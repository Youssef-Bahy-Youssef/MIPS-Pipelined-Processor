LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ControlUnit IS
  PORT (
    opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0)
    lastBit : IN STD_LOGIC;

    memRead : OUT STD_LOGIC;
    memWrite : OUT STD_LOGIC;
    memToReg : OUT STD_LOGIC;
    regWrite : OUT STD_LOGIC;
    isInt : OUT STD_LOGIC;
    spWrite : OUT STD_LOGIC;
    useSp : OUT STD_LOGIC;
    useImm : OUT STD_LOGIC;
    isCall : OUT STD_LOGIC;
    pcWrite : OUT STD_LOGIC;
    aluOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

    isJz : OUT STD_LOGIC;
    isJn : OUT STD_LOGIC;
    isJc : OUT STD_LOGIC;
    isRetOrRti2 : OUT STD_LOGIC;
    isRet : OUT STD_LOGIC;
    isCallOrInt : OUT STD_LOGIC;
    store_or_load_Flags : OUT STD_LOGIC -- for INT, RTI 
    -- INT1 --> store flags
    -- INT2 --> store pc
    -- RTI1 --> load pc
    -- RTI2 --> load flags

    -- isIntFlag : OUT STD_LOGIC;
  );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS

  SIGNAL

BEGIN
  PROCESS (opcode)
  BEGIN
    -- Default values for control signals
    memRead <= '0';
    memWrite <= '0';
    memToReg <= '0';
    regWrite <= '0';
    isInt <= '0';
    spWrite <= '0';
    useSp <= '0';
    useImm <= '0';
    isCall <= '0';
    pcWrite <= '0';

    isJz <= '0';
    isJn <= '0';
    isJc <= '0';
    isRetOrRti2 <= '0';
    isRet <= '0';
    isCallOrInt <= '0';
    store_or_load_Flags <= lastBit; -- in INT RTI

    -- isIntFlag <= '0';

    aluOp <= "000";

    CASE opcode IS
        -- NOP (No Operation)
      WHEN "00000" =>
        pcWrite <= '1';

        -- HLT (Halt)
      WHEN "00010" =>
        pcWrite <= '0';

        -- SETC (Set Carry)
      WHEN "00011" =>
        pcWrite <= '1';
        aluOp <= "001";

        -- NOT (Logical NOT)
      WHEN "00100" =>
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "010";

        -- INC (Increment)
      WHEN "00101" =>
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "011";

        -- OUT (Output)
      WHEN "00110"
        pcWrite <= '1';
        aluOp <= "100";

        -- IN (Input)
      WHEN "00111"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- MOV (mov)
      WHEN "01000"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- ADD (add)
      WHEN "01001"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- SUB (subtract)
      WHEN "01010"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "110";

        -- AND (logical and)
      WHEN "01011"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "111";

        -- IADD (immediate add)
      WHEN "01100"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- PUSH (push)
      WHEN "01101"
        memWrite <= '1';
        spWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- POP (pop)
      WHEN "10000"
        memRead <= '1';
        memToReg <= '1';
        regWrite <= '1';
        spWrite <= '1';
        useSp <= '1';
        pcWrite <= '1';
        aluOp <= "011";

        -- LDM (load immediate value)
      WHEN "10001"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- LDD (load value from memory)
      WHEN "10010"
        memRead <= '1';
        memToReg <= '1';
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- STD (Store value to memory)
      WHEN "10011"
        memWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- JZ (jump if zero)
      WHEN "11000"
        pcWrite <= '1';
        isJz <= '1';

        -- JN (jump if negative)
      WHEN "11001"
        pcWrite <= '1';
        isJn <= '1';

        -- JC (jump if carry)
      WHEN "11010"
        pcWrite <= '1';
        isJc <= '1';

        -- JMP (jump)
      WHEN "11011"
        pcWrite <= '1';

        -- CALL (call)
      WHEN "11100"
        memWrite <= '1';
        spWrite <= '1';
        pcWrite <= '1';
        isCallOrInt <= "1";
        aluOp <= "100";

        -- RET (return)
      WHEN "11110"
        memRead <= '1';
        memToReg <= '1';
        spWrite <= '1';
        useSp <= '1';
        pcWrite <= '1';
        isRet <= "1";
        isRetOrRti2 <= "1";
        aluOp <= "011";
        ------------------------------------------------------

        -- INT (interrupt)
      WHEN "11101"
        regWrite <= '1';
        pcWrite <= '1';
        isCallOrInt <= "1";
        aluOp <= "101";

        -- RTI (return)
      WHEN "11111"
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- Default case for unrecognized opcodes
      WHEN OTHERS =>
        pcWrite <= '0'; -- Disable PC write as a fail-safe
    END CASE;
  END PROCESS;
END Behavioral;