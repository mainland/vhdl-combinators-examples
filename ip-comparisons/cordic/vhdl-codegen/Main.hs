{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RebindableSyntax #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

module Main (
    main
  ) where

import Prelude hiding ( id )

import Control.Category ( (>>>), id )
import Control.Monad ( forM_, replicateM )
import Control.Monad.IO.Class ( liftIO )
import Data.Bits ( FiniteBits(finiteBitSize), Bits(shift) )
import Data.Foldable ( toList )
import Data.Fixed.Q
    ( FixedBits(intBitSize), Q(Q), UQ(UQ) )
import Data.List ( zip4 )
import Data.Loc ( noLoc )
import Data.Maybe ( isJust )
import Data.Proxy ( Proxy(..) )
import Data.Sequence ( Seq )
import Data.String ( fromString )
import GHC.TypeLits ( KnownNat, type (-), type (+), type (<=), natVal )
import Language.VHDL.Quote ( vexp )
import qualified Language.VHDL.Syntax as V
import Language.VHDL.Quote
import System.Environment ( getArgs )
import System.IO ( IOMode(WriteMode), hPutStrLn, withFile )
import Test.QuickCheck ( Arbitrary(..), Gen, generate, elements)

import Text.PrettyPrint.Mainland
    ( comma, punctuate, folddoc, prettyCompact, hPutDoc, Doc )
import Text.PrettyPrint.Mainland.Class ( Pretty(ppr) )

import Language.VHDL.Codegen.Lift
import Language.VHDL.Codegen.Monad
import Language.VHDL.Codegen.Pipeline
import Language.VHDL.Codegen.Pipeline.Testbench
import Language.VHDL.Codegen.Testbench
import Language.VHDL.Codegen.VExp
import Opt

type B = 32
type S1 = 1
type S2 = 2
type N = Q S1 (B-S1-1)
type M = Q S2 (B-S2-1)

main :: IO ()
main = do
    (conf, args) <- getArgs >>= compilerOpts
    when (not (help conf)) $ do
      (unit, p :: Pipeline (VExp N, VExp N, VExp M) (VExp N, VExp N, VExp M)) <- evalCg $ cordicGen conf
      case output conf of
        Nothing   -> return ()
        Just path -> liftIO $ withFile path WriteMode $ \h -> hPutDoc h (ppr (toList unit))
      case tb_output conf of
        Nothing   -> return ()
        Just path -> do unit <- evalCg $ vunitTestBench
                                         defaultTestBenchConfig { tb_watchdog = Nothing
                                                                , tb_entity   = "tb_cordic"
                                                                , tb_check_equal_diff = 0.0000001
                                                                }
                                         p
                        withFile path WriteMode $ \h -> hPutDoc h (ppr unit)
      when (isJust (tv_in_output conf) || isJust (tv_out_output conf)) $
        genTestVectors (Proxy :: Proxy (N,M)) conf

csvsep :: [Doc] -> Doc
csvsep = folddoc (<>) . punctuate comma

data XYZ a b = XYZ a a b
  deriving (Eq, Ord, Show)


instance (Pretty a, Pretty b) => Pretty (XYZ a b) where
    ppr (XYZ x y z) = csvsep [ppr x, ppr y, ppr z]

-- Generating tests for Rotating mode:
-- x <- scaling factor at infinity, y <- 0, z <- random angles between (-pi/4,pi/4)
instance (KnownNat m, KnownNat f, 1 <= f, KnownNat m', KnownNat f', 1 <= f') => Arbitrary (XYZ (Q m f) (Q m' f')) where
    arbitrary = do
      x <- pure 0.6072529350088814 :: Gen (Q m f)
      y <- pure 0 :: Gen (Q m f)
      z <- nonZeroRange (pi * 0.25)
      return $ XYZ x y z
      where
        nonZeroRange :: (Q m' f') -> Gen (Q m' f')
        nonZeroRange b = do
          x <- elements ([-b,-b+0.1..b])
          if x == 0 then nonZeroRange b else pure x

        sf = foldl (*) 1 [ scale i | i <- [0..99]]
        scale i = 1 / sqrt ( 1 + 2^^(-2*i))

-- Rotating mode test vectors:
genTestVectors :: forall m m' f f' . (KnownNat m, KnownNat f, KnownNat (m+f), 1 <= f, KnownNat m', KnownNat f', KnownNat (m'+f'), 1 <= f')
               => Proxy ((Q m f), (Q m' f'))
               -> Config
               -> IO ()
genTestVectors _ conf = do
    ps :: [XYZ (Q m f) (Q m' f')] <- generate (replicateM (tv_len conf) arbitrary)
    let zs = [(cos(z),sin(z),z*0) | XYZ x y z <- ps]
    case tv_in_output conf of
      Just path -> withFile path WriteMode $ \h ->
                   forM_ ps $ \p -> hPutStrLn h $ prettyCompact $ ppr p
      Nothing -> return ()
    case tv_out_output conf of
      Just path -> withFile path WriteMode $ \h ->
                   forM_ zs $ \(x,y, z) -> hPutStrLn h $ prettyCompact $ csvsep [ppr x, ppr y, ppr z]
      Nothing -> return ()
  where
    m, f, n :: Integer
    m = natVal (Proxy :: Proxy m)
    f = natVal (Proxy :: Proxy f)
    n = f + m


cordicGen :: forall i i' f f' m . (KnownNat i, KnownNat f, KnownNat i', KnownNat f', MonadCg m, 1 <= f')
             => Config
             -> m (Seq V.DesignUnit, Pipeline (VExp (Q i f), VExp (Q i f), VExp (Q i' f')) (VExp (Q i f), VExp (Q i f), VExp (Q i' f')))
cordicGen conf = withDesignUnit $ do
    p <- iters
    wrapP "main" p
  where

    tau = toType (Proxy :: Proxy (Q i' f')) noLoc :: V.Subtype

    cnts = [atan (2 ^^ (-i)) | i <- [0..]]

    iters = case variant conf of
             Serial -> siter "cordic"
                        id
                        stepS
                        id
                        ["x", "y", "z"]
                        ["x", "y", "z"]
                        (iterations conf)
             Parallel -> piter "cordic"
                          id
                          stepP
                          id
                          ["x", "y", "z"]
                          ["x", "y", "z"]
                          (iterations conf)


    stepS :: (KnownNat i, KnownNat i', KnownNat f, KnownNat f', MonadCg m)
        => (VExp (Q i f), VExp (Q i f), VExp (Q i' f'))
        -> VExp Int
        -> m (VExp (Q i f), VExp (Q i f), VExp (Q i' f'))
    stepS (x,y,z) i = do
        append [vdecl|type $id:consts_t is array (0 to $(iterations conf-1)) of $ty:tau;|]
        append [vdecl| variable $id:consts : typename $id:consts_t := ($exps:(take (iterations conf) (map (fromRational . toRational) cnts) :: [Q i' f']));|]
        return res

      where
        res = case mode conf of
            Rotating  -> if z .>=. 0 then (x - y `sra` i, y + x `sra` i, z - alpha)
                                     else (x + y `sra` i, y - x `sra` i, z + alpha)
            Vectoring -> if y .>. 0  then (x + y `sra` i, y - x `sra` i, z + alpha)
                                     else (x - y `sra` i, y + x `sra` i, z - alpha)
        alpha = VExp ([vexp|$id:consts($i)|])

    stepP :: (KnownNat i, KnownNat i', KnownNat f, KnownNat f', MonadCg m)
        => (VExp (Q i f), VExp (Q i f), VExp (Q i' f'))
        -> VExp Int
        -> m (VExp (Q i f), VExp (Q i f), VExp (Q i' f'))
    stepP (x,y,z) i = do
        addTypeContext [vtype|real|]
        return res

      where
        res = case mode conf of
            Rotating  -> if z .>=. 0 then (x - y `sra` i, y + x `sra` i, z - alpha)
                                     else (x + y `sra` i, y - x `sra` i, z + alpha)
            Vectoring -> if y .>. 0  then (x + y `sra` i, y - x `sra` i, z + alpha)
                                     else (x - y `sra` i, y + x `sra` i, z - alpha)

        alpha = VExp ([vexp|to_sfixed(arctan(2.0**(-$i)),$i',-$f')|])
        i', f' :: Integer
        i' = natVal (Proxy :: Proxy i')
        f' = natVal (Proxy :: Proxy f')


consts, consts_t :: V.Id
consts = "consts"
consts_t = "consts_t"
