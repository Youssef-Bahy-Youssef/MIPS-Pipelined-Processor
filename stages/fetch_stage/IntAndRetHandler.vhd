LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IntAndRetHandler IS
  PORT (
    inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    out1 : OUT STD_LOGIC;
    out2 : OUT STD_LOGIC;
    newInst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
  );
END IntAndRetHandler;

ARCHITECTURE Behavioral OF IntAndRetHandler IS

  SIGNAL opcode : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL flag_bit : STD_LOGIC;

  CONSTANT INT_OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11101";

  CONSTANT RTI_OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11111";

BEGIN
  newInst <= inst(15 DOWNTO 1) AND NOT inst(0);
  PROCESS (inst)
  BEGIN
    CASE inst(15 DOWNTO 11) IS
      WHEN INT_OPCODE =>
        CASE inst(0) IS
          WHEN '1' =>
            out1 <= '1';
            out2 <= '0';
          WHEN OTHERS =>
            out1 <= '0';
            out2 <= '1';
        END CASE;

      WHEN RTI_OPCODE =>
        CASE inst(0) IS
          WHEN '0' =>
            out1 <= '1';
            out2 <= '0';
          WHEN OTHERS =>
            out1 <= '0';
            out2 <= '0';
        END CASE;
      WHEN OTHERS =>
        out1 <= '0';
        out2 <= '0';
    END CASE;
  END PROCESS;
END Behavioral;