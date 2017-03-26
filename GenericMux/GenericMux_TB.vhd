
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:39:45 04/21/2008
-- Design Name:   GenericMux
-- Module Name:   GenericMux_TB.vhd
-- Project Name:  kk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GenericMux
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

entity GenericMux_TB_vhd is
generic(
        size_select  : integer := 3    
    );
end GenericMux_TB_vhd;

architecture behavior of GenericMux_TB_vhd is

	-- Component Declaration for the Unit Under Test (UUT)
	component GenericMux
	port(
        input           : in   std_logic;
        selection       : in   std_logic_vector (size_select-1 downto 0);
        output          : out  std_logic_vector (2**size_select-1 downto 0)
	);
    end component;

	--Inputs
	signal input_s     :  std_logic := '0';
	signal selection_s :  std_logic_vector(size_select-1 downto 0) := (others => '0');

	--Outputs
	signal output_s    :  std_logic_vector(2**size_select-1 downto 0) := (others => '0');

begin

	-- Instantiate the Unit Under Test (UUT)
	COMPONENT_MUX: GenericMux 
    port map(
		   input     => input_s,
		   selection => selection_s,
		   output    => output_s
	);

	TEST : process    
	begin
		input_s <= '0';
        -- Wait 10 ns for global reset to finish
		wait for 10 ns;
        input_s <= '1';
        wait for 5 ns;
        for i in 0 to 7 loop
            selection_s <= selection_s + 1;
            wait for 5 ns;
        end loop;        
        wait;
	end process;

end;
