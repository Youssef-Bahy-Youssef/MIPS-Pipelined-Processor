LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterFile IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    regWrite : IN STD_LOGIC;
    readReg1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    readReg2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    writeReg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    writeData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    readData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    readData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END RegisterFile;

ARCHITECTURE Behavioral OF RegisterFile IS
  -- Function to convert std_logic_vector to integer
  FUNCTION toInt(SIGNAL vec : STD_LOGIC_VECTOR) RETURN INTEGER IS
  BEGIN
    RETURN to_integer(unsigned(vec));
  END FUNCTION;

  -- Register File Declaration
  TYPE reg_file_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL regFile : reg_file_type := (OTHERS => (OTHERS => '0'));

BEGIN
  PROCESS (clk, rst)
  BEGIN
    IF rst = '1' THEN
      -- Reset all registers
      regFile <= (OTHERS => (OTHERS => '0'));
    ELSIF rising_edge(clk) AND regWrite = '1' THEN
      -- register write
      regFile(toInt(writeReg)) <= writeData;
    ELSIF falling_edge(clk) THEN
      -- register read
      readData1 <= regFile(toInt(readReg1));
      readData2 <= regFile(toInt(readReg2));
    END IF;
  END PROCESS;
END Behavioral;