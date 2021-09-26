module Opt where

import Control.Monad ( when )
import System.Console.GetOpt
import System.Environment
import System.IO

data Variant = Serial | Parallel

data Config = Config { help          :: Bool
                     , variant       :: Variant
                     , output        :: Maybe FilePath
                     , tb_output     :: Maybe FilePath
                     , tv_len        :: Int
                     , tv_in_output  :: Maybe FilePath
                     , tv_out_output :: Maybe FilePath
                     }

defaultOptions :: Config
defaultOptions = Config { help          = False
                        , variant       = Serial
                        , output        = Nothing
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
      (o_,n,[])  -> do let o = foldl (flip id) defaultOptions o_
                       when (help o) $
                         hPutStrLn stderr (usageInfo header options)
                       return (o,n)
      (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
