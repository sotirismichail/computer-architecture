----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 10:42:36 PM
-- Design Name: CDB Unit
-- Module Name: cdb_unit - Structural
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: The Common Data Bus unit of the Tomasulo backend
-- Dependencies: Register - 1 bit, Register - 2 bit, CDB Control FSM,
--               Multiplexer - 4 to 1 - 32 bit, Multiplexer - 4 to 1 - 5 bit
--
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cdb_unit is
    Port ( clk : in std_logic; 
           rq  : in std_logic_vector (2 downto 0); 
           val_0 : in std_logic_vector (31 downto 0); 
           val_1 : in std_logic_vector (31 downto 0); 
           val_2 : in std_logic_vector (31 downto 0); 
           q_0 : in std_logic_vector (4 downto 0); 
           q_1 : in std_logic_vector (4 downto 0); 
           q_2 : in std_logic_vector (4 downto 0);
           cdb_out : out std_logic_vector (37 downto 0);
           grant : out std_logic_vector (2 downto 0) );
end cdb_unit;

architecture Structural of cdb_unit is

    component mux_4to1_32bit is
        Port ( sel : in std_logic_vector (1 downto 0);
               in_0: in std_logic_vector (31 downto 0);
               in_1: in std_logic_vector (31 downto 0);
               in_2: in std_logic_vector (31 downto 0);
               in_3: in std_logic_vector (31 downto 0);         
               dout: out std_logic_vector (31 downto 0) );
    end component;
    
    component mux_4to1_5bit is
        Port ( sel : in std_logic_vector (1 downto 0);
               in_0: in std_logic_vector (4 downto 0);
               in_1: in std_logic_vector (4 downto 0);
               in_2: in std_logic_vector (4 downto 0);
               in_3: in std_logic_vector (4 downto 0);         
               dout: out std_logic_vector (4 downto 0) );
    end component;
    
    component register_1bit is
        Port ( d 	  : in  std_logic;
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic );
    end component;
    
    component register_2bit is
        Port ( d 	  : in  std_logic_vector (1 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector (1 downto 0) );
    end component;
    
    component cdb_control is
        Port ( clk : in std_logic;
               request : in std_logic_vector (2 downto 0);
               cdb_valid : out std_logic;
               sel : out std_logic_vector (1 downto 0); 
               grant : out std_logic_vector (2 downto 0) );
    end component;  
    
    signal control_valid : std_logic;
    signal sel_before_reg, sel : std_logic_vector (1 downto 0);
    
begin

    cdb_ctrl : cdb_control
        port map ( clk => clk,
                   request => rq,
                   cdb_valid => control_valid,
                   sel => sel_before_reg,
                   grant => grant );
                   
    sel_register : register_2bit
        port map ( d => sel_before_reg,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => sel );
                   
    val_mux : mux_4to1_32bit
        port map ( sel  => sel,
                   in_0 => val_0,
                   in_1 => val_1,
                   in_2 => val_2,
                   in_3 => "00000000000000000000000000000000",
                   dout => cdb_out (31 downto 0) ); 

    q_mux : mux_4to1_5bit
        port map ( sel  => sel,
                   in_0 => q_0,
                   in_1 => q_1,
                   in_2 => q_2,
                   in_3 => "00000",
                   dout => cdb_out (36 downto 32) );
                   
    valid_register : register_1bit
        port map ( d => control_valid,
                   resetn => '0',
                   clock => clk,
                   wren => '1',
                   q => cdb_out (37) );
                   
end Structural;
