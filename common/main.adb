with Display;
with Board;
with Ada.Wide_Text_IO;


procedure Main is
  package Board_10 is new Board(10, 10);
  package Display_10 is new Display(Board_10);

  use Board_10;

  stone: constant Board_10.Stone_T := Board_10.Stone_From_Borders (
    (1 => Open,   2 => Closed, 3 => Closed, 4 => Closed),
    (1 => Closed, 2 => Open),
    (1 => Closed, 2 => Closed, 3 => Open,   4 => Closed),
    (1 => Closed, 2 => Open));

  brd: Board_10.Board_T := Board_10.New_Board;
  chars: Display_10.Board_Display_T;
begin
  Board_10.Place(brd, stone, (4, 4));
  chars := Display_10.Display(brd);
  for Y in Display_10.Board_Display_T'Range(2) loop
    for X in Display_10.Board_Display_T'Range(1) loop
      Ada.Wide_Text_IO.Put(chars(X, Y));
    end loop;
    Ada.Wide_Text_IO.Put_Line("");
  end loop;
end Main;
