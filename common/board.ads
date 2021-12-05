with Ada.Containers.Ordered_Sets;
-- @summary Representation of the current game state.
--
-- @description This package mainly provides the type
--   Board_T
--   Game_T
-- which encapsulates the current state of the board and the game respectively.
-- It is generic in the width and height of the board.
generic
  Width: Positive;
  Height: Positive;
package Board is
  -- The representation of a game.
  --type Game_T is private;

  -- The central representation of a board. Logically, one can think of a board
  -- as a two dimensional space of squares.
  type Board_T is private;

  subtype X_Coordinate is Positive range 1 .. Width;
  subtype Y_Coordinate is Positive range 1 .. Height;

  type Point_T is
    record
      X: X_Coordinate;
      Y: Y_Coordinate;
    end record;

  function "<" (P1, P2: In Point_T) return Boolean;

  package Point_Sets is new Ada.Containers.Ordered_Sets(
    Element_Type => Point_T,
    "<" => "<",
    "=" => "=");


  -- We consider a board to be a discrete two-dimensional space of squares.
  -- Hence, there is a natural concept of directions which is captured by this
  -- type.
  type Direction_T is (North, East, South, West);

  -- The connection of one square in one direction can have different states:
  -- @value Closed when the is some square placed at these coordinates and the
  -- connection is the end of the logical unit of a stone but does not allow
  -- for a flow through this connection.
  -- @value Open is defined as above, but allows for flow through this
  -- connection.
  -- @value Inner represents a connection within the logical unit of a stone.
  -- For the general flow of the rivers Inner and Open are interchangeable.
  -- @value Outer represents the very end of the board.
  -- @value Empty corresponds to any connection of a square that is not yet
  -- occupied by anything.
  type Connector_T is (Closed, Open, Inner, Outer, Empty);

  -- This subrange represents the connections that are relevant for stones.
  subtype Inner_Connector_T is Connector_T range Closed .. Inner;

  -- This function generates an empty new board.
  -- @return The new empty board.
  function New_Board return Board_T;

  -- Get_Connector returns which logical connector type occurs for some square
  -- in some direction.
  -- @param Board The board to check the connector for.
  -- @param Point The coordinates of the square to check.
  -- @param Direction The direction in which the square is checked.
  -- @return The connector type that is at field (X, Y) in direction Direction
  -- on Board.
  function Get_Connector (Board: In Board_T;
                          Point: In Point_T;
                          Direction: In Direction_T)
                          return Connector_T;

  -- Get_Opposing_Connector returns which logical connector type occurs on the
  -- other side of some square in some direction.
  -- @param Board The board to check the connector for.
  -- @param Point The coordinates of the square to check.
  -- @param Direction The direction in which the square is checked.
  -- @return The connector type that is opposite of field (X, Y) in direction
  -- Direction on Board. For example,
  --   Get_Opposing_Connector(board, x, y, North) = Get_Connector(board, x-1, y, South)
  -- For appropiate board, x, and y.
  function Get_Opposing_Connector (Board: In Board_T;
                                   Point: In Point_T;
                                   Direction: In Direction_T)
                                   return Connector_T;

  -- Checks whether the square at some position is already occupied.
  -- @param Board The board to inspect the position in.
  -- @param Point The coordinates of the position to check.
  -- @return Returns whether that square already is occupied by some stone.
  function Is_Occupied (Board: In Board_T; Point: In Point_T) return Boolean;

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

  type Board_T is array (X_Coordinate, Y_Coordinate) of Board_Field_T;

end Board;
