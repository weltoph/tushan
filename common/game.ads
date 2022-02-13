with Board;
with Player;

generic
  with package Game_Board is new Board(<>);
package Game is
  type Player_Identifier is new Natural;
  type Message_Coordinates is new Positive;

  type Message_Type is (Game_Begin, Move_Request, Move_Broadcast, Game_End);
  type Message_Content (Msg_Type: Message_type) is
    record
      case Msg_Type is
        when Game_Begin =>
          Personal_Identifier: Player_Identifier;
          Board_Width: Natural;
          Board_Height: Natural;
        when Move_Request =>
          --  Stone: Game_Board.Stone_T;
          Moving_Player: Player_Identifier;
        when Move_Broadcast =>
          --  Stone: Game_Board.Stone_T;
          Rotation: Game_Board.Rotation_T;
          Position: Game_Board.Point_T;
        when Game_End =>
          --  Non_Fitting_Stone: Game_Board.Stone_T;
          null;
      end case;
    end record;

  type Answer_Content is
    record
      Rotation: Game_Board.Rotation_T;
      Position: Game_Board.Point_T;
    end record;

end Game;
