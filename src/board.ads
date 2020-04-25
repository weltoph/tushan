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

  type Field_T is array (Direction_T) of Connector_T;

  type Board_Field_Status_T is (Empty, Occupied);

  type Board_Field_T (Status: Board_Field_Status_T := Empty) is
    record
      case Status is
        when Empty => null;
        when Occupied => Field: Field_T;
      end case;
    end record;

  Board_Error: exception;

  type Board_T is array(X_Coordinate_T, Y_Coordinate_T) of Board_Field_T;

  function NewBoard return Board_T;

private


end Board;
