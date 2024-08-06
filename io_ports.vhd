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

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY io_ports IS
    GENERIC( N : INTEGER := kWORD_SIZE );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dout : OUT word_t;
        pin_port : INOUT word_t
    );
END io_ports;

ARCHITECTURE hardware OF io_ports IS
    COMPONENT gpio IS
    GENERIC(
        N : INTEGER := kWORD_SIZE
    );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dout : OUT word_t;
        pin_port : INOUT word_t
    );
    END COMPONENT;
    
    COMPONENT counter IS
    GENERIC(
        N : INTEGER := 16
    );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dout : OUT word_t
    );
    END COMPONENT;
    
    SIGNAL gpio_en : STD_LOGIC;
    SIGNAL counter_en : STD_LOGIC;
    
    SIGNAL port_address : word_t;
    SIGNAL port_address_u : UNSIGNED(N - 1 DOWNTO 0);
    
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
        
    PROCESS(en, rst, port_address_u)
    BEGIN
        IF(en = '0' OR rst = '1') THEN
            gpio_en <= '0';
            counter_en <= '0'; 
            port_address <= (OTHERS => '0');
        ELSIF(port_address_u < 6) THEN
            gpio_en <= '1';
            counter_en <= '0'; 
            port_address <= STD_LOGIC_VECTOR(port_address_u);
        ELSIF(port_address_u < 12) THEN
            gpio_en <= '0';
            counter_en <= '1'; 
            port_address <= STD_LOGIC_VECTOR(port_address_u - 6);
        ELSE
            gpio_en <= '0';
            counter_en <= '0';
            port_address <= (OTHERS => '0');
        END IF;
    END PROCESS;
    
END hardware;
