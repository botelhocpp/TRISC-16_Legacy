----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_prescaler
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the 'prescaler' module.
-- 
-- Dependencies: prescaler
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY tb_prescaler IS
END tb_prescaler;

ARCHITECTURE behaviour OF tb_prescaler IS
    CONSTANT N : INTEGER := 10;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT prescaler IS
    GENERIC( N : INTEGER := 4 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        divisor : IN STD_LOGIC_VECTOR( N - 1 DOWNTO 0 );
        output_clk : OUT STD_LOGIC
    );
    END COMPONENT;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL divisor : STD_LOGIC_VECTOR( N - 1 DOWNTO 0 );
    SIGNAL output_clk_div_1, output_clk_div_2, output_clk_div_4, output_clk_div_8, output_clk_div_16 : STD_LOGIC := '0';
    
BEGIN
    PS_COMP_DIV_1 : prescaler PORT MAP (
        clk => clk,
        rst => rst,
        divisor => "0000",
        output_clk => output_clk_div_1
    );
    PS_COMP_DIV_2 : prescaler PORT MAP (
        clk => clk,
        rst => rst,
        divisor => "0001",
        output_clk => output_clk_div_2
    );
    PS_COMP_DIV_4 : prescaler PORT MAP (
        clk => clk,
        rst => rst,
        divisor => "0010",
        output_clk => output_clk_div_4
    );
    PS_COMP_DIV_8 : prescaler PORT MAP (
        clk => clk,
        rst => rst,
        divisor => "0011",
        output_clk => output_clk_div_8
    );
    PS_COMP_DIV_16 : prescaler PORT MAP (
        clk => clk,
        rst => rst,
        divisor => "0100",
        output_clk => output_clk_div_16
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
