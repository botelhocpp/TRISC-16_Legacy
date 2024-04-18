----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Performs arithmetic and logic operations on two operands.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY alu IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END alu;

ARCHITECTURE hardware OF alu IS
BEGIN
    WITH op SELECT
        Q <=   (A + B)          WHEN "0100",
               (A - B)          WHEN "0101",
               (A * B)          WHEN "0110",
               (A AND B)        WHEN "0111",
               (A OR B)         WHEN "1000",
               (NOT A)          WHEN "1001",
               (A XOR B)        WHEN "1010",
               (OTHERS => '0')  WHEN OTHERS;
END hardware;
