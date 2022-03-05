with Board;
with Ada.Containers.Vectors;

generic
  with package Game_Board is new Board(<>);
package Game is
  type Player_Identifier is new Natural;
  type Message_Coordinates is new Positive;

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

  type Answer_Content is
    record
      Rotation: Game_Board.Rotation_T;
      Position: Game_Board.Point_T;
    end record;

  package Answer_List is new Ada.Containers.Vectors
    (Index_Type => Positive,
     Element_Type => Answer_Content);

  protected Game_State_T is
    function Get_Board return Game_Board.Board_T;
    --  function Get_Player_Amount return Positive;
    --  function Get_Sent_Messages(Player: Positive) return Message_List.Vector;
    --  function Get_Recv_Messages(Player: Positive) return Message_List.Vector;
  private
    Board: Game_Board.Board_T;
  end Game_State_T;

end Game;
