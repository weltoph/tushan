with AUnit;
with AUnit.Test_Cases;

package Uniform_Stone_Test is
  type Uniform_Stone_Test is new AUnit.Test_Cases.Test_Case with null record;

  procedure Register_Tests (T: in out Uniform_Stone_Test);

  function Name (T: Uniform_Stone_Test) return AUnit.Message_String;

  procedure Test_Generation (T: in out AUnit.Test_Cases.Test_Case'Class);

end Uniform_Stone_Test;
