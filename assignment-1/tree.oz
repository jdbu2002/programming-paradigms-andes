declare fun {FindRootPos InList RootVal Pos}
  case InList of nil then ~1
  [] H | T then
    if H == RootVal then Pos
    else {FindRootPos T RootVal (Pos + 1)}
    end
  end
end

declare fun {Reverse L}
  local Reversed in
    Reversed = {NewCell nil}

    for Element in L do
      Reversed := Element | @Reversed
    end

    @Reversed
  end
end
  
declare fun {Pop L}
  {Reverse {List.drop {Reverse L} 1}}
end

declare fun {InorderPreorder2BT InOrder PreOrder}
  if InOrder == nil then 
    nil
  else
    case PreOrder of 
      nil then nil
    [] Root | PreOrderRest then
      local MidPoint LeftInOrder RightInOrder LeftPreOrder RightPreOrder in
        MidPoint = {FindRootPos InOrder Root 0}

        if MidPoint == ~1 then
          nil
        else
          LeftInOrder = {List.take InOrder MidPoint}
          RightInOrder = {List.drop InOrder (MidPoint + 1)}
          LeftPreOrder = {List.take PreOrderRest MidPoint}
          RightPreOrder = {List.drop PreOrderRest MidPoint}

          tree(
            Root 
            {InorderPreorder2BT LeftInOrder LeftPreOrder}
            {InorderPreorder2BT RightInOrder RightPreOrder}
          )
        end
      end
    end
  end
end


declare fun {InorderPostorder2BT InOrder PostOrder}
  if InOrder == nil orelse PostOrder == nil then
    nil
  else 
    local Root MidPoint WithoutRoot LeftInOrder RightInOrder LeftPostOrder RightPostOrder in
      Root = {List.last PostOrder}
      MidPoint = {FindRootPos InOrder Root 0}

      if MidPoint == ~1 then
        nil
      else
        WithoutRoot = {Pop PostOrder}
        LeftInOrder = {List.take InOrder MidPoint}
        RightInOrder = {List.drop InOrder (MidPoint + 1)}
        LeftPostOrder = {List.take WithoutRoot MidPoint}
        RightPostOrder = {List.drop WithoutRoot MidPoint}

        tree(
          Root 
          {InorderPostorder2BT LeftInOrder LeftPostOrder}
          {InorderPostorder2BT RightInOrder RightPostOrder}
        )
      end
    end
  end 
end


proc {TestResult TestName Expected Actual}
   if Expected == Actual then
      {Show testpassed(TestName)}
   else
      {Show testfailed(TestName expected:Expected actual:Actual)}
   end
end


proc {TestTask2}
  local Result1 Result2 Result3 Result4 Result5 Result6 Result7 Result8 Result9 TreeChar Tree1 Tree2 Tree3 Tree4 in
   {Browse '=== Testing Task 3: Binary Tree Construction ==='}
   
   Tree1 = tree(1 tree(2 nil nil) tree(3 nil nil))
   Result1 = {InorderPreorder2BT [2 1 3] [1 2 3]}
   {TestResult 'Simple tree (in+pre)' Tree1 Result1}
   
   Result2 = {InorderPostorder2BT [2 1 3] [2 3 1]}
   {TestResult 'Simple tree (in+post)' Tree1 Result2}
   
   Tree2 = tree(5 nil nil)
   Result3 = {InorderPreorder2BT [5] [5]}
   {TestResult 'Single node (in+pre)' Tree2 Result3}
   
   Result4 = {InorderPostorder2BT [5] [5]}
   {TestResult 'Single node (in+post)' Tree2 Result4}
   
   Result5 = {InorderPreorder2BT nil nil}
   {TestResult 'Empty tree (in+pre)' nil Result5}
   
   Result6 = {InorderPostorder2BT nil nil}
   {TestResult 'Empty tree (in+post)' nil Result6}
   
   Tree4 = tree(3 tree(2 tree(1 nil nil) nil) nil)
   Result7 = {InorderPreorder2BT [1 2 3] [3 2 1]}
   {TestResult 'Left-skewed (in+pre)' Tree4 Result7}
   
   Result8 = {InorderPostorder2BT [1 2 3] [1 2 3]}
   {TestResult 'Left-skewed (in+post)' Tree4 Result8}

   TreeChar = tree(a tree(b nil nil) tree(c nil nil))
   Result9 = {InorderPreorder2BT [b a c] [a b c]}
   {TestResult 'Character tree' TreeChar Result9}
  end
end

{TestTask2}