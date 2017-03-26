--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:10:19 03/07/2013
-- Design Name:   
-- Module Name:   GenericShiftRegister_TB.vhd
-- Project Name:  TEST
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ShiftRegister
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY GenericShiftRegister_TB IS
END GenericShiftRegister_TB;
 
ARCHITECTURE behavior OF GenericShiftRegister_TB IS 

	 -- Constants
	 constant ACTIVE : STD_LOGIC := '1';
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ShiftRegister
    PORT(
         SerialInput : IN  std_logic;
         ce : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         lr : IN  std_logic;
         SerialOutput : OUT  std_logic;
         ParallelOutput : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SerialInput : std_logic := '0';
   signal ce : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal lr : std_logic := '0';

 	--Outputs
   signal SerialOutput : std_logic;
   signal ParallelOutput : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ShiftRegister PORT MAP (
          SerialInput => SerialInput,
          ce => ce,
          rst => rst,
          clk => clk,
          lr => lr,
          SerialOutput => SerialOutput,
          ParallelOutput => ParallelOutput
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
		ce <= '0';
		SerialInput <= '1';
		lr <= '1'; -- left shift.
		--lr <= '0'; -- right shift.
		-- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '0';
		ce <= '1';
      wait for clk_period*10;
      -- insert stimulus here
      wait;
   end process;

END;
