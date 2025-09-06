\insert 'list.oz'
\insert 'poly.oz' 
\insert 'tree.oz'
\insert 'integral.oz'
\insert 'recordR.oz'

proc {TestResult TestName Expected Actual}
   if Expected == Actual then
      {Browse testpassed(TestName)}
   else
      {Browse testfailed(TestName expected:Expected actual:Actual)}
   end
end

%% TASK 1 TESTS: OddSumEvenProduct
proc {TestTask1}
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

%% TASK 2 TESTS: AddPolynomials
proc {TestTask2}
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

%% TASK 3 TESTS: Binary Tree Construction
proc {TestTask3}
   {Browse '=== Testing Task 3: Binary Tree Construction ==='}
   
   Tree1 = tree(1 tree(2 nil nil) tree(3 nil nil))
   Result1 = {InorderPreorder2BT [2 1 3] [1 2 3]}
   {TestResult 'Simple tree (in+pre)' Tree1 Result1}
   
   Result2 = {inorderPostorder2BT [2 1 3] [2 3 1]}
   {TestResult 'Simple tree (in+post)' Tree1 Result2}
   
   Tree2 = tree(5 nil nil)
   Result3 = {inorderPreorder2BT [5] [5]}
   {TestResult 'Single node (in+pre)' Tree2 Result3}
   
   Result4 = {inorderPostorder2BT [5] [5]}
   {TestResult 'Single node (in+post)' Tree2 Result4}
   
   Result5 = {inorderPreorder2BT nil nil}
   {TestResult 'Empty tree (in+pre)' nil Result5}
   
   Result6 = {inorderPostorder2BT nil nil}
   {TestResult 'Empty tree (in+post)' nil Result6}
   
   Tree4 = tree(3 tree(2 tree(1 nil nil) nil) nil)
   Result7 = {inorderPreorder2BT [1 2 3] [3 2 1]}
   {TestResult 'Left-skewed (in+pre)' Tree4 Result7}
   
   Result8 = {inorderPostorder2BT [1 2 3] [1 2 3]}
   {TestResult 'Left-skewed (in+post)' Tree4 Result8}

   TreeChar = tree(a tree(b nil nil) tree(c nil nil))
   Result9 = {inorderPreorder2BT [b a c] [a b c]}
   {TestResult 'Character tree' TreeChar Result9}
end

%% TASK 4 TESTS: Simpson's Rule Integration
proc {TestTask4}
   {Browse '=== Testing Task 4: Simpson\'s Rule Integration ==='}
   
   fun {Linear X} X end                   
   fun {Quadratic X} X*X end              
   fun {Constant X} 1.0 end               
   fun {Cubic X} X*X*X end                
   
   Result1 = {integral Constant 0.0 1.0 2}
   {Browse test1_constant(expected:1.0 actual:Result1)}
   
   Result2 = {integral Linear 0.0 2.0 4}
   {Browse test2_linear(expected:2.0 actual:Result2)}
   
   Result3 = {integral Quadratic 0.0 1.0 6}
   {Browse test3_quadratic(expected:0.333333 actual:Result3)}
   
   Result5 = {integral Quadratic 0.0 1.0 100}
   {Browse test5_precision(expected:0.333333 actual:Result5)}
   
   Result6 = {integral Cubic ~1.0 1.0 8}
   {Browse test6_odd_function(expected:0.0 actual:Result6)}
end

%% TASK 5 TESTS: Record Relations
proc {TestTask5}
    {Browse '=== Testing Task 5: Record Relations ==='}
    
    R1 = person(name:john age:25 city:bogota)
    R2 = person(name:john age:25 city:bogota)
    Result1 = {RecordRelation R1 R2}
    {TestResult 'Equal records' equal Result1}
    
    R3 = person(name:mary age:30 city:medellin)
    Result2 = {RecordRelation R1 R3}
    {TestResult 'Equivalent records' equivalent Result2}
    
    R4 = person(name:john age:25)
    Result3 = {RecordRelation R4 R1}
    {TestResult 'Subsimilar records' subsimilar Result3}
    
    R5 = car(brand:toyota model:corolla)
    Result4 = {RecordRelation R1 R5}
    {TestResult 'Different record types' different Result4}
    
    R8 = empty()
    R7 = empty()
    Result6 = {RecordRelation R7 R8}
    {TestResult 'Empty records' equal Result6}
    
    R7 = empty()
    R9 = data(value:42)
    Result7 = {RecordRelation R7 R9}
    {TestResult 'Empty vs non-empty' subsimilar Result7}
    
    Result8 = {RecordRelation R1 R4}
    {TestResult 'Reverse subsimilar' subsimilar Result8}
    
    R10 = person(id:123 salary:5000)
    Result9 = {RecordRelation R1 R10}
    {TestResult 'Same label, different fields' different Result9}
end
