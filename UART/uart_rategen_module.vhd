----------------------------------------------------------------------------------
--! Company: 
--! Engineer: Enrique Pérez de las Heras
--! 
--! Create Date:    12:42:26 22/04/2008 
--! Module Name:    uart_rategen_module - Behavioral
--! Project Name:   Component UART RATE GENERATOR
--!
--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a generic UART rate generator

--! Revision 0.01 - File Created
--!
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity uart_rategen_module is

port(
    clk     : in std_logic; --! System CLK
    rst     : in std_logic; --! System Reset. Low level active
    ena     : in std_logic; --! Reset tick generate rate counter. Low level active
    rate    : out std_logic --! CLK rate
);

end uart_rategen_module;

architecture behavioral of uart_rategen_module is
	
    signal counter : std_logic_vector (5 downto 0);
    
    -- Rate counter limits:
    
    -- 300
    -- 1200
    -- 2400
    -- 4800
    -- 9600
    -- 19200
    -- 38400
    -- 57600
    -- 115200
    
    -- These values are calculated as: integer = [Fclk(Hz)/(BRate * 16)] - 1.
    -- For example: if you wish a 115200 rate with 50 Mhz of System CLK:
    -- RATE_CNT := (50*10^6/16*115200)-1 := 27.16 := 26 (integer) := 011010 (bin)
    constant RATE_CNT : std_logic_vector (5 downto 0) := "000001";   -- to Test Bench -> RATE_CNT := "000001"

begin

    RGEN: process (clk, rst)
    begin
    
        if rst = '0' then
            counter <= (others => '0');
            rate <= '0';
        elsif rising_edge (clk) then
            if ena = '0' then
                counter <= (others => '0');
            else
                if counter = RATE_CNT then
                    counter <= (others => '0');
                    rate <= '1';
                else
                    counter <= counter + 1;
                    rate <= '0';
                end if;
            end if;
        end if;
        
    end process;
    
end behavioral;