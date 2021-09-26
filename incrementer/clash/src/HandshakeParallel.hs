{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module HandshakeParallel
where
import Control.Monad.State
import Control.Monad
import Clash.Prelude
import GHC.Generics
import Control.DeepSeq
import Clash.Signal

type Enabled a = Maybe a
type Ready = Bool
type Valid = Bool
data ST = Idle | Valid | Ready  deriving (Eq,Show,Generic,NFData,ShowX)


instance NFDataX ST where
  deepErrorX = errorX
  rnfX = rwhnfX
  hasUndefined = error "hasUndefined on Undefined"
  ensureSpine = id


instance (Num a) => Num (Maybe a) where
    (+) = liftA2 (+)
    (-) = liftA2 (-)
    (*) = liftA2 (*)
    negate = liftA negate
    abs = liftA abs
    signum = liftA signum
    fromInteger = pure . fromInteger


handshakeParallel :: forall a n . (Num a, KnownNat n)  -- optimized parallel handshake
    => (Int -> a -> a)
    -> Int
    -> (Vec n a,Vec n Bool)
    -> (a,Valid,Ready)
    -> ((Vec n a,Vec n Bool),(a,Valid,Ready))
handshakeParallel f n (x_,v_) (dataIn,in_valid,out_ready) = ((x',v'),(dataOut,out_valid,in_ready))
  where

    v' = if out_ready then (in_valid +>> v_) else v_
    x' = if out_ready then (map (f n) (dataIn +>> x_)) else x_

    out_valid = v_ !! (length v_ -1)
    dataOut = x_ !! (length x_ -1)
    in_ready  = out_ready


---- instance of parallel handshake

hsParallel :: (HiddenClockResetEnable dom, Num a, NFDataX a)
         => Reset dom
         -> Signal dom (a,Valid, Ready)
         -> Signal dom (a,Valid, Ready)
hsParallel rst = withReset rst (mealy (handshakeParallel (\i x -> x+1) 16)
           (undefined, replicate (SNat :: SNat 16) False))

topEntity :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((Unsigned 16), Valid, Ready)
         -> Signal System ((Unsigned 16),Valid, Ready)
topEntity = exposeClockResetEnable hsParallel

topEntityFixed :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((UFixed 8 8), Valid, Ready)
         -> Signal System ((UFixed 8 8),Valid, Ready)
topEntityFixed = exposeClockResetEnable hsParallel

{-# ANN topEntity
  (Synthesize { t_name   = "paralleliter"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

{-# ANN topEntityFixed
  (Synthesize { t_name   = "paralleliter_fixed"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}
