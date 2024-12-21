library ieee;
Use ieee.std_logic_1164.all;

entity SP_register is
    port(
        clk : in std_logic;
        en : in std_logic;
        d : in std_logic_vector(15 downto 0);
        q : out std_logic_vector(15 downto 0)
    );
end SP_register;

ARCHITECTURE a_SP_register of SP_register is
begin
    PROCESS(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                q <= d;
            end if;
        end if;
    end process;
end a_SP_register;

library ieee;
Use ieee.std_logic_1164.all;

entity Flags_register is
    port(
        clk : in std_logic;
        en : in std_logic;
        d : in std_logic_vector(2 downto 0);
        q : out std_logic_vector(2 downto 0)
    );
end Flags_register;

ARCHITECTURE a_Flags_register of Flags_register is
begin
    PROCESS(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                q <= d;
            end if;
        end if;
    end process;
end a_Flags_register;

library ieee;
Use ieee.std_logic_1164.all;

entity EPC_register is
    port(
        clk : in std_logic;
        en : in std_logic;
        d : in std_logic_vector(15 downto 0);
        q : out std_logic_vector(15 downto 0)
    );
end EPC_register;

ARCHITECTURE a_EPC_register of EPC_register is
begin
    PROCESS(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                q <= d;
            end if;
        end if;
    end process;
end a_EPC_register;
