with Display;
with Player;
with Game;
with Board;
with Ada.Wide_Text_IO;


procedure Main is
  package Board_10 is new Board(10, 10);
  package Game_10 is new Game(Board_10);

  Final_Board: Board_10.Board_T;
  Game: Game_10.Game_T(new Game_10.Players.Player_Info, new Game_10.Players.Player_Info);
begin
  Game.Result(Final_Board);
end Main;
