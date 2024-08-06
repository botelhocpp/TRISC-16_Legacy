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
        -- setup:
        "0001100000000000", -- 00: MOV R0, #0
        "0001100100001111", -- 02: MOV R1, #0xF
        "1111000000000100", -- 04: OUT [R0], R1
                
        -- while:
        "0001100000000100", -- 06: MOV R0, #4
        "1111000100000001", -- 08: IN R1, [R0]
        
        "1011100100100100", -- 0A: SHR R1, R1, #4
        "0001101000000010", -- 0C: MOV R2, #2
        "1111000001000100", -- 0E: OUT [R2], R1
        "0000111111101011", -- 10: JMP #-6
        
        OTHERS => (OTHERS => '1')
    );
    
BEGIN 
    dout <= rom_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) WHEN (en = '1') ELSE (OTHERS => 'Z');
END hardware;
