with Ada.Containers.Ordered_Sets;
-- @summary Representation of the current game state.
--
-- @description This package mainly provides the type
--   Board_T
--   Stone_T
-- which encapsulates the current state of the board and stones of the game
-- respectively. It is generic in the width and height of the board.
generic
  Width: Positive;
  Height: Positive;

  Stone_Width: Positive;
  Stone_Height: Positive;
package Board is
  -- The central representation of a board. Logically, one can think of a board
  -- as a two dimensional space of squares.
  type Board_T is private;

  function Empty_Board return Board_T;

  subtype X_Coordinate is Positive range 1 .. Width;
  subtype Y_Coordinate is Positive range 1 .. Height;

  subtype Stone_X_Coordinate is Positive range 1 .. Stone_Width;
  subtype Stone_Y_Coordinate is Positive range 1 .. Stone_Height;

  -- We consider a board to be a discrete two-dimensional space of squares.
  -- Hence, there is a natural concept of directions which is captured by this
  -- type.
  type Direction_T is (North, East, South, West);

  -- A point is simply the canoncical composition of an X and Y coordinate.
  type Point_T is
    record
      X: X_Coordinate;
      Y: Y_Coordinate;
    end record;

  -- We introduce a linear order on points; for all intents and purposes think
  -- about it as the lexicographic order.
  function "<" (P1, P2: In Point_T) return Boolean;

  package Point_Sets is new Ada.Containers.Ordered_Sets(
    Element_Type => Point_T,
    "<" => "<",
    "=" => "=");

  -- This returns a set of points which constitute the middle of the field.
  function Middle return Point_Sets.Set;

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
  subtype Border_Connector_T is Inner_Connector_T range Closed .. Open;

  -- A connective is a point and a direction. It uniquely identifies a
  -- Connector_T in any given board.
  type Connective_T is
    record
      Point: Point_T;
      Direction: Direction_T;
    end record;

  function "<" (C1, C2: In Connective_T) return Boolean;

  package Connective_Sets is new Ada.Containers.Ordered_Sets(
    Element_Type => Connective_T,
    "<" => "<",
    "=" => "=");

  type Field_T is array (Direction_T) of Inner_Connector_T;

  type Border_T is array (Positive range <>) of Border_Connector_T;

  type Stone_T is private;

  -- Any Stone_T can be rotated. This subtype associates with this operation.
  -- This means that any pair of a Stone_T and a value of Rotation_T gives some
  -- stone.
  subtype Rotation_T is Natural range 0 .. 3;

  type Rotated_Stone_T is record
    Stone: Stone_T;
    Rotation: Rotation_T;
  end record;

  -- This type represents as a compound all valid moves for a given stone.
  type Moves_T is array (Rotation_T) of Point_Sets.Set;

  -- Returns the four rotations of a stone and their respective valid
  -- placements onto the board.
  -- @param Board The board the stone is placed on.
  -- @param Stone The stone to be placed.
  function Valid_Moves(Board: In Board_T; Stone: In Stone_T) return Moves_T;

  -- Places a stone on a board such that the upper left element of the stone is
  -- placed at placement.
  -- @param Board The board the stone is placed on.
  -- @param Stone The stone to be placed.
  -- @param Placement The coordinates of the upper left corner of the stone
  -- on the board.
  -- @exception Board.Board_Error raised if the stone would overlap with a
  -- previously placed stone; i.e., if
  --   Is_Empty (Intersection (Covers (Stone, Placement), Occupied_Places (Board))) = False
  procedure Place (Board: In Out Board_T;
                   Stone: In Rotated_Stone_T;
                   Placement: In Point_T);

  -- Returns a set of points that a stone covers if put at point.
  -- @param Stone The stone to use.
  -- @param Point The point to put the upper left corner of the stone to return
  -- the "shadow" it casts.
  -- @return The set of points the stone would cover if places at the given
  -- point.
  -- @exception Board.Board_Error Thrown if the shadow of the stone lies
  -- outside the board dimensions.
  function Covers (Stone: In Rotated_Stone_T; Point: In Point_T) return Point_Sets.Set;

  -- Returns a set of connectives that a stone has if put at point.
  -- @param Stone The stone to use.
  -- @param Point The point to put the upper left corner of the stone.
  -- @return The set of connectives the stone has to the rest of the board.
  -- @exception Board.Board_Error Thrown if the shadow of the stone lies
  -- outside the board dimensions.
  function Connectives (Stone: In Rotated_Stone_T; Point: In Point_T) return Connective_Sets.Set;

  -- Returns whether the stone put on this point fits the dimensions of the
  -- board.
  -- @param Stone The stone to use.
  -- @param Point The point to put the upper left corner of the stone to return
  -- whether it then fits the board.
  -- @return Whether the stone when put at the point would fit into the
  -- dimensions of the board.
  function Fits_Dimensions (Stone: In Rotated_Stone_T; Point: In Point_T) return Boolean;

  -- Checks whether a stone connects to the other stones on the board if placed
  -- at postition Placement. That is, open connectors only
  -- connect to either open, empty, or outer connectors, and closed connectors
  -- connect only to closed, empty, or outer connectors. The procedure returns
  -- two values; that is, Consistent and Increasing. Consistent is set to true
  -- if all connectors have a fitting counterpart. Increasing is set to true if
  -- the stone connects at least one one open connector to another one.
  -- @param Stone The stone to check the connections for.
  -- @param Board The board to check the connections at.
  -- @param Placement The coordinates of the upper left corner of the stone
  -- on the board.
  -- @param Consistent_Connectives Indicates which connectives of the stone are
  -- consistent with the current state of Board if placed at Placement
  -- the already placed stones on the board.
  -- @param Increasing_Connectives Indicates which connectives of the stone
  -- connect open connectors with open connectors.
  -- @exception Board.Board_Error Thrown if an inconsistent state is detected;
  -- e.g., an overlap with another stone which is detected by
  -- seeing Inner connectors. Although, this check is not
  -- complete: if fails, for example, when a stone is checked to
  -- be put precisely on another stone that is already placed.
  procedure Connects (Board: In Board_T;
                      Stone: In Rotated_Stone_T;
                      Placement: In Point_T;
                      Consistent_Connectives: Out Connective_Sets.Set;
                      Increasing_Connectives: Out Connective_Sets.Set);

  -- Constructs a stone from four borders which are placed roundabout the
  -- stone.
  -- @param Northern_Border The northern border of the stone.
  -- @param Eastern_Border The eastern border of the stone.
  -- @param Southern_Border The southern border of the stone.
  -- @param Western_Border The western border of the stone.
  -- @return The stone constructed from the borders.
  -- @exception Board.Board_Error Thrown if opposite borders are of different
  -- length.
  function Stone_From_Borders(Northern_Border: Border_T;
                              Eastern_Border: Border_T;
                              Southern_Border: Border_T;
                              Western_Border: Border_T)
                              return Stone_T;

  -- Get_Connector returns which logical connector type occurs for some square
  -- in some direction.
  -- @param Board The board to check the connector for.
  -- @param Point The coordinates of the square to check.
  -- @param Direction The direction in which the square is checked.
  -- @return The connector type khat is at field (X, Y) in direction Direction
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

  -- Gets all occupied places of the given board.
  -- @param Board The board to get the points to.
  -- @return Set of all points that are currently occupied in Board.
  function Occupied_Points (Board: In Board_T) return Point_Sets.Set;

  Board_Error: exception;

  private

  type Board_Field_T (Occupied: Boolean := False) is
    record
      case Occupied is
        when False => null;
        when True => Field: Field_T;
      end case;
    end record;

  type Board_T is array (X_Coordinate, Y_Coordinate) of Board_Field_T;
  type Stone_T is array (Stone_X_Coordinate, Stone_Y_Coordinate) of Field_T;

end Board;
