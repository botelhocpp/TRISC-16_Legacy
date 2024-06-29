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
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm IS
    GENERIC ( N : INTEGER := 16 );
    PORT (
        -- Inputs
        IR_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        FLAGS_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
		ROM_en : OUT STD_LOGIC;
        PC_inc : OUT STD_LOGIC;
        PC_clr : OUT STD_LOGIC;
        IR_load : OUT STD_LOGIC;
        FLAGS_load : OUT STD_LOGIC;
		Immed_en : OUT STD_LOGIC;
		RAM_we : OUT STD_LOGIC;
		IO_we : OUT STD_LOGIC;
		IN_sel : OUT STD_LOGIC;
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
    ALIAS Z_flag : STD_LOGIC IS FLAGS_data(0);
    ALIAS C_flag : STD_LOGIC IS FLAGS_data(1);
    
    TYPE states_t IS (
        INIT, 
        FETCH, 
        DECODE, 
        EXEC_NOP, 
        EXEC_HALT, 
        EXEC_MOVE, 
        EXEC_LOAD, 
        EXEC_STORE, 
        EXEC_ALU, 
        EXEC_PUSH1, 
        EXEC_PUSH2, 
        EXEC_POP1, 
        EXEC_POP2, 
        EXEC_BRANCH, 
        EXEC_INPUT, 
        EXEC_OUTPUT
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
                    IF(IR_data(15 DOWNTO 11) = "00000") THEN
                        CASE IR_data(1 DOWNTO 0) IS
                            WHEN "01" =>
                                current_state <= EXEC_PUSH1;
                            WHEN "10" =>
                                current_state <= EXEC_POP1;
                            WHEN "11" =>
                                current_state <= EXEC_ALU;
                            WHEN OTHERS =>
                                current_state <= EXEC_NOP;
                        END CASE;
                        
                    ELSIF(IR_data(15 DOWNTO 11) = "00001") THEN
                        current_state <= EXEC_BRANCH;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0001") THEN
                        current_state <= EXEC_MOVE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0010") THEN
                        current_state <= EXEC_STORE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0011") THEN
                        current_state <= EXEC_LOAD;
                        
                    ELSIF(IR_data(15 DOWNTO 12) >= "0100" AND IR_data(15 DOWNTO 12) <=  "1110") THEN
                        current_state <= EXEC_ALU;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "1111") THEN
                        CASE IR_data(1 DOWNTO 0) IS
                            WHEN "01" =>
                                current_state <= EXEC_INPUT;
                            WHEN ("00" OR "10") =>
                                current_state <= EXEC_OUTPUT;
                            WHEN OTHERS =>
                                current_state <= EXEC_HALT;
                        END CASE;
                        
                    END IF;
                    
                WHEN EXEC_HALT => 
                    current_state <= EXEC_HALT;
                    
                WHEN EXEC_NOP | EXEC_MOVE | EXEC_LOAD | EXEC_STORE | EXEC_ALU | EXEC_BRANCH | EXEC_INPUT | EXEC_OUTPUT =>
                    current_state <= FETCH;
                    
                WHEN EXEC_PUSH1 =>
                    current_state <= EXEC_PUSH2;
                     
                WHEN EXEC_PUSH2 =>
                    current_state <= FETCH;
                    
                WHEN EXEC_POP1 =>
                    current_state <= EXEC_POP2;
                     
                WHEN EXEC_POP2 =>
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
                    FLAGS_load <= '0';
                    Immed <= (OTHERS => '0');
                    Immed_en <= '0';
                    RAM_we <= '0';
                    IO_we <= '0';
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
                    FLAGS_load <= '0';
                    Immed_en <= '0';
                    RAM_we <= '0';
                    IO_we <= '0';
                    Rd_wr <= '0';
                    
                WHEN DECODE =>
                    PC_inc <= '0';
                    ROM_en <= '0';
                    IR_load <= '0';
                    Immed_en <= IR_data(11);
                    
                    Rd_sel <= IR_data(10 DOWNTO 8);
                    Rm_sel <= IR_data(7 DOWNTO 5);
                    Rn_sel <= IR_data(4 DOWNTO 2);
                    
                WHEN EXEC_MOVE =>
                    Rd_wr <= '1';
                    IF(IR_data(11) = '1') THEN
                        Immed <= STD_LOGIC_VECTOR( RESIZE( SIGNED( IR_data( 7 DOWNTO 0 ) ), 16 ) );
                        RF_sel <= "01";
                    ELSE
                        RF_sel <= "00";
                    END IF;
                    
                WHEN EXEC_LOAD =>
                    Rd_wr <= '1';
                    RF_sel <= "10";
                    IN_sel <= '0';
                    
                WHEN EXEC_STORE =>
                    RAM_we <= '1';
                    IF(IR_data(11) = '1') THEN
                        Immed <= STD_LOGIC_VECTOR( RESIZE( SIGNED( IR_data( 10 DOWNTO 8 ) & IR_data( 4 DOWNTO 0 ) ), 16 ) );
                    END IF;
                    
                WHEN EXEC_ALU =>
                    FLAGS_load <= '1';
                    RF_sel <= "11";
                    IF(IR_data(15 DOWNTO 12) /= "0000") THEN
                        Rd_wr <= '1';
                        alu_op <= IR_data(15 DOWNTO 12);
                    ELSE
                        alu_op <= "0101";
                    END IF;
                    
                WHEN EXEC_PUSH1 =>
                    RAM_we <= '1';
                    Rm_sel <= "111";
                     
                WHEN EXEC_PUSH2 =>
                    RAM_we <= '0';
                    Immed <= x"0002";
                    Immed_en <= '1';
                    Rd_wr <= '1';
                    alu_op  <= "0101";
                    
                WHEN EXEC_POP1 =>
                    Immed <= x"0002";
                    Immed_en <= '1';
                    Rd_wr <= '1';
                    alu_op  <= "0100";
                    Rm_sel <= "111";
                     
                WHEN EXEC_POP2 =>
                    Immed_en <= '0';
                    RF_sel <= "10";
                    IN_sel <= '0';
                    
                WHEN EXEC_BRANCH =>
                    Immed <= STD_LOGIC_VECTOR( RESIZE( SIGNED( IR_data( 10 DOWNTO 2 ) ), 16 ) );
                    CASE IR_data(1 DOWNTO 0) IS
                        WHEN "00" => -- JMP
                            PC_inc <= '1';
                            
                        WHEN "01" => -- JEQ
                            IF(Z_flag = '1' AND C_flag = '0') THEN
                                PC_inc <= '1';
                            END IF;
                            
                        WHEN "10" => -- JGT
                            IF(Z_flag = '0' AND C_flag = '0') THEN
                                PC_inc <= '1';
                            END IF;
                            
                        WHEN OTHERS => -- JLT
                            IF(Z_flag = '0' AND C_flag = '1') THEN
                                PC_inc <= '1';
                            END IF;
                            
                    END CASE;
                    
                WHEN EXEC_INPUT =>
                    RF_sel <= "10";
                    IN_sel <= '1';
                    Rd_wr <= '1';
                    
                WHEN EXEC_OUTPUT =>
                    IO_we <= '1';
                    IF( IR_data(11) = '1' ) THEN     
                        Immed <= STD_LOGIC_VECTOR( RESIZE( SIGNED( IR_data( 10 DOWNTO 8 ) & IR_data( 4 DOWNTO 2 ) ), 16 ) );
                    END IF;
                
                WHEN OTHERS =>
            END CASE;
    END PROCESS;
END hardware;
