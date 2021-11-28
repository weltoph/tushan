package body Board.Stone is
  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
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

  function Fits_Dimensions (Stone: In Stone_T; Point: In Point_T) return Boolean is
    Max_Width: constant X_Coordinate := Width - Point.X + 1;
    Max_Height: constant Y_Coordinate := Height - Point.Y + 1;
  begin
    return Get_Width (Stone) <= Max_Width and Get_Height (Stone) <= Max_Height;
  end;

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

  function Fits (Stone: In Stone_T;
    Board: In Board_T;
    Placement: In Point_T) return Boolean is

    Max_Width: constant X_Coordinate := Width - Placement.X + 1;
    Max_Height: constant Y_Coordinate := Height - Placement.Y + 1;
  begin
    -- check out of bounds
    if not Fits_Dimensions (Stone, Placement) then
      return False;
    end if;
    -- check that all places on the board are not yet occupied
    for P of Covers (Stone, Placement) loop
      if Board(P.X, P.Y).Occupied then
        return False;
      end if;
    end loop;
    return True;
  end Fits;

  function Get_Width (Stone: in Stone_T) return Positive is
  begin
    return Stone'Length (1);
  end Get_Width;

  function Get_Height (Stone: in Stone_T) return Positive is
  begin
    return Stone'Length (2);
  end Get_Height;

  procedure Connects (Stone: In Stone_T;
                     Board: In Board_T;
                     Placement: In Point_T;
                     Consistent: Out Boolean;
                     Increasing: Out Boolean) is
    Northern_Border: constant Border_T := Get_Border (Stone, North);
    Southern_Border: constant Border_T := Get_Border (Stone, South);
    Eastern_Border: constant Border_T := Get_Border (Stone, East);
    Western_Border: constant Border_T := Get_Border (Stone, West);
    Width: constant Positive := Get_Width (Stone);
    Height: constant Positive := Get_Height (Stone);
  begin
    Consistent := True;
    Increasing := False;
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
          Consistent := False;
        elsif N = Closed and ON = Open then
          Consistent := False;
        elsif S = Open and OS = Closed then
          Consistent := False;
        elsif S = Closed and OS = Open then
          Consistent := False;
        end if;
        if N = Open and ON = Open then
          Increasing := True;
        end if;
        if S = Open and OS = Open then
          Increasing := True;
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
          Consistent := False;
        elsif E = Closed and OE = Open then
          Consistent := False;
        elsif W = Open and OW = Closed then
          Consistent := False;
        elsif W = Closed and OW = Open then
          Consistent := False;
        end if;
        if E = Open and OE = Open then
          Increasing := True;
        end if;
        if W = Open and OW = Open then
          Increasing := True;
        end if;
      end;
    end loop;
  end Connects;

end Board.Stone;
