----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/26/2021 12:50:09 PM
-- Design Name: Tomasulo Backend
-- Module Name: tomasulo_backend - Structural
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: Top-level module of the implemented
--              Tomasulo algorithm individual units 
--
-- Dependencies: Issue Unit, Register File, Functional Unit
--               (Logical & Arithmetic), Reservation Stations
--               (Logical & Arithmetic), Common Data Bus
-- 
-- Revision: R1
-- Revision 0.01 - File Created
-- Additional Comments: -
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tomasulo_backend is
    Port (  clk : in std_logic;
            issue : in std_logic;
            fu_type : in std_logic_vector (1 downto 0);
            if_fop : in std_logic_vector (1 downto 0);
            if_ri : in std_logic_vector (4 downto 0);
            if_rj : in std_logic_vector (4 downto 0);
            if_rk : in std_logic_vector (4 downto 0);
            accepted : out std_logic );
end tomasulo_backend;

architecture Structural of tomasulo_backend is

    component issue_unit is
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
    end component;
    
    component register_file is
        Port (  clk : in std_logic;
                valid : in std_logic; 
                tag : in std_logic_vector (4 downto 0); 
                ri : in std_logic_vector (4 downto 0);
                rj : in std_logic_vector (4 downto 0); 
                rk : in std_logic_vector (4 downto 0); 
                cdb : in std_logic_vector (37 downto 0);
                vj : out std_logic_vector (31 downto 0);
                vk : out std_logic_vector (31 downto 0);
                qj : out std_logic_vector (4 downto 0); 
                qk : out std_logic_vector (4 downto 0)  );
    end component;

    component rsu_logical is
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
    end component;

    component rsu_arithmetic is
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
    end component;

    component fu_logical is
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
    end component;

    component fu_arithmetic is
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
    end component;
    
    component cdb_unit is
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
    end component;

-- Wires for IU
signal instruction_valid : std_logic;
signal available, issue_to_rs : std_logic_vector (2 downto 0) := "000";
signal fop : std_logic_vector (1 downto 0);
signal ri, rj, rk, tag_lo, tag_ar, tag_rf : std_logic_vector (4 downto 0);
signal tag_0 : std_logic_vector (4 downto 0) := "00000";

-- Wires for RS & RF
signal fua_ready, ful_ready : std_logic;
signal fop_ar, fop_lo : std_logic_vector (1 downto 0);
signal qj, qk, tag_fu_ar, tag_fu_lo : std_logic_vector (4 downto 0);
signal vj, vk, vj_ar, vk_ar, vj_lo, vk_lo : std_logic_vector (31 downto 0); 

-- Wires for CDB
signal cdb : std_logic_vector (37 downto 0);
signal grant, request : std_logic_vector (2 downto 0) := "000";
signal q_lo, q_ar, q_0 : std_logic_vector (4 downto 0);
signal val_lo, val_ar, val_0 : std_logic_vector (31 downto 0);

begin

instance_issue_unit : issue_unit
    port map (  issue => issue,
                fu_type => fu_type,
                if_fop => if_fop,
                avail => available,
                if_ri => if_ri,
                if_rj => if_rj,
                if_rk => if_rk,
                tag_0 => tag_lo,
                tag_1 => tag_ar,
                tag_2 => tag_0,
                accept => accepted,
                valid => instruction_valid,
                fop => fop,
                issue_rs => issue_to_rs,
                ri => ri,
                rj => rj,
                rk => rk,
                tag_rf => tag_rf );
                
instance_rf : register_file
    port map (  clk => clk,
                valid => instruction_valid,
                tag => tag_rf,
                ri => ri,
                rj => rj,
                rk => rk,                
                cdb => cdb,
                vj => vj,
                vk => vk,
                qj => qj,
                qk => qk );
                
instance_rsu_ar : rsu_arithmetic
    port map (  clk => clk,
                ready_fu => fua_ready,
                ready_issue => issue_to_rs (1),
                cdb => cdb,
                fop_in => fop,
                rf_vj => vj,
                rf_vk => vk,
                rf_qj => qj,
                rf_qk => qk,
                available => available (1),
                vj_out => vj_ar,
                vk_out => vk_ar,
                fop_out => fop_ar,
                tag_rf => tag_ar,
                tag_fu => tag_fu_ar );
                
instance_fu_ar : fu_arithmetic
    port map (  clk => clk,
                grant => grant (1),
                op => fop_ar,
                tag => tag_fu_ar,
                val_0 => vj_ar,
                val_1 => vk_ar,
                ready => fua_ready,
                request => request (1),
                val_out => val_ar,
                q => q_ar);                

instance_rsu_lo : rsu_logical
    port map (  clk => clk,
                ready_fu => ful_ready,
                ready_issue => issue_to_rs (2),
                cdb => cdb,
                fop_in => fop,
                rf_vj => vj,
                rf_vk => vk,
                rf_qj => qj,
                rf_qk => qk,
                available => available (2),
                vj_out => vj_lo,
                vk_out => vk_lo,
                fop_out => fop_lo,
                tag_rf => tag_lo,
                tag_fu => tag_fu_lo );
                
instance_fu_lo : fu_logical
    port map (  clk => clk,
                grant => grant (2),
                op => fop_lo,
                tag => tag_fu_lo,
                val_0 => vj_lo,
                val_1 => vk_lo,
                ready => ful_ready,
                request => request (2),
                val_out => val_lo,
                q => q_lo);                                      

cdbus : cdb_unit
    port map (  clk => clk,
                rq => request,
                val_0 => val_lo,
                val_1 => val_ar,
                val_2 => val_0,
                q_0 => q_lo,
                q_1 => q_ar,
                q_2 => q_0,
                cdb_out => cdb,
                grant => grant );
                
end Structural;
