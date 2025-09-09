declare fun {WithDefault X Default}
   case {Value.status X} of
    free then
      Default
    else
      X
   end
end

declare fun {ObjectBuilder Name AttrsTuples}
  local 
    Attributes
    InnerAttributes 
    InnerMethods 

    fun {UpdateAttributes AttrsTuples}
      local Attrs in
        Attrs = {NewCell attributes()} 

        for Entry in AttrsTuples do
          case Entry of
            Name#Value then
              if {Procedure.is Value} then
                local 
                  proc {NewFun Params ?R}
                    local Appended = {List.append
                      {List.append [InnerAttributes] {WithDefault Params nil}}
                      [R]
                    }
                    in
                      {Procedure.apply Value Appended}
                    end
                  end
                in
                  Attrs := {Record.adjoin
                    @Attrs
                    attributes(Name:NewFun)
                  }
                end
              else
                Attrs := {Record.adjoin @Attrs attributes(Name:{NewCell Value})}
              end
          end
        end

        @Attrs
      end
    end
  in
    InnerMethods = {List.filter
      AttrsTuples
      fun {$ X} 
        case X of
          _#Value then {Procedure.is Value}
        else false end
      end
    }
    InnerAttributes = {NewCell {UpdateAttributes AttrsTuples}}

    proc {Attributes Methods ?R}
      R = if {WithDefault Methods false} then
        InnerMethods
      else
        InnerAttributes
      end
    end

    {Record.adjoin @InnerAttributes Name(attributes:Attributes)}
  end
end

Employee = {ObjectBuilder employer [
  name#"David"
  address#"Cra 24 # 1 - 135"
  getName#proc {$ This ?R} R = @((@This).name) end
  setName#proc {$ This Name ?R} 
    ((@This).name) := Name
    R = true
  end
  getAddress#proc {$ This ?R} R = @((@This).address) end
  display#proc {$ This ?R} 
    {System.showInfo "Employer"}
    {System.showInfo "Name: " # @((@This).name)}
    {System.showInfo "Address: " # @((@This).address)}
  end
]}
