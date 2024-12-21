LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FlushSignal IS
  PORT (
    cu_isJump : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    pc_stop : IN STD_LOGIC;
    branch_flush : IN STD_LOGIC;
    hdu_flush : IN STD_LOGIC;

    out_flush : OUT STD_LOGIC
  );
END FlushSignal;

ARCHITECTURE Behavioral OF FlushSignal IS

BEGIN
  out_flush <= cu_isJump OR isException OR pc_stop OR branch_flush OR hdu_flush;
END Behavioral;