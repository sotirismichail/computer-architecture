----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/22/2021 12:20:15 PM
-- Design Name: Arithmetic RS Control FSM
-- Module Name: rs_arithmetic_control - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Control FSM of the Arithmetic RS Unit
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

entity rs_arithmetic_control is
    Port (  clk : in std_logic;
            issue_rs : in std_logic;
            ready_fu : in std_logic;
            ready_exec : in std_logic_vector (2 downto 0);
            line_busy : in std_logic_vector (2 downto 0);
            available : out std_logic;
            rs_line_sel : out std_logic_vector (1 downto 0);
            tag_rf : out std_logic_vector (4 downto 0);
            tag_fu : out std_logic_vector (4 downto 0);
            control_en : out std_logic_vector (2 downto 0);
            busy_en : out std_logic_vector (2 downto 0) );
end rs_arithmetic_control;

architecture state_machine of rs_arithmetic_control is

    type state is (rsl_a, rsl_b, rsl_c, rsl_0);
    signal current_state, next_state : state;
    
    signal busy_in_en, busy_out_en : std_logic_vector (2 downto 0);
    signal line_sel : std_logic_vector (1 downto 0);
    
begin
    command_entry : process(issue_rs, line_busy, busy_out_en)
    begin
    -- Command entered
        if issue_rs = '1' then
            -- Command in the first line of registers
                if line_busy(0) = '0' or busy_out_en(0) = '1' then
                    control_en <= "001";
                    busy_in_en <= "001";
                    tag_rf <= "01001";
            -- Command in the second line of registers
                elsif line_busy(1) = '0' or busy_out_en(1) = '1' then
                    control_en <= "010";
                    busy_in_en <= "010";
                    tag_rf <= "01010";
            -- Command in the third line of registers
                elsif line_busy(2) = '0' or busy_out_en(2) = '1' then
                    control_en <= "100";
                    busy_in_en <= "100";
                    tag_rf <= "01100";
            -- Latch condition - command is not in any register
                else
                    control_en <= "000";
                    busy_in_en <= "000";
                    tag_rf <= "00000";
                end if;
        -- No command entered
        else
            control_en <= "000";
            busy_in_en <= "000";
            tag_rf <= "00000";
        end if;
    end process;

    command_issue : process(ready_exec, ready_fu, current_state)
    begin
        if ready_fu = '1' then
            case ready_exec is
            when "100" =>   tag_fu <= "01100";
                            busy_out_en <= "100";
                            line_sel <= "10";
            when "010" =>   tag_fu <= "01010";
                            busy_out_en <= "010";
                            line_sel <= "01";
            when "001" =>   tag_fu <= "01001";
                            busy_out_en <= "001";
                            line_sel <= "00";
            --	Collision cases
            when "011" =>   if current_state = rsl_b then 
                                tag_fu <= "01001";
                                busy_out_en <= "001";
                                line_sel <= "00";		
                            else 					
                                tag_fu <= "01010";
                                busy_out_en <= "010";
                                line_sel <= "01";			
                            end if;
            when "101" =>   if current_state = rsl_a then 
                                tag_fu <= "01001";
                                busy_out_en <= "001";
                                line_sel <= "00";						
                            else 
                                tag_fu <= "01100";
                                busy_out_en <= "100";
                                line_sel <= "10";				
                            end if;
            when "110" =>   if current_state = rsl_a then 
                                tag_fu <= "01010";
                                busy_out_en <= "010";
                                line_sel <= "01";	
                            else 
                                tag_fu <= "01100";
                                busy_out_en <= "100";
                                line_sel <= "10";		
                            end if;
            when "111" =>   if current_state = rsl_a then 
                                tag_fu <= "01010";
                                busy_out_en <= "010";
                                line_sel <= "01";	
                            elsif current_state = rsl_b then
                                tag_fu <= "01001";
                                busy_out_en <= "001";
                                line_sel <= "00";			
                            else 
                                tag_fu <= "01100";
                                busy_out_en <= "100";
                                line_sel <= "10";
                            end if;
            when others =>  tag_fu <= "00000";
                            busy_out_en <= "000";
                            line_sel <= "11";
            end case;	
        -- FU not ready
        else
            line_sel <= "11";
            tag_fu <= "00000";
            busy_out_en <= "000";
        end if;
    end process;

	-- FU Send memory
	roundrobin : process (current_state, line_sel, clk)
	begin
		if  line_sel = "00" then
            next_state <= rsl_c;
		elsif line_sel = "01" then
			next_state <= rsl_b;
		elsif line_sel = "10" then
			next_state <= rsl_a;
		else 
			next_state <= rsl_0;
		end if;
	end process;
	
    synchro : process (clk)
    begin
        if (rising_edge(clk)) then 
            current_state <= next_state;
        end if;
    end process;
	
end state_machine;
