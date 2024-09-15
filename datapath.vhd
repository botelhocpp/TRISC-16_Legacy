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

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

ENTITY datapath IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        -- Inputs
        Immed : IN word_t;
        PC_in : IN word_t;
        RAM_in : IN word_t;
        IO_in : IN word_t;
        
        -- Control Signals
        Immed_en : IN STD_LOGIC;
        RF_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_op : IN alu_op_t;
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Outputs
        FLAGS_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        DATA_addr : OUT word_t;
        DATA_out : OUT word_t
    );
END datapath;

ARCHITECTURE hardware OF datapath IS

    COMPONENT mux_4x1 IS
    GENERIC ( N : INTEGER := N );
    PORT (
        I0 : IN word_t;
        I1 : IN word_t;
        I2 : IN word_t;
        I3 : IN word_t;
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Q : OUT word_t
    );
    END COMPONENT;

    COMPONENT register_file IS
    GENERIC ( N : INTEGER := N );
    PORT (
        Rd : IN word_t;
        Rd_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_wr : IN STD_LOGIC;
        Rm_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rn_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Rm : OUT word_t;
        Rn : OUT word_t
    );
    END COMPONENT;

    COMPONENT alu IS
    GENERIC ( N : INTEGER := N );
    PORT (
        A : IN word_t;
        B : IN word_t;
        op : IN alu_op_t;
        Z_flag : OUT STD_LOGIC;
        C_flag : OUT STD_LOGIC;
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
    
    -- Intermediary Signals
    SIGNAL Rm : word_t;
    SIGNAL Rn_RF : word_t;
    SIGNAL Rn_out : word_t;
    SIGNAL Rd : word_t;
    SIGNAL alu_res : word_t;
    
BEGIN
    RF_MUX_COMP : mux_4x1 PORT MAP (
        I0 => alu_res,
        I1 => PC_in,
        I2 => RAM_in,
        I3 => IO_in,
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
    
    DATA_out <= Rn_out;
    DATA_addr <= alu_res;
    
END hardware;
