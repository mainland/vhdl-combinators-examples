{-# LANGUAGE FlexibleContexts #-}

module Incrementer where

import Clash.Prelude

import Pipeline

{-# ANN incrementer_u16_serial
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u16_serial :: Clock System
                       -> Reset System
                       -> Enable System
                       -> Signal System (Unsigned 16,Bool,Bool)
                       -> Signal System (Unsigned 16,Bool,Bool)
incrementer_u16_serial = runPipeline $ siter @16 (\x _ -> x + 1)

{-# ANN incrementer_u8_8_serial
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u8_8_serial :: Clock System
                        -> Reset System
                        -> Enable System
                        -> Signal System (UFixed 8 8,Bool,Bool)
                        -> Signal System (UFixed 8 8,Bool,Bool)
incrementer_u8_8_serial = runPipeline $ siter @16 (\x _ -> x + 1)

{-# ANN incrementer_u16_parallel
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u16_parallel :: Clock System
                         -> Reset System
                         -> Enable System
                         -> Signal System (Unsigned 16,Bool,Bool)
                         -> Signal System (Unsigned 16,Bool,Bool)
incrementer_u16_parallel = runPipeline $ piter @16 (\x _ -> x + 1)

{-# ANN incrementer_u8_8_parallel
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u8_8_parallel :: Clock System
                          -> Reset System
                          -> Enable System
                          -> Signal System (UFixed 8 8,Bool,Bool)
                          -> Signal System (UFixed 8 8,Bool,Bool)
incrementer_u8_8_parallel = runPipeline $ piter @16 (\x _ -> x + 1)

{-# ANN incrementer_u16_bubbles
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u16_bubbles :: Clock System
                        -> Reset System
                        -> Enable System
                        -> Signal System (Unsigned 16,Bool,Bool)
                        -> Signal System (Unsigned 16,Bool,Bool)
incrementer_u16_bubbles = runPipeline $ piter' @16 (\x _ -> x + 1)

{-# ANN incrementer_u8_8_bubbles
  (Synthesize { t_name   = "incrementer"
              , t_inputs = [ PortName "clk"
                           , PortName "rst"
                           , PortName "en"
                           , PortProduct "" [PortName "in_x",PortName "in_valid", PortName "out_ready"]
                           ]
              , t_output = PortProduct "" [PortName "out_x",PortName "out_valid", PortName "in_ready"]

              }) #-}

incrementer_u8_8_bubbles :: Clock System
                         -> Reset System
                         -> Enable System
                         -> Signal System (UFixed 8 8,Bool,Bool)
                         -> Signal System (UFixed 8 8,Bool,Bool)
incrementer_u8_8_bubbles = runPipeline $ piter' @16 (\x _ -> x + 1)
