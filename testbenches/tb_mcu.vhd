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

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

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
        pin_port : INOUT word_t
    );
    END COMPONENT;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL pin_port : word_t := (OTHERS => 'Z');
    
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
        pin_port(4) <= '1';
        pin_port(5) <= '1';
        pin_port(6) <= '1';
        pin_port(7) <= '1';
        WAIT FOR 70*CLK_PERIOD;
    END PROCESS;
END behaviour;
