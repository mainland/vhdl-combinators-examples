{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module HandshakeRV
where
import Control.Monad.State
import Control.Monad
import Clash.Prelude
import GHC.Generics
import Control.DeepSeq
import Clash.Signal
import GHC.Classes
import qualified Data.List as L
import qualified Clash.Explicit.Prelude as CEP
type Enabled a = Maybe a
type Ready = Bool
type Valid = Bool
data ST = Idle | Valid | Ready  deriving (Eq,Show,Generic,NFData,ShowX)


instance NFDataX ST where
  deepErrorX = errorX
  rnfX = rwhnfX
  hasUndefined = error "hasUndefined on Undefined"
  ensureSpine = id

--data Reset (domain :: Domain) (synchronous :: ResetKind)

instance (Num a) => Num (Maybe a) where
    (+) = liftA2 (+)
    (-) = liftA2 (-)
    (*) = liftA2 (*)
    negate = liftA negate
    abs = liftA abs
    signum = liftA signum
    fromInteger = pure . fromInteger


handshakeRV :: (Num a) => (ST,a) -> (a,Valid,Ready) -> ((ST,a),(a,Valid,Ready)) -- Unity handshake: Passed the tests
handshakeRV (state,x_) (dataIn,in_valid,out_ready) = ((state',x'),(x',out_valid,in_ready))
  where
    out_valid = case state' of  Idle   -> False
                                Valid  -> True
                                Ready  -> True
    in_ready  = case out_ready of  True -> True
                                   False  -> False
    state' = case state of  Idle -> case in_valid of
                              False -> Idle
                              True  -> Valid
                            Valid  ->   if out_ready then Ready else Valid
                            Ready  ->   if not out_ready then Idle else Ready
    x = if (state == Valid) then dataIn else x_
    x' = if (state == Valid) then x + 1
          else x


handshakeSerial :: forall a n . (Num a, KnownNat n)
                => (Int -> a -> a)
                -> BitVector n
                -> (a,BitVector n)
                -> (a,Valid,Ready)
                -> ((a,BitVector n),(a,Valid,Ready))
handshakeSerial f n (x_,cnt_) (dataIn,in_valid,out_ready) = ((x',cnt),(x',out_valid,in_ready))
  where

    out_valid = if (cnt_ == n) then True else False
    in_ready  = case cnt_ of  0 -> True
                              _ -> False
    c = in_valid && cnt_ == 0
    cnt = if c || (cnt_ > 0 && cnt_ < n) then cnt_ + 1
          else (if cnt_ == n && out_ready then 0 else cnt_)
    x = if c then dataIn else x_
    x' = if c || (cnt_ > 0 && cnt_ < n) then (f 0 x)
          else x


handshakeParallel' :: forall a n . (Num a, KnownNat n, KnownNat (n-1)) -- parallel handshake with bubble squeezing
    => (Int -> a -> a)
    -> (Vec n a,Vec n Valid, Vec n Ready)
    -> (Bool,a,Valid,Ready)
    -> ((Vec n a,Vec n Valid, Vec n Ready),(a,Valid,Ready))
handshakeParallel' f (x_,v_,r_) (rst,dataIn,in_valid,out_ready) = ((x',v',r'),(dataOut,out_valid,in_ready))
  where

    v' = case rst of True -> replicate (SNat :: SNat n) False
                     False -> imap (\i e -> if r_ !! i then
                                   (if i>0 then v_ !! (i-1) else in_valid) else e) v_

    x' = imap (\i e -> if r_ !! i then
                (if i>0 then f 0 (x_ !! (i-1)) else f 0 dataIn) else e) x_

    r'' = zipWith (\x y -> x || not y) (tail r_) (take (SNat :: SNat (n-1)) v')
    r' = case rst of True -> replicate (SNat :: SNat n) True
                     False -> r'' ++ ( singleton (out_ready || not (v' !! (length v' -1))))

    out_valid = v_ !! (length v_ -1)
    dataOut = x_ !! (length x_ -1)
    in_ready  = r' !! 0


handshakeParallel :: forall a n . (Num a, KnownNat n)  -- optimized parallel handshake
    => (Int -> a -> a)
    -> (Int,Vec n a,Vec n Bool)
    -> (Bool,a,Valid,Ready)
    -> ((Int,Vec n a,Vec n Bool),(a,Valid,Ready))
handshakeParallel f (n,x_,v_) (rst,dataIn,in_valid,out_ready) = ((n,x',v'),(dataOut,out_valid,in_ready))
  where

    v' = if rst then (replicate (SNat :: SNat n) False)
         else (if out_ready then (in_valid +>> v_) else v_)
    x' = if (rst == False && out_ready)
         then (map (f n) (dataIn +>> x_)) else x_

    out_valid = v_ !! (length v_ -1)
    dataOut = x_ !! (length x_ -1)
    in_ready  = out_ready


------------------------------------------------------------------------------------------

-- Instance of a unity handshake

hsRV :: (HiddenClockResetEnable dom,
             Num a, NFDataX a)
         =>
         Signal dom (a, Valid, Ready) -> Signal dom (a,Valid, Ready)
hsRV = mealy handshakeRV (Idle, 0) -- (state_init, x_init)

--topEntity :: Clock System
--          -> Reset System
--          -> Enable System
--          -> Signal System ((Signed 16),Bool,Bool)
--          -> Signal System ((Signed 16),Bool,Bool)
--topEntity = exposeClockResetEnable hsRV

