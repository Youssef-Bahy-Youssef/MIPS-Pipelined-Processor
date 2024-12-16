-- inputs : 
-- cause, reset, isInt2,expSignal, isBranch, isReturn

-- jumpAddress, branchAddress, returnAddress

-- signals : nextSequentialAddress, exceptionAddress 

-- outputs : newInstruction, PC, IN, 

LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IF_Stage IS
  PORT (
    jumpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    branchAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    returnAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  );
END IF_Stage;
ARCHITECTURE Behavioral OF IF_Stage IS

  SIGNAL

BEGIN

END Behavioral;