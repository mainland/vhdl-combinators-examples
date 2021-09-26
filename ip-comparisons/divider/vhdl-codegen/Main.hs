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

import Prelude hiding ( id )

import Control.Category ( (>>>), id )
import Control.Monad ( forM_, replicateM )
import Control.Monad.IO.Class ( liftIO )
import Data.Bits ( FiniteBits(finiteBitSize) )
import Data.Foldable ( toList )
import Data.Fixed.Q
    ( isLteNat, isZeroNat, FixedBits(intBitSize), UQ(UQ) )
import Data.List ( zip4 )
import Data.Loc ( noLoc )
import Data.Maybe ( fromMaybe, isJust )
import Data.Proxy ( Proxy(..) )
import Data.Ratio ( numerator, denominator, (%) )
import Data.Sequence ( Seq )
import Data.String ( fromString )
import Data.Type.Equality ( type (:~:)(..) )
import GHC.TypeLits ( KnownNat, type (+), type (<=), natVal )
import Language.VHDL.Quote ( vexp )
import qualified Language.VHDL.Syntax as V
import System.Environment ( getArgs )
import System.IO ( IOMode(WriteMode), hPutStrLn, withFile )
import Test.QuickCheck ( Arbitrary(..), Gen, choose, generate )
import Text.PrettyPrint.Mainland
    ( comma, punctuate, folddoc, prettyCompact, hPutDoc, Doc )
import Text.PrettyPrint.Mainland.Class ( Pretty(ppr) )

import Language.VHDL.Codegen.Lift
import Language.VHDL.Codegen.Monad
import Language.VHDL.Codegen.Pipeline.VHDL
import Language.VHDL.Codegen.Pipeline.VHDL.Testbench
import Language.VHDL.Codegen.Testbench
import Language.VHDL.Codegen.VExp

import Opt

type M = 8

type F = 8

type N = UQ M F

main :: IO ()
main = do
    (conf, args) <- getArgs >>= compilerOpts
    when (not (help conf)) $ do
      (unit, p :: Pipeline (VExp N, VExp N) (VExp N, VExp (UQ (1+M+M) F))) <- evalCg $ nonrestoring conf
      case output conf of
        Nothing   -> return ()
        Just path -> writeDesignUnit path unit
      case tb_output conf of
        Nothing   -> return ()
        Just path -> do let config = defaultTestBenchConfig { tb_watchdog = Nothing
                                                            , tb_entity   = "tb_divider"
                                                            }
                        writeTestBench config path p
      when (isJust (tv_in_output conf) || isJust (tv_out_output conf)) $
        genTestVectors (Proxy :: Proxy N) conf

csvsep :: [Doc] -> Doc
csvsep = folddoc (<>) . punctuate comma

data DivPair a = DivPair a a
  deriving (Eq, Ord, Show)

instance Pretty a => Pretty (DivPair a) where
    ppr (DivPair n d) = csvsep [ppr n, ppr d]

instance (KnownNat m, KnownNat f) => Arbitrary (DivPair (UQ m f)) where
    arbitrary = do
      d <- nonZero
      n <- case isZeroNat @f of
             Just Refl -> fromIntegral <$> choose (0, toInteger (2^m * d) :: Integer)
             Nothing   -> case isLteNat @1 @f of
                            Just Refl -> do let d' = toRational d
                                            x <- choose (0, (2^m - 1) * numerator d')
                                            pure $ fromRational (x % denominator d')
                            Nothing   -> error "can't happen"
      return $ DivPair n d
      where
        m = natVal (Proxy :: Proxy m)

        nonZero :: Gen (UQ m f)
        nonZero = do
          x <- arbitrary
          if x == 0 then nonZero else pure x

genTestVectors :: forall m f m' f' . (KnownNat m, KnownNat f, KnownNat (m + f), 1 <= f, m' ~ (1+m+m), KnownNat m', KnownNat (m' + f))
               => Proxy (UQ m f)
               -> Config
               -> IO ()
genTestVectors _ conf = do
    ps :: [DivPair (UQ m f)] <- generate (replicateM (tv_len conf) arbitrary)
    let qs = [fquotRem n d | DivPair n d <- ps]
    case tv_in_output conf of
      Just path -> withFile path WriteMode $ \h ->
                   forM_ ps $ \p -> hPutStrLn h $ prettyCompact $ ppr p
      Nothing -> return ()
    case tv_out_output conf of
      Just path -> withFile path WriteMode $ \h ->
                   forM_ qs $ \(q, r) -> hPutStrLn h $ prettyCompact $ csvsep [ppr q, ppr r]
      Nothing -> return ()
  where
    m, f, n :: Integer
    m = natVal (Proxy :: Proxy m)
    f = natVal (Proxy :: Proxy f)
    n = f + m

fquotRem :: forall m f m'. (KnownNat m, KnownNat f, KnownNat m', m' ~ (1+m+m)) => UQ m f -> UQ m f -> (UQ m f, UQ m' f)
fquotRem (UQ n) (UQ d) = (UQ q, UQ (r * 2^m))
  where
    (q, r) = quotRem (n * 2^f) d

    m, f :: Integer
    m = natVal (Proxy :: Proxy m)
    f = natVal (Proxy :: Proxy f)

underflow :: forall m f . (KnownNat m, KnownNat f) => VExp (UQ m f) -> VExp Bool
underflow e = testBit' e (fromIntegral (finiteBitSize (undefined :: UQ m f) - 1))

cast :: forall m m' f f' . (KnownNat m', KnownNat f') => VExp (UQ m f) -> VExp (UQ m' f')
cast e = resize [vexp|$e|]

nonrestoring :: forall i i' f m . (KnownNat i, KnownNat f, KnownNat (i + f), KnownNat (i' + f), i' ~ (1+i+i), KnownNat i', MonadCg m)
             => Config
             -> m (Seq V.DesignUnit, Pipeline (VExp (UQ i f), VExp (UQ i f)) (VExp (UQ i f), VExp (UQ i' f)))
nonrestoring conf = withDesignUnit $ do
    p <- iter "divider"
              pre
              step
              post
              ["n", "d"]
              ["q", "r", "d"]
              (finiteBitSize (undefined :: UQ i f))
    wrapP "main" p
  where
    iter = case variant conf of
             Serial -> siter
             Parallel -> piter

    n, m :: VExp Int
    n = fromIntegral $ finiteBitSize (undefined :: UQ i f)
    m = fromIntegral $ intBitSize (undefined :: UQ i f)

    pre :: (VExp (UQ i f), VExp (UQ i f)) -> (VExp (UQ i f), VExp (UQ i' f), VExp (UQ i' f))
    pre (x0, d0) = (0, cast x0, cast d0)

    post :: (VExp (UQ i f), VExp (UQ i' f), VExp (UQ i' f)) -> (VExp (UQ i f), VExp (UQ i' f))
    post (q, r, d) =
        if underflow r
        then (q' - bit' 0, r + d `sla` m)
        else (q', r)
      where
        q' = q - complement' q

    step :: (VExp (UQ i f), VExp (UQ i' f), VExp (UQ i' f))
         -> VExp Int
         -> m (VExp (UQ i f), VExp (UQ i' f), VExp (UQ i' f))
    step (q, r, d) i =
        return $ if underflow r
        then (q,                       r `sla` 1 + d `sla` m, d)
        else (q `setBit'` (n - i - 1), r `sla` 1 - d `sla` m, d)
