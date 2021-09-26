{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module HandshakeParallelBubble
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


handshakeParallel' :: forall a n . (Num a, KnownNat n, KnownNat (n-1)) -- parallel handshake with bubble squeezing
    => (Int -> a -> a)
    -> (Vec n a,Vec n Valid, Vec n Ready)
    -> (a,Valid,Ready)
    -> ((Vec n a,Vec n Valid, Vec n Ready),(a,Valid,Ready))
handshakeParallel' f (x_,v_,r_) (dataIn,in_valid,out_ready) = ((x',v',r'),(dataOut,out_valid,in_ready))
  where

    v' = imap (\i e -> if r_ !! i then (if i>0 then v_ !! (i-1) else in_valid) else e) v_

    x' = imap (\i e -> if r_ !! i then
                (if i>0 then f (fromIntegral $ toInteger i) (x_ !! (i-1)) else f 0 dataIn) else e) x_

    r'' = zipWith (\x y -> x || not y) (tail r_) (take (SNat :: SNat (n-1)) v')
    r' = r'' ++ ( singleton (out_ready || not (v' !! (length v' -1))))

    out_valid = v_ !! (length v_ -1)
    dataOut = x_ !! (length x_ -1)
    in_ready  = r' !! 0


hsParallel' :: (HiddenClockResetEnable dom, Num a, NFDataX a)
         => Reset dom
         -> Signal dom (a, Valid, Ready)
         -> Signal dom (a,Valid, Ready)
hsParallel' rst = withReset rst (mealy (handshakeParallel' (\i x -> x+1) )
           (undefined, replicate (SNat :: SNat 16) False,replicate (SNat :: SNat 16) True))


topEntity :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((Unsigned 16), Valid, Ready)
         -> Signal System ((Unsigned 16),Valid, Ready)
topEntity = exposeClockResetEnable hsParallel'

topEntityFixed :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((UFixed 8 8), Valid, Ready)
         -> Signal System ((UFixed 8 8),Valid, Ready)
topEntityFixed = exposeClockResetEnable hsParallel'

{-# ANN topEntity
  (Synthesize { t_name   = "paralleliterb"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

{-# ANN topEntityFixed
  (Synthesize { t_name   = "paralleliterb_fixed"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortName "reset"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}
