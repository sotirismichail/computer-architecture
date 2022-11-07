----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 08:28:09 PM
-- Design Name: Q Block
-- Module Name: q_block - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: -
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

library work;
use work.array_5bit.all;

entity q_block is
    Port ( clk : in std_logic;
           instruction_valid : in std_logic;
           cdb_valid : in std_logic;
           cdb_q : in std_logic_vector (4 downto 0);
           ri  : in std_logic_vector (4 downto 0);
           rj  : in std_logic_vector (4 downto 0);
           rk  : in std_logic_vector (4 downto 0);
           tag : in std_logic_vector (4 downto 0);
           qj  : out std_logic_vector (4 downto 0);
           qk  : out std_logic_vector (4 downto 0);
           wren_val : out std_logic_vector (31 downto 0) );
end q_block;

architecture Structural of q_block is

    component mux_32to1_5bit is
        Port ( sel      : in std_logic_vector (4 downto 0);
               data_in  : in array_5bit; 
               data_out : out std_logic_vector (4 downto 0) );
    end component;

    component demuxer_1to32 is
        Port ( i : in std_logic; 
               o : out std_logic_vector (31 downto 0); 
               sel : in std_logic_vector (4 downto 0) );
    end component;
    
    component mux_2to1_5bit is
        Port ( sel : in std_logic;
               in_0: in std_logic_vector (4 downto 0);
               in_1: in std_logic_vector (4 downto 0); 
               dout: out std_logic_vector (4 downto 0) );
    end component;
    
    component register_5bit is
        Port ( d 	  : in  std_logic_vector(4 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector(4 downto 0) );
    end component;
    
    signal demux_out, reg_en, cmp_out : std_logic_vector (31 downto 0);
    signal q_reg_in, q_reg_out, q_reg_nofw : array_5bit;
     
begin

    gen : for i in 0 to 31 generate
    
    mux_q_in : mux_2to1_5bit
        port map ( sel  => demux_out(i),
                   in_0 => "00000",
                   in_1 => tag,
                   dout => q_reg_in(i) );
    
    q_reg : register_5bit
        port map ( d      => q_reg_in(i),
                   resetn => '0',
                   wren   => reg_en(i),
                   clock  => clk,
                   q      => q_reg_nofw(i) );
      
    cmp_out(i) <= 
                (q_reg_nofw(i)(0) xnor cdb_q(0)) and
                (q_reg_nofw(i)(1) xnor cdb_q(1)) and
                (q_reg_nofw(i)(2) xnor cdb_q(2)) and
                (q_reg_nofw(i)(3) xnor cdb_q(3)) and
                (q_reg_nofw(i)(4) xnor cdb_q(4)) 
                when cdb_valid = '1' else '0';
                        
    mux_fw : mux_2to1_5bit
        port map ( sel  => cmp_out(i),
                   in_0 => q_reg_nofw(i),
                   in_1 => q_reg_in(i),
                   dout => q_reg_out(i) );
                   
   end generate gen;

    demux_q : demuxer_1to32
            port map ( i => instruction_valid,
                       o => demux_out,
                       sel => ri );
                       
    mux_j : mux_32to1_5bit
            port map ( sel      => rj,
                       data_in  => q_reg_out,
                       data_out => qj );
                       
    mux_k : mux_32to1_5bit
            port map ( sel      => rk,
                       data_in  => q_reg_out,
                       data_out => qk );    
                                          
end Structural;
