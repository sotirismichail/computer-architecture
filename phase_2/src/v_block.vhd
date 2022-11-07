----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/18/2021 06:33:02 PM
-- Design Name: V Block
-- Module Name: v_block - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Shares the result of the aglorithm to the rest
--              of the design.
-- Dependencies: Register - 32 bit, Multiplexer - 32 to 1, 32 bit
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.array_32bit.all;

entity v_block is
    Port ( clk     : in std_logic;
           wren_v  : in std_logic_vector (31 downto 0);
           cdb_val : in std_logic_vector (31 downto 0); 
           rj      : in std_logic_vector (4 downto 0);
           rk      : in std_logic_vector (4 downto 0);
           vj      : out std_logic_vector (31 downto 0);
           vk      : out std_logic_vector (31 downto 0) );
end v_block;

architecture Structural of v_block is

    component mux_2to1_32bit is
        Port ( sel : in std_logic;
               in_0: in std_logic_vector (31 downto 0);
               in_1: in std_logic_vector (31 downto 0); 
               dout: out std_logic_vector (31 downto 0) );
    end component;

    component mux_32to1_32bit is
        Port ( sel      : in std_logic_vector (4 downto 0);
               data_in  : in array_32bit; 
               data_out : out std_logic_vector (31 downto 0) );
    end component;
    
    component register_32bit is
        Port ( d 	  : in  std_logic_vector(31 downto 0);
               resetn : in  std_logic;
               clock  : in  std_logic;
               wren   : in  std_logic;
               q      : out std_logic_vector(31 downto 0) );
    end component;

    signal v_reg_out, v_reg_nofw : array_32bit;
    
begin
    
    gen : for i in 0 to 31 generate
        
        v_reg : register_32bit
            port map ( d      => cdb_val,
                       resetn => '0',
                       wren   => wren_v(i),
                       clock  => clk,
                       q      => v_reg_nofw(i) );
                       
        mux_fw : mux_2to1_32bit
            port map ( sel  => wren_v(i),
                       in_0 => v_reg_nofw(i),
                       in_1 => cdb_val,
                       dout => v_reg_out(i) );
                        
    end generate gen;
    
    mux_j : mux_32to1_32bit
            port map ( sel      => rj,
                       data_in  => v_reg_out,
                       data_out => vj );
                       
    mux_k : mux_32to1_32bit
            port map ( sel      => rk,
                       data_in  => v_reg_out,
                       data_out => vk );      
                                    
end Structural;
