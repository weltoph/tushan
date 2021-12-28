with Board;

generic
  with package Game_Board is new Board(<>);
package Player is
  type Player_Interface is abstract tagged null record;

  type Player_Acc is access all Player_Interface'Class;

  procedure Next_Move(Player: In Player_Interface;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T) is abstract;

  procedure Disqualify(Player: In Player_Interface) is abstract;

  procedure End_Game(Player: In Player_Interface;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural) is abstract;

  protected type Player_T(Player: Player_Acc) is
    procedure Next_Move(Board: In Game_Board.Board_T;
                    Stone: In Out Game_Board.Stone_T;
                    Placement: Out Game_Board.Point_T);
    procedure Disqualify;
    procedure End_Game(Final_Board: In Game_Board.Board_T;
                   Score: In Natural);
  private
    Inner: Player_Acc;
  end Player_T;

  type Random_Player is new Player_Interface with null record;

  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T);

  procedure Disqualify(Player: In Random_Player);

  procedure End_Game(Player: In Random_Player;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural);

end Player;
