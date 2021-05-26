{-
Want to specify an environment by a string

Environments are constructed via repeated application
of extendEnv to an initially empty environment 

e1 = extend "x" (NumVal 3) emptyEnv
e2 = extend "y" (NumVal 4) e1
...

Define a language 
Env ::= [] | [Var1=Val1, Var2=Val2,  ... ]

Var are Strings
Val need a type; example: "x=5" becomes (Var="x", Val=(NumVal 5)) 
                          "b=T" gives (Var="b", val=(BoolVal True))

Env ::= [] | [ExtList]
ExtList ::= Ext | Ext , ExtList
Ext ::= Var = Val
Val ::= NumVal n | BoolVal (T|F)
-}

import Control.Applicative
import Data.Foldable
import DataTypes
import Parser
import Env


senv :: Environment a => Parser a
senv = do 
         symbol "["
         space
         symbol "]"
         return emptyEnv
        <|>
         do
           symbol "["
           env <- sextlist
           symbol "]"
           return env


sextlist :: Environment a => Parser a
sextlist = do
             (var,val) <- sext
             symbol ","
             es <- sextlist
             return (extendEnv var val es)
            <|> 
             do
               (var,val) <- sext
               return (extendEnv var val emptyEnv)


sext :: Parser (Var, Val)
sext = do 
         snumvar
        <|>
         sboolvar


snumvar :: Parser (Var, Val)
snumvar = do
            var <- identifier
            symbol "="
            val <- integer
            return (var, NumVal val)


sboolvar :: Parser (Var, Val)
sboolvar = do
             var <- identifier
             symbol "="
             symbol "T"
             return (var, BoolVal True)
            <|>
             do            
               var <- identifier
               symbol "="
               symbol "F"
               return (var, BoolVal False)




-- LPV Implementation

senvLPV :: Parser LPV
senvLPV = senv

