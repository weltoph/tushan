generic
package Board.Piece is
  type Piece_T is
    array (X_Coordinate_T range <>, Y_Coordinate_T range <>) of Field_Access_T;

  function Fits(Piece: Piece_T; Placed: Placement_T; On_Board: Board_T) return
    Boolean;

private
  function Rotate_Piece(Piece: Piece_T; To: Direction_T) return Piece_T;
end Board.Piece;
