{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import Data.Bit ( Bit )
import Data.Fixed.Q ( Unsigned )
import GHC.TypeLits ( KnownNat, type (+) )
import Test.Hspec ( hspec, describe, it, Spec )
import Test.HUnit ( (@?=) )

import Language.VHDL.Codegen.Pipeline.Shallow ( reifyP )
import Language.VHDL.Codegen.SLV ( SLV )
import Language.VHDL.Codegen.Vec ( Vec )
import qualified Language.VHDL.Codegen.Vec as Vec

import Encoder

encode :: forall r k. (KnownNat r, KnownNat k) => Vec r (Unsigned (k+1)) -> [Bit] -> [Bit]
encode gs bs = toBits $ reifyP (encodeP gs) bs

toBits :: KnownNat n => [SLV n] -> [Bit]
toBits []     = []
toBits (v:vs) = Vec.toList v ++ toBits vs

main :: IO ()
main = hspec $ do
    mit

mit :: Spec
mit = do
    describe "Encoder" $ do
      it "(7,6)" $
        let message = [1, 0, 1, 1, 0, 0, 0]
            encoded = [1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0]
            gs :: Vec.Vec 2 (Unsigned 3)
            Just gs = Vec.fromList [7,6]
        in
          encode gs message @?= encoded
