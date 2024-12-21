library ieee;
Use ieee.std_logic_1164.all;

entity my_adder is
    port(
        a,b,cin : in std_logic;
        s,cout : out std_logic 
    );
end my_adder;

architecture a_my_adder of my_adder is 
begin
    s <= a xor b xor cin;
    cout <= (a and b) or (cin and (a xor b));
end a_my_adder;

library ieee;
Use ieee.std_logic_1164.all;

entity my_nadder is
generic(n : integer := 16);
    port(
        a,b : in std_logic_vector(n-1 downto 0);
        --cin : in std_logic;
        s : out std_logic_vector(n-1 downto 0);
        cout : out std_logic 
    );
end my_nadder;

architecture a_my_nadder of my_nadder is 
    component my_adder is
       port(a,b,cin : in std_logic; s,cout : out std_logic);
    end component;
    signal temp :std_logic_vector(n downto 0);
begin
    temp(0) <= '0';
    loop1 : for i in 0 to n-1 generate
        fx: my_adder port map(a(i),b(i),temp(i),s(i),temp(i+1));
    end generate;
    cout <= temp(n);
end a_my_nadder;

library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_ALU is 
    port(
        alu_op : in std_logic_vector(2 downto 0);
        operand1 : in std_logic_vector(15 downto 0);
        operand2 : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(15 downto 0);
        flags : out std_logic_vector(2 downto 0) -- Z is 0 , N is 1 , C is 2
    );
end my_ALU;

architecture a_my_ALU of my_ALU is 
    component my_nadder is
        generic( n : integer );
        port(
            a,b : in std_logic_vector(n-1 downto 0);
            --cin : in std_logic;
            s : out std_logic_vector(n-1 downto 0);
            cout : out std_logic 
        );
    end component;
    TYPE results_type IS ARRAY(0 TO 4) of std_logic_vector(15 DOWNTO 0);
    signal temp : results_type; -- 0 is not, 1 is inc, 2 is add , 3 is sub, 4 is and
    signal c : std_logic_vector(3 downto 0); -- inc is 0 , add is 1 , sub is 2 , 3 for two's complement of operand two
    signal op2_bar : std_logic_vector(15 downto 0);
    signal op2_2comp : std_logic_vector(15 downto 0);
    signal z : std_logic_vector(5 downto 0);
begin

    temp(0) <= not operand1;
    f1: my_nadder generic map(16) port map(operand1,x"0001",temp(1),c(0));
    f2: my_nadder generic map(16) port map(operand1,operand2,temp(2),c(1)); 
    temp(4) <= operand1 and operand2;
    op2_bar <= not operand2;
    f3: my_nadder generic map(16) port map(x"0001",op2_bar,op2_2comp,c(3));
    f4: my_nadder generic map(16) port map(operand1,op2_2comp,temp(2),c(2)); 
    z(0) <= '1' when temp(0) = x"0000" else '0';
    z(1) <= '1' when temp(1) = x"0000" else '0';
    z(2) <= '1' when temp(2) = x"0000" else '0';
    z(3) <= '1' when temp(3) = x"0000" else '0';
    z(4) <= '1' when temp(4) = x"0000" else '0';
    z(5) <= '1' when operand1 = x"0000" else '0';



    process(operand1,operand2,alu_op)
    begin
        if ( alu_op = "001" ) then -- setc
            flags(2) <= '1';
        elsif ( alu_op = "010" ) then -- not
            result <= temp(0);
            flags(0) <= z(0);
            flags(1) <= temp(0)(15); 
        elsif ( alu_op = "011" ) then -- inc
            result <= temp(1);
            flags(0) <= z(1);
            flags(1) <= temp(1)(15);
            flags(2) <= c(0);
        elsif ( alu_op = "100" ) then -- mov
            result <= operand1;
            flags(0) <= z(5);
            flags(1) <= operand1(15);
        elsif ( alu_op = "101" ) then -- add
            result <= temp(2);
            flags(0) <= z(2);
            flags(1) <= temp(2)(15);
            flags(2) <= c(1);
        elsif ( alu_op = "110" ) then -- sub
            result <= temp(3);
            flags(0) <= z(3);
            flags(1) <= temp(3)(15);
            flags(2) <= c(2);
        elsif ( alu_op = "111" ) then -- and
            result <= temp(4);
            flags(0) <= z(4);
            flags(1) <= temp(4)(15);
        end if; 
    end process;


    
end a_my_ALU;

