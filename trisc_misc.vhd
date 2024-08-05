----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: trisc_misc
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Miscellaneous parameters for the TRISC-16 project.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

PACKAGE trisc_misc IS  
    -- Types
    TYPE mem_array_t IS ARRAY (0 TO kADDR_NUM - 1) OF word_t;
    
    -- Functions
    IMPURE FUNCTION InitMEM(file_name : string) RETURN mem_array_t;

END trisc_misc;

PACKAGE BODY trisc_misc IS 

    IMPURE FUNCTION InitMEM(file_name : string) RETURN mem_array_t IS
      FILE text_file : text OPEN read_mode IS file_name;
      VARIABLE text_line : line;
      VARIABLE contents : mem_array_t;
      VARIABLE i : INTEGER := 0;
    BEGIN
      WHILE NOT ENDFILE(text_file) LOOP
        readline(text_file, text_line);
        bread(text_line, contents(i));
        i := i + 1;
      END LOOP;
      
      FOR j IN i TO kADDR_NUM - 1 LOOP
        contents(j) := (OTHERS => '0');
      END LOOP;
      
      RETURN contents;
    END FUNCTION;
END trisc_misc;
