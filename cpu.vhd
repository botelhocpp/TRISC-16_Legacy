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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY cpu IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		RAM_we : OUT STD_LOGIC;
		ROM_en : OUT STD_LOGIC;
        
        -- Outputs
        ROM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END cpu;

ARCHITECTURE behaviour OF cpu IS

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

    COMPONENT control_unit IS
    GENERIC ( N : INTEGER := N );
    PORT (
        ROM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
		RAM_sel : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
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
    
    -- Intermediary I/O Signals
    SIGNAL RAM_data_out : word_t;
    SIGNAL Immed : word_t;
    
    -- Intermediary Control Signals
    SIGNAL RAM_sel : STD_LOGIC;
    SIGNAL Rd_wr : STD_LOGIC;
    SIGNAL RF_sel : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL Rd_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rm_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rn_sel : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL alu_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
    
BEGIN    
    CTRL_UNIT_COMP : control_unit PORT MAP (
        ROM_in => ROM_in,
        clk => clk,
        rst => rst,
		RAM_sel => RAM_sel,
		RAM_we => RAM_we,
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
        RF_sel => RF_sel,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        alu_op => alu_op,
        clk => clk,
        rst => rst,
        RAM_addr => RAM_addr,
        RAM_out => RAM_data_out
    );
    
    RAM_MUX_COMP: mux_2x1 PORT MAP (
        I0 => RAM_data_out,
        I1 => Immed,
        sel => RAM_sel,
        Q => RAM_out
    ); 
    
END behaviour;
