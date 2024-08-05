----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: rom
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The program memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;
USE WORK.TRISC_MISC.ALL;

ENTITY rom IS
    GENERIC(
        N : INTEGER := kWORD_SIZE;
        Q : INTEGER := kADDR_NUM
    );
    PORT (
        addr : IN word_t;
        en : IN STD_LOGIC;
        dout : OUT word_t
    );
END rom;

ARCHITECTURE hardware OF rom IS 
    CONSTANT rom_contents : mem_array_t := (
        "0001100000000000", -- 00: MOV R0, #0
        "1111100100011100", -- 02: OUT [R0], #0x0F
                
        -- while:
        "0001100000000100", -- 04: MOV R0, #4
        "1111000100000001", -- 06: IN R1, [R0]
        "0000000000000101", -- 08: PUSH R1
        "0000001000000010", -- 10: POP R2
        "1011100101000100", -- 12: SHR R1, R2, #4
        
        -- if
        "0001101000001111", -- 14: MOV R2, #0xF
        "0111000100101000", -- 16: AND R1, R1, R2
        "0001101000000010", -- 18: MOV R2, #2
        "0000100000010001", -- 20: JEQ #4
        
        -- else
        "1111100101011100", -- 22: OUT [R2], #0xF
        "0000111110101000", -- 24: JMP #-22
        
        -- then
        "1111100001000000", -- 22: OUT [R2], #0
        "0000111110011000", -- 28: JMP #-26
        
        OTHERS => (OTHERS => '1')
    );
    
BEGIN 
    dout <= rom_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) WHEN (en = '1') ELSE (OTHERS => 'Z');
END hardware;
