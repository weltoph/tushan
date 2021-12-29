with Board;
with Ada.Numerics.Discrete_Random;

generic
  with package Game_Board is new Board(<>);
package Player is
  type Player_Interface is abstract tagged limited null record;

  type Player_Acc is access all Player_Interface'Class;

  Player_Error: exception;

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

  package Rnd_Int is new Ada.Numerics.Discrete_Random(Integer);

  type Random_Player is new Player_Interface with
    record
      Rnd: Rnd_Int.Generator;
    end record;

  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T);

  procedure Disqualify(Player: In Random_Player);

  procedure End_Game(Player: In Random_Player;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural);

end Player;
