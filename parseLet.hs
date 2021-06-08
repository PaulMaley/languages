{-
parse a string into a LetLanguage AST

examples ...
-(2,3) ->  DiffExp (Const 2) (Const 3)
-(2,x) -> DiffExp (Const 2) (Var "x")  -- "x" will be (hopefully) in the enrironment
-(3,-(1,3)) ->  DiffExp (Const 3) (DiffExp (Const 1) (Const 3))
if(-(2,x),2,3) -> IfExp (DiffExp (Const 2) (Var "x")) (Const 2) (Const 3) 

Grammer 
-}

module ParseLet where

import Parser
import Control.Applicative
import DataTypes

lexp :: Parser LLExp
lexp = do
        e <- lconst
        return e
       <|> lvar
       <|> ldiff
       <|> lif
       <|> lzeroq
       <|> llet
       <|> lproc
       <|> lcall
       <|> lletrec
       <|> lnewref
       <|> lderef
       <|> lsetref

lconst :: Parser LLExp
lconst = do
          n <- integer
          return (ConstExp (NumVal n))
         <|> do
               e <- symbol "True"
               return (ConstExp (BoolVal True))
         <|> do
               e <- symbol "False"
               return (ConstExp (BoolVal False))

lvar :: Parser LLExp 
lvar = do 
        s <- identifier
        return (VarExp s)

ldiff :: Parser LLExp
ldiff = do
         symbol "-("
         e1 <- lexp
         symbol ","
         e2 <- lexp 
         symbol ")"
         return (DiffExp e1 e2)

lif :: Parser LLExp
lif = do
        symbol "If("
        ep <- lexp
        symbol ","
        et <- lexp
        symbol ","
        ef <- lexp
        symbol ")"
        return (IfExp ep et ef) 

lzeroq :: Parser LLExp
lzeroq = do
           symbol "ZeroQ("
           ep <- lexp
           symbol ")"
           return (ZeroQExp ep)

llet :: Parser LLExp
llet = do
         symbol "Let"
         s <- identifier
         symbol "=" 
         val <- lexp
         symbol "In"
         body <- lexp
         return (LetExp s val body)

lproc :: Parser LLExp
lproc = do 
          symbol "Proc"
          symbol "("
          id <- identifier
          symbol ")"
          body <- lexp
          return (ProcExp id body)

lcall :: Parser LLExp
lcall = do
          symbol "("
          rator <- lexp
          rand <- lexp
          symbol ")"
          return (CallExp rator rand)

lletrec :: Parser LLExp
lletrec = do
         symbol "Letrec"
         fid <- identifier
         symbol "("
         pid <- identifier
         symbol ")"
         symbol "=" 
         fbody <- lexp
         symbol "In"
         letrecexp <- lexp
         return (LetRecExp fid pid fbody letrecexp)

lnewref :: Parser LLExp
lnewref = do
            symbol "NewRef"
            symbol "("
            e <- lexp
            symbol ")"
            return (NewRefExp e)

lderef :: Parser LLExp
lderef = do 
           symbol "DeRef"
           symbol "("
           e <- lexp
           symbol ")"
           return (DeRefExp e)

lsetref :: Parser LLExp
lsetref = do 
            symbol "SetRef"
            symbol "("
            id <- lexp
            symbol ","
            val <- lexp
            symbol ")"
            return (SetRefExp id val)








         

