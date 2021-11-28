package body Board is
  function New_Board return Board_T is
  begin
    return (others => (others => (Occupied => False)));
  end New_Board;

  function Get_Connector (Board: In Board_T;
                          Point: In Point_T;
                          Direction: In Direction_T)
                          return Connector_T is
  begin
    if Is_Occupied (Board, Point) then
      return Board(Point.X, Point.Y).Field(Direction);
    else
      return Empty;
    end if;
  end Get_Connector;


  function Get_Opposing_Connector (Board: In Board_T;
                                   Point: In Point_T;
                                   Direction: In Direction_T)
                                   return Connector_T is
  begin
    if (Point.X = X_Coordinate'First and Direction = West)
      or (Point.X = X_Coordinate'Last and Direction = East)
      or (Point.Y = Y_Coordinate'First and Direction = North)
      or (Point.Y = Y_Coordinate'Last and Direction = South) then
      return Outer;
    else
      case Direction is
        when North =>
          if not Is_Occupied (Board, (Point.X, Point.Y - 1)) then
            return Empty;
          else
            return Board(Point.X, Point.Y - 1).Field(South);
          end if;
        when East  =>
          if not Is_Occupied (Board, (Point.X + 1, Point.Y)) then
            return Empty;
          else
            return Board(Point.X + 1, Point.Y).Field(West);
          end if;
        when South =>
          if not Is_Occupied (Board, (Point.X, Point.Y + 1)) then
            return Empty;
          else
            return Board(Point.X, Point.Y + 1).Field(North);
          end if;
        when West  =>
          if not Is_Occupied (Board, (Point.X - 1, Point.Y)) then
            return Empty;
          else
            return Board(Point.X - 1, Point.Y).Field(East);
          end if;
      end case;
    end if;
  end Get_Opposing_Connector;


  function Is_Occupied (Board: In Board_T; Point: In Point_T) return Boolean is
  begin
    return Board(Point.X, Point.Y).Occupied;
  end Is_Occupied;

  function "<" (P1, P2: In Point_T) return Boolean is
  begin
    if P1.X < P2.X then return True; end if;
    if P1.Y < P2.Y then return True; end if;
    return False;
  end "<";

end Board;
