with Ada.Wide_Text_IO;
with Ada.Text_IO;

package body Board is

  function Empty_Board return Board_T
  is
  begin
    return (others => (others => (Occupied => False)));
  end Empty_Board;

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

  function Middle return Point_Sets.Set
  is
    Min_X: constant X_Coordinate :=
      (if Width mod 2 = 0
       then Width / 2
       else (Width + 1) / 2);
    Max_X: constant X_Coordinate :=
      (if Width mod 2 = 0
       then (Width / 2) + 1
       else (Width + 1) / 2);
    Min_Y: constant Y_Coordinate :=
      (if Height mod 2 = 0
       then Height / 2
       else (Height + 1) / 2);
    Max_Y: constant Y_Coordinate :=
      (if Height mod 2 = 0
       then (Height / 2) + 1
       else (Height + 1) / 2);
    Result: Point_Sets.Set;
  begin
    for X in Min_X .. Max_X loop
      for Y in Min_Y .. Max_Y loop
        Result.Insert((X, Y));
      end loop;
    end loop;
    return Result;
  end Middle;

  function Valid_Moves(Board: In Board_T; Stone: In Stone_T) return Moves_T
  is
    function Valid_Moves_For_Rotation(Stone: In Stone_T)
      return Point_Sets.Set
    is
      Result: Point_Sets.Set;
      Occupied: constant Point_Sets.Set := Occupied_Points(Board);
      Middle_Points: constant Point_Sets.Set := Middle;

      procedure Handle(Current: In Point_T)
      is
        Fits: constant Boolean := Fits_Dimensions(Stone, Current);
      begin
        if not Fits then return; end if;
        declare
          Cover: constant Point_Sets.Set := Covers(Stone, Current);
        begin
          if Occupied.Is_Empty then
            if Middle_Points.Intersection(Cover).Is_Empty then return; end if;
            Result.Insert(Current);
          else
            if not Occupied.Intersection(Cover).Is_Empty then return; end if;
            declare
              Consistent: Connective_Sets.Set;
              Increasing: Connective_Sets.Set;
              Everything: constant Connective_Sets.Set := Connectives(Stone, Current);
            begin
              Connects(Board, Stone, Current, Consistent, Increasing);
              if not Connective_Sets.Equivalent_Sets(Consistent, Everything) then return; end if;
              if Increasing.Is_Empty then return; end if;
              Result.Insert(Current);
            end;
          end if;
        end;
      end Handle;
    begin
      for X in X_Coordinate loop
        for Y in Y_Coordinate loop
          declare
            Current: constant Point_T := (X, Y);
          begin
            Handle(Current);
          end;
        end loop;
      end loop;
      return Result;
    end Valid_Moves_For_Rotation;
    RStone: constant Stone_T := Rotate(Stone);
    RRStone: constant Stone_T := Rotate(RStone);
    RRRStone: constant Stone_T := Rotate(RRStone);
  begin
    return (
      0 => Valid_Moves_For_Rotation(Stone),
      1 => Valid_Moves_For_Rotation(RStone),
      2 => Valid_Moves_For_Rotation(RRStone),
      3 => Valid_Moves_For_Rotation(RRRStone));
  end Valid_Moves;

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

  procedure Connects (Board: In Board_T;
                      Stone: In Rotated_Stone_T;
                      Placement: In Point_T;
                      Consistent_Connectives: Out Connective_Sets.Set;
                      Increasing_Connectives: Out Connective_Sets.Set) is
    Northern_Border: constant Border_T := Get_Border (Stone.Stone, North);
    Southern_Border: constant Border_T := Get_Border (Stone.Stone, South);
    Eastern_Border: constant Border_T := Get_Border (Stone.Stone, East);
    Western_Border: constant Border_T := Get_Border (Stone.Stone, West);
    Width: constant Positive := Get_Width(Stone);
    Height: constant Positive := Get_Height(Stone);
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

  function Stone_From_Borders(Northern_Border: Border_T;
    Eastern_Border: Border_T;
    Southern_Border: Border_T;
    Western_Border: Border_T)
    return Stone_T is
    Stone_Width:  constant Positive := Northern_Border'Length;
    Stone_Height: constant Positive := Eastern_Border'Length;
    Stone: Stone_T(1 .. Stone_Width, 1 .. Stone_Height) := (
      others => (
        others => (North => Inner,
        East => Inner,
        South => Inner,
        West => Inner)));
  begin
    if Southern_Border'Length /= Stone_Width or Western_Border'Length /= Stone_Height then
      -- errorneous state
      raise Board_Error with "Inconsistent borders for stone.";
    end if;

    declare
      Stone_X: Positive := 1;
    begin
      for I in Northern_Border'Range loop
        Stone(Stone_X, Stone'First(2))(North) := Northern_Border(I);
        Stone_X := Stone_X + 1;
      end loop;
    end;

    declare
      Stone_X: Positive := 1;
    begin
      for I in reverse Southern_Border'Range loop
        Stone(Stone_X, Stone'Last(2))(South) := Southern_Border(I);
        Stone_X := Stone_X + 1;
      end loop;
    end;

    declare
      Stone_Y: Positive := 1;
    begin
      for I in Eastern_Border'Range loop
        Stone(Stone'Last(1), Stone_Y)(East) := Eastern_Border(I);
        Stone_Y := Stone_Y + 1;
      end loop;
    end;

    declare
      Stone_Y: Positive := 1;
    begin
      for I in reverse Western_Border'Range loop
        Stone(Stone'First(1), Stone_Y)(West) := Western_Border(I);
        Stone_Y := Stone_Y + 1;
      end loop;
    end;
    return Stone;
  end Stone_From_Borders;

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

  function Get_Border (Stone: In Stone_T; Direction: In Direction_T)
    return Border_T is
  begin
    case Direction is
      when North =>
        declare
          Border: Border_T (1 .. Get_Width(Stone)) := (others => Closed);
          Border_X: Positive := 1;
        begin
          for X in Stone'Range(1) loop
            Border(Border_X) := Stone(X, Stone'First(2))(North);
            Border_X := Border_X+1;
          end loop;
          return Border;
        end;
      when South =>
        declare
          Border: Border_T (1 .. Get_Width(Stone)) := (others => Closed);
          Border_X: Positive := 1;
        begin
          for X in Stone'Range(1) loop
            Border (Border_X) := Stone (Stone'Last(1) - X + Stone'First(1), Stone'Last(2))(South);
            Border_X := Border_X+1;
          end loop;
          return Border;
        end;
      when East =>
        declare
          Border: Border_T (1 .. Get_Height(Stone)) := (others => Closed);
          Border_Y: Positive := 1;
        begin
          for Y in Stone'Range(2) loop
            Border (Border_Y) := Stone (Stone'Last(1), Y)(East);
            Border_Y := Border_Y + 1;
          end loop;
          return Border;
        end;
      when West =>
        declare
          Border: Border_T (1 .. Get_Height(Stone)) := (others => Closed);
          Border_Y: Positive := 1;
        begin
          for Y in Stone'Range(2) loop
            Border (Border_Y) := Stone (1, Stone'Last(2) - Y + Stone'First(2))(West);
            Border_Y := Border_Y + 1;
          end loop;
          return Border;
        end;
    end case;
  end Get_Border;

  function Rotate (Stone: In Stone_T; Repetitions: In Rotation_T := 1) return Stone_T is
  begin
    case Repetitions is
      when 0 => return Stone_From_Borders(Get_Border(Stone, North),
                                          Get_Border(Stone, East),
                                          Get_Border(Stone, South),
                                          Get_Border(Stone, West));
      when 1 => return Stone_From_Borders(Get_Border(Stone, West),
                                          Get_Border(Stone, North),
                                          Get_Border(Stone, East),
                                          Get_Border(Stone, South));
      when 2 => return Stone_From_Borders(Get_Border(Stone, South),
                                          Get_Border(Stone, West),
                                          Get_Border(Stone, North),
                                          Get_Border(Stone, East));
      when 3 => return Stone_From_Borders(Get_Border(Stone, East),
                                          Get_Border(Stone, South),
                                          Get_Border(Stone, West),
                                          Get_Border(Stone, North));
      when others => raise Constraint_Error with "Value of Repetitions is not in the expected range of Rotation_T";
    end case;
  end Rotate;
end Board;
