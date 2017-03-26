----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras
-- 
-- Create Date: 03/08/2017 11:42:27 AM
-- Design Name: 
-- Module Name: FIR_FILTER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: FIR filter order N = 4
-- 
-- Revision: 0.0
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

entity FIR_FILTER is
    Generic ( DEBUG   : BOOLEAN  := false);              -- True for simulations		      
    Port ( CLK        : in STD_LOGIC;
           RST        : in STD_LOGIC;
           FILTER_IN  : in STD_LOGIC_VECTOR (15 downto 0);
           FILTER_OUT : out STD_LOGIC_VECTOR (15 downto 0));
end FIR_FILTER;

architecture Behavioral of FIR_FILTER is

-- FIR coefficients.
type FIR_COEFF is array (0 to 3) of signed (7 downto 0); 
signal B : FIR_COEFF;

-- Multiplication signals
type X_ARRAY is array (0 to 3) of signed (15 downto 0); 
signal X : X_ARRAY;
type W_ARRAY is array (0 to 3) of signed (31 downto 0); 
signal W : W_ARRAY;
signal Y : signed (15 downto 0);
type MUL_ARRAY is array (0 to 3) of signed (31 downto 0); 
signal MUL : MUL_ARRAY;

-- Addings signals
signal TAP_CNT : unsigned (7 downto 0);
signal Z1 : signed (31 downto 0);
signal Z2 : signed (31 downto 0);
signal Z3 : signed (31 downto 0);
signal ADD1 : signed (31 downto 0);
signal ADD2 : signed (31 downto 0);
signal ADD3 : signed (31 downto 0);

begin

-- FIR filter Coefficients.
B(0) <=  x"2D";
B(1) <=  x"0F";
B(2) <=  x"0F";
B(3) <=  x"2D";

--Multiplication
gen_MULT16x16 : for I in 0 to 3 generate
	X(I) <= resize(B(I), X(I)'length);
	Y <= signed(FILTER_IN);
	i_MUL16x16: entity work.MUL16x16
		port map (	
			CLK      => CLK,
			X        => X(I),
			Y        => Y,
			W        => W(I)
		);    
	MUL(I)<=W(I);
end generate gen_MULT16x16;

-- Addings.
process (RST,CLK)
begin
	if RST = '1' then
		TAP_CNT <= (others => '0');		
	elsif rising_edge (CLK) then
		if TAP_CNT = 0 then
			Z1 <= MUL(3);
			TAP_CNT	<= TAP_CNT + 1;
		elsif TAP_CNT = 1 then
			ADD1 <= Z1 + MUL(2);
			TAP_CNT	<= TAP_CNT + 1;
		elsif TAP_CNT = 2 then
			Z2 <= ADD1;
			TAP_CNT	<= TAP_CNT + 1;
		elsif TAP_CNT = 3 then			
			ADD2 <= Z2 + MUL(1);
			TAP_CNT	<= TAP_CNT + 1;
		elsif TAP_CNT = 4 then						
			Z3 <= ADD2;
			TAP_CNT	<= TAP_CNT + 1;
		elsif TAP_CNT = 5 then									
			ADD3 <= Z3 + MUL(0);
			TAP_CNT <= (others => '0');		
		end if;				
	end if;
end process;

FILTER_OUT <= std_logic_vector(resize((ADD3/100),FILTER_OUT'length));

end Behavioral;
