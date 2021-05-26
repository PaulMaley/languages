module DataTypes where 

type Var = String
data Val = BoolVal Bool | NumVal Int deriving (Show)

getNum :: Val -> Int
getNum (NumVal n) = n
getNum _ = error "Non numeric value"

getBool :: Val -> Bool
getBool (BoolVal b) = b
getBool _ = error "Non boolean type"


