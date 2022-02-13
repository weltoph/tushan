with Display;
with Player;
with Game;
with Board;
with Ada.Wide_Text_IO;


procedure Main is
  package Board_10 is new Board(10, 10);
  package Game_10 is new Game(Board_10);
begin
  null;
end Main;
