LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY InstructionMemory IS
  PORT (
    pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    IM_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    IM_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    IM_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    IM_6 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END InstructionMemory;

ARCHITECTURE Behavioral OF InstructionMemory IS

  -- Function to convert STD_LOGIC_VECTOR to INTEGER
  FUNCTION toInt(vec : STD_LOGIC_VECTOR) RETURN INTEGER IS
  BEGIN
    RETURN to_integer(unsigned(vec));
  END FUNCTION;

  -- RAM type definition
  TYPE ram_type IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- Impure function to initialize RAM from a file
  IMPURE FUNCTION init_ram_bin RETURN ram_type IS
    FILE text_file : text OPEN read_mode IS "../program.mc";
    VARIABLE text_line : line;
    VARIABLE ram_content : ram_type;
    VARIABLE bv : bit_vector(15 DOWNTO 0); -- Adjusted to match STD_LOGIC_VECTOR(15 DOWNTO 0)
    VARIABLE i : INTEGER := 0;
  BEGIN
    WHILE NOT endfile(text_file) LOOP
      readline(text_file, text_line);
      read(text_line, bv);
      ram_content(i) := to_stdlogicvector(bv);
      i := i + 1; -- Corrected the increment
    END LOOP;
    RETURN ram_content;
  END FUNCTION;

  -- Signal declaration for RAM
  SIGNAL ram : ram_type := init_ram_bin;

BEGIN

  -- Assign instructions based on the program counter
  inst <= ram(toInt(pc));
  IM_0 <= ram(0);
  IM_2 <= ram(2);
  IM_4 <= ram(4);
  IM_6 <= ram(6);

END Behavioral;