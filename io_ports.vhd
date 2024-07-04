----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: io_ports
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The input/output ports of the processor.
-- 
-- Dependencies: gpio, counter
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
        rst : IN STD_LOGIC;
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
        rst : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT counter IS
    GENERIC(
        N : INTEGER := 16
    );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SIGNAL gpio_en : STD_LOGIC;
    SIGNAL counter_en : STD_LOGIC;
    
    SIGNAL port_address : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL port_address_u : UNSIGNED(N - 1 DOWNTO 0) := (OTHERS => 'Z');
    
BEGIN    
    GPIO_COMP: gpio PORT MAP (
        din => din,
        addr => port_address,
        en => gpio_en,
        we => we,
        clk => clk,
        rst => rst,
        dout => dout,
        pin_port => pin_port
    ); 
    COUNTER_COMP: counter PORT MAP (
        din => din,
        addr => port_address,
        en => counter_en,
        we => we,
        clk => clk,
        rst => rst,
        dout => dout
    ); 
    
    port_address_u <= UNSIGNED(addr);
    
    gpio_en <= '1'      WHEN (port_address_u >= 0 AND port_address_u <= 5) ELSE '0';
    counter_en <= '1'   WHEN (port_address_u >= 6 AND port_address_u <= 11) ELSE '0';
    
    port_address <= STD_LOGIC_VECTOR(port_address_u)        WHEN (gpio_en = '1') ELSE
                    STD_LOGIC_VECTOR(port_address_u - 6)    WHEN (counter_en = '1');
    
END hardware;
