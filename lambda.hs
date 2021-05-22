{-
From Friedman and Wand p9 & 18
(with help from Bor0)
-}

-- Lamda expressions (Is this a faithful implementation ?
-- To understand ... why I can't put LcVar in the LcAbs definition
type Ident = String
data LcExp = LcVar Ident         -- Identifier 
           | LcAbs Ident LcExp   -- Abstraction 
           | LcApp LcExp  LcExp  -- Application

-- Test if a 
occursFree :: Ident -> LcExp -> Bool
occursFree x exp = case exp of 
                     (LcVar y) -> x == y 
                     (LcAbs y exp) -> (x /= y) && (occursFree x exp)
                     (LcApp e e') -> (occursFree x e) || (occursFree x e')


