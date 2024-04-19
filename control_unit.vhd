----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: control_unit
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The control part of the processor.
-- 
-- Dependencies: mux_4x1, register_file, alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control_unit IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		RAM_sel : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        Rd_wr : OUT STD_LOGIC;
        RF_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     
		alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        -- Outputs
        ROM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Immed : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END control_unit;

ARCHITECTURE hardware OF control_unit IS

    COMPONENT fsm IS
    GENERIC ( N : INTEGER := N );
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

    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Input Signals
    SIGNAL IR_data : word_t;
    SIGNAL PC_input : word_t;
    SIGNAL PC_output : word_t;
    
    -- Control Signals
    SIGNAL PC_clr : STD_LOGIC;
    SIGNAL PC_inc : STD_LOGIC;
    SIGNAL IR_load : STD_LOGIC;
    
BEGIN
    PC: register_nbit PORT MAP (
        D => PC_input,
        ld => PC_inc,
        clk => clk,
        rst => PC_clr,
        Q => PC_output
    );
    IR: register_nbit PORT MAP (
        D => ROM_in,
        ld => IR_load,
        clk => clk,
        rst => rst,
        Q => IR_data
    );
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
    
    PC_input <= PC_output + 2;
    ROM_addr <= PC_output;
    
END hardware;
