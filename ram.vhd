----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: ram
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data memory of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;

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
    
    -- Load the Data Memory from File
    FUNCTION InitRAM(file_name : string) RETURN ram_array_t IS
      FILE text_file : text OPEN read_mode IS file_name;
      VARIABLE text_line : line;
      VARIABLE ram_content : ram_array_t;
      VARIABLE i : INTEGER := 0;
    BEGIN
      WHILE NOT ENDFILE(text_file) LOOP
        readline(text_file, text_line);
        hread(text_line, ram_content(i));
        i := i + 1;
      END LOOP;
      
      FOR j IN i TO Q - 1 LOOP
        ram_content(j) := (OTHERS => '0');
      END LOOP;
      
      RETURN ram_content;
    END FUNCTION;
    
    SIGNAL ram_contents : ram_array_t := InitRAM("data.txt");
BEGIN    
    PROCESS(clk, we)
    BEGIN
        IF(RISING_EDGE(clk)) THEN
            IF(we = '1') THEN
                ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1)))) <= din;
                dout <= (OTHERS => 'Z');
            ELSE
                dout <= ram_contents(TO_INTEGER(UNSIGNED(addr(N - 1 DOWNTO 1))));
            END IF;
        END IF;
    END PROCESS;
END hardware;
