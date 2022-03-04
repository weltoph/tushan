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

  type Horizontal_Border_T is array (Stone_X_Coordinate) of Border_Connector_T;
  type Vertical_Border_T is array (Stone_Y_Coordinate) of Border_Connector_T;

  type Stone_T is private;

  -- Any Stone_T can be rotated. This subtype associates with this operation.
  -- This means that any pair of a Stone_T and a value of Rotation_T gives some
  -- stone.
  subtype Rotation_T is Natural range 0 .. 3;

  function Rotate(Stone: In Stone_T; Rotation: In Rotation_T := 1) return Stone_T;
  function Get_Rotation(Stone: In Stone_T) return Rotation_T;

  -- This type represents as a compound all valid moves for a given stone.
  type Moves_T is array (Rotation_T) of Point_Sets.Set;

  procedure Place(Board: In Out Board_T;
                  Stone: In Stone_T;
                  Placement: In Point_T)
    with Pre => Fits_Dimensions(Get_Rotation(Stone), Placement)
                and then Point_Sets.Is_Empty(
                  Point_Sets.Intersection(
                    Occupied_Points(Board),
                    Covers(Placement, Get_Rotation(Stone))));

  function Covers(Point: In Point_T; Rotation: In Rotation_T) return Point_Sets.Set
    with Pre => Fits_Dimensions(Rotation, Point);

  function Connectives (Stone: In Stone_T; Point: In Point_T) return Connective_Sets.Set
    with Pre => Fits_Dimensions(Get_Rotation(Stone), Point);

  function Fits_Dimensions(Rotation: In Rotation_T; Point: In Point_T) return Boolean;

  procedure Connects(Board: In Board_T;
                     Stone: In Stone_T;
                     Placement: In Point_T;
                     Inconsistent_Connectives: Out Connective_Sets.Set;
                     Increasing_Connectives: Out Connective_Sets.Set)
    with Pre => Fits_Dimensions(Get_Rotation(Stone), Placement)
                and then Point_Sets.Is_Empty(
                  Point_Sets.Intersection(
                    Occupied_Points(Board),
                    Covers(Placement, Get_Rotation(Stone))));

  function Stone_From_Borders(Northern_Border: Horizontal_Border_T;
                              Eastern_Border: Vertical_Border_T;
                              Southern_Border: Horizontal_Border_T;
                              Western_Border: Vertical_Border_T)
                              return Stone_T;

  function Get_Connector(Board: In Board_T;
                         Point: In Point_T;
                         Direction: In Direction_T)
                         return Connector_T;

  function Get_Connector(Board: In Board_T;
                         Connective: In Connective_T)
                         return Connector_T;

  function Get_Opposing_Connector(Board: In Board_T;
                                  Point: In Point_T;
                                  Direction: In Direction_T)
                                  return Connector_T;

  function Get_Opposing_Connector(Board: In Board_T;
                                  Connective: In Connective_T)
                                  return Connector_T;

  function Is_Occupied(Board: In Board_T; Point: In Point_T) return Boolean;

  function Occupied_Points(Board: In Board_T) return Point_Sets.Set;

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
  type Stone_Fields_T is array (Stone_X_Coordinate, Stone_Y_Coordinate) of Field_T;

  type Stone_T is
    record
      Fields: Stone_Fields_T;
      Rotation: Rotation_T := 0;
    end record;

  type Rotated_Fields_T is array (Positive range <>, Positive range <>) of Field_T;
  function Get_Fields(Stone: Stone_T) return Rotated_Fields_T;
end Board;
