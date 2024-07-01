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
USE IEEE.NUMERIC_STD.ALL;

ENTITY control_unit IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        FLAGS_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		Immed_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		IN_sel : OUT STD_LOGIC;
        Addr_sel : OUT STD_LOGIC;
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
        FLAGS_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        PC_inc : OUT STD_LOGIC;
        PC_clr : OUT STD_LOGIC;
        IR_load : OUT STD_LOGIC;
        FLAGS_load : OUT STD_LOGIC;
		Immed_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		IN_sel : OUT STD_LOGIC;
        Addr_sel : OUT STD_LOGIC;
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
    
    COMPONENT mux_2x1 IS
    GENERIC ( N : INTEGER := N );
    PORT (
        I0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Constants
    CONSTANT kPC_DEFAULT_INCREMENT : word_t := STD_LOGIC_VECTOR(TO_UNSIGNED(N/8, N));
    
    -- Input Signals
    SIGNAL FLAGS_data : word_t;
    SIGNAL IR_data : word_t;
    SIGNAL PC_input : word_t;
    SIGNAL PC_output : word_t;
    SIGNAL PC_increment : word_t;
    
    -- Internal Control Signals
    SIGNAL PC_clr : STD_LOGIC;
    SIGNAL PC_inc : STD_LOGIC;
    SIGNAL IR_load : STD_LOGIC;
    SIGNAL FLAGS_load : STD_LOGIC;
    
    -- Intermediary Signals
    SIGNAL FLAGS_intermediary : word_t;
    SIGNAL Immed_intermediary : word_t;
    SIGNAL Immed_en_intermediary : STD_LOGIC;
    
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
    FSM_COMP : fsm PORT MAP (
        IR_data => IR_data,
        FLAGS_data => FLAGS_data,
        clk => clk,
        rst => rst,
        IR_load => IR_load,
        FLAGS_load => FLAGS_load,
        PC_clr => PC_clr,
        PC_inc => PC_inc,
		IN_sel => IN_sel,
        Addr_sel => Addr_sel,
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
    PC_input <= STD_LOGIC_VECTOR(SIGNED(PC_output) + SIGNED(PC_increment));
    ROM_addr <= PC_output;
    
    FLAGS_intermediary <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(FLAGS_in), N));
    
    Immed <= Immed_intermediary;
    Immed_en <= Immed_en_intermediary;
END hardware;
