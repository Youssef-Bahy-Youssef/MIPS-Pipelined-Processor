LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExceptionMux IS
  PORT (
    IM_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    IM_4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    cause : IN STD_LOGIC;

    exception_address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ExceptionMux;

ARCHITECTURE Behavioral OF ExceptionMux IS

  SIGNAL

BEGIN
  exception_address <=
    IM_2 WHEN cause = '1' ELSE
    IM_4
  END Behavioral;