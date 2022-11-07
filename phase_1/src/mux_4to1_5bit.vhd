library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1_5bit is
    Port ( sel : in std_logic_vector (1 downto 0);
           in_0: in std_logic_vector (4 downto 0);
           in_1: in std_logic_vector (4 downto 0);
           in_2: in std_logic_vector (4 downto 0);
           in_3: in std_logic_vector (4 downto 0);         
           dout: out std_logic_vector (4 downto 0) );
end mux_4to1_5bit;

architecture Behavioral of mux_4to1_5bit is

begin

    multiplexer : process(sel, in_0, in_1, in_2, in_3)
    begin
        if sel = "00" then
            dout <= in_0;
        elsif sel = "01" then
            dout <= in_1;
        elsif sel = "10" then
            dout <= in_2;
        else
            dout <= in_3;
        end if;
    end process;
    
end Behavioral;