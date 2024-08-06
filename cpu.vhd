----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: cpu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Pairing of the datapath and the control unit to form a processor.
-- 
-- Dependencies: datapath, control_unit
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY cpu IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        -- Inputs
        ROM_in : IN word_t;
        DATA_in : IN word_t;
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		RAM_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_en : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        
        -- Outputs
        ROM_addr : OUT word_t;
        DATA_addr : OUT word_t;
        DATA_out : OUT word_t
    );
END cpu;

ARCHITECTURE behaviour OF cpu IS

    COMPONENT datapath IS
    GENERIC ( N : INTEGER := N );
    PORT (
        Immed : IN word_t;
        DATA_in : IN word_t;
        PC_in : IN word_t;
        Immed_en : IN STD_LOGIC;
        RF_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_op : IN alu_op_t;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        FLAGS_out : OUT word_t;
        DATA_addr : OUT word_t;
        DATA_out : OUT word_t
    );
    END COMPONENT;

    COMPONENT control_unit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        PC_in : IN word_t;
        ROM_in : IN word_t;
        FLAGS_in : IN word_t;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		Immed_en : OUT STD_LOGIC;
		RAM_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_en : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        Rd_wr : OUT STD_LOGIC;
        RF_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rm_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);     
		alu_op : OUT alu_op_t;
        ROM_addr : OUT word_t;
        Immed : OUT word_t
    );
    END COMPONENT;
    
    -- Intermediary I/O Signals
    SIGNAL Immed : word_t;
    SIGNAL FLAGS_data : word_t;
    SIGNAL DATA_addr_intermediary : word_t;
    
    -- Intermediary Control Signals
    SIGNAL Immed_en : STD_LOGIC;
    SIGNAL IN_sel : STD_LOGIC;
    SIGNAL Rd_wr : STD_LOGIC;
    SIGNAL RF_sel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL Rd_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alu_op : alu_op_t;
    SIGNAL ROM_addr_intermediary : word_t;
    
BEGIN    
    CTRL_UNIT_COMP : control_unit PORT MAP (
        PC_in => DATA_addr_intermediary,
        ROM_in => ROM_in,
        FLAGS_in => FLAGS_data,
        clk => clk,
        rst => rst,
		Immed_en => Immed_en,
		RAM_en => RAM_en,
		RAM_we => RAM_we,
		IO_en => IO_en,
		IO_we => IO_we,
		ROM_en => ROM_en,
        Rd_wr => Rd_wr,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,   
		alu_op => alu_op,
		ROM_addr => ROM_addr_intermediary,
        Immed => Immed
    );
    
    DP_COMP : datapath PORT MAP (
        Immed => Immed,
        DATA_in => DATA_in,
        PC_in => ROM_addr_intermediary,
        Immed_en => Immed_en,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        alu_op => alu_op,
        clk => clk,
        rst => rst,
        FLAGS_out => FLAGS_data,
        DATA_addr => DATA_addr_intermediary,
        DATA_out => DATA_out
    );
    
    ROM_addr <= ROM_addr_intermediary;
    DATA_addr <= DATA_addr_intermediary;
    
END behaviour;
