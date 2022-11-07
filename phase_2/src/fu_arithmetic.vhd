----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/19/2021 08:04:36 PM
-- Design Name: FU - Arithmetic
-- Module Name: fu_arithmetic - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Functional Unit - Arithmetic Module
-- Dependencies: Register - 2 bit, Register - 5 bit, FU - Arithmetic Control FSM,
--               Arithmetic Unit
--
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fu_arithmetic is
    Port (  clk : in std_logic;
            grant : in std_logic;
            op : in std_logic_vector (1 downto 0);
            tag : in std_logic_vector (4 downto 0);
            val_0 : in std_logic_vector (31 downto 0);
            val_1 : in std_logic_vector (31 downto 0);
            ready : out std_logic;
            request : out std_logic;
            val_out : out std_logic_vector (31 downto 0);
            q : out std_logic_vector (4 downto 0) );
end fu_arithmetic;

architecture Behavioral of fu_arithmetic is

    component register_2bit is
        Port ( d 	  : in  std_logic_vector (1 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector (1 downto 0) );
    end component;
    
    component register_5bit is
        Port ( d 	  : in  std_logic_vector (4 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector (4 downto 0) );
    end component;
    
    component register_32bit is
        Port ( d 	  : in  std_logic_vector (31 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector (31 downto 0) );
    end component;
            
    component arithmetic_unit is
        Port ( in_0 : in std_logic_vector (31 downto 0);
               in_1 : in std_logic_vector (31 downto 0);
               op   : in std_logic_vector (1 downto 0);
               res  : out std_logic_vector (31 downto 0) );
    end component;
    
    component fu_arithmetic_control is
        Port ( grant : in std_logic;
               tag_low : in std_logic_vector (4 downto 0);
               tag_high : in std_logic_vector (4 downto 0);
               request : out std_logic;
               ready : out std_logic;
               stage_one_en : out std_logic;
               stage_two_en : out std_logic );
    end component;

    signal exec_0, exec_1, exec_out, res_temp : std_logic_vector (31 downto 0);
    signal op_exec : std_logic_vector (1 downto 0);
    signal q_tag, q_temp : std_logic_vector (4 downto 0);
    signal stage_1_en, stage_2_en : std_logic;
    
begin

    val_0_register : register_32bit
        port map ( d => val_0,
                   resetn => '0',
                   clock => clk,
                   wren => stage_1_en,
                   q => exec_0 );

    val_1_register : register_32bit
        port map ( d => val_1,
                   resetn => '0',
                   clock => clk,
                   wren => stage_1_en,
                   q => exec_1 );
                   
    op_register : register_2bit
        port map ( d => op,
                   resetn => '0',
                   clock => clk,
                   wren => stage_1_en,
                   q => op_exec );
                   
    tag_register : register_5bit
        port map ( d => tag,
                   resetn => '0',
                   clock => clk,
                   wren => stage_1_en,
                   q => q_tag );
                   
    exec_arithmetic : arithmetic_unit
        port map (  in_0 => exec_0,
                    in_1 => exec_1,
                    op => op_exec,
                    res => exec_out );                   

    res_pipeline : register_32bit
        port map ( d => exec_out,
                   resetn => '0',
                   clock => clk,
                   wren => stage_2_en,
                   q => res_temp );
                   
    tag_pipeline : register_5bit
        port map ( d => q_tag,
                   resetn => '0',
                   clock => clk,
                   wren => stage_2_en,
                   q => q_temp );

    res_register : register_32bit
        port map ( d => res_temp,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => val_out );
                   
    q_register : register_5bit
        port map ( d => q_temp,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => q );
                   
    control_fsm : fu_arithmetic_control
        port map ( grant => grant,
                   tag_low => q_tag,
                   tag_high =>  q_temp,
                   request => request,
                   ready => ready, 
                   stage_one_en => stage_1_en,
                   stage_two_en => stage_2_en );
                                                                                                                                                               
end Behavioral;
