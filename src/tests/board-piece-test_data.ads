generic
package Board.Piece.Test_Data is
  --------------------------------------------------
  --  Original --  Once   --  Twice    -- Thrice  --
  --           --   x o   --           --   x o   --
  --   x o x   -- x|_|_|x --   o o x   -- x|_|_|o --
  -- o|_|_|_|x -- o|_|_|o -- o|_|_|_|x -- o|_|_|o --
  -- x|_|_|_|o -- o|_|_|x -- x|_|_|_|o -- x|_|_|x --
  --   x o o   --   o x   --   x o x   --   o x   --
  --------------------------------------------------
  Original_Piece: constant Piece_T := (
    1 => (1 => (North => Closed, East => Inner, South => Inner, West => Open),
          2 => (North => Inner, East => Inner, South => Closed, West => Closed)),
    2 => (1 => (North => Open, East => Inner, South => Inner, West => Inner),
          2 => (North => Inner, East => Inner, South => Open, West => Inner)),
    3 => (1 => (North => Closed, East => Closed, South => Inner, West => Inner),
          2 => (North => Inner, East => Open, South => Open, West => Inner)));
  Once_Rotated_Piece: constant Piece_T := (
    1 => (1 => (North => Closed, East => Inner, South => Inner, West => Closed),
          2 => (North => Inner, East => Inner, South => Inner, West => Open),
          3 => (North => Inner, East => Inner, South => Open, West => Open)),
    2 => (1 => (North => Open, East => Closed, South => Inner, West => Inner),
          2 => (North => Inner, East => Open, South => Inner, West => Inner),
          3 => (North => Inner, East => Closed, South => Closed, West => Inner)));
  Twice_Rotated_Piece: constant Piece_T := (
    1 => (1 => (North => Open, East => Inner, South => Inner, West => Open),
          2 => (North => Inner, East => Inner, South => Closed, West => Closed)),
    2 => (1 => (North => Open, East => Inner, South => Inner, West => Inner),
          2 => (North => Inner, East => Inner, South => Open, West => Inner)),
    3 => (1 => (North => Closed, East => Closed, South => Inner, West => Inner),
          2 => (North => Inner, East => Open, South => Closed, West => Inner)));
  Thrice_Rotated_Piece: constant Piece_T := (
    1 => (1 => (North => Closed, East => Inner, South => Inner, West => Closed),
          2 => (North => Inner, East => Inner, South => Inner, West => Open),
          3 => (North => Inner, East => Inner, South => Open, West => Closed)),
    2 => (1 => (North => Open, East => Open, South => Inner, West => Inner),
          2 => (North => Inner, East => Open, South => Inner, West => Inner),
          3 => (North => Inner, East => Closed, South => Closed, West => Inner)));

  -- .^........^.
  -- .          .
  -- .  4x2     .
  -- .          .
  -- .          >
  -- ....v..v....

  Test_Piece: constant Piece_T := (
    1 => (
      1 => (
                        North => Open,
        West => Closed,                East => Inner,
                        South => Inner),
      2 => (
                        North => Inner,
        West => Closed,                East => Inner,
                        South => Closed)),
    2 => (
      1 => (
                        North => Closed,
        West => Inner,                   East => Inner,
                        South => Inner),
      2 => (
                        North => Inner,
        West => Inner,                 East => Inner,
                        South => Open)),
    3 => (
      1 => (
                        North => Closed,
        West => Inner,                   East => Inner,
                        South => Inner),
      2 => (
                        North => Inner,
        West => Inner,                 East => Inner,
                        South => Closed)),
    4 => (
      1 => (
                        North => Open,
        West => Inner,                   East => Closed,
                        South => Inner),
      2 => (
                        North => Inner,
        West => Inner,                 East => Open,
                        South => Closed)));

  Fits_Places: constant array(X_Coordinate_T, Y_Coordinate_T) of Boolean :=
    (
      1 => (
        6 => True,
        7 => True,
        8 => True,
        9 => True,
        others => False),
      2 => (
        8 => True,
        9 => True,
        others => False),
      3 => (
        8 => True,
        9 => True,
        others => False),
      4 => (
        1 => True,
        8 => True,
        9 => True,
        others => False),
      5 => (
        1 => True,
        2 => True,
        8 => True,
        9 => True,
        others => False),
      6 => (
        1 => True,
        2 => True,
        8 => True,
        9 => True,
        others => False),
      7 => (
        1 => True,
        2 => True,
        8 => True,
        9 => True,
        others => False),
      8 => (others => False),
      9 => (others => False),
      10 => (others => False)
    );
end Board.Piece.Test_Data;
