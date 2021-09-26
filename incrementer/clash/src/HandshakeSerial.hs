{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module HandshakeSerial
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


handshakeSerial :: forall a n . (Num a, KnownNat n)
                => (Int -> a -> a)
                -> BitVector n
                -> (a,BitVector n)
                -> (a,Valid,Ready)
                -> ((a,BitVector n),(a,Valid,Ready))
handshakeSerial f n (x_,cnt_) (dataIn,in_valid,out_ready) = ((x',cnt),(x',out_valid,in_ready))
  where

    out_valid = cnt_ == n
    in_ready  = cnt_ == 0
    c = in_valid && cnt_ == 0
    cnt = if c || (cnt_ > 0 && cnt_ < n) then cnt_ + 1
          else (if cnt_ == n && out_ready then 0 else cnt_)
    x = if c then dataIn else x_
    x' = if c || (cnt_ > 0 && cnt_ < n) then (f 0 x)
          else x


-- instance of serial handshake

hsSerial :: (HiddenClockResetEnable dom,
             Num a, NFDataX a, Ord a)
         => Reset dom -> Signal dom (a, Valid, Ready) -> Signal dom (a,Valid, Ready)
hsSerial rst = withReset rst (mealy (handshakeSerial (\i x -> x+1) (0b10000 :: BitVector 5)) (0,0))


topEntity :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((Unsigned 16),Bool,Bool)
         -> Signal System ((Unsigned 16),Bool,Bool)
topEntity = exposeClockResetEnable hsSerial

topEntityFixed :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((UFixed 8 8),Bool,Bool)
         -> Signal System ((UFixed 8 8),Bool,Bool)
topEntityFixed = exposeClockResetEnable hsSerial


{-# ANN topEntity
  (Synthesize { t_name   = "serialiter"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

{-# ANN topEntityFixed
  (Synthesize { t_name   = "serialiter_fixed"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}
