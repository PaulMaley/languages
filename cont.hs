{-
Try to understand the notion of continuation passing !!

Exploratory example: 
Exp::
 - Num Int -- A constant
 - Sum Exp Exp -- Sum x y = x+y
 - Prod Exp Exp -- Prod x y = x*y
 - Sqr Exp -- Square a value
 
What is a continuation in this situation?
-}

data Exp = Num Int | Inc Exp | Sum Exp Exp | Prod Exp Exp | Sqr Exp

{- STEP 1 - Interpreter -}

eval :: Exp -> Int
eval (Num n) = n
eval (Inc e) = (eval e) + 1
eval (Sqr e) = let n = eval e in n*n 
eval (Sum e1 e2) = (eval e1) + (eval e2)
eval (Prod e1 e2) = (eval e1) * (eval e2)  

{- STEP 2 - Continuation -}

newtype Cont = C (Int -> Int)
--applyCont :: Cont -> Int -> Int
--applyCont (C f) x = f x 

extendContSqr :: Cont -> Cont
extendContSqr c = C (\n -> evalC (Num (n*n)) c)

extendContInc :: Cont -> Cont
extendContInc c = C (\n -> evalC (Num (n+1)) c)

extendContSum1 :: Exp -> Cont -> Cont
extendContSum1 e2 c = C (\n1 -> evalC e2 (extendContSum2 n1 c))

extendContSum2 :: Int -> Cont -> Cont
extendContSum2 n1 c = C (\n2 -> evalC (Num (n1+n2)) c)

evalC :: Exp -> Cont -> Int
evalC (Num n) (C c) = c n
evalC (Sqr e) cont = evalC e (extendContSqr cont) 
evalC (Inc e) cont = evalC e (extendContInc cont)
evalC (Sum e1 e2) cont = evalC e1 (extendContSum1 e2 cont)

{-
Equational reasoning:
evalC (Sqr (Inc (Num 1))) (C id)
evalC (Inc (Num 1)) (extendContSqr (C id))
evalC (Inc (Num 1)) (C (\n -> evalC (Num (n*n)) (C id)))
evalC (Inc (Num 1)) (C (\n -> id (n*n)))
evalC (Num 1) (extendContInc ( C (\n -> id (n*n)) ))
evalC (Num 1) (C (\m -> evalC (Num (m+1)) C (\n -> id (n*n)) ))
(\m -> evalC (Num (m+1)) C (\n -> id (n*n)) ) 1
evalC (Num (1+1)) C (\n -> id (n*n))
(\n -> id (n*n)) 2
id 4
4 

Alternative: Shows build up of Continuation
evalC (Num 1) (C (\m -> evalC (Num (m+1)) C (\n -> id (n*n)) ))
evalC (Num 1) (C (\m -> (\n -> id (n*n)) (m+1)  ))
(\m -> (\n -> id (n*n)) (m+1)) 1
(\n -> id (n*n)) (1+1)
id (2*2)
4
-}

{-
Examples: 
Main>  evalC (Num 3) (C id)
3
Main> evalC (Sqr (Num 2)) (C id)
4
Main> evalC (Sum (Sqr (Num 2)) (Num 1)) (C id)
5
Main> evalC (Sum (Sqr (Num 2)) (Sqr (Num 3))) (C id)
13-}





