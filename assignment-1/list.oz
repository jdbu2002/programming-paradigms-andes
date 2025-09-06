declare fun {OddSumEvenProduct L}
  local SumEvenBase in
    fun {SumEvenBase L Sum Product Even}
      case L of
        % nil then [Product Sum]
        nil then result(Product Sum)
        [] H | T then
          local NewSum NewProduct NewEven in
            if Even then
              NewSum = Sum
              
              if Product == 0 then
                NewProduct = H
              else
                NewProduct = Product * H
              end
            else
              NewSum = Sum + H
              NewProduct = Product
            end

            NewEven = {Not Even}

            {SumEvenBase T NewSum NewProduct NewEven}
          end
      end
    end

    {SumEvenBase L 0 0 false}
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
proc {TestTask1} 

  local Result1 Result2 Result3 Result4 Result5 in
    {Browse '=== Testing Task 1: OddSumEvenProduct ==='}
    
    Result1 = {OddSumEvenProduct [1 2 3 4 5]}
    {TestResult 'Basic case' 8#9 Result1}
    
    Result2 = {OddSumEvenProduct [1]}
    {TestResult 'Single element' 1#1 Result2}
    
    Result3 = {OddSumEvenProduct [5 3]}
    {TestResult 'Two elements' 3#5 Result3}
    
    Result4 = {OddSumEvenProduct nil}
    {TestResult 'Empty list' 1#0 Result4}
    
    Result5 = {OddSumEvenProduct [~1 2 3 ~4 ~5]}
    {TestResult 'Negative numbers' ~8#~3 Result5}
  end
end

{TestTask1}