----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_alu_physical
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the 'alu' module.
-- 
-- Dependencies: alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_alu_physical IS
GENERIC ( N : INTEGER := 16 );
PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
);
END tb_alu_physical;

ARCHITECTURE behaviour OF tb_alu_physical IS
    COMPONENT alu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Z_flag : OUT STD_LOGIC;
        C_flag : OUT STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL A : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    
    SIGNAL op : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL Z_flag : STD_LOGIC;
    SIGNAL C_flag : STD_LOGIC;
    
    SIGNAL Q : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    
BEGIN
    ALU_COMP : alu PORT MAP ( 
        A => A,
        B => B,
        op => op,
        Z_flag => Z_flag,
        C_flag => C_flag,
        Q => Q
    );
    
    A <= (1 => pin_port(5), 0 => pin_port(4), OTHERS => '0');
    B <= (1 => pin_port(7), 0 => pin_port(6), OTHERS => '0');
    op <= (3 => pin_port(10), 2 => pin_port(9), 1 => pin_port(8), 0 => rst, OTHERS => '0');
    pin_port <= (3 => Q(3), 2 => Q(2), 1 => Q(1), 0 => Q(0), OTHERS => 'Z');
    
END behaviour;
