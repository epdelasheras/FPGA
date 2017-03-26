
--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras
--
-- Create Date:   16:59:17 04/24/2008
-- Design Name:   gen_uart
-- Module Name:   gen_uart_TB.vhd
-- Project Name:  uart
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: gen_uart
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY gen_uart_TB_vhd IS
END gen_uart_TB_vhd;

ARCHITECTURE behavior OF gen_uart_TB_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT gen_uart
	PORT(
		clk     : IN std_logic;
		rst     : IN std_logic;
		ena     : IN std_logic;
		tx_data : IN std_logic_vector(7 downto 0);
		tx_load : IN std_logic;
		rx      : IN std_logic;          
		tx_rdy  : OUT std_logic;
		rx_data : OUT std_logic_vector(7 downto 0);
		rx_ok   : OUT std_logic;
		rx_rdy  : OUT std_logic;
		tx      : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '0';
	SIGNAL ena :  std_logic := '0';
	SIGNAL tx_load :  std_logic := '0';
	SIGNAL rx :  std_logic := '1';
	SIGNAL tx_data :  std_logic_vector(7 downto 0) := (others=>'0');

	--Outputs
	SIGNAL tx_rdy :  std_logic;
	SIGNAL rx_data :  std_logic_vector(7 downto 0);
	SIGNAL rx_ok :  std_logic;
	SIGNAL rx_rdy :  std_logic;
	SIGNAL tx :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: gen_uart PORT MAP(
		clk => clk,
		rst => rst,
		ena => ena,
		tx_data => tx_data,
		tx_load => tx_load,
		tx_rdy => tx_rdy,
		rx_data => rx_data,
		rx_ok => rx_ok,
		rx_rdy => rx_rdy,
		tx => tx,
		rx => rx
	);
    
    clk <= not clk after 20 ns;
    
    -- Note: This Test Bench will work properly if
    -- rate = 2*clk --> RATE_CNT = "000001"

	tb : PROCESS
	BEGIN

        --**************Receivind data**********
        rst <= '0';
        ena <= '0'; -- reset rate counter        
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
        -- Place stimulus here
        rst <= '1';
        ena <= '1'; -- start rate counter
        rx <= '0'; -- start bit
        wait for 740 ns;
        for i in 0 to 7 loop
            rx <= not rx;
            wait for 1240 ns;
        end loop;
        rx <= '1'; -- Stop bit
        wait for 2480 ns;
        --***********Transmitting data*********
        rst <= '0';
        ena <= '0';
        tx_data <= x"5F";
        wait for 100 ns;
        rst <= '1';
        ena <= '1';
        tx_load <= '1';       
		wait; -- will wait forever
	END PROCESS;

END;
