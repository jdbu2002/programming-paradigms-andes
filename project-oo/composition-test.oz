declare fun {ObjectBuilder Name AttrsTuples}
  local 
    InnerAttributes 

    fun {UpdateAttributes AttrsTuples}
      local Attrs in
        Attrs = {NewCell attributes()} 

        for Entry in AttrsTuples do
          case Entry of
            Name#Value then
              Attrs := {Record.adjoin @Attrs attributes(Name:Value)}
          end
        end

        @Attrs
      end
    end
  in
    InnerAttributes = {NewCell {UpdateAttributes AttrsTuples}}

    {Record.adjoin @InnerAttributes Name()}
  end
end

{Show {ObjectBuilder employer [
  name#"David"
  address#"Cra 24 # 1 - 135"
  getName#fun {$ This} This.name end
  getName#fun {$ This} This.name end
  getName#fun {$ This} This.name end
]}}