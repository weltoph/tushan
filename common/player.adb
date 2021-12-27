package body Player is
  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T)
  is
  begin
    Placement := (1, 1);
  end Next_Move;


  procedure Disqualify(Player: In Random_Player) is begin null; end Disqualify;

  procedure End_Game(Player: In Random_Player;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural) is begin null; end End_Game;
end Player;
