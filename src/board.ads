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

  type Connector_T is (Empty, Closed, Open, Inner);

  type Field_T is array (Direction_T) of Connector_T;

  type Board_Field_Status_T is (Empty, Occupied);
  type Board_Field_T (Status: Board_Field_Status_T := Empty) is
    record
      case Status is
        when Empty => null;
        when Occupied => Field: Field_T;
      end case;
    end record;
  type Board_T is private;

  function NewBoard return Board_T;

private

  type Board_T is array(X_Coordinate_T, Y_Coordinate_T) of Board_Field_T;


end Board;
