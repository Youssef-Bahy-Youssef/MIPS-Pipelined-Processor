-- inputs : 
-- cause, reset, isInt2,expSignal, isBranch, isReturn

-- jumpAddress, branchAddress, returnAddress

-- signals : nextSequentialAddress, exceptionAddress 

-- outputs : newInstruction, PC, IN, 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IF_Stage IS
  PORT (
    jumpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    branchAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    returnAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- control signals
    cause : IN STD_LOGIC;
    isBranch : IN STD_LOGIC;
    isJump : IN STD_LOGIC;
    isReturn : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    -- isInterrupt : IN STD_LOGIC; -- signal not input

    -- Flush signals
    cu_isJump : IN STD_LOGIC;
    isExp : IN STD_LOGIC;
    pc_stop : IN STD_LOGIC;
    branch_flush : IN STD_LOGIC;
    hdu_flush : IN STD_LOGIC;

    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    flush : IN STD_LOGIC;
    pcWrite : IN STD_LOGIC;

    -- outputs
    inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END IF_Stage;
ARCHITECTURE Behavioral OF IF_Stage IS

  -- Priority Selector Instantiation
  COMPONENT PrioritySelector IS
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
  END COMPONENT;

  -- Program Counter Instantiation
  COMPONENT ProgramCounter IS
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      pcWrite : IN STD_LOGIC;
      isInt1OrRti1 : IN STD_LOGIC;
      pcIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    );
  END COMPONENT;

  -- Instruction Memory Instantiation
  COMPONENT InstructionMemory IS
    PORT (
      pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      IM_0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      IM_2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      IM_4 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      IM_6 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  -- IF Flush Signal Instantiation
  COMPONENT FlushSignal IS
    PORT (
      cu_isJump : IN STD_LOGIC;
      isExp : IN STD_LOGIC;
      pc_stop : IN STD_LOGIC;
      branch_flush : IN STD_LOGIC;
      hdu_flush : IN STD_LOGIC;

      out_flush : OUT STD_LOGIC;
    );
  END COMPONENT;

  -- Interrupt and Return (RTI) handler
  COMPONENT IntAndRetHandler IS
    PORT (
      inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      out1 : OUT STD_LOGIC;
      out2 : OUT STD_LOGIC;
      newInst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    );
  END COMPONENT;

  -- Output Mux
  COMPONENT OutputMux IS
    PORT (
      flush : IN STD_LOGIC;
      isInt1OrRti1 : IN STD_LOGIC;
      int2_rti2_instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      memory_output : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      inst_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    );
  END COMPONENT;

  SIGNAL exceptionAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL emptyStackExceptionAddress : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
  SIGNAL invalidMemoryAddress : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

  SIGNAL pcIn : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL pcOut : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL selectedAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- for interrupts
  SIGNAL isInterrupt : STD_LOGIC;
  SIGNAL index : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL interruptAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL interruptBaseAddress : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000"; -- IM[6]
  SIGNAL INT2Opcode : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000"

BEGIN
  -- concurrent assignments
  exceptionAddress <=
    emptyStackExceptionAddress WHEN cause = '0' ELSE
    invalidMemoryAddress;
  nextSequentialAddress <= pcOut + 1;
  pc <= pcOut;

  -- interrupt signals
  isInterrupt <= '1' WHEN inst(15 DOWNTO 11) = INT2Opcode ELSE
    '0';
  index <= inst(1 DOWNTO 0);
  interruptAddress <= interruptBaseAddress + index;

  PrioritySelector_inst : PrioritySelector
  PORT MAP(
    -- Control signals
    isReturn => isReturn,
    isException => isException,
    isInterrupt => isInterrupt,
    isBranch => isBranch,
    isJump => isJump,

    -- Input addresses
    jumpAddress => jumpAddress,
    nextSequentialAddress => nextSequentialAddress,
    branchAddress => branchAddress,
    exceptionAddress => exceptionAddress,
    returnAddress => returnAddress,
    interruptAddress => interruptAddress,

    -- Output
    selectedAddress => selectedAddress
  );

  ProgramCounter_inst : ProgramCounter
  PORT MAP(
    clk => clk,
    rst => rst,
    pcWrite => pcWrite,
    pcIn => selectedAddress, -- Input from PrioritySelector
    isInterrupt => isInterrupt;
    pcOut => pcOut -- Output to InstructionMemory
  );
  InstructionMemory_inst : InstructionMemory
  PORT MAP(
    flush => flush,
    pc => pcOut, -- Input from ProgramCounter
    inst => inst -- Output: Instruction fetched
  );

END Behavioral;