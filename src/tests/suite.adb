with AUnit.Test_Suites;
with Piece_Test;

package body Suite is
  Result: aliased AUnit.Test_Suites.Test_Suite;

  Piece_Test_Element: aliased Piece_Test.Piece_Test;

  function Suite return AUnit.Test_Suites.Access_Test_Suite is
  begin
    AUnit.Test_Suites.Add_Test (Result'Access, Piece_Test_Element'Access);
    return Result'Access;
  end Suite;
end Suite;
