-- is that use clk (i do not think that)

LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY InstructionMemory IS
  PORT (
    clk : IN STD_LOGIC;
    flush : IN STD_LOGIC;
    pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END InstructionMemory;

ARCHITECTURE Behavioral OF InstructionMemory IS
  FUNCTION toInt(SIGNAL vec : STD_LOGIC_VECTOR) RETURN INTEGER IS
  BEGIN
    RETURN to_integer(unsigned(vec));
  END FUNCTION;

  TYPE IM_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IM : IM_type

  CONSTANT nop : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
BEGIN
  PROCESS (clk, flush)
  BEGIN
    inst <= "0000000000000000";
    IF flush = '1' THEN
      inst <= nop;
    ELSIF rising_edge(clk) AND flush = '0' THEN
      inst <= IM(toInt(nop));
    END IF;
  END PROCESS;
END Behavioral;