with Player;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;

package body Game is

  task body Game_T is
    Board: Game_Board.Board_T := Game_Board.New_Board;

    NS_Player: Players.Player_Acc := Players.Construct_Player(NS.all);
    WE_Player: Players.Player_Acc := Players.Construct_Player(EW.all);

    type Token_T is (NSP, WEP);
    Token: Token_T := NSP;
    procedure Toggle
    is
    begin
      if Token = NSP then
        Token := WEP;
      else
        Token := NSP;
      end if;
    end Toggle;

    type Outer_Indices is new Positive range 1 .. 8;
    package Rnd_Indices is new Ada.Numerics.Discrete_Random(Outer_Indices);
    Gen: Rnd_Indices.Generator;

    function Generate_Stone return Game_Board.Stone_T
    is
      Value: array (Outer_Indices) of Boolean := (others => False);

      function Marked_Value return Natural
      is
        Result: Natural := 0;
      begin
        for I in Outer_Indices loop
          if Value(I) then
            Result := Result + 1;
          end if;
        end loop;
        return Result;
      end Marked_Value;
    begin
      while Marked_Value < 3 loop
        declare
          Index: constant Outer_Indices := Rnd_Indices.Random(Gen);
        begin
          Ada.Text_IO.Put_Line("Setting index " & Index'Image & " for generated stone.");
          Value(Index) := True;
        end;
      end loop;
      declare
        Northern_Border: constant Game_Board.Border_T(1 .. 3)
          := (1 => (if Value(1) then Game_Board.Open else Game_Board.Closed),
              2 => (if Value(2) then Game_Board.Open else Game_Board.Closed),
              3 => (if Value(3) then Game_Board.Open else Game_Board.Closed));
        Eastern_Border: constant Game_Board.Border_T(1 .. 1)
          := (1 => (if Value(4) then Game_Board.Open else Game_Board.Closed));
        Southern_Border: constant Game_Board.Border_T(1 .. 3)
          := (1 => (if Value(5) then Game_Board.Open else Game_Board.Closed),
              2 => (if Value(6) then Game_Board.Open else Game_Board.Closed),
              3 => (if Value(7) then Game_Board.Open else Game_Board.Closed));
        Western_Border: constant Game_Board.Border_T(1 .. 1)
          := (1 => (if Value(8) then Game_Board.Open else Game_Board.Closed));
      begin
        Ada.Text_IO.Put_Line("Generating stone.");
        return Game_Board.Stone_From_Borders(Northern_Border, Eastern_Border, Southern_Border, Western_Border);
      end;
    end Generate_Stone;
  begin
    Ada.Text_IO.Put_Line("Start playing.");
    loop
      Ada.Text_IO.Put_Line("Beginning of loop.");
      declare
        Current_Stone: constant Game_Board.Stone_T := Generate_Stone;
        Moves: constant Game_Board.Moves_T := Game_Board.Valid_Moves(Board, Current_Stone);
      begin
        Ada.Text_IO.Put_Line("Generated  Stone.");
        exit when Moves(0).Is_Empty and Moves(1).Is_Empty and Moves(2).Is_Empty and Moves(3).Is_Empty;
        Ada.Text_IO.Put_Line("Awaiting move.");
        declare
          Player_Stone: Game_Board.Stone_T := Current_Stone;
          Player_Move: Game_Board.Point_T;
        begin
          if Token = NSP then
            NS_Player.Next_Move(Board, Player_Stone, Player_Move);
          else
            WE_Player.Next_Move(Board, Player_Stone, Player_Move);
          end if;
          -- for now we just trust the player to not do stupid things
          Game_Board.Place(Board, Player_Stone, Player_Move);
          Ada.Text_IO.Put_Line("Placed Stone; toggling player.");
          Toggle;
        end;
      exception
        when others => Ada.Text_IO.Put_Line("There was an exception.");
      end;
    end loop;
    Ada.Text_IO.Put_Line("Finished playing; ready to accept output of result.");
    accept Result(Final_Board: out Game_Board.Board_T) do
      Final_Board := Board;
    end Result;
  end Game_T;

end Game;
