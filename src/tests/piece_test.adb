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
      1 => (1 => (North => Closed, East => Inner, South => Inner, West => Open),
            2 => (North => Inner, East => Inner, South => Closed, West => Closed)),
      2 => (1 => (North => Open, East => Inner, South => Inner, West => Inner),
            2 => (North => Inner, East => Inner, South => Open, West => Inner)),
      3 => (1 => (North => Closed, East => Closed, South => Inner, West => Inner),
            2 => (North => Inner, East => Open, South => Open, West => Inner)));
    South_Piece: constant Piece_T := (
      1 => (1 => (North => Closed, East => Inner, South => Inner, West => Closed),
            2 => (North => Inner, East => Inner, South => Inner, West => Open),
            3 => (North => Inner, East => Inner, South => Open, West => Open)),
      2 => (1 => (North => Open, East => Closed, South => Inner, West => Inner),
            2 => (North => Inner, East => Open, South => Inner, West => Inner),
            3 => (North => Inner, East => Closed, South => Closed, West => Inner)));
    West_Piece: constant Piece_T := (
      1 => (1 => (North => Open, East => Inner, South => Inner, West => Open),
            2 => (North => Inner, East => Inner, South => Closed, West => Closed)),
      2 => (1 => (North => Open, East => Inner, South => Inner, West => Inner),
            2 => (North => Inner, East => Inner, South => Open, West => Inner)),
      3 => (1 => (North => Closed, East => Closed, South => Inner, West => Inner),
            2 => (North => Inner, East => Open, South => Closed, West => Inner)));
    North_Piece: constant Piece_T := (
      1 => (1 => (North => Closed, East => Inner, South => Inner, West => Closed),
            2 => (North => Inner, East => Inner, South => Inner, West => Open),
            3 => (North => Inner, East => Inner, South => Open, West => Closed)),
      2 => (1 => (North => Open, East => Open, South => Inner, West => Inner),
            2 => (North => Inner, East => Open, South => Inner, West => Inner),
            3 => (North => Inner, East => Closed, South => Closed, West => Inner)));

  begin
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, East) = East_Piece, "East rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, South) = South_Piece, "South rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, West) = West_Piece, "West rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, North) = North_Piece, "North rotation test");
  end Test_Rotation;

end Piece_Test;
