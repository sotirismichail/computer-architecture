----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 07:36:57 PM
-- Design Name: Multiplexer, 2 to 1, 5 bit
-- Module Name: mux_2to1_5bit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Multiplexer
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

entity mux_2to1_5bit is
    Port ( sel : in std_logic;
           in_0: in std_logic_vector (4 downto 0);
           in_1: in std_logic_vector (4 downto 0); 
           dout: out std_logic_vector (4 downto 0) );
end mux_2to1_5bit;

architecture Behavioral of mux_2to1_5bit is

begin

    multiplexer : process(sel, in_0, in_1)
    begin
        if sel = '0' then
            dout <= in_0;
        else
            dout <= in_1;
        end if;
    end process;
    
end Behavioral;
