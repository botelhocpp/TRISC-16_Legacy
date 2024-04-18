----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_file
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: A set of 8 n-bit registers. 
-- 
-- Dependencies: register_nbit.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY register_file IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        Rd : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Rm : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rn : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END register_file;

ARCHITECTURE hardware OF register_file IS
    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    TYPE register_array_t IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL registers : register_array_t;
    
    SIGNAL registers_ld : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN  
    registers_ld <= (
        CONV_INTEGER(Rd_sel) => ( Rd_wr AND '1' ),
        OTHERS => '0'
    );
    
    generate_registers:
    FOR i IN 7 DOWNTO 0 GENERATE
        REGS: register_nbit PORT MAP (
            D => Rd,
            ld => registers_ld(i),
            clk => clk,
            rst => rst,
            Q => registers(i)
        );
    END GENERATE;
    
    Rm <= registers( CONV_INTEGER(Rm_sel) );
    Rn <= registers( CONV_INTEGER(Rn_sel) );
    
END hardware;
