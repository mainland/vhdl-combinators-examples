{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}

import Data.Fixed.Q
import Data.Proxy (Proxy(..))
import GHC.TypeLits
import Test.Hspec

import Test.QuickCheck
import Divider

prop_divide_uq :: forall m f m' . (KnownNat m, KnownNat f, KnownNat (m+f), m' ~ (1+m+m), KnownNat m', KnownNat (m'+f))
               => ((UQ m f, UQ m f) -> (UQ m f, UQ m' f))
               -> UQ m f
               -> UQ m f
               -> Property
prop_divide_uq alg x d =
    toRational x < 2^m * toRational d ==>
    counterexample (show (q, r)) $
    toRational q*toRational d + toRational r * 2^^(-n) === toRational x
    .&&.
    q === UQ q'
    .&&.
    r === UQ (r' * 2^m)
  where
    q :: UQ m f
    r :: UQ m' f
    (q, r) = alg (x, d)

    q', r' :: Integer
    (q', r') = quotRem (unUQ x * 2^f) (unUQ d)

    m, f :: Integer
    m = natVal (Proxy :: Proxy m)
    f = natVal (Proxy :: Proxy f)
    n = f + m

prop_divide_q :: forall m f m' . (KnownNat m, KnownNat f, KnownNat (m+f), m' ~ (1+m+m), KnownNat m', KnownNat (m'+f))
              => ((Q m f, Q m f) -> (Q m f, Q m' f))
              -> Q m f
              -> Q m f
              -> Property
prop_divide_q alg x d =
    d /= 0 && (abs (toRational x) < 2^m * abs (toRational d)) ==>
    counterexample (show (q, r)) $
    (toRational q*toRational d + toRational r * 2^^(-n) === toRational x)
    .&&.
    q === Q q'
    .&&.
    r === Q (r' * 2^m)
  where
    q :: Q m f
    r :: Q m' f
    (q, r) = alg (x, d)

    q', r' :: Integer
    (q', r') = quotRem (unQ x * 2^f) (unQ d)

    m, f :: Integer
    m = fromIntegral $ natVal (Proxy :: Proxy m)
    f = fromIntegral $ natVal (Proxy :: Proxy f)
    n = f + m

main :: IO ()
main = hspec $ do
    restoringSpec
    nonrestoringSpec

restoringSpec :: Spec
restoringSpec = do
    describe "Restoring division (unsigned)" $ do
      it "UQ 8 0" $
        property (prop_divide_uq restoring :: UQ 8 0 -> UQ 8 0 -> Property)
      it "UQ 0 8" $
        property (prop_divide_uq restoring :: UQ 0 8 -> UQ 0 8 -> Property)
      it "UQ 0 2" $
        property (prop_divide_uq restoring :: UQ 0 2 -> UQ 0 2 -> Property)
      it "UQ 8 8" $
        property (prop_divide_uq restoring :: UQ 8 8 -> UQ 8 8 -> Property)
      it "UQ 8 16" $
        property (prop_divide_uq restoring :: UQ 8 16 -> UQ 8 16 -> Property)
      it "UQ 16 8" $
        property (prop_divide_uq restoring :: UQ 16 8 -> UQ 16 8 -> Property)

nonrestoringSpec :: Spec
nonrestoringSpec = do
    describe "Non-restoring division (unsigned)" $ do
      it "UQ 8 0" $
        property (prop_divide_uq nonrestoring :: UQ 8 0 -> UQ 8 0 -> Property)
      it "UQ 0 8" $
        property (prop_divide_uq nonrestoring :: UQ 0 8 -> UQ 0 8 -> Property)
      it "UQ 0 2" $
        property (prop_divide_uq nonrestoring :: UQ 0 2 -> UQ 0 2 -> Property)
      it "UQ 8 8" $
        property (prop_divide_uq nonrestoring :: UQ 8 8 -> UQ 8 8 -> Property)
      it "UQ 8 16" $
        property (prop_divide_uq nonrestoring :: UQ 8 16 -> UQ 8 16 -> Property)
      it "UQ 16 8" $
        property (prop_divide_uq nonrestoring :: UQ 16 8 -> UQ 16 8 -> Property)
    describe "Non-restoring division (signed)" $ do
      it "Q 0 3" $
        property (prop_divide_q nonrestoring :: Q 0 3 -> Q 0 3 -> Property)
      it "Q 8 0" $
        property (prop_divide_q nonrestoring :: Q 8 0 -> Q 8 0 -> Property)
      it "Q 0 8" $
        property (prop_divide_q nonrestoring :: Q 0 8 -> Q 0 8 -> Property)
      it "Q 0 2" $
        property (prop_divide_q nonrestoring :: Q 0 2 -> Q 0 2 -> Property)
      it "Q 8 8" $
        property (prop_divide_q nonrestoring :: Q 8 8 -> Q 8 8 -> Property)
      it "Q 8 16" $
        property (prop_divide_q nonrestoring :: Q 8 16 -> Q 8 16 -> Property)
      it "Q 16 8" $
        property (prop_divide_q nonrestoring :: Q 16 8 -> Q 16 8 -> Property)
