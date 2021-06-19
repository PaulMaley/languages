{-
Upgrade to use types in the environment

OK, this is a wierd mxture of stuff ... but what the hell
Ex: Var is the same idea in both modules ... 

The environment returns only strings as values .. but in 
this language we need numbers and booleans ... 

In the book the env returns SchemeTypes !!

Also modify a bit ..... remove the Zero constructor ...

Upgrade to include Store ...

"Upgrade" to include a trace facility
-}
module LetEval (valueOf) where

import DataTypes
import Env 
import Store 
import Trace

valueOf :: Trace t => LLExp -> Env -> Str -> t -> (Val,Str,t)
valueOf exp env str tr = case exp of 
                           (ConstExp x) -> (x,str,tloga ("ConstExp:"++show(x)) env tr)
                           (VarExp id) -> ((applyEnv env id),str,tloga ("VarExp:"++id) env tr)

                           (ZeroQExp e) -> let tr' = tloga ("ZeroQExp:"++show(e)) env tr
                                               (v,str1,tr1) = valueOf e env str tr'
                                           in
                                             (BoolVal (if getNum v  == 0 
                                                       then True
                                                       else False), str1, tr1)

                           (DiffExp e1 e2) -> let tr' = tloga ("DiffExp:"++show(e1)++" "++show(e2)) env tr 
                                                  (val1, s1, tr1) = valueOf e1 env str tr'
                                                  (val2, s2, tr2) = valueOf e2 env s1 tr1
                                              in
                                                (NumVal ((getNum val1) - (getNum val2)), s2, tr2)

                           (LetExp var valexp bodyexp) -> let tr' = tloga ("LetExp:" ++ var ++ " " ++
                                                                           show(valexp) ++ " " ++
                                                                           show(bodyexp)) env tr
                                                              (val,s1,tr1) = valueOf valexp env str tr'
                                                          in
                                                            valueOf bodyexp (extendEnv var val env) s1 tr1  

                           (IfExp pred et ef) -> let tr' = tloga ("IfExp:" ++ show(pred) ++ " " ++ 
                                                                  show(et) ++ " " ++ show(ef)) env tr
                                                     (b,s1,tr1) = valueOf pred env str tr'
                                                     selexp = if (getBool b) 
                                                              then et 
                                                              else ef 
                                                 in 
                                                   valueOf selexp env s1 tr1 

                           (ProcExp var bodyexp) -> let tr1 = tloga ("ProcExp:" ++ var ++ " " ++ show(bodyexp)) env tr
                                                    in 
                                                      (ProcVal var bodyexp env, str, tr1) 

                           (CallExp rator rand) -> let tr' = tloga ("CallExp:" ++ show(rator) ++
                                                                                  show(rand)) env tr 
                                                       (proc,s1,tr1) = valueOf rator env str tr' 
                                                       (rand',s2,tr2) = valueOf rand env s1 tr1 
                                                       rho1 = extendEnv (getVarFromProc proc) 
                                                                        rand' 
                                                                        (getEnvFromProc proc)
                                                       rho2 = case proc of 
                                                                (ProcVal _ _ _) -> rho1
                                                                (RecProcVal fid pid body env) -> extendEnv fid proc rho1
                                                   in 
                                                     valueOf (getBodyFromProc proc) rho2 s2 tr2 
{-
                           (CallExp rator rand) -> let tr' = tloga ("CallExp:" ++ show(rator) ++
                                                                                  show(rand)) env tr 
                                                       (proc,s1,tr1) = valueOf rator env str tr' 
                                                       (rand',s2,tr2) = valueOf rand env s1 tr1 
                                                       rho1 = extendEnv (getVarFromProc proc) 
                                                                        rand' 
                                                                        (getEnvFromProc proc)
                                                   in 
                                                     valueOf (getBodyFromProc proc) rho1 s2 tr2 
-}
                           (BeginExp (e:[])) -> let tr' = tloga ("BeginExp:" ++ show(e)) env tr
                                                in
                                                  valueOf e env str tr'  
                           (BeginExp (e:es)) -> let tr' = tloga ("BeginExp:" ++ show(e)) env tr
                                                    (v,s1,tr1) = valueOf e env str tr'
                                                in
                                                  valueOf (BeginExp es) env s1 tr1

                           (NewRefExp e) -> let tr' = tloga ("NewRefExp:" ++ show(e)) env tr 
                                                (val1,s1,t1) = valueOf e env str tr'
                                                (val2,s2) = newRef val1 s1    
                                            in
                                              (val2,s2,t1) 

                           (DeRefExp e) -> let tr' = tloga ("DeRefExp:" ++ show(e)) env tr
                                               (val1,s1,t1) = valueOf e env str tr'
                                           in
                                             (deRef val1 s1,s1,t1)


                           (SetRefExp e v) -> let tr' = tloga ("SetRefExp:" ++ show(e) ++ " " ++ show(v)) env tr 
                                                  (rval,s1,t1) = valueOf e env str tr'
                                                  (vval,s2,t2) = valueOf v env s1 t1
                                                  s3 = setRef rval vval s2
                                              in
                                                (vval,s3,t2) 


                           (LetRecExp fid pid fbody letrecexp) -> let tr' = tloga ("LetRecExp:") env tr
                                                                  in 
                                                                    valueOf letrecexp 
                                                                       (extendEnv fid (RecProcVal fid pid fbody env) env) 
                                                                       str tr'

{--
-- To reimplement !!
-- Requires modification to extendEnv ??
-- According to the book - yes

                        (LetRecExp fid pid fbody letrecexp) -> valueOf letrecexp 
                                                                       (extendEnv fid (ProcVal pid fbody env) env) 
                                                                       str
--}
