with AUnit.Test_Suites;
with Stone_Test;

package body Suite is
  Result: aliased AUnit.Test_Suites.Test_Suite;

  Stone_Test_Element: aliased Stone_Test.Stone_Test;

  function Suite return AUnit.Test_Suites.Access_Test_Suite is
  begin
    AUnit.Test_Suites.Add_Test (Result'Access, Stone_Test_Element'Access);
    return Result'Access;
  end Suite;
end Suite;
