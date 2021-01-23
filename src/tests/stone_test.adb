with AUnit.Assertions;
with Board.Stone;
with Ada.Text_IO;

package body Stone_Test is
  package Board_10 is new Board(10, 10);
  package Stone_10 is new Board_10.Stone;

  procedure Register_Tests (T: in out Stone_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Place'Access, "Test placement of stone");
      Register_Routine (T, Test_Rotation'Access, "Test rotation of stone");
      Register_Routine (T, Test_Fit_and_Connect'Access, "Test fit of stone");
   end Register_Tests;

  function Name (T: Stone_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing stone");
  end Name;

  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    Test_Board: Board_10.Board_T := Board_10.New_Board;

    Test_Stone: constant Stone_10.Stone_T := Stone_10.Stone_From_Borders (
      (1 => Open,   2 => Closed, 3 => Closed, 4 => Closed),
      (1 => Closed, 2 => Open),
      (1 => Closed, 2 => Closed, 3 => Open,   4 => Closed),
      (1 => Closed, 2 => Open));

    Occupied_Places: constant array (Board_10.X_Coordinate,
                                     Board_10.Y_Coordinate) of Boolean := (
       4 => (4 => True, 5 => True, others => False),
       5 => (4 => True, 5 => True, others => False),
       6 => (4 => True, 5 => True, others => False),
       7 => (4 => True, 5 => True, others => False),
       others => (others => False));

  begin
    AUnit.Assertions.Assert (Stone_10.Get_Width (Test_Stone) = 4,
                             "Checking width of stone");

    AUnit.Assertions.Assert (Stone_10.Get_Height (Test_Stone) = 2,
                             "Checking height of stone");

    Stone_10.Place (Test_Stone, Test_Board, 4, 4);

    for X in Occupied_Places'Range (1) loop
      for Y in Occupied_Places'Range (2) loop
        if Occupied_Places (X, Y) then
          AUnit.Assertions.Assert (Board_10.Is_Occupied (Test_Board, X, Y),
                                   "Checking occupied Field <"
                                   & X'Image & "," & Y'Image & ">");
        else
          AUnit.Assertions.Assert (Not Board_10.Is_Occupied (Test_Board, X, Y),
                                   "Checking unoccupied Field <"
                                   & X'Image & "," & Y'Image & ">");
        end if;
      end loop;
    end loop;

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 4, North) = Open,
                             "Checking Connector <4, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 4, East) = Inner,
                             "Checking Connector <4, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 4, South) = Inner,
                             "Checking Connector <4, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 4, West) = Open,
                             "Checking Connector <4, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 4, North) = Closed,
                             "Checking Connector <5, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 4, East) = Inner,
                             "Checking Connector <5, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 4, South) = Inner,
                             "Checking Connector <5, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 4, West) = Inner,
                             "Checking Connector <5, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 4, North) = Closed,
                             "Checking Connector <6, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 4, East) = Inner,
                             "Checking Connector <6, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 4, South) = Inner,
                             "Checking Connector <6, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 4, West) = Inner,
                             "Checking Connector <6, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 4, North) = Closed,
                             "Checking Connector <7, 4, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 4, East) = Closed,
                             "Checking Connector <7, 4, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 4, South) = Inner,
                             "Checking Connector <7, 4, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 4, West) = Inner,
                             "Checking Connector <7, 4, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 5, North) = Inner,
                             "Checking Connector <4, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 5, East) = Inner,
                             "Checking Connector <4, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 5, South) = Closed,
                             "Checking Connector <4, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     4, 5, West) = Closed,
                             "Checking Connector <4, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 5, North) = Inner,
                             "Checking Connector <5, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 5, East) = Inner,
                             "Checking Connector <5, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 5, South) = Open,
                             "Checking Connector <5, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     5, 5, West) = Inner,
                             "Checking Connector <5, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 5, North) = Inner,
                             "Checking Connector <6, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 5, East) = Inner,
                             "Checking Connector <6, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 5, South) = Closed,
                             "Checking Connector <6, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     6, 5, West) = Inner,
                             "Checking Connector <6, 5, West>");

    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 5, North) = Inner,
                             "Checking Connector <7, 5, North>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 5, East) = Open,
                             "Checking Connector <7, 5, East>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 5, South) = Closed,
                             "Checking Connector <7, 5, South>");
    AUnit.Assertions.Assert (Board_10.Get_Connector (Test_Board,
                                                     7, 5, West) = Inner,
                             "Checking Connector <7, 5, West>");
  end Test_Place;

  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    use Stone_10;
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
    AUnit.Assertions.Assert (Once_Stone = Rotate (Original_Stone),
                             "Incremental rotation original to once");
    AUnit.Assertions.Assert (Twice_Stone = Rotate (Once_Stone),
                             "Incremental rotation once to twice");
    AUnit.Assertions.Assert (Thrice_Stone = Rotate (Twice_Stone),
                             "Incremental rotation twice to thrice");
    AUnit.Assertions.Assert (Original_Stone = Rotate (Thrice_Stone),
                             "Incremental rotation thrice to original");
  end Test_Rotation;

  procedure Test_Fit_and_Connect (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    use Stone_10;

    Board: Board_T := New_Board;

    Placed_Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Closed, 2 => Open, 3 => Open, 4 => Closed),
      Border_T'(1 => Open, 2 => Closed, 3 => Closed, 4 => Open),
      Border_T'(1 => Open, 2 => Open, 3 => Closed, 4 => Closed),
      Border_T'(1 => Closed, 2 => Closed, 3 => Open, 4 => Open));

    Stone: constant Stone_T := Stone_From_Borders(
      Border_T'(1 => Open),
      Border_T'(1 => Open, 2 => Closed),
      Border_T'(1 => Closed),
      Border_T'(1 => Closed, 2 => Open));

    Placement_X: constant X_Coordinate := 2;
    Placement_Y: constant Y_Coordinate := 4;

    Fitting_Places: constant array (X_Coordinate, Y_Coordinate) of Boolean := (
      2 => (1 => True, 2 => True, 8 => True, 9 => True, others => False),
      3 => (1 => True, 2 => True, 8 => True, 9 => True, others => False),
      4 => (1 => True, 2 => True, 8 => True, 9 => True, others => False),
      5 => (1 => True, 2 => True, 8 => True, 9 => True, others => False),
      others => (10 => False, others => True));

    Connecting_Places: constant array (X_Coordinate, Y_Coordinate) of Boolean := (
      1 => (1 => True, 2 => True, 5 => True, 8 => True, 9 => True, others => False),
      2 => (1 => True, 2 => True, 9 => True, others => False),
      3 => (1 => True, 9 => True, others => False),
      4 => (1 => True, 8 => True, 9 => True, others => False),
      5 => (1 => True, 2 => True, 8 => True, 9 => True, others => False),
      6 => (1 => True, 2 => True, 4 => True, 7 => True, 8 => True, 9 => True, others => False),
      others => (10 => False, others => True));
  begin
    Place (Placed_Stone, Board, Placement_X, Placement_Y);

    for X in X_Coordinate loop
      for Y in Y_Coordinate loop
        if Fitting_Places (X, Y) then
          AUnit.Assertions.Assert (Fits (Stone, Board, X, Y),
                                   "Checking fitting placement at <"
                                   & X'Image & "," & Y'Image & ">");
          if Connecting_Places (X, Y) then
            AUnit.Assertions.Assert (Connects (Stone, Board, X, Y),
                                   "Checking connecting placement at <"
                                   & X'Image & "," & Y'Image & ">");
          else
            AUnit.Assertions.Assert (Not Connects (Stone, Board, X, Y),
                                   "Checking non-connecting placement at <"
                                   & X'Image & "," & Y'Image & ">");
          end if;
        else
          AUnit.Assertions.Assert (Not Fits (Stone, Board, X, Y),
                                   "Checking non-fitting placement at <"
                                   & X'Image & "," & Y'Image & ">");
        end if;
      end loop;
    end loop;
  end Test_Fit_and_Connect;
end Stone_Test;
