with Suite;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Run_Tests is
  procedure Run is new AUnit.Run.Test_Runner (Suite.Suite);
  Reporter: AUnit.Reporter.Text.Text_Reporter;
begin
  Run (Reporter);
end Run_Tests;
