with AUnit;
with AUnit.Test_Cases;

package Stone_Test is
  type Stone_Test is new AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Stone_Test);

  function Name (T: Stone_Test) return AUnit.Message_String;

  procedure Test_Place (T: in out AUnit.Test_Cases.Test_Case'Class);
  procedure Test_Rotation (T: in out AUnit.Test_Cases.Test_Case'Class);
  procedure Test_Fit_and_Connect (T: in out AUnit.Test_Cases.Test_Case'Class);

end Stone_Test;
