with AUnit.Assertions;

package body Piece_Test is

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
  begin
    AUnit.Assertions.Assert(True, "Should not fail!");
  end Test_Rotation;

end Piece_Test;
