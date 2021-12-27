with Player;

generic
  with package Players is new Player(<>);
package Game is

  protected type Play_T is
    procedure Init(NSPlayer: In Players.Player_Acc;
                   WEPlayer: In Players.Player_Acc);
    function Play return Players.Game_Board.Board_T;
  private
    NSPlayer: Players.Player_Acc;
    WEPlayer: Players.Player_Acc;
  end Play_T;

end Game;
