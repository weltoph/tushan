with AUnit.Assertions;
with Board;
with Board.Stone;
with Board.Stone.Uniform;
with Ada.Text_IO;

package body Uniform_Stone_Test is
  package Board_10 is new Board(10, 10);
  package Stone_10 is new Board_10.Stone;
  package Uniform_Stone_3_1 is new Stone_10.Uniform(3, 1);

  procedure Register_Tests (T: in out Uniform_Stone_Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Generation'Access,
                        "Test generation of uniform stones");
   end Register_Tests;

  function Name (T: Uniform_Stone_Test) return AUnit.Message_String is
  begin
    return AUnit.Format ("Testing uniform stone");
  end Name;

  procedure Test_Generation (T: in out AUnit.Test_Cases.Test_Case'Class) is
  begin
    AUnit.Assertions.Assert (False,
                             "Test false");
  end Test_Generation;
end Uniform_Stone_Test;
