{-
Stand-alone to try out using statements in conjunction
with expressions. Develop on the side to start with
-}

module DataStatements where 


type Var = String

data Val = BoolVal Bool
         | NumVal Int
         deriving (Show)

data LLExp = ConstExp Val
           | VarExp Var
           | DiffExp LLExp LLExp
           deriving (Show)

data LStat = LStatList [LStat]
           | LStatPrint LLExp
           | LStatAssign Var LLExp
           deriving (Show) 


