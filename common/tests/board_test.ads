with AUnit;
with AUnit.Test_Cases;

package Board_Test is
  type Board_Test is new AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Board_Test);

  function Name (T: Board_Test) return AUnit.Message_String;

  --  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class);
  --  procedure Test_Covers (T: in out AUnit.Test_Cases.Test_Case'Class);
  --  procedure Test_Connectives (T: in out AUnit.Test_Cases.Test_Case'Class);
  procedure Test_Fits_Dimensions (T: in out AUnit.Test_Cases.Test_Case'Class);
  --  procedure Test_Connects (T: in out AUnit.Test_Cases.Test_Case'Class);
  --  procedure Test_Valid_Moves (T: in out AUnit.Test_Cases.Test_Case'Class);

end Board_Test;
