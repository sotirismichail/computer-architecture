----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/22/2021 02:02:54 PM
-- Design Name: Arithmetic RS Unit
-- Module Name: rsu_arithmetic - Behavioral
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Upper level arithmetic operations unit
--              of the RS block
--
-- Dependencies: Register Line, Arithmetic RS Unit Control FSM,
--                              Multiplexer, 4 to 1, 32 bit 
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rsu_arithmetic is
    Port (  clk : in std_logic;
            ready_fu : in std_logic;
            ready_issue : in std_logic;
            cdb : in std_logic_vector (37 downto 0); 
            fop_in : in std_logic_vector (1 downto 0);
            rf_vj : in std_logic_vector (31 downto 0);
            rf_vk : in std_logic_vector (31 downto 0);
            rf_qj : in std_logic_vector (4 downto 0);
            rf_qk : in std_logic_vector (4 downto 0);
            available : out std_logic;
            vj_out : out std_logic_vector (31 downto 0);
            vk_out : out std_logic_vector (31 downto 0);
            fop_out : out std_logic_vector (1 downto 0);
            tag_rf : out std_logic_vector (4 downto 0);
            tag_fu : out std_logic_vector (4 downto 0) );
end rsu_arithmetic;

architecture Structural of rsu_arithmetic is
    
    component register_line is
        Port (  clk : in std_logic;
                control_en : in std_logic;
                busy_en : in std_logic;
                cdb_valid : in std_logic;
                en_active : in std_logic;
                fop_in : in std_logic_vector (1 downto 0);
                rf_vj : in std_logic_vector (31 downto 0);
                rf_vk : in std_logic_vector (31 downto 0); 
                rf_qj : in std_logic_vector (4 downto 0);
                rf_qk : in std_logic_vector (4 downto 0);
                cdb_v : in std_logic_vector (31 downto 0);
                cdb_q : in std_logic_vector (4 downto 0);
                exec_ready : out std_logic;
                busy_out : out std_logic;
                vj_out : out std_logic_vector (31 downto 0);
                vk_out : out std_logic_vector (31 downto 0);
                fop_out : out std_logic_vector (1 downto 0) );
    end component;
    
    component rs_arithmetic_control is
        Port (  clk : in std_logic;
                issue_rs : in std_logic;
                ready_fu : in std_logic;
                cdb_valid : in std_logic;
                cdb_q : in std_logic_vector (4 downto 0);                
                ready_exec : in std_logic_vector (2 downto 0);
                line_busy : in std_logic_vector (2 downto 0);
                available : out std_logic;
                rs_line_sel : out std_logic_vector (1 downto 0);
                tag_rf : out std_logic_vector (4 downto 0);
                tag_fu : out std_logic_vector (4 downto 0);
                control_en : out std_logic_vector (2 downto 0);
                busy_en : out std_logic_vector (2 downto 0);
                en_active : out std_logic_vector (2 downto 0) );
    end component;
       
    component mux_4to1_32bit is
        Port ( sel : in std_logic_vector (1 downto 0);
               in_0: in std_logic_vector (31 downto 0);
               in_1: in std_logic_vector (31 downto 0);
               in_2: in std_logic_vector (31 downto 0);
               in_3: in std_logic_vector (31 downto 0);         
               dout: out std_logic_vector (31 downto 0) );
    end component;

    type triple32bit is array (0 to 2) of std_logic_vector (31 downto 0);
    signal vk_line_out, vj_line_out : triple32bit;
    
    type triple2bit is array (0 to 2) of std_logic_vector (1 downto 0);
    signal fop_line_out : triple2bit;
    
    signal en_active, control_en, exec_ready, busy_en, busy_out : std_logic_vector (2 downto 0);
    signal line_sel : std_logic_vector (1 downto 0);
    
begin

    gen : for i in 0 to 2 generate
        register_lines : register_line
            port map (  clk => clk,
                        control_en => control_en (i),
                        busy_en => busy_en (i),
                        cdb_valid => cdb (37),
                        en_active => en_active (i),
                        fop_in => fop_in,
                        rf_vj => rf_vj,
                        rf_vk => rf_vk,
                        rf_qj => rf_qj,
                        rf_qk => rf_qk,
                        cdb_v => cdb (31 downto 0),
                        cdb_q => cdb (36 downto 32),
                        exec_ready => exec_ready (i),
                        busy_out => busy_out (i),
                        vj_out => vj_line_out (i),
                        vk_out => vk_line_out (i),
                        fop_out => fop_line_out (i) );
    end generate;                    

    vj_mux : mux_4to1_32bit
        port map (  sel => line_sel,
                    in_0 => vj_line_out (0),
                    in_1 => vj_line_out (1),
                    in_2 => vj_line_out (2),
                    in_3 => "00000000000000000000000000000000",
                    dout => vj_out );

    vk_mux : mux_4to1_32bit
        port map (  sel => line_sel,
                    in_0 => vk_line_out (0),
                    in_1 => vk_line_out (1),
                    in_2 => vk_line_out (2),
                    in_3 => "00000000000000000000000000000000",
                    dout => vk_out );
                    
    fop_out <=  fop_line_out (0) when line_sel = "00" else
                fop_line_out (1) when line_sel = "01" else
                fop_line_out (2) when line_sel = "10" else
                "00";
                
    control_fsm : rs_arithmetic_control
        port map (  clk => clk,
                    issue_rs => ready_issue,
                    ready_fu => ready_fu,
                    cdb_valid => cdb (37),
                    cdb_q => cdb (36 downto 32),
                    ready_exec => exec_ready,
                    line_busy => busy_out,
                    available => available,
                    rs_line_sel => line_sel,
                    tag_rf => tag_rf,
                    tag_fu => tag_fu,
                    control_en => control_en,
                    busy_en => busy_en,
                    en_active => en_active );
                                                                             
end Structural;
