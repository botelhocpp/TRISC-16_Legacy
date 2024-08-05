----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: trisc_parameters
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Common parameters for the TRISC-16 project.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE trisc_parameters IS  
    -- Integer Constants
    CONSTANT kWORD_SIZE : INTEGER := 16;
    CONSTANT kADDR_NUM : INTEGER := 2**(kWORD_SIZE - 1);
    
    -- Types
    SUBTYPE word_t IS STD_LOGIC_VECTOR (kWORD_SIZE - 1 DOWNTO 0);
    
    -- Word Constants
    CONSTANT kZERO : word_t := (OTHERS => '0');
    CONSTANT kPC_DEFAULT_INCREMENT : word_t := STD_LOGIC_VECTOR(TO_UNSIGNED(kWORD_SIZE/8, kWORD_SIZE));

END trisc_parameters;
