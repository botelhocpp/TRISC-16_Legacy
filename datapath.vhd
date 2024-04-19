----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: datapath
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: The data processing part of the processor.
-- 
-- Dependencies: mux_4x1, register_file, alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY datapath IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        Immed : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Control Signals
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
        RAM_addr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        RAM_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
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
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
    END COMPONENT;
    
    SUBTYPE word_t IS STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
    
    -- Intermediary Signals
    SIGNAL Rm : word_t;
    SIGNAL Rn : word_t;
    SIGNAL Rd : word_t;
    SIGNAL alu_res : word_t;
    
BEGIN
    RF_MUX_COMP : mux_4x1 PORT MAP (
        I0 => Rm,
        I1 => RAM_in,
        I2 => Immed,
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
        Rn => Rn
    );
    
    ALU_COMP : alu PORT MAP (
        A => Rm,
        B => Rn,
        op => alu_op,
        Q => alu_res
    ); 
    
    RAM_out <= Rn;
    RAM_addr <= Rm;
    
END hardware;
