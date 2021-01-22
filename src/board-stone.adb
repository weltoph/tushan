package body Board.Stone is
  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
                   Placement_X: X_Coordinate;
                   Placement_Y: Y_Coordinate) is
  begin
    for X in 1 .. Stone'Length (1) loop
      for Y in 1 .. Stone'Length (2) loop
        declare
          Current_X: constant X_Coordinate := Placement_X + X - 1;
          Current_Y: constant Y_Coordinate := Placement_Y + Y - 1;
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

  function Get_Northern_Border (Stone: In Stone_T) return Horizontal_Border_T is
    Width: constant X_Coordinate := Get_Width (Stone);
    Border: Horizontal_Border_T(1 .. Width) := (others => Closed);
  begin
    for X in 1 .. Width loop
      Border (X) := Stone (X, 1)(North);
    end loop;
    return Border;
  end Get_Northern_Border;

  function Get_Eastern_Border (Stone: In Stone_T) return Vertical_Border_T is
    Width: constant X_Coordinate := Get_Width (Stone);
    Height: constant Y_Coordinate := Get_Height (Stone);
    Border: Vertical_Border_T(1 .. Height) := (others => Closed);
  begin
    for Y in 1 .. Height loop
      Border (Y) := Stone (Width, Y)(East);
    end loop;
    return Border;
  end Get_Eastern_Border;

  function Get_Southern_Border (Stone: In Stone_T) return Horizontal_Border_T is
    Width: constant X_Coordinate := Get_Width (Stone);
    Height: constant Y_Coordinate := Get_Height (Stone);
    Border: Horizontal_Border_T(1 .. Width) := (others => Closed);
  begin
    for X in 1 .. Width loop
      Border (X) := Stone (Width - X + 1, Height)(South);
    end loop;
    return Border;
  end Get_Southern_Border;

  function Get_Western_Border (Stone: In Stone_T) return Vertical_Border_T is
    Height: constant Y_Coordinate := Get_Height (Stone);
    Border: Vertical_Border_T(1 .. Height) := (others => Closed);
  begin
    for Y in 1 .. Height loop
      Border (Y) := Stone (1, Height - Y + 1)(West);
    end loop;
    return Border;
  end Get_Western_Border;

  function Rotate (Stone: In Stone_T) return Stone_T is
    Old_Height: constant Y_Coordinate := Get_Height (Stone);
    Old_Width: constant X_Coordinate := Get_Width (Stone);

    Old_North: Horizontal_Border_T := Get_Northern_Border (Stone);
    Old_East: Vertical_Border_T := Get_Eastern_Border (Stone);
    Old_South: Horizontal_Border_T := Get_Southern_Border (Stone);
    Old_West: Vertical_Border_T := Get_Western_Border (Stone);

    New_North: Horizontal_Border_T (1 .. Old_Height) := (others => Closed);
    New_East: Vertical_Border_T (1 .. Old_Width) := (others => Closed);
    New_South: Horizontal_Border_T (1 .. Old_Height) := (others => Closed);
    New_West: Vertical_Border_T (1 .. Old_Width) := (others => Closed);
  begin
    for X in 1 .. Old_Height loop
      New_North (X) := Old_West (X);
      New_South (X) := Old_East (X);
    end loop;

    for Y in 1 .. Old_Width loop
      New_West (Y) := Old_South (Y);
      New_East (Y) := Old_North (Y);
    end loop;
    return Stone_From_Borders (
      New_North,
      New_East,
      New_South,
      New_West);
  end Rotate;

 function Stone_From_Borders(Northern_Border: Horizontal_Border_T;
                             Eastern_Border: Vertical_Border_T;
                             Southern_Border: Horizontal_Border_T;
                             Western_Border: Vertical_Border_T)
                             return Stone_T is
   Width:  constant X_Coordinate := Northern_Border'Length;
   Height: constant X_Coordinate := Eastern_Border'Length;
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
                Board: In Out Board_T;
                Placement_X: X_Coordinate;
                Placement_Y: Y_Coordinate)
   return Boolean is
   Width: constant X_Coordinate := Get_Width (Stone);
   Height: constant X_Coordinate := Get_Height (Stone);

   Max_Width: constant X_Coordinate := Board'Length (1) - Placement_X + 1;
   Max_Height: constant Y_Coordinate := Board'Length (2) - Placement_Y + 1;
 begin
   -- check out of bounds
   if Width > Max_Width or Height > Max_Height then
     return False;
   end if;
   -- check that all places on the board are not yet occupied
   for X in Placement_X .. Placement_X + Width - 1 loop
     for Y in Placement_Y .. Placement_Y + Height - 1 loop
       if Board(X, Y).Occupied then
         return False;
       end if;
     end loop;
   end loop;
   return True;
 end Fits;

--   function Piece_Connects (On_Board: In Board_T;
--                            Piece: In Piece_T;
--                            At_Point: In Point_T)
--     return Boolean is
--     Northern_Border: constant Horizontal_Border_T
--       := Get_Northern_Border (Piece);
--     Southern_Border: constant Horizontal_Border_T
--       := Get_Southern_Border (Piece);
--     Western_Border: constant Vertical_Border_T
--       := Get_Western_Border (Piece);
--     Eastern_Border: constant Vertical_Border_T
--       := Get_Eastern_Border (Piece);

