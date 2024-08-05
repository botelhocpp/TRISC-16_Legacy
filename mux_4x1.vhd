----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: mux_4x1
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Multiplexes 4 inputs to a singular output.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY mux_4x1 IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        I0 : IN word_t;
        I1 : IN word_t;
        I2 : IN word_t;
        I3 : IN word_t;
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Q : OUT word_t
    );
END mux_4x1;

ARCHITECTURE hardware OF mux_4x1 IS
BEGIN    
    WITH sel SELECT
        Q <=    I0 WHEN "00",
                I1 WHEN "01",
                I2 WHEN "10",
                I3 WHEN "11",
                (OTHERS => '0') WHEN OTHERS;
END hardware;
