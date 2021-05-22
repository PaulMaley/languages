{-
Check for correct nesting of parentheses
Gives True for correct bracketing, False otherwise

Step 1: Only ( and ) in the strings
expr ::= expr expr | (expr) | ()  

Grammer impleented !!
!! Reversing prexpr and brexpr in the first production 
cauese an infinite loop ... to understand !! 
prexpr ::= brexpr prexpr | brexpr
brexpr ::= (prexpr) | terminal
terminal ::= ()

-}

import Parser
import Control.Applicative

terminal :: Parser Bool
terminal = do symbol "(" 
              symbol ")" 
              return True

brexpr :: Parser Bool
brexpr = do symbol "("
            e <- prexpr
            symbol ")"
            return True
           <|> terminal

prexpr :: Parser Bool
prexpr = do e <- brexpr
            f <- prexpr
            return (e && f)
           <|> brexpr

eval :: String -> Bool
eval xs = case (parse prexpr xs) of 
            [(v,[])]  -> v
            _ -> False
            

