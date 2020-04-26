generic
package Board.Stone is
  subtype Border_Connector_T is Inner_Connector_T range Closed .. Open;

  type Horizontal_Border_T is array (X_Coordinate range <>)
    of Border_Connector_T;

  type Vertical_Border_T is array (Y_Coordinate range <>)
    of Border_Connector_T;

  type Stone_T(<>) is private;

  procedure Place (Stone: In Stone_T;
                   Board: In Out Board_T;
                   Placement_X: X_Coordinate;
                   Placement_Y: Y_Coordinate);

--    function Fits (Stone: In Stone_T;
--                   Board: In Out Board_T;
--                   Placement_X: X_Coordinate;
--                   Placement_Y: Y_Coordinate)
--                   return Boolean;

--    function Connects_Flow (Stone: In Stone_T;
--                            Board: In Out Board_T;
--                            Placement_X: X_Coordinate;
--                            Placement_Y: Y_Coordinate)
--                            return Boolean;

  function Stone_From_Borders(Northern_Border: Horizontal_Border_T;
                              Eastern_Border: Vertical_Border_T;
                              Southern_Border: Horizontal_Border_T;
                              Western_Border: Vertical_Border_T)
                              return Stone_T;

--    function Rotate (Stone: In Stone_T) return Stone_T;

  private

  type Stone_T is
    array (X_Coordinate range <>, Y_Coordinate range <>) of Field_T;


--    function Get_Northern_Border (Stone: In Stone_T) return Horizontal_Border_T;
--    function Get_Southern_Border (Stone: In Stone_T) return Horizontal_Border_T;
--    function Get_Eastern_Border  (Stone: In Stone_T) return Vertical_Border_T;
--    function Get_Western_Border  (Stone: In Stone_T) return Vertical_Border_T;

end Board.Stone;
