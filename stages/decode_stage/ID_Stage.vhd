LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ID_Stage IS
  PORT (
    -- inputs
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    rf_regWrite : IN STD_LOGIC;
    writeReg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    writeData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- for Hazard Detection Unit
    id_ex_memRead : IN STD_LOGIC;
    id_ex_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    if_id_write : OUT STD_LOGIC;
    control : OUT STD_LOGIC;

    -- Inputs for ID_Flush_Mux
    id_ex_isRetOrRti2 : IN STD_LOGIC;
    branch : IN STD_LOGIC;
    id_ex_useImm : IN STD_LOGIC;
    ex_mem_isRet : IN STD_LOGIC;
    isException : IN STD_LOGIC;
    hdu_control : IN STD_LOGIC;

    -- outputs
    pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    nextPcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    readData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    readData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    Rsrc1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    Rsrc2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    Rdst : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    if_id_flush : OUT STD_LOGIC;

    -- control signals outputs
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
  );
END ID_Stage;

ARCHITECTURE Behavioral OF ID_Stage IS
  -- add components

  COMPONENT RegisterFile IS
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
  END COMPONENT;

  COMPONENT ControlUnit IS
    PORT (
      opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
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

      isJz : OUT STD_LOGIC;
      isJn : OUT STD_LOGIC;
      isJc : OUT STD_LOGIC;
      isRetOrRti2 : OUT STD_LOGIC;
      isRet : OUT STD_LOGIC;
      isCallOrInt : OUT STD_LOGIC;
      store_or_load_Flags : OUT STD_LOGIC; -- for INT, RTI 
      aluOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT HazardDetectionUnit IS
    PORT (
      id_ex_memRead : IN STD_LOGIC;
      id_ex_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      if_id_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      if_id_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

      if_id_write : OUT STD_LOGIC;
      control : OUT STD_LOGIC;
      pcWrite : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ID_Flush_Mux IS
    PORT (
      id_ex_isRetOrRti2 : IN STD_LOGIC;
      branch : IN STD_LOGIC;
      id_ex_useImm : IN STD_LOGIC;
      ex_mem_isRet : IN STD_LOGIC;
      isException : IN STD_LOGIC;
      hdu_control : IN STD_LOGIC;

      if_id_flush : OUT STD_LOGIC;
      id_ex_flush : OUT STD_LOGIC
    );
  END COMPONENT;
  -- add signals

  SIGNAL rf_readReg1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL rf_readReg2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL rf_readData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL rf_readData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

  -- signals for flush
  SIGNAL id_ex_flush : STD_LOGIC;

  -- signals for control unit
  SIGNAL cu_opcode : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL cu_lastBit : STD_LOGIC;
  SIGNAL cu_memRead : STD_LOGIC;
  SIGNAL cu_memWrite : STD_LOGIC;
  SIGNAL cu_memToReg : STD_LOGIC;
  SIGNAL cu_regWrite : STD_LOGIC;
  SIGNAL cu_isInt : STD_LOGIC;
  SIGNAL cu_spWrite : STD_LOGIC;
  SIGNAL cu_useSp : STD_LOGIC;
  SIGNAL cu_useImm : STD_LOGIC;
  SIGNAL cu_isCall : STD_LOGIC;
  SIGNAL cu_pcWrite : STD_LOGIC;

  SIGNAL cu_isJz : STD_LOGIC;
  SIGNAL cu_isJn : STD_LOGIC;
  SIGNAL cu_isJc : STD_LOGIC;
  SIGNAL cu_isRetOrRti2 : STD_LOGIC;
  SIGNAL cu_isRet : STD_LOGIC;
  SIGNAL cu_isCallOrInt : STD_LOGIC;
  SIGNAL cu_store_or_load_Flags : STD_LOGIC;

  SIGNAL cu_aluOp : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- signals does not include in some component
  SIGNAL d_Rdst : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

  -- Concurrent Assignments
  cu_opcode <= inst(15 DOWNTO 11);
  cu_lastBit <= inst(0);
  rf_readReg1 <= inst(10 DOWNTO 8);
  rf_readReg2 <= inst(7 DOWNTO 5);
  d_Rdst <= inst(4 DOWNTO 2);
  -- Register File Instantiation
  regFile : RegisterFile
  PORT MAP(
    clk => clk,
    rst => rst,
    regWrite => rf_regWrite,
    readReg1 => rf_readReg1,
    readReg2 => rf_readReg2,
    writeReg => writeReg,
    writeData => writeData,
    readData1 => rf_readData1,
    readData2 => rf_readData2
  );

  -- Control Unit Instantiation
  ctrlUnit : ControlUnit
  PORT MAP(
    opcode => cu_opcode,
    lastBit => cu_lastBit,
    memRead => cu_memRead,
    memWrite => cu_memWrite,
    memToReg => cu_memToReg,
    regWrite => cu_regWrite,
    isInt => cu_isInt,
    spWrite => cu_spWrite,
    useSp => cu_useSp,
    useImm => cu_useImm,
    isCall => cu_isCall,
    pcWrite => cu_pcWrite,

    isJz => cu_isJz,
    isJn => cu_isJn,
    isJc => cu_isJc,
    isRetOrRti2 => cu_isRetOrRti2,
    isRet => cu_isRet,
    isCallOrInt => cu_isCallOrInt,
    store_or_load_Flags => cu_store_or_load_Flags,
    aluOp => cu_aluOp
  );

  -- Hazard Detection Unit Instantiation
  hazardDetection : HazardDetectionUnit
  PORT MAP(
    id_ex_memRead => id_ex_memRead,
    id_ex_Rdst => id_ex_Rdst,
    if_id_Rsrc1 => rf_readReg1,
    if_id_Rsrc2 => rf_readReg2,
    if_id_write => if_id_write,
    control => control,
    pcWrite => pcWrite
  );

  -- ID_Flush_Mux Instantiation
  ID_Flush_Mux_inst : ID_Flush_Mux
  PORT MAP(
    id_ex_isRetOrRti2 => id_ex_isRetOrRti2,
    branch => branch,
    id_ex_useImm => id_ex_useImm,
    ex_mem_isRet => ex_mem_isRet,
    isException => isException,
    hdu_control => hdu_control,

    if_id_flush => if_id_flush,
    id_ex_flush => id_ex_flush
  );

  -- General Outputs
  pcOut <= pc;
  -- nextPcOut <= pc + 1;
  nextPcOut <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
  readData1 <= rf_readData1;
  readData2 <= rf_readData2;
  Rsrc1 <= rf_readReg1;
  Rsrc2 <= rf_readReg2;
  Rdst <= d_Rdst;

  -- Control Unit Outputs
  PROCESS (id_ex_flush, clk)
  BEGIN
    IF id_ex_flush = '1' THEN
      memRead <= '0';
      memWrite <= '0';
      memToReg <= '0';
      regWrite <= '0';
      isInt <= '0';
      spWrite <= '0';
      useSp <= '0';
      useImm <= '0';
      isCall <= '0';
      -- pcWrite <= '1';
      aluOp <= "00";

      isJz <= '0';
      isJn <= '0';
      isJc <= '0';
      isRetOrRti2 <= '0';
      isRet <= '0';
      isCallOrInt <= '1';
      store_or_load_Flags <= '0';

    ELSE
      memRead <= cu_memRead;
      memWrite <= cu_memWrite;
      memToReg <= cu_memToReg;
      regWrite <= cu_regWrite;
      isInt <= cu_isInt;
      spWrite <= cu_spWrite;
      useSp <= cu_useSp;
      useImm <= cu_useImm;
      isCall <= cu_isCall;
      pcWrite <= cu_pcWrite;
      aluOp <= cu_aluOp;

      isJz <= cu_isJz;
      isJn <= cu_isJn;
      isJc <= cu_isJc;
      isRetOrRti2 <= cu_isRetOrRti2;
      isRet <= cu_isRet;
      isCallOrInt <= cu_isCallOrInt;
      store_or_load_Flags <= cu_store_or_load_Flags;
    END IF;
  END PROCESS;
END Behavioral;