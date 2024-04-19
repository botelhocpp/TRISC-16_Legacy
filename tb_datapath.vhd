----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_datapath
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Testbench for the 'datapath' module.
-- 
-- Dependencies: datapath
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY tb_datapath IS
END tb_datapath;

ARCHITECTURE behaviour OF tb_datapath IS
    CONSTANT N : INTEGER := 16;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT datapath IS
    GENERIC ( N : INTEGER := N );
    PORT (
        Immed : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RF_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        RAM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Input Signals
    SIGNAL Immed : word_t;
    SIGNAL RAM_in : word_t;
    
    -- Output Signals
    SIGNAL RAM_addr : word_t;
    SIGNAL RAM_out : word_t;
    
    -- Control Signals
    SIGNAL Rd_wr : STD_LOGIC;
    SIGNAL RF_sel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL Rd_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alu_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    DP_COMP : datapath PORT MAP (
        Immed => Immed,
        RAM_in => RAM_in,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        alu_op => alu_op,
        clk => clk,
        rst => rst,
        RAM_addr => RAM_addr,
        RAM_out => RAM_out
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        Immed <= x"0000";
        RAM_in <= x"0000";
        Rd_wr <= '0';
        RF_sel <= "00";
        Rd_sel <= "000";
        Rm_sel <= "000";
        Rn_sel <= "000";
        alu_op <= "0000";
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- WAIT FOR NEXT CYCLE
        rst <= '0';
        WAIT FOR CLK_PERIOD;
        
        -- R2 = 0x34  (MOVE IMM)
        Immed <= x"0034";
        Rd_sel <= "010"; 
        RF_sel <= "10";
        Rd_wr  <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- R5 = 0x51 (LDR)
        RAM_in <= x"0051";
        Rd_sel <= "101"; 
        RF_sel <= "01";
        WAIT FOR CLK_PERIOD;
        
        -- R3 = R2 (MOVE REG)
        Rm_sel <= "010";  
        Rd_sel <= "011";
        RF_sel <= "00";
        Rd_wr  <= '1';
        WAIT FOR CLK_PERIOD;
        
        -- R6 = R2 + R5 (ADD)
        Rm_sel <= "010"; 
        Rn_sel  <= "101";
        Rd_sel <= "110";
        RF_sel <= "11";
        alu_op <= "0100";
        WAIT FOR CLK_PERIOD;
        
        -- R6 = R6 - R5 (SUB)
        Rm_sel <= "110"; 
        Rn_sel  <= "101";
        Rd_sel <= "110";
        alu_op <= "0101";
        WAIT FOR CLK_PERIOD;
        
        -- END
        Rd_wr  <= '0';
        WAIT FOR 2*CLK_PERIOD;
    END PROCESS;
    
END behaviour;
