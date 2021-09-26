{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

module Divider where

import Data.Bits
import Data.Proxy (Proxy(..))
import Data.Fixed.Q
import GHC.TypeLits

underflow :: FiniteBits a => a -> Bool
underflow bits = testBit bits (finiteBitSize bits - 1)

-- | Restoring division.
class Restoring n d q r where
    restoring :: (n, d) -> (q, r)

-- | Non-restoring division.
class Nonrestoring n d q r where
    nonrestoring :: (n, d) -> (q, r)

instance (KnownNat m, KnownNat f, m' ~ (1+m+m), KnownNat m') => Restoring (UQ m f) (UQ m f) (UQ m f) (UQ m' f) where
    restoring (x0, d0) = post (foldl step (pre (x0, d0)) [0..n-1])
        where
          n = finiteBitSize x0
          m = intBitSize x0

          pre :: (UQ m f, UQ m f) -> (UQ m f, UQ m' f, UQ m' f)
          pre (x0, d0) = (0, fixedCast x0, fixedCast d0)

          post :: (UQ m f, UQ m' f, UQ m' f) -> (UQ m f, UQ m' f)
          post (q, r, _) = (q, r)

          step :: (UQ m f, UQ m' f, UQ m' f) -> Int -> (UQ m f, UQ m' f, UQ m' f)
          step (q, r, d) i =
              if underflow r'
                then (q,            r' + d `shiftL` m, d)
                else (q `setBit` b, r',                d)
            where
              r' = r `shiftL` 1 - d `shiftL` m
              b = n - i - 1

instance (KnownNat m, KnownNat f, m' ~ (1+m+m), KnownNat m') => Nonrestoring (UQ m f) (UQ m f) (UQ m f) (UQ m' f) where
    nonrestoring (x0, d0) = post (foldl step (pre (x0, d0)) [0..n-1])
        where
          n = finiteBitSize x0
          m = intBitSize x0

          pre :: (UQ m f, UQ m f) -> (UQ m f, UQ m' f, UQ m' f)
          pre (x0, d0) = (0, fixedCast x0, fixedCast d0)

          post :: (UQ m f, UQ m' f, UQ m' f) -> (UQ m f, UQ m' f)
          post (q, r, d) =
              if underflow r
                then (q' - ulp, r + d `shiftL` m)
                else (q', r)
            where
              q' = q - complement q

          step :: (UQ m f, UQ m' f, UQ m' f) -> Int -> (UQ m f, UQ m' f, UQ m' f)
          step (q, r, d) i =
              if underflow r
                then (q,            r `shiftL` 1 + d `shiftL` m, d)
                else (q `setBit` b, r `shiftL` 1 - d `shiftL` m, d)
            where
              b = n - i - 1

instance (KnownNat m, KnownNat f, m' ~ (1+m+m), KnownNat m') => Nonrestoring (Q m f) (Q m f) (Q m f) (Q m' f) where
    nonrestoring (x0, d0) = post (foldl step (pre (x0, d0)) [0..n-2])
        where
          n = finiteBitSize x0
          m = intBitSize x0

          pre :: (Q m f, Q m f) -> (Q m f, Q m' f, Int, Bool, Q m' f)
          pre (x0, d0) = (0, fixedCast x0, signBit x0, False, fixedCast d0)

          post :: (Q m f, Q m' f, Int, Bool, Q m' f) -> (Q m f, Q m' f)
          post (q, r, x_sign, r_zero, d) =
              if r /= 0 && ((signBit r /= x_sign) || r_zero)
                then if signBit r /= signBit d
                       then (q' - ulp, r + d `shiftL` m)
                       else (q' + ulp, r - d `shiftL` m)
                else (q', r)
            where
              q' = fromBSD q

              -- See Koren Section 3.3.1
              fromBSD :: Q m f -> Q m f
              fromBSD x = ((x `shiftL` 1) `complementBit` (n-1)) `setBit` 0

          step :: (Q m f, Q m' f, Int, Bool, Q m' f) -> Int -> (Q m f, Q m' f, Int, Bool, Q m' f)
          step (q, r, x_sign, r_zero, d) i =
              if signBit r /= signBit d
                then (q,            r `shiftL` 1 + d `shiftL` m, x_sign, r_zero || r == 0, d)
                else (q `setBit` b, r `shiftL` 1 - d `shiftL` m, x_sign, r_zero || r == 0, d)
            where
              b = n - i - 2
