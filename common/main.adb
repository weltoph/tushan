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

  NSPlayer: Player_10.Player_Info;
  WEPlayer: Player_10.Player_Info;

  Final_Board: Board_10.Board_T;

  Play: Game_10.Play_T;

  procedure Idiot is
  begin
    Ada.Wide_Text_IO.Put_Line("I am an idiot.");
    Idiot;
  end Idiot;
begin
  select
    delay 0.1;
    Ada.Wide_Text_IO.Put_Line("after 1");
  then abort
    Idiot;
  end select;

  --  Play.Init(NSPlayer, WEPlayer);
  --  Play.Play(Final_Board);
  --  declare
  --    Chars: constant Display_10.Board_Display_T := Display_10.Display(Final_Board);
  --  begin
  --    for Y in Chars'Range(2) loop
  --      for X in Chars'Range(1) loop
  --        Ada.Wide_Text_IO.Put(Chars(X, Y));
  --      end loop;
  --      Ada.Wide_Text_IO.Put_Line("");
  --    end loop;
  --  end;
end Main;
