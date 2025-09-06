declare fun {Employer InitialName InitialAddress}
  local
    InnerName = {NewCell InitialName}
    InnerAddress = {NewCell InitialAddress}

    fun {Attributes} 
      attributes(name:@InnerName address:@InnerAddress)
    end
    fun {Name} @InnerName end
    fun {Address} @InnerAddress end

    fun {Display}
      {System.showInfo "Employer"}
      {System.showInfo "Name: " # @InnerName}
      {System.showInfo "Address: " # @InnerAddress}
    end
  in
    employer(
      name:@InnerName
      address:@InnerAddress
      attributes:Attributes
      getName:Name
      getAddress:Address
      display:Display
    )
  end
end

declare Wa = {Employer "David" "Cra 24"}

{Show Wa}

