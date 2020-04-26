package body Board.Stone is
  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
                   Placement_X: X_Coordinate;
                   Placement_Y: Y_Coordinate) is
  begin
    for X in Stone'Range(1) loop
      for Y in Stone'Range(2) loop
        declare
          Current_X: constant X_Coordinate := Placement_X
            + (X - Stone'First(1) + 1);
          Current_Y: constant Y_Coordinate := Placement_Y
            + (Y - Stone'First(2) + 1);
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


--   function Rotate_Piece (Piece: In Piece_T) return Piece_T is
--     function Rotate_Field (Field: Field_T) return Field_T is
--     begin
--       return (North => Field(West),
--               East =>  Field(North),
--               South => Field(East),
--               West =>  Field(South));
--     end Rotate_Field;

--     Result: Piece_T(1 .. Piece'Length(2), 1 .. Piece'Length(1));
--     New_X: Positive := 1;
--     New_Y: Positive := 1;
--   begin
--     for X in Piece'Range(1) loop
--       for Y in reverse Piece'Range(2) loop
--         Result(New_X, New_Y) := Rotate_Field(Piece(X, Y));
--         New_X := New_X + 1;
--       end loop;
--       New_Y := New_Y + 1;
--       New_X := 1;
--     end loop;
--     return Result;
--   end Rotate_Piece;

 function Stone_From_Borders(Northern_Border: Horizontal_Border_T;
                             Eastern_Border: Vertical_Border_T;
                             Southern_Border: Horizontal_Border_T;
                             Western_Border: Vertical_Border_T)
                             return Stone_T is
   Width:  constant X_Coordinate := Northern_Border'Size;
   Height: constant X_Coordinate := Eastern_Border'Size;
   Stone: Stone_T(1 .. Width, 1 .. Height) := (others => (others => (
     North => Inner, East => Inner, South => Inner, West => Inner)));
 begin
   if Southern_Border'Size /= Width or Western_Border'Size /= Height then
     -- errorneous state
     raise Board_Error with "Inconsistent borders for stone.";
   end if;

   for X in 1 .. Width loop
     declare
       Northern: constant Border_Connector_T := Northern_Border(X);
       Southern: constant Border_Connector_T := Southern_Border(X);
     begin
       Stone(X, 1)(North) := Northern;
       Stone(X, Height)(North) := Southern;
     end;
   end loop;

   for Y in 1 .. Height loop
     declare
       Eastern: constant Border_Connector_T := Eastern_Border(Y);
       Western: constant Border_Connector_T := Western_Border(Y);
     begin
       Stone(1, Y)(West) := Western;
       Stone(Width, Y)(East) := Eastern;
     end;
   end loop;

   return Stone;
 end Stone_From_Borders;

--   function Piece_Fits (On_Board: In Board_T;
--                        At_Point: In Point_T;
--                        Piece: In Piece_T)
--     return Boolean is
--     Piece_Begin_X: constant Positive := At_Point.X;
--     Piece_End_X: constant Positive := At_Point.X + Piece'Length(1) - 1;

--     Piece_Begin_Y: constant Positive := At_Point.Y;
--     Piece_End_Y: constant Positive := At_Point.Y + Piece'Length(2) - 1;

--     Board_Width: constant Positive := On_Board'Length(1);
--     Board_Heigth: constant Positive := On_Board'Length(2);
--   begin
--     -- check out of boundness for width
--     if Piece_Begin_X > Board_Width or Piece_End_X > Board_Width then
--       return False;
--     end if;
--     -- check out of boundness for height
--     if Piece_Begin_Y > Board_Heigth or Piece_End_Y > Board_Heigth then
--       return False;
--     end if;
--     -- check that all places on the board are not yet occupied
--     for X in Piece_Begin_X .. Piece_End_X loop
--       for Y in Piece_Begin_Y .. Piece_End_Y loop
--         if On_Board(X, Y).Status /= Empty then
--           return False;
--         end if;
--       end loop;
--     end loop;
--     return True;
--   end Piece_Fits;

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
--         Relative_X: constant X_Coordinate_T := X - Northern_Border'First(1);
--         Board_X: constant X_Coordinate_T := At_Point.X + Relative_X;
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
--         Relative_Y: constant Y_Coordinate_T := Y - Western_Border'First;
--         Board_Y: constant Y_Coordinate_T := At_Point.Y + Relative_Y;
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
--     Width: constant X_Coordinate_T := Piece'Length(1);
--     Border: Horizontal_Border_T(1 .. Width);
--   begin
--     for X in Border'Range loop
--       Border(X) := Piece(Piece'First(1) + (X - 1), Piece'First(2))(North);
--     end loop;
--     return Border;
--   end Get_Northern_Border;

--   function Get_Southern_Border (Piece: Piece_T) return Horizontal_Border_T is
--     Width: constant X_Coordinate_T := Piece'Length(1);
--     Border: Horizontal_Border_T(1 .. Width);
--   begin
--     for X in Border'Range loop
--       Border(X) := Piece(Piece'First(1) + (X - 1), Piece'Last(2))(South);
--     end loop;
--     return Border;
--   end Get_Southern_Border;

--   function Get_Eastern_Border (Piece: Piece_T) return Vertical_Border_T is
--     Height: constant Y_Coordinate_T := Piece'Length(2);
--     Border: Vertical_Border_T(1 .. Height);
--   begin
--     for Y in Border'Range loop
--       Border(Y) := Piece(Piece'Last(1), Piece'First(2) + (Y - 1))(East);
--     end loop;
--     return Border;
--   end Get_Eastern_Border;

--   function Get_Western_Border (Piece: Piece_T) return Vertical_Border_T is
--     Height: constant Y_Coordinate_T := Piece'Length(2);
--     Border: Vertical_Border_T(1 .. Height);
--   begin
--     for Y in Border'Range loop
--       Border(Y) := Piece(Piece'First(1), Piece'First(2) + (Y - 1))(West);
--     end loop;
--     return Border;
--   end Get_Western_Border;


end Board.Stone;
