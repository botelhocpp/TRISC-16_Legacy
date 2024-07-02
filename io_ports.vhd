----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: io_ports
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The input/output ports of the processor.
-- 
-- Dependencies: gpio
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY io_ports IS
    GENERIC(
        N : INTEGER := 16
    );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END io_ports;

ARCHITECTURE hardware OF io_ports IS

    COMPONENT gpio IS
    GENERIC(
        N : INTEGER := 16
    );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL gpio_en : STD_LOGIC;
    SIGNAL port_address : UNSIGNED(N - 1 DOWNTO 0);
    
BEGIN    
    GPIO_COMP: gpio PORT MAP (
        din => din,
        addr => addr,
        en => gpio_en,
        we => we,
        clk => clk,
        dout => dout,
        pin_port => pin_port
    ); 
    
    port_address <= UNSIGNED(addr);
    
    gpio_en <= '1' WHEN (port_address >= 0 AND port_address <= 2) ELSE '0';
END hardware;
