----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/22/2021 12:40:19 PM
-- Design Name: Logical RS Control FSM
-- Module Name: rs_logical_control - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Control FSM of the Logical RS Unit
-- 
-- Dependencies: -
-- 
-- Revision: R2
-- Version: 0.02
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rs_logical_control is
    Port (  clk : in std_logic;
            issue_rs : in std_logic;
            ready_fu : in std_logic;
            cdb_valid : in std_logic;
            cdb_q : in std_logic_vector (4 downto 0);            
            ready_exec : in std_logic_vector (1 downto 0);
            line_busy : in std_logic_vector (1 downto 0);
            available : out std_logic;
            rs_line_sel : out std_logic_vector (1 downto 0);
            tag_rf : out std_logic_vector (4 downto 0);
            tag_fu : out std_logic_vector (4 downto 0);
            control_en : out std_logic_vector (1 downto 0);
            busy_en : out std_logic_vector (1 downto 0);
            en_active : out std_logic_vector (1 downto 0)  );
end rs_logical_control;

architecture state_machine of rs_logical_control is

    type state is (rsl_a, rsl_b, rsl_c, rsl_0);
    signal current_state, next_state : state;
    
    signal en_active_out, control_en_out, busy_in_en, busy_out_en, line_sel : std_logic_vector (1 downto 0);
    
begin

    -- Select the command to be executed
    rs_line_sel <= line_sel;
    -- Signal for resource availability
    available <= '0' when line_busy = "11" and busy_out_en = "00" else '1';
    -- Busy register enable flag. Raised whenever a new command is input or erased.
    busy_en <= busy_in_en or busy_out_en;
    -- Active command flag. Raised whenever a command is sent for execution or is erased.
    en_active <= en_active_out or control_en_out;
    -- Register enable flag. Raised when a command is erased.
    control_en <= control_en_out;
    
    command_entry : process(issue_rs, line_busy, busy_out_en)
	begin
		-- Command entered
		if issue_rs = '1' then
			-- Command in the first line of registers
			if line_busy(0) = '0' or busy_out_en(0) = '1' then
				control_en_out <= "01";
				busy_in_en <= "01";
				tag_rf <= "00001";
			-- Command in the secibd line of registers
			elsif line_busy(1) = '0' or busy_out_en(1) = '1' then
				control_en_out <= "10";
				busy_in_en <= "10";
				tag_rf <= "00010";
			-- Latch condition - command is not in any register
			else
				control_en_out <= "00";
				busy_in_en <= "00";
				tag_rf <= "00000";
			end if;
		-- No command entered
		else
			control_en_out <= "00";
			busy_in_en <= "00";
			tag_rf <= "00000";
		end if;
	end process;
	
    command_issue : process(ready_exec, ready_fu, current_state)
    begin
        if ready_fu = '1' then
            case ready_exec is
            -- No collisions
            when "10" =>    tag_fu <= "00010";
                            en_active_out <= "10";
                            line_sel <= "01";
            when "01" =>    tag_fu <= "00001";
                            en_active_out <= "01";
                            line_sel <= "00";
            --	Collision cases	
            when "11" =>    if current_state = rsl_b then 
                                tag_fu <= "00001";
                                en_active_out <= "01";
                                line_sel <= "00";		
                            else 					
                                tag_fu <= "00010";
                                en_active_out <= "10";
                                line_sel <= "01";			
                            end if;
            when others =>  tag_fu <= "00000";
                            en_active_out <= "00";
                            line_sel <= "11";
            end case;	
        -- FU not ready
        else
            line_sel <= "10";
            tag_fu <= "00000";
            en_active_out <= "00";
        end if;
    end process;	

    -- Erases the command after it resolves
    erase_command : process (cdb_valid, cdb_q)
    begin
        if cdb_valid = '1' then
            if cdb_q = "00010" then
                busy_out_en <= "10";
            elsif cdb_q = "00001" then
                busy_out_en <= "01";
            else
                busy_out_en <= "00";
            end if;
        else
            busy_out_en <= "00";
        end if;
    end process;
    
	-- FU Send memory
	roundrobin : process (current_state, line_sel, clk)
	begin
		if  line_sel = "00" then
            next_state <= rsl_c;
		elsif line_sel = "01" then
			next_state <= rsl_b;
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
