--
-- data definition to move into dataTypes
--

-- Define the interface

module Store where

import DataTypes

{-
  empty - sets up a new Store
  newRef - takes an expression, calculates its value 
           and shoves it into the store returning a ref
           to the stored value
  deRef - returns a value from the store
  setRef - MODIFIES the store
-}

{-
class Store str where 
  empty :: str
  newRef :: Val -> str -> (Val,str)
  deRef :: Val -> str -> Val
  setRef :: Val -> Val -> str -> str
-}

-- Implementation
-- References are integers 0,1, ...
-- The store only increases in size ..... nothing is 
-- removed (for the mo). Need to store as (ref,val)
-- pairs as adding new elements changes the indices !
-- element at 0 becomes the element at 1 ....

--data SIS = SIS [(Val,Val)] deriving (Show)

instance Store SIS where
  empty = SIS []
  newRef val (SIS str) = let ref = RefVal (length str) in (ref, SIS ((ref,val):str))
  deRef (RefVal n) (SIS str) = let cmp r (RefVal r', val) = r == r' 
                                   find r [] = error "Not in store"
                                   find r (x:xs) = if cmp r x 
                                                   then (snd x)
                                                   else find r xs                            
                               in
                                 find n str 
     
  --setRef (RefVal n) newval str = error "Not implemented" 

  setRef (RefVal n) val (SIS str) = let cmp r (RefVal r', val) = r == r'
                                        replace _ _ str' [] = str'
                                        replace r val str' (x:xs) = if cmp r x
                                                                    then replace r val ((RefVal n,val):str') xs
                                                                    else replace r val (x:str') xs
                                    in
                                      SIS (replace n val [] str)   






