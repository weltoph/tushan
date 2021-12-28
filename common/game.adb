with Player;

package body Game is
  function Valid_Moves(Board: In Players.Game_Board.Board_T;
                       Stone: In Players.Game_Board.Stone_T)
    return Players.Game_Board.Point_Sets.Set
  is
    Result: Players.Game_Board.Point_Sets.Set;
    Occupied: constant Players.Game_Board.Point_Sets.Set := Players.Game_Board.Occupied_Points(Board);
  begin
    if Occupied.Is_Empty then
      declare
        Middle: Players.Game_Board.Point_Sets.Set;
        Min_X: constant Players.Game_Board.X_Coordinate :=
          (if Players.Game_Board.Width mod 2 = 0
           then Players.Game_Board.Width / 2
           else (Players.Game_Board.Width + 1) / 2);
        Max_X: constant Players.Game_Board.X_Coordinate :=
          (if Players.Game_Board.Width mod 2 = 0
           then (Players.Game_Board.Width / 2) + 1
           else (Players.Game_Board.Width + 1) / 2);
        Min_Y: constant Players.Game_Board.X_Coordinate :=
          (if Players.Game_Board.Height mod 2 = 0
           then Players.Game_Board.Height / 2
           else (Players.Game_Board.Height + 1) / 2);
        Max_Y: constant Players.Game_Board.X_Coordinate :=
          (if Players.Game_Board.Height mod 2 = 0
           then (Players.Game_Board.Height / 2) + 1
           else (Players.Game_Board.Height + 1) / 2);
      begin
        for X in Min_X .. Max_X loop
          for Y in Min_Y .. Max_Y loop
            Middle.Insert((X, Y));
          end loop;
        end loop;
        for X in Players.Game_Board.X_Coordinate loop
          for Y in Players.Game_Board.X_Coordinate loop
            declare
              Current: constant Players.Game_Board.Point_T := (X, Y);
              Fits: constant Boolean := Players.Game_Board.Fits_Dimensions(Stone, Current);
            begin
              if Fits and then not Middle.Intersection(Players.Game_Board.Covers(Stone, Current)).Is_Empty then
                Result.Insert(Current);
              end if;
            end;
          end loop;
        end loop;
      end;
    else
      null;
    end if;
    return Result;
  end Valid_Moves;

end Game;
