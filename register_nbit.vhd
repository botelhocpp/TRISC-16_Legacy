----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_nbit
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: A n-bit register. 
-- 
-- Dependencies: none.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY register_nbit IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END register_nbit;

ARCHITECTURE hardware OF register_nbit IS
BEGIN    
    PROCESS(rst, clk)
    BEGIN
        IF(rst = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF(RISING_EDGE(clk) AND ld = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END hardware;
