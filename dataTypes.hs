module DataTypes where 

type Ref = Int

-- Concrete imlpementation of a Trace facility
type Entry = String
data BT = T [Entry] deriving (Show) 
type Tr = BT

data NulTr = NulTr deriving (Show)
type NTr = NulTr

-- Concrete implementation of an environment
data LPV = LPVEmpty | LPV [(Var,Val)] deriving (Show)

-- Concrete implementation of a store
data SIS = SIS [(Val,Val)] deriving (Show)
type Str = SIS

type Var = String
type Env = LPV  
data Val 
         = BoolVal Bool
         | NumVal Int
         | ProcVal Var LLExp Env
         | RecProcVal Var Var LLExp Env
         | RefVal Ref
         deriving (Show)

getNum :: Val -> Int
getNum (NumVal n) = n
getNum _ = error "Non numeric value"

getBool :: Val -> Bool
getBool (BoolVal b) = b
getBool _ = error "Non boolean value"

getVarFromProc :: Val -> Var
getVarFromProc (ProcVal var _ _) = var
getVarFromProc (RecProcVal _ var _ _) = var
getVarFromProc _ = error "Non Proc value"

getBodyFromProc :: Val -> LLExp
getBodyFromProc (ProcVal _ body _) = body
getBodyFromProc (RecProcVal _ _ body _) = body
getBodyFromProc _ = error "Non Proc value"

getEnvFromProc :: Val -> Env
getEnvFromProc (ProcVal _ _ env) = env
getEnvFromProc (RecProcVal _ _ _ env) = env
getEnvFromProc _ = error "Non Proc value"

class Environment env where 
  emptyEnv :: env
  applyEnv :: env -> Var -> Val
  extendEnv :: Var -> Val -> env -> env
-- Doesn't seem to be necessary
--  extendEnvRec :: Var -> Val -> env -> env

class Store str where 
  empty :: str
  newRef :: Val -> str -> (Val,str)
  deRef :: Val -> str -> Val
  setRef :: Val -> Val -> str -> str

class Trace tr where 
  tlog :: Entry -> tr -> tr
  tloga :: (Environment env,Show env) => Entry -> env -> tr -> tr 

data LLExp = ConstExp Val
                  | DiffExp LLExp  LLExp
                  | ZeroQExp LLExp
                  | IfExp LLExp LLExp LLExp
                  | VarExp Var
                  | LetExp Var LLExp LLExp
                  | ProcExp Var LLExp
                  | CallExp LLExp LLExp
                  | LetRecExp Var Var LLExp LLExp
                  | NewRefExp LLExp 
                  | DeRefExp LLExp
                  | SetRefExp LLExp LLExp
                  | BeginExp [LLExp]               -- A bit of a cheat
                  deriving (Show)
