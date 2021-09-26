-- | Perform serial iteration with a function.
siter :: forall a b c m . (Pack a, Pack b, Pack c, MonadCg m)
      => Id                     -- ^ Name of VHDL entity
      -> (a -> b)               -- ^ Pre-processing function
      -> (b -> VExp Int -> m b) -- ^ Function to iterate
      -> (b -> c)               -- ^ Post-processing function
      -> [String]               -- ^ (Optional) signal names
      -> [String]               -- ^ (Optional) state names
      -> Int                    -- ^ Number of iterations to perform
      -> m (Pipeline a c)
siter entity f g h names snames n = do
    (_ :: a, in_vars)    <- genPack names
    (x :: b, state_vars) <- genPack snames
    (_ :: c, out_vars)   <- genPack names

    addTypeContext [vtype|natural|]
    addTypeContext [vtype|unsigned|]
    addTypeContext [vtype|std_logic|]
    mapM_ addTypeContext [tau | (_, tau) <- in_vars]
    mapM_ addTypeContext [tau | (_, tau) <- state_vars]
    mapM_ addTypeContext [tau | (_, tau) <- out_vars]

    let in_idecls  = [[videcl|$id:(in_ v) : in $ty:tau|]   | (v, tau) <- in_vars]
        out_idecls = [[videcl|$id:(out_ v) : out $ty:tau|] | (v, tau) <- out_vars]

    ctx <- gets context
    append [vunit|
      entity $id:entity is
        port (clk : in std_logic;
              rst : in std_logic;
              in_ready : out std_logic;
              in_valid : in std_logic;
              $idecls:in_idecls;
              out_ready : in std_logic;
              out_valid : out std_logic;
              $idecls:out_idecls);
      end;|]

    withArchitecture "behavioral" (toName entity noLoc) $ do
        -- Declare loop counter and state
        sig "i" [vtype|natural range 0 to $n|] (Just [vexp|0|])
        mapM_ (\(v, tau) -> sig v tau Nothing) state_vars

        let i :: VExp Int
            i = VExp [vexp|i|]

        -- Update loop index
        withProcess ["clk"] $ do
            onRisingEdge $ do
                if [vexp|rst = '1'|] then
                  append [vstm|i <= 0;|]
                else if [vexp|(i > 0 and i < $n) or (i = 0 and in_valid = '1')|] then
                  append [vstm|i <= i + 1;|]
                else when [vexp|i = $n and out_ready = '1'|] $
                  append [vstm|i <= 0;|]

        -- Update state
        withProcess ["clk"] $ do
            onRisingEdge $ do
                when [vexp|i = 0 and in_valid = '1'|] $ do
                  x_pre  <- pack [(in_ v, tau)| (v, tau) <- in_vars]
                  result <- unpack <$> g (f x_pre) 0
                  zipWithM_ sigassign (map fst state_vars) result

                -- We can take a step when in_valid is high and we are at
                -- the initial step or when we have remaining subsequent
                -- steps to take.
                when [vexp|i > 0 and i < $n|] $ do
                  result <- unpack <$> g x (VExp [vexp|i|])
                  zipWithM_ sigassign (map fst state_vars) result

        -- Update in_ready signal
        append [vcstm|in_ready <= '1' when (i = 0) else
                                  '0';|]

        -- Update out_valid signal
        append [vcstm|out_valid <= '1' when $(atUpperBound i n) else
                                   '0';|]

        -- Update state
        z <- pack state_vars
        zipWithM_ sigcassign [out_ v | (v, _) <- out_vars] (unpack (h z))

    return Pipeline { pipe_context = ctx
                    , pipe_entity  = entity
                    , pipe_in      = [(in_ v, tau)  | (v, tau) <- in_vars]
                    , pipe_out     = [(out_ v, tau) | (v, tau) <- out_vars]
                    }


