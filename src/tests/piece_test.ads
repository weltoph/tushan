with AUnit;
with AUnit.Test_Cases;

package Piece_Test is
  type Piece_Test is new AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Piece_Test);

  function Name (T: Piece_Test) return AUnit.Message_String;

  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class);
  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class);
  procedure Test_Fit (T: in out AUnit.Test_Cases.Test_Case'Class);

end Piece_Test;
