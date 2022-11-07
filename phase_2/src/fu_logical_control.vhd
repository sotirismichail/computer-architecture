----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/19/2021 08:57:46 PM
-- Design Name: Logical Functional Unit - Control FSM
-- Module Name: fu_logical_control - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: An FSM controlling the Logical FU of the Tomasulo backend
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

entity fu_logical_control is
    Port (  grant : in std_logic;
            tag : in std_logic_vector (4 downto 0);
            request : out std_logic;
            ready : out std_logic;
            stage_1_en : out std_logic );
end fu_logical_control;

architecture state_machine of fu_logical_control is

begin

	process (tag, grant)
        begin
            if not(tag = "00000") then
                request <= '1';
                if grant = '1' then
                    stage_1_en <= '1';
                    ready <= '1';
                elsif grant = '0' then
                    stage_1_en <= '0';
                    ready <= '0';
                end if;
            else
                stage_1_en <= '1';
                ready <= '1';
                request <= '0';
            end if;
	end process;

end state_machine;
