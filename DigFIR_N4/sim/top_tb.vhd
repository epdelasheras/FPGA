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
  constant CLK_T : time := 5 ns; 
  signal CLK     : std_logic := '0';  -- 200 MHz 
  signal RESET   : std_logic := '1';  
  signal PB      : std_logic_vector (3 downto 0) := (others => '0'); 
  signal LED     : std_logic_vector (7 downto 0) := (others => '0');  
  signal FILTER_IN  :  std_logic_vector (15 downto 0) := (others => '0');
  signal FILTER_OUT :  std_logic_vector (15 downto 0) := (others => '0');  
  
  
  -- ----------------------  
  -- SineGenerator signals
  -- ----------------------  
  constant CLK_WAVE_T : time := 10 ns;   
  signal CLK_WAVE     : std_logic := '0';  
  signal WAVE_GEN     : std_logic_vector (15 downto 0) := (others => '0');
  
  
begin    

  -- ----------------------------------------------------
  --  MODULES INSTANTIATION
  -- ----------------------------------------------------
  

  -- Top inst  
  FILTER_IN <= WAVE_GEN;
  --FILTER_IN <= x"0001";
  UUT_Top: entity work.top 
    generic map (
      DEBUG => DEBUG
    )  
	port map (	
		-- Generic ports
	    CLK        => CLK,
	    RESET      => RESET,
	    PB         => PB,
	    LED        => LED,		
	    -- IIR Filter
	    FILTER_IN     => FILTER_IN,
	    FILTER_OUT    => FILTER_OUT
    );    


  -- WaveGenerator inst
  UUT_WaveGenerator: entity work.WaveGenerator
    generic map (
      DEBUG => DEBUG,	  	  
	  ROM_DEPTH => 50 
    )    
  	port map(
		CLK       => CLK_WAVE,
		RST       => RESET,		
		WAVE_GEN  => WAVE_GEN
	);	


  -- ----------------------------------------------------
  -- STIMULUS HERE!
  -- ----------------------------------------------------

  CLK <= not(CLK) after CLK_T/2; -- 200MHz
  CLK_WAVE <= not (CLK_WAVE) after CLK_WAVE_T/2;
  
  -- Main Process
  process
  	BEGIN 
		RESET <=  not (RESET) after 1us;
		wait;
  end process; 
  
end testbench;
