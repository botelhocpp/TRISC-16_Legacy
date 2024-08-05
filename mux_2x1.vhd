----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: mux_2x1
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Multiplexes 2 inputs to a singular output.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY mux_2x1 IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        I0 : IN word_t;
        I1 : IN word_t;
        sel : IN STD_LOGIC;
        Q : OUT word_t
    );
END mux_2x1;

ARCHITECTURE hardware OF mux_2x1 IS
BEGIN    
        Q <= I1 WHEN (sel = '1') ELSE I0;
END hardware;
