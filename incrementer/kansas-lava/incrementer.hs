{-# LANGUAGE PackageImports #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE GADTs #-}

import "kansas-lava" Language.KansasLava hiding (Ready)
import Data.Sized.Matrix as M
import Data.Sized.Unsigned
import Data.Sized.Sampled as SMP
import Data.Sized.Signed
import Data.Ix
import Data.Bits
import Control.Applicative
import qualified Language.KansasLava.Stream as S
import Language.KansasLava.Signal
import Data.Proxy


type Ready = Bool
type Valid = Bool
type ValidReady a = (a, Valid, Ready)

data Pipeline a b = forall clk . (Clock clk) => Pipeline ((Signal clk (ValidReady a)) -> (Signal clk (ValidReady b)))


------- Iterators using RTL DSL:


-- Serial iterator with a function, using RTL DSL:
siter :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a , Rep xs, Num xs, Size xs)
      => (sig a -> xs -> sig a)
      -> sig Bool
      -> sig (ValidReady a)
      -> sig (ValidReady a)
siter f rst in_pipe = runRTL $ do
    let (in_x,in_valid,out_ready) = unpack in_pipe
        n = fromIntegral (size (undefined :: xs)-1) :: xs
    cnt <- newReg (0 :: xs)
    nr <- newReg (n :: xs )
    x <- newReg (0 :: a)
    CASE [ IF rst $ do
              cnt := 0
         , OTHERWISE $ do
            WHEN (reg cnt .==. 0 .&&. in_valid ) $ x := f in_x 0
            CASE [IF ((reg cnt .>. 0 .&&. reg cnt .<. reg nr) .||. (reg cnt .==. 0 .&&. in_valid )) $ do
                    cnt := reg cnt + 1
                    x := f (reg x) n
                 , OTHERWISE $ do
                    WHEN (reg cnt .==. reg nr .&&. out_ready) $ cnt := 0
                 ]
         ]
    let in_ready' = mux (reg cnt .==.0) (low,high)
        out_valid' = mux (reg cnt .==. reg nr) (low,high)

        in_x_E = packEnabled out_valid' (reg x) :: Signal clk (Enabled a)
        patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
        (in_ready, data_res_E) = execP patch (in_x_E, in_ready')
        (out_valid,out_x) = unpackEnabled data_res_E
    return $ pack ( out_x, out_valid, in_ready)


-- Parallel iter with a function, using RTL DSL, the version that does not squeeze bubbles:
piter :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a, Rep xs, Num xs, Size xs)
      => (sig a -> xs -> sig a)
      -> sig Bool
      -> sig (ValidReady a)
      -> sig (ValidReady a)
