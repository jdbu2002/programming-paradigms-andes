declare fun {Reverse L}
  local Reversed in
    Reversed = {NewCell nil}

    for Element in L do
      Reversed := Element | @Reversed
    end

    @Reversed
  end
end

declare fun {Length L}
  local Count in
    Count = {NewCell 0}

    for _ in L do
      Count := @Count + 1
    end

    @Count
  end
end

declare fun {RightPad L Amount Padding}
  local Padded in
    Padded = {NewCell nil}

    for _ in 1..Amount do
      Padded := Padding | @Padded
    end

    for Word in {Reverse L} do
      Padded := Word | @Padded
    end

    @Padded
  end
end

% L1 and L2 must be same length otherwise it will truncate
declare fun {Zip L1 L2}    
  case L1 of
    H1 | T1 then
      case L2 of
        H2 | T2 then [H1 H2] | {Zip T1 T2}
        else nil
      end
    else nil
  end
end

declare fun {Abs N}
  if N >= 0 then N else ~N end
end

declare fun {AddPolynomials P1 P2}
  local SumPoly PP1 PP2 Padding in
    fun {SumPoly P1 P2}
      local Result Zipped in
        Result = {NewCell nil}

        for Tuple in {Zip P1 P2} do
          case Tuple of
            [C1 C2] then Result := C1 + C2 | @Result
          end  
        end

       @Result
      end
    end 

    Padding = {Abs {Length P1} - {Length P2}}

    % We don't care about extra padding due to Zip Function Truncate extra values
    PP1 = {RightPad {Reverse P1} Padding 0}
    PP2 = {RightPad {Reverse P2} Padding 0}

    {SumPoly PP1 PP2}

  end
end

proc {TestResult TestName Expected Actual}
   if Expected == Actual then
      {Show testpassed(TestName)}
   else
      {Show testfailed(TestName expected:Expected actual:Actual)}
   end
end

%% TASK 1 TESTS: OddSumEvenProduct
proc {TestTask2}
  local Result1 Result2 Result3 Result4 Result5 Result6 in
   {Browse '=== Testing Task 2: AddPolynomials ==='}
   
   Result1 = {AddPolynomials [1 ~2] [4 3 2 1]}
   {TestResult 'Example 1' [4 3 3 ~1] Result1}
   
   %% Test 2: Given example
   Result2 = {AddPolynomials [3 0 0 4 1 ~5] [0 2 ~1 1 4 10]}
   {TestResult 'Example 2' [3 2 ~1 5 5 5] Result2}
   
   %% Test 4: First polynomial longer
   Result4 = {AddPolynomials [1 2 3 4 5] [1 1]}
   {TestResult 'First longer' [1 2 3 5 6] Result4}
   
   %% Test 5: Second polynomial longer
   Result5 = {AddPolynomials [2 3] [1 2 3 4 5]}
   {TestResult 'Second longer' [1 2 5 7 5] Result5}
   
   %% Test 6: One empty polynomial
   Result6 = {AddPolynomials nil [1 2 3]}
   {TestResult 'First empty' [1 2 3] Result6}
  end
end
{TestTask2}