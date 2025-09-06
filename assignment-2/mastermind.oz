%% ============================================================================
%% MastermindGame Class
%% Main game controller that manages the overall game flow
%% ============================================================================
%% Color enumeration - valid colors in the game
%% Type: Color :: red | blue | green | yellow | orange | purple
%% ============================================================================
declare fun {Factorial N}
   if N < 2 then
      1
   else
      N * {Factorial N - 1} 
   end
end

declare fun {Perms N R}
   {Factorial N} div {Factorial (N - R)}
end

declare class MastermindGame
   attr codemaker codebreaker currentRound maxRounds gameStatus
   
   meth init(CodemakerObj CodebreakerObj)
      %% Initialize a new Mastermind game
      %% Input: CodemakerObj :: CodeMaker - Object implementing codemaker behavior
      %%        CodebreakerObj :: CodeBreaker - Object implementing codebreaker behavior
      %% Side effects: Initializes game state, sets maxRounds to 12
      %% Postcondition: Game ready to start, gameStatus = 'ready'
      %% Your code here

      codemaker := CodemakerObj
      codebreaker := CodebreakerObj
      maxRounds := 12
      gameStatus := ready
   end
   
   meth startGame(?Result)
      %% Starts a new game session
      %% Input: None
      %% Output: Result :: Bool - true if game started successfully, false otherwise
      %% Side effects: Resets game state, generates new secret code
      %% Precondition: Game must be in 'ready' or 'finished' state
      %% Postcondition: Game in 'playing' state, currentRound = 1
      %% Your code here

      if @gameStatus == ready orelse @gameStatus == finished then
         {@codemaker generateSecretCode(Result)}

         if Result then
            {@codebreaker resetHistory}
            gameStatus := playing
            currentRound := 1
         end
      else
         Result = false
      end
   end
   
   meth playRound(?Result)
      %% Executes one round of the game (guess + feedback)
      %% Input: None  
      %% Output: Result :: GameRoundResult - Record containing round results
      %%         GameRoundResult = result(
      %%            guess: [Color]           % The guess made this round
      %%            feedback: [FeedbackClue] % Black and white Clues received  
      %%            roundNumber: Int         % Current round number
      %%            gameWon: Bool            % Whether game was won this round
      %%            gameOver: Bool           % Whether game is over
      %%         )
      %% Precondition: Game must be in 'playing' state
      %% Side effects: Increments currentRound, may change gameStatus
      %% Your code here
      
      if @gameStatus == playing then
         local
            Guess = {@codebreaker generateRandom($)}
            FeedbackResult GameWon GameOver
         in
            {@codebreaker makeGuess(Guess _)}
            {@codemaker evaluateGuess(Guess FeedbackResult)}

            GameWon = FeedbackResult.isCorrect
            GameOver = GameWon orelse @currentRound >= @maxRounds

            {@codebreaker receiveFeedback(Guess FeedbackResult)}

            if GameWon orelse GameOver then
               gameStatus := finished
            else
               currentRound := @currentRound + 1
            end
            
            Result = result(
               guess: Guess
               feedback: FeedbackResult.clueList
               roundNumber: @currentRound
               gameWon: GameWon
               gameOver: GameOver
            )
         end
      else
         Result = result(
            guess: nil
            feedback: nil
            roundNumber: @currentRound
            gameWon: false
            gameOver: true
         )
      end
   end
   
   meth getGameStatus(?Result)
      %% Returns current game status
      %% Input: None
      %% Output: Result :: GameStatus - Current status of the game
      %%         GameStatus :: 'ready' | 'playing' | 'won' | 'lost' | 'finished'
      %% Your code here

      Result = @gameStatus
   end
   
   meth getCurrentRound(?Result)
      %% Returns current round number
      %% Input: None
      %% Output: Result :: Int - Current round number (1-12)
      %% Your code here

      Result = @currentRound
   end
   
   meth getRemainingRounds(?Result)
      %% Returns number of rounds left
      %% Input: None
      %% Output: Result :: Int - Number of rounds remaining (0-11)
      %% Your code here

      Result = @maxRounds - @currentRound
   end
   
end

