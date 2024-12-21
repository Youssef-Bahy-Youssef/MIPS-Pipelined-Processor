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
    -- * Inputs for PrioritySelector
    isReturn : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    isBranch : IN STD_LOGIC;
    isJump : IN STD_LOGIC;

    jumpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    branchAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    returnAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- * Inputs for Interrupt and Return (RTI) handler
    ID_inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- * Inputs for Program Counter
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pcWrite : IN STD_LOGIC;

    -- * Other Inputs
    cause : IN STD_LOGIC;
    -- * Inputs for Instruction Memory (NOT FOUND)
    -- * Inputs for Flush Signal
    cu_isJump : IN STD_LOGIC;
    branch_flush : IN STD_LOGIC;
    hdu_flush : IN STD_LOGIC;

    -- outputs
    inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    debug_interruptAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    debug_ID_Toggled_inst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    debug_pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    debug_selectedAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    debug_pc_stop : OUT STD_LOGIC;
    debug_flush : OUT STD_LOGIC;
    debug_instMemOutput : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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
      rst : IN STD_LOGIC;
      -- input addresses
      jumpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      nextSequentialAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      branchAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      exceptionAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      returnAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      interruptAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      IM_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

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

      pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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
      isException : IN STD_LOGIC;
      pc_stop : IN STD_LOGIC;
      branch_flush : IN STD_LOGIC;
      hdu_flush : IN STD_LOGIC;

      out_flush : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Interrupt and Return (RTI) handler
  COMPONENT IntAndRetHandler IS
    PORT (
      inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      out1 : OUT STD_LOGIC;
      out2 : OUT STD_LOGIC;
      newInst : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  -- Output Mux
  COMPONENT OutputMux IS
    PORT (
      flush : IN STD_LOGIC;
      isInt1OrRti1 : IN STD_LOGIC;
      int2_rti2_instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      memory_output : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      inst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;
  -- * Signals for Priority Selector
  SIGNAL exceptionAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL isInterrupt : STD_LOGIC;
  SIGNAL index : STD_LOGIC_VECTOR(10 DOWNTO 0);
  SIGNAL interruptAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- * Signals for Interrupt and Return (RTI) handler
  SIGNAL isInt1OrRti1 : STD_LOGIC;
  SIGNAL isInt2OrRti2 : STD_LOGIC;
  SIGNAL ID_Toggled_inst : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- * Signals for Program Counter
  SIGNAL pcOut : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL selectedAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- * Signals for Instruction Memory
  SIGNAL IM_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IM_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IM_4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IM_6 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL IM_Out : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- * Signals for Flush Signal
  SIGNAL pc_stop : STD_LOGIC;
  SIGNAL flush : STD_LOGIC;

  SIGNAL nextSequentialAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

  debug_interruptAddress <= interruptAddress;
  debug_selectedAddress <= selectedAddress;
  debug_ID_Toggled_inst <= ID_Toggled_inst;
  debug_pcOut <= pcOut;
  debug_instMemOutput <= IM_Out;
  debug_flush <= flush;
  debug_pc_stop <= pc_stop;

  -- concurrent assignments
  -- * Priority Selector
  exceptionAddress <=
    IM_2 WHEN cause = '1' ELSE
    IM_4;
  nextSequentialAddress <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(pcOut)) + 1, 16));
  interruptAddress <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(IM_Out)) + to_integer(unsigned(index)), 16));
  index <= ID_inst(10 DOWNTO 0);
  isInterrupt <= isInt2OrRti2;
  -- * Program Counter
  -- * Interrupt and Return (RTI) handler
  -- * Instruction Memory
  -- * Flush Signal
  pc_stop <= NOT pcWrite;
  ID_Toggled_inst <= ID_inst(15 DOWNTO 1) & NOT ID_inst(0);

  -- Priority Selector Instantiation
  PrioritySelector_inst : PrioritySelector
  PORT MAP(
    -- Control signals
    isReturn => isReturn,
    isException => isException,
    isInterrupt => isInterrupt,
    isBranch => isBranch,
    isJump => isJump,
    rst => rst,
    IM_0 => IM_0,
    -- Input addresses
    jumpAddress => jumpAddress,
    nextSequentialAddress => pcOut,
    branchAddress => branchAddress,
    exceptionAddress => exceptionAddress,
    returnAddress => returnAddress,
    interruptAddress => interruptAddress,

    -- Output
    selectedAddress => selectedAddress
  );

  -- Program Counter Instantiation
  ProgramCounter_inst : ProgramCounter
  PORT MAP(
    clk => clk,
    rst => rst,
    pcWrite => pcWrite,
    isInt1OrRti1 => isInt1OrRti1,
    pcIn => selectedAddress,

    pcOut => pcOut
  );

  -- Instruction Memory Instantiation
  InstructionMemory_inst : InstructionMemory
  PORT MAP(
    pc => pcOut,

    IM_0 => IM_0,
    IM_2 => IM_2,
    IM_4 => IM_4,
    IM_6 => IM_6,
    inst => IM_Out
  );

  -- Flush Signal Instantiation
  FlushSignal_inst : FlushSignal
  PORT MAP(
    cu_isJump => cu_isJump,
    isException => isException,
    pc_stop => pc_stop,
    branch_flush => branch_flush,
    hdu_flush => hdu_flush,

    out_flush => flush
  );

  -- Interrupt and Return (RTI) Handler Instantiation
  IntAndRetHandler_inst : IntAndRetHandler
  PORT MAP(
    inst => ID_inst,

    out1 => isInt1OrRti1,
    out2 => isInt2OrRti2,
    newInst => ID_Toggled_inst
  );

  -- Output Mux Instantiation
  OutputMux_inst : OutputMux
  PORT MAP(
    flush => flush,
    isInt1OrRti1 => isInt1OrRti1,
    int2_rti2_instruction => ID_Toggled_inst,
    memory_output => IM_Out,

    inst_out => inst
  );

END Behavioral;