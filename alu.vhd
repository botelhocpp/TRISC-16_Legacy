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
USE IEEE.NUMERIC_STD.ALL;

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
    SIGNAL Q_mul : SIGNED( 2*N - 1 DOWNTO 0 );
    SIGNAL Q_op : SIGNED( N DOWNTO 0 );
    SIGNAL A_op : SIGNED( N DOWNTO 0 );
    SIGNAL B_op : SIGNED( N DOWNTO 0 );
BEGIN
    A_op <= SIGNED('0' & A);
    B_op <= SIGNED('0' & B);
    
    Q_mul <= A_op(N - 1 DOWNTO 0) * B_op(N - 1 DOWNTO 0);
    WITH op SELECT
        Q_op <= (A_op + B_op)                           WHEN "0100",
                (A_op - B_op)                           WHEN "0101",
                (Q_mul( N DOWNTO 0 ))                   WHEN "0110",
                (A_op AND B_op)                         WHEN "0111",
                (A_op OR B_op)                          WHEN "1000",
                (NOT A_op)                              WHEN "1001",
                (A_op XOR B_op)                         WHEN "1010",
                (SHIFT_RIGHT(A_op, TO_INTEGER(B_op)))   WHEN "1011",
                (SHIFT_LEFT(A_op, TO_INTEGER(B_op)))    WHEN "1100",
                ('0' & ROTATE_RIGHT(SIGNED(A), 1))      WHEN "1101",
                ('0' & ROTATE_LEFT(SIGNED(A), 1))       WHEN "1110",
                (OTHERS => '0')                         WHEN OTHERS;
    Q <= STD_LOGIC_VECTOR(Q_op(N - 1 DOWNTO 0)); 
    
    Z_flag <= '1' WHEN (Q_op(N - 1 DOWNTO 0) = x"0000") ELSE '0';
    C_flag <= Q_op(N);
END hardware;
