%% Matrix Class Definition
%% Represents a square matrix with operations for rows, columns, and entire matrix
declare class Matrix
   attr data size
   
   meth init(Data)
      %% Initialize matrix from list of lists
      %% Input: Data :: [[Int]] - List of lists representing matrix rows
      %%                            Each inner list represents a row of the matrix
      %%                            All rows must have equal length to form a square matrix
      %% Precondition: Data must represent a valid square matrix (N×N where N > 0)
      %% Side effects: Initializes @data and @size attributes
      %% Your code here

      data := Data
      size := {List.length Data}
   end
   
   meth getSize(?Result)
      %% Returns the size N of the N×N matrix
      %% Input: None
      %% Output: Result :: Int - The dimension N of the N×N matrix
      %% Your code here

      Result = @size
   end
   
   meth getElement(Row Col ?Result)
      %% Returns element at position (Row, Col) using 1-indexed coordinates
      %% Input: Row :: Int - Row index (1 ≤ Row ≤ N)
      %%        Col :: Int - Column index (1 ≤ Col ≤ N)
      %% Output: Result :: Int - Element at position (Row, Col)
      %% Note: If Row and Col are not valide within the matrix size return 142857
      %% Your code here

      if Row < 1 orelse Row > @size orelse Col < 1 orelse Col > @size then
         Result = 142857
      else
         Result = {List.nth {List.nth @data Row} Col}
      end
   end
   
   meth getRow(RowIndex ?Result)
      %% Returns the complete row as a list
      %% Input: RowIndex :: Int - Row number (1 ≤ RowIndex ≤ N)
      %% Output: Result :: [Int] - List containing all elements of the specified row
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here
      
      if RowIndex < 1 orelse RowIndex > @size then
         Result = 142857
      else
         Result = {List.nth @data RowIndex}
      end
   end
   
   meth getColumn(ColIndex ?Result)
      %% Returns the complete column as a list
      %% Input: ColIndex :: Int - Column number (1 ≤ ColIndex ≤ N)  
      %% Output: Result :: [Int] - List containing all elements of the specified column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here

      if ColIndex < 1 orelse ColIndex > @size then
         Result = 142857
      else
         local Col in
            Col = {NewCell nil}

            for I in 1..@size do
               local Row Cell in
                  Row = {List.nth @data I}
                  Cell = {List.nth Row ColIndex}
                  Col := {List.append @Col [Cell]}
               end
            end

            Result = @Col
         end
      end
   end
   
   meth sumRow(RowIndex ?Result)
      %% Returns sum of all elements in specified row
      %% Input: RowIndex :: Int - Row number (1 ≤ RowIndex ≤ N)
      %% Output: Result :: Int - Arithmetic sum of all elements in the row
      %% Precondition: RowIndex is valid within the Matrix size
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here

      local Row in
         {self getRow(RowIndex Row)}
         if Row == 142857 then
            Result = 142857
         else
            Result = {List.foldL Row fun {$ Acc V} Acc + V end 0}
         end
      end
   end
   
   meth productRow(RowIndex ?Result)
      %% Returns product of all elements in specified row
      %% Input: RowIndex :: Int - Row number (1 ≤ RowIndex ≤ N)
      %% Output: Result :: Int - Arithmetic product of all elements in the row
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here
      local Row in
         {self getRow(RowIndex Row)}
         if Row == 142857 then
            Result = 142857
         else
            Result = {List.foldL Row fun {$ Acc V} Acc * V  end 1}
         end
      end
   end
   
   meth sumColumn(ColIndex ?Result)
      %% Returns sum of all elements in specified column
      %% Input: ColIndex :: Int - Column number (1 ≤ ColIndex ≤ N)
      %% Output: Result :: Int - Arithmetic sum of all elements in the column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here
      local Col in
         {self getColumn(ColIndex Col)}
         if Col == 142857 then
            Result = 142857
         else
            Result = {List.foldL Col fun {$ Acc V} Acc + V  end 0}
         end
      end
   end
   
   meth productColumn(ColIndex ?Result)
      %% Returns product of all elements in specified column
      %% Input: ColIndex :: Int - Column number (1 ≤ ColIndex ≤ N)
      %% Output: Result :: Int - Arithmetic product of all elements in the column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here
      local Col in
         {self getColumn(ColIndex Col)}
         if Col == 142857 then
            Result = 142857
         else
            Result = {List.foldL Col fun {$ Acc V} Acc * V end 1}
         end
      end
   end
   
   meth sumAll(?Result)
      %% Returns sum of all elements in the matrix
      %% Input: None
      %% Output: Result :: Int - Arithmetic sum of all matrix elements
      %% Note: Returns 0 for empty matrix
      %% Your code here

      Result = {List.foldL 
         @data
         fun {$ Acc Row}
            Acc + {List.foldL Row fun {$ Acc V} Acc + V end 0} 
         end
         0
      }
   end
   
   meth productAll(?Result) 
      %% Returns product of all elements in the matrix
      %% Input: None
      %% Output: Result :: Int - Arithmetic product of all matrix elements
      %% Note: Returns 1 for empty matrix, returns 0 if any element is 0
      %% Your code here

      Result = {List.foldL 
         @data
         fun {$ Acc Row}
            Acc * {List.foldL Row fun {$ Acc V} Acc * V end 1} 
         end
         1
      }
   end
   
   %% Utility methods
   meth display()
      %% Prints matrix in readable format to standard output
      %%    Any format is valid, just must display all the matrix content
      %% Input: None
      %% Output: None (void)
      %% Your code here

      for Rows in @data do
         {Show Rows}
      end
   end
end

declare M = {New Matrix init([
   [1 2 3 4 5]
   [6 7 8 9 10]
   [11 12 13 14 15]
   [16 17 18 19 20]
   [21 22 23 24 25]
])}

local Res1 Res2 Res3 Res4 Res5 Res6 Res7 Res8 Res9 Res10 in
   {M getSize(Res1)}
   {Show Res1}

   {M getElement(3 4 Res2)}
   {Show Res2}

   {M getRow(1 Res3)}
   {Show Res3}

   {M getColumn(1 Res4)}
   {Show Res4}

   {M sumRow(1 Res5)}
   {Show Res5}

   {M productRow(1 Res6)}
   {Show Res6}

   {M sumColumn(1 Res7)}
   {Show Res7}
   
   {M productColumn(1 Res8)}
   {Show Res8}

   {M sumAll(Res9)}
   {Show Res9}
   
   {M productAll(Res10)}
   {Show Res10}

   {M display}
end