piter f rst in_pipe = runRTL $ do
    let (in_x,in_valid,out_ready) = unpack in_pipe
        n = size (undefined :: xs) - 1
    valid <- newReg (matrix (replicate (n+1) False) :: Matrix xs Bool)
    r <- newReg (matrix (replicate (n+1) 0) :: Matrix xs a)
    let r' = reg r
        valid' = reg valid
    CASE [ IF rst $ do
              valid := packMatrix $ matrix (replicate (n+1) low)
         , OTHERWISE $ do
              WHEN (out_ready) $ do
                r := packMatrix $ forEach (unpackMatrix r')
                            (\i x -> if i>0 then f (unpackMatrix r' ! (i-1) ) i else f in_x 0)
                valid := packMatrix $ forEach (unpackMatrix valid')
                            (\i v -> if i>0 then (unpackMatrix valid' ! (i-1)) else in_valid)
         ]
    let x' = (unpackMatrix r') ! (fromIntegral (n - 1))
        valid_d' = (unpackMatrix (reg valid)) ! (fromIntegral (n - 1))
        in_x_E = packEnabled valid_d' x' :: Signal clk (Enabled a)
        patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
        (in_ready, data_res_E) = execP patch (in_x_E, out_ready)
        (out_valid,out_x) = unpackEnabled data_res_E
    return $ pack ( out_x, out_valid, in_ready)


-- Parallel iter with a function, using RTL DSL, the version that squeezes bubbles:
piter' :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a, Rep xs, Num xs, Size xs)
       => (sig a -> xs -> sig a)
       -> sig Bool
       -> sig (ValidReady a)
       -> sig (ValidReady a)
piter' f rst in_pipe = pack ( out_x, out_valid, in_ready)

   where
    (in_x,in_valid,out_ready) = unpack in_pipe
    n = size (undefined :: xs) - 1
    (x',valid',ready') = runRTL $ do

      valid <- newReg (matrix (replicate (n+1) False) :: Matrix xs Bool)
      ready <- newReg (matrix (replicate (n+1) False) :: Matrix xs Bool)
      d <- newReg (matrix (replicate (n+1) 0) :: Matrix xs a)

      CASE [ IF rst $ do
                valid := packMatrix $ matrix (replicate (n+1) low)
                ready := packMatrix $ matrix (replicate (n+1) high)
           , OTHERWISE $ do
                d := packMatrix $ forEach (unpackMatrix (var d))
                            (\i x -> if i > 0 then
                                          mux ((unpackMatrix (var ready)) ! i) (delay x, f (unpackMatrix (reg d) ! (i-1) ) i  )
                                     else mux ((unpackMatrix (var ready)) ! 0) (delay x, f in_x 0))
                valid := packMatrix $ forEach (unpackMatrix (var valid))
                            (\i v -> if i > 0 then
                                          mux ((unpackMatrix (var ready)) ! i) (delay v, unpackMatrix (reg valid) ! (i-1))
                                     else mux ((unpackMatrix (var ready)) ! 0) (delay v, in_valid))
           ]
      ready := packMatrix $ forEach (unpackMatrix (var ready))
                    (\i e -> if i < fromIntegral n - 1
                             then (((unpackMatrix (var ready)) ! (i+1)) `or2` (bitNot (unpackMatrix (reg valid) ! i)))
                             else (out_ready `or2` (bitNot (unpackMatrix (reg valid) ! (fromIntegral n - 1)))))
      return (reg d, reg valid, var ready)

    x_d' = (unpackMatrix x') ! (fromIntegral (n - 1))
    valid_d' = (unpackMatrix valid') ! (fromIntegral (n - 1))
    ready_d' = (unpackMatrix ready') ! 0

    in_x_E = packEnabled valid_d' x_d' :: Signal clk (Enabled a)
    patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
    (in_ready, data_res_E) = execP patch (in_x_E, ready_d')
    (out_valid,out_x) = unpackEnabled data_res_E


------- "Straightforward" implementations:

-- Serial iter with a function
siterNaive :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a , Rep xs, Num xs, Size xs)
           => (sig a -> xs -> sig a)
           -> sig Bool
           -> sig (ValidReady a)
           -> sig (ValidReady a)
siterNaive f rst in_pipe = pack ( delay out_x, delay out_valid, delay in_ready)
  where
    (in_x,in_valid,out_ready) = unpack in_pipe
    n = fromIntegral (size (undefined :: xs)-1) :: xs
    x = register 0 tmp
    tmp = mux ( bitNot rst .&&. i .==. 0 .&&. in_valid ) ( x', f in_x 0)
    i = register (0 :: xs) i'
    (i',x') = unpack $ mux (bitNot rst  .&&. ((i .==. 0 .&&. in_valid ) .||. (i .>. 0 .&&. i .<. pureS n)))
                  (pack (i_tmp, x) , pack (i + 1, f x n  ) :: Signal clk (xs,a))
    i_tmp = mux (i .==. pureS n .&&. out_ready) (i, 0)
    out_valid' = mux (i .==. pureS n) (low,high)
    in_ready' = mux (i .==. 0) (low,high)
    out_x' = x'

    in_x_E = packEnabled out_valid' out_x' :: Signal clk (Enabled a)
    patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
              :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
    (in_ready, data_res_E) = execP patch (in_x_E, in_ready')
    (out_valid,out_x) = unpackEnabled data_res_E


-- Parallel iter with a function, the version that does not squeeze bubbles:
piterNaive :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a, Show a, Rep xs, Num xs, Size xs)
      => (sig a -> xs -> sig a)
      -> sig Bool
      -> sig (ValidReady a)
      -> sig (ValidReady a)
piterNaive f rst in_pipe = pack ( out_x, out_valid, in_ready)
  where
    (in_x,in_valid,out_ready) = unpack in_pipe
    n = size (undefined :: xs) - 1
    x_mat = matrix (replicate (n+1) 0) :: Matrix xs (Signal clk a)
    x_mat' = forEach x_mat (\i x -> mux (bitNot rst .&&. delay out_ready)
          (delay $ x_mat' ! i, if i>0 then f (delay $ x_mat' ! (i-1)) i else f (delay in_x) 0 ))
    x' = x_mat' ! (fromIntegral (n - 1))

    v_mat = matrix (replicate (n+1) low) :: Matrix xs (Signal clk Bool)
    v_mat' = forEach v_mat (\i e -> mux (bitNot rst .&&. delay out_ready)
          (delay $ v_mat' ! i,if i>0 then (delay $ v_mat' ! (i-1)) else (delay in_valid)))
    valid' = v_mat' ! (fromIntegral (n - 1))
    valid_d' = mux rst (valid',low)


    in_x_E = packEnabled valid_d' x' :: Signal clk (Enabled a)
    patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
    (in_ready, data_res_E) = execP patch (in_x_E, out_ready)
    (out_valid,out_x) = unpackEnabled data_res_E

