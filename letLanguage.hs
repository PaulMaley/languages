module LetLanguage where


--data Program = LetExp
type Var = String
data LLExp a = ConstExp a
                  | DiffExp (LLExp a) (LLExp a)
                  | ZeroQExp (LLExp a)
                  | IfExp (LLExp a) (LLExp a) (LLExp a)
                  | VarExp Var
                  | LetExp Var (LLExp a) (LLExp a) 
                  deriving (Show)
  
