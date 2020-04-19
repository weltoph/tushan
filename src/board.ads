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

  type Placement_T is record
    Point: Point_T;
    Direction: Direction_T;
  end record;


  type Connector_T is (Empty, Closed, Open, Inner);

  type Field_T is array (Direction_T) of Connector_T;
  type Field_Access_T is access constant Field_T;

  type Board_T is private;
  type Coordinate_Set_T is array (X_Coordinate_T, Y_Coordinate_T) of Boolean;

  function NewBoard return Board_T;

private

  type Board_T is array(X_Coordinate_T, Y_Coordinate_T) of Field_Access_T;


end Board;
