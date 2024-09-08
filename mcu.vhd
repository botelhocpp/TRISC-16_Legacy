----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: mcu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Complete MCU module.
-- 
-- Dependencies: cpu, ram, rom
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY mcu IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pin_port : INOUT word_t
    );
END mcu;

ARCHITECTURE behaviour OF mcu IS
    
    COMPONENT cpu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        ROM_in : IN word_t;
        RAM_in : IN word_t;
        IO_in : IN word_t;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        ROM_addr : OUT word_t;
        DATA_addr : OUT word_t;
        DATA_out : OUT word_t
    );
    END COMPONENT;
    
    COMPONENT rom IS
    GENERIC(
        N : INTEGER := N;
        Q : INTEGER := kADDR_NUM
    );
    PORT (
        addr : IN word_t;
        en : IN STD_LOGIC;
        dout : OUT word_t
    );
    END COMPONENT;

    COMPONENT ram IS
    GENERIC(
        N : INTEGER := N;
        Q : INTEGER := kADDR_NUM
    );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT word_t
    );
    END COMPONENT;

    COMPONENT io_ports IS
    GENERIC(
        N : INTEGER := 16
    );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dout : OUT word_t;
        pin_port : INOUT word_t
    );
    END COMPONENT;
    
    -- Input Signals
    SIGNAL ROM_in : word_t;
    SIGNAL RAM_in : word_t;
    SIGNAL IO_in : word_t;
    
    -- Output Signals
    SIGNAL ROM_addr : word_t;
    SIGNAL DATA_out : word_t;
    SIGNAL DATA_addr : word_t;
    
    -- Control Signals
    SIGNAL RAM_we : STD_LOGIC;
    SIGNAL IO_we : STD_LOGIC;
    SIGNAL ROM_en : STD_LOGIC;
    
BEGIN
    CPU_COMP : cpu PORT MAP (
        ROM_in => ROM_in,
        RAM_in => RAM_in,
        IO_in => IO_in,
        clk => clk,
        rst => rst,
		RAM_we => RAM_we,
		IO_we => IO_we,
		ROM_en => ROM_en,
        ROM_addr => ROM_addr,
        DATA_addr => DATA_addr,
        DATA_out => DATA_out
    );
    
    RAM_COMP : ram PORT MAP (
        din => DATA_out,
        addr => DATA_addr,
        we => RAM_we,
        clk => clk,
        dout => RAM_in
    );
    
    IO_COMP : io_ports PORT MAP (
        din => DATA_out,
        addr => DATA_addr,
        we => IO_we,
        clk => clk,
        rst => rst,
        dout => IO_in,
        pin_port => pin_port
    );
    
    ROM_COMP : rom PORT MAP (
        addr => ROM_addr,
        en => ROM_en,
        dout => ROM_in
    );
    
END behaviour;
