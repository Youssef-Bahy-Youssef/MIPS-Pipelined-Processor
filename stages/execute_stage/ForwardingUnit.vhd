library ieee;
Use ieee.std_logic_1164.all;

entity ForwardingUnit is
    port(
        ID_EX_Rsrc1 : in std_logic_vector(2 downto 0);
        ID_EX_Rsrc2 : in std_logic_vector(2 downto 0);
        EX_MEM_Rdst : in std_logic_vector(2 downto 0);
        MEM_WB_Rdst : in std_logic_vector(2 downto 0);
        EX_MEM_regWrite : in std_logic;
        MEM_WB_regWrite : in std_logic;
        ForwardA : out std_logic_vector(1 downto 0);
        ForwardB : out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

ARCHITECTURE a_ForwardingUnit of ForwardingUnit is
begin
    ForwardA <= "10" when EX_MEM_regWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc1
        else "01" when MEM_WB_regWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc1
        else "00";

    ForwardB <= "10" when EX_MEM_regWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc2
        else "01" when MEM_WB_regWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc2
        else "00";
end a_ForwardingUnit;


