-------------------------------------------------------------------------------
--! Company:
--! Engineer: Enrique Pérez de las Heras

--! Create Date:    11:52:43 04/17/2008 
--! Module Name:    GenericMux - Behavioral 
--! Project Name:   Component Generic MUX

--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a generic asynchronous multiplexor 

--! Revision 0.01 - File Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity GenericMux is

generic(
    size_select  : integer := 3 --! Number of selection lines.
);
    
Port( 
    input           : in   std_logic;
    selection       : in   std_logic_vector (size_select-1 downto 0);  
    output          : out  std_logic_vector (2**size_select-1 downto 0)
);

end GenericMux;

architecture Behavioral of GenericMux is

begin

    -- It's very easy. Selection is converted to integer to select the right
    -- output
    output(conv_integer(selection)) <= input;

end Behavioral;