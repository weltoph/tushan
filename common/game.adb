with Player;

package body Game is

  task body Play_T is
    NS: Players.Player_T;
    WE: Players.Player_T;

    type Token_T is (NSP, WEP);
    Token: Token_T := NSP;

    function Current_Player return Players.Player_T
    is
    begin
      if Token = NSP then
        Token := WEP;
        return NS;
      else
        Token := NSP;
        return WEP;
      end if;
    end Current_Player;

    function Is_Over(B: In Players.Game_Board.Board_T;
                     S: In Players.Game_Board.Stone_T) return Boolean
    is
      RS: Players.Game_Board.Rotate(S);
      RRS: Players.Game_Board.Rotate(RS);
      RRRS: Players.Game_Board.Rotate(RRS);
      SMoves: Players.Game_Board.Valid_Moves(B, S);
      RSMoves: Players.Game_Board.Valid_Moves(B, RS);
      RRSMoves: Players.Game_Board.Valid_Moves(B, RRS);
      RRRSMoves: Players.Game_Board.Valid_Moves(B, RRRS);
    begin
      return (SMoves.Is_Empty and RSMoves.Is_Empty and RRSMoves.Is_Empty and RRRSMoves.Is_Empty);
    end Is_Over;
  begin
    accept Init(NSPlayer: In Players.Player_T; WEPlayer: In Players.Player_T) do
      NS := NSPlayer;
      WE := WEPlayer;
    end Init;

    declare
      Current_Board: Players.Game_Board.Board_T := Players.Game_Board.New_Board;
    begin
      loop
        declare
          Current_Stone: Players.Game_Board.Stone_T := Players.Game_Board.Stone_From_Borders(
            (Players.Game_Board.Border_Connector_T.Closed, Players.Game_Board.Border_Connector_T.Open, Players.Game_Board.Border_Connector_T.Open),
            (Players.Game_Board.Border_Connector_T.Closed),
            (Players.Game_Board.Border_Connector_T.Open, Players.Game_Board.Border_Connector_T.Open, Players.Game_Board.Border_Connector_T.Closed),
            (Players.Game_Board.Border_Connector_T.Open));
        begin
          exit when Is_Over(Current_Board, Current_Stone);
          declare
            Move: Players.Game_Board.Point_T;
            Rotation: Players.Game_Board.Stone_T := Current_Stone;
          begin
            Current_Player.Next_Move(Current_Board, Rotation, Move);
            -- Missing check whether this is valid.
            Players.Game_Board.Place(Current_Board, Rotation, Move);
          end;
        end;
      end loop;
    end;

    accept Play(Final_Board: Out Players.Game_Board.Board_T) do
      Final_Board := Current_Board;
    end;
  end Play_T;
end Game;
