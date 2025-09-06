declare fun {Trim VS}
  local S DropWhile Rev L1 L2 L3 in 
    S = {Atom.toString {VirtualString.toAtom VS}}

    fun {DropWhile L P}
      case L of
        C | Cs andthen {P C} then
          {DropWhile Cs P}
        else
          L
      end
    end
  
    fun {Rev L Acc}
      case L of nil then 
        Acc
      [] H|T then
        {Rev T (H | Acc)}
      end
    end

    L1 = {DropWhile S Char.isSpace}
    L2 = {Rev L1 nil}
    L3 = {DropWhile L2 Char.isSpace}

    {Rev L3 nil}
  end
end

declare class Expression
  meth print
    {System.showInfo "Base method does nothing "}
  end

  meth eval(R)
    {System.showInfo "Base method does nothing "}
  end

  meth toString(R)
    {System.showInfo "Base method does nothing "}
  end
end

declare class Num from Expression
  attr n:0

  meth init(Val)
    n := Val
  end

  meth print
    {System.showInfo @n}
  end

  meth eval(R)
    R = @n
  end

  meth toString(R)
    local Text Digits BaseDigits DecimalDigits in 
      if @n == 0 then
        R = "zero"
      else
        Text = {NewCell ""}

        if @n < 0 then
          Text := "negative"
        end

        Digits = {List.mapInd
          {List.make 3}
          fun {$ I _} ({Abs @n} div {Pow 10 (3 - I)}) mod 10 end
        }

        BaseDigits = [
          "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten"
          "eleven" "twelve" "thirteen" "fourteen" "fiveteen" "sixteen"
          "seventeen" "eighteen" "nineteen"
        ]
        DecimalDigits = [
          "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety"
        ]

        case Digits of
          H | D | U | nil then            
            if H > 0 then
              Text := @Text # " " # {List.nth BaseDigits H} # " hundred"
            end

            if D == 1 then
              local DU in
                DU = D * 10 + U
                Text := @Text # " " # {List.nth BaseDigits DU}
              end
            end

            if D > 1 then
              Text := @Text # " " # {List.nth DecimalDigits (D - 1)}
            end


            if D \= 1 andthen U > 0 then
              Text := @Text # " " # {List.nth BaseDigits U}
            end
        end

        R = {Trim @Text}
      end
    end
  end
end

declare class Sum from Expression
  attr left right

  meth init(L R)
    left := L
    right := R
  end

  meth print
    {@left print} {System.showInfo "+"} {@right print}
  end

  meth eval(R)
    local LR RR in
      {@left eval(LR)}
      {@right eval(RR)}
      R = LR + RR
    end
  end

  meth toString(R)
    local Le Ri in
      {@left toString(Le)}
      {@right toString(Ri)}
      R = Le # " plus " # Ri
    end
  end
end

declare class Difference from Expression
  attr left right

  meth init(L R)
    left := L
    right := R
  end

  meth print
    {@left print} {System.showInfo "-"} {@right print}
  end

  meth eval(R)
    local LR RR in
      {@left eval(LR)}
      {@right eval(RR)}
      R = LR - RR
    end
  end

  meth toString(R)
    local Le Ri in
      {@left toString(Le)}
      {@right toString(Ri)}
      R = Le # " minus " # Ri
    end
  end
end

declare class Multiplication from Expression
  attr left right

  meth init(L R)
    left := L
    right := R
  end

  meth print
    {@left print} {System.showInfo "*"} {@right print}
  end

  meth eval(R)
    local LR RR in
      {@left eval(LR)}
      {@right eval(RR)}
      R = LR * RR
    end
  end

  meth toString(R)
    local Le Ri in
      {@left toString(Le)}
      {@right toString(Ri)}
      R = Le # " times " # Ri
    end
  end
end

declare class Modulo from Expression
  attr left right

  meth init(L R)
    left := L
    right := R
  end

  meth print
    {@left print} {System.showInfo "mod"} {@right print}
  end

  meth eval(R)
    local LR RR in
      {@left eval(LR)}
      {@right eval(RR)}
      R = LR mod RR
    end
  end

  meth toString(R)
    local Le Ri in
      {@left toString(Le)}
      {@right toString(Ri)}
      R = Le # " modulo " # Ri
    end
  end
end


declare Num1 = {New Num init(246)}
declare Num2 = {New Num init(~572)}

declare Sum1 = {New Sum init(Num1 Num2)}
declare Difference1 = {New Difference init(Num1 Num2)}
declare Multi = {New Multiplication init(Num1 Num2)}
declare Module = {New Modulo init(Num1 Num2)}

declare Twist = {New Sum init(
  {New Difference init(
    {New Num init(2)}
    {New Num init(3)}
  )}
  {New Multiplication init(
    {New Num init(5)}
    {New Num init(~2)}
  )}
)}

declare Items = [Num1 Num2 Sum1 Difference1 Multi Module Twist]

for E in Items do
  local Res in
    {E toString(Res)}
    {System.showInfo Res}
    {System.showInfo "--- --- ---"}
  end
end
