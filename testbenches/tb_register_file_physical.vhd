----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_register_file_physical
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the 'register_file' module.
-- 
-- Dependencies: register_file
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_register_file_physical IS
GENERIC ( N : INTEGER := 16 );
PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
);
END tb_register_file_physical;

ARCHITECTURE behaviour OF tb_register_file_physical IS
    COMPONENT register_file IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        Rd : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Rm : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rn : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL Rd : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL Rm : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL Rn : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    
    SIGNAL Rd_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    SIGNAL Rd_wr : STD_LOGIC;
    
BEGIN
    REGISTER_FILE_COMP : register_file PORT MAP ( 
        Rd => Rd,
        Rm => Rm,
        Rn => Rn,
        
        Rd_sel => Rd_sel,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        
        Rd_wr => Rd_wr,
        
        clk => clk,
        rst => rst
    );
    
    Rd <= (0 => pin_port(7), OTHERS => '0');
    Rd_sel <= (0 => pin_port(6), OTHERS => '0');
    Rm_sel <= (0 => pin_port(5), OTHERS => '0');
    Rn_sel <= (0 => pin_port(4), OTHERS => '0');
    Rd_wr <= pin_port(8);
    
    pin_port(1) <= Rm(0);
    pin_port(0) <= Rn(0);
    
END behaviour;
