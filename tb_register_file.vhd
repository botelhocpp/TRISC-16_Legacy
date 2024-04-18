----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_register_file
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Testbench for the 'register_file' module.
-- 
-- Dependencies: register_file
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY tb_register_file IS
END tb_register_file;

ARCHITECTURE behaviour OF tb_register_file IS
    CONSTANT N : INTEGER := 16;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT register_file IS
    GENERIC ( N : INTEGER := N );
    PORT (
        Rd : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Rm : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Rn : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Registers Intermediary Signals
    SIGNAL Rm : word_t;
    SIGNAL Rn : word_t;
    SIGNAL Rd : word_t;
    
    -- Control Intermediary Signals
    SIGNAL Rd_wr : STD_LOGIC;
    SIGNAL Rd_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    
    -- Common Intermediary Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    RF_COMP : register_file PORT MAP (
        Rd => Rd,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        clk => clk,
        rst => rst,
        Rm => Rm,
        Rn => Rn
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        Rd_wr <= '0';
        Rd_sel <= "000";
        Rm_sel <= "000"; 
        Rn_sel  <= "000";
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- WAIT FOR NEXT CYCLE
        rst <= '0';
        WAIT FOR CLK_PERIOD;
        
        -- R2 = 0x34 
        Rd <= x"0034";
        Rd_sel <= "010"; 
        Rd_wr  <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- R5 = 0x51 
        Rd <= x"0051";
        Rd_sel <= "101"; 
        WAIT FOR CLK_PERIOD;
        
        -- Rm = R2 AND Rn = R5 
        Rd_wr  <= '0';
        Rm_sel <= "010"; 
        Rn_sel  <= "101";
        WAIT FOR CLK_PERIOD;
        
        -- R3 = Rm 
        Rd_sel <= "011";
        Rd <= Rm;
        Rd_wr  <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- R6 = Rn 
        Rd_sel <= "110";
        Rd <= Rn;
        WAIT FOR CLK_PERIOD;
        
        -- END
        Rd_wr  <= '0';
        WAIT FOR 2*CLK_PERIOD;
    END PROCESS;
    
END behaviour;
