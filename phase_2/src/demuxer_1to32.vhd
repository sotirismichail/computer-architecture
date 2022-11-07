----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 07:39:03 PM
-- Design Name: Demultiplexer, 1 to 32
-- Module Name: demuxer_1to32 - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: -
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

entity demuxer_1to32 is
    Port ( i : in std_logic; 
           o : out std_logic_vector (31 downto 0); 
           sel : in std_logic_vector (4 downto 0) );
end demuxer_1to32;

architecture demux_arch of demuxer_1to32 is

begin
    process (i, sel)
        begin
            o <= "00000000000000000000000000000000";
                case sel is
                    when "00000" => o(0) <= i;
                    when "00001" => o(1) <= i; 
                    when "00010" => o(2) <= i; 
                    when "00011" => o(3) <= i;
                    when "00100" => o(4) <= i;
                    when "00101" => o(5) <= i; 
                    when "00110" => o(6) <= i; 
                    when "00111" => o(7) <= i;
                    when "01000" => o(8) <= i;
                    when "01001" => o(9) <= i; 
                    when "01010" => o(10) <= i; 
                    when "01011" => o(11) <= i;
                    when "01100" => o(12) <= i;
                    when "01101" => o(13) <= i; 
                    when "01110" => o(14) <= i; 
                    when "01111" => o(15) <= i;
                    when "10000" => o(16) <= i;
                    when "10001" => o(17) <= i; 
                    when "10010" => o(18) <= i; 
                    when "10011" => o(19) <= i;
                    when "10100" => o(20) <= i;
                    when "10101" => o(21) <= i; 
                    when "10110" => o(22) <= i; 
                    when "10111" => o(23) <= i;
                    when "11000" => o(24) <= i;
                    when "11001" => o(25) <= i; 
                    when "11010" => o(26) <= i; 
                    when "11011" => o(27) <= i;
                    when "11100" => o(28) <= i;
                    when "11101" => o(29) <= i; 
                    when "11110" => o(30) <= i; 
                    when "11111" => o(31) <= i;
                    when others => o <= "00000000000000000000000000000000";
                end case;
           end process;
end demux_arch;
