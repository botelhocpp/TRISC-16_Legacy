----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: datapath
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data processing part of the processor.
-- 
-- Dependencies: mux_4x1, mux_2x1, register_file, alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY datapath IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        Immed : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        IO_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Control Signals
        Immed_en : IN STD_LOGIC;
        IN_sel : IN STD_LOGIC;
        Addr_sel : IN STD_LOGIC;
        RF_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Outputs
        FLAGS_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        DATA_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        DATA_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END datapath;

ARCHITECTURE hardware OF datapath IS

    COMPONENT mux_4x1 IS
    GENERIC ( N : INTEGER := N );
    PORT (
        I0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        I3 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;

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

    COMPONENT alu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Z_flag : OUT STD_LOGIC;
        C_flag : OUT STD_LOGIC;
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
    
    -- Intermediary Signals
    SIGNAL Rm : word_t;
    SIGNAL Rn_RF : word_t;
    SIGNAL Rn_out : word_t;
    SIGNAL Rd : word_t;
    SIGNAL alu_res : word_t;
    SIGNAL DATA_in : word_t;
    
BEGIN
    INPUT_MUX_COMP: mux_2x1 PORT MAP (
        I0 => RAM_in,
        I1 => IO_in,
        sel => IN_sel,
        Q => DATA_in
    ); 
    
    RF_MUX_COMP : mux_4x1 PORT MAP (
        I0 => Rm,
        I1 => Immed,
        I2 => DATA_in,
        I3 => alu_res,
        sel => RF_sel,
        Q => Rd
    );
    
    RF_COMP : register_file PORT MAP (
        Rd => Rd,
        Rd_sel => Rd_sel,
        Rd_wr => Rd_wr,
        Rm_sel => Rm_sel,
        Rn_sel => Rn_sel,
        clk => clk,
        rst => rst,
        Rm => Rm,
        Rn => Rn_RF
    );
    
    RN_MUX_COMP: mux_2x1 PORT MAP (
        I0 => Rn_RF,
        I1 => Immed,
        sel => Immed_en,
        Q => Rn_out
    ); 
    
    ALU_COMP : alu PORT MAP (
        A => Rm,
        B => Rn_out,
        op => alu_op,
        Z_flag => FLAGS_out(0),
        C_flag => FLAGS_out(1),
        Q => alu_res
    ); 
    
    DATA_ADDR_MUX_COMP: mux_2x1 PORT MAP (
        I0 => Rm,
        I1 => alu_res,
        sel => ADDR_sel,
        Q => DATA_addr
    ); 
    
    DATA_out <= Rn_out;
    
END hardware;
