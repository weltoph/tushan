package body Board is
  function NewBoard return Board_T is
  begin
    return (others => (others => (Status => Empty)));
  end NewBoard;
end Board;
