----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/19/2021 08:24:45 PM
-- Design Name: Logical Unit
-- Module Name: logical_unit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: A logical operation unit, implementing the
-- 				AND, OR and NOT logical operations			 
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

entity logical_unit is
    Port (  in_0 : in std_logic_vector (31 downto 0);
            in_1 : in std_logic_vector (31 downto 0);
            op : in std_logic_vector (1 downto 0);
            res : out std_logic_vector (31 downto 0) );
end logical_unit;

architecture Behavioral of logical_unit is

begin

res <=  in_0 and in_1 when op = "01" else
        in_0 or in_1 when op = "00" else
        not in_0 when op = "10" else
        "00000000000000000000000000000000" ;

end Behavioral;
