----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: gpio
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The I/O pin controller of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY gpio IS
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
        dout : OUT word_t;
        pin_port : INOUT word_t
    );
END gpio;

ARCHITECTURE hardware OF gpio IS
    CONSTANT DATADIR_off : INTEGER := 0;
    CONSTANT DATAOUT_off : INTEGER := 1;
    CONSTANT DATAIN_off : INTEGER := 2;
    
    TYPE gpio_array_t IS ARRAY (0 TO 2) OF word_t;
    
    SIGNAL gpio_registers : gpio_array_t;
    
    SIGNAL register_address : INTEGER;
    
    ALIAS DATADIR_reg : word_t IS gpio_registers(DATADIR_off);
    ALIAS DATAOUT_reg : word_t IS gpio_registers(DATAOUT_off); 
    ALIAS DATAIN_reg : word_t IS gpio_registers(DATAIN_off);
BEGIN    
    register_address <= TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)));
    
    -- User interface (CPU <-> Controller)
    PROCESS(clk, rst)
    BEGIN
        -- Reset State
        IF(rst = '1') THEN
            gpio_registers <= (
                DATADIR_off => (OTHERS => '0'),
                DATAOUT_off => (OTHERS => '0'),
                DATAIN_off => (OTHERS => 'Z')
            );
            dout <= (OTHERS => 'Z');
        
        ELSIF(RISING_EDGE(clk)) THEN
               
            input_pin_interface:
            FOR i IN 0 TO N - 1 LOOP
                DATAIN_reg(i) <= '1' WHEN (pin_port(i) = '1') ELSE '0';
            END LOOP;
             
            -- User Interface Enabled
            IF(en = '1') THEN
                IF(we = '1') THEN
                    dout <= (OTHERS => 'Z');
                                
                    IF(register_address /= DATAIN_off) THEN
                        gpio_registers(register_address) <= din;
                    END IF;
                ELSE
                    resd_register_interface:
                    FOR i IN 0 TO N - 1 LOOP
                        dout(i) <= '1' WHEN (gpio_registers(register_address)(i) = '1') ELSE '0';
                    END LOOP;
                END IF;
            ELSE
                dout <= (OTHERS => 'Z');
            END IF; 
        END IF;
    END PROCESS;
        
    -- Pin interface (Controller <-> Pin)
    PROCESS(rst, DATAOUT_reg, DATADIR_reg)
    BEGIN
        -- Reset State
        IF(rst = '1') THEN
            pin_port <= (OTHERS => 'Z');
        ELSE
            output_pin_interface:
            FOR i IN 0 TO N - 1 LOOP
                pin_port(i) <= DATAOUT_reg(i) WHEN (DATADIR_reg(i) = '1') ELSE 'Z';
                    
            END LOOP;
        END IF;
    END PROCESS;
    
END hardware;
