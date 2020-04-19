package body Board is
  function NewBoard return Board_T is
  begin
    return (others => (others => null));
  end NewBoard;
end Board;
