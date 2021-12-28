with Ada.Text_IO;

package body Player is
  protected body Player_T is
    procedure Next_Move(Board: In Game_Board.Board_T;
                        Stone: In Out Game_Board.Stone_T;
                        Placement: Out Game_Board.Point_T) is
    begin
      Player.all.Next_Move(Board, Stone, Placement);
    end Next_Move;

    procedure Disqualify is
    begin
      Inner.all.Disqualify;
    end Disqualify;

    procedure End_Game(Final_Board: In Game_Board.Board_T;
                       Score: In Natural) is
    begin
      Inner.all.End_Game(Final_Board, Score);
    end End_Game;

  end Player_T;


  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T)
  is
    use Ada.Text_IO;
  begin
    Put_Line("I was asked for a move....AAHHH");
    Placement := (1, 1);
  end Next_Move;


  procedure Disqualify(Player: In Random_Player)
  is
    use Ada.Text_IO;
  begin
    Put_Line("I was disqualified :(");
  end Disqualify;

  procedure End_Game(Player: In Random_Player;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural)
  is
    use Ada.Text_IO;
  begin
    Put_Line("The game ended and I scored " & Score'Image & " points!");
  end End_Game;
end Player;
