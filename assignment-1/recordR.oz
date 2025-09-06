declare fun {RecordRelation R1 R2}
  local A1 A2 in
    A1 = {Arity R1}
    A2 = {Arity R2}

    if R1 == R2 then
      equal

    elseif {Label R1} == {Label R2} andthen A1 == A2 then
      equivalent

    elseif {All A1 fun {$ F} {HasFeature R2 F} andthen R1.F == R2.F end} then
      subsimilar

    elseif {All A2 fun {$ F} {HasFeature R1 F} andthen R1.F == R2.F end} then
      subsimilar

    else
      different
    end
  end
end

declare X
X = record(a:1 b:2 c:3 d:4)
Y = record(a:1 b:2)

{Show {RecordRelation X Y}}