module EvalStatements where

import Control.Monad
import Control.Monad.State

import DataStatements

{-
OK, Second attmept to mix statements and expressions
 - No environment (store takes its place - global env)
 - State is a list of (Var, Val) pairs
-}

type MyState a = StateT [(Var,Val)] IO a

emptyState :: MyState ()
emptyState = return ()

find :: String -> [(Var,Val)] -> Val
find _ [] = error "Variable not found"
find var ((xvar,xval):xs) | var == xvar = xval
                          | otherwise = find var xs
                             
-- evaluate an expression
eval :: LLExp -> MyState Val
eval (ConstExp val) = return val
eval (VarExp var) = do 
                      ss <- get 
                      let val = find var ss
                      return val 
eval (DiffExp e1 e2) = do
                         (NumVal n1) <- eval e1
                         (NumVal n2) <- eval e2
                         return (NumVal (n1-n2)) 

{-
First try out ok ....
EvalStatements> runStateT (eval (ConstExp (NumVal 1))) []
(NumVal 1,[])
EvalStatements> runStateT (eval (ConstExp (NumVal 1))) [("x",NumVal 2)]
(NumVal 1,[("x",NumVal 2)])
EvalStatements> runStateT (eval (VarExp "x")) [("x",NumVal 2)]
(NumVal 2,[("x",NumVal 2)])
EvalStatements> runStateT (eval (DiffExp (VarExp "x") (ConstExp (NumVal 1)))) [("x",NumVal 2)]
(NumVal 1,[("x",NumVal 2)])
EvalStatements> runStateT (eval (DiffExp (VarExp "x") (ConstExp (NumVal 1)))) [("x",NumVal 20)]
(NumVal 19,[("x",NumVal 20)])-}


-- Execute statements : They return nothing
execute :: LStat -> MyState () 
execute (LStatPrint exp) = do
                             val <- eval exp
--                             (lift . putStrLn) (show val)
                             (lift . putStrLn) $ (show exp) ++ " = "++ (show val)


execute (LStatAssign var exp) = do
                                  ss <- get
                                  val <- eval exp
                                  put ((var, val):ss)
                                  return ()

execute (LStatList []) = return ()
execute (LStatList (s:ss)) = do 
                               execute s
                               execute (LStatList ss)
                               return () 

{-
Man, even this works .....
Eval> runStateT (execute (LStatPrint (ConstExp (NumVal 1)))) []
NumVal 1
((),[])
Eval> runStateT (execute (LStatPrint (VarExp "x"))) [("x",NumVal 3)]
NumVal 3
((),[("x",NumVal 3)])
Eval> runStateT (execute (LStatAssign "x" (ConstExp (NumVal 3)))) []
((),[("x",NumVal 3)])
-- Major league success. Statement list, Assignment and printing 
Eval> runStateT (execute (LStatList [(LStatAssign "x" (ConstExp (NumVal 4))), (LStatPrint (VarExp "x"))])) []
NumVal 4
((),[("x",NumVal 4)])
-}



