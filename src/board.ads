generic
  Width: Positive;
  Height: Positive;
package Board is
  subtype X_Coordinate is Positive range 1 .. Width;
  subtype Y_Coordinate is Positive range 1 .. Height;

  type Direction_T is (North, East, South, West);
  type Connector_T is (Closed, Open, Inner, Outer);

  subtype Inner_Connector_T is Connector_T range Closed .. Inner;

  type Board_T is private;

  function New_Board return Board_T;

  function Get_Connector (Board: In Board_T;
                          X: In X_Coordinate;
                          Y: In Y_Coordinate;
                          Direction: In Direction_T)
                          return Inner_Connector_T;

  function Get_Opposing_Connector (Board: In Board_T;
                                   X: In X_Coordinate;
                                   Y: In Y_Coordinate;
                                   Direction: In Direction_T)
                                   return Connector_T;

  function Is_Occupied (Board: In Board_T;
                        X: In X_Coordinate;
                        Y: In Y_Coordinate)
                        return Boolean;

  Board_Error: exception;

  private

  type Field_T is array (Direction_T) of Inner_Connector_T;

  type Board_Field_T (Occupied: Boolean := False) is
    record
      case Occupied is
        when False => null;
        when True => Field: Field_T;
      end case;
    end record;

  type Board_T is array(X_Coordinate, Y_Coordinate) of Board_Field_T;

end Board;
