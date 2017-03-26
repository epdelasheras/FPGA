----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras 
-- 
-- Create Date:  08:50:03 07/10/2008 
-- Project Name: remove bounces
-- Target Devices: all FPGAs families
-- Description: remove pushbutton bounces with a three stages shift register.
--
-- Revision 0.0 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity remove_bounces is
  port (
  	clk    : in  std_logic;
  	rst    : in  std_logic;
  	button : in  std_logic;
  	output : out std_logic
	);
end remove_bounces;

architecture Behavioral of remove_bounces is

	signal shift_reg : std_logic_vector(2 downto 0);

begin	 -- architecture behavioral

	SHIFT_REG_PROC : process(clk, rst) is
	begin
		if rst='1' then
			shift_reg <= "000";
		elsif (clk'event and clk='1')	then
			shift_reg <= button & shift_reg(2 downto 1);
		end if;
	end process SHIFT_REG_PROC;

	output <= shift_reg(2) and shift_reg(1) and shift_reg(0);

end Behavioral;
