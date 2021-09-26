type Ready = Bool
type Valid = Bool
type ValidReady a = (a, Valid, Ready)

data Pipeline a b = forall clk . (Clock clk) => Pipeline ((Signal clk (ValidReady a)) -> (Signal clk (ValidReady b)))

-- Serial iterator with a function, using RTL DSL:
siter :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a , Rep xs, Num xs, Size xs)
      => (sig a -> xs -> sig a)
      -> sig Bool
      -> sig (ValidReady a)
      -> sig (ValidReady a)
siter f rst in_pipe = runRTL $ do
    let (in_x,in_valid,out_ready) = unpack in_pipe
        n = fromIntegral (size (undefined :: xs)-1) :: xs
    cnt <- newReg (0 :: xs)
    nr <- newReg (n :: xs )
    x <- newReg (0 :: a)
    CASE [ IF rst $ do
              cnt := 0
         , OTHERWISE $ do
            WHEN (reg cnt .==. 0 .&&. in_valid ) $ x := f in_x 0
            CASE [IF ((reg cnt .>. 0 .&&. reg cnt .<. reg nr) .||. (reg cnt .==. 0 .&&. in_valid )) $ do
                    cnt := reg cnt + 1
                    x := f (reg x) n
                 , OTHERWISE $ do
                    WHEN (reg cnt .==. reg nr .&&. out_ready) $ cnt := 0
                 ]
         ]
    let in_ready' = mux (reg cnt .==.0) (low,high)
        out_valid' = mux (reg cnt .==. reg nr) (low,high)

        in_x_E = packEnabled out_valid' (reg x) :: Signal clk (Enabled a)
        patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
        (in_ready, data_res_E) = execP patch (in_x_E, in_ready')
        (out_valid,out_x) = unpackEnabled data_res_E
    return $ pack ( out_x, out_valid, in_ready)


-- Parallel iter with a function, using RTL DSL, the version that squeezes bubbles:
piter' :: forall clk a xs sig . (sig ~ Signal clk, Clock clk, Num a, Rep a, Rep xs, Num xs, Size xs)
       => (sig a -> xs -> sig a)
       -> sig Bool
       -> sig (ValidReady a)
       -> sig (ValidReady a)
piter' f rst in_pipe = pack ( out_x, out_valid, in_ready)

   where
    (in_x,in_valid,out_ready) = unpack in_pipe
    n = size (undefined :: xs) - 1
    (x',valid',ready') = runRTL $ do

      valid <- newReg (matrix (replicate (n+1) False) :: Matrix xs Bool)
      ready <- newReg (matrix (replicate (n+1) False) :: Matrix xs Bool)
      d <- newReg (matrix (replicate (n+1) 0) :: Matrix xs a)

      CASE [ IF rst $ do
                valid := packMatrix $ matrix (replicate (n+1) low)
                ready := packMatrix $ matrix (replicate (n+1) high)
           , OTHERWISE $ do
                d := packMatrix $ forEach (unpackMatrix (var d))
                            (\i x -> if i > 0 then
                                          mux ((unpackMatrix (var ready)) ! i) (delay x, f (unpackMatrix (reg d) ! (i-1) ) i  )
                                     else mux ((unpackMatrix (var ready)) ! 0) (delay x, f in_x 0))
                valid := packMatrix $ forEach (unpackMatrix (var valid))
                            (\i v -> if i > 0 then
                                          mux ((unpackMatrix (var ready)) ! i) (delay v, unpackMatrix (reg valid) ! (i-1))
                                     else mux ((unpackMatrix (var ready)) ! 0) (delay v, in_valid))
           ]
      ready := packMatrix $ forEach (unpackMatrix (var ready))
                    (\i e -> if i < fromIntegral n - 1
                             then (((unpackMatrix (var ready)) ! (i+1)) `or2` (bitNot (unpackMatrix (reg valid) ! i)))
                             else (out_ready `or2` (bitNot (unpackMatrix (reg valid) ! (fromIntegral n - 1)))))
      return (reg d, reg valid, var ready)

    x_d' = (unpackMatrix x') ! (fromIntegral (n - 1))
    valid_d' = (unpackMatrix valid') ! (fromIntegral (n - 1))
    ready_d' = (unpackMatrix ready') ! 0

    in_x_E = packEnabled valid_d' x_d' :: Signal clk (Enabled a)
    patch = mapP ((\x -> x) :: (forall clk'. Signal clk' a -> Signal clk' a))
                 :: Patch (Signal clk (Enabled a)) (Signal clk (Enabled a)) ack ack
    (in_ready, data_res_E) = execP patch (in_x_E, ready_d')
    (out_valid,out_x) = unpackEnabled data_res_E
