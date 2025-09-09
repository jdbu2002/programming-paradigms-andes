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
    proc {Address ?R} R =@InnerAddress end

    proc {Display}
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

    proc {Display}
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
    Final = {NewCell none()}

    fun {Attributes Value} 
      proc {$ ?R}
        R = {Record.adjoin Value attributes()}
      end
    end
  in
    for Obj in {List.reverse ObjList} do
      {Show Obj}
      Final := {Record.adjoin @Final {Record.subtract Obj attributes}}
    end

    Final := {Record.adjoin @Final composed(attributes:{Attributes @Final})}
    
    @Final
  end
end

declare Comp = {ExplicitComposition [Emp Per]}
{Comp.display}
{Show {Comp.attributes $}}