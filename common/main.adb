with Display;
with Player;
with Game;
with Board;
with Ada.Wide_Text_IO;


procedure Main is
  package Board_10 is new Board(10, 10);
  package Display_10 is new Display(Board_10);
  package Player_10 is new Player(Board_10);
  package Game_10 is new Game(Player_10);

  NSPlayer: Player_10.Random_Player;
  WEPlayer: Player_10.Random_Player;

  Play: Game_10.Play_T;
begin
  Play.Init(new Player_10.Random_Player, new Player_10.Random_Player);
  declare
    Chars: constant Display_10.Board_Display_T := Display_10.Display(Play.Play);
  begin
    for Y in Chars'Range(2) loop
      for X in Chars'Range(1) loop
        Ada.Wide_Text_IO.Put(Chars(X, Y));
      end loop;
      Ada.Wide_Text_IO.Put_Line("");
    end loop;
  end;
end Main;
