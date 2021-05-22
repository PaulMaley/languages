{-
Alternative ... function based as opposed to data based 

IT FUCKING WORKS !!!
-}
type Var = String
type Val = String

-- Just a note ... what about applyEnv when
-- the variable is not defined in the environment ..
class Environment env where 
  emptyEnv :: env
  applyEnv :: env -> Var -> Val
  extendEnv :: Var -> Val -> env -> env

-- An implentation (Need to wrap in a constructor)
newtype FEnv = FEnv (Var -> Val) 

-- Use Functor to make it accesible ???
-- instance Functor FEnv where 
--   fmap f (FEnv x) = FEnv (f x)


instance Environment FEnv where
  --emptyEnv :: FEnv
  emptyEnv = FEnv (\var -> "Fuck Up!!")
  applyEnv (FEnv e) var = e var
  extendEnv var val env = FEnv (\v -> if v == var 
                                      then val 
                                      else (applyEnv env v)) 


{-
data LPV = LPVEmpty | LPV [(Var,Val)] deriving (Show)

get :: Var -> LPV -> Val
get v LPVEmpty = "Fuck Up!!"
get v (LPV ((e1var,e1val):es)) 
  | v == e1var = e1val
  | otherwise = get v (LPV es)

instance Environment LPV where
  emptyEnv = LPVEmpty
  applyEnv e var = get var e
  extendEnv var val LPVEmpty = LPV ((var,val):[])
  extendEnv var val (LPV e) = LPV ((var,val):e)
-}

