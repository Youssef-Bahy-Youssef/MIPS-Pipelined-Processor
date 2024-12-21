LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY EX_MEM_Register IS
  PORT (
    clk : in std_logic;
    --input from EX
    EX_regWrite : in std_logic;
    EX_memRead : in std_logic;
    EX_memWrite : in std_logic;
    EX_memtoReg : in std_logic;
    EX_PCout : in std_logic_vector(15 downto 0);
    EX_PCinc : in std_logic_vector(15 downto 0);
    EX_is_call_or_int : in std_logic;
    EX_store_flags_or_pc : in std_logic;
    EX_RET_or_RTI : in std_logic;
    EX_ALUout : in std_logic_vector(15 downto 0);
    EX_Rsrc2 : in std_logic_vector(15 downto 0); -- register value
    EX_Rdst : in std_logic_vector(2 downto 0); --address
    EX_is_RTI : in std_logic;
    EX_reset_or_exception : in std_logic;
    EX_PCwrite : in std_logic;
    EX_SPwrite : in std_logic;
    EX_is_INT : in std_logic;
    EX_branch : in std_logic;
    EX_flags : in std_logic_vector(2 downto 0);
    --output to MEM
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
END EX_MEM_Register;

ARCHITECTURE a_EX_MEM_Register OF EX_MEM_Register IS

    signal regWrite : std_logic;
    signal memRead : std_logic;
    signal memWrite : std_logic;
    signal memtoReg : std_logic;
    signal PCout : std_logic_vector(15 downto 0);
    signal PCinc : std_logic_vector(15 downto 0);
    signal is_call_or_int : std_logic;
    signal store_flags_or_pc : std_logic;
    signal RET_or_RTI : std_logic;
    signal ALUout : std_logic_vector(15 downto 0);
    signal Rsrc2 : std_logic_vector(15 downto 0); -- register value
    signal Rdst : std_logic_vector(2 downto 0); --address
    signal is_RTI : std_logic;
    signal reset_or_exception : std_logic;
    signal PCwrite : std_logic;
    signal SPwrite : std_logic;
    signal is_INT : std_logic;
    signal branch : std_logic;
    signal flags : std_logic_vector(2 downto 0);

BEGIN
  PROCESS (clk)
  BEGIN
    if rising_edge(clk) then
        MEM_regWrite <= regWrite; 
        MEM_memRead <= memRead;
        MEM_memWrite <= memWrite;
        MEM_memtoReg <= memtoReg;
        MEM_PCout <= PCout;
        MEM_PCinc <= PCinc;
        MEM_is_call_or_int <= is_call_or_int;
        MEM_store_flags_or_pc <= store_flags_or_pc;
        MEM_RET_or_RTI <= RET_or_RTI;
        MEM_ALUout <= ALUout;
        MEM_Rsrc2 <= Rsrc2;
        MEM_Rdst <= Rdst;
        MEM_is_RTI <= is_RTI;
        MEM_reset_or_exception <= reset_or_exception;
        MEM_PCwrite <= PCwrite;
        MEM_SPwrite <= SPwrite;
        MEM_is_INT <= is_INT;
        MEM_branch <= branch;
        MEM_flags <= flags;
    elsif falling_edge(clk) then
        regWrite <= EX_regWrite; 
        memRead <= EX_memRead;
        memWrite <= EX_memWrite;
        memtoReg <= EX_memtoReg;
        PCout <= EX_PCout;
        PCinc <= EX_PCinc;
        is_call_or_int <= EX_is_call_or_int;
        store_flags_or_pc <= EX_store_flags_or_pc;
        RET_or_RTI <= EX_RET_or_RTI;
        ALUout <= EX_ALUout;
        Rsrc2 <= EX_Rsrc2;
        Rdst <= EX_Rdst;
        is_RTI <= EX_is_RTI;
        reset_or_exception <= EX_reset_or_exception;
        PCwrite <= EX_PCwrite;
        SPwrite <= EX_SPwrite;
        is_INT <= EX_is_INT;
        branch <= EX_branch;
        flags <= EX_flags;      
    end if;
  END PROCESS;
END a_EX_MEM_Register;