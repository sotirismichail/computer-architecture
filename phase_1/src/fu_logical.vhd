----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/19/2021 09:11:45 PM
-- Design Name: Logical Functional Unit
-- Module Name: fu_logical - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Logical FU of the Tomasulo backend
-- 
-- Dependencies: Register - 2 bit, Register - 5 bit, Register - 32 bit,
--               Logical Operations Unit, Logical FU Control FSM 
--              
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fu_logical is
    Port (  clk : in std_logic;
            grant : in std_logic;
            val_0 : in std_logic_vector (31 downto 0);
            val_1 : in std_logic_vector (31 downto 0);
            tag : in std_logic_vector (4 downto 0);
            op : in std_logic_vector (1 downto 0);
            ready : out std_logic;
            request : out std_logic;
            val_out : out std_logic_vector (31 downto 0);
            q : out std_logic_vector (4 downto 0)   );
end fu_logical;

architecture Behavioral of fu_logical is

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
    
    component fu_logical_control is
        Port (  grant : in std_logic;
                tag : in std_logic_vector (4 downto 0);
                request : out std_logic;
                ready : out std_logic;
                stage_1_en : out std_logic );
    end component;

    component logical_unit is
        Port (  in_0 : in std_logic_vector (31 downto 0);
                in_1 : in std_logic_vector (31 downto 0);
                op : in std_logic_vector (1 downto 0);
                res : out std_logic_vector (31 downto 0) );
    end component;
    
    signal exec_0, exec_1, exec_out : std_logic_vector (31 downto 0);
    signal op_exec : std_logic_vector (1 downto 0);
    signal q_tag : std_logic_vector (4 downto 0);
    signal stage_1_en : std_logic;
    
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
                   
    exec_logical : logical_unit
        port map (  in_0 => exec_0,
                    in_1 => exec_1,
                    op => op_exec,
                    res => exec_out );                   

    res_register : register_32bit
        port map ( d => exec_out,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => val_out );
                   
    q_register : register_5bit
        port map ( d => q_tag,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => q );    

    control_fsm : fu_logical_control
        port map ( grant => grant,
                   tag => q_tag,
                   request => request,
                   ready => ready, 
                   stage_1_en => stage_1_en );
                   
end Behavioral;
