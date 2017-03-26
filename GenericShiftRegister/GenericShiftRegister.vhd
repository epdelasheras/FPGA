----------------------------------------------------------------------------------
-- Company: Indra
-- Engineer: Enrique Perez
-- 
-- Create Date:    12:58:03 03/06/2013 
-- Design Name: 
-- Module Name:    GenericShiftRegister - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: XILINX ISE 12.1
-- Description: Left7Right generic shift register with 
--              serial input and parallel output.
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GenericShiftRegister is
	Generic (width : integer:= 4);
    Port ( SerialInput : in  STD_LOGIC;
		     ce : in  STD_LOGIC; -- chip enable
             rst : in  STD_LOGIC; -- reset
             clk : in  STD_LOGIC; -- master clock
		     lr : in STD_LOGIC; -- left/right shift
		     SerialOutput : out STD_LOGIC;
             ParallelOutput : out  STD_LOGIC_VECTOR (width-1 downto 0));
end GenericShiftRegister;

architecture Behavioral of GenericShiftRegister is

constant ACTIVE : std_logic:= '1';
signal ParallelOutput_s: STD_LOGIC_VECTOR (width-1 downto 0);

begin

GenericShiftRegister: process (rst, clk)
	begin
		if rst = ACTIVE then
			ParallelOutput_s <= (others => '0');
		elsif rising_edge (clk) then
			if ce = ACTIVE then
				if lr = ACTIVE then -- left shift
					ParallelOutput_s <= ParallelOutput_s (width-2 downto 0) & SerialInput;
				else -- right shift
					ParallelOutput_s <= SerialInput & ParallelOutput_s (width-1 downto 1) ;
				end if;
			else
				ParallelOutput_s <= ParallelOutput_s;
			end if;
		end if;
	end process;
	
	ParallelOutput <= ParallelOutput_s;
	SerialOutput <= ParallelOutput_s(width -1) when lr = ACTIVE else ParallelOutput_s(0);

end Behavioral;

