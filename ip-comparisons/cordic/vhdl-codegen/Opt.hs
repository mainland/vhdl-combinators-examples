{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE OverloadedStrings #-}

module Opt where

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

data Mode = Vectoring | Rotating

data Config = Config { help        :: Bool           -- ^ Show help
                     , variant     :: Variant        -- ^ Pipeline variant
                     , mode        :: Mode           -- ^ CORDIC mode
                     , iterations  :: Int            -- ^ Number of Iterations
                     , output      :: Maybe FilePath -- ^ VHDL output
                     , tb_compare  :: Bool           -- ^ True if test bench should compare to output,
                     , tb_output   :: Maybe FilePath -- ^ VHDL test bench output
                     , tv_len        :: Int
                     , tv_in_output  :: Maybe FilePath
                     , tv_out_output :: Maybe FilePath
                     }

defaultConfig :: Config
defaultConfig = Config { help          = False
                       , variant       = Parallel
                       , mode          = Rotating
                       , iterations    = 32
                       , output        = Nothing
                       , tb_compare    = True
                       , tb_output     = Nothing
                       , tv_len        = 100
                       , tv_in_output  = Nothing
                       , tv_out_output = Nothing
                       }

options :: [OptDescr (Config -> Config)]
options =
    [ Option ['h'] ["help"]      (NoArg (\conf -> conf { help = True }))                            "show help"
    , Option ['s'] ["serial"]    (NoArg (\conf -> conf { variant = Serial }))                       "generate serial version"
    , Option ['p'] ["parallel"]  (NoArg (\conf -> conf { variant = Parallel }))                     "generate parallel version"
    , Option ['b'] ["bubbles"]   (NoArg (\conf -> conf { variant = ParallelBubbles }))              "generate parallel version (with pipeline bubbles)"
    , Option ['v'] ["vectoring"] (NoArg (\conf -> conf { mode = Vectoring }))                       "Vectoring mode of CORDIC"
    , Option ['r'] ["rotating"]  (NoArg (\conf -> conf { mode = Rotating }))                        "Rotating mode of CORDIC"
    , Option ['i'] ["iterations"](ReqArg (\iterations conf -> conf { iterations = read iterations })"Iterations")"number of iterations"
    , Option ['o'] ["output"]    (ReqArg (\path conf -> conf { output = Just path }) "FILE")        "output FILE"
    , Option ['t'] ["testbench"] (ReqArg (\path conf -> conf { tb_output = Just path }) "FILE")     "testbench output FILE"
    , Option ['n'] ["tvlen"]     (ReqArg (\n conf -> conf { tv_len = read n }) "N")                 "test vector length"
    , Option []    ["tvinput"]   (ReqArg (\path conf -> conf { tv_in_output = Just path }) "FILE")  "write test vector inputs to FILE"
    , Option []    ["tvoutput"]  (ReqArg (\path conf -> conf { tv_out_output = Just path }) "FILE") "write test vector outputs to FILE"
    ]

compilerOpts :: [String] -> IO (Config, [String])
compilerOpts argv = do
  progName <- getProgName
  let header = "Usage: " ++ progName ++ " [OPTION...]"
  case getOpt Permute options argv of
      (o_,n,[])  -> do let o = foldl (flip id) defaultConfig o_
                       when (help o) $
                         hPutStrLn stderr (usageInfo header options)
                       return (o,n)
      (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
