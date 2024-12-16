LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ProgramCounter IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pcWrite : IN STD_LOGIC;
    pcIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
  );
END ProgramCounter;

ARCHITECTURE Behavioral OF ProgramCounter IS

  SIGNAL rstIm : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

BEGIN
  PROCESS (clk, rst)
  BEGIN
    IF rst = '1' THEN
      pcOut <= rstIm;
    ELSIF rising_edge(clk) AND pcWrite = '1' THEN
      pcOut <= pcIn;
    END IF;
  END PROCESS;
END Behavioral;