--     Found_Open_Connection: Boolean := False;

--     function Check_Combination (Piece_Connector, Opposite : In Connector_T)
--       return Boolean is
--     begin
--       if (Opposite = Open and Northern_Connector = Closed)
--         or (Opposite = Closed and Northern_Connector = Open) then
--         return False;
--       elsif (Opposite = Open and Northern_Connector = Open) then
--         Found_Open_Connection := True;
--       end if;
--       return True;
--     end Check_Combination;

--   begin
--     for X in Northern_Border'Range loop
--       declare
--         Relative_X: constant X_Coordinate := X - Northern_Border'First(1);
--         Board_X: constant X_Coordinate := At_Point.X + Relative_X;
--         Northern_Connector: constant Connector_T := Northern_Border(X);
--         Southern_Connector: constant Connector_T := Southern_Border(X);

--         Touches_Northern_Border: constant Boolean
--           := At_Point.Y = On_Board'First(2);
--         Touches_Southern_Border: constant Boolean
--           := At_Point.Y = On_Board'Last(2);
--       begin
--         if not Touches_Northern_Border then
--           declare
--             Opposite: constant Connector_T
--               := On_Board(Board_X, At_Point.Y - 1)(South);
--           begin
--             if not Check_Combination (Northern_Connector, Opposite) then
--               return False;
--             end if;
--           end;
--         end if;

--         if not Touches_Southern_Border then
--           declare
--             Opposite: constant Connector_T
--               := On_Board(Board_X, At_Point.Y + 1)(North);
--           begin
--             if not Check_Combination (Southern_Connector, Opposite) then
--               return False;
--             end if;
--           end;
--         end if;
--       end;
--     end loop;

--     for Y in Western_Border'Range loop
--       declare
--         Relative_Y: constant Y_Coordinate := Y - Western_Border'First;
--         Board_Y: constant Y_Coordinate := At_Point.Y + Relative_Y;
--         Eastern_Connector: constant Connector_T := Eastern_Border(Y);
--         Western_Connector: constant Connector_T := Western_Border(Y);

--         Touches_Eastern_Border: constant Boolean
--           := At_Point.X = On_Board'Last(1);
--         Touches_Western_Border: constant Boolean
--           := At_Point.X = On_Board'First(1);
--       begin
--         if not Touches_Eastern_Border then
--           declare
--             Opposite: constant Connector_T
--               := On_Board(At_Point.X + 1, Board_Y)(West);
--           begin
--             if not Check_Combination (Eastern_Connector, Opposite) then
--               return False;
--             end if;
--           end;
--         end if;

--         if not Touches_Western_Border then
--           declare
--             Opposite: constant Connector_T
--               := On_Board(At_Point.X - 1, Board_Y)(East);
--           begin
--             if not Check_Combination (Western_Connector, Opposite) then
--               return False;
--             end if;
--           end;
--         end if;
--       end;
--     end loop;

--     return Found_Open_Connection;
--   end Piece_Connects;


--   function Get_Northern_Border (Piece: Piece_T) return Horizontal_Border_T is
--     Width: constant X_Coordinate := Piece'Length(1);
--     Border: Horizontal_Border_T(1 .. Width);
--   begin
--     for X in Border'Range loop
--       Border(X) := Piece(Piece'First(1) + (X - 1), Piece'First(2))(North);
--     end loop;
--     return Border;
--   end Get_Northern_Border;

--   function Get_Southern_Border (Piece: Piece_T) return Horizontal_Border_T is
--     Width: constant X_Coordinate := Piece'Length(1);
--     Border: Horizontal_Border_T(1 .. Width);
--   begin
--     for X in Border'Range loop
--       Border(X) := Piece(Piece'First(1) + (X - 1), Piece'Last(2))(South);
--     end loop;
--     return Border;
--   end Get_Southern_Border;

--   function Get_Eastern_Border (Piece: Piece_T) return Vertical_Border_T is
--     Height: constant Y_Coordinate := Piece'Length(2);
--     Border: Vertical_Border_T(1 .. Height);
--   begin
--     for Y in Border'Range loop
--       Border(Y) := Piece(Piece'Last(1), Piece'First(2) + (Y - 1))(East);
--     end loop;
--     return Border;
--   end Get_Eastern_Border;

--   function Get_Western_Border (Piece: Piece_T) return Vertical_Border_T is
--     Height: constant Y_Coordinate := Piece'Length(2);
--     Border: Vertical_Border_T(1 .. Height);
--   begin
--     for Y in Border'Range loop
--       Border(Y) := Piece(Piece'First(1), Piece'First(2) + (Y - 1))(West);
--     end loop;
--     return Border;
--   end Get_Western_Border;

  function Get_Width (Stone: in Stone_T) return X_Coordinate is
  begin
    return Stone'Length (1);
  end Get_Width;

  function Get_Height (Stone: in Stone_T) return Y_Coordinate is
  begin
    return Stone'Length (2);
  end Get_Height;

end Board.Stone;
