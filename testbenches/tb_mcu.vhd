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
END tb_mcu;

ARCHITECTURE behaviour OF tb_mcu IS
    CONSTANT N : INTEGER := 16;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT mcu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL pin_port : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => 'Z');
    
BEGIN
    MCU_COMP : mcu PORT MAP (
        clk => clk,
        rst => rst,
        pin_port => pin_port
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD/2;
        
        rst <= '0';
        WAIT FOR 70*CLK_PERIOD;
    END PROCESS;
END behaviour;
