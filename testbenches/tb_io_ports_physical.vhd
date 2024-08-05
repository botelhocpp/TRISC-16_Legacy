	----------------------------------------------------------------------------------
	-- Engineer: Pedro Botelho
	-- 
	-- Module Name: tb_io_ports_physical
	-- Project Name: TRISC-16
	-- Target Devices: Zybo Zynq-7000
	-- Language Version: VHDL-2008
	-- Description: Testbench for the 'io_ports' module.
	-- 
	-- Dependencies: io_ports
	-- 
	----------------------------------------------------------------------------------

	LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;

	ENTITY tb_io_ports_physical IS
	GENERIC ( N : INTEGER := 16 );
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
	);
	END tb_io_ports_physical;

	ARCHITECTURE behaviour OF tb_io_ports_physical IS
		COMPONENT io_ports IS
		GENERIC( N : INTEGER := N );
		PORT (
			din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			addr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			we : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			pin_port : INOUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
		END COMPONENT;
		
		SIGNAL din : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		SIGNAL addr : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		SIGNAL we : STD_LOGIC;
		SIGNAL dout : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		
		SIGNAL int_data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		
		TYPE states_t IS ( RESET, READ, WRITE );
		SIGNAL current_state : states_t;
		
	BEGIN
		IO_PORTS_COMP : io_ports PORT MAP (
			din => din,
			addr => addr,
			we => we,
			clk => clk,
			rst => rst,
			dout => dout,
			pin_port => pin_port
		);
		
		-- FSM
		PROCESS(clk, rst)
		BEGIN 
			IF(rst = '1') THEN  
				current_state <= RESET;
			ELSIF(RISING_EDGE(clk)) THEN
				CASE current_state IS
					WHEN RESET =>
						current_state <= READ;
					WHEN READ =>
						current_state <= WRITE;
					WHEN WRITE =>
						current_state <= READ;
					WHEN OTHERS =>
				END CASE;
			END IF; 
		END PROCESS;
		
		-- Output logic
		PROCESS(current_state, pin_port)
		BEGIN 
			CASE current_state IS
				WHEN RESET =>
					din <= x"000F";
					addr <= x"0000";
					we <= '1';
				
				WHEN READ =>
					int_data <= dout;
					addr <= x"0004";
					we <= '0';
				
				WHEN WRITE =>
					din <= (0 => int_data(4), 1 => int_data(5), 2 => int_data(6), 3 => int_data(7), OTHERS => 'Z');
					addr <= x"0002";
					we <= '1';
					
				WHEN OTHERS =>
			END CASE;
		END PROCESS;
		
	END behaviour;
