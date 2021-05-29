module DataTypes where 

type Var = String
data Val = BoolVal Bool | NumVal Int | ProcVal Var LLExp deriving (Show)

getNum :: Val -> Int
getNum (NumVal n) = n
getNum _ = error "Non numeric value"

getBool :: Val -> Bool
getBool (BoolVal b) = b
getBool _ = error "Non boolean type"

class Environment env where 
  emptyEnv :: env
  applyEnv :: env -> Var -> Val
  extendEnv :: Var -> Val -> env -> env

data LLExp = ConstExp Val
                  | DiffExp LLExp  LLExp
                  | ZeroQExp LLExp
                  | IfExp LLExp LLExp LLExp
                  | VarExp Var
                  | LetExp Var LLExp LLExp
                  | ProcExp Var LLExp
                  | CallExp LLExp LLExp
                  deriving (Show)
