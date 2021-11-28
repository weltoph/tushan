with Board;
with Board.Stone;


-- @summary Package which mainly encapsulates the type
--   Game_T
-- which is a logical representation of one game instances.
--
-- @description The type Game_T represents a game with an implementation of its
-- rules. Essentially, Game_T is a state machine which produces a stone at
-- every moment, awaits a placement of the stone (which it then checks for
-- validity), and repeats until a stone comes up which can no longer be played.
-- At this moment in time the game ends and moves into a state in which it
-- cannot change anymore.
generic
  with package Game_Board is new Board(<>);
  with package Stone is new Game_Board.Stone;
package Game is
  type Game_T is private;

  private

  type Game_T is null record;
end Game;
