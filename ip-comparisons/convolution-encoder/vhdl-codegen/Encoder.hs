{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Encoder (
    encodeP
  ) where

import Control.Monad ( msum, MonadPlus(mzero) )
import Data.Bit ( Bit )
import Data.Bits
    ( Bits(testBit, zeroBits), FiniteBits(finiteBitSize) )
import Data.Fixed.Q ( Unsigned )
import GHC.TypeLits ( KnownNat, type (+) )

import Language.VHDL.Codegen.Lift ( LiftBits(xor') )
import Language.VHDL.Codegen.Pipeline ( Pipeline(moore) )
import Language.VHDL.Codegen.SLV ( SLV )
import Language.VHDL.Codegen.VExp ( VExp(VConst), Lift(lift) )
import Language.VHDL.Codegen.Vec ( Vec )
import qualified Language.VHDL.Codegen.Vec as Vec
import qualified Language.VHDL.Codegen.VExp.Vec as V

-- | Convolutional encoder pipeline
encodeP :: forall r k p. (KnownNat r, KnownNat k, Pipeline p)
        => Vec r (Unsigned (k+1))
        -> p (VExp Bit) (VExp (SLV r))
encodeP gs = moore step out (VConst zeroBits)
  where
    step :: VExp (SLV (k+1)) -> VExp Bit -> VExp (SLV (k+1))
    step s i = V.tail s `V.snoc` i

    out :: VExp (SLV (k+1)) -> VExp (SLV r)
    out s = V.liftVec $ Vec.map (\g -> parity g s) gs

-- | Compute parity of bits using generator polynomial @g@.
parity :: forall k . KnownNat k
       => Unsigned (k+1)   -- ^ Generator polynomial
       -> VExp (SLV (k+1)) -- ^ Current state
       -> VExp Bit
parity g state = xorreduce $ msum [extract i | i <- [n-1,n-2..0]]
  where
    n :: Int
    n = finiteBitSize (undefined :: Unsigned (k+1))

    -- Reduce list of bits using xor
    xorreduce :: [VExp Bit] -> VExp Bit
    xorreduce = foldr1 xor'

    -- Extract bit i of state if corresponding bit is set in g
    extract :: MonadPlus m => Int -> m (VExp Bit)
    extract i = if testBit g i then pure (V.index state (lift i)) else mzero
