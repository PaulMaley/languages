module Trace where 

{-
Want two implementations
1) Does nothing (i.e. no trace)
2) Logs entry/exit into valueOf, long with the environment and the store
-}

import DataTypes

-- Basic log
instance Trace BT where
--tlog :: String -> Trace BT -> Trace BT
  tlog t (T ts) = T (t:ts) 
--tloga :: Environment env => Entry -> env -> tr
  tloga t env (T ts)  = T (("[{" ++ t ++ "}{" ++ show(env) ++ "}]"):ts) 


instance Trace NulTr where
  tlog _ NulTr = NulTr   
  tloga _ _ NulTr = NulTr
 
