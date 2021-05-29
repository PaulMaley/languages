module Env where

{-
Introduce types ... environment can now contain variables of different
types
-}

import DataTypes
--import LetLanguage

--type Var = String
--type Val = Int
--data Val = BoolVal Bool | NumVal Int deriving (Show)

{-
TODO:
1) Deal with a call to applyEnv when the variable is not defined in the 
environment ..
2) Adding a variable which is already there .... It seems to be correct
to have two entries ... like shadowing ?
-}
{-
class Environment env where 
  emptyEnv :: env
  applyEnv :: env -> Var -> Val
  extendEnv :: Var -> Val -> env -> env
-}

-- An implentation
--data LPV = LPVEmpty | LPV [(Var,Val)] deriving (Show)

get :: Var -> LPV -> Val
get v LPVEmpty = error "Environment is empty!!"
get v (LPV ((e1var,e1val):es)) 
  | v == e1var = e1val
  | otherwise = get v (LPV es)

instance Environment LPV where
  emptyEnv = LPVEmpty
  applyEnv e var = get var e
  extendEnv var val LPVEmpty = LPV ((var,val):[])
  extendEnv var val (LPV e) = LPV ((var,val):e)


