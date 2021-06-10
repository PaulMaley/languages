{-
Upgrade to use types in the environment

OK, this is a wierd mxture of stuff ... but what the hell
Ex: Var is the same idea in both modules ... 

The environment returns only strings as values .. but in 
this language we need numbers and booleans ... 

In the book the env returns SchemeTypes !!

Also modify a bit ..... remove the Zero constructor ...

Upgrade to include Store ...
-}
module LetEval (valueOf) where

import DataTypes
import Env 
import Store 


valueOf :: LLExp -> Env -> Str -> (Val,Str)
valueOf exp env str = case exp of 
                        (ConstExp x) -> (x,str)
                        (VarExp id) -> ((applyEnv env id),str)
                        (ZeroQExp e) -> if (getNum . fst) (valueOf e env str) == 0
                                        then (BoolVal True, str)
                                        else (BoolVal False, str)
                        -- Bug ... doesn't thread the store in the evaluation
                        -- of the two exps !!
                        (DiffExp e1 e2) -> (NumVal (n1-n2), str)
                                           where
                                             n1 = (getNum . fst) (valueOf e1 env str)
                                             n2 = (getNum . fst) (valueOf e2 env str)

                        (LetExp var valexp bodyexp) -> let (val,s1) = valueOf valexp env str
                                                       in
                                                         valueOf bodyexp (extendEnv var val env) s1  
                        (NewRefExp e) -> let (val,s1) = valueOf e env str
                                         in
                                           newRef val s1 

                        (DeRefExp e) -> let (val,s1) = valueOf e env str
                                        in
                                          (deRef val s1, s1)

                        (SetRefExp e v) -> let (rval,s1) = valueOf e env str
                                               (vval,s2) = valueOf v env s1
                                           in
                                             (vval, setRef rval vval s2) 

                        (IfExp pred et ef) -> let (b,s1) = valueOf pred env str 
                                              in 
                                                if getBool b
                                                then valueOf et env s1
                                                else valueOf ef env s1

                        (ProcExp var bodyexp) -> (ProcVal var bodyexp env, str) 

                        (CallExp rator rand) -> let (proc,s1) = valueOf rator env str 
                                                    (rand',s2) = valueOf rand env s1 
                                                    rho1 = extendEnv (getVarFromProc proc) 
                                                                     rand' 
                                                                     (getEnvFromProc proc)
                                                in 
                                                  valueOf (getBodyFromProc proc) rho1 s2 

                        (LetRecExp fid pid fbody letrecexp) -> valueOf letrecexp 
                                                                       (extendEnv fid (ProcVal pid fbody env) env) 
                                                                       str
          
                        (BeginExp (e:[])) -> valueOf e env str  
                        (BeginExp (e:es)) -> let (v,s') = valueOf e env str 
                                             in
                                               valueOf (BeginExp es) env s'

