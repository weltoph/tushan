with Player;
with Display;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
with Ada.Exceptions;

package body Game is

  task body Game_T is
    package Display_Board is new Display(Game_Board);
    Board: Game_Board.Board_T := Game_Board.Empty_Board;

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
        return Game_Board.Stone_From_Borders(Northern_Border, Eastern_Border, Southern_Border, Western_Border);
      end;
    end Generate_Stone;
  begin
    Ada.Text_IO.Put_Line("The game begins. The board is:");
    Rnd_Indices.Reset(Gen);
    Display_Board.Print_Display(Board);
    loop
      declare
        Current_Stone: constant Game_Board.Stone_T := Generate_Stone;
        Moves: constant Game_Board.Moves_T := Game_Board.Valid_Moves(Board, Current_Stone);
      begin
        Ada.Text_IO.Put_Line("We have generated a stone. It looks like:");
        Game_Board.Display_Stone(Current_Stone);
        exit when Moves(0).Is_Empty and Moves(1).Is_Empty and Moves(2).Is_Empty and Moves(3).Is_Empty;
        declare
          Player_Rotation: Game_Board.Rotation_T;
          Player_Move: Game_Board.Point_T;
        begin
          if Token = NSP then
            NS_Player.Next_Move(Board, Current_Stone, Player_Rotation, Player_Move);
          else
            WE_Player.Next_Move(Board, Current_Stone, Player_Rotation, Player_Move);
          end if;
          -- for now we just trust the player to not do stupid things
          declare
            Inserted_Stone: constant Game_Board.Stone_T := Game_Board.Rotate(Current_Stone, Player_Rotation);
          begin
            Ada.Text_IO.Put_Line("The user gave us their move: it places at <" & Player_Move.X'Image & "," & Player_Move.Y'Image &"> the following stone:");
            Game_Board.Display_Stone(Inserted_Stone);
            Game_Board.Place(Board, Inserted_Stone, Player_Move);
          end;
          Ada.Text_IO.Put_Line("This results in the following board state:");
          Display_Board.Print_Display(Board);
          declare
            Input: Character;
          begin
            Ada.Text_IO.Get_Immediate(Input);
            exit when Input = 'c';
          end;
          Toggle;
        end;
      exception
        when E: others =>
          Ada.Text_IO.Put_Line("There was an exception.");
          Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Information(E));
          exit;
      end;
    end loop;
    Ada.Text_IO.Put_Line("Finished playing; ready to accept output of result.");
    accept Result(Final_Board: out Game_Board.Board_T) do
      Final_Board := Board;
    end Result;
  end Game_T;

end Game;
