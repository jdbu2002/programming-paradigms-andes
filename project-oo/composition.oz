declare fun {WithDefault X Default}
  case {Value.status X} of
    free then Default
    else X
  end
end

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

declare Emp = {Employer "David" "Cra 24"}
declare Per = {Person "Lucas" "Trabajador"}

fun {ExplicitComposition ObjList}
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

% Implicit Compositions is not an object in a record representation
% But like a function with a simple dispatcher
fun {ImplicitComposition ObjList}
  % Here's the dispatcher, it uses the key, params and return
  proc {$ Key Params ?R}
    if Key == attributes then
      % Reuse the code to get the attributes list only
      R = {{ExplicitComposition ObjList}.attributes}
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
              local Appended = {List.append
                {WithDefault Params nil}
                [R]
              }
              in
                % Apply if procedure
                {Procedure.apply First.Key Appended}
              end
            else
              % In this case if not procedure it means it's an attribute
              % We return the value (We can also return the cell directly)
              R = @(First.Key)
            end
          else 
            % We raise an exception
            raise doNotUnderstand(Key)
          end
        end
      end
    end
  end
end

fun {ExplicitCompositionPoly ObjList}
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
                {Procedure.is Value}
              else
                false
              end
          end
          Methods
          Attributes
        }
        % Adjoin takes precedence in the second attribute
        Final := {Record.adjoin @Final {List.toRecord composed Attributes}}

        for MethodItem in Methods do
          case MethodItem of
            Name#Method then
              if {Value.hasFeature @Final Name} then
                Final := {Record.adjoin @Final composed(Name:{List.append
                  (@Final).Name
                  [Method]
                })}
              else
                Final := {Record.adjoin @Final composed(Name:[Method])}
              end
          end
        end
      end
    end

    Final := {Record.adjoin @Final composed(attributes:{Attributes @Final})}
    
    @Final
  end
end

declare Comp = {ExplicitComposition [Per Emp]}
declare Comp2 = {ImplicitComposition [Per Emp]}
declare Comp3 = {ExplicitCompositionPoly [Per Emp]}


{Show {Comp3.attributes $}}
% {Comp.display _}
% {System.showInfo }

% {System.showInfo {Comp2 getName _ $}}
% {Comp2 display _ _}
% {Show {Comp2 lel _ $}}