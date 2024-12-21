LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity EX_stage is
    port(
        clk : in std_logic;
        -- inputs
        pcOut : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        nextPcOut : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        readData1 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        readData2 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc1 : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2 : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdst : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        if_id_flush : in STD_LOGIC;
        memRead : in STD_LOGIC;
        memWrite : in STD_LOGIC;
        memToReg : in STD_LOGIC;
        regWrite : in STD_LOGIC;
        isInt : in STD_LOGIC;
        spWrite : in STD_LOGIC;
        useSp : in STD_LOGIC;
        useImm : in STD_LOGIC;
        isCall : in STD_LOGIC;
        pcWrite : in STD_LOGIC;
        aluOp : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        isJz : in STD_LOGIC;
        isJn : in STD_LOGIC;
        isJc : in STD_LOGIC;
        isRetOrRti2 : in STD_LOGIC;
        isRet : in STD_LOGIC;
        isCallOrInt : in STD_LOGIC;
        store_or_load_Flags : in STD_LOGIC; -- for INT, RTI 
        -- outputs
        MEM_regWrite : out std_logic;
        MEM_memRead : out std_logic;
        MEM_memWrite : out std_logic;
        MEM_memtoReg : out std_logic;
        MEM_PCout : out std_logic_vector(15 downto 0);
        MEM_PCinc : out std_logic_vector(15 downto 0);
        MEM_is_call_or_int : out std_logic;
        MEM_store_flags_or_pc : out std_logic;
        MEM_RET_or_RTI : out std_logic;
        MEM_ALUout : out std_logic_vector(15 downto 0);
        MEM_Rsrc2 : out std_logic_vector(15 downto 0); -- register value
        MEM_Rdst : out std_logic_vector(2 downto 0); --address
        MEM_is_RTI : out std_logic;
        MEM_reset_or_exception : out std_logic;
        MEM_PCwrite : out std_logic;
        MEM_SPwrite : out std_logic;
        MEM_is_INT : out std_logic;
        MEM_branch : out std_logic;
        MEM_flags : out std_logic_vector(2 downto 0)
    );
end EX_stage;

ARCHITECTURE a_EX_stage of EX_stage is
begin
end a_EX_stage;