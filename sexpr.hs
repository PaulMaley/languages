{-
Friedman & Wand p 8
S-expr grammer (symbols are space delimited strings)
Parser returns .... what ? Let's try a nested list of strings   

For the moment a valid symbol is anything accepted
by the "identifier" function ... update later 

S-list ::= ({S-exp}^*)
S-exp  ::= Symbol | S-list

Examples
() <-- This is not allowed (use some rather than many) in slist
(a b)
(a b (c (d)) e f)

NB: Empty lists () are disallowed by the parser, not by the data 
    specification which I think would need to be changed ...
-}

import Parser
import Control.Applicative

-- Data type  
data SExp a = Sym a | SList [SExp a] deriving (Show)


-- Parse S-List
slist :: Parser (SExp String) 
slist = do symbol "("
--           e <-  many sexp
           e <-  some sexp
           symbol ")"
           return (SList e)

-- Parse S-Expr 
sexp :: Parser (SExp String)
sexp = do 
         s <- identifier
         return (Sym s)
        <|> 
         slist

-- Substitution of one symbol by another
-- This is not good .... It's a partial function ... Need to change data type
-- usage: subst (Sym new) (Sym old) ast 
-- where ast = (fst . head) $ parse sexp "(...)"
subst :: (Eq a) => SExp a -> SExp a -> SExp a -> SExp a
subst (Sym new) (Sym old) sexp = case sexp of 
                                  Sym x -> if (x == old) then (Sym new) else (Sym x) 
                                  SList ss -> SList (map (subst (Sym new) (Sym old)) ss)
subst _ _ _ = error "First two arguements must be Smbols"  





  


