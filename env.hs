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
-- Some clean up possible ... LPVEmpty is distinct from LPV []

get :: Var -> LPV -> Val
get v LPVEmpty = error ("Variable " ++ v ++ " not in environment !!")
get v (LPV []) = error ("Variable " ++ v ++ " not in environment !!")
get v (LPV ((e1var, ProcVal pid fbody e):es))
  | v == e1var = ProcVal pid fbody (LPV ((e1var, ProcVal pid fbody e):es))
  | otherwise = get v (LPV es)
get v (LPV ((e1var,e1val):es)) 
  | v == e1var = e1val
  | otherwise = get v (LPV es)

instance Environment LPV where
  emptyEnv = LPVEmpty
  applyEnv e var = get var e
  extendEnv var val LPVEmpty = LPV ((var,val):[])
  extendEnv var val (LPV e) = LPV ((var,val):e)
-- Is this needed ? Given code in get .... seems to work without
{-
  extendEnvRec fid (ProcVal pid fbody env) e = let env' = extendEnv fid (ProcVal pid fbody env) env
                                               in
                                                 extendEnv fid (ProcVal pid fbody env') e 
-}
