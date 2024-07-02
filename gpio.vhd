----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: gpio
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The I/O pin controller of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY gpio IS
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
END gpio;

ARCHITECTURE hardware OF gpio IS
    CONSTANT DATADIR_off : INTEGER := 0;
    CONSTANT DATAOUT_off : INTEGER := 1;
    CONSTANT DATAIN_off : INTEGER := 2;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    TYPE gpio_array_t IS ARRAY (0 TO 2) OF word_t;
    
    SIGNAL gpio_registers : gpio_array_t := (OTHERS => (OTHERS => '0'));
    
    SIGNAL register_address : INTEGER;
    
    ALIAS DATADIR_reg : word_t IS gpio_registers(DATADIR_off);
    ALIAS DATAOUT_reg : word_t IS gpio_registers(DATAOUT_off); 
    ALIAS DATAIN_reg : word_t IS gpio_registers(DATAIN_off);
BEGIN    
    register_address <= TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)));
    
    -- Register interface (CPU <-> Controller)
    PROCESS(clk, we, en)
    BEGIN
        IF(rst = '1') THEN
            gpio_registers <= (OTHERS => (OTHERS => '0'));
            dout <= (OTHERS => 'Z');
        
        ELSIF(en = '1') THEN
            IF(RISING_EDGE(clk)) THEN
                IF(we = '1' AND register_address /= DATAIN_off) THEN
                    gpio_registers(register_address) <= din;
                    dout <= (OTHERS => 'Z');
                ELSE
                    dout <= gpio_registers(register_address);
                END IF;
            END IF;
        ELSE
            dout <= (OTHERS => 'Z');  
        END IF;
    END PROCESS;
    
    -- Pin interface (Controller <-> Pin)
    PROCESS(pin_port)
    BEGIN
        gpio_port: FOR i IN 0 TO N - 1 LOOP
            IF(DATADIR_reg(i) = '1') THEN
                pin_port(i) <= DATAOUT_reg(i);
                DATAIN_reg(i) <= 'Z';
            ELSE
                DATAIN_reg(i) <= pin_port(i);
            END IF;
        END LOOP;
    END PROCESS;
    
END hardware;