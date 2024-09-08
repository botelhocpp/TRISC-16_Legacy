----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Performs arithmetic and logic operations on two operands.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY alu IS
    GENERIC ( N : INTEGER := 8 );
    PORT (
        A : IN word_t;
        B : IN word_t;
        op : IN alu_op_t;
        Z_flag : OUT STD_LOGIC;
        C_flag : OUT STD_LOGIC;
        Q : OUT word_t
    );
END alu;

ARCHITECTURE hardware OF alu IS
    CONSTANT kZERO : SIGNED(N - 1 DOWNTO 0) := (OTHERS => '0');
    
    SIGNAL Q_mul : SIGNED( 2*N - 1 DOWNTO 0 );
    SIGNAL Q_op : SIGNED( N DOWNTO 0 );
    SIGNAL A_op : SIGNED( N DOWNTO 0 );
    SIGNAL B_op : SIGNED( N DOWNTO 0 );
BEGIN
    A_op <= SIGNED('0' & A);
    B_op <= SIGNED('0' & B);
    
    Q_mul <= A_op(N - 1 DOWNTO 0) * B_op(N - 1 DOWNTO 0);
    WITH op SELECT
        Q_op <= (A_op)                                  WHEN ALU_MOV_A,
                (B_op)                                  WHEN ALU_MOV_B,
                (A_op + B_op)                           WHEN ALU_ADD,
                (A_op - B_op)                           WHEN ALU_SUB,
                (Q_mul( N DOWNTO 0 ))                   WHEN ALU_MUL,
                (A_op AND B_op)                         WHEN ALU_AND,
                (A_op OR B_op)                          WHEN ALU_ORR,
                (NOT A_op)                              WHEN ALU_NOT,
                (A_op XOR B_op)                         WHEN ALU_XOR,
                (SHIFT_RIGHT(A_op, TO_INTEGER(B_op)))   WHEN ALU_SHR,
                (SHIFT_LEFT(A_op, TO_INTEGER(B_op)))    WHEN ALU_SHL,
                (OTHERS => '0')                         WHEN OTHERS;
    Q <= STD_LOGIC_VECTOR(Q_op(N - 1 DOWNTO 0)); 
    
    Z_flag <= '1' WHEN (Q_op(N - 1 DOWNTO 0) = kZERO) ELSE '0';
    C_flag <= Q_op(N);
END hardware;
