with Board;
with Ada.Containers.Vectors;

generic
  with package Game_Board is new Board(<>);
package Game is
  type Player_Identifier is new Positive;

  type Message_Type is (Game_Begin, Move_Request, Move_Broadcast, Game_End);
  type Message_Content (Msg_Type: Message_type := Game_Begin) is
    record
      case Msg_Type is
        when Game_Begin =>
          Personal_Identifier: Player_Identifier;
          Board_Width: Natural;
          Board_Height: Natural;
        when Move_Request =>
          Turn_Stone: Game_Board.Stone_T;
          Moving_Player: Player_Identifier;
        when Move_Broadcast =>
          Placed_Stone: Game_Board.Stone_T;
          Rotation: Game_Board.Rotation_T;
          Position: Game_Board.Point_T;
        when Game_End =>
          Non_Fitting_Stone: Game_Board.Stone_T;
      end case;
    end record;

  package Message_List is new Ada.Containers.Vectors
    (Index_Type => Positive,
     Element_Type => Message_Content);

  type Answer_Type is (Timeout, Success);
  type Answer_Content(Msg_Type: Answer_Type := Success) is
    record
      case Msg_Type is
        when Timeout =>
          null;
        when Success => 
          Rotation: Game_Board.Rotation_T;
          Position: Game_Board.Point_T;
      end case;
    end record;

  package Answer_List is new Ada.Containers.Vectors
    (Index_Type => Positive,
     Element_Type => Answer_Content);

  type Player_T is abstract tagged null record;

  procedure Send_Msg(Player: In Player_T; Msg: In Message_Content) is abstract;
  function Recv_Msg(Player: In Player_T) return Answer_Content is abstract;

  type Player_Acc is access Player_T'Class;
  type Objective_T is array (Game_Board.Direction_T) of boolean;

  type Actor_T is record
    Player: Player_Acc;
    Objective: Objective_T;
  end record;

  package Actor_List is new Ada.Containers.Vectors
    (Index_Type => Positive,
     Element_Type => Actor_T);


  protected type Game_State_T is
    function Get_Board return Game_Board.Board_T;
    private
      procedure Update_Board(New_Board: In Game_Board.Board_T);
      Board: Game_Board.Board_T;
  end Game_State_T;

  private
end Game;
