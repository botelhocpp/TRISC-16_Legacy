----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_cpu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Testbench for the 'cpu' module.
-- 
-- Dependencies: cpu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY tb_cpu IS
END tb_cpu;

ARCHITECTURE behaviour OF tb_cpu IS
    CONSTANT N : INTEGER := 16;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT cpu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        ROM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Input Signals
    SIGNAL ROM_in : word_t;
    SIGNAL RAM_in : word_t;
    
    -- Output Signals
    SIGNAL ROM_addr : word_t;
    SIGNAL RAM_out : word_t;
    SIGNAL RAM_addr : word_t;
    
    -- Control Signals
    SIGNAL RAM_we : STD_LOGIC;
    SIGNAL ROM_en : STD_LOGIC;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    CPU_COMP : cpu PORT MAP (
        ROM_in => ROM_in,
        RAM_in => RAM_in,
        clk => clk,
        rst => rst,
		RAM_we => RAM_we,
		ROM_en => ROM_en,
        ROM_addr => ROM_addr,
        RAM_addr => RAM_addr,
        RAM_out => RAM_out
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        ROM_in <= x"0000";
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD;
        
        rst <= '0';
        WAIT FOR CLK_PERIOD;
        
        -- MOV R2, 0x34  (MOV IMM)
        ROM_in <= "0001101000110100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- LDR R5, [R2] (LDR REG)
        RAM_in <= x"1000";
        ROM_in <= "0011010101000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- LDR R1, [R5] (LDR REG)
        RAM_in <= x"2000";
        ROM_in <= "0011000110100000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- NOP
        ROM_in <= "0000000000000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- MOV R3, R2 (MOV REG)
        ROM_in <= "0001001100100000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- ADD R6, R2, R5
        ROM_in <= "0100011001010100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- NOP
        ROM_in <= "0000000000000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- SUB R6, R6, R5
        ROM_in <= "0101011011010100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- STR [R6], 0x10 (LDR REG)
        ROM_in <= "0010100001110000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- STR [R3], R6 (LDR REG)
        ROM_in <= "0010000001111000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- HALT
        ROM_in <= "1111111111111111";
        WAIT FOR 2*CLK_PERIOD;
    END PROCESS;
    
END behaviour;
