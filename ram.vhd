----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: ram
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;
USE WORK.TRISC_MISC.ALL;

ENTITY ram IS
    GENERIC(
        N : INTEGER := kWORD_SIZE;
        Q : INTEGER := kADDR_NUM
    );
    PORT (
        din : IN word_t;
        addr : IN word_t;
        en : IN STD_LOGIC;
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT word_t
    );
END ram;

ARCHITECTURE hardware OF ram IS
    SIGNAL ram_contents : mem_array_t;
BEGIN    
    PROCESS(clk, en)
    BEGIN
        IF(en = '0') THEN
            dout <= (OTHERS => 'Z');
        ELSIF(RISING_EDGE(clk)) THEN
            IF(we = '1') THEN
                ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) <= din;
                dout <= (OTHERS => 'Z');
            ELSE
                dout <= ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1))));
            END IF;
        END IF;
    END PROCESS;
END hardware;
