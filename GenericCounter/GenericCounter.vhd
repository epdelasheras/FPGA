----------------------------------------------------------------------------------
--! Company: 
--! Engineer: Enrique Pérez de las Heras
--! 
--! Create Date:    12:42:26 22/04/2008 
--! Module Name:    GenericCounter - Behavioral
--! Project Name:   Generic Counter
--!
--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a down generic counter with a zero cross
--!              detection.

--! Revision 0.01 - File Created
--!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity GenericCount is
generic(
    size_counter : integer := 32
);
port (
    clk      : in std_logic;                           --! System clock
    rst      : in std_logic;                           --! System reset    
    load     : in std_logic_vector (size_counter-1 downto 0); --! Count to start to descent count
    cs       : in std_logic;                           --! Counter enable
    save     : in std_logic;                           --! Flag to save current count
    result   : out std_logic_vector (size_counter-1 downto 0);--! When active "save" flag
                                                       --! result = current count
    done     : out std_logic                           --! Active this flag when count = 0
);
end GenericCount;

architecture behavioral of GenericCount is

    constant DONE_VALUE     : std_logic_vector(size_counter - 1 downto 0) := (others => '0');
    
    signal count : std_logic_vector (size_counter - 1 downto 0); -- it's the variable to decrease the count
    signal zero  : std_logic;                                    -- like "done"
    
begin

    -- This process is the counter logic. Firstly load the count and after start
    -- to decrease the cout if flags "cs" and "zero" are configured properly.
    COUNTER: process (clk, rst)
    begin
        if rst = '1' then
            count <= (others => '0');
        elsif rising_edge (clk) then
            if cs = '1' and zero = '0' then
                count <= count - 1;
            else
                count <= load;
            end if;
        end if;
    end process;
    
    -- When flag "save" is actived, result = current count 
    SAVECOUNT: process (clk, rst)
    begin
        if rst = '1' then
            result <= (others => '0');
        elsif rising_edge (clk) then
            if save = '1' then
                result <= count;
            end if;
        end if;
    end process;
    
    -- Detecting count = min value = 0
    zero <= '1' when count = DONE_VALUE else '0';
    
    done <= zero;
    
end behavioral;