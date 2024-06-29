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
        Z_flag : OUT STD_LOGIC;
        C_flag : OUT STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END alu;

ARCHITECTURE hardware OF alu IS
    SIGNAL multiply_result : STD_LOGIC_VECTOR( 2*N - 1 DOWNTO 0 );
BEGIN
    multiply_result <= A * B;
    WITH op SELECT
        Q <=   (A + B)          WHEN "0100",
               (OTHERS => '0')  WHEN OTHERS;
    Z_flag <= '1';
    C_flag <= '1';
END hardware;