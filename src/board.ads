generic
  Width: Positive;
  Height: Positive;
package Board is
  subtype X_Coordinate_T is Positive range 1 .. Width;
  subtype Y_Coordinate_T is Positive range 1 .. Height;

  type Point_T is record
    X: X_Coordinate_T;
    Y: X_Coordinate_T;
  end record;
  type Direction_T is (North, East, South, West);

  type Connector_T is (Closed, Open, Inner);
  subtype Border_Connector_T is Connector_T
    with Static_Predicate => Border_Connector_T in Closed | Open;

  type Horizontal_Border_T is array (X_Coordinate_T range <>)
    of Border_Connector_T;
  type Vertical_Border_T is array (Y_Coordinate_T range <>)
    of Border_Connector_T;

  type Field_T is array (Direction_T) of Connector_T;

  type Board_Field_Status_T is (Empty, Occupied);

  type Board_Field_T (Status: Board_Field_Status_T := Empty) is private;

  Board_Error: exception;

  type Board_T is private;

  type Piece_T(<>) is private;

  function NewBoard return Board_T;

  procedure Place_Piece (Board: In Out Board_T;
                         Piece: In Piece_T;
                         At_Point: In Point_T);

  function Get_Status (Board: In Board_T; At_Point: In Point_T)
    return Board_Field_Status_T;

  function Get_Field (Board: In Board_T; At_Point: In Point_T)
    return Field_T;

  function Piece_Fits (On_Board: In Board_T;
                       Piece: In Piece_T;
                       At_Point: In Point_T)
    return Boolean;

  function Piece_Connects (On_Board: In Board_T;
                           Piece: In Piece_T;
                           At_Point: In Point_T)
    return Boolean;

  function Rotate_Piece (Piece: In Piece_T) return Piece_T;

  function New_Piece_From_Borders (Northern_Border: Horizontal_Border_T;
                                   Eastern_Border: Vertical_Border_T;
                                   Southern_Border: Horizontal_Border_T;
                                   Western_Border: Vertical_Border_T)
                                   return Piece_T;

  function Get_Northern_Border (Piece: In Piece_T) return Horizontal_Border_T;
  function Get_Southern_Border (Piece: In Piece_T) return Horizontal_Border_T;
  function Get_Eastern_Border (Piece: In Piece_T) return Vertical_Border_T;
  function Get_Western_Border (Piece: In Piece_T) return Vertical_Border_T;


private
  type Board_T is array(X_Coordinate_T, Y_Coordinate_T) of Board_Field_T;

  type Piece_T is
    array (X_Coordinate_T range <>, Y_Coordinate_T range <>) of Field_T;

  type Board_Field_T (Status: Board_Field_Status_T := Empty) is
    record
      case Status is
        when Empty => null;
        when Occupied => Field: Field_T;
      end case;
    end record;

end Board;
