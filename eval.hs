{-
Read in a string from the command line, parse and 
evaluate it according to the Let language with an
empty environment
Upgrade: parse an execution environment ...

usage example: ./eval "If(ZeroQ(-(3,x)),1,y)" "[x=2,y=3]"

upgrade to provide help and read from a file



-}

import System.Environment 
import System.IO
import DataTypes
import Parser
import ParseLet
import ParseEnv
import LetEval
import Env
import Store 
import Trace

data Act = Help | ReadFile String | CmdLine

main = do
         args <- getArgs
{-
         let choice = case args of 
                     ("--help":_) -> Help
                     ("--file":fn:_) -> ReadFile fn
                     (exp:env: 
-}
         let out = case args of
                     ("--help":_) -> return usage
                     ("--file":fn:_) -> do
                                          exp <- readFile fn  
                                          return (evaluate exp "[]") 
                     (exp:env:[]) -> return (evaluate exp env)
                     (exp:[]) -> return (evaluate exp "[]")
                     _ -> return usage 
         out' <- out
         putStrLn out'

usage :: String
usage =  "usage: ./eval <<Let Expression>>  <<Envrionment>>" 

evaluate :: String -> String -> String 
evaluate exp env = let pexp = parse lexp exp
                       penv = parse senvLPV env
                   in case (pexp,penv) of
                       ([],_) -> "Failed to parse expresssion"
                       (_,[]) -> "Failed to parse environment"
                       ([(exp',_)],[(env',_)]) -> show (valueOf exp' env' (SIS []) NulTr)  -- Empty Simple Int Store
--                       ([(exp',_)],[(env',_)]) -> show (valueOf exp' env')

