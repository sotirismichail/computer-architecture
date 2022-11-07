----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/22/2021 12:57:19 PM
-- Design Name: Register Line
-- Module Name: register_line - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2 
-- Description: A "register line", or otherwise, a "pipeline" stage
-- 
-- Dependencies: Register - 1 bit, Register 2 - bit, Register - 5 bit
--               Register - 32 bit, Multiplexer 2-to-1 32 bit,
--               Multiplexer 2-to-1 1 bit, Multiplexer 2-to-1 5 bit
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_line is
    Port (  clk : in std_logic;
            control_en : in std_logic;
            busy_en : in std_logic;
            cdb_valid : in std_logic;
            fop_in : in std_logic_vector (1 downto 0);
            rf_vj : in std_logic_vector (31 downto 0);
            rf_vk : in std_logic_vector (31 downto 0); 
            rf_qj : in std_logic_vector (4 downto 0);
            rf_qk : in std_logic_vector (4 downto 0);
            cdb_v : in std_logic_vector (31 downto 0);
            cdb_q : in std_logic_vector (4 downto 0);
            exec_ready : out std_logic;
            vj_out : out std_logic_vector (31 downto 0);
            vk_out : out std_logic_vector (31 downto 0);
            fop_out : out std_logic_vector (1 downto 0) );
end register_line;

architecture Structural of register_line is

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
    
    component mux_2to1_1bit is
        Port ( sel : in std_logic;
               in_0: in std_logic;
               in_1: in std_logic; 
               dout: out std_logic );
    end component;
 
     component mux_2to1_5bit is
        Port ( sel : in std_logic;
               in_0: in std_logic_vector (4 downto 0);
               in_1: in std_logic_vector (4 downto 0); 
               dout: out std_logic_vector (4 downto 0) );
    end component;
    
    component mux_2to1_32bit is
        Port ( sel : in std_logic;
               in_0: in std_logic_vector (31 downto 0);
               in_1: in std_logic_vector (31 downto 0); 
               dout: out std_logic_vector (31 downto 0) );
    end component;       

    signal busy_in, reg_busy_out, compare_j, compare_k, vj_wren, vk_wren : std_logic;
    signal qj_in, qk_in, qj, qk  : std_logic_vector (4 downto 0);
    signal vj_in, vk_in, vj_reg_out, vk_reg_out : std_logic_vector (31 downto 0);
        
begin

    busy_mux : mux_2to1_1bit
        port map (  sel => control_en,
                    in_0 => '0',
                    in_1 => '1',
                    dout => busy_in );

    busy_reg : register_1bit
        port map (  d => busy_in,
                    resetn => '0',
                    clock => clk,
                    wren => busy_en,
                    q => reg_busy_out );                    

    vj_mux : mux_2to1_32bit
        port map (  sel => compare_j,
                    in_0 => rf_vj,
                    in_1 => cdb_v,
                    dout => vj_in );

    vj_wren <= control_en or compare_j;
    
    vj_reg : register_32bit
        port map (  d => vj_in,
                    resetn => '0',
                    clock => clk,
                    wren => vj_wren,
                    q => vj_reg_out );
                    
    -- CDB forwarding                 
    vj_out <= vj_reg_out when compare_j = '0' else vj_in;
    
    vk_mux : mux_2to1_32bit
        port map (  sel => compare_k,
                    in_0 => rf_vk,
                    in_1 => cdb_v,
                    dout => vk_in );

    vk_wren <= control_en or compare_k;
    
    vk_reg : register_32bit
        port map (  d => vk_in,
                    resetn => '0',
                    clock => clk,
                    wren => vk_wren,
                    q => vk_reg_out );
                    
    -- CDB forwarding                 
    vk_out <= vk_reg_out when compare_k = '0' else vk_in;                
    
    qj_mux : mux_2to1_5bit
        port map (  sel => compare_j,
                    in_0 => rf_qj,
                    in_1 => "00000",
                    dout => qj_in );
    
    qj_reg : register_5bit
        port map (  d => qj_in,
                    resetn => '0',
                    clock => clk,
                    wren => vj_wren,
                    q => qj );

    qk_mux : mux_2to1_5bit
        port map (  sel => compare_k,
                    in_0 => rf_qk,
                    in_1 => "00000",
                    dout => qk_in );
    
    qk_reg : register_5bit
        port map (  d => qk_in,
                    resetn => '0',
                    clock => clk,
                    wren => vk_wren,
                    q => qk );  
    
    fop_reg_0 : register_1bit
        port map (  d => fop_in(0),
                    resetn => '0',
                    clock => clk,
                    wren => control_en,
                    q => fop_out(0) );

    fop_reg_1 : register_1bit
        port map (  d => fop_in(1),
                    resetn => '0',
                    clock => clk,
                    wren => control_en,
                    q => fop_out(1) );
                    
    compare_j <= '1' when cdb_valid = '1' and reg_busy_out = '1' and qj = cdb_q else '0';
    compare_k <= '1' when cdb_valid = '1' and reg_busy_out = '1' and qk = cdb_q else '0';                                                                                                        
    
    exec_ready <= '1' when reg_busy_out = '1' and (( qj = "00000" and qk = "00000" ) or
                                                   ( qj = "00000" and compare_k = '1') or
                                                   ( qk = "00000" and compare_j = '1') or
                                                   ( compare_j = '1' and compare_k = '1' ) )
                      else '0'; 
                      
end Structural;                                
