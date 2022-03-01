with AUnit.Assertions;
with Ada.Text_IO;
with Board;

package body Board_Test is
  package Board_10 is new Board(10, 10, 3, 2);

  procedure Register_Tests (T: in out Board_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Place'Access, "Test placement of stone");
      Register_Routine (T, Test_Covers'Access, "Test cover of stone");
      Register_Routine (T, Test_Connectives'Access, "Test connectives of stone");
      Register_Routine (T, Test_Fits_Dimensions'Access, "Test dimentional fit of stone");
      Register_Routine (T, Test_Connects'Access, "Test connections of stone");
      --  Register_Routine (T, Test_Valid_Moves'Access, "Test valid moves for stone on board");
   end Register_Tests;

  function Name (T: Board_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing stone");
  end Name;

  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Test_Stone: constant Board_10.Stone_T := Board_10.Stone_From_Borders (
      (1 => Open, 2 => Closed, 3 => Closed),
      (1 => Closed, 2 => Open),
      (1 => Closed, 2 => Closed, 3 => Open),
      (1 => Closed, 2 => Closed));
    Placement: constant Board_10.Point_T := (5, 3);
    type Board_State is array (Board_10.X_Coordinate, Board_10.Y_Coordinate, Direction_T) of Connector_T;

    procedure Test_Case(Rotated_Stone: In Board_10.Rotated_Stone_T; Expected_Board: In Board_State) is
      Test_Board: Board_10.Board_T;
    begin
      Place(Test_Board, Rotated_Stone, Placement);
      for X in Board_10.X_Coordinate loop
        for Y in Board_10.Y_Coordinate loop
          declare
            Current_Point: constant Board_10.Point_T := (X, Y);
          begin
            for Dir in Direction_T loop
              AUnit.Assertions.Assert(Get_Connector(Test_Board, Current_Point, Dir) = Expected_Board(X, Y, Dir),
                                      "Mismatch at <" & Current_Point.X'Image & "," & Current_Point.Y'Image & ">:" & Dir'Image
                                      & " Expected: " & Expected_Board(X, Y, Dir)'Image & ", Actual: " & Get_Connector(Test_Board, Current_Point, Dir)'Image);
            end loop;
          end;
        end loop;
      end loop;
    end;
  begin
    declare
      Rotated_Stone: constant Board_10.Rotated_Stone_T := (Test_Stone, 0);
      Expected_Board: constant Board_State  := (
        5 => (
          3 => (North => Open, West => Closed, Others => Inner),
          4 => (South => Open, West => Closed, Others => Inner),
          Others => (Others => Empty)),
        6 => (
          3 => (North => Closed, Others => Inner),
          4 => (South => Closed, Others => Inner),
          Others => (Others => Empty)),
        7 => (
          3 => (North => Closed, East => Closed, Others => Inner),
          4 => (South => Closed, East => Open, Others => Inner),
          Others => (Others => Empty)),
        Others => (Others => (Others => Empty)));
    begin
      Test_Case(Rotated_Stone, Expected_Board);
    end;

    declare
      Rotated_Stone: constant Board_10.Rotated_Stone_T := (Test_Stone, 1);
      Expected_Board: constant Board_State  := (
        5 => (
          3 => (North => Closed, West => Open, Others => Inner),
          4 => (West => Closed, Others => Inner),
          5 => (West => Closed, South => Open, Others => Inner),
          Others => (Others => Empty)),
        6 => (
          3 => (North => Closed, East => Open, Others => Inner),
          4 => (East => Closed, Others => Inner),
          5 => (East => Closed, South => Closed, Others => Inner),
          Others => (Others => Empty)),
        Others => (Others => (Others => Empty)));
    begin
      Test_Case(Rotated_Stone, Expected_Board);
    end;

    declare
      Rotated_Stone: constant Board_10.Rotated_Stone_T := (Test_Stone, 2);
      Expected_Board: constant Board_State  := (
        5 => (
          3 => (North => Closed, West => Open, Others => Inner),
          4 => (South => Closed, West => Closed, Others => Inner),
          Others => (Others => Empty)),
        6 => (
          3 => (North => Closed, Others => Inner),
          4 => (South => Closed, Others => Inner),
          Others => (Others => Empty)),
        7 => (
          3 => (North => Open, East => Closed, Others => Inner),
          4 => (South => Open, East => Closed, Others => Inner),
          Others => (Others => Empty)),
        Others => (Others => (Others => Empty)));
    begin
      Test_Case(Rotated_Stone, Expected_Board);
    end;

    declare
      Rotated_Stone: constant Board_10.Rotated_Stone_T := (Test_Stone, 3);
      Expected_Board: constant Board_State  := (
        5 => (
          3 => (North => Closed, West => Closed, Others => Inner),
          4 => (West => Closed, Others => Inner),
          5 => (West => Open, South => Closed, Others => Inner),
          Others => (Others => Empty)),
        6 => (
          3 => (North => Open, East => Closed, Others => Inner),
          4 => (East => Closed, Others => Inner),
          5 => (East => Open, South => Closed, Others => Inner),
          Others => (Others => Empty)),
        Others => (Others => (Others => Empty)));
    begin
      Test_Case(Rotated_Stone, Expected_Board);
    end;
  end Test_Place;

  procedure Test_Covers (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Placement: constant Point_T := (1, 3);

  begin
    declare
      Expected: Point_Sets.Set;
      Rotation: constant Rotation_T := 0;
      Cover: constant Point_Sets.Set := Covers(Placement, Rotation);
    begin
      Point_Sets.Include(Expected, (1, 3));
      Point_Sets.Include(Expected, (2, 3));
      Point_Sets.Include(Expected, (3, 3));
      Point_Sets.Include(Expected, (1, 4));
      Point_Sets.Include(Expected, (2, 4));
      Point_Sets.Include(Expected, (3, 4));
      AUnit.Assertions.Assert(Point_Sets.Equivalent_Sets(Cover, Expected),
                              "Check cover of a stone.");
    end;

    declare
      Expected: Point_Sets.Set;
      Rotation: constant Rotation_T := 1;
      Cover: constant Point_Sets.Set := Covers(Placement, Rotation);
    begin
      Point_Sets.Include(Expected, (1, 3));
      Point_Sets.Include(Expected, (1, 4));
      Point_Sets.Include(Expected, (1, 5));
      Point_Sets.Include(Expected, (2, 3));
      Point_Sets.Include(Expected, (2, 4));
      Point_Sets.Include(Expected, (2, 5));
      AUnit.Assertions.Assert(Point_Sets.Equivalent_Sets(Cover, Expected),
                              "Check cover of a stone.");
    end;

    declare
      Expected: Point_Sets.Set;
      Rotation: constant Rotation_T := 2;
      Cover: constant Point_Sets.Set := Covers(Placement, Rotation);
    begin
      Point_Sets.Include(Expected, (1, 3));
      Point_Sets.Include(Expected, (2, 3));
      Point_Sets.Include(Expected, (3, 3));
      Point_Sets.Include(Expected, (1, 4));
      Point_Sets.Include(Expected, (2, 4));
      Point_Sets.Include(Expected, (3, 4));
      AUnit.Assertions.Assert(Point_Sets.Equivalent_Sets(Cover, Expected),
                              "Check cover of a stone.");
    end;

    declare
      Expected: Point_Sets.Set;
      Rotation: constant Rotation_T := 3;
      Cover: constant Point_Sets.Set := Covers(Placement, Rotation);
    begin
      Point_Sets.Include(Expected, (1, 3));
      Point_Sets.Include(Expected, (2, 3));
      Point_Sets.Include(Expected, (1, 4));
      Point_Sets.Include(Expected, (2, 4));
      Point_Sets.Include(Expected, (1, 5));
      Point_Sets.Include(Expected, (2, 5));
      AUnit.Assertions.Assert(Point_Sets.Equivalent_Sets(Cover, Expected),
                              "Check cover of a stone.");
    end;
  end Test_Covers;

  procedure Test_Connectives (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Stone: constant Stone_T := Stone_From_Borders(
      (1 => Closed, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open),
      (1 => Open, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open));

    Placement: constant Point_T := (1, 3);

  begin
    declare
      Result: constant Connective_Sets.Set := Connectives((Stone, 0), Placement);
      Expected: Connective_Sets.Set;
    begin
      Connective_Sets.Include(Expected, ((1, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), North));
      Connective_Sets.Include(Expected, ((3, 3), North));
      Connective_Sets.Include(Expected, ((3, 3), East));
      Connective_Sets.Include(Expected, ((3, 4), East));
      Connective_Sets.Include(Expected, ((1, 4), South));
      Connective_Sets.Include(Expected, ((2, 4), South));
      Connective_Sets.Include(Expected, ((3, 4), South));
      Connective_Sets.Include(Expected, ((1, 3), West));
      Connective_Sets.Include(Expected, ((1, 4), West));

      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Result, Expected),
                               "Check connectives of a stone.");
    end;

    declare
      Result: constant Connective_Sets.Set := Connectives((Stone, 2), Placement);
      Expected: Connective_Sets.Set;
    begin
      Connective_Sets.Include(Expected, ((1, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), North));
      Connective_Sets.Include(Expected, ((3, 3), North));
      Connective_Sets.Include(Expected, ((3, 3), East));
      Connective_Sets.Include(Expected, ((3, 4), East));
      Connective_Sets.Include(Expected, ((1, 4), South));
      Connective_Sets.Include(Expected, ((2, 4), South));
      Connective_Sets.Include(Expected, ((3, 4), South));
      Connective_Sets.Include(Expected, ((1, 3), West));
      Connective_Sets.Include(Expected, ((1, 4), West));

      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Result, Expected),
                               "Check connectives of a stone.");
    end;

    declare
      Result: constant Connective_Sets.Set := Connectives((Stone, 1), Placement);
      Expected: Connective_Sets.Set;
    begin
      Connective_Sets.Include(Expected, ((1, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), East));
      Connective_Sets.Include(Expected, ((2, 4), East));
      Connective_Sets.Include(Expected, ((2, 5), East));
      Connective_Sets.Include(Expected, ((2, 5), South));
      Connective_Sets.Include(Expected, ((1, 5), South));
      Connective_Sets.Include(Expected, ((1, 5), West));
      Connective_Sets.Include(Expected, ((1, 4), West));
      Connective_Sets.Include(Expected, ((1, 3), West));

      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Result, Expected),
                               "Check connectives of a stone.");
    end;

    declare
      Result: constant Connective_Sets.Set := Connectives((Stone, 3), Placement);
      Expected: Connective_Sets.Set;
    begin
      Connective_Sets.Include(Expected, ((1, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), North));
      Connective_Sets.Include(Expected, ((2, 3), East));
      Connective_Sets.Include(Expected, ((2, 4), East));
      Connective_Sets.Include(Expected, ((2, 5), East));
      Connective_Sets.Include(Expected, ((2, 5), South));
      Connective_Sets.Include(Expected, ((1, 5), South));
      Connective_Sets.Include(Expected, ((1, 5), West));
      Connective_Sets.Include(Expected, ((1, 4), West));
      Connective_Sets.Include(Expected, ((1, 3), West));

      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Result, Expected),
                               "Check connectives of a stone.");
    end;

  end Test_Connectives;

  procedure Test_Fits_Dimensions (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Expected_Results: constant array (X_Coordinate, Y_Coordinate) of Boolean := (
      9 => (Others => False),
      10 => (Others => False),
      Others => (10 => False, Others => True));
  begin
    for X in Expected_Results'Range(1) loop
      for Y in Expected_Results'Range(2) loop
        AUnit.Assertions.Assert (Fits_Dimensions(0, (X, Y)) = Expected_Results(X, Y),
                                 "Checking dimensions with stone with dimensions 3x1 (Width x Height) at <" & X'Image & "," & Y'Image & ">");
      end loop;
    end loop;
  end Test_Fits_Dimensions;

  procedure Test_Connects (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Board: Board_T;

    Placed_Stone: constant Stone_T := Stone_From_Borders(
      (1 => Closed, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open),
      (1 => Open, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open));

    Placement: Point_T := (4, 3);

    Stone: constant Stone_T := Stone_From_Borders(
      (1 => Closed, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open),
      (1 => Open, 2 => Open, 3 => Closed),
      (1 => Closed, 2 => Open));
  begin
    Place(Board, (Placed_Stone, 0), Placement);
    AUnit.Assertions.Assert(False, "TODO: Implement tests");
  end Test_Connects;

  -- procedure Test_Valid_Moves(T: in out AUnit.Test_Cases.Test_Case'Class)
  -- is
  --   use Board_10;

  --   Board: Board_T;

  --   First_Stone: constant Stone_T := Stone_From_Borders(
  --     Border_T'(1 => Closed, 2 => Open, 3 => Closed),
  --     Border_T'(1 => Closed, 2 => Open, 3 => Open),
  --     Border_T'(1 => Open, 2 => Open, 3 => Closed),
  --     Border_T'(1 => Closed, 2 => Open, 3 => Closed));

  --   First_Valid_Placements: Point_Sets.Set;
  --   First_Moves: constant Moves_T := Valid_Moves(Board, First_Stone);
  -- begin
  --   -- First_Stone has dimensions 3x3 and the middle of a 10x10 board should
  --   -- be
  --   -- <5, 5>, <6, 5>,
  --   -- <5, 6>, <6, 6>.
  --   -- A 3x3 stone covers any of these fields at:
  --   -- <3, 3>, <4, 3>, <5, 3>, <6, 3>,
  --   -- <3, 4>, <4, 4>, <5, 4>, <6, 4>,
  --   -- <3, 5>, <4, 5>, <5, 5>, <6, 5>,
  --   -- <3, 6>, <4, 6>, <5, 6>, <6, 6>.
  --   -- Consequently, we expect for every rotation precisely these values.
  --   Point_Sets.Include(First_Valid_Placements, (3, 3)); Point_Sets.Include(First_Valid_Placements, (4, 3)); Point_Sets.Include(First_Valid_Placements, (5, 3)); Point_Sets.Include(First_Valid_Placements, (6, 3));
  --   Point_Sets.Include(First_Valid_Placements, (3, 4)); Point_Sets.Include(First_Valid_Placements, (4, 4)); Point_Sets.Include(First_Valid_Placements, (5, 4)); Point_Sets.Include(First_Valid_Placements, (6, 4));
  --   Point_Sets.Include(First_Valid_Placements, (3, 5)); Point_Sets.Include(First_Valid_Placements, (4, 5)); Point_Sets.Include(First_Valid_Placements, (5, 5)); Point_Sets.Include(First_Valid_Placements, (6, 5));
  --   Point_Sets.Include(First_Valid_Placements, (3, 6)); Point_Sets.Include(First_Valid_Placements, (4, 6)); Point_Sets.Include(First_Valid_Placements, (5, 6)); Point_Sets.Include(First_Valid_Placements, (6, 6));

  --   AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(0), First_Valid_Placements),
  --                            "Valid placements on empty board without rotation.");
  --   AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(1), First_Valid_Placements),
  --                            "Valid placements on empty board with one rotation.");
  --   AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(2), First_Valid_Placements),
  --                            "Valid placements on empty board with two rotations.");
  --   AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(3), First_Valid_Placements),
  --                            "Valid placements on empty board with three rotations.");
  -- end Test_Valid_Moves;
end Board_Test;
