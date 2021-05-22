module Env where

type Var = String
--type Val = String
type Val = Int
--data Val = BoolVal bool | NumVal Int

{-
Just a note ... what about applyEnv when
the variable is not defined in the environment ..
also ... adding a variable which is already there ....
things to remedy obviously
-}

class Environment env where 
  emptyEnv :: env
  applyEnv :: env -> Var -> Val
  extendEnv :: Var -> Val -> env -> env


-- An implentation
data LPV = LPVEmpty | LPV [(Var,Val)] deriving (Show)

get :: Var -> LPV -> Val
get v LPVEmpty = error "Fuck Up!!"
get v (LPV ((e1var,e1val):es)) 
  | v == e1var = e1val
  | otherwise = get v (LPV es)

instance Environment LPV where
  emptyEnv = LPVEmpty
  applyEnv e var = get var e
  extendEnv var val LPVEmpty = LPV ((var,val):[])
  extendEnv var val (LPV e) = LPV ((var,val):e)


