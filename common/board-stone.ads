-- @summary
-- Representation of stones.
--
-- @description
-- This package provides methods to deal with the logical unit of a stone of
-- the game.
generic
package Board.Stone is
  subtype Border_Connector_T is Inner_Connector_T range Closed .. Open;

  type Border_T is array (Positive range <>) of Border_Connector_T;

  type Stone_T(<>) is private;

  -- Places a stone on a board such that the upper left element of the stone is
  -- placed at placement.
  -- @param Stone The stone to be placed.
  -- @param Board The board the stone is placed on.
  -- @param Placement The coordinates of the upper left corner of the stone
  -- on the board.
  -- @exception Board.Board_Error raised if the stone would overlap with a
  -- previously placed stone; i.e., if
  --   Fits(Stone, Board, Placement) = False
  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
                   Placement: In Point_T);

  -- Returns a set of points that a stone would cover if put at point.
  -- @param Stone The stone to use.
  -- @param Point The point to put the upper left corner of the stone to return
  -- the "shadow" it casts.
  -- @return The set of points the stone would cover if places at the given
  -- point.
  -- @exception Board.Board_Error Thrown if the shadow of the stone lies
  -- outside the board dimensions.
  function Covers (Stone: In Stone_T; Point: In Point_T) return Point_Sets.Set;

  -- Returns whether the stone put on this point fits the dimensions of the
  -- board.
  -- @param Stone The stone to use.
  -- @param Point The point to put the upper left corner of the stone to return
  -- whether it then fits the board.
  -- @return Whether the stone when put at the point would fit into the
  -- dimensions of the board.
  function Fits_Dimensions (Stone: In Stone_T; Point: In Point_T) return Boolean;

  -- Checks whether a stone fits on a board at postition Placement.
  -- @param Stone The stone to fit.
  -- @param Board The board to fit it on.
  -- @param Placement The coordinate of the upper left corner of the stone
  -- on the board.
  -- @return Whether stone can be placed on the board at the specified
  -- position.
  function Fits (Stone: In Stone_T;
                 Board: In Board_T;
                 Placement: In Point_T)
                 return Boolean;

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
  -- @param Consistent Indicates whether the connectors of the stone fit with
  -- the already placed stones on the board.
  -- @param Increasing Indicates whether the connectors of the stone fit
  -- connects at least one open connector with the already placed stones on the
  -- board.
  -- @exception Board.Board_Error Thrown if an inconsistent state is detected;
  -- e.g., an overlap with another stone which is detected by
  -- seeing Inner connectors. Although, this check is not
  -- complete: if fails, for example, when a stone is checked to
  -- be put precisely on another stone that is already placed.
  procedure Connects (Stone: In Stone_T;
                     Board: In Board_T;
                     Placement: In Point_T;
                     Consistent: Out Boolean;
                     Increasing: Out Boolean);

  -- Returns the border of a stone in a certain direction.
  -- @param Stone The stone for which we return the border.
  -- @param Direction Which border to return.
  -- @return The border of the direction of the stone.
  function Get_Border (Stone: In Stone_T;
                       Direction: In Direction_T) return Border_T;

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

  function Get_Width (Stone: in Stone_T) return Positive;
  function Get_Height (Stone: in Stone_T) return Positive;

  -- Constructs a stone that is a copy of another stone but rotated by 90°.
  -- @param Stone The stone to rotate.
  -- @return A copy of the stone but rotated by 90°.
  function Rotate (Stone: In Stone_T) return Stone_T;

  private

  type Stone_T is array (Positive range <>, Positive range <>) of Field_T;
end Board.Stone;
