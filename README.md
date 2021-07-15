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

## Upgrade `eval` program
Apparently we already do recursive calls, but I don't understand the code.  
Need to modify `eval` to read a program from a file ....

Upgrade complete ... no environment and code is a bit messy .. to redo later.  
Example:
```
./eval --file ./progs/proc77.let
```

## Add letrec
For (more easily implemented) recursive calls   
I don't think I need to change the Env interface; `extendEnv` already handles it, no ?
```
extendEnv "f" (ProcVal "x" (VarExp "x") LPVEmpty) LPVEmpty
```
seems to work ok ... No, only compiles !!  

Recursive function identifiers are not put into the environment : the double example
gives an error "double" not in environment !! Ha. Maybe I do need to change the Env interface - fixed (modified `applEnv`).

## Add State (chap 4)
Language is now:

```
Var ::= String
NumVal ::= Integer
BoolVal ::= True | False
Exp ::= ConstExp | DiffExp | ZeroQExp | IfExp | VarExp |  
        LetExp | ProcExp | CallExp | LetRecExp  
ConstExp ::= NumVal | BoolVal
DiffExp ::= -(Exp,Exp)
ZeroQExp ::= ZeroQ(Exp)
IfExp ::= If(Exp,Exp,Exp)
VarExp ::= Var
LetExp ::= Let Var = Exp In Exp
ProcExp ::= Proc (Var) Exp
CallExp ::= (Exp Exp)
LetRecExp ::= LetRec Var (Var) = Exp In Exp
NewRefExp ::= NewRef(Exp)
DeRefExp ::= DeRef(Exp)
SetRefExp ::= SetRef(Exp,Exp)
```

`SetRefExp` modifies the store and returns a value equal to the value
placed into the store.

## BUG
```
"Let f = Let y = 1 In Proc (x) y In (f 3)"
```
Gives `y` not found in the Environment .... this is similar to the
structure of the `counter` program which is giving problems but
which is more complicated (`Begin` expresssion).

**This problem already existed** so merge back into `master` and
introduce `trace`facility to see what is happening ...

So ... the problem is fairly clear -- when evaluating a
`ProcExp` the resulting `ProcVal` has an environment that doesn't
contain a reference to itself. This was clear from the start, but
the code implemented to deal with this doesn't work as even
if I explicitly include the function into the environment on the
first invocation, following invocations use the environment from
the `ProcVal` which lacks the reference, hence we finish with
`Not found in Environment`.  

I will now try by addinga new type `RecProcVal` for recursive
functions and evaluate them differently from `ProcVal`s; Specifically
readding an entry to the environment on each invocation.

Seems to have worked !! Now need to implement a test suite to keep
track that things don't get broken.

## Implicit refs
This seems like a fairly fundamental change - it will probably give a
second version of the code .... let's see.

### Modifications
Introduce `Set` into the language. This will essentially ba a statement
and so only makes sense within a `Begin` `End` block.

OK, modified all of code (Let, LetRec, etc.) so that the environment
only contains `RefVal`s which point to the real values in the store.
(Actually the environment also contains `NumVal`s and `BoolVal`s still).

Code seems to work ok but is getting messy !!

Next stage is to add in statements.

### Mini-implementation
So, Left the main program unchanged and worked on a mini-version which
combines statements and expressions. Whats more it's based on `Monad`s;
this was major brain ache.

The code is in the files
```
dataStatements.hs
evalStatements.hs
parseStatements.hs
```
Expressions return values -- there is no environment so variables are
stored in the global store (implemented with the `StateT` monad). statements
return no value but can alter the state of the store and print things --
thus the IO monad. The whole thing is based around :

```
type Var = String
data Val = NumVal Int | BoolVal Bool -- as before
type MyState = StateT [(Var,Val)] IO ()
```

Examples:
```
\>se = (fst . head) $  parse lstat "{x=1; Print x; y=3; Print y; Print -(y,x)}"
\>se
LStatList [LStatAssign "x" (ConstExp (NumVal 1)),
           LStatPrint (VarExp "x"),
           LStatAssign "y" (ConstExp (NumVal 3)),
           LStatPrint (VarExp "y"),
           LStatPrint (DiffExp (VarExp "y") (VarExp "x"))]
\>runStateT (execute se) []
NumVal 1
NumVal 3
NumVal 2
((),[("y",NumVal 3),("x",NumVal 1)])
```
(`CR`s added for clarity)
