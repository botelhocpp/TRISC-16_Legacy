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
USE STD.TEXTIO.ALL;

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
                                     
    -- Load the Program Memory from File
    FUNCTION InitROM(file_name : string) RETURN rom_array_t IS
      FILE text_file : text OPEN read_mode IS file_name;
      VARIABLE text_line : line;
      VARIABLE rom_content : rom_array_t;
      VARIABLE i : INTEGER := 0;
    BEGIN
      WHILE NOT ENDFILE(text_file) LOOP
        readline(text_file, text_line);
        bread(text_line, rom_content(i));
        i := i + 1;
      END LOOP;
      
      FOR j IN i TO Q - 1 LOOP
        rom_content(j) := (OTHERS => '0');
      END LOOP;
      
      RETURN rom_content;
    END FUNCTION;    
    
    SIGNAL rom_contents : rom_array_t := InitROM("program.txt");
    
BEGIN 
    dout <= rom_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) WHEN (en = '1') ELSE (OTHERS => 'Z');
END hardware;
