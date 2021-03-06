	---------------------------------------------------------------
-- Copyright    : 
-- Contact      : 
-- Project Name : 
-- Block Name   : 
-- Description  : 
-- Author       : 
-- Date         : 
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library unisim;
--use unisim.vcomponents.all;


entity top_tb is
	generic (
	    DEBUG             : boolean := true    -- True in Simu Only
	);
end top_tb;

architecture testbench of top_tb is


  -- -------------------------
  -- Top constants and signals
  -- -------------------------  
  constant CLK_T : time := 5 ns; -- 200MHz
  signal CLK     : std_logic := '0';  
  signal RESET   : std_logic := '1';      
  
begin    

  -- ----------------------------------------------------
  --  MODULES INSTANTIATION
  -- ----------------------------------------------------  

  --FILTER_IN <= x"0001";
  UUT_Top: entity work.top 
    generic map (
      DEBUG       => DEBUG,
	  ftw_width   => 32,
	  data_length => 16,
	  bits_resol  => 16,
	  taps        => 15, -- order + 1
	  hn          => (0.020409034,
					  0.027280282,
					  0.041597363,
					  0.057052962,
					  0.07189111,
					  0.084242014,
					  0.092422163,
					  0.095287803,
					  0.092422163,
					  0.084242014,	
					  0.07189111,
					  0.057052962,
					  0.041597363,
					  0.027280282,
					  0.020409034,
                      others=>0.0)
    )  
	port map (	
		-- Generic ports
	    CLK        => CLK,		
	    RESET      => RESET
    );    

  -- ----------------------------------------------------
  -- STIMULUS HERE!
  -- ----------------------------------------------------

  CLK <= not(CLK) after CLK_T/2; -- 200MHz   
  
  -- Main Process
  process
  	BEGIN 
		RESET <=  not (RESET) after 1us;
		wait;
  end process; 
  
end testbench;
