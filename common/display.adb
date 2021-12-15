with Ada.Text_IO;
package body Display is

  pragma Wide_Character_Encoding(UTF8);

  function Display(Display_Board: Game_Board.Board_T) return Board_Display_T is
    Result: Board_Display_T := (others => (others => (' ')));
    type Tile_Display is array (1 .. 3, 1 .. 3) of Wide_Character;

    function Render_Tile (Point: In Game_Board.Point_T) return Tile_Display is
      Tile: Tile_Display := (others => (others => ' '));
      use Game_Board;
    begin
      if Game_Board.Is_Occupied(Display_Board, Point) then
        declare
          Northern: constant Game_Board.Inner_Connector_T := Game_Board.Get_Connector(Display_Board, Point, Game_Board.North);
          Eastern: constant Game_Board.Inner_Connector_T := Game_Board.Get_Connector(Display_Board, Point, Game_Board.East);
          Southern: constant Game_Board.Inner_Connector_T := Game_Board.Get_Connector(Display_Board, Point, Game_Board.South);
          Western: constant Game_Board.Inner_Connector_T := Game_Board.Get_Connector(Display_Board, Point, Game_Board.West);
        begin

          if Northern = Closed then
            Tile(2, 1) := '─';
          elsif Northern = Open then
            Tile(2, 1) := '┴';
          end if;

          if Eastern = Closed then
            Tile(3, 2) := '│';
          elsif Eastern = Open then
            Tile(3, 2) := '├';
          end if;

          if Southern = Closed then
            Tile(2, 3) := '─';
          elsif Southern = Open then
            Tile(2, 3) := '┬';
          end if;

          if Western = Closed then
            Tile(1, 2) := '│';
          elsif Western = Open then
            Tile(1, 2) := '┤';
          end if;

          if Northern /= Inner then
            if Western /= Inner then
              Tile(1, 1) := '┌';
            else
              Tile(1, 1) := '─';
            end if;

            if Eastern /= Inner then
              Tile(3, 1) := '┐';
            else
              Tile(3, 1) := '─';
            end if;
          else
            if Western /= Inner then
              Tile(1, 1) := '│';
            end if;

            if Eastern /= Inner then
              Tile(3, 1) := '│';
            end if;
          end if;

          if Southern /= Inner then
            if Western /= Inner then
              Tile(1, 3) := '└';
            else
              Tile(1, 3) := '─';
            end if;

            if Eastern /= Inner then
              Tile(3, 3) := '┘';
            else
              Tile(3, 3) := '─';
            end if;
          else
            if Western /= Inner then
              Tile(1, 3) := '│';
            end if;

            if Eastern /= Inner then
              Tile(3, 3) := '│';
            end if;
          end if;
        end;
      else
        Tile(1, 1) := '┏';
        Tile(1, 2) := '┃';
        Tile(1, 3) := '┗';
        Tile(2, 1) := '━';
        Tile(2, 2) := '░';
        Tile(2, 3) := '━';
        Tile(3, 1) := '┓';
        Tile(3, 2) := '┃';
        Tile(3, 3) := '┛';
      end if;
      return Tile;
    end Render_Tile;
  begin
    for X in Game_Board.X_Coordinate loop
      for Y in Game_Board.Y_Coordinate loop
        declare
          Point: constant Game_Board.Point_T := (X, Y);
          Tile: constant Tile_Display := Render_Tile(Point);
          Ref_X: constant Natural := (X - 1)*3;
          Ref_Y: constant Natural := (Y - 1)*3;
        begin
          for Xp in 1 .. 3 loop
            for Yp in 1 .. 3 loop
              Result(Ref_X + Xp, Ref_Y + Yp) := Tile(Xp, Yp);
            end loop;
          end loop;
        end;
      end loop;
    end loop;
    return Result;
  end Display;
end Display;
