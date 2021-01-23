package body Board is

  function New_Board return Board_T is
  begin
    return (others => (others => (Occupied => False)));
  end New_Board;

  function Get_Connector (Board: In Board_T;
                          X: In X_Coordinate;
                          Y: In Y_Coordinate;
                          Direction: In Direction_T)
                          return Inner_Connector_T is
  begin
    if Is_Occupied (Board, X, Y) then
      return Board(X, Y).Field(Direction);
    else
      return Empty;
    end if;
  end Get_Connector;


  function Get_Opposing_Connector (Board: In Board_T;
                                   X: In X_Coordinate;
                                   Y: In Y_Coordinate;
                                   Direction: In Direction_T)
                                   return Connector_T is
  begin
    if (X = X_Coordinate'First and Direction = West)
      or (X = X_Coordinate'Last and Direction = East)
      or (Y = Y_Coordinate'First and Direction = North)
      or (Y = Y_Coordinate'Last and Direction = South) then
      return Outer;
    else
      case Direction is
        when North =>
          if not Is_Occupied (Board, X, Y - 1) then
            return Empty;
          else
            return Board(X, Y - 1).Field(South);
          end if;
        when East  =>
          if not Is_Occupied (Board, X + 1, Y) then
            return Empty;
          else
            return Board(X + 1, Y).Field(West);
          end if;
        when South =>
          if not Is_Occupied (Board, X, Y + 1) then
            return Empty;
          else
            return Board(X, Y + 1).Field(North);
          end if;
        when West  =>
          if not Is_Occupied (Board, X - 1, Y) then
            return Empty;
          else
            return Board(X - 1, Y).Field(East);
          end if;
      end case;
    end if;
  end Get_Opposing_Connector;


  function Is_Occupied (Board: In Board_T;
                        X: In X_Coordinate;
                        Y: In Y_Coordinate)
                        return Boolean is
  begin
    return Board(X, Y).Occupied;
  end Is_Occupied;

  function Contains (Set: In Coordinate_Set_T;
                     X: In X_Coordinate;
                     Y: In Y_Coordinate) return Boolean is
  begin
    return Set (X, Y);
  end Contains;

  function Empty (Set: In Coordinate_Set_T;
                  X: In X_Coordinate;
                  Y: In Y_Coordinate) return Boolean is
  begin
    for X in X_Coordinate loop
      for Y in Y_Coordinate loop
        if Set (X, Y) then
          return False;
        end if;
      end loop;
    end loop;
    return True;
  end Empty;

  function Occupied_Places (Board: In Board_T) return Coordinate_Set_T is
    Places: Coordinate_Set_T := (others => (others => False));
  begin
    for X in X_Coordinate loop
      for Y in Y_Coordinate loop
        Places (X, Y) := Is_Occupied (Board, X, Y);
      end loop;
    end loop;
    return Places;
  end Occupied_Places;

end Board;
