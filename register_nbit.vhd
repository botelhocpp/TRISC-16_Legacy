----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_nbit
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A n-bit register. 
-- 
-- Dependencies: none.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY register_nbit IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        D : IN word_t;
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT word_t
    );
END register_nbit;

ARCHITECTURE hardware OF register_nbit IS
BEGIN    
    PROCESS(rst, clk, ld)
    BEGIN
        IF(rst = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF(RISING_EDGE(clk) AND ld = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END hardware;
