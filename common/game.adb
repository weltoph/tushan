package body Game is
  function Get_Player(Actor: Actor_T) return Player_Acc
  is
  begin
    return Actor.Player;
  end Get_Player;

  function Connects(Actor: Actor_T; Direction: Game_Board.Direction_T) return Boolean
  is
  begin
    return Actor.Target(Direction);
  end Connects;
end Game;
