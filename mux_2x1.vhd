----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: mux_2x1
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Multiplexes 2 inputs to a singular output.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_2x1 IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        I0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END mux_2x1;

ARCHITECTURE hardware OF mux_2x1 IS
BEGIN    
        Q <= I1 WHEN (sel = '1') ELSE I0;
END hardware;
