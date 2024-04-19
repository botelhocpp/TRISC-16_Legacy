----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: mcu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Complete MCU module.
-- 
-- Dependencies: cpu, ram, rom
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY mcu IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC
    );
END mcu;

ARCHITECTURE behaviour OF mcu IS
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
    
    COMPONENT rom IS
    GENERIC( N : INTEGER := N );
    PORT (
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT ram IS
    GENERIC( N : INTEGER := N );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
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
    
    RAM_COMP : ram PORT MAP (
        din => RAM_out,
        addr => RAM_addr,
        we => RAM_we,
        clk => clk,
        dout => RAM_in
    );
    
    ROM_COMP : rom PORT MAP (
        addr => ROM_addr,
        en => ROM_en,
        clk => clk,
        dout => ROM_in
    );
    
END behaviour;
