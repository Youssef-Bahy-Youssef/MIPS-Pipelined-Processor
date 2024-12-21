LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HazardDetectionUnit IS
  PORT (
    id_ex_memRead : IN STD_LOGIC;
    id_ex_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    if_id_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    if_id_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

    if_id_write : OUT STD_LOGIC;
    control : OUT STD_LOGIC;
    pcWrite : OUT STD_LOGIC
  );
END HazardDetectionUnit;

ARCHITECTURE Behavioral OF HazardDetectionUnit IS
BEGIN

  PROCESS (id_ex_memRead, id_ex_Rdst, if_id_Rsrc1, if_id_Rsrc2)
  BEGIN
    -- default values 
    control <= '0';
    pcWrite <= '1';
    if_id_write <= '1';

    IF id_ex_memRead = '1' THEN
      IF (if_id_Rsrc1 = id_ex_Rdst) OR (if_id_Rsrc2 = id_ex_Rdst) THEN
        control <= '1';
        pcWrite <= '0';
        if_id_write <= '0';
      END IF;
    END IF;
  END PROCESS;

END Behavioral;