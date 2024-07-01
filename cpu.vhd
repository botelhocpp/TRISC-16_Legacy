----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: cpu
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Pairing of the datapath and the control unit to form a processor.
-- 
-- Dependencies: datapath, control_unit, mux_2x1
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cpu IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        IO_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        
        -- Outputs
        ROM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        DATA_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        DATA_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END cpu;

ARCHITECTURE behaviour OF cpu IS

    COMPONENT datapath IS
    GENERIC ( N : INTEGER := N );
    PORT (
        Immed : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        IO_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Immed_en : IN STD_LOGIC;
        IN_sel : IN STD_LOGIC;
        Addr_sel : IN STD_LOGIC;
        RF_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        FLAGS_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        DATA_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        DATA_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT control_unit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        FLAGS_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
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
        ROM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Immed : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Intermediary I/O Signals
    SIGNAL Immed : word_t;
    SIGNAL FLAGS_data : STD_LOGIC_VECTOR (1 DOWNTO 0);
    
    -- Intermediary Control Signals
    SIGNAL Immed_en : STD_LOGIC;
    SIGNAL IN_sel : STD_LOGIC;
    SIGNAL Addr_sel : STD_LOGIC;
    SIGNAL Rd_wr : STD_LOGIC;
    SIGNAL RF_sel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL Rd_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alu_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
    
BEGIN    
    CTRL_UNIT_COMP : control_unit PORT MAP (
        ROM_in => ROM_in,
        FLAGS_in => FLAGS_data,
        clk => clk,
        rst => rst,
		Immed_en => Immed_en,
		RAM_we => RAM_we,
		IO_we => IO_we,
		IN_sel => IN_sel,
        Addr_sel => Addr_sel,
		ROM_en => ROM_en,
        Rd_wr => Rd_wr,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,   
		alu_op => alu_op,
		ROM_addr => ROM_addr,
        Immed => Immed
    );
    
    DP_COMP : datapath PORT MAP (
        Immed => Immed,
        RAM_in => RAM_in,
        IO_in => IO_in,
        Immed_en => Immed_en,
        IN_sel => IN_sel,
        Addr_sel => Addr_sel,
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        alu_op => alu_op,
        clk => clk,
        rst => rst,
        FLAGS_out => FLAGS_data,
        DATA_addr => DATA_addr,
        DATA_out => DATA_out
    );
    
END behaviour;