%% ============================================================================
%% CodeMaker Class  
%% Handles secret code generation and feedback calculation
%% ============================================================================
declare class CodeMaker
   attr secretCode availableColors
   
   meth init()
      %% Initialize codemaker with available colors
      %% Input: None
      %% Side effects: Sets availableColors to [red blue green yellow orange purple]
      %% Postcondition: Ready to generate secret codes
      %% Your code here

      availableColors := [red blue green yellow orange purple]
      secretCode := nil
   end
   
   meth generateSecretCode(?Result)
      %% Generates a new random secret code
      %% Input: None
      %% Output: Result :: Bool - true if code generated successfully
      %% Side effects: Sets new secretCode (4 colors, repetitions allowed)
      %% Postcondition: secretCode contains exactly 4 valid colors
      %% Note: Uses random selection, colors may repeat
      %% Your code here     

      local Code = {NewCell nil} in
         for I in 1..4 do
            local Chosen = {OS.rand} mod {List.length @availableColors} in
               Code := {List.append
                  @Code
                  [{List.nth @availableColors (Chosen + 1)}]
               }
            end
         end

         secretCode := @Code
         Result = true
      end
   end
   
   meth setSecretCode(Code ?Result)
      %% Sets a specific secret code
      %% Input: Code :: [Color] - List of exactly 4 valid colors
      %% Output: Result :: Bool - true if code was set successfully
      %% Validation: Code must have exactly 4 elements, all valid colors
      %% Your code here

      {self isValidCode(Code Result)}

      if Result then
         secretCode := Code
      end
   end
   
   meth evaluateGuess(Guess ?Result)
      %% Evaluates a guess against the secret code
      %% Input: Guess :: [Color] - List of exactly 4 colors representing the guess
      %% Output: Result :: FeedbackResult - Detailed feedback for the guess
      %%         FeedbackResult = feedback(
      %%            blackClues: Int            % Number of correct color & position
      %%            whiteClues: Int            % Number of correct color, wrong position  
      %%            totalCorrect: Int          % blackClues + whiteClues
      %%            isCorrect: Bool            % true if guess matches secret code exactly
      %%            ClueList: [FeedbackClue]   % List of individual Clue results
      %%         )
      %%         FeedbackClue :: black | white | none
      %% Your code here

      local Blacks Whites Correct ClueList in
         Blacks = {NewCell 0}
         Whites = {NewCell 0}
         ClueList = {NewCell nil}

         for Idx in 1..4 do
            local Item = {List.nth Guess Idx} in 
               if {List.nth @secretCode Idx} == Item then
                  Blacks := @Blacks + 1
                  ClueList := {List.append @ClueList [black]}
               elseif {List.member Item @secretCode} then
                  Whites := @Whites + 1
                  ClueList := {List.append @ClueList [white]}
               else
                  ClueList := {List.append @ClueList [none]}
               end
            end
         end

         Result = feedback(
            blackClues:@Blacks
            whiteClues:@Whites
            totalCorrect:(@Blacks + @Whites)
            isCorrect:(@Blacks == 4)
            clueList:@ClueList
         )
      end
   end
   
   meth getSecretCode(?Result)
      %% Returns the current secret code (for testing/debugging)
      %% Input: None
      %% Output: Result :: [Color] | nil - Secret code or nil if not set
      %% Note: Should only be used for testing, breaks game in normal play
      %% Your code here
      Result = @secretCode
   end
   
   meth getAvailableColors(?Result)
      %% Returns list of colors that can be used in codes
      %% Input: None
      %% Output: Result :: [Color] - List of available colors for the game
      %% Your code here
      Result = @availableColors
   end
   
   meth isValidCode(Code ?Result)
      %% Validates if a code follows game rules
      %% Input: Code :: [Color] - Code to validate
      %% Output: Result :: Bool - true if code is valid for this game
      %% Validation: Exactly 4 colors, all from available color set
      %% Your code here

      Result = {List.length Code} == 4 andthen
         {All Code fun {$ V} {List.member V @availableColors} end}
   end
end

