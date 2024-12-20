LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IF_ID_Register IS
  PORT (
    clk : IN STD_LOGIC;
    if_id_write : IN STD_LOGIC;
    IF_pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    IF_inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    IF_inPort : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    ID_pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    ID_inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    ID_inPort : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
  );
END IF_ID_Register;

ARCHITECTURE Behavioral OF IF_ID_Register IS

  SIGNAL

BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) AND if_id_write = '1' THEN
      ID_pc <= IF_pc;
      ID_inPort <= IF_inPort;
      ID_inst <= IF_inst;
    END IF;
  END PROCESS;
END Behavioral;