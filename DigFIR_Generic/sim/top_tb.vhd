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
	  hn          => (-0.01259277478717816,
                      -0.02704833486706803,
                      -0.031157016036431583,
                      -0.0033516667471792812,
                       0.06651710329324828,
                       0.1635643048779222,
                       0.249729473226146,
                       0.2842779082622769,
                       0.249729473226146,
                       0.1635643048779222,
                       0.06651710329324827,
                      -0.0033516667471792812,
                      -0.031157016036431583,
                      -0.027048334867068043,
                      -0.01259277478717816,
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
