{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE OverloadedStrings #-}

-- |
-- Module      :  Opt
-- Copyright   :  (c) 2020-2021 Drexel University
-- License     :  BSD-style
-- Maintainer  :  mainland@drexel.edu

module Opt (
  Variant(..),
  NumType(..),
  Config(..),
  SomePipeline(..),
  defaultConfig,
  defaultMain,
  defaultMainWith
) where

import Control.Monad ( when )
import Control.Monad.IO.Class ( liftIO )
import Data.Foldable ( toList )
import Data.Sequence ( Seq )
import System.Console.GetOpt
    ( OptDescr(..),
      getOpt,
      usageInfo,
      ArgDescr(ReqArg, NoArg),
      ArgOrder(Permute) )
import System.Environment ( getArgs, getProgName )
import System.IO ( stderr, IOMode(WriteMode), hPutStrLn, withFile )
import Text.PrettyPrint.Mainland ( hPutDoc )
import Text.PrettyPrint.Mainland.Class ( Pretty(ppr) )

import Language.VHDL.Codegen.Monad ( evalCg, Cg )
import Language.VHDL.Codegen.Pipeline ( Pipeline )
import Language.VHDL.Codegen.Testbench ( TextIO )
import qualified Language.VHDL.Codegen.Pipeline.Testbench as TB
import qualified Language.VHDL.Syntax as V

data Variant = Serial | Parallel | ParallelBubbles

data NumType = UQ16 | UQ8_8

data Config = Config { help        :: Bool           -- ^ Show help
                     , variant     :: Variant        -- ^ Pipeline variant
                     , numtype     :: NumType        -- ^ Numeric type
                     , output      :: Maybe FilePath -- ^ VHDL output
                     , tb_entity   :: V.Id           -- ^ VHDL test bench entity name
                     , tb_watchdog :: Maybe Int      -- ^ Watchdog timeout (in clock periods)
                     , tb_compare  :: Bool           -- ^ True if test bench should compare to output,
                                                     -- False to write output
                     , tb_output   :: Maybe FilePath -- ^ VHDL test bench output
                     }

defaultConfig :: Config
defaultConfig = Config { help        = False
                       , variant     = Serial
                       , numtype     = UQ16
                       , output      = Nothing
                       , tb_entity   = "testbench"
                       , tb_watchdog = Nothing
                       , tb_compare  = True
                       , tb_output   = Nothing
                       }

options :: [OptDescr (Config -> Config)]
options =
    [ Option ['h'] ["help"]      (NoArg (\conf -> conf { help = True }))                        "show help"
    , Option ['s'] ["serial"]    (NoArg (\conf -> conf { variant = Serial }))                   "generate serial version"
    , Option ['p'] ["parallel"]  (NoArg (\conf -> conf { variant = Parallel }))                 "generate parallel version"
    , Option ['b'] ["bubbles"]   (NoArg (\conf -> conf { variant = ParallelBubbles }))          "generate parallel version (with pipeline bubbles)"
    , Option []    ["uq16"]      (NoArg (\conf -> conf { numtype = UQ16 }))                     "use UQ16 type"
    , Option []    ["uq8.8"]     (NoArg (\conf -> conf { numtype = UQ8_8 }))                     "use UQ8.8 type"
    , Option ['o'] ["output"]    (ReqArg (\path conf -> conf { output = Just path }) "FILE")    "output FILE"
    , Option ['t'] ["testbench"] (ReqArg (\path conf -> conf { tb_output = Just path }) "FILE") "testbench output FILE"
    ]

parseOpts :: Config -> [String] -> IO (Config, [String])
parseOpts conf argv = do
  progName <- getProgName
  let header = "Usage: " ++ progName ++ " [OPTION...]"
  case getOpt Permute options argv of
      (o_,n,[])  -> do let o = foldl (flip id) conf o_
                       when (help o) $
                         hPutStrLn stderr (usageInfo header options)
                       return (o,n)
      (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))

data SomePipeline = forall a b. (TextIO a, TextIO b) => SomePipeline (Pipeline a b)

defaultMain :: (Config -> Cg (Seq V.DesignUnit, SomePipeline))
            -> IO ()
defaultMain f = do
    defaultMainWith defaultConfig f

defaultMainWith :: Config
                -> (Config -> Cg (Seq V.DesignUnit, SomePipeline))
                -> IO ()
defaultMainWith conf0 f = do
    (conf, _args) <- getArgs >>= parseOpts conf0
    when (not (help conf)) $ do
      (unit, p) <- evalCg $ f conf
      writeModule conf unit
      case p of
        SomePipeline p' -> writeTestBench conf p'
  where
    writeModule :: Config -> Seq V.DesignUnit -> IO ()
    writeModule conf unit =
      case output conf of
        Nothing   -> return ()
        Just path -> liftIO $ withFile path WriteMode $ \h -> hPutDoc h (ppr (toList unit))

    writeTestBench :: (TextIO a, TextIO b) => Config -> Pipeline a b -> IO ()
    writeTestBench conf p =
      case tb_output conf of
        Nothing   -> return ()
        Just path -> do let tbconf = TB.defaultTestBenchConfig { TB.tb_entity   = tb_entity conf
                                                               , TB.tb_watchdog = tb_watchdog conf
                                                               , TB.tb_compare  = tb_compare conf
                                                               }
                        tb_unit <- evalCg $ TB.vunitTestBench tbconf p
                        withFile path WriteMode $ \h -> hPutDoc h (ppr tb_unit)
