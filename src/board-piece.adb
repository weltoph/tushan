with Ada.Text_IO;
package body Board.Piece is

  function Fits(Piece: Piece_T; At_Point: Point_T; On_Board: Board_T)
    return Boolean is
    Piece_Begin_X: constant Positive := At_Point.X;
    Piece_End_X: constant Positive := At_Point.X + Piece'Length(1);

    Piece_Begin_Y: constant Positive := At_Point.Y;
    Piece_End_Y: constant Positive := At_Point.Y + Piece'Length(2);

    Board_Width: constant Positive := On_Board'Length(1);
    Board_Heigth: constant Positive := On_Board'Length(2);
  begin
    if Piece_Begin_X > Board_Width or Piece_End_X > Board_Width then
      return False;
    end if;
    if Piece_Begin_Y > Board_Heigth or Piece_End_Y > Board_Heigth then
      return False;
    end if;
    for X in Piece_Begin_X .. Piece_End_X loop
      for Y in Piece_Begin_Y .. Piece_End_Y loop
        if On_Board(X, Y) /= null then
          return False;
        end if;
      end loop;
    end loop;
    return True;
  end Fits;

  function Rotate_Piece (Piece: Piece_T; To: Direction_T) return Piece_T is
    function Rotate_Field (Field: Field_Access_T) return Field_Access_T is
    begin
      case To is
        when East =>
          return new Field_T'(North => Field.all(North),
                              East => Field.all(East),
                              South => Field.all(South),
                              West => Field.all(West));
        when South =>
          return new Field_T'(North => Field.all(West),
                              East => Field.all(North),
                              South => Field.all(East),
                              West => Field.all(South));
        when West =>
          return new Field_T'(North => Field.all(South),
                              East => Field.all(West),
                              South => Field.all(North),
                              West => Field.all(East));
        when North =>
          return new Field_T'(North => Field.all(East),
                              East => Field.all(South),
                              South => Field.all(West),
                              West => Field.all(North));
      end case;
    end Rotate_Field;
  begin
    case To is
      when East =>
        declare
          Result: Piece_T(1 .. Piece'Length(1), 1 .. Piece'Length(2)) := (others => (others => null));
          New_X: Positive := 1;
          New_Y: Positive := 1;
        begin
          for X in Piece'Range(1) loop
            for Y in Piece'Range(2) loop
              Result(New_X, New_Y) := Rotate_Field(Piece(X, Y));
              New_Y := New_Y + 1;
            end loop;
            New_X := New_X + 1;
            New_Y := 1;
          end loop;
          return Result;
        end;
      when South =>
        declare
          Result: Piece_T(1 .. Piece'Length(2), 1 .. Piece'Length(1)) := (others => (others => null));
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
        end;
      when West =>
        declare
          Result: Piece_T(1 .. Piece'Length(1), 1 .. Piece'Length(2)) := (others => (others => null));
          New_X: Positive := 1;
          New_Y: Positive := 1;
        begin
          for X in reverse Piece'Range(1) loop
            for Y in reverse Piece'Range(2) loop
              Result(New_X, New_Y) := Rotate_Field(Piece(X, Y));
              New_Y := New_Y + 1;
            end loop;
            New_X := New_X + 1;
            New_Y := 1;
          end loop;
          return Result;
        end;
      when North =>
        declare
          Result: Piece_T(1 .. Piece'Length(2), 1 .. Piece'Length(1)) := (others => (others => null));
          New_X: Positive := 1;
          New_Y: Positive := 1;
        begin
          for X in reverse Piece'Range(1) loop
            for Y in Piece'Range(2) loop
              Result(New_X, New_Y) := Rotate_Field(Piece(X, Y));
              New_X := New_X + 1;
            end loop;
            New_Y := New_Y + 1;
            New_X := 1;
          end loop;
          return Result;
        end;
    end case;
  end;
end Board.Piece;