%% ============================================================================
%% CodeBreaker Class
%% Handles guess generation and strategy for breaking codes
%% ============================================================================  
declare class CodeBreaker
   attr guessHistory feedbackHistory strategy availableColors
   
   meth init(Strategy)
      %% Initialize codebreaker with a specific strategy
      %% Input: Strategy :: GuessingStrategy - Strategy for making guesses
      %%        GuessingStrategy :: 'random' | 'systematic' | 'smart' | 'human'
      %% Side effects: Initializes strategy and available colors
      %% Postcondition: Ready to make guesses
      %% Your code here
      strategy := Strategy
      guessHistory := nil
      feedbackHistory := nil
      availableColors := [red blue green yellow orange purple]
   end
   
   meth makeGuess(SuggestedGuess ?Result)
      %% Makes a specific guess (overrides strategy)
      %% Input: SuggestedGuess :: [Color] - Specific guess to make
      %% Output: Result :: Bool - true if guess was accepted and recorded
      %% Note: If SuggestedGuess is invalid, return false
      %% Side effects: Records guess in history
      %% Your code here
      {self isValidCode(SuggestedGuess Result)}

      if Result then
         guessHistory := SuggestedGuess | @guessHistory
      end
   end
   
   meth receiveFeedback(Guess Feedback)
      %% Receives and processes feedback for a guess
      %% Input: Guess :: [Color] - The guess that was evaluated
      %%        Feedback :: FeedbackResult - Feedback received from codemaker
      %% Side effects: Updates internal state, refines strategy if applicable
      %% Note: Smart strategies use this to eliminate future possibilities
      %% Your code here
      feedbackHistory := record(
         guess: Guess
         feedback: Feedback
         roundNumber: {List.length @feedbackHistory} + 1
      ) | @feedbackHistory
   end
   
   meth getGuessHistory(?Result)
      %% Returns all guesses made so far
      %% Input: None  
      %% Output: Result :: [GuessRecord] - History of all guesses
      %%         GuessRecord = record(
      %%            guess: [Color]
      %%            feedback: FeedbackResult  
      %%            roundNumber: Int
      %%         )
      %% Your code here

      %% NOTE: The order is from the most recent to the latest
      Result = @feedbackHistory
   end

   meth generateRandom(?Result)
      local Code = {NewCell nil} in
         for I in 1..4 do
            local Chosen = {OS.rand} mod {List.length @availableColors} in
               Code := {List.append
                  @Code
                  [{List.nth @availableColors (Chosen + 1)}]
               }
            end
         end

         Result = @Code
      end
   end
   
   meth setStrategy(NewStrategy ?Result)
      %% Changes the guessing strategy
      %% Input: NewStrategy :: GuessingStrategy - New strategy to use
      %% Output: Result :: Bool - true if strategy was changed successfully
      %% Side effects: Updates strategy, may reset internal state
      %% Your code here

      local Strategies = [random systematic smart human] in
         Result = {List.member NewStrategy Strategies}
         if Result then
            strategy := NewStrategy
         end
      end
   end
   
   meth getStrategy(?Result)
      %% Returns current guessing strategy
      %% Input: None
      %% Output: Result :: GuessingStrategy - Current strategy being used
      %% Your code here
      Result = @strategy
   end
   
   meth resetHistory()
      %% Clears guess and feedback history (for new game)
      %% Input: None
      %% Output: None (void)
      %% Side effects: Clears guessHistory and feedbackHistory
      %% Your code here
      guessHistory := nil
      feedbackHistory := nil
   end
   
   meth getRemainingPossibilities(?Result)
      %% Returns estimated number of remaining possible codes (smart strategy only)
      %% Input: None
      %% Output: Result :: Int | nil - Number of possibilities or nil if not applicable
      %% Note: Only meaningful for 'smart' strategy, returns nil for others
      %% Your code here
      if @strategy == smart then
         local Len = {List.length @feedbackHistory} in
            if Len == 0 then
               Result = {Pow 4 4}
            else
               local
                  First = {List.nth @feedbackHistory 1}
                  Nones = (4 - First.blackClues)
               in
                  Result = {Perms Nones First.whiteClues} * {Pow 4 Nones}         
               end
            end
         end
      else
         Result = nil
      end
   end

   meth isValidCode(Code ?Result)
      %% Validates if a code follows game rules
      %% Input: Code :: [Color] - Code to validate
      %% Output: Result :: Bool - true if code is valid for this game
      %% Validation: Exactly 4 colors, all from available color set
      %% Your code here

      Result = {List.length Code} == 4 andthen
         {All Code fun {$ V} {List.member V @availableColors} end}
   end
end

{System.showInfo "\n=== MASTERMIND COMPREHENSIVE TEST SUITE ==="}

