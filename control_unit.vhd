----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: control_unit
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The control part of the processor.
-- 
-- Dependencies: mux_2x1, register_nbit, fsm
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY control_unit IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        -- Inputs
        ROM_in : IN word_t;
        PC_in : IN word_t;
        FLAGS_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		Immed_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        Rd_wr : OUT STD_LOGIC;
        RF_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     
		alu_op : OUT alu_op_t;
        
        -- Outputs
        ROM_addr : OUT word_t;
        Immed : OUT word_t
    );
END control_unit;

ARCHITECTURE hardware OF control_unit IS

    COMPONENT fsm IS
    GENERIC ( N : INTEGER := N );
    PORT (
        IR_data : IN word_t;
        FLAGS_data : IN word_t;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        PC_load : OUT STD_LOGIC;
        PC_sel : OUT STD_LOGIC;
        IR_load : OUT STD_LOGIC;
        FLAGS_load : OUT STD_LOGIC;
		Immed_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
        Rd_wr : OUT STD_LOGIC;
        RF_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     
		alu_op : OUT alu_op_t;
        Immed : OUT word_t
    );
    END COMPONENT;

    COMPONENT register_nbit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        D : IN word_t;
        ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT word_t
    );
    END COMPONENT;
    
    COMPONENT mux_2x1 IS
    GENERIC ( N : INTEGER := N );
    PORT (
        I0 : IN word_t;
        I1 : IN word_t;
        sel : IN STD_LOGIC;
        Q : OUT word_t
    );
    END COMPONENT;
    
    -- Input Signals
    SIGNAL FLAGS_data : word_t;
    SIGNAL IR_data : word_t;
    SIGNAL PC_input : word_t;
    SIGNAL PC_output : word_t;
    SIGNAL PC_increment : word_t;
    SIGNAL Adder_output : word_t;
    
    -- Internal Control Signals
    SIGNAL PC_load : STD_LOGIC;
    SIGNAL PC_sel : STD_LOGIC;
    SIGNAL IR_load : STD_LOGIC;
    SIGNAL FLAGS_load : STD_LOGIC;
    
    -- Intermediary Signals
    SIGNAL FLAGS_intermediary : word_t;
    SIGNAL Immed_intermediary : word_t;
    SIGNAL Immed_en_intermediary : STD_LOGIC;
    
BEGIN
    PC: register_nbit PORT MAP (
        D => PC_input,
        ld => PC_load,
        clk => clk,
        rst => rst,
        Q => PC_output
    );
    IR: register_nbit PORT MAP (
        D => ROM_in,
        ld => IR_load,
        clk => clk,
        rst => rst,
        Q => IR_data
    );
    FLAGS: register_nbit PORT MAP (
        D => FLAGS_intermediary,
        ld => FLAGS_load,
        clk => clk,
        rst => rst,
        Q => FLAGS_data
    );
    ADDER_MUX_COMP: mux_2x1 PORT MAP (
        I0 => kPC_DEFAULT_INCREMENT,
        I1 => Immed_intermediary,
        sel => Immed_en_intermediary,
        Q => PC_increment
    ); 
    PC_MUX_COMP: mux_2x1 PORT MAP (
        I0 => Adder_output,
        I1 => PC_in,
        sel => PC_sel,
        Q => PC_input
    );
    FSM_COMP : fsm PORT MAP (
        IR_data => IR_data,
        FLAGS_data => FLAGS_data,
        clk => clk,
        rst => rst,
        IR_load => IR_load,
        FLAGS_load => FLAGS_load,
        PC_load => PC_load,
        PC_sel => PC_sel,
		RAM_we => RAM_we,
		IO_we => IO_we,
		Immed_en => Immed_en_intermediary,
		ROM_en => ROM_en,
        Rd_wr => Rd_wr,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,   
		alu_op => alu_op,
        Immed => Immed_intermediary
    );
    Adder_output <= STD_LOGIC_VECTOR(SIGNED(PC_output) + SIGNED(PC_increment));
    ROM_addr <= PC_output;
    
    FLAGS_intermediary <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(FLAGS_in), N));
    
    Immed <= Immed_intermediary;
    Immed_en <= Immed_en_intermediary;
END hardware;
