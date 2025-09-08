declare fun {ObjectBuilder Name AttrsTuples}
  local 
    Attributes
    InnerAttributes 

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
                      {List.append [@InnerAttributes] Params}
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
                Attrs := {Record.adjoin @Attrs attributes(Name:Value)}
              end
          end
        end

        @Attrs
      end
    end
  in
    InnerAttributes = {NewCell {UpdateAttributes AttrsTuples}}

    proc {Attributes ?R}
      R = @InnerAttributes
    end

    {Record.adjoin @InnerAttributes Name(attributes:Attributes)}
  end
end

Employee = {ObjectBuilder employer [
  name#"David"
  address#"Cra 24 # 1 - 135"
  getName#proc {$ This ?R} R = This.name end
  getAddress#proc {$ This ?R} R = This.address end
  display#proc {$ This ?R} 
    {System.showInfo "Employer"}
    {System.showInfo "Name: " # This.name}
    {System.showInfo "Address: " # This.address}
  end
]}

{Employee.display nil _}
{System.showInfo {Employee.getName nil $}}
