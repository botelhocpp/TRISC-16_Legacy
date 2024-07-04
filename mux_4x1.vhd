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

ENTITY mux_4x1 IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        I0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I3 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
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
