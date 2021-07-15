module ParseStatements where 

{-
A parser for the mini-interpreter based on statements and expressions

The grammer for statements (at least for the par implemented)

Statement ::= Identifier = Expression
          ::= print Expression 
          ::= {{Statement}∗(;) }

For the moment just copy the expression parser from parseLet.hs
since I just copied the data types for expressions

-}

import Parser
import Control.Applicative
import DataStatements


{- Statement parser -}

lstat :: Parser LStat
lstat = do lassign
        <|> lprint 
        <|> lblock 

lassign :: Parser LStat
lassign = do
            ident <- identifier
            symbol "="
            e <- lexp
            return (LStatAssign ident e)

lprint :: Parser LStat
lprint = do 
           symbol "Print"
           e <- lexp 
           return (LStatPrint e)

lblock :: Parser LStat
lblock = do 
           symbol "{"
           sl <- lstatlist
           symbol "}"
           return (LStatList sl)

lstatlist :: Parser [LStat]
lstatlist = do 
              s <- lstat
              symbol ";"
              ss <- lstatlist
              return (s:ss)
            <|> do
                  s <- lstat
                  return [s]

{- Expression parser -}

lexp :: Parser LLExp
lexp = do
        e <- lconst
        return e
       <|> lvar
       <|> ldiff

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

