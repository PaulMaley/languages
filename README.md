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

## Current syntax 
What does the language look like now? Strings that can be parsed: 
```
x  
"x"  
Let "x" = 1 In x  
-(3,4)  
Let x = 1 In -(x,1)  
ZeroQ(x)  
If(ZeroQ(x), x, y)  
Let f = Proc (x) -(x,1) In (f 1)
Let f = Proc (x) Proc (y) -(x,-(0,y)) In ((f 2) 3)
```

Apparently we already do recursive calls, but I don't understand the code.  
Need to modify `eval` to read a program from a file ....

Upgrade complete ... no environment and code is a bit messy .. to redo later.  
Example:
```
./eval --file ./progs/proc77.let 
```





