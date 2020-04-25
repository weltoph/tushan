with AUnit.Assertions;
with Board.Piece.Test_Data;
with Board.Test_Data;
with Ada.Text_IO;

package body Piece_Test is
  package Board_10 is new Board(10, 10);
  package Piece_10 is new Board_10.Piece;
  package Board_Data_10 is new Board_10.Test_Data;
  package Piece_Data_10 is new Piece_10.Test_Data;

  procedure Register_Tests (T: in out Piece_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Rotation'Access, "Test Rotation of Piece");
      Register_Routine (T, Test_Fit'Access, "Test Fit of Piece");
   end Register_Tests;

  function Name (T: Piece_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing Piece");
  end Name;

  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    use Piece_10;

    Once: constant Piece_T := Rotate_Piece (Piece_Data_10.Original_Piece);
    Twice: constant Piece_T := Rotate_Piece (Rotate_Piece (Piece_Data_10.Original_Piece));
    Thrice: constant Piece_T := Rotate_Piece (Rotate_Piece (Rotate_Piece (Piece_Data_10.Original_Piece)));
    Full: constant Piece_T := Rotate_Piece (Rotate_Piece (Rotate_Piece (Rotate_Piece (Piece_Data_10.Original_Piece))));
  begin
    AUnit.Assertions.Assert (Twice = Rotate_Piece (Once), "Incremental rotation once to twice");
    AUnit.Assertions.Assert (Thrice = Rotate_Piece (Twice), "Incremental rotation twice to thrice");
    AUnit.Assertions.Assert (Full = Rotate_Piece (Thrice), "Incremental rotation thrice to full");
    AUnit.Assertions.Assert (Once = Piece_Data_10.Once_Rotated_Piece, "Rotated once");
    AUnit.Assertions.Assert (Twice = Piece_Data_10.Twice_Rotated_Piece, "Rotated twice");
    AUnit.Assertions.Assert (Thrice = Piece_Data_10.Thrice_Rotated_Piece, "Rotated thrice");
    AUnit.Assertions.Assert (Full = Piece_Data_10.Original_Piece, "Four rotations idempotent");
  end Test_Rotation;

  procedure Test_Fit (T: in out AUnit.Test_Cases.Test_Case'Class) is
    use Board_10;
    use Piece_10;
    Successful_5_1: constant Point_T := (X => 5, Y => 1);
    Successful_1_6: constant Point_T := (X => 1, Y => 6);
    Failing_8_1: constant Point_T := (X => 8, Y => 1);
    Failing_1_3: constant Point_T := (X => 1, Y => 3);
  begin
    for X in Piece_Data_10.Fits_Places'Range(1) loop
      for Y in Piece_Data_10.Fits_Places'Range(2) loop
        declare
          Test_Coordinate : constant Point_T := (X => X, Y => Y);
          Result: constant Boolean := Fits (Piece_Data_10.Test_Piece,
                                            Test_Coordinate,
                                            Board_Data_10.Test_Board);
          Expected_Result: constant Boolean := Piece_Data_10.Fits_Places(X, Y);
        begin
          AUnit.Assertions.Assert (Result = Expected_Result,
            "Test fit at <" & Positive'Image(X) & "," & Positive'Image(Y) & ">");
        end;
      end loop;
    end loop;
  end Test_Fit;

end Piece_Test;
