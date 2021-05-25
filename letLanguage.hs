module LetLanguage where
{-
Keep it simple for the moment ... explicitly numbers
Upgrade ... different data types (Bools and Ints) 
-}

import DataTypes

--data Program = LetExp
--type Var = String
data LLExp = ConstExp Val
                  | DiffExp LLExp  LLExp
                  | ZeroQExp LLExp
                  | IfExp LLExp LLExp LLExp
                  | VarExp Var
                  | LetExp Var LLExp LLExp
                  deriving (Show)
  
