----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: tb_fsm
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Testbench for the 'fsm' module.
-- 
-- Dependencies: fsm
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY tb_fsm IS
END tb_fsm;

ARCHITECTURE behaviour OF tb_fsm IS
    CONSTANT N : INTEGER := 16;
    CONSTANT CLK_FREQ : INTEGER := 50e6;
    CONSTANT CLK_PERIOD : TIME := 5000ms / CLK_FREQ;

    COMPONENT fsm IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        IR_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        IR_load : OUT STD_LOGIC;
        PC_clr : OUT STD_LOGIC;
        PC_inc : OUT STD_LOGIC;
		RAM_sel : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        Rd_wr : OUT STD_LOGIC;
        RF_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     
		alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Immed : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Input Signals
    SIGNAL IR_data : word_t;
    
    -- Output Signals
    SIGNAL Immed : word_t;
    
    -- Control Signals
    SIGNAL RAM_sel : STD_LOGIC;
    SIGNAL RAM_we : STD_LOGIC;
    SIGNAL ROM_en : STD_LOGIC;
    SIGNAL PC_clr : STD_LOGIC;
    SIGNAL PC_inc : STD_LOGIC;
    SIGNAL IR_load : STD_LOGIC;
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
    FSM_COMP : fsm PORT MAP (
        IR_data => IR_data,
        clk => clk,
        rst => rst,
        IR_load => IR_load,
        PC_clr => PC_clr,
        PC_inc => PC_inc,
		RAM_sel => RAM_sel,
		RAM_we => RAM_we,
		ROM_en => ROM_en,
        Rd_wr => Rd_wr,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,   
		alu_op => alu_op,
        Immed => Immed
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        -- RESET INPUT VARIABLES
        IR_data <= x"0000";
        
        -- RESET CONDITION
        rst <= '1';
        WAIT FOR CLK_PERIOD;
        
        rst <= '0';
        WAIT FOR CLK_PERIOD;
        
        -- MOV R2, 0x34  (MOV IMM)
        IR_data <= "0001101000110100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- LDR R5, [R2] (LDR REG)
        IR_data <= "0011010101000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- LDR R1, [R5] (LDR REG)
        IR_data <= "0011000110100000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- NOP
        IR_data <= "0000000000000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- MOV R3, R2 (MOV REG)
        IR_data <= "0001001100100000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- ADD R6, R2, R5
        IR_data <= "0100011001010100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- NOP
        IR_data <= "0000000000000000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- SUB R6, R6, R5
        IR_data <= "0101011011010100";
        WAIT FOR 3*CLK_PERIOD;
        
        -- STR [R6], 0x10 (LDR REG)
        IR_data <= "0010100001110000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- STR [R3], R6 (LDR REG)
        IR_data <= "0010000001111000";
        WAIT FOR 3*CLK_PERIOD;
        
        -- HALT
        IR_data <= "1111111111111111";
        WAIT FOR 2*CLK_PERIOD;
    END PROCESS;
    
END behaviour;
