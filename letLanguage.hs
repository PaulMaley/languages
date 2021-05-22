module LetLanguage where
{-
Keep it simple for the moment ... explicitly numbers
-}

--data Program = LetExp
type Var = String
data LLExp = ConstExp Int
                  | DiffExp LLExp  LLExp
                  | ZeroQExp LLExp
                  | IfExp LLExp LLExp LLExp
                  | VarExp Var
                  | LetExp Var LLExp LLExp
                  deriving (Show)
  
