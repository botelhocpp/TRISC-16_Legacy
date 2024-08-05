----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_file
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A set of 8 n-bit registers. 
-- 
-- Dependencies: register_nbit.
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY register_file IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        Rd : IN word_t;
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Rm : OUT word_t;
        Rn : OUT word_t
    );
END register_file;

ARCHITECTURE hardware OF register_file IS
    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        D : IN word_t;
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT word_t
    );
    END COMPONENT;
    
    TYPE register_array_t IS ARRAY (7 DOWNTO 0) OF word_t;
    SIGNAL registers : register_array_t;
    
    SIGNAL registers_ld : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN  
    generate_registers:
    FOR i IN 7 DOWNTO 0 GENERATE
    registers_ld(i) <= '1' when Rd_sel = STD_LOGIC_VECTOR(TO_UNSIGNED(i, 3)) and Rd_wr = '1' else '0';
        REGS: register_nbit PORT MAP (
            D => Rd,
            ld => registers_ld(i),
            clk => clk,
            rst => rst,
            Q => registers(i)
        );
    END GENERATE;
    
    Rm <= registers(TO_INTEGER(UNSIGNED(Rm_sel)));
    Rn <= registers(TO_INTEGER(UNSIGNED(Rn_sel)));
    
END hardware;
