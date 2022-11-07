----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/20/2021 08:55:14 PM
-- Design Name: Issue Unit
-- Module Name: issue_unit - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Command issuing unit
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

entity issue_unit is
    Port (  issue : in std_logic;
            fu_type : in std_logic_vector (1 downto 0); 
            if_fop : in std_logic_vector (1 downto 0);
            avail : in std_logic_vector (2 downto 0); 
            if_ri : in std_logic_vector (4 downto 0);
            if_rj : in std_logic_vector (4 downto 0);
            if_rk : in std_logic_vector (4 downto 0);
            tag_0 : in std_logic_vector (4 downto 0);
            tag_1 : in std_logic_vector (4 downto 0);
            tag_2 : in std_logic_vector (4 downto 0);
            accept : out std_logic;
            valid : out std_logic;
            fop : out std_logic_vector (1 downto 0);
            issue_rs : out std_logic_vector (2 downto 0);
            ri : out std_logic_vector (4 downto 0);
            rj : out std_logic_vector (4 downto 0);
            rk : out std_logic_vector (4 downto 0);
            tag_rf : out std_logic_vector (4 downto 0) );
end issue_unit;

architecture state_machine of issue_unit is

begin

	fop <= if_fop;
	ri <= if_ri;
	rj <= if_rj;
	rk <= if_rk;
	
    process(issue, avail, fu_type, tag_0, tag_1, tag_2)
    begin
        if issue = '1' then
            if avail(2) = '1' and fu_type = "00" then
                accept <= '1';
                valid <= '1';
                issue_rs <= "100";
                tag_rf <= tag_0;
            elsif avail(1) = '1' and fu_type = "01" then
                accept <= '1';
                valid <= '1';
                issue_rs <= "010";
                tag_rf <= tag_1;
            elsif avail(0) = '1' and fu_type(1) = '1' then
                accept <= '1';
                valid <= '1';
                issue_rs <= "001";
                tag_rf <= tag_2;
            else
                accept <= '0';
                valid <= '0';
                issue_rs <= "000";
                tag_rf <= "00000";
            end if;
        else
            accept <= '0';
            valid <= '0';
            issue_rs <= "000";
            tag_rf <= "00000";		
        end if;
    end process;

end state_machine;
