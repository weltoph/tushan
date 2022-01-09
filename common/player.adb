with Ada.Text_IO;

package body Player is
  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Game_Board.Stone_T;
                      Rotations: Out Game_Board.Rotation_T;
                      Placement: Out Game_Board.Point_T)
  is
    use Ada.Text_IO;
    Moves: constant Game_Board.Moves_T := Game_Board.Valid_Moves(Board, Stone);
    Possible_Indices: Natural := 0;
  begin
    if not Moves(0).Is_Empty then
      Possible_Indices := Possible_Indices + 1;
    end if;
    if not Moves(1).Is_Empty then
      Possible_Indices := Possible_Indices + 1;
    end if;
    if not Moves(2).Is_Empty then
      Possible_Indices := Possible_Indices + 1;
    end if;
    if not Moves(3).Is_Empty then
      Possible_Indices := Possible_Indices + 1;
    end if;
    if Possible_Indices = 0 then
      raise Player_Error with "We cannot find any available moves.";
    end if;


    declare
      type Mapping_Range is new Positive range 1 .. Possible_Indices;
      Mapping: array (Mapping_Range) of Game_Board.Rotation_T;
      Current_Index: Natural := 0;
    begin
      for I in Mapping'Range loop
        while (Game_Board.Rotation_T'First <= Current_Index and Current_Index <= Game_Board.Rotation_T'Last) and then Moves(Current_Index).Is_Empty loop
          Current_Index := Current_Index + 1;
        end loop;
        Mapping(I) := Current_Index;
      end loop;
      declare
        package Rnd_Rng is new Ada.Numerics.Discrete_Random(Mapping_Range);
        Gen: Rnd_Rng.Generator;
      begin
        Rnd_Rng.Reset(Gen, Rnd_Int.Random(Player.Rnd));
        Rotations := Mapping(Rnd_Rng.Random(Gen));
      end;
    end;

    -- Choose move for stone
    declare
      Considered_Moves: constant Game_Board.Point_Sets.Set
        := Moves(Rotations);
      type Move_Range is new Positive range 1 .. Natural(Considered_Moves.Length);
      package Rnd_Rng is new Ada.Numerics.Discrete_Random(Move_Range);
      Gen: Rnd_Rng.Generator;
      Current: Game_Board.Point_Sets.Cursor := Considered_Moves.First;
    begin
      Rnd_Rng.Reset(Gen, Rnd_Int.Random(Player.Rnd));
      for X in 2 .. Rnd_Rng.Random(Gen) loop
        Game_Board.Point_Sets.Next(Current);
      end loop;
      Placement := Game_Board.Point_Sets.Element(Current);
    end;
  end Next_Move;


  procedure Disqualify(Player: In Random_Player)
  is
    use Ada.Text_IO;
  begin
    Put_Line("I was disqualified :(");
  end Disqualify;

  procedure End_Game(Player: In Random_Player;
                     Final_Board: In Game_Board.Board_T;
                     Score: In Natural)
  is
    use Ada.Text_IO;
  begin
    Put_Line("The game ended and I scored " & Score'Image & " points!");
  end End_Game;

  function Construct_Player(Info: In Player_Info) return Player_Acc
  is
  begin
    case Info.Player_Type is
      when Random => return new Random_Player;
    end case;
  end Construct_Player;
end Player;
