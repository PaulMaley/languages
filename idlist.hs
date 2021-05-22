{-
Try something simple ... parse a space separated 
list of identifiers into a list of strings

1) OK this works
"a dfd sd " -> ["a","dfd", "sd"]

idList :: Parser [String]
idList = do
           xs <- many identifier
           return xs

2) Now try strings or "()" ... need a data type
"asd () as as" -> ["asd", [], "as", "as"]

Amazing, but this "works" as well 

data Id a = Id a | Idl [a] deriving (Show) 
  
idl :: Parser [(Id String)]
idl = do 
        x <- identifier 
        xs <- idl 
        return ((Id x) : xs) 
       <|> do (symbol "()")
              xs <- idl
              return ((Idl ["()"]) : xs)
       <|> do space
              return []

3) Try to nest lists ....
grammer :

list ::= id | id list
-}

import Parser
import Control.Applicative


data Id a = Id a | Idl [a] deriving (Show) 


idList :: Parser [String]
idList = do
           xs <- many identifier
           return xs


idl :: Parser [(Id String)]
idl = do 
        x <- identifier 
        xs <- idl 
        return ((Id x) : xs) 
       <|> do (symbol "(")
              xs <- idl
              (symbol ")")
              return (xs)
       <|> do space
              return []






