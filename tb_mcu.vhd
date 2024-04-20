----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_mcu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Testbench for the 'mcu' module.
-- 
-- Dependencies: mcu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

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
        rst : IN STD_LOGIC
    );
    END COMPONENT;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    MCU_COMP : mcu PORT MAP (
        clk => clk,
        rst => rst
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD/2;
        
        rst <= '0';
        WAIT FOR 60*CLK_PERIOD;
    END PROCESS;
END behaviour;
