----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: rom
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The program memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rom IS
    GENERIC( N : INTEGER := 16 );
    PORT (
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END rom;

ARCHITECTURE hardware OF rom IS
    TYPE rom_array_t IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    CONSTANT rom_contents : rom_array_t := (
        "0001100000000010",     -- 00: MOV R0, 0x02     (MOV IMM)
        "0011000100000000",     -- 02: LDR R1, [R0]     (LDR REG)
        "0001100000000100",     -- 04: MOV R0, 0x04     (MOV IMM)
        "0011001000000000",     -- 06: LDR R2, [R0]     (LDR REG)
        "0100000100101000",     -- 08: ADD R1, R1, R2   (ALU)
        "0001100000000110",     -- 10: MOV R0, 0x06     (MOV IMM)
        "0010000000000100",     -- 12: STR [R0], R1     (STR REG)
        "1111111111111111"      -- 14: HALT             (HALT)
    );
BEGIN    
    PROCESS(clk)
    BEGIN
        -- IF(RISING_EDGE(clk) AND en = '1') THEN
        IF(RISING_EDGE(clk)) THEN
            dout <= rom_contents( CONV_INTEGER( addr(N - 1 DOWNTO 1) ) );
        END IF;
    END PROCESS;
END hardware;
