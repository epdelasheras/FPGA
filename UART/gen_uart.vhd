----------------------------------------------------------------------------------
--! Company:
--! Engineer: Enrique Pérez de las Heras
--! 
--! Create Date:    12:42:26 22/04/2008 
--! Module Name:    gen_uart - Behavioral
--! Project Name:   Generic UART
--!
--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a generic UART with several rates.

--! Revision 0.01 - File Created
--! Note: configure the speed uart_rategen_module.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity gen_uart is

port(
    clk     : in std_logic;                             --! System clock
    rst     : in std_logic;                             --! System reset. Low level active
    ena     : in std_logic;                             --! counter=0 in "uart_rategen" module. Low level active
    
    tx_data : in std_logic_vector (7 downto 0);         --! Data to send (from FPGA)
    tx_load : in std_logic;                             --! Data load pulse
    tx_rdy  : out std_logic;                            --! New byte required
    
    rx_data : out std_logic_vector (7 downto 0);        --! Received data
    rx_ok   : out std_logic;                            --! Frame OK (error if 0)
    rx_rdy  : out std_logic;                            --! Data ready
    
    tx      : out std_logic;                            --! TX line
    rx      : in std_logic                              --! RX line
);

end gen_uart;

architecture behavioral of gen_uart is

    component uart_rategen_module is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        ena     : in std_logic;
        rate    : out std_logic
    );
    end component;
    
    component uart_rx_module is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        rate    : in std_logic;
        rx      : in std_logic;
        rx_data : out std_logic_vector (7 downto 0);
        rx_rdy  : out std_logic;
        rx_ok   : out std_logic
    );
    end component;
    
    component uart_tx_module is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        rate    : in std_logic;
        tx_data : in std_logic_vector (7 downto 0);
        tx_load : in std_logic;
        tx_rdy  : out std_logic;
        tx      : out std_logic
    );
    end component;
    
	signal rate : std_logic;
    
begin
    
    RG_MOD: uart_rategen_module    -- Generate the bit rate for the serial port
    port map(
        clk     => clk,
        rst     => rst,
        ena     => ena,
        rate    => rate
    );
    
    TX_MOD: uart_tx_module         -- Transmitter
    port map(
        clk     => clk,
        rst     => rst,
        rate    => rate,    
        tx_data => tx_data,
        tx_load => tx_load,
        tx_rdy  => tx_rdy,
        tx      => tx
    );
    
    RX_MOD: uart_rx_module        -- Receiver
    port map(
        clk     => clk,
        rst     => rst,
        rate    => rate,    
        rx      => rx,
        rx_data => rx_data,
        rx_rdy  => rx_rdy,
        rx_ok   => rx_ok
    );
    
end behavioral;