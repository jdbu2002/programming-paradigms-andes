local Integral Fn A B N in
    fun {Fn X}
        {Sqrt {Sqrt (1.0 + {Pow X 2.0})}}
    end
    
    A = 0.0
    B = 2.0
    N = 2

    
    fun {Integral F A B N}
        local H C Y Yo Yn in
            H = (B - A) / {Int.toFloat N}
            C = {NewCell 4}
            Y = {NewCell 0.0}
            
            Yo = {F A}
             
            for K in 1..(N-1) do
                Y := @Y + {Int.toFloat @C} * {F (A + {Int.toFloat K} * H)}
                if @C == 2 then C := 4 else C := 2 end
            end
            
            Yn = {F ({Int.toFloat N} * H + A)}
            
            H / 3.0 * (Yo + @Y + Yn)
        end
    end
    
    
    
    {Show {Integral Fn A B N}}
end