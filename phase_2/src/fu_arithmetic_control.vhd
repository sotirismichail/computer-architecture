----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 11:08:21 PM
-- Design Name: Functional Unit - Arithmetic Control
-- Module Name: fu_arithmetic_control - Finite State Machine
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: The controlling FSM of the arithmetic portion of the
--              functional unit
-- Dependencies: -
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fu_arithmetic_control is
    Port ( grant : in std_logic;
           tag_low : in std_logic_vector (4 downto 0);
           tag_high : in std_logic_vector (4 downto 0);
           request : out std_logic;
           ready : out std_logic;
           stage_one_en : out std_logic;
           stage_two_en : out std_logic );
end fu_arithmetic_control;

architecture state_machine of fu_arithmetic_control is

begin

    process (tag_low, tag_high, grant)
        begin
            if not (tag_low = "00000") then
                if not (tag_high = "00000") then
                    request <= '1';
                    if grant = '1' then 
                        ready <= '1';
                        stage_one_en <= '1';
                        stage_two_en <= '1';
                    else
                        ready <= '0';
                        stage_one_en <= '0';
                        stage_two_en <= '0';
                    end if;
                else
                    request <= '0';
                    ready <= '1';
                    stage_one_en <= '1';
                    stage_two_en <= '1';
                end if;
            else
                if not (tag_high = "00000") then
                    request <= '1';
                    ready <= '1';
                    stage_one_en <= '1';
                        if grant = '1' then
                            stage_two_en <= '1';
                        else
                            stage_two_en <= '0';
                        end if;                    
                else
                    request <= '0';
                    ready <= '1';
                    stage_one_en <= '1';
                    stage_two_en <= '1';
                end if;
            end if;
    end process;
                                                                                                            
end state_machine;