piterNaive' :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a, Show a, Rep xs, Num xs, Size xs)
      => (sig a -> xs -> sig a)
      -> sig Bool
      -> sig (ValidReady a)
      -> sig (ValidReady a)
piterNaive' f rst in_pipe = pack ( out_x, out_valid, in_ready)
  where
    (in_x,in_valid,out_ready) = unpack in_pipe
    n = size (undefined :: xs) - 1
    x_mat = matrix (replicate (n+1) 0) :: Matrix xs (Signal clk a)
    x_mat' = forEach x_mat (\i x -> mux (bitNot rst .&&. delay (r_mat ! i))
              (delay $ x_mat' ! i, if i>0 then f (delay $ x_mat' ! (i-1)) i else f (delay in_x) 0 ))
    x' = x_mat' ! (fromIntegral (n - 1))

    v_mat = matrix (replicate (n+1) low) :: Matrix xs (Signal clk Bool)
    v_mat' = forEach v_mat (\i e -> mux (bitNot rst .&&. delay (r_mat ! i))
              (delay $ v_mat' ! i,if i>0 then (delay $ v_mat' ! (i-1)) else (delay in_valid)))
    valid_rst = [ mux rst (v_mat' ! (fromIntegral i) , low) | i <- [0..n]]

    ready_d = [ (ready_d !! (i+1)) `or2` (bitNot (valid_rst !! i )) | i <- [0..(n-1)]]
               ++ [out_ready `or2` (bitNot (valid_rst !! n))]
    ready_d' = [ mux rst (ready_d !! i, high) | i <- [0..n]]
    r_mat = matrix ready_d'

    in_x_E = packEnabled (valid_rst !! (n-1)) x' :: Signal clk (Enabled a)
    patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
    (in_ready, data_res_E) = execP patch (in_x_E, r_mat ! 0)
    (out_valid,out_x) = unpackEnabled data_res_E


-- turn it into a fabric and specify the input and output ports

data Imp = SiterNaive
         | PiterNaive
         | Piter'Naive
         | SiterRTL
         | PiterRTL
         | Piter'RTL
        deriving (Show, Eq)

dut :: (Num a, Rep a, Size (W a), Show a, Size xs, Rep xs, Num xs)
    => Imp
    -> (Signal CLK a -> xs -> Signal CLK a)
    -> Fabric ()
dut imp f = do
   in_x <- inStdLogicVector "in_x"
   rst <- inStdLogic "reset" -- if named "rst" in source code it won't assign the signal to the port!
   in_valid <- inStdLogic "in_valid"
   out_ready <- inStdLogic "out_ready"
   let res = case imp of
        SiterNaive   -> siterNaive f rst (pack (in_x,in_valid,out_ready))
        PiterNaive   -> piterNaive f rst (pack (in_x,in_valid,out_ready))
        Piter'Naive  -> piterNaive' f rst (pack (in_x,in_valid,out_ready))
        SiterRTL     -> siter f rst (pack (in_x,in_valid,out_ready))
        PiterRTL     -> piter f rst (pack (in_x,in_valid,out_ready))
        Piter'RTL    -> piter' f rst (pack (in_x,in_valid,out_ready))
   let (out_x, out_valid, in_ready) = unpack res
   outStdLogicVector "out_x" out_x
   outStdLogic "out_valid" out_valid
   outStdLogic "in_ready" in_ready

type FPType = Sampled U7 X16 -- uq8.8

incr :: forall clk . (Clock clk) -- unsigned 16 version
     => Signal clk U16
     -> X17
     -> Signal clk U16
incr x i = x + 1

incX :: forall clk . (Clock clk) -- uq8.8 version
      => Signal clk FPType
      -> X17
      -> Signal clk FPType
incX x i = x + 1

---- Functions to use with funMap:
-- unsigned 16 version
incr' :: (U16, X17)
     -> Maybe U16
incr' (x, i) = Just (x + 1)

-- uq8.8 version
incX' :: (FPType, X17)
      -> Maybe FPType
incX' (x, i) = Just (x + 1)


-- generate VHDL
main = do
   kleg_siterNaive_unsigned <- reifyFabric (dut SiterNaive incr)
   kleg_piterNaive_unsigned <- reifyFabric (dut PiterNaive incr)
   kleg_piterNaive'_unsigned <- reifyFabric (dut Piter'Naive incr)
   kleg_siterRTL_unsigned <- reifyFabric (dut SiterRTL incr)
   kleg_piterRTL_unsigned <- reifyFabric (dut PiterRTL incr)
   kleg_piterRTL'_unsigned <- reifyFabric (dut Piter'RTL incr)
   kleg_siterNaive_fixed <- reifyFabric (dut SiterNaive incX)
   kleg_piterNaive_fixed <- reifyFabric (dut PiterNaive incX)
   kleg_piterNaive'_fixed <- reifyFabric (dut Piter'Naive incX)
   kleg_siterRTL_fixed <- reifyFabric (dut SiterRTL incX)
   kleg_piterRTL_fixed <- reifyFabric (dut PiterRTL incX)
   kleg_piterRTL'_fixed <- reifyFabric (dut Piter'RTL incX)
   writeVhdlCircuit "incrementer" "vhdl/serial/incrementer.vhd" kleg_siterNaive_unsigned
   writeVhdlCircuit "incrementer" "vhdl/parallel/incrementer.vhd" kleg_piterNaive_unsigned
   writeVhdlCircuit "incrementer" "vhdl/parallel-bubble-squeeze/incrementer.vhd" kleg_piterNaive'_unsigned
   writeVhdlCircuit "incrementer" "vhdl/serial/incrementer_rtl_dsl.vhd" kleg_siterRTL_unsigned
   writeVhdlCircuit "incrementer" "vhdl/parallel/incrementer_rtl_dsl.vhd" kleg_piterRTL_unsigned
   writeVhdlCircuit "incrementer" "vhdl/parallel-bubble-squeeze/incrementer_rtl_dsl.vhd" kleg_piterRTL'_unsigned
   writeVhdlCircuit "incrementer" "vhdl/serial/incrementer_fixed.vhd" kleg_siterNaive_fixed
   writeVhdlCircuit "incrementer" "vhdl/parallel/incrementer_fixed.vhd" kleg_piterNaive_fixed
   writeVhdlCircuit "incrementer" "vhdl/parallel-bubble-squeeze/incrementer_fixed.vhd" kleg_piterNaive'_fixed
   writeVhdlCircuit "incrementer" "vhdl/serial/incrementer_rtl_dsl_fixed.vhd" kleg_siterRTL_fixed
   writeVhdlCircuit "incrementer" "vhdl/parallel/incrementer_rtl_dsl_fixed.vhd" kleg_piterRTL_fixed
   writeVhdlCircuit "incrementer" "vhdl/parallel-bubble-squeeze/incrementer_rtl_dsl_fixed.vhd" kleg_piterRTL'_fixed
   writeVhdlPrelude "vhdl/Lava.vhd"
