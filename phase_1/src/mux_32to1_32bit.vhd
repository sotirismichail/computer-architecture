----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 07:29:34 PM
-- Design Name: Multiplexer, 32 to 1, 32 bit
-- Module Name: mux_32to1_32bit - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.array_32bit.all;

entity mux_32to1_32bit is
    Port ( sel      : in std_logic_vector (4 downto 0);
           data_in  : in array_32bit; 
           data_out : out std_logic_vector (31 downto 0) );
end mux_32to1_32bit;

architecture Behavioral of mux_32to1_32bit is

begin

    data_out <= data_in (to_integer(unsigned(sel)));

end Behavioral;
