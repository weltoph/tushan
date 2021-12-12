with AUnit.Test_Suites;
with Board_Test;

package body Suite is
  Result: aliased AUnit.Test_Suites.Test_Suite;

  Board_Test_Element: aliased Board_Test.Board_Test;

  function Suite return AUnit.Test_Suites.Access_Test_Suite is
  begin
    AUnit.Test_Suites.Add_Test (Result'Access, Board_Test_Element'Access);
    return Result'Access;
  end Suite;
end Suite;
