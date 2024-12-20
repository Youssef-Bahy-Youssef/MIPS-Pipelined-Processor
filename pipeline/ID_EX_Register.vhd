LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ID_EX_Register IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;

    -- inputs
    ID_pcOut : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ID_nextPcOut : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ID_readData1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ID_readData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    ID_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- control signals inputs
    ID_memRead : IN STD_LOGIC;
    ID_memWrite : IN STD_LOGIC;
    ID_memToReg : IN STD_LOGIC;
    ID_regWrite : IN STD_LOGIC;
    ID_isInt : IN STD_LOGIC;
    ID_spWrite : IN STD_LOGIC;
    ID_useSp : IN STD_LOGIC;
    ID_useImm : IN STD_LOGIC;
    ID_isCall : IN STD_LOGIC;
    ID_pcWrite : IN STD_LOGIC;
    ID_aluOp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_isJz : IN STD_LOGIC;
    ID_isJn : IN STD_LOGIC;
    ID_isJc : IN STD_LOGIC;
    ID_isRetOrRti2 : IN STD_LOGIC;
    ID_isRet : IN STD_LOGIC;
    ID_isCallOrInt : IN STD_LOGIC;
    ID_store_or_load_Flags : IN STD_LOGIC;

    --  OUTPUTS
    EX_Rdst : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    EX_pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    EX_nextPcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- control signal outputs
    EX_memRead : OUT STD_LOGIC;
    EX_memWrite : OUT STD_LOGIC;
    EX_memToReg : OUT STD_LOGIC;
    EX_regWrite : OUT STD_LOGIC;
    EX_isInt : OUT STD_LOGIC;
    EX_spWrite : OUT STD_LOGIC;
    EX_useImm : OUT STD_LOGIC;
    EX_isCall : OUT STD_LOGIC;
    EX_pcWrite : OUT STD_LOGIC;
    EX_isJz : OUT STD_LOGIC;
    EX_isJn : OUT STD_LOGIC;
    EX_isJc : OUT STD_LOGIC;
    EX_isRetOrRti2 : OUT STD_LOGIC;
    EX_isRet : OUT STD_LOGIC;
    EX_isCallOrInt : OUT STD_LOGIC;
    EX_store_or_load_Flags : OUT STD_LOGIC;
  );
END ID_EX_Register;

ARCHITECTURE Behavioral OF ID_EX_Register IS

BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      -- Data signals
      EX_pcOut <= ID_pcOut;
      EX_nextPcOut <= ID_nextPcOut;
      EX_Rdst <= ID_Rdst;

      -- Control signals
      EX_memRead <= ID_memRead;
      EX_memWrite <= ID_memWrite;
      EX_memToReg <= ID_memToReg;
      EX_regWrite <= ID_regWrite;
      EX_isInt <= ID_isInt;
      EX_spWrite <= ID_spWrite;
      EX_useImm <= ID_useImm;
      EX_isCall <= ID_isCall;
      EX_pcWrite <= ID_pcWrite;

      EX_isJz <= ID_isJz;
      EX_isJn <= ID_isJn;
      EX_isJc <= ID_isJc;
      EX_isRetOrRti2 <= ID_isRetOrRti2;
      EX_isRet <= ID_isRet;
      EX_isCallOrInt <= ID_isCallOrInt;
      EX_store_or_load_Flags <= ID_store_or_load_Flags;
    END IF;
  END PROCESS;
END Behavioral;