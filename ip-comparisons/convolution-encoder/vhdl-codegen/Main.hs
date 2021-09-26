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

module Main (
    main
  ) where

import Prelude

import Data.Bit ( Bit )
import Control.Category ( (>>>) )
import Control.Monad ( forM_, replicateM )
import Data.Fixed.Q ( Unsigned )
import Data.String ( fromString )
import GHC.TypeLits
import System.IO ( hPutStrLn, withFile, IOMode(WriteMode) )
import Test.QuickCheck
import Text.PrettyPrint.Mainland ( prettyCompact )
import Text.PrettyPrint.Mainland.Class ( Pretty(ppr) )

import Language.VHDL.Codegen.Monad ( evalCg, withDesignUnit, writeDesignUnit )
import Language.VHDL.Codegen.Pipeline.VHDL ( flattenP, serialize )
import Language.VHDL.Codegen.Pipeline.Shallow ( reifyP )
import qualified Language.VHDL.Codegen.Pipeline.VHDL.Testbench as TB
import Language.VHDL.Codegen.SLV
import Language.VHDL.Codegen.Vec ( Vec )
import qualified Language.VHDL.Codegen.Vec as Vec

import Encoder ( encodeP )

encode :: forall r k. (KnownNat r, KnownNat k) => Vec r (Unsigned (k+1)) -> [Bit] -> [Bit]
encode gs bs = toBits $ reifyP (encodeP gs) bs

toBits :: KnownNat n => [SLV n] -> [Bit]
toBits []     = []
toBits (v:vs) = Vec.toList v ++ toBits vs

main :: IO ()
main = do
    (unit, p) <- evalCg $ withDesignUnit $ do
                 -- Create pipeline that will serialize bits in std_logic_vector
                 serializep <- serialize
                 -- Build encoding pipeline and flatten it to VHDL.
                 flattenP $ encodeP gs >>> serializep
    -- Write encoder VHDL
    writeDesignUnit "rtl/encoder.vhd" unit
    -- Write tstbench VHDL
    TB.writeTestBench tb_config "tb_encoder.vhd" p
    -- Generate random test vector
    in_bits :: [Bit] <- generate $ replicateM 1000 arbitrary
    writeBits "data/in.csv" in_bits
    let out_bits = encode gs in_bits
    writeBits "data/out.csv" out_bits
  where
    -- Rate 1/2 encoder with constraint length 7 and polynomial (121,91)
    gs :: Vec.Vec 2 (Unsigned 7)
    Just gs = Vec.fromList [121,91]
    --gs :: Vec.Vec 2 (Unsigned 3)
    --Just gs = Vec.fromList [7,6]

    writeBits :: FilePath -> [Bit] -> IO ()
    writeBits path bs =
      withFile path WriteMode $ \h ->
        forM_ bs $ \b -> hPutStrLn h $ prettyCompact $ ppr b

    tb_config = TB.defaultTestBenchConfig { TB.tb_entity   = "tb_encoder"
                                          , TB.tb_watchdog = Just 50000
                                          , TB.tb_compare  = True
                                          }
