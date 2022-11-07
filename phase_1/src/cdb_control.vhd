----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 08:54:47 PM
-- Design Name: CDB Control
-- Module Name: cdb_control - state_machine
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: A finite state machine controlling the CDB unit
-- Dependencies: -
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cdb_control is
    Port ( clk : in std_logic;
           request : in std_logic_vector (2 downto 0);
           cdb_valid : out std_logic;
           sel : out std_logic_vector (1 downto 0); 
           grant : out std_logic_vector (2 downto 0) );
end cdb_control;

architecture state_machine of cdb_control is

    signal signal_grant : std_logic_vector (2 downto 0);
    
    type state is (grant_a, grant_b, grant_c, grant_0);
    signal current_state, next_state : state;

begin

    control : process ( request, current_state)
        begin
            case request is
                when "100" => sel <= "00";
                              signal_grant <= "100";
                              cdb_valid <= '1';
                when "010" => sel <= "01";
                              signal_grant <= "010";
                              cdb_valid <= '1';
                when "001" => sel <= "10";
                              signal_grant <= "001";
                              cdb_valid <= '1';
                              
                when "011" =>
                    if current_state = grant_b then
                        sel <= "10";
                        signal_grant <= "001";
                        cdb_valid <= '1';
                    else
                        sel <= "01";
                        signal_grant <= "010";
                        cdb_valid <= '1';
                    end if;
                when "101" =>
                    if current_state = grant_a then
                        sel <= "10";
                        signal_grant <= "001";
                        cdb_valid <= '1';
                    else
                        sel <= "00";
                        signal_grant <= "100";
                        cdb_valid <= '1';
                    end if;
                when "110" =>
                    if current_state = grant_a then
                        sel <= "01";
                        signal_grant <= "010";
                        cdb_valid <= '1';
                    else
                        sel <= "00";
                        signal_grant <= "100";
                        cdb_valid <= '1';
                    end if;
                when "111" =>
                    if current_state = grant_a then
                        sel <= "01";
                        signal_grant <= "010";
                        cdb_valid <= '1';
                    elsif current_state = grant_b then
                        sel <= "10";
                        signal_grant <= "001";
                        cdb_valid <= '1';                        
                    else
                        sel <= "00";
                        signal_grant <= "100";
                        cdb_valid <= '1';
                    end if;
                when others =>
                        sel <= "11";
                        signal_grant <= "000";
                        cdb_valid <= '0';
                end case;
        end process;
        
    memory_roundrobin : process (current_state, signal_grant)
        begin
            if signal_grant = "100" then 
                next_state <= grant_a;
            elsif signal_grant = "010" then 
                next_state <= grant_b;
            elsif signal_grant = "001" then 
                next_state <= grant_c;
            else
                next_state <= grant_0;
            end if;
        end process;

    fsm_clock : process (clk)
        begin
            if (rising_edge(clk)) then
                current_state <= next_state;
            end if;
        end process;
        
    grant <= signal_grant;
    
end state_machine;
