Let times4 = 0 In
       Begin
         Set times4 = Proc (x) If(ZeroQ(x),0, -((times4 -(x,1)), -4));
         (times4 3)
       End
