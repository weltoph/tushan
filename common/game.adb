package body Game is
  protected body Game_State_T is
    function Get_Board return Game_Board.Board_T is
    begin
      return Board;
    end Get_Board;
  end Game_State_T;
end Game;
