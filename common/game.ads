with Board;
with Board.Stone;

generic
  with package Game_Board is new Board(<>);
  with package Stone is new Game_Board.Stone;

package Game is
  type Game_T is private;

  private

  type Game_T is null record;
end Game;
