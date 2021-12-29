with Ada.Text_IO;

package body Player is
  protected body Player_T is
    procedure Next_Move(Board: In Game_Board.Board_T;
                        Stone: In Out Game_Board.Stone_T;
                        Placement: Out Game_Board.Point_T) is
    begin
      Player.all.Next_Move(Board, Stone, Placement);
    end Next_Move;

    procedure Disqualify is
    begin
      Inner.all.Disqualify;
    end Disqualify;

    procedure End_Game(Final_Board: In Game_Board.Board_T;
                       Score: In Natural) is
    begin
      Inner.all.End_Game(Final_Board, Score);
    end End_Game;

  end Player_T;


  procedure Next_Move(Player: In Random_Player;
                      Board: In Game_Board.Board_T;
                      Stone: In Out Game_Board.Stone_T;
                      Placement: Out Game_Board.Point_T)
  is
    use Ada.Text_IO;
    Moves: constant array (1 .. 4) of Game_Board.Point_Sets.Set
      := (Game_Board.Valid_Moves(Board, Stone),
          Game_Board.Valid_Moves(Board, Game_Board.Rotate(Stone)),
          Game_Board.Valid_Moves(Board, Game_Board.Rotate(Game_Board.Rotate(Stone))),
          Game_Board.Valid_Moves(Board, Game_Board.Rotate(Game_Board.Rotate(Game_Board.Rotate(Stone)))));
    Valid_Stones: Natural := 0;
    Chosen_Stone: Positive := 1;
  begin
    if not Moves(1).Is_Empty then
      Valid_Stones := Valid_Stones + 1;
    end if;
    if not Moves(2).Is_Empty then
      Valid_Stones := Valid_Stones + 1;
    end if;
    if not Moves(3).Is_Empty then
      Valid_Stones := Valid_Stones + 1;
    end if;
    if not Moves(4).Is_Empty then
      Valid_Stones := Valid_Stones + 1;
    end if;
    if Valid_Stones = 0 then
      raise Player_Error with "We cannot find any available moves.";
    end if;

    -- Choose stone
    declare
      type Move_Range is new Positive range 1 .. Valid_Stones;
      package Rnd_Rng is new Ada.Numerics.Discrete_Random(Move_Range);
      Gen: Rnd_Rng.Generator;
    begin
      Rnd_Rng.Reset(Gen, Rnd_Int.Random(Player.Rnd));
      for X in 2 .. Rnd_Rng.Random(Gen) loop
        Stone := Game_Board.Rotate(Stone);
        Chosen_Stone := Chosen_Stone + 1;
        while Moves(Chosen_Stone).Is_Empty loop
          Chosen_Stone := Chosen_Stone + 1;
          Stone := Game_Board.Rotate(Stone);
        end loop;
      end loop;
    end;

    -- Choose move for stone
    declare
      Considered_Moves: constant Game_Board.Point_Sets.Set
        := Moves(Chosen_Stone);
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
end Player;
