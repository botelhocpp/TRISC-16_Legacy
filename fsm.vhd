----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: fsm
-- Project Name: TRISC-16
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Controls the processor instruction execution.
-- Observation: Uses Mealy machine model.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY WORK;
USE WORK.TRISC_PARAMETERS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm IS
    GENERIC ( N : INTEGER := kWORD_SIZE );
    PORT (
        -- Inputs
        IR_data : IN word_t;
        FLAGS_data : IN word_t;
        
        -- Common
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        
        -- Control Signals
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
        
        -- Outputs
        Immed : OUT word_t
    );
END fsm;

ARCHITECTURE hardware OF fsm IS
    ALIAS Z_flag : STD_LOGIC IS FLAGS_data(0);
    ALIAS C_flag : STD_LOGIC IS FLAGS_data(1);
    
    SIGNAL current_state : states_t;
    
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
                    IF(IR_data = x"0000") THEN
                        current_state <= EXEC_NOP;
                    
                    ELSIF(IR_data = x"FFFF") THEN
                        current_state <= EXEC_HALT;
                    
                    ELSIF(IR_data(15 DOWNTO 12) = "0000") THEN
                        current_state <= EXEC_BRANCH;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0001") THEN
                        current_state <= EXEC_MOVE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0010") THEN
                        current_state <= EXEC_STORE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "0011") THEN
                        current_state <= EXEC_LOAD;
                        
                    ELSIF(IR_data(15 DOWNTO 12) >= "0100" AND IR_data(15 DOWNTO 12) <=  "1101") THEN
                        current_state <= EXEC_ALU;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "1110") THEN
                        current_state <= EXEC_PROCEDURE;
                        
                    ELSIF(IR_data(15 DOWNTO 12) = "1111") THEN
                        CASE IR_data(1 DOWNTO 0) IS
                            WHEN "00" =>
                                current_state <= EXEC_OUTPUT;
                            WHEN "01" =>
                                current_state <= EXEC_INPUT;
                            WHEN "10" =>
                                current_state <= EXEC_PUSH1;
                            WHEN OTHERS =>
                                current_state <= EXEC_POP1;
                        END CASE;
                        
                    END IF;
                    
                WHEN EXEC_HALT => 
                    current_state <= EXEC_HALT;
                    
                WHEN EXEC_NOP | EXEC_BRANCH | EXEC_MOVE | EXEC_LOAD | EXEC_STORE | EXEC_ALU | EXEC_PROCEDURE | EXEC_INPUT | EXEC_OUTPUT =>
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
    PROCESS(current_state, IR_data, Z_flag, C_flag)
    BEGIN
        -- Reset state
        PC_load <= '0';
        PC_sel <= '0';
        ROM_en <= '0';
        IR_load <= '0';
        FLAGS_load <= '0';
        Immed <= (OTHERS => '0');
        RAM_we <= '0';
        IO_we <= '0';
        RF_sel <= "00";
        Rd_wr <= '0';
        alu_op <= ALU_MOV_A;
            
        -- Operands
        Immed_en <= IR_data(11);
        Rd_sel <= IR_data(10 DOWNTO 8);
        Rm_sel <= IR_data(7 DOWNTO 5);
        Rn_sel <= IR_data(4 DOWNTO 2);
        
        CASE current_state IS
            WHEN INIT =>
                -- Init SP
                Immed <= x"FFF0";
                Immed_en <= '1';
                Rd_wr <= '1';
                Rd_sel <= "111";
                alu_op <= ALU_MOV_B;
                
            WHEN FETCH => 
                PC_load <= '1';
                ROM_en <= '1';
                IR_load <= '1';
                Immed_en <= '0';
                
            WHEN EXEC_BRANCH =>
                Immed <= word_t(RESIZE(SHIFT_LEFT(SIGNED(IR_data(10 DOWNTO 2)), 1), N));
                
                alu_op <= ALU_MOV_B;
                
                CASE IR_data(1 DOWNTO 0) IS
                    WHEN "00" => -- BEQ
                        IF(Z_flag = '1' AND C_flag = '0') THEN
                            PC_load <= '1';
                        END IF;
                        
                    WHEN "01" => -- BLT
                        IF(Z_flag = '0' AND C_flag = '1') THEN
                            PC_load <= '1';
                        END IF;
                        
                    WHEN "10" => -- BGT
                        IF(Z_flag = '0' AND C_flag = '0') THEN
                            PC_load <= '1';
                        END IF;
                        
                    WHEN OTHERS => -- JMP
                        PC_load <= '1';
                        IF(IR_data(11) = '0') THEN              
                            PC_sel <= '1';
                        END IF;
                        
                END CASE;
                
            WHEN EXEC_MOVE =>
                Rd_wr <= '1';
                alu_op <= ALU_MOV_B;
                IF(IR_data(11) = '1') THEN
                    Immed <= word_t(RESIZE(SIGNED(IR_data(7 DOWNTO 0)), N));
                END IF;
                
            WHEN EXEC_STORE =>
                RAM_we <= '1';
                IF(IR_data(11) = '1') THEN
                    Immed <= word_t(RESIZE(SHIFT_LEFT(UNSIGNED(IR_data(10 DOWNTO 8) & IR_data(1 DOWNTO 0)), 1), N));
                    alu_op <= ALU_ADD;
                ELSE
                    alu_op <= ALU_MOV_A;
                END IF;
                
            WHEN EXEC_LOAD =>
                Rd_wr <= '1';
                RF_sel <= "10";
                IF(IR_data(11) = '1') THEN
                    Immed <= word_t(RESIZE(SHIFT_LEFT(UNSIGNED(IR_data(4 DOWNTO 0)), 1), N));
                    alu_op <= ALU_ADD;
                ELSE
                    alu_op <= ALU_MOV_A;
                END IF;
                
            WHEN EXEC_ALU =>
                FLAGS_load <= '1';
                
                IF(IR_data(11) = '1') THEN 
                    Immed <= word_t(RESIZE(UNSIGNED(IR_data(4 DOWNTO 0)), N));
                END IF;
                
                CASE IR_data(15 DOWNTO 12) IS
                    WHEN "0100" => alu_op <= ALU_ADD;
                    WHEN "0101" => alu_op <= ALU_SUB;
                    WHEN "0110" => alu_op <= ALU_MUL;
                    WHEN "0111" => alu_op <= ALU_AND;
                    WHEN "1000" => alu_op <= ALU_ORR;
                    WHEN "1001" => alu_op <= ALU_NOT;
                    WHEN "1010" => alu_op <= ALU_XOR;
                    WHEN "1011" => alu_op <= ALU_SHR;
                    WHEN "1100" => alu_op <= ALU_SHL;
                    WHEN "1101" => alu_op <= ALU_SUB;
                    WHEN OTHERS =>
                END CASE;
                                    
                IF(IR_data(15 DOWNTO 12) /= "1101") THEN
                    Rd_wr <= '1';
                END IF;
                
            WHEN EXEC_PROCEDURE =>
                -- Save PC in LR
                RF_sel <= "01";
                Rd_sel <= "110";
                Rd_wr <= '1';
                
                -- Set new PC
                PC_load <= '1';
                alu_op <= ALU_MOV_B;
                
                IF(IR_data(11) = '1') THEN 
                    Immed <= word_t(RESIZE(SHIFT_LEFT(SIGNED(IR_data(10 DOWNTO 0)), 1), N));
                ELSE
                    PC_sel <= '1';
                END IF;
                
            WHEN EXEC_PUSH1 =>
                RAM_we <= '1';
                Rm_sel <= "111";
                alu_op  <= ALU_MOV_A;
                 
            WHEN EXEC_PUSH2 =>
                Immed <= x"0002";
                Immed_en <= '1';
                Rd_wr <= '1';
                Rd_sel <= "111";
                Rm_sel <= "111";
                alu_op  <= ALU_SUB;
                
            WHEN EXEC_POP1 =>
                Immed <= x"0002";
                Immed_en <= '1';
                Rd_wr <= '1';
                Rd_sel <= "111";
                Rm_sel <= "111";
                alu_op  <= ALU_ADD;
                 
            WHEN EXEC_POP2 =>
                Rd_wr <= '1';
                RF_sel <= "10";
                Rm_sel <= "111";
                alu_op  <= ALU_MOV_A;
                
            WHEN EXEC_INPUT =>
                Rd_wr <= '1';
                RF_sel <= "11";
                alu_op <= ALU_MOV_A;
                
            WHEN EXEC_OUTPUT =>
                IO_we <= '1';
                alu_op <= ALU_MOV_A;
            
            WHEN OTHERS =>
        END CASE;
    END PROCESS;
END hardware;