-- | Perform parallel iteration with a function. This version will squeeze out
-- pipeline bubbles.
piter :: forall a b c m . (Pack a, Pack b, Pack c, MonadCg m)
      => Id                     -- ^ Name of VHDL entity
      -> (a -> b)               -- ^ Pre-processing function
      -> (b -> VExp Int -> m b) -- ^ Function to iterate
      -> (b -> c)               -- ^ Post-processing function
      -> [String]               -- ^ (Optional) signal names
      -> [String]               -- ^ (Optional) state names
      -> Int                    -- ^ Number of iterations to perform
      -> m (Pipeline a c)
piter entity f g h names snames n = do
    (_ :: a, in_vars)    <- genPack names
    (_ :: b, state_vars) <- genPack snames
    (_ :: c, out_vars)   <- genPack names

    addTypeContext [vtype|std_logic|]
    mapM_ addTypeContext [tau | (_, tau) <- in_vars]
    mapM_ addTypeContext [tau | (_, tau) <- state_vars]
    mapM_ addTypeContext [tau | (_, tau) <- out_vars]

    let in_idecls  = [[videcl|$id:(in_ v) : in $ty:tau|]   | (v, tau) <- in_vars]
        out_idecls = [[videcl|$id:(out_ v) : out $ty:tau|] | (v, tau) <- out_vars]

    ctx <- gets context
    append [vunit|
      entity $id:entity is
        port (clk : in std_logic;
              rst : in std_logic;
              in_ready : out std_logic;
              in_valid : in std_logic;
              $idecls:in_idecls;
              out_ready : in std_logic;
              out_valid : out std_logic;
              $idecls:out_idecls);
      end;|]
    withArchitecture "behavioral" (toName entity noLoc) $ do
        sig "valid" [vtype|std_logic_vector($(n-1) downto 0)|] Nothing
        sig "ready" [vtype|std_logic_vector($(n-1) downto 0)|] Nothing

        forM_ state_vars $ \(v, tau) -> do
          let array_t = mapId (++ "_t") v
          append [vdecl|type $id:array_t is array ($(n-1) downto 0) of $ty:tau;|]
          sig v [vtype|typename $id:array_t|] Nothing

        withProcess ["clk"] $ do
            onRisingEdge $ do
                if [vexp|rst = '1'|]
                  then reset
                  else do
                    when [vexp|arrname ready(0)|] $ do
                      x <- pack [(in_ v, tau)| (v, tau) <- in_vars]
                      result <- unpack <$> g (f x) 0
                      zipWithM_ (\(v, _) e -> sigassign [vname|arrname $id:v(0)|] e) state_vars result
                      append [vstm|valid(0) <= in_valid;|]

                    forS "i" [vrange|1 to $(n-1)|] $ \i -> do
                        when [vexp|arrname ready($i)|] $ do
                          x <- pack (map (\(v, tau) -> ([vexp|arrname $id:v($i-1)|], tau)) state_vars)
                          result <- unpack <$> g x (VExp i)
                          zipWithM_ (\(v, _) e -> sigassign [vname|arrname $id:v($i)|] e) state_vars result
                          append [vstm|valid($i) <= arrname valid($i-1);|]

        append [vcstm|ready($(n-1)) <= out_ready or not valid($(n-1));|]

        append [vcstm|gen_ready:
                      for i in $(n-2) downto 0 generate
                        begin
                          ready(i) <= ready(i+1) or not valid(i);
                        end;
                      end generate;|]

        append [vcstm|in_ready <= ready(0);|]

        z <- pack [([vexp|arrname $id:v($(n-1))|], tau) | (v, tau) <- state_vars]
        zipWithM_ (\(v, _) e -> sigcassign [vname|$id:(out_ v)|] e) out_vars (unpack (h z))

        append [vcstm|out_valid <= valid(valid'high);|]
    return Pipeline { pipe_context = ctx
                    , pipe_entity  = entity
                    , pipe_in      = [(in_ v, tau)  | (v, tau) <- in_vars]
                    , pipe_out     = [(out_ v, tau) | (v, tau) <- out_vars]
                    }
  where
    reset :: m ()
    reset = do
        append [vstm|valid <= (others => '0');|]
        append [vstm|ready <= (others => '1');|]
