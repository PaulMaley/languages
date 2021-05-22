{-
The grammer: 
expr   ::= term (+ expr | eps)
term   ::= factor (* term  | eps)
factor ::= (expr) | nat
nat    ::= 0 | 1 | .. 

Upgrade required for :
(int ::= ...-1 | 0 | 1 ...) 
-}

import Parser
import Control.Applicative

expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
            <|> return t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return (f * t)
            <|> return f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")" 
            return e
         <|> natural


eval :: String -> Int
eval xs = case (parse expr xs) of
            [(n,[])]  -> n
            [(_,out)] -> error ("Unused input "++out)
            []        -> error "Invalid imput -- helpful message" 




