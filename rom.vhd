----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: rom
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The program memory of the processor.
-- Observations: At INIT state, when en = '0' the dout is "UUUU", causing errors. 
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY rom IS
    GENERIC(
        N : INTEGER := 16;
        Q : INTEGER := 32768
    );
    PORT (
        addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END rom;

ARCHITECTURE hardware OF rom IS
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    TYPE rom_array_t IS ARRAY (0 TO Q - 1) OF word_t;
    CONSTANT rom_contents : rom_array_t := (
        -- LOAD SP
        "0001100000000000",     -- 00: MOV R0, #0
        "0011011100000000",     -- 02: LDR R7, [R0]
        
        -- LOAD VAR(A)
        "0001100000000010",     -- 04: MOV R0, #2
        "0011000100000000",     -- 06: LDR R1, [R0]
        
        -- LOAD VAR(B)
        "0001100000000100",     -- 08: MOV R0, #4
        "0011001000000000",     -- 0A: LDR R2, [R0]
        
        -- LOAD VAR(C)
        "0001100000000110",     -- 0C: MOV R0, #6
        "0011001100000000",     -- 0E: LDR R3, [R0]
        
        -- X = A + B
        "0100010000101000",     -- 10: ADD R4, R1, R2
        
        -- PUSH X TO STACK
        "0000000000010001",     -- 12: PUSH R4
        
        -- IF X < C...
        "0000000010001111",     -- 14: CMP R4, R3
        "0000100001000010",     -- 16: JLT #16
        
        -- ELSE Y = X - C
        "0101010110001100",     -- 18: SUB R5, R4, R3 
        
        -- VAR(D) = Y
        "0001100000001000",     -- 1A: MOV R0, #8
        "0010000000010100",     -- 1C: STR [R0], R5
        
        -- POP STACK TO Y
        "0000010100000010",     -- 1E: POP R5
        
        -- IF X = Y...
        "0000000010010111",     -- 20: CMP R4, R5
        "0000100000001001",     -- 22: JEQ #2
        
        -- ELSE
        "0000111101100000",     -- 24: JMP #-38
        
        -- ... END
        "1111111111111111",     -- 26: HALT
        
        -- ... Y = X * C
        "0110010110001100",     -- 28: MUL R5, R4, R3
        "0000111110111000",     -- 2A: JMP #-18

        OTHERS => x"0000"
    );
BEGIN    
    dout <= rom_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) WHEN (en = '1') ELSE (OTHERS => 'Z');
END hardware;
