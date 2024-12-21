LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY OutputMux IS
  PORT (
    flush : IN STD_LOGIC;
    isInt1OrRti1 : IN STD_LOGIC;
    int2_rti2_instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    memory_output : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    inst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END OutputMux;

ARCHITECTURE Behavioral OF OutputMux IS

  CONSTANT NOP : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

BEGIN
  inst_out <= NOP WHEN flush = '1' ELSE
    int2_rti2_instruction WHEN isInt1OrRti1 = '1' ELSE
    memory_output;
END Behavioral;