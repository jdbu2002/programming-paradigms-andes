% -- Extra functions --
declare fun {WithDefault X Default}
  %% If a variable is unbound set a default value
  %% Input: X :: T
  %%        Default :: E
  %% Output: T if X is not free else E. 
  case {Value.status X} of
    free then
      Default
    else
      X
  end
end


% Task 6 - Implement NextFunction
declare HasNextCalled = {NewCell false}

declare proc {NextFunction}
  %% Just update the cell global value for next-ing a function
  HasNextCalled := true
end


% Task 1 - Model objects for composition using Bundling
declare fun {Employer InitialName InitialAddress}
  local
    InnerName = {NewCell InitialName}
    InnerAddress = {NewCell InitialAddress}

    proc {Attributes ?R} 
      R = attributes(
        name:InnerName
        address:InnerAddress
        getName:Name
        getAddress:Address
        display:Display
      )
    end
    proc {Name ?R} R = @InnerName end
    proc {Address ?R} R = @InnerAddress end

    proc {Display ?R}
      {System.showInfo "Employer"}
      {System.showInfo "Name: " # @InnerName}
      {System.showInfo "Address: " # @InnerAddress}
    end
  in
    employer(
      name:InnerName
      address:InnerAddress
      attributes:Attributes
      getName:Name
      getAddress:Address
      display:Display
    )
  end
end

declare fun {Person InitialName InitialEmployer}
  local
    InnerName = {NewCell InitialName}
    InnerEmployer = {NewCell InitialEmployer}

    proc {Attributes ?R} 
      R = attributes(
        name:InnerName
        employer:InnerEmployer
        personName:PersonName
        personEmployer:PersonEmployer
        display:Display
      )
    end
    proc {PersonName ?R} R = @InnerName end
    proc {PersonEmployer ?R} R = @InnerEmployer end

    proc {Display ?R}
      {System.showInfo "Person"}
      {System.showInfo "Name: " # @InnerName}
      {NextFunction}
    end
  in
    person(
      attributes:Attributes
      name:InnerName
      employer:InnerEmployer
      personName:PersonName
      personEmployer:PersonEmployer
      display:Display
    )
  end
end

declare fun {Cat InitialName}
  local
    InnerName = {NewCell InitialName}

    proc {Attributes ?R} 
      R = attributes(
        name:InnerName
        display:Display
      )
    end

    proc {Display ?R}
      {System.showInfo "Cat"}
      {System.showInfo "Name: " # @InnerName}
      {System.showInfo "Meows"}
      {NextFunction}
    end
  in
    cat(
      attributes:Attributes
      name:InnerName
      display:Display
    )
  end
end

% Task 2 - Implement Explicit Composition
declare fun {ExplicitComposition ObjList}
  %% Compose a list of object into a new record that contains the fusion of all 
  %% the attributes mantaing precedence by the leftmost element in the array
  %% Input: ObjList :: [Record (Bundled Objects)]
  %% Output: Record - A new composed object

  local
    Final = {NewCell composed()}

    fun {Attributes Value} 
      proc {$ ?R}
        R = {Record.adjoin Value attributes()}
      end
    end
  in
    for Obj in {List.reverse ObjList} do
      % Adjoin takes precedence in the second attribute
      Final := {Record.adjoin @Final {Record.subtract Obj attributes}}
    end

    Final := {Record.adjoin @Final composed(attributes:{Attributes @Final})}
    
    @Final
  end
end

% Task 3 - Implement Implicit Composition

% Implicit Compositions is not an object in a record representation
% But like a function with a simple dispatcher
declare fun {ImplicitComposition ObjList}
  %% Compose a list of object into a function "dispatcher" that can lookup the
  %% attributes of the objects priorizing the leftmost one lazily.
  %% Input: ObjList :: [Record (Bundled Objects)]
  %% Output: Procedure - The "dispatcher" function to find and locate the
  %% attributes / methods lazily.
  %% Raises: doNotUnderstand - If the key provided is not part of the composed
  %%          object.
  local 
    Attributes = {{ExplicitComposition ObjList}.attributes}

    proc {Eval Key ?R}
      if Key == attributes then
        % Reuse the code to get the attributes list only
        R = Attributes
      else
        local 
          % Filter the one who has the feature in the list
          FirstInstance = {List.filter
            ObjList
            fun {$ X} {Value.hasFeature X Key} end
          }
        in
          case FirstInstance of
            % Use the first one and execute it
            First | _ then
              if {Procedure.is First.Key} then
                R = First.Key
              else
                % In this case if not procedure it means it's an attribute
                % We return the value (We can also return the cell directly)
                R = @(First.Key)
              end
            else 
              % We raise an exception
              raise doNotUnderstand(Key) end
          end
        end
      end
    end
  in
    composed(
      eval:Eval
      attributes:proc {$ ?R} 
        R = Attributes
      end
    )
  end
end

% Task 4 - Implement Explicit Composition saving all Methods in Lists
declare fun {ExplicitCompositionPoly ObjList}
  %% Compose a list of object into a new record that contains the fusion of all 
  %% the attributes mantaing precedence by the leftmost element in the array.
  %% The main difference is now that methods are saved in a list to allow
  %% method overloading and avoid clashes.
  %% Input: ObjList :: [Record (Bundled Objects)]
  %% Output: Record - A new composed object

  local
    Final = {NewCell composed()}

    fun {Attributes Value} 
      proc {$ ?R}
        R = {Record.adjoin Value attributes()}
      end
    end
  in
    for Obj in {List.reverse ObjList} do
      local 
        AttrsList = {Record.toListInd {Obj.attributes}}
        Attributes
        Methods
      in
        {List.partition
          AttrsList
          fun {$ Item}
            case Item of
              _#Value then
                if {Procedure.is Value} then
                  true
                elseif {List.is Value} andthen
                  {List.all Value fun {$ X} {Procedure.is X} end}
                then
                  true
                else 
                  false
                end
              else
                false
              end
          end
          Methods
          Attributes
        }

        
        % Adjoin takes precedence in the second attribute
        Final := {Record.adjoin @Final {List.toRecord composed Attributes}}

        % We iterate for all the methods to append them in the list
        for MethodItem in Methods do
          case MethodItem of
            Name#Method then
              if {Value.hasFeature @Final Name} then
                local
                  FinalMethod
                in
                  if {List.is Method} then
                    FinalMethod = Method
                  else 
                    FinalMethod = [Method]
                  end

                  Final := {Record.adjoin
                    @Final
                    composed(Name:{List.append
                      FinalMethod
                      (@Final).Name
                    })
                  }
                end
              else
                local
                  FinalMethod
                in
                  if {List.is Method} then
                    FinalMethod = Method
                  else 
                    FinalMethod = [Method]
                  end

                  Final := {Record.adjoin @Final composed(Name:FinalMethod)}
                end
              end
          end
        end
      end
    end

    Final := {Record.adjoin @Final composed(attributes:{Attributes @Final})}
    
    @Final
  end
end

% Task 5 & 6 - Implement Dispatch with Key Index and NextFunction
declare proc {Dispatch Obj Key Params Index}
  %% Dispatch a method that is in the polymorphed composed object method list.
  %% Use the index to choose what method want to execute, and also add the logic
  %% to use next-ify the next function in the list from inside method
  %% definition.
  %% Input: Obj :: Record (Composed by ExplicitPoly)
  %%        Key :: Atom representing the key of the method
  %%        Params :: The params that will be used in the method
  %%        Index :: A natural number choosing the Index of the list of the 
  %%                 method to use
  %% Output: None
  %% Raises: notAMethod - If the key provided is not a method list of a poly
  %%          composition

  local
    MethodList = Obj.Key
    ProccesedParams = {WithDefault Params nil}
  in
    if {List.is MethodList} then
      if Index > 0 andthen Index =< {List.length MethodList} then
        local Method = {List.nth MethodList Index} in
          {Procedure.apply Method ProccesedParams}

          if @HasNextCalled then
            HasNextCalled := false
            {Dispatch Obj Key ProccesedParams (Index + 1)}
          end
        end
      end
    else
      raise notAMethod(Key) end
    end
  end
end

% Execution / Test cases

declare Emp = {Employer "David" "Cra 24"}
declare Per = {Person "Lucas" "Trabajador"}
declare Caty = {Cat "Void"}

declare ExplicitComposed = {ExplicitComposition [Per Emp]}
declare ImplicitComposed = {ImplicitComposition [Per Emp]}
declare PolyComposed = {ExplicitCompositionPoly [Per Emp]}

%% Test 1 - Show display
{System.showInfo "Explicit Composed\n"}


local 
  GetFunction
  DisplayFunction
  Name
in
  {Show ExplicitComposed}

  GetFunction = {CondSelect ExplicitComposed getName _}

  {GetFunction Name}
  {System.showInfo Name}

  DisplayFunction = {CondSelect ExplicitComposed display  _}
  {DisplayFunction _}
end

{System.showInfo "\nImplicit Composed\n"}

%% Test 2 - Show getName with Implicit
{Show ImplicitComposed}

local 
  GetFunction
  DisplayFunction
  NoFunction
  Name
in
  GetFunction = {CondSelect
    ImplicitComposed
    getName
    {ImplicitComposed.eval getName $}
  } 

  {GetFunction Name}
  {System.showInfo Name}

  DisplayFunction = {CondSelect
    ImplicitComposed
    display
    {ImplicitComposed.eval display $}
  }

  {DisplayFunction _}

  try
    NoFunction = {CondSelect
      ImplicitComposed
      noFunction
      {ImplicitComposed.eval noFunction $}
    }

    {NoFunction}
  catch
    doNotUnderstand(K) then
      {System.showInfo "Method not found: " # K }
  end
end

{System.showInfo "\nExplicit Poly Composed\n"}

%% Test 3 - Show PolyComposed
{Show PolyComposed}
{Show {PolyComposed.attributes $}}
{Dispatch PolyComposed display [_] 1}