-------------------------------------------------------------------------------------------

-- instance of serial handshake

hsSerial :: (HiddenClockResetEnable dom,
             Num a, NFDataX a, Ord a)
         => Reset dom -> Signal dom (a, Valid, Ready) -> Signal dom (a,Valid, Ready)
hsSerial rst = withReset rst (mealy (handshakeSerial (\i x -> x+1) (0b10000 :: BitVector 5)) (0,0)) -- (n,x_init, cnt_int,valid_out_init) , n = 16

topEntity :: Clock System
         -> Reset System
         -> Enable System
         -> Reset System
         -> Signal System ((Unsigned 16),Bool,Bool) -- number of bits = 16
         -> Signal System ((Unsigned 16),Bool,Bool)
topEntity = exposeClockResetEnable hsSerial

------------------------------------------------------------------------------------------------------

---- instance of parallel handshake

hsParallel :: (HiddenClockResetEnable dom, Num a, NFDataX a)
         => Signal dom (Bool, a, Valid, Ready)
         -> Signal dom (a,Valid, Ready)
hsParallel = mealy (handshakeParallel (\i x -> x+1))
           (16,replicate (SNat :: SNat 16) 0, replicate (SNat :: SNat 16) False)

-- topEntity :: Clock System
--          -> Reset System
--          -> Enable System
--          -> Signal System (Bool, (UFixed 8 8), Valid, Ready)
--          -> Signal System ((UFixed 8 8),Valid, Ready)
-- topEntity = exposeClockResetEnable hsParallel


hsParallel' :: (HiddenClockResetEnable dom, Num a, NFDataX a)
         => Signal dom (Bool, a, Valid, Ready)
         -> Signal dom (a,Valid, Ready)
hsParallel' = mealy (handshakeParallel' (\i x -> x+1) )
           (replicate (SNat :: SNat 16) 0, replicate (SNat :: SNat 16) False,replicate (SNat :: SNat 16) False)


-- topEntity :: Clock System
--          -> Reset System
--          -> Enable System
--          -> Signal System (Bool, (UFixed 8 8), Valid, Ready)
--          -> Signal System ((UFixed 8 8),Valid, Ready)
-- topEntity = exposeClockResetEnable hsParallel'



--------------------------------------------------------------------------------------------------

-- handshakeParallel' :: forall a n . (Num a, KnownNat n, KnownNat (n-1)) -- unoptimized parallel handshake with bubble squeezing
--     => (Int -> a -> a)
--     -> (Vec n a,Vec n Valid, Vec n Ready)
--     -> (Bool,a,Valid,Ready)
--     -> ((Vec n a,Vec n Valid, Vec n Ready),(a,Valid,Ready))
-- handshakeParallel' f (x_,v_,r_) (rst,dataIn,in_valid,out_ready) = ((x',v',r'),(dataOut,out_valid,in_ready))
--   where
--
--     v'' = if rst then (replicate (SNat :: SNat n) False)
--           else (if (r_ !! 0) then in_valid +>> v_ else v_)
--     v' = izipWith (\i a b -> if r_ !! i then a else b) v'' v_
--
--     x'' = if (rst == False && r_ !! 0 )
--           then (dataIn +>> x_) else x_
--     x' = izipWith (\i a b -> if r_ !! i then (f 0 a) else b) x'' x_
--
--     r'' = zipWith (\x y -> x || not y) (tail r_) (take (SNat :: SNat (n-1)) v')
--     r' = if rst then (replicate (SNat :: SNat n) True)
--          else (r'' ++ ( replicate d1 (out_ready || not (v' !! (length v' -1)))))
--
--     out_valid = v_ !! (length v_ -1)
--     dataOut = x_ !! (length x_ -1)
--     in_ready  = r' !! 0

-----------------------------------------------------------------------------------------

-- handshakeParallel :: forall a dom n . (HiddenClockResetEnable dom, Num a,NFDataX a, KnownNat n) -- around 500 LUTs
--                    => (Signal dom a -> Signal dom a -> Int -> Signal dom a)
--                    -> Vec n (Signal dom a)
--                    -> (Bool, Signal dom a,Valid,Ready)
--                    -> (Signal dom a,Valid,Ready)
-- handshakeParallel func consts (rst,dataIn,in_valid,out_ready) = (x',out_valid,in_ready)
--   where
--
--     valid = replicate (SNat :: SNat n) in_valid
--     valid' = if (rst == False && out_ready)
--            then rotateLeft valid (length valid - 1)
--            else rotateLeft valid (length valid - 2)
--     out_valid = if rst then False else (valid' !! 0)
--
--     in_ready  = out_ready
--
--     x = if (rst == False && out_ready)
--         then (func dataIn 0 0) else (delay 0 x)
--
--     initial = (0,out_ready,x)
--     (_,_,x') = foldl iter initial consts
--
--     iter :: (Int,Bool,Signal dom a) -> Signal dom a -> (Int,Bool,Signal dom a)
--     iter (i, ready, f) g = (i+1,ready,f')
--        where
--          f' = if ready then (func f g i) else (dflipflop f')

-- topEntity :: Clock System
--           -> Reset System
--           -> Enable System
--           -> (Bool,Signal System (Signed 16),Bool, Bool)
--           -> (Signal System (Signed 16),Bool, Bool)
-- topEntity = exposeClockResetEnable (handshakeParallel (\x y i -> x+y) (replicate d16 1) ) -- this one utilizes near 900 LUTs
