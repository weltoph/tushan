with Player;

package body Game is

  task body Game_T is
    NS_Player: Players.Player_Acc := Players.Construct_Player(NS.all);
    EW_Player: Players.Player_Acc := Players.Construct_Player(EW.all);

    type Token_T is (NSP, WEP);
    Token: Token_T := NSP;
    procedure Toggle
    is
    begin
      if Token = NSP then
        Token := WEP;
      else
        Token := NSP;
      end if;
    end Toggle;
  begin
    loop
      null;
    end loop;
  end Game_T;

end Game;
