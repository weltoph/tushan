generic
package Board.Piece is
  subtype Border_Connector_T is Connector_T range (Closed, Open);

  type Horizontal_Border_T is array (X_Coordinate_T range <>) of Border_Connector_T;
  type Vertical_Border_T is array (Y_Coordinate_T range <>) of Border_Connector_T;

  type Piece_T is
    array (X_Coordinate_T range <>, Y_Coordinate_T range <>) of Field_T;

  function Fits (Piece: Piece_T; At_Point: Point_T; On_Board: Board_T) return
    Boolean;

  function Rotate_Piece (Piece: In Piece_T) return Piece_T;

  function Piece_From_Borders (Northern_Border: Horizontal_Border_T;
                               Eastern_Border: Vertical_Border_T;
                               Southern_Border: Horizontal_Border_T;
                               Western_Border: Vertical_Border_T)
                               return Piece_T;

  function Get_Northern_Border (Piece: Piece_T) return Horizontal_Border_T;
  function Get_Southern_Border (Piece: Piece_T) return Horizontal_Border_T;
  function Get_Eastern_Border (Piece: Piece_T) return Vertical_Border_T;
  function Get_Western_Border (Piece: Piece_T) return Vertical_Border_T;

end Board.Piece;
