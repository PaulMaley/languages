# Project for learning Haskell #

 - Learning haskell because ... why not?  
 - Also studying Freidman and Wand, trying to implement the
stuff in Haskell as opposed to Scheme.  
 - Pretty clear I'm no computor scientist.
 - Took the parsing code from Hutton

In the code all `symbol`s (`If`, `Let`, etc.) start with a capital
letter, this is so they don't get picked up by the `identifier`
parser. 
 
First milestone: `eval` program.
```
usage: ./eval <<LetExpression>> <<Environment>>
```  
examples:
```
./eval "Let x = 3 In - (x,y)" "[y=2]"
./eval "-(y,Let x = 0 In -(x,z))" "[x=0,y=1,z=2]"
```

Next step -- procedures ....

Combined `dataTypes` and `letLanguage` modules ... othewise circular dependancy not accepted.  
New `proc` data type seems to be acceptable:  
```
*LetLanguage> ProcVal "y" (IfExp (ZeroQExp (VarExp "y")) (ConstExp (NumVal 1)) (ConstExp (NumVal 2)))
ProcVal "y" (IfExp (ZeroQExp (VarExp "y")) (ConstExp (NumVal 1)) (ConstExp (NumVal 2)))
```

Hmmm ... this is harder than it looks (and it looks already hard). Refactored the code due to 
mutually dependent modules. All data types are now togther in one place.

OK, works !! Minor miracle. Even correctly evaluates the program at the top of page 76.


