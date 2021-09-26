type Ready = Bool

type Valid = Bool

-- | Data with associated ready and valid signals
type ValidReady a = (a, Valid, Ready)

type Pipeline dom a b = Signal dom (ValidReady a) -> Signal dom (ValidReady b)

runPipeline :: forall dom a b. WithSingleDomain dom (Signal dom a -> Signal dom b)
            => (HiddenClockResetEnable dom => Signal dom a -> Signal dom b)
            -> KnownDomain dom => Clock dom -> Reset dom -> Enable dom -> Signal dom a -> Signal dom b
runPipeline = exposeClockResetEnable

siter :: forall n a dom . (HiddenClockResetEnable dom, KnownNat n, NFDataX a, 1 <= n)
      => (a -> Index n -> a)
      -> Pipeline dom a a
siter f = mealy step (undefined, 0)
  where
    step :: (a, Index (n+1))
         -> ValidReady a
         -> ((a, Index (n+1)), ValidReady a)
    step (x_,cnt_) (in_data,in_valid,out_ready) = ((x',cnt),(x',out_valid,in_ready))
      where
        n :: Index (n+1)
        n = fromIntegral (natVal (Proxy :: Proxy n))

        out_valid :: Bool
        out_valid = cnt_ == n

        in_ready :: Bool
        in_ready = cnt_ == 0

        -- True if this is the first step
        first_step :: Bool
        first_step = in_valid && cnt_ == 0

        cnt :: Index (n+1)
        cnt | first_step || (cnt_ > 0 && cnt_ < n) = cnt_ + 1
            | cnt_ == n && out_ready               = 0
            | otherwise                            = cnt_

        x :: a
        x = if first_step then in_data else x_

        x' :: a
        x' = if first_step || (cnt_ > 0 && cnt_ < n)
             then f x (resize cnt_)
             else x

-- | Parallel iteration with pipeline bubble elimination
piter :: forall n a dom . (HiddenClockResetEnable dom, KnownNat n, NFDataX a, 1 <= n)
      => (a -> Index n -> a)
      -> Pipeline dom a a
piter f = mealy step (undefined, replicate (SNat :: SNat n) False, replicate (SNat :: SNat n) True)
  where
    step :: (Vec n a, Vec n Valid, Vec n Ready)
         -> ValidReady a
         -> ((Vec n a, Vec n Valid, Vec n Ready), ValidReady a)
    step (x_,v_,r_) (in_data,in_valid,out_ready) = ((x',v',r'),(out_data,out_valid,in_ready))
      where
        whenReady :: forall m b. KnownNat m
                  => Vec m b
                  -> (Index m -> b -> b)
                  -> Vec m b
        whenReady xs g = imap (\i e -> if r_ !! i then g i e else e) xs

        x' :: Vec n a
        x' = whenReady x_ $ \i _ -> if i == 0 then f in_data i else f (x_ !! (i-1)) i

        v' :: Vec n Valid
        v' = whenReady v_ $ \i _ -> if i == 0 then in_valid else v_ !! (i-1)

        r' :: Vec n Ready
        r' = zipWith (\x y -> x || not y) (tail r_) (take (SNat :: SNat (n-1)) v') :< (out_ready || not (last v'))

        out_data :: a
        out_data = last x_

        out_valid :: Bool
        out_valid = last v_

        in_ready :: Bool
        in_ready = head r'
