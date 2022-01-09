with AUnit.Assertions;
with Ada.Text_IO;
with Board;

package body Board_Test is
  package Board_10 is new Board(10, 10);

  procedure Register_Tests (T: in out Board_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Place'Access, "Test placement of stone");
      Register_Routine (T, Test_Rotation'Access, "Test rotation of stone");
      Register_Routine (T, Test_Covers'Access, "Test cover of stone");
      Register_Routine (T, Test_Connectives'Access, "Test connectives of stone");
      Register_Routine (T, Test_Fits_Dimensions'Access, "Test dimentional fit of stone");
      Register_Routine (T, Test_Connects'Access, "Test connections of stone");
      Register_Routine (T, Test_Valid_Moves'Access, "Test valid moves for stone on board");
   end Register_Tests;

  function Name (T: Board_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing stone");
  end Name;

  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    Test_Board: Board_10.Board_T;

    Test_Stone: constant Board_10.Stone_T := Board_10.Stone_From_Borders (
      (1 => Open,   2 => Closed, 3 => Closed, 4 => Closed),
      (1 => Closed, 2 => Open), (1 => Closed, 2 => Closed, 3 => Open,   4 => Closed),
      (1 => Closed, 2 => Open));

    Occupied_Places: constant array (Board_10.X_Coordinate,
                                     Board_10.Y_Coordinate) of Boolean := (
       4 => (4 => True, 5 => True, others => False),
       5 => (4 => True, 5 => True, others => False),
       6 => (4 => True, 5 => True, others => False),
       7 => (4 => True, 5 => True, others => False),
       others => (others => False));

  begin
    AUnit.Assertions.Assert (Board_10.Get_Width (Test_Stone) = 4,
                             "Checking width of stone");

    AUnit.Assertions.Assert (Board_10.Get_Height (Test_Stone) = 2,
                             "Checking height of stone");

    Board_10.Place (Test_Board, Test_Stone, (4, 4));

    for X in Occupied_Places'Range (1) loop
      for Y in Occupied_Places'Range (2) loop
        if Occupied_Places (X, Y) then
          AUnit.Assertions.Assert (Board_10.Is_Occupied (Test_Board, (X, Y)),
                                   "Checking occupied Field <"
                                   & X'Image & "," & Y'Image & ">");
        else
          AUnit.Assertions.Assert (Not Board_10.Is_Occupied (Test_Board, (X, Y)),
                                   "Checking unoccupied Field <"
                                   & X'Image & "," & Y'Image & ">");
        end if;
      end loop;
    end loop;

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 4), North) = Open,
                             "Checking Connector <4, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 4), East) = Inner,
                             "Checking Connector <4, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 4), South) = Inner,
                             "Checking Connector <4, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 4), West) = Open,
                             "Checking Connector <4, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 4), North) = Closed,
                             "Checking Connector <5, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 4), East) = Inner,
                             "Checking Connector <5, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 4), South) = Inner,
                             "Checking Connector <5, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 4), West) = Inner,
                             "Checking Connector <5, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 4), North) = Closed,
                             "Checking Connector <6, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 4), East) = Inner,
                             "Checking Connector <6, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 4), South) = Inner,
                             "Checking Connector <6, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 4), West) = Inner,
                             "Checking Connector <6, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 4), North) = Closed,
                             "Checking Connector <7, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 4), East) = Closed,
                             "Checking Connector <7, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 4), South) = Inner,
                             "Checking Connector <7, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 4), West) = Inner,
                             "Checking Connector <7, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 5), North) = Inner,
                             "Checking Connector <4, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 5), East) = Inner,
                             "Checking Connector <4, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 5), South) = Closed,
                             "Checking Connector <4, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (4, 5), West) = Closed,
                             "Checking Connector <4, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 5), North) = Inner,
                             "Checking Connector <5, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 5), East) = Inner,
                             "Checking Connector <5, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 5), South) = Open,
                             "Checking Connector <5, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (5, 5), West) = Inner,
                             "Checking Connector <5, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 5), North) = Inner,
                             "Checking Connector <6, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 5), East) = Inner,
                             "Checking Connector <6, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 5), South) = Closed,
                             "Checking Connector <6, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (6, 5), West) = Inner,
                             "Checking Connector <6, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 5), North) = Inner,
                             "Checking Connector <7, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 5), East) = Open,
                             "Checking Connector <7, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 5), South) = Closed,
                             "Checking Connector <7, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     (7, 5), West) = Inner,
                             "Checking Connector <7, 5, West>");
  end Test_Place;

  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    --------------------------------------------------
    --  Original --  Once   --  Twice    -- Thrice  --
    --           --   x o   --           --   x o   --
    --   x o x   -- x|_|_|x --   o o x   -- x|_|_|o --
    -- o|_|_|_|x -- o|_|_|o -- o|_|_|_|x -- o|_|_|o --
    -- x|_|_|_|o -- o|_|_|x -- x|_|_|_|o -- x|_|_|x --
    --   x o o   --   o x   --   x o x   --   o x   --
    --------------------------------------------------
    Original_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Once_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed));

    Twice_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Thrice_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Closed, 2 => Open, 3 => Closed));

  begin
    AUnit.Assertions.Assert (Original_Stone = Rotate (Original_Stone, 0),
                             "Identity rotation for original");
    AUnit.Assertions.Assert (Once_Stone = Rotate (Once_Stone, 0),
                             "Identity rotation for once");
    AUnit.Assertions.Assert (Twice_Stone = Rotate (Twice_Stone, 0),
                             "Identity rotation for twice");
    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Thrice_Stone, 0),
                             "Identity rotation for thrice");


    AUnit.Assertions.Assert (Once_Stone = Rotate (Original_Stone),
                             "Incremental rotation original to once");
    AUnit.Assertions.Assert (Once_Stone = Rotate (Original_Stone, 1),
                             "Incremental rotation original to once explicitly");
    AUnit.Assertions.Assert (Twice_Stone = Rotate (Original_Stone, 2),
                             "Incremental rotation original to twice explicitly");
    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Original_Stone, 3),
                             "Incremental rotation original to thrice explicitly");

    AUnit.Assertions.Assert (Twice_Stone = Rotate (Once_Stone),
                             "Incremental rotation once to twice");
    AUnit.Assertions.Assert (Twice_Stone = Rotate (Once_Stone, 1),
                             "Incremental rotation Once to twice explicitly");
    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Once_Stone, 2),
                             "Incremental rotation Once to once explicitly");
    AUnit.Assertions.Assert (Original_Stone = Rotate (Once_Stone, 3),
                             "Incremental rotation Once to original explicitly");

    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Twice_Stone),
                             "Incremental rotation twice to thrice");
    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Twice_Stone, 1),
                             "Incremental rotation twice to thrice explicitly");
    AUnit.Assertions.Assert (Original_Stone = Rotate (Twice_Stone, 2),
                             "Incremental rotation twice to original explicitly");
    AUnit.Assertions.Assert (Once_Stone = Rotate (Twice_Stone, 3),
                             "Incremental rotation twice to once explicitly");

    AUnit.Assertions.Assert (Original_Stone = Rotate (Thrice_Stone),
                             "Incremental rotation thrice to original");
    AUnit.Assertions.Assert (Original_Stone = Rotate (Thrice_Stone, 1),
                             "Incremental rotation thrice to original explicitly");
    AUnit.Assertions.Assert (Once_Stone = Rotate (Thrice_Stone, 2),
                             "Incremental rotation thrice to once explicitly");
    AUnit.Assertions.Assert (Twice_Stone = Rotate (Thrice_Stone, 3),
                             "Incremental rotation thrice to twice explicitly");
  end Test_Rotation;

  procedure Test_Covers (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Placement: constant Point_T := (1, 3);
    Cover: constant Point_Sets.Set := Covers(Stone, Placement);

    Expected: Point_Sets.Set;
  begin
    Point_Sets.Include(Expected, (1, 3));
    Point_Sets.Include(Expected, (2, 3));
    Point_Sets.Include(Expected, (3, 3));
    Point_Sets.Include(Expected, (1, 4));
    Point_Sets.Include(Expected, (2, 4));
    Point_Sets.Include(Expected, (3, 4));

    AUnit.Assertions.Assert(Point_Sets.Equivalent_Sets(Cover, Expected),
                            "Check cover of a stone.");
  end Test_Covers;

  procedure Test_Connectives (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Placement: constant Point_T := (1, 3);
    Result: constant Connective_Sets.Set := Connectives(Stone, Placement);

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
  end Test_Connectives;

  procedure Test_Fits_Dimensions (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Expected_Results: constant array (X_Coordinate, Y_Coordinate) of Boolean := (
      9 => (Others => False),
      10 => (Others => False),
      Others => (10 => False, Others => True));
  begin
    for X in Expected_Results'Range(1) loop
      for Y in Expected_Results'Range(2) loop
        AUnit.Assertions.Assert (Fits_Dimensions(Stone, (X, Y)) = Expected_Results(X, Y),
                                 "Checking dimensions with stone with dimensions" & Get_Width(Stone)'Image & " x" & Get_Height(Stone)'Image & " (Width x Height) at <" & X'Image & "," & Y'Image & ">");
      end loop;
    end loop;
  end Test_Fits_Dimensions;

  procedure Test_Connects (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;

    Board: Board_T;

    Placed_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open, 3 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open, 3 => Closed));

    Placement: Point_T := (4, 3);

    Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    First_Placement: constant Point_T := (3, 1);
    First_Expectation_Consistent: Connective_Sets.Set;
    First_Expectation_Increasing: Connective_Sets.Set;

    Second_Placement: constant Point_T := (1, 3);
    Second_Expectation_Consistent: Connective_Sets.Set;
    Second_Expectation_Increasing: Connective_Sets.Set;

    Third_Placement: constant Point_T := (7, 6);
    Third_Expectation_Consistent: Connective_Sets.Set;
    Third_Expectation_Increasing: Connective_Sets.Set;

    Fourth_Placement: constant Point_T := (7, 4);
    Fourth_Expectation_Consistent: Connective_Sets.Set;
    Fourth_Expectation_Increasing: Connective_Sets.Set;

    Fifth_Placement: constant Point_T := (4, 6);
    Fifth_Expectation_Consistent: Connective_Sets.Set;
    Fifth_Expectation_Increasing: Connective_Sets.Set;

  begin
    Place(Board, Placed_Stone, Placement);

    First_Expectation_Consistent := Connectives(Stone, First_Placement);
    Connective_Sets.Delete(First_Expectation_Consistent, ((4, 2), South));
    First_Expectation_Increasing := Connective_Sets.To_Set(((5, 2), South));

    Second_Expectation_Consistent := Connectives(Stone, Second_Placement);
    Second_Expectation_Increasing := Connective_Sets.To_Set(((3, 4), East));

    Third_Expectation_Consistent := Connectives(Stone, Third_Placement);
    Third_Expectation_Increasing := Connective_Sets.Empty_set;

    Fourth_Expectation_Consistent := Connectives(Stone, Fourth_Placement);
    Connective_Sets.Delete(Fourth_Expectation_Consistent, ((7, 5), West));
    Fourth_Expectation_Increasing := Connective_Sets.To_Set(((7, 4), West));

    Fifth_Expectation_Consistent := Connectives(Stone, Fifth_Placement);
    Connective_Sets.Delete(Fifth_Expectation_Consistent, ((6, 6), North));
    Fifth_Expectation_Increasing := Connective_Sets.To_Set(((5, 6), North));

    declare
      Consistent: Connective_Sets.Set;
      Increasing: Connective_Sets.Set;
    begin
      Connects(Board, Stone, First_Placement, Consistent, Increasing);
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(First_Expectation_Consistent, Consistent),
                               "Consistent for first placement");
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(First_Expectation_Increasing, Increasing),
                               "Increasing for first placement");
    end;

    declare
      Consistent: Connective_Sets.Set;
      Increasing: Connective_Sets.Set;
    begin
      Connects(Board, Stone, Second_Placement, Consistent, Increasing);
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Second_Expectation_Consistent, Consistent),
                               "Consistent for Second placement");
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Second_Expectation_Increasing, Increasing),
                               "Increasing for Second placement");
    end;

    declare
      Consistent: Connective_Sets.Set;
      Increasing: Connective_Sets.Set;
    begin
      Connects(Board, Stone, Third_Placement, Consistent, Increasing);
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Third_Expectation_Consistent, Consistent),
                               "Consistent for Third placement");
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Third_Expectation_Increasing, Increasing),
                               "Increasing for Third placement");
    end;

    declare
      Consistent: Connective_Sets.Set;
      Increasing: Connective_Sets.Set;
    begin
      Connects(Board, Stone, Fourth_Placement, Consistent, Increasing);
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Fourth_Expectation_Consistent, Consistent),
                               "Consistent for Fourth placement");
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Fourth_Expectation_Increasing, Increasing),
                               "Increasing for Fourth placement");
    end;

    declare
      Consistent: Connective_Sets.Set;
      Increasing: Connective_Sets.Set;
    begin
      Connects(Board, Stone, Fifth_Placement, Consistent, Increasing);
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Fifth_Expectation_Consistent, Consistent),
                               "Consistent for Fifth placement");
      AUnit.Assertions.Assert (Connective_Sets.Equivalent_Sets(Fifth_Expectation_Increasing, Increasing),
                               "Increasing for Fifth placement");
    end;

  end Test_Connects;

  procedure Test_Valid_Moves(T: in out AUnit.Test_Cases.Test_Case'Class)
  is
    use Board_10;

    Board: Board_T;

    First_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open, 3 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed),
      Border_T'(1 => Closed, 2 => Open, 3 => Closed));

    First_Valid_Placements: Point_Sets.Set;
    First_Moves: constant Moves_T := Valid_Moves(Board, First_Stone);
  begin
    -- First_Stone has dimensions 3x3 and the middle of a 10x10 board should
    -- be
    -- <5, 5>, <6, 5>,
    -- <5, 6>, <6, 6>.
    -- A 3x3 stone covers any of these fields at:
    -- <3, 3>, <4, 3>, <5, 3>, <6, 3>,
    -- <3, 4>, <4, 4>, <5, 4>, <6, 4>,
    -- <3, 5>, <4, 5>, <5, 5>, <6, 5>,
    -- <3, 6>, <4, 6>, <5, 6>, <6, 6>.
    -- Consequently, we expect for every rotation precisely these values.
    Point_Sets.Include(First_Valid_Placements, (3, 3)); Point_Sets.Include(First_Valid_Placements, (4, 3)); Point_Sets.Include(First_Valid_Placements, (5, 3)); Point_Sets.Include(First_Valid_Placements, (6, 3));
    Point_Sets.Include(First_Valid_Placements, (3, 4)); Point_Sets.Include(First_Valid_Placements, (4, 4)); Point_Sets.Include(First_Valid_Placements, (5, 4)); Point_Sets.Include(First_Valid_Placements, (6, 4));
    Point_Sets.Include(First_Valid_Placements, (3, 5)); Point_Sets.Include(First_Valid_Placements, (4, 5)); Point_Sets.Include(First_Valid_Placements, (5, 5)); Point_Sets.Include(First_Valid_Placements, (6, 5));
    Point_Sets.Include(First_Valid_Placements, (3, 6)); Point_Sets.Include(First_Valid_Placements, (4, 6)); Point_Sets.Include(First_Valid_Placements, (5, 6)); Point_Sets.Include(First_Valid_Placements, (6, 6));

    AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(0), First_Valid_Placements),
                             "Valid placements on empty board without rotation.");
    AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(1), First_Valid_Placements),
                             "Valid placements on empty board with one rotation.");
    AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(2), First_Valid_Placements),
                             "Valid placements on empty board with two rotations.");
    AUnit.Assertions.Assert (Point_Sets.Equivalent_Sets(First_Moves(3), First_Valid_Placements),
                             "Valid placements on empty board with three rotations.");
  end Test_Valid_Moves;
end Board_Test;
