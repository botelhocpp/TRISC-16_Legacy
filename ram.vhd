----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: ram
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The data memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ram IS
    GENERIC(
        N : INTEGER := 16;
        Q : INTEGER := 32768
    );
    PORT (
        din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ram;

ARCHITECTURE hardware OF ram IS
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    TYPE ram_array_t IS ARRAY (0 TO Q - 1) OF word_t;
    SIGNAL ram_contents : ram_array_t := (
        x"0000",    -- 0
        x"1000",    -- 2
        x"2000",    -- 4
        x"0000",    -- 6
        OTHERS => x"0000"
    );
BEGIN    
    PROCESS(clk)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF(we = '1') THEN
                ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) <= din;
            END IF;
            dout <= ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1))));
        END IF;
    END PROCESS;
END hardware;
