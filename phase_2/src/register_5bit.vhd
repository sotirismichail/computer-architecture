----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 04:27:42 PM
-- Design Name: Register - 5 bit
-- Module Name: register_5bit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: A 5-bit register
-- 
-- Dependencies: -
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_5bit is
    Port ( d 	  : in  std_logic_vector(4 downto 0);
           resetn : in  std_logic;
           clock  : in  std_logic;
           wren   : in  std_logic;
           q      : out std_logic_vector(4 downto 0) );
end register_5bit;

architecture Behavioral of register_5bit is

signal q_temp : std_logic_vector(4 downto 0);

begin

    process(resetn, clock)
    begin
        if (resetn = '1') then
            q_temp <= (others => '0');
        elsif (rising_edge(clock)) then
            if (wren = '1') then
                q_temp <= d;
            else
                q_temp <= q_temp;
            end if;
        end if;
   end process;
   
   q <= q_temp;

end Behavioral;
