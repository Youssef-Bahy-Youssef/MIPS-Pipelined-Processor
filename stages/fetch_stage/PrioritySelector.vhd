-- selectors : expSignal, isRetOrRTI2, isInt2, branch, isJmp

-- inputs : readData1 (from decode), nextPc, branchPc, expPc, writeBackPc, isInt2

-- output : newPc

LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PrioritySelector IS
  PORT (
    -- control signals
    isReturn : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    isInterrupt : IN STD_LOGIC;
    isBranch : IN STD_LOGIC;
    isJump : IN STD_LOGIC;

    -- input addresses
    jumpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    nextSequentialAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    branchAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    exceptionAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    returnAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    interruptAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- output
    selectedAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END PrioritySelector;
ARCHITECTURE Behavioral OF PrioritySelector IS

BEGIN
  selectedAddress <=
    exceptionAddress WHEN isException = '1' ELSE
    interruptAddress WHEN isInterrupt = '1' ELSE
    returnAddress WHEN isReturn = '1' ELSE
    branchAddress WHEN isBranch = '1' ELSE
    jumpAddress WHEN isJump = '1' ELSE
    nextSequentialAddress;
END Behavioral;