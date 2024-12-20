LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ID_Flush_Mux IS
  PORT (
    id_ex_isRetOrRti2 : IN STD_LOGIC;
    branch : IN STD_LOGIC;
    id_ex_useImm : IN STD_LOGIC;
    ex_mem_isRet : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    hdu_control : IN STD_LOGIC;

    if_id_flush : OUT STD_LOGIC;
    id_ex_flush : OUT STD_LOGIC
  );
END ID_Flush_Mux;

ARCHITECTURE Behavioral OF ID_Flush_Mux IS

  SIGNAL retOrBranchFlushSignal : STD_LOGIC;

BEGIN
  retOrBranchFlushSignal <= id_ex_isRetOrRti2 OR branch;

  if_id_flush <= retOrBranchFlushSignal OR ex_mem_isRet;
  id_ex_flush <= retOrBranchFlushSignal OR hdu_control OR isException OR id_ex_useImm;

END Behavioral;