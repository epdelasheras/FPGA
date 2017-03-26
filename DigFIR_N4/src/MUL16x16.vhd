----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2017 11:42:27 AM
-- Design Name: 
-- Module Name: FIR_FILTER_N2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
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
-- arithmetic functions with UNSIGNED or UnUNSIGNED values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; --unsigned arithmetics library 
use ieee.std_logic_signed.all; --unsigned arithmetics library


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUL16x16 is    
    Port ( 
		CLK      :in STD_LOGIC;
		X        :in  SIGNED (15 downto 0);
        Y        :in  SIGNED (15 downto 0);
        W        :out SIGNED (31 downto 0)        
    );
end MUL16x16;

architecture Behavioral of MUL16x16 is

signal W_AUX : SIGNED (31 downto 0);

begin

W_AUX <= X*Y;

process(CLK)
begin
	if rising_edge (CLK) then
		W <= W_AUX;
	end if;
end process;

end Behavioral;