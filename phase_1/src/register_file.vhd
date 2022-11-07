----------------------------------------------------------------------------------
-- Company: Technical University of Crete
-- Engineer: S. Michail
-- 
-- Create Date: 04/20/2021 09:26:29 PM
-- Design Name: Register File
-- Module Name: register_file - Structural
-- Project Name: tomasulo_algorithm
-- Target Devices: ZedBoard
-- Tool Versions: Vivado 2020.2
-- Description: The Register File (RF) of the Tomasulo backend
--              combining the Q and V blocks of the design.
--
-- Dependencies: Q Block, V Block
-- 
-- Revision: R1
-- Version: 0.01
-- Additional Comments: - 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_file is
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
end register_file;

architecture Structural of register_file is

    component q_block is
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
    end component;
    
    component v_block is
        Port ( clk     : in std_logic;
               wren_v  : in std_logic_vector (31 downto 0);
               cdb_val : in std_logic_vector (31 downto 0); 
               rj      : in std_logic_vector (4 downto 0);
               rk      : in std_logic_vector (4 downto 0);
               vj      : out std_logic_vector (31 downto 0);
               vk      : out std_logic_vector (31 downto 0) );
    end component;
    
    signal wren_val : std_logic_vector (31 downto 0);
     
begin

    q_unit : q_block
        port map (  clk => clk,
                    instruction_valid => valid,
                    cdb_valid => cdb (37),
                    cdb_q => cdb (36 downto 32),
                    ri => ri,
                    rj => rj,
                    rk => rk,
                    tag => tag,
                    qj => qj,
                    qk => qk,
                    wren_val => wren_val );
                    
    v_unit : v_block
        port map (  clk => clk,
                    wren_v => wren_val,
                    cdb_val => cdb (31 downto 0),
                    rj => rj,
                    rk => rk,
                    vj => vj,
                    vk => vk );
                    
end Structural;
