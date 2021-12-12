package body Board is

  function New_Board return Board_T is
  begin
    return (others => (others => (Occupied => False)));
  end New_Board;

  function "<" (P1, P2: In Point_T) return Boolean is
  begin
    if P1.X < P2.X then
      return True;
    elsif P1.X = P2.X and then P1.Y < P2.Y then
      return True;
    else
      return False;
    end if;
  end "<";

  function "<" (C1, C2: In Connective_T) return Boolean is
    function Dir_Val (Dir: In Direction_T) return Natural is
    begin
      case Dir is
        when North => return 1;
        when East  => return 2;
        when South => return 3;
        when West  => return 4;
      end case;
    end Dir_Val;
  begin
    if C1.Point < C2.Point then
      return True;
    elsif C1.Point = C2.Point and then Dir_Val(C1.Direction) < Dir_Val(C2.Direction) then
      return True;
    else
      return False;
    end if;
  end "<";

  procedure Place (Board: In Out Board_T;
                   Stone: In Stone_T;
                   Placement: In Point_T) is
  begin
    for X in 1 .. Stone'Length (1) loop
      for Y in 1 .. Stone'Length (2) loop
        declare
          Current_X: constant X_Coordinate := Placement.X + X - 1;
          Current_Y: constant Y_Coordinate := Placement.Y + Y - 1;
        begin
          case Board(Current_X, Current_Y).Occupied is
            when True =>
              raise Board_Error with "Try to place overlapping stone";
            when False =>
              Board(Current_X, Current_Y) := (Occupied => True,
                                              Field => Stone(X, Y));
          end case;
        end;
      end loop;
    end loop;
  end Place;

  function Covers (Stone: In Stone_T; Point: In Point_T) return Point_Sets.Set is
    Result: Point_Sets.Set;
  begin
    if not Fits_Dimensions (Stone, Point) then
      raise Board_Error with "Shadow of stone lies outside the dimensions of the board.";
    end if;
    for X in Point.X .. Point.X + Get_Width (Stone) - 1 loop
      for Y in Point.Y .. Point.Y + Get_Height (Stone) - 1 loop
        Point_Sets.Include (Result, (X, Y));
      end loop;
    end loop;
    return Result;
  end Covers;

  function Connectives (Stone: In Stone_T; Point: In Point_T) return Connective_Sets.Set is
    Result: Connective_Sets.Set;
  begin
    if not Fits_Dimensions (Stone, Point) then
      raise Board_Error with "Shadow of stone lies outside the dimensions of the board.";
    end if;
    for X in Point.X .. Point.X + Get_Width (Stone) - 1 loop
      Connective_Sets.Include (Result, ((X, Point.Y), North));
      Connective_Sets.Include (Result, ((X, Point.Y + Get_Height (Stone) - 1), South));
    end loop;
    for Y in Point.Y .. Point.Y + Get_Height (Stone) - 1 loop
      Connective_Sets.Include (Result, ((Point.X, Y), West));
      Connective_Sets.Include (Result, ((Point.X + Get_Width (Stone) - 1, Y), East));
    end loop;
    return Result;
  end Connectives;

  function Fits_Dimensions (Stone: In Stone_T; Point: In Point_T) return Boolean is
    Max_Width: constant X_Coordinate := Width - Point.X + 1;
    Max_Height: constant Y_Coordinate := Height - Point.Y + 1;
  begin
    return Get_Width (Stone) <= Max_Width and Get_Height (Stone) <= Max_Height;
  end;

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

  function Get_Border (Stone: In Stone_T; Direction: In Direction_T)
    return Border_T is
    Width: constant Positive := Get_Width (Stone);
    Height: constant Positive := Get_Height (Stone);
  begin
    case Direction is
      when North =>
        declare
          Border: Border_T (1 .. Width) := (others => Closed);
        begin
          for X in 1 .. Width loop
            Border (X) := Stone (X, 1)(North);
          end loop;
          return Border;
        end;
      when South =>
        declare
          Border: Border_T (1 .. Width) := (others => Closed);
        begin
          for X in 1 .. Width loop
            Border (X) := Stone (Width - X + 1, Height)(South);
          end loop;
          return Border;
        end;
      when East =>
        declare
          Border: Border_T (1 .. Height) := (others => Closed);
        begin
          for Y in 1 .. Height loop
            Border (Y) := Stone (Width, Y)(East);
          end loop;
          return Border;
        end;
      when West =>
        declare
          Border: Border_T (1 .. Height) := (others => Closed);
        begin
          for Y in 1 .. Height loop
            Border (Y) := Stone (1, Height - Y + 1)(West);
          end loop;
          return Border;
        end;
    end case;
  end Get_Border;

  function Rotate (Stone: In Stone_T) return Stone_T is
  begin
    return Stone_From_Borders (
      Get_Border (Stone, West),
      Get_Border (Stone, North),
      Get_Border (Stone, East),
      Get_Border (Stone, South));
  end Rotate;

 function Stone_From_Borders(Northern_Border: Border_T;
                             Eastern_Border: Border_T;
                             Southern_Border: Border_T;
                             Western_Border: Border_T)
                             return Stone_T is
   Width:  constant Positive := Northern_Border'Length;
   Height: constant Positive := Eastern_Border'Length;
   Stone: Stone_T(1 .. Width, 1 .. Height) := (
     others => (
       others => (North => Inner,
                  East => Inner,
                  South => Inner,
                  West => Inner)));
 begin
   if Southern_Border'Length /= Width or Western_Border'Length /= Height then
     -- errorneous state
     raise Board_Error with "Inconsistent borders for stone.";
   end if;

   for X in 1 .. Width loop
     declare
       Northern: constant Border_Connector_T := Northern_Border(X);
       Southern: constant Border_Connector_T := Southern_Border(Width - X + 1);
     begin
       Stone(X, 1)(North) := Northern;
       Stone(X, Height)(South) := Southern;
     end;
   end loop;

   for Y in 1 .. Height loop
     declare
       Eastern: constant Border_Connector_T := Eastern_Border(Y);
       Western: constant Border_Connector_T := Western_Border(Height - Y + 1);
     begin
       Stone(1, Y)(West) := Western;
       Stone(Width, Y)(East) := Eastern;
     end;
   end loop;

   return Stone;
 end Stone_From_Borders;

  function Get_Width (Stone: in Stone_T) return Positive is
  begin
    return Stone'Length (1);
  end Get_Width;

  function Get_Height (Stone: in Stone_T) return Positive is
  begin
    return Stone'Length (2);
  end Get_Height;

  procedure Connects (Board: In Board_T;
                      Stone: In Stone_T;
                      Placement: In Point_T;
                      Consistent_Connectives: Out Connective_Sets.Set;
                      Increasing_Connectives: Out Connective_Sets.Set) is
    Northern_Border: constant Border_T := Get_Border (Stone, North);
    Southern_Border: constant Border_T := Get_Border (Stone, South);
    Eastern_Border: constant Border_T := Get_Border (Stone, East);
    Western_Border: constant Border_T := Get_Border (Stone, West);
    Width: constant Positive := Get_Width (Stone);
    Height: constant Positive := Get_Height (Stone);
  begin
    for X in 1 .. Width loop
      declare
        N: constant Inner_Connector_T := Northern_Border (X);
        ON: constant Connector_T := Get_Opposing_Connector (Board,
                                                            (Placement.X + X - 1, Placement.Y),
                                                            North);
        S: constant Inner_Connector_T := Southern_Border (X);
        OS: constant Connector_T := Get_Opposing_Connector (Board,
                                                            (Width + Placement.X - X, Placement.Y + Height- 1),
                                                            South);
      begin
        if N = Inner or ON = Inner or S = Inner or OS = Inner then
          -- errorneous state
          raise Board_Error
            with "Stone presents <Inner> as connector of a border.";
        end if;
        if N = Open and ON = Closed then
          null;
        elsif N = Closed and ON = Open then
          null;
        else
          Connective_Sets.Include(Consistent_Connectives, ((Placement.X + X - 1, Placement.Y), North));
        end if;

        if S = Open and OS = Closed then
          null;
        elsif S = Closed and OS = Open then
          null;
        else
          Connective_Sets.Include(Consistent_Connectives, ((Width + Placement.X - X, Placement.Y + Height - 1), South));
        end if;

        if N = Open and ON = Open then
          Connective_Sets.Include(Increasing_Connectives, ((Placement.X + X - 1, Placement.Y), North));
        end if;
        if S = Open and OS = Open then
          Connective_Sets.Include(Increasing_Connectives, ((Width + Placement.X - X, Placement.Y + Height - 1), South));
        end if;
      end;
    end loop;
    for Y in 1 .. Height loop
      declare
        E: constant Inner_Connector_T := Eastern_Border (Y);
        OE: constant Connector_T := Get_Opposing_Connector (Board,
                                                            (Placement.X + Width - 1, Placement.Y + Y - 1),
                                                            East);
        W: constant Inner_Connector_T := Western_Border (Y);
        OW: constant Connector_T := Get_Opposing_Connector (Board,
                                                            (Placement.X, Placement.Y + Height - Y),
                                                            West);
      begin
        if E = Inner or OE = Inner or W = Inner or OW = Inner then
          -- errorneous state
          raise Board_Error
            with "Stone presents <Inner> as connector of a border.";
        end if;
        if E = Open and OE = Closed then
          null;
        elsif E = Closed and OE = Open then
          null;
        else
          Connective_Sets.Include(Consistent_Connectives, ((Placement.X + Width - 1, Placement.Y + Y - 1), East));
        end if;
        if W = Open and OW = Closed then
          null;
        elsif W = Closed and OW = Open then
          null;
        else
          Connective_Sets.Include(Consistent_Connectives, ((Placement.X, Placement.Y + Height - Y), West));
        end if;
        if E = Open and OE = Open then
          Connective_Sets.Include(Increasing_Connectives, ((Placement.X + Width - 1, Placement.Y + Y - 1), East));
        end if;
        if W = Open and OW = Open then
          Connective_Sets.Include(Increasing_Connectives, ((Placement.X, Placement.Y + Height - Y), West));
        end if;
      end;
    end loop;
  end Connects;

  function Occupied_Points (Board: In Board_T) return Point_Sets.Set is
    Result: Point_Sets.Set;
  begin
    for X in Board'Range (1) loop
      for Y in Board'Range (2) loop
        declare
          Point: constant Point_T := (X, Y);
        begin
          if Is_Occupied (Board, Point) then
            Point_Sets.Include (Result, Point);
          end if;
        end;
      end loop;
    end loop;
    return Result;
  end Occupied_Points;

end Board;
