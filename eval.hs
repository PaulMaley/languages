{-
Read in a string from the command line, parse and 
evaluate it according to the Let language with an
empty environment
Upgrade: parse an execution environment ...

usage example: ./eval "If(ZeroQ(-(3,x)),1,y)" "[x=2,y=3]"
-}

import System.Environment 
import System.IO
--import DataTypes
import Parser
import ParseLet
import ParseEnv
import LetEval
import Env


main = do
         args <- getArgs
         let out = case args of
                     (exp:env:[]) -> evaluate exp env
                     (exp:[]) -> evaluate exp "[]"
                     _ -> "usage: ./eval <<Let Expression>>  <<Envrionment>>" 
         putStrLn out

evaluate :: String -> String -> String 
evaluate exp env = let pexp = parse lexp exp
                       penv = parse senvLPV env
                   in case (pexp,penv) of
                       ([],_) -> "Failed to parse expresssion"
                       (_,[]) -> "Failed to parse environment"
                       ([(exp',_)],[(env',_)]) -> show (valueOf exp' env')

