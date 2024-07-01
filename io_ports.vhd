----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: io_ports
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The input/output ports of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY io_ports IS
    GENERIC(
        N : INTEGER := 16;
        Q : INTEGER := 32768
    );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END io_ports;

ARCHITECTURE hardware OF io_ports IS
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    TYPE io_ports_array_t IS ARRAY (0 TO Q - 1) OF word_t;
    
    SIGNAL io_ports_contents : io_ports_array_t := (OTHERS => (OTHERS => '0'));
BEGIN    
    PROCESS(clk, we)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF(we = '1') THEN
                io_ports_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) <= din;
                dout <= (OTHERS => 'Z');
            ELSE
                dout <= io_ports_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1))));
            END IF;
        END IF;
    END PROCESS;
END hardware;