{System.showInfo "\n--- Test 1: CodeMaker Basic Functionality ---"}
local CM1 Success1 Success2 Code1 Code2 Colors1 in
   CM1 = {New CodeMaker init()}
   
   {CM1 getAvailableColors(Colors1)}
   {System.showInfo "Default colors:"} {System.show Colors1}
   
   {CM1 generateSecretCode(Success1)}
   {CM1 getSecretCode(Code1)}
   {System.showInfo "Generated code:"} {System.show Code1} {System.showInfo "Success:"} {System.show Success1}
   
   {CM1 setSecretCode([red blue green yellow] Success2)}
   {CM1 getSecretCode(Code2)}
   {System.showInfo "Set code:"} {System.show Code2} {System.showInfo "Success:"} {System.show Success2}
end

{System.showInfo "\n--- Test 2: Code Validation ---"}
local CM Valid1 Valid2 Valid3 Valid4 Valid5  in
   CM = {New CodeMaker init()}
   
   {CM isValidCode([red blue green yellow] Valid1)}
   {CM isValidCode([red red red red] Valid2)}
   {System.showInfo "Valid codes - [red blue green yellow]:"} {System.show Valid1}
   {System.showInfo "[red red red red]:"} {System.show Valid2}
   
   {CM isValidCode([red blue green] Valid3)}  % Too short
   {CM isValidCode([red blue green yellow orange] Valid4)}  % Too long
   {CM isValidCode([red blue green yellow tangerine] Valid5)}  % Too long
   {System.showInfo "Invalid codes - [red blue green]:"} {System.show Valid3} {System.showInfo "[red blue green yellow orange]:"} {System.show Valid4}
   {System.showInfo "[red blue green tangerine]:"} {System.show Valid5}
end

{System.showInfo "\n--- Test 3: Guess Evaluation ---"}
local CM Feedback1 Feedback2 Feedback3 Feedback4 in
   CM = {New CodeMaker init()}
   
   {CM setSecretCode([red blue green yellow] _)}
   
   {CM evaluateGuess([red blue green yellow] Feedback1)}
   {System.showInfo "Perfect match - Black:"} {System.show Feedback1.blackClues} {System.showInfo "White:"} {System.show Feedback1.whiteClues} {System.showInfo "Correct:"} {System.show Feedback1.isCorrect}
   
   {CM evaluateGuess([blue red yellow green] Feedback2)}
   {System.showInfo "All colors wrong positions - Black:"} {System.show Feedback2.blackClues} {System.showInfo "White:"} {System.show Feedback2.whiteClues}
   
   {CM evaluateGuess([red orange purple blue] Feedback3)}
   {System.showInfo "Mixed - Black:"} {System.show Feedback3.blackClues} {System.showInfo "White:"} {System.show Feedback3.whiteClues}
   
   {CM evaluateGuess([orange purple orange purple] Feedback4)}
   {System.showInfo "No matches - Black:"} {System.show Feedback4.blackClues} {System.showInfo "White:"} {System.show Feedback4.whiteClues}
end

{System.showInfo "\n--- Test 4: CodeBreaker Strategies ---"}
local CB1 CB2 CB3 CB4 Strategy1 Strategy2 in
   CB1 = {New CodeBreaker init(random)}
   CB2 = {New CodeBreaker init(systematic)}
   CB3 = {New CodeBreaker init(smart)}
   CB4 = {New CodeBreaker init(human)}
   
   {CB1 getStrategy(Strategy1)}
   {System.showInfo "Random strategy:"} {System.show Strategy1}
   
   {CB2 getStrategy(Strategy2)}
   {System.showInfo "Systematic strategy:"} {System.show Strategy2}
   
   {CB1 setStrategy(smart _)}
   {System.showInfo "Changed to smart strategy"}
end

{System.showInfo "\n--- Test 5: Specific Guess Functionality ---"}
local CB Success1 Success2 Success3 in
   CB = {New CodeBreaker init(random)}
   
   {CB makeGuess([red blue green yellow] Success1)}
   {System.showInfo "Valid specific guess success:"} {System.show Success1}
   
   {CB makeGuess([red blue green] Success2)}
   {System.showInfo "Invalid specific guess (short) success:"} {System.show Success2}
   
   {CB makeGuess([red blue green invalid] Success3)}
   {System.showInfo "Invalid specific guess (bad color) success:"} {System.show Success3}
