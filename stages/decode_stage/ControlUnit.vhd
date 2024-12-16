LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ControlUnit IS
  PORT (
    opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0)

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

    aluOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
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
    aluOp <= "000";

    CASE opcode IS
        -- NOP (No Operation)
      WHEN "00000" =>
        pcWrite <= '1';

        -- HLT (Halt)
      WHEN "00001" =>
        pcWrite <= '0';

        -- SETC (Set Carry)
      WHEN "00010" =>
        pcWrite <= '1';
        aluOp <= "001";

        -- NOT (Logical NOT)
      WHEN "00011" =>
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "010";

        -- INC (Increment)
      WHEN "00100" =>
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "011";

        -- OUT (Output)
      WHEN ""
        pcWrite <= '1';
        aluOp <= "100";

        -- IN (Input)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- MOV (mov)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- ADD (add)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- SUB (subtract)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "110";

        -- AND (logical and)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "111";

        -- IADD (immediate add)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- PUSH (push)
      WHEN ""
        memWrite <= '1';
        spWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- POP (pop)
      WHEN ""
        memRead <= '1';
        memToReg <= '1';
        regWrite <= '1';
        spWrite <= '1';
        useSp <= '1';
        pcWrite <= '1';
        aluOp <= "011";

        -- LDM (load immediate value)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- LDD (load value from memory)
      WHEN ""
        memRead <= '1';
        memToReg <= '1';
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- STD (Store value to memory)
      WHEN ""
        memWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- JZ (jump if zero)
      WHEN ""
        pcWrite <= '1';

        -- JN (jump if negative)
      WHEN ""
        pcWrite <= '1';

        -- JC (jump if carry)
      WHEN ""
        pcWrite <= '1';

        -- JMP (jump)
      WHEN ""
        pcWrite <= '1';

        -- CALL (call)
      WHEN ""
        memWrite <= '1';
        spWrite <= '1';
        pcWrite <= '1';
        aluOp <= "100";

        -- RET (return)
      WHEN ""
        memRead <= '1';
        memToReg <= '1';
        spWrite <= '1';
        useSp <= '1';
        pcWrite <= '1';
        aluOp <= "011";
        ------------------------------------------------------

        -- INT1 (interrupt)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- INT2 (interrupt)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- RTI1 (return)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";

        -- RTI2 (return)
      WHEN ""
        regWrite <= '1';
        pcWrite <= '1';
        aluOp <= "101";
        -- Default case for unrecognized opcodes
      WHEN OTHERS =>
        pcWrite <= '0'; -- Disable PC write as a fail-safe
    END CASE;
  END PROCESS;
END Behavioral;