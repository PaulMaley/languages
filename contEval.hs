{-
Return to Retlec - i.e. pre-store. This seems to be the kick-off
point for chaptes 5 -> 7. Continuation interpreters and Types.

Try to use the same DataTypes module to start with ... if it 
doesn't work out then make a new copy and cut the irrelevant stuff.

ALSO, this time try to implement with Monads !!
 - Reader for the environment, 
 - IO So that Ican print stuff out (printf baby).
 - For the continuation ??

Ignore the Monads to get started !! 
-}

--module ContEval (valueOf) where
module ContEval  where

import DataTypes
import Env 

--type FinalVal = IO Val

--data Cont = EndCont | Cont
--data Cont = EndCont | C (Val -> FinalVal) 
data Cont = EndCont | C (Val -> Val) 
--type Cont = (Val -> FinalVal) 

extendContZeroQ :: Cont -> Cont
extendContZeroQ c = C (\(NumVal n) -> applyCont c (if n==0 then (BoolVal True) else (BoolVal False)))

extendContLet :: Var -> LLExp -> Env -> Cont -> Cont
extendContLet var body env c = C (\val -> applyCont c (valueOf body (extendEnv var val env) c))

extendContIf te fe env c = C (\(BoolVal b) -> if b 
                                              then (valueOf te env c) 
                                              else (valueOf fe env c))

--2nd function can be simplified .. and remove the need to pass the environment)
extendContDiff1 e2 env c = C (\n1 -> valueOf e2 env (extendContDiff2 n1 env c))
extendContDiff2 n1 env c = C (\n2 -> let (NumVal nn1) = n1
                                         (NumVal nn2) = n2
                                     in
                                       valueOf (ConstExp (NumVal (nn1-nn2))) env c) 
                                       -- NumVal (nn1-nn2) -- Simpler version

--extendContCallRator :: LLExp -> Env -> Cont -> Cont
extendContCallRator rand env c = C (\proc -> valueOf rand env (extendContCallRand proc env c)) 
extendContCallRand proc env c = C (\val -> let env1 = extendEnv (getVarFromProc proc) val env 
                                               exp = getBodyFromProc proc
                                           in valueOf exp env1 c)

applyCont :: Cont -> Val -> Val
applyCont EndCont val = val 
applyCont (C c) val = (c val) 

--valueOf :: LLExp -> Env -> Cont -> FinalVal
valueOf :: LLExp -> Env -> Cont -> Val
valueOf (ConstExp val) _ cont = applyCont cont val
valueOf (VarExp var) env cont = applyCont cont (applyEnv env var)
valueOf (ProcExp var body) env cont = applyCont cont (ProcVal var body env)

valueOf (CallExp rator rand) env cont = valueOf rator env (extendContCallRator rand env cont)
  
valueOf (ZeroQExp exp) env cont = valueOf exp env (extendContZeroQ cont)
valueOf (LetExp var exp body) env cont = valueOf exp env (extendContLet var body env cont)
valueOf (IfExp ce te fe) env cont = valueOf ce env (extendContIf te fe env cont)
valueOf (DiffExp e1 e2) env cont = valueOf e1 env (extendContDiff1 e2 env cont)

valueOf (LetRecExp fvar pvar  body appln) env cont = undefined -- This will cause problems !!








