----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 07:36:57 PM
-- Design Name: Multiplexer, 4 to 1, 1 bit
-- Module Name: mux_4to1_1bit - Behavioral
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

entity mux_4to1_1bit is
    Port ( sel : in std_logic_vector (1 downto 0);
           in_0: in std_logic;
           in_1: in std_logic;
           in_2: in std_logic;
           in_3: in std_logic;
           dout: out std_logic );
end mux_4to1_1bit;

architecture Behavioral of mux_4to1_1bit is

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
