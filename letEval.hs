{-
OK, this is a wierd mxture of stuff ... but what the hell
Ex: Var is the same idea in both modules ... 

The environment returns only strings as values .. but in 
this language we need numbers and booleans ... 

In the book the env returns SchemeTypes !!
-}

import qualified Env as E
import qualified LetLanguage as L


-- this is "eval" but I'm following the book ...
valueOf :: E.Environment env => L.LLExp a -> env -> a 
valueOf (L.ConstExp x)  _  = x 
valueOf (L.VarExp s) env = E.applyEnv env s

