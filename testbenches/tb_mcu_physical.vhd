----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_mcu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the 'mcu' module.
-- 
-- Dependencies: mcu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_mcu IS
GENERIC ( N : INTEGER := 16 );
PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
);
END tb_mcu;

ARCHITECTURE behaviour OF tb_mcu IS
    COMPONENT mcu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
BEGIN
    MCU_COMP : mcu PORT MAP (
        clk => clk,
        rst => rst,
        pin_port => pin_port
    );
    
END behaviour;
	