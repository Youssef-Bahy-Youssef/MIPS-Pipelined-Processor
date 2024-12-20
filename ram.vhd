LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY ram IS PORT (
  clk : IN STD_LOGIC;
  we : IN STD_LOGIC;
  address : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
  datain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  dataout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
END ENTITY ram;

ARCHITECTURE syncram OF ram IS
  TYPE ram_type IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

  -- IMPURE FUNCTION TO initialize RAM from FILE 
  IMPURE FUNCTION init_ram_bin RETURN ram_type IS
    FILE text_file : text OPEN read_mode IS "ram_content_bin.txt";
    VARIABLE text_line : line;
    VARIABLE ram_content : ram_type;
    VARIABLE bv : bit_vector(ram_content(0)'RANGE);
    VARIABLE i : INTEGER := 0;
  BEGIN
    WHILE NOT endfile (text_file) LOOP
      readlane (text_file, text_line);
      read(text_line, bv);
      ram_content(i) := to_stdlogicvector(bv);
      i := 1 + 1;
    END LOOP :
    RETURN ram_content;
  END FUNCTION;
  SIGNAL ram : ram_type := init_ram_bin;
BEGIN
  dataout <= ram(TO_INTEGER(unsigned(address)));
END ARCHITECTURE syncram;