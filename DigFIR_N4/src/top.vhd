----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras
-- 
-- Create Date: 03/07/2017 09:48:10 AM
-- Design Name: 
-- Module Name: top - Behavioral
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
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  generic (
    DEBUG             : boolean := false    -- True in Simu Only
  );
port (
  -- Generic Ports
  CLK         : in    std_logic;  -- 200 MHz
  RESET       : in    std_logic;  -- External reset
  PB          : in    std_logic_vector (3 downto 0); -- Push Buttons
  LED         : out   std_logic_vector (7 downto 0); -- Leds     
  -- IIR Filter
  FILTER_IN      : in    std_logic_vector (15 downto 0);
  FILTER_OUT     : out   std_logic_vector (15 downto 0)
  );

end top;

architecture Behavioral of top is

constant FIR_WIDTH : positive := 20;
signal X : std_logic_vector (FIR_WIDTH-1 downto 0);
signal Y : std_logic_vector (FIR_WIDTH-1 downto 0);

begin


  UUT_FIR_FILTER: entity work.FIR_FILTER 
    generic map (
      DEBUG => DEBUG
    )  
	port map (		    
	    CLK        => CLK,
	    RST        => RESET,
        FILTER_IN  => FILTER_IN,
        FILTER_OUT => FILTER_OUT
    ); 
	
  X <= std_logic_vector(resize(unsigned(FILTER_IN), X'length)); 
  

end Behavioral;