end

{System.showInfo "\n--- Test 6: Feedback Processing ---"}
local CB Feedback History in
   CB = {New CodeBreaker init(random)}
   
   {CB makeGuess([red blue green yellow] _)}
   
   Feedback = feedback(
      blackClues: 2
      whiteClues: 1
      totalCorrect: 3
      isCorrect: false
      clueList: [black black white none]
   )
   
   {CB receiveFeedback([red blue green yellow] Feedback)}
   
   {CB getGuessHistory(History)}
   {System.showInfo "Guess history length:"} {System.show {Length History}}
end

{System.showInfo "\n--- Test 7: Full Game Simulation ---"}
local Game CM CB Status1 Status2 Round Result Remaining in
   CM = {New CodeMaker init()}
   CB = {New CodeBreaker init(random)}
   Game = {New MastermindGame init(CM CB)}
   
   {Game getGameStatus(Status1)}
   {System.showInfo "Initial game status:"} {System.show Status1}
   
   {Game startGame(_)}
   {Game getGameStatus(Status2)}
   {System.showInfo "After start game status:"} {System.show Status2}
   
   {Game playRound(Result)}
   {System.showInfo "Round 1 - Guess:"} {System.show Result.guess} {System.showInfo "Black:"} {System.show {Length {Filter Result.feedback fun {$ X} X == black end}}} {System.showInfo "White:"} {System.show {Length {Filter Result.feedback fun {$ X} X == white end}}}
   
   {Game getCurrentRound(Round)}
   {System.showInfo "Current round:"} {System.show Round}
   
   {Game getRemainingRounds(Remaining)}
   {System.showInfo "Remaining rounds calculated"} {System.show Remaining}
end

% {System.showInfo "\n--- Test 8: Edge Cases ---"}
% local CM CB Game in
%    CM = {New CodeMaker init()}
%    CB = {New CodeBreaker init('random')}
%    Game = {New MastermindGame init(CM CB)}
   
%    try
%       local BadCM2 BadCB2 BadGame2 in
%          BadCM2 = {New CodeMaker init()}
%          BadCB2 = {New CodeBreaker init('random')}
%          BadGame2 = {New MastermindGame init(BadCM2 BadCB2)}
%          {BadGame2 playRound(_)}
%          {System.showInfo "ERROR: Should not reach here"}
%       end
%    catch E then
%       {System.showInfo "Correctly caught error for no secret code:"} {System.show E}
%    end
   
%    try
%       {CM setSecretCode([red blue green yellow] _)}
%       {CM evaluateGuess([red blue green] _)}
%       {System.showInfo "ERROR: Should not reach here"}
%    catch E then
%       {System.showInfo "Correctly caught error for invalid guess length:"} {System.show E}
%    end
% end

{System.showInfo "\n--- Test 9: Strategy-Specific Functionality ---"}
local CB1 CB2 Possibilities1 Possibilities2 in
   CB1 = {New CodeBreaker init(smart)}
   CB2 = {New CodeBreaker init(random)}
   
   {CB1 getRemainingPossibilities(Possibilities1)}
   {System.showInfo "Smart strategy possibilities:"} {System.show Possibilities1}
   
   {CB2 getRemainingPossibilities(Possibilities2)}
   {System.showInfo "Random strategy possibilities:"} {System.show Possibilities2}
   
   {CB1 makeGuess([red blue green yellow] _)}
   {CB1 resetHistory()}
   {CB1 getGuessHistory(_)}
   {System.showInfo "History reset completed"}
end

{System.showInfo "\n--- Test 10: Multiple Games ---"}
local Game CM CB Status1 Status2 in
   CM = {New CodeMaker init()}
   CB = {New CodeBreaker init(random)}
   Game = {New MastermindGame init(CM CB)}
   
   {Game startGame(_)}
   {Game playRound(_)}
   {Game getGameStatus(Status1)}
   {System.showInfo "First game status:"} {System.show Status1}
   
   {Game startGame(_)}
   {Game getGameStatus(Status2)}
   {System.showInfo "Second game status:"} {System.show Status2}
end

{System.showInfo "\n=== ALL TESTS COMPLETED ==="}