----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- dds_synthesizer packages
use work.dds_synthesizer_pkg.all;
use work.sine_lut_pkg.all;

-- FIR_low_area package
use work.fir_package.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  generic (
    DEBUG     : boolean := false;   -- True in Simu Only	
	-- DDS Synthesizer
	ftw_width : integer := 32;
	-- FIR Low area
    data_length : natural := 16;
    bits_resol  : natural := 16;
    taps        : natural := 15; -- order + 1	
	hn          : COEFF_ARRAY := (-0.01259277478717816,
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
  );
port (  
  CLK         : in    std_logic; -- External CLK
  RESET       : in    std_logic  -- External reset
  );

end top;

architecture Behavioral of top is

-- DDS Synthesizer
signal ftw : std_logic_vector(ftw_width-1 downto 0);
signal init_phase : std_logic_vector(phase_width-1 downto 0);
signal phase_out : std_logic_vector(phase_width-1 downto 0);
signal ampl_out : std_logic_vector(ampl_width-1 downto 0);

-- FIR filter
signal fir_out : std_logic_vector (data_length-1 downto 0);
										  
begin


  --*******************************
  -- DDS Synthesizer
  --*******************************
  -- A 16-bits sinus signal is generated from -32768 to 32767.  
  
  -- To estimate the ftw value apply the next equation:
  -- ftw=[Fout*(2^ftw_width)]/FCLK
  -- where,
  -- 	*Fout = Ouput DDS sinus frequency.
  --    *ftw_with = 32 (by default)
  --    *FLCK = system clock => 200MHz
  -- ftw=Fout*21.47 => Round to the next integer. Only valid with ftw_with = 32 and FCLK=200MHz
  ftw <= conv_std_logic_vector(2147483,ftw_width);  --10us period @ 200MHz, ftw_width=32
  
  -- start with 0º phase
  init_phase <= (others => '0');
  
  UUT_dds_synthesizer: entity work.dds_synthesizer
  generic map(
		ftw_width   => ftw_width
  )
  port map(
		clk_i => CLK,
		rst_i => RESET,
		ftw_i    => ftw,
		phase_i  => init_phase,
		phase_o  => phase_out,
		ampl_o => ampl_out
  );	
  

  --*******************************
  -- Low Pass FIR Filter
  --*******************************  
  
  UUT_FIR_low_area: ENTITY work.FIR_low_area 
  --.............................................
  generic map(        
    data_length  => data_length,
    data_signed  => false,
    improv_t     => false,
    bits_resol   => bits_resol,
    taps         => taps,  
    coefficients => hn)
  port map(
    areset   => RESET,
    sreset   => '0',
    clock_fs => CLK,
    enable   => '1',
    xn       => ampl_out,
    yn       => fir_out
    );
  
  

end Behavioral;
