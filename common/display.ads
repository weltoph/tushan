with Board;
with Ada.Wide_Characters;

generic
  with package Game_Board is new Board(<>);
package Display is
  type Board_Display_T is array (1 .. Game_Board.Width*3,
                                 1 .. Game_Board.Height*3) of Wide_Character;

  function Display(Display_Board: Game_Board.Board_T) return Board_Display_T;
  procedure Print_Display(Input: In Game_Board.Board_T);
end Display;
