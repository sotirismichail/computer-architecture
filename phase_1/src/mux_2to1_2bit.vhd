----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 08:06:30 PM
-- Design Name: 
-- Module Name: mux_2to1_2bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Version: 0.01
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1_2bit is
    Port ( sel : in std_logic;
           in_0: in std_logic_vector (1 downto 0);
           in_1: in std_logic_vector (1 downto 0); 
           dout: out std_logic_vector (1 downto 0) );
end mux_2to1_2bit;

architecture Behavioral of mux_2to1_2bit is

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
