generic
package Board.Test_Data is
  ----------------------------------------
  --      01 02 03 04 05 06 07 08 09 10 --
  --     .^..^..^.                      --
  -- 01  .       .                      --
  --     .       .                      --
  --     .       .                      --
  -- 02  .       >                      --
  --     .......v.                      --
  --           .^....                   --
  -- 03        .    .                   --
  --           .    .                   --
  --           .    ........^....       --
  -- 04        <    ><          .       --
  --           .    ..          .       --
  --           .    ..          .       --
  -- 05        .    ..          >       --
  --           .v.....          .       --
  --                 .          .       --
  -- 06              .          >       --
  --                 .          .       --
  --                 .          .       --
  -- 07              .          .       --
  --                 .......v....       --
  --                                    --
  -- 08                                 --
  --                                    --
  --                                    --
  -- 09                                 --
  --                                    --
  --                                    --
  -- 10                                 --
  ----------------------------------------
  Test_Board: constant Board_T := (
    1 => ( 1 => (Status => Occupied, Field => (North => Open, East => Inner, South => Inner, West => Closed)),
           2 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Closed, West => Closed)),
           others => (Status => Empty)),
    2 => ( 1 => (Status => Occupied, Field => (North => Open, East => Closed, South => Inner, West => Inner)),
           2 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Closed, West => Inner)),
           others => (Status => Empty)),
    3 => ( 1 => (Status => Occupied, Field => (North => Open, East => Closed, South => Inner, West => Inner)),
           2 => (Status => Occupied, Field => (North => Inner, East => Open, South => Open, West => Inner)),
           3 => (Status => Occupied, Field => (North => Open, East => Inner, South => Inner, West => Closed)),
           4 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Open)),
           5 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Open, West => Closed)),
           others => (Status => Empty)),
    4 => ( 3 => (Status => Occupied, Field => (North => Closed, East => Closed, South => Inner, West => Inner)),
           4 => (Status => Occupied, Field => (North => Inner, East => Open, South => Inner, West => Inner)),
           5 => (Status => Occupied, Field => (North => Inner, East => Closed, South => Closed, West => Inner)),
           others => (Status => Empty)),
    5 => ( 4 => (Status => Occupied, Field => (North => Closed, East => Inner, South => Inner, West => Open)),
           5 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Closed)),
           6 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Closed)),
           7 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Closed, West => Closed)),
           others => (Status => Empty)),
    6 => ( 4 => (Status => Occupied, Field => (North => Closed, East => Inner, South => Inner, West => Inner)),
           5 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Inner)),
           6 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Inner)),
           7 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Closed, West => Inner)),
           others => (Status => Empty)),
    7 => ( 4 => (Status => Occupied, Field => (North => Open, East => Inner, South => Inner, West => Inner)),
           5 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Inner)),
           6 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Inner, West => Inner)),
           7 => (Status => Occupied, Field => (North => Inner, East => Inner, South => Open, West => Inner)),
           others => (Status => Empty)),
    8 => ( 4 => (Status => Occupied, Field => (North => Closed, East => Closed, South => Inner, West => Inner)),
           5 => (Status => Occupied, Field => (North => Inner, East => Open, South => Inner, West => Inner)),
           6 => (Status => Occupied, Field => (North => Inner, East => Open, South => Inner, West => Inner)),
           7 => (Status => Occupied, Field => (North => Inner, East => Closed, South => Closed, West => Inner)),
           others => (Status => Empty)),
    others => (others => (Status => Empty)));
end Board.Test_Data;
