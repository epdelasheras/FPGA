----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Enrique Perez de las Heras
-- 
-- Create Date: 03/07/2017 09:26:30 AM
-- Design Name: 
-- Module Name: WaveGenerator - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.all;
--use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WaveGenerator is
    Generic ( DEBUG     : BOOLEAN  := false;-- True for simulations
	          ROM_DEPTH : INTEGER  := 100); -- Number of items of the ROM
    Port    ( CLK         : in STD_LOGIC;   -- Input Clock
              RST         : in STD_LOGIC;   -- High level reset			  
              WAVE_GEN    : out STD_LOGIC_VECTOR (15 downto 0)); -- Waveform data output
end WaveGenerator;

architecture Behavioral of WaveGenerator is

-- Signals to generate the waveform
signal dataout     : signed (15 downto 0);
signal table_index       : integer range 0 to ROM_DEPTH;
signal table_index_down  : std_logic; -- table_index_down = '1' => walk down the table; ='0' walk up the table
--ROM for storing the table values generated by MATLAB for the 
-- 1/4 of a sinus signal
-- type table_type is array (0 to ROM_DEPTH-1) of integer range 0 to 65535; 
-- signal table : table_type :=(
     -- 0    ,16   ,65	  ,145	,258  ,403  ,580  ,789  ,1029 ,1301 ,
	 -- 1604 ,1937 ,2301 ,2695 ,3119 ,3571 ,4053 ,4563 ,5101 ,5666 ,
	 -- 6258 ,6876 ,7520 ,8188 ,8881 ,9597 ,10336,11098,11881,12684,
	 -- 13507,14349,15210,16087,16981,17891,18815,19754,20705,21668,
	 -- 22641,23625,24618,25619,26627,27641,28660,29683,30710,31738,
	 -- 32767,33796,34824,35851,36874,37893,38907,39915,40916,41909,
	 -- 42893,43866,44829,45780,46719,47643,48553,49447,50324,51185,
	 -- 52027,52850,53653,54436,55198,55937,56653,57346,58014,58658,
	 -- 59276,59868,60433,60971,61481,61963,62415,62839,63233,63597,
	 -- 63930,64233,64505,64745,64954,65131,65276,65389,65469,65518
	 -- );

--ROM for storing the table values generated by MATLAB for the 
-- 1/4 of a 500KHz sinus signal from -32768 to 32767
 -- type table_type is array (0 to ROM_DEPTH-1) of integer range -32768 to 32767; 
 -- signal table : table_type :=(
      -- -32767,-32751,-32702,-32622,-32509,-32364,-32187,-31978,-31738,-31466,
	  -- -31163,-30830,-30466,-30072,-29648,-29196,-28714,-28204,-27666,-27101,
	  -- -26509,-25891,-25247,-24579,-23886,-23170,-22431,-21669,-20886,-20083,
	  -- -19260,-18418,-17557,-16680,-15786,-14876,-13952,-13013,-12062,-11099,
	  -- -10126,-9142 ,-8149 ,-7148 ,-6140 ,-5126 ,-4107 ,-3084 ,-2057 ,-1029 ,
	  -- 0     ,1029  ,2057  ,3084  ,4107  ,5126  ,6140  ,7148  ,8149  ,9142  ,
	  -- 10126 ,11099 ,12062 ,13013 ,13952 ,14876 ,15786 ,16680 ,17557 ,18418 ,
	  -- 19260 ,20083 ,20886 ,21669 ,22431 ,23170 ,23886 ,24579 ,25247 ,25891 ,
	  -- 26509 ,27101 ,27666 ,28204 ,28714 ,29196 ,29648 ,30072 ,30466 ,30830 ,
	  -- 31163 ,31466 ,31738 ,31978 ,32187 ,32364 ,32509 ,32622 ,32702 ,32751 	
	  -- );	

--ROM for storing the table values generated by MATLAB for the 
-- 1/4 of a 3.3MHz sinus signal from -32768 to 32767
-- type table_type is array (0 to ROM_DEPTH-1) of integer range -32768 to 32767; 
-- signal table : table_type :=(
     -- -32767,-32065,-29990,-26630,-22129,-16680,-10516,-3902,2879,2879,	     
	  -- 9536 , 15786, 21359, 26017, 29560, 31837 	
	-- );		 

type table_type is array (0 to ROM_DEPTH-1) of integer range -32768 to 32767; 
signal table : table_type :=(
         -32767,-32702,-32509,-32187 ,-31738,-31163,-30466,-29648,-28714,
	     -27666,-26509,-25247,-23886 ,-22431,-20886,-19260,-17557,-15786,
	     -13952,-12062,-10126,-8149  ,-6140 ,-4107 ,-2057 ,0     ,2057  ,
	     4107  , 6140 , 8149 , 10126 ,12062 ,13952 ,15786 ,17557 ,19260 ,
	     20886 , 22431, 23886, 25247 ,26509 ,27666 ,28714 ,29648 ,30466 ,
	     31163 , 31738, 32187, 32509 ,32702
	    );		 
	
--type table_type is array (0 to ROM_DEPTH-1) of integer range -32768 to 32767; 
--signal table : table_type :=(
	--  -32767 ,-18418, 12062, 31978
	 --);		 

	
begin
	
	--Process to generate the signal
	process(CLK,RST)
	begin
		if RST = '1' then
			table_index <= 0;
			table_index_down <= '0';
			dataout <= to_signed(table(0),dataout'length)/2;
		elsif rising_edge(CLK) then 			
			-- walking the table    
			if table_index_down = '0' then -- walk up the table
				if table_index < ROM_DEPTH-1 then
					table_index <= table_index + 1;
				else			
					table_index_down <= '1';
					table_index      <= table_index;
				end if;
			else                           -- walk down the table
				if table_index > 0 then			
					table_index <= table_index - 1;
				else
					table_index_down <= '0';
					table_index      <= table_index;
				end if;
			end if;
		dataout <= to_signed(table(table_index),dataout'length)/2;				        	
		end if;
	end process;

	-- Output of the SignalGenerator.
	WAVE_GEN <= std_logic_vector (dataout);


end Behavioral;