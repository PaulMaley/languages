{-
Read in a string from the command line, parse and 
evaluate it according to the Let language with an
empty environment
-}

import System.IO
import DataTypes
import Parser
import ParseLet
import LetEval
import Env

main = do
         s <- getLine
         let v = case parse lexp s of
                   [] -> "Failed to parse expression"
                   [(e,_)] ->  show(valueOf e LPVEmpty) 
         putStrLn v
