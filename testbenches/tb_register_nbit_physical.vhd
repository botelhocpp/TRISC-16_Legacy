----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_register_nbit_physical
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the 'register_nbit' module.
-- 
-- Dependencies: register_nbit
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_register_nbit_physical IS
GENERIC ( N : INTEGER := 16 );
PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
);
END tb_register_nbit_physical;

ARCHITECTURE behaviour OF tb_register_nbit_physical IS
    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL D : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL ld : STD_LOGIC;
    SIGNAL Q : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    
BEGIN
    REGISTER_COMP : register_nbit PORT MAP ( 
        D => D,
        ld => ld,
        clk => clk,
        rst => rst,
        Q => Q
    );
    
    D <= (0 => pin_port(4), OTHERS => '0');
    ld <= pin_port(5);
    pin_port(0) <= Q(0);
    
END behaviour;
