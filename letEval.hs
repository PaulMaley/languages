{-
Upgrade to use types in the environment

OK, this is a wierd mxture of stuff ... but what the hell
Ex: Var is the same idea in both modules ... 

The environment returns only strings as values .. but in 
this language we need numbers and booleans ... 

In the book the env returns SchemeTypes !!

Also modify a bit ..... remove the Zero constructor ...
-}
module LetEval (valueOf) where

import DataTypes
import Env 
import LetLanguage 

valueOf :: Environment env => LLExp -> env -> Val 
valueOf (ConstExp x)  _  = x 
valueOf (VarExp s) env = applyEnv env s
valueOf (ZeroQExp e) env = if getNum (valueOf e env) == 0 
                             then (BoolVal True)
                             else (BoolVal False)  
valueOf (DiffExp e1 e2) env = NumVal (n1 - n2) 
                              where 
                                n1 = getNum (valueOf e1 env)
                                n2 = getNum (valueOf e2 env)
valueOf (IfExp pred et ef) env = if getBool (valueOf pred env)
                                   then valueOf et env
                                   else valueOf ef env
valueOf (LetExp var valexp bodyexp) env = valueOf bodyexp 
                                            (extendEnv var (valueOf valexp env) env)
--valueOf _ _ = error "Not implemented"

