package body Board.Stone.Uniform is

  function Unique_List (Connectors: Positive) return Stack_T is

    function Bin(N: in Positive; K: in Positive) return Positive is
      function Fac(L: in Positive) return Positive is
        Fac_Res: Positive := 1;
      begin
        for Factor in 1 .. L loop
          Fac_Res := Fac_Res * Factor;
        end loop;
        return Fac_Res;
      end Fac;
    begin
      return (Fac (N) / (Fac (K) + Fac(N - K)));
    end Bin;

  Count_Result: constant Positive := (if Stone_Width /= Stone_Height
                                      then Bin (2*Stone_Width + 2*Stone_Height, Connectors) / 2
                                      else Bin (2*Stone_Width + 2*Stone_Height, Connectors) / 4);
  Result: Stack_T (1 .. Count_Result);

  begin
    return result;
  end Unique_List;

  function Stonify (U: In Uniform_Stone_T) return Stone_T is
    Result: Stone_T (U'range(1), U'range(2));
  begin
    for X in U'range (1) loop
      for y in U'range (2) loop
        Result (X, Y) := U (X, Y);
      end loop;
    end loop;
    return Result;
  end Stonify;

end Board.Stone.Uniform;
