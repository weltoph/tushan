package body Board.Piece is

  function Fits(Piece: Piece_T; Placed: Placement_T; On_Board: Board_T) return
    Boolean is
  begin
    return False;
  end Fits;


  function Rotate_Piece (Piece: Piece_T; To: Direction_T) return Piece_T is
  begin
    case To is
      when East =>
        declare
          Result: Piece_T(Piece'Range(1), Piece'Range(2)) := (others => (others => null));
        begin
          for X in Piece'Range(1) loop
            for Y in Piece'Range(2) loop
              Result(X, Y) := Piece(X, Y);
            end loop;
          end loop;
          return Result;
        end;
      when South =>
        declare
          Result: Piece_T(Piece'Range(2), Piece'Range(1)) := (others => (others => null));
        begin
          for X in Piece'Range(2) loop
            for Y in reverse Piece'Range(1) loop
              Result(X, Y) := Piece(X, Y);
            end loop;
          end loop;
          return Result;
        end;
      when West =>
        declare
          Result: Piece_T(Piece'Range(1), Piece'Range(2)) := (others => (others => null));
        begin
          for X in reverse Piece'Range(2) loop
            for Y in reverse Piece'Range(1) loop
              Result(X, Y) := Piece(X, Y);
            end loop;
          end loop;
          return Result;
        end;
      when North =>
        declare
          Result: Piece_T(Piece'Range(2), Piece'Range(1)) := (others => (others => null));
        begin
          for X in reverse Piece'Range(2) loop
            for Y in Piece'Range(1) loop
              Result(X, Y) := Piece(X, Y);
            end loop;
          end loop;
          return Result;
        end;
    end case;
  end;
end Board.Piece;
