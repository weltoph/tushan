with Board;
with Player;

generic
  with package Game_Board is new Board(<>);
package Game is
  package Players is new Player(Game_Board);

  task type Game_T(NS, EW: access Players.Player_Info) is
    entry Result(Final_Board: out Game_Board.Board_T);
  end Game_T;
end Game;
