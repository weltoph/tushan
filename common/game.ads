with Board;
with Player;
with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Bounded_Queue;

generic
  with package Game_Board is new Board(<>);
package Game is
  type Player_Identifier is new Natural;
  type Message_Coordinates is new Positive;

  type Message_Type is (Game_Begin, Move, Game_End);
  type Message_Content (Msg_Type: Message_type) is
    record
      case Msg_Type is
        when Game_Begin =>
          Personal_Identifier: Player_Identifier;
          Board_Width: Natural;
          Board_Height: Natural;
        when Move =>
          Stone: Stone_T;
          Current_Player: Player_Identifier;
        when Game_End =>
          null;
      end case;
    end record;

  type Answer_Content is
    record
      X: Message_Coordinates;
      Y: Message_Coordinates;
    end record;

  package OutQueue is new 

  package Players is new Player(Game_Board);

  task type Game_T(NS, EW: access Players.Player_Info) is
    entry Result(Final_Board: out Game_Board.Board_T);
  end Game_T;
end Game;
