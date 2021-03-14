generic
  Stone_Width: Positive;
  Stone_Height: Positive;
package Board.Stone.Uniform is

  type Uniform_Stone_T is private;

  type Stack_T is array (Positive range <>) of Uniform_Stone_T;

  function Unique_List (Connectors: Positive) return Stack_T;
  function Stonify (U: In Uniform_Stone_T) return Stone_T;

  private

  type Uniform_Stone_T is new Stone_T (1 .. Stone_Width, 1 .. Stone_Height);

end Board.Stone.Uniform;
