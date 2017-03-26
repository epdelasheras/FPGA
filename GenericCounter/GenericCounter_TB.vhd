
--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras
--
-- Create Date:   15:54:32 04/22/2008
-- Design Name:   GenericCount
-- Module Name:   GenericCounter_TB.vhd
-- Target Device:  
-- Tool versions:  XILINX ISE 8.2.1
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GenericCount
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

ENTITY GenericCounter_TB_vhd IS
END GenericCounter_TB_vhd;

ARCHITECTURE behavior OF GenericCounter_TB_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT GenericCount
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		load : IN std_logic_vector(31 downto 0);
		cs : IN std_logic;
		save : IN std_logic;          
		result : OUT std_logic_vector(31 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '0';
	SIGNAL cs :  std_logic := '0';
	SIGNAL save :  std_logic := '0';
	SIGNAL load :  std_logic_vector(31 downto 0) := x"00000032";

	--Outputs
	SIGNAL result :  std_logic_vector(31 downto 0);
	SIGNAL done :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: GenericCount PORT MAP(
		clk => clk,
		rst => rst,
		load => load,
		cs => cs,
		save => save,
		result => result,
		done => done
	);

	tb : PROCESS
	BEGIN
        
        rst <= '1';
        cs <= '0';
        save <= '0';       
		-- Wait 100 ns for global reset to finish
		wait for 50 ns;
        -- Place stimulus here
        rst <= '0';
        cs <= '1';
        wait for 20 ns;
        save <= '1';
        wait for 20 ns;
        save <= '0';
		wait; -- will wait forever
	END PROCESS;
    
    clk <= not clk after 5 ns;

END;
