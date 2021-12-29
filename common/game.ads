with Player;

generic
  with package Players is new Player(<>);
package Game is

  task type Play_T is
    entry Init(NSPlayer: In Players.Player_T;
               WEPlayer: In Players.Player_T);
    entry Play(Final_Board: Out Players.Game_Board.Board_T);
  end Play_T;

end Game;
