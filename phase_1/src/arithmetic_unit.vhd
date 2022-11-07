----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/17/2021 06:53:12 PM
-- Design Name: Arithmetic Unit
-- Module Name: arithmetic_unit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: An arithmetic operations unit, implementing the
--				operations ADD, SUB and NOT
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
use IEEE.std_logic_unsigned.ALL;

entity arithmetic_unit is
    Port ( in_0 : in std_logic_vector (31 downto 0);
           in_1 : in std_logic_vector (31 downto 0);
           op   : in std_logic_vector (1 downto 0);
           res  : out std_logic_vector (31 downto 0) );
end arithmetic_unit;

architecture Behavioral of arithmetic_unit is

begin

res <= in_0 + in_1 when op = "00" else
       in_0 - in_1 when op = "01" else
       in_0 (30 downto 0) & '0' when op = "10" else
       "00000000000000000000000000000000";

end Behavioral;
