----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: fsm
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Description: Controls the processor instruction execution.
-- Observation: Uses Mealy machine model.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY fsm IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        IR_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
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
        
        -- Outputs
        Immed : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END fsm;

ARCHITECTURE hardware OF fsm IS
    TYPE states_t IS (
        INIT, 
        FETCH, 
        DECODE, 
        EXEC_NOP, 
        EXEC_HALT, 
        EXEC_MOVE, 
        EXEC_LOAD, 
        EXEC_STORE, 
        EXEC_ALU
    );
    SIGNAL current_state : states_t := INIT;
    
BEGIN  
    -- States Logic
    PROCESS(clk, rst)
    BEGIN
        IF(rst = '1') THEN
            current_state <= INIT;
        ELSIF(RISING_EDGE(clk)) THEN
            CASE current_state IS
                WHEN INIT =>
                    current_state <= FETCH;
                    
                WHEN FETCH => 
                    current_state <= DECODE;
                    
                WHEN DECODE =>
                    IF(IR_data(15 DOWNTO 12) = "0000") THEN
                        current_state <= EXEC_NOP;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "1111") THEN
                        current_state <= EXEC_HALT;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0001") THEN
                        current_state <= EXEC_MOVE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0010") THEN
                        current_state <= EXEC_STORE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0011") THEN
                        current_state <= EXEC_LOAD;
                        
                    ELSIF(IR_data(15 DOWNTO 12) >= "0100" AND IR_data(15 DOWNTO 12) <=  "1010") THEN
                        current_state <= EXEC_ALU;
                    END IF;
                    
                WHEN EXEC_NOP =>
                    current_state <= FETCH;
                    
                WHEN EXEC_HALT => 
                    current_state <= EXEC_HALT;
                    
                WHEN EXEC_MOVE =>
                    current_state <= FETCH;
                    
                WHEN EXEC_LOAD =>
                    current_state <= FETCH;
                    
                WHEN EXEC_STORE =>
                    current_state <= FETCH;
                    
                WHEN EXEC_ALU =>
                    current_state <= FETCH;
            END CASE;
        END IF;
    END PROCESS;
    
    -- Output Logic
    PROCESS(current_state, IR_data)
    BEGIN
            CASE current_state IS
                WHEN INIT =>
                    PC_clr <= '1';
                    PC_inc <= '0';
                    ROM_en <= '0';
                    IR_load <= '0';
                    Immed <= (OTHERS => '0');
                    RAM_sel <= '0';
                    RAM_we <= '0';
                    RF_sel <= "00";
                    Rd_sel <= "000";
                    Rd_wr <= '0';
                    Rm_sel <= "000";
                    Rn_sel <= "000";
                    alu_op <= "0000";
                    
                WHEN FETCH => 
                    PC_clr <= '0';
                    PC_inc <= '1';
                    ROM_en <= '1';
                    IR_load <= '1';
                    RAM_we <= '0';
                    Rd_wr <= '0';
                    
                WHEN DECODE =>
                    PC_inc <= '0';
                    ROM_en <= '0';
                    IR_load <= '0';
                    
                    Rd_sel <= IR_data(10 DOWNTO 8);
                    Rm_sel <= IR_data(7 DOWNTO 5);
                    Rn_sel <= IR_data(4 DOWNTO 2);
                    
                WHEN EXEC_MOVE =>
                    Rd_wr <= '1';
                    IF(IR_data(11) = '1') THEN
                        Immed <= x"00" & IR_data(7 DOWNTO 0);
                        RF_sel <= "10";
                    ELSE
                        RF_sel <= "00";
                    END IF;
                    
                WHEN EXEC_LOAD =>
                    Rd_wr <= '1';
                    RF_sel <= "01";
                    
                WHEN EXEC_STORE =>
                    RAM_we <= '1';
                    IF(IR_data(11) = '1') THEN
                        Immed <= x"00" & IR_data(10 DOWNTO 8) & IR_data(4 DOWNTO 0);
                        RAM_sel <= '1';
                    ELSE
                        RAM_sel <= '0';
                    END IF;
                    
                WHEN EXEC_ALU =>
                    RF_sel <= "11";
                    Rd_wr <= '1';
                    alu_op <= IR_data(15 DOWNTO 12);
                
                WHEN OTHERS =>
            END CASE;
    END PROCESS;
END hardware;
