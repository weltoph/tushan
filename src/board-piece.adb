package body Board.Piece is

  function Fits(Piece: Piece_T; At_Point: Point_T; On_Board: Board_T)
    return Boolean is
    Piece_Begin_X: constant Positive := At_Point.X;
    Piece_End_X: constant Positive := At_Point.X + Piece'Length(1) - 1;

    Piece_Begin_Y: constant Positive := At_Point.Y;
    Piece_End_Y: constant Positive := At_Point.Y + Piece'Length(2) - 1;

    Board_Width: constant Positive := On_Board'Length(1);
    Board_Heigth: constant Positive := On_Board'Length(2);
  begin
    -- check out of boundness for width
    if Piece_Begin_X > Board_Width or Piece_End_X > Board_Width then
      return False;
    end if;
    -- check out of boundness for height
    if Piece_Begin_Y > Board_Heigth or Piece_End_Y > Board_Heigth then
      return False;
    end if;
    -- check that all places on the board are not yet occupied
    for X in Piece_Begin_X .. Piece_End_X loop
      for Y in Piece_Begin_Y .. Piece_End_Y loop
        if On_Board(X, Y).Status /= Empty then
          return False;
        end if;
      end loop;
    end loop;
    return True;
  end Fits;

  function Rotate_Piece (Piece: In Piece_T) return Piece_T is
    function Rotate_Field (Field: Field_T) return Field_T is
    begin
      return (North => Field(West),
              East =>  Field(North),
              South => Field(East),
              West =>  Field(South));
    end Rotate_Field;

    Result: Piece_T(1 .. Piece'Length(2), 1 .. Piece'Length(1));
    New_X: Positive := 1;
    New_Y: Positive := 1;
  begin
    for X in Piece'Range(1) loop
      for Y in reverse Piece'Range(2) loop
        Result(New_X, New_Y) := Rotate_Field(Piece(X, Y));
        New_X := New_X + 1;
      end loop;
      New_Y := New_Y + 1;
      New_X := 1;
    end loop;
    return Result;
  end Rotate_Piece;

  function Piece_From_Borders (Northern_Border: Horizontal_Border_T;
                               Eastern_Border: Vertical_Border_T;
                               Southern_Border: Horizontal_Border_T;
                               Western_Border: Vertical_Border_T)
                               return Piece_T is
    Width: constant X_Coordinate_T := Northern_Border'Size;
    Height: constant X_Coordinate_T := Eastern_Border'Size;
    Piece: Piece_T(1 .. Width, 1 .. Height) := (others => (others => (others => Inner)));
  begin
    if Southern_Border'Size /= Width or Western_Border'Size then
      -- errorneous state
      raise Board_Error with "Inconsistent borders for piece.";
    end if;

    for X in 1 .. Width loop
      declare
        Northern: constant Border_Connector_T := Northern_Border(X);
        Southern: constant Border_Connector_T := Southern_Border(X);
      begin
        Piece(X, 1)(North) := Northern;
        Piece(X, Height)(North) := Southern;
      end;
    end loop;

    for Y in 1 .. Height loop
      declare
        Eastern: constant Border_Connector_T := Eastern_Border(X);
        Western: constant Border_Connector_T := Western_Border(X);
      begin
        Piece(1, Y)(West) := Western;
        Piece(Width, Y)(East) := Eastern;
      end;
    end loop;

    return Piece;
  end Piece_From_Borders;

  function Get_Northern_Border (Piece: Piece_T) return Horizontal_Border_T;
  function Get_Southern_Border (Piece: Piece_T) return Horizontal_Border_T;
  function Get_Eastern_Border (Piece: Piece_T) return Vertical_Border_T;
  function Get_Western_Border (Piece: Piece_T) return Vertical_Border_T;
end Board.Piece;
