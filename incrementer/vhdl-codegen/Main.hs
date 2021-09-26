{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RebindableSyntax #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Main (
    main
  ) where

import Prelude

import Data.Fixed.Q ( UQ )
import Data.Proxy ( Proxy )
import Data.Sequence ( Seq )
import Data.String ( fromString )
import qualified Language.VHDL.Syntax as V
import Text.PrettyPrint.Mainland
import Text.PrettyPrint.Mainland.Class

import Language.VHDL.Codegen.VExp ( VExp )
import Language.VHDL.Codegen.Pipeline
import Language.VHDL.Codegen.Monad
import Language.VHDL.Quote (ToType)

import Opt

main :: IO ()
main = defaultMainWith config0 $ \config ->
       case numtype config of
         UQ16  -> do (unit, p) <- mkIncrementer @(UQ 16 0) config
                     return (unit, SomePipeline p)
         UQ8_8 -> do (unit, p) <- mkIncrementer @(UQ 8 8) config
                     return (unit, SomePipeline p)
  where
    config0 = defaultConfig { tb_watchdog = Just 5000
                            , tb_entity = "tb_incrementer"
                            }

mkIncrementer :: forall a m . (ToType (Proxy a), Num (VExp a), MonadCg m)
              => Config
              -> m (Seq V.DesignUnit, Pipeline (VExp a) (VExp a))
mkIncrementer conf = withDesignUnit $ do
    p <- iter "incrementer"
              id
              (\x _ -> return $ x + 1)
              id
              ["x"]
              ["x"]
              16
    wrapP "main" p
  where
    iter = case variant conf of
             Serial -> siter
             Parallel -> piter
             ParallelBubbles -> piter'
