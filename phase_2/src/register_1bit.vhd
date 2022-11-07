----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 04:27:42 PM
-- Design Name: Register - 1 bit
-- Module Name: register_1bit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: A 1-bit register
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

entity register_1bit is
    Port ( d 	  : in  std_logic;
           resetn : in  std_logic;
           clock  : in  std_logic;
           wren   : in  std_logic;
           q      : out std_logic );
end register_1bit;

architecture Behavioral of register_1bit is

signal q_temp : std_logic;

begin

    process(resetn, clock)
    begin
        if (resetn = '1') then
            q_temp <= '0';
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
