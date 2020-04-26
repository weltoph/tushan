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
    return Board(X, Y).Field(Direction);
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
        when North => return Board(X, Y - 1).Field(South);
        when East  => return Board(X + 1, Y).Field(West);
        when South => return Board(X, Y + 1).Field(North);
        when West  => return Board(X - 1, Y).Field(East);
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

end Board;
