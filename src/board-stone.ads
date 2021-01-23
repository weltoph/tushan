generic
package Board.Stone is
  subtype Border_Connector_T is Inner_Connector_T range Closed .. Open;

  type Border_T is array (Positive range <>) of Border_Connector_T;

  type Stone_T(<>) is private;

  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
                   Placement_X: X_Coordinate;
                   Placement_Y: Y_Coordinate);

  function Fits (Stone: In Stone_T;
                 Board: In Out Board_T;
                 Placement_X: X_Coordinate;
                 Placement_Y: Y_Coordinate)
                 return Boolean;

  function Connects (Stone: In Stone_T;
                     Board: In Out Board_T;
                     Placement_X: X_Coordinate;
                     Placement_Y: Y_Coordinate)
                     return Boolean;

  function Get_Border (Stone: In Stone_T;
                       Direction: In Direction_T) return Border_T;

  function Stone_From_Borders(Northern_Border: Border_T;
                              Eastern_Border: Border_T;
                              Southern_Border: Border_T;
                              Western_Border: Border_T)
                              return Stone_T;

  function Get_Width (Stone: in Stone_T) return Positive;
  function Get_Height (Stone: in Stone_T) return Positive;

  function Rotate (Stone: In Stone_T) return Stone_T;

  private

  type Stone_T is array (Positive range <>, Positive range <>) of Field_T;
end Board.Stone;
