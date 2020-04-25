package Board.Piece.Test is
  procedure Rotation_Test is

  begin
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, East) = East_Piece, "East rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, South) = South_Piece, "South rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, West) = West_Piece, "West rotation test");
    AUnit.Assertions.Assert (Piece_10.Rotate_Piece(East_Piece, North) = North_Piece, "North rotation test");
  end Rotation_Test;
end Board.Piece.Test;

