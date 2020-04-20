with AUnit.Assertions;
with Board.Piece;
with Ada.Text_IO;

package body Piece_Test is
  package Board_10 is new Board(10, 10);
  package Piece_10 is new Board_10.Piece;

  procedure Register_Tests (T: in out Piece_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Rotation'Access, "Test Rotation of Piece");
   end Register_Tests;

  function Name (T: Piece_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing Piece");
  end Name;

  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    use Piece_10;
    ----------------------------------------------------
    --    East   --   South  --    West   --   North  --
    --  ------>  -- |  x o   --  <------  -- ^  x o   --
    --   x o x   -- |x|_|_|x --   o o x   -- |x|_|_|o --
    -- o|_|_|_|x -- |o|_|_|o -- o|_|_|_|x -- |o|_|_|o --
    -- x|_|_|_|o -- |o|_|_|x -- x|_|_|_|o -- |x|_|_|x --
    --   x o o   -- v  o x   --   x o x   -- |  o x   --
    ----------------------------------------------------
    East_Piece: constant Piece_T := (
      1 => (1 => new Field_T'(North => Closed, East => Inner, South => Inner, West => Open),
            2 => new Field_T'(North => Inner, East => Inner, South => Closed, West => Closed)),
      2 => (1 => new Field_T'(North => Open, East => Inner, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Inner, South => Open, West => Inner)),
      3 => (1 => new Field_T'(North => Closed, East => Closed, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Open, South => Open, West => Inner)));
    South_Piece: constant Piece_T := (
      1 => (1 => new Field_T'(North => Closed, East => Inner, South => Inner, West => Closed),
            2 => new Field_T'(North => Inner, East => Inner, South => Inner, West => Open),
            3 => new Field_T'(North => Inner, East => Inner, South => Open, West => Open)),
      2 => (1 => new Field_T'(North => Open, East => Closed, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Open, South => Inner, West => Inner),
            3 => new Field_T'(North => Inner, East => Closed, South => Closed, West => Inner)));
    West_Piece: constant Piece_T := (
      1 => (1 => new Field_T'(North => Open, East => Inner, South => Inner, West => Open),
            2 => new Field_T'(North => Inner, East => Inner, South => Closed, West => Closed)),
      2 => (1 => new Field_T'(North => Open, East => Inner, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Inner, South => Open, West => Inner)),
      3 => (1 => new Field_T'(North => Closed, East => Closed, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Open, South => Closed, West => Inner)));
    North_Piece: constant Piece_T := (
      1 => (1 => new Field_T'(North => Closed, East => Inner, South => Inner, West => Closed),
            2 => new Field_T'(North => Inner, East => Inner, South => Inner, West => Open),
            3 => new Field_T'(North => Inner, East => Inner, South => Open, West => Closed)),
      2 => (1 => new Field_T'(North => Open, East => Open, South => Inner, West => Inner),
            2 => new Field_T'(North => Inner, East => Open, South => Inner, West => Inner),
            3 => new Field_T'(North => Inner, East => Closed, South => Closed, West => Inner)));

    procedure Test_Piece_Equivalence (LHS, RHS: Piece_T) is
    begin
      AUnit.Assertions.Assert (LHS'First(1) = RHS'First(1), "Equivalent first (1)");
      AUnit.Assertions.Assert (LHS'First(2) = RHS'First(2), "Equivalent first (2)");
      AUnit.Assertions.Assert (LHS'Last(1) = RHS'Last(1), "Equivalent last (1)");
      AUnit.Assertions.Assert (LHS'Last(2) = RHS'Last(2), "Equivalent last (2)");
      for X in LHS'Range(1) loop
        for Y in LHS'Range(2) loop
          AUnit.Assertions.Assert (LHS(X, Y).all = RHS(X, Y).all, "Equivalent element <" & Positive'Image(X) & ", " & Positive'Image(Y) & ">");
        end loop;
      end loop;
    end Test_Piece_Equivalence;
  begin
    Test_Piece_Equivalence (Piece_10.Rotate_Piece(East_Piece, East), East_Piece);
    Test_Piece_Equivalence (Piece_10.Rotate_Piece(East_Piece, South), South_Piece);
    Test_Piece_Equivalence (Piece_10.Rotate_Piece(East_Piece, West), West_Piece);
    Test_Piece_Equivalence (Piece_10.Rotate_Piece(East_Piece, North), North_Piece);
  end Test_Rotation;

end Piece_Test;
