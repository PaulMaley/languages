{-
OK, this is a wierd mxture of stuff ... but what the hell
Ex: Var is the same idea in both modules ... 

The environment returns only strings as values .. but in 
this language we need numbers and booleans ... 

In the book the env returns SchemeTypes !!

Also modify a bit ..... remove the Zero constructor ...
-}
module LetEval (valueOf) where

import qualified Env as E
import qualified LetLanguage as L


-- this is "eval" but I'm following the book ...
valueOf :: E.Environment env => L.LLExp -> env -> Int 
valueOf (L.ConstExp x)  _  = x 
valueOf (L.VarExp s) env = E.applyEnv env s
valueOf (L.DiffExp e1 e2) env = (valueOf e1 env)-(valueOf e2 env)
valueOf (L.LetExp var valexp bodyexp) env = valueOf bodyexp 
                                            (E.extendEnv var (valueOf valexp env) env)
valueOf (L.IfExp pred et ef) env = if (valueOf pred env) == 0
                                   then valueOf et env
                                   else valueOf ef env
valueOf _ _ = error "Not implemented"


