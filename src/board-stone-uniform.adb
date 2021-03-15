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

    Longest_Side: constant Positive := (if Stone_Width < Stone_Height
                                        then Stone_Height
                                        else Stone_Width);

    subtype Side_Index_T is Positive range 1 .. Longest_Side;

    type Side_T is new Border_T(Side_Index_T);

    type Optional_Side_T (Empty: Boolean := True) is
      record
        case Empty is
          when True => null;
          when False => Side_T: Content;
        end case;
      end record;

    type Side_Collection_T is array (Positive range <>) of Side_T;

    function Smaller (Left: In Side_T;
                      Right: In Side_T;
                      Cmp_Index: In Side_Index_T) return Boolean is
    begin
      for I in 1 .. Cmp_Index loop
        if Left(I) = Border_Connector_T.Open and Right(I) = Border_Connector_T.Closed then
          return True;
        end if;
      end loop;
      return False;
    end Smaller;


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
