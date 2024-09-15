----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: prescaler
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A clock frequency divisor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY prescaler IS
    GENERIC( N : INTEGER := 4 );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        divisor : IN STD_LOGIC_VECTOR( N - 1 DOWNTO 0 );
        output_clk : OUT STD_LOGIC
    );
END prescaler;

ARCHITECTURE hardware OF prescaler IS 
    CONSTANT Q : INTEGER := 2**N;
    CONSTANT kN_BIT_ZERO : STD_LOGIC_VECTOR( Q - 1 DOWNTO 0) := (OTHERS => '0');
    
    -- Internal prescaler counter
    SIGNAL counter : UNSIGNED( Q - 1 DOWNTO 0);
BEGIN 
    -- Enables prescaler if divisor isn't zero
    output_clk <= counter(TO_INTEGER(UNSIGNED(divisor) - 1)) WHEN (divisor /= kN_BIT_ZERO) ELSE (clk);
    
    -- Counter process
    PROCESS(clk, rst)
    BEGIN
        IF(rst = '1') THEN
            counter <= (OTHERS => '0');
        ELSIF(RISING_EDGE(clk)) THEN
            counter <= counter + 1;
        END IF;
    END PROCESS;
END hardware;
