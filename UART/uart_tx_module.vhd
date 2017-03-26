----------------------------------------------------------------------------------
--! Company: 
--! Engineer: Enrique Pérez de las Heras
--! 
--! Create Date:    12:42:26 22/04/2008 
--! Design Name:    My_Components
--! Module Name:    uart_tx_module - Behavioral
--! Project Name:   Component reciver UART module
--!
--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a transmitter UART module. Protocol is
--! next: Firstly a Start bit (Tx = 0) is sending by Tx output pin during 15 
--! "rate" ticks. Then, 7 data bits stored in tx_data registerare sending one 
--! by one. Finally Stop bit (Tx = 1) is sending during 15 "rate" ticks.

--! ------------------------Tx output---------------------->
--! |-------|----|----|----|----|----|----|----|----|------|
--! | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
--! |_______|____|____|____|____|____|____|____|____|______|

--! Note: If tx_data = x"5F" = 01011111. The first to send is the LSB.


--! Revision 0.01 - File Created
--!
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_tx_module is

port(
    clk     : in std_logic;                     --! System CLK
	rst     : in std_logic;                     --! System Reset
    rate    : in std_logic;                     --! Clock Rate (11520 by default)
	tx_data : in std_logic_vector (7 downto 0); --! Register where store bits to Tx
	tx_load : in std_logic;                     --! tx_load = 1 to init Tx
	tx_rdy  : out std_logic;                    --! tx_rdy = 1 if Tx buffer is empty
	tx      : out std_logic                     --! Serial pin Tx
);

end uart_tx_module;

architecture rtl of uart_tx_module is

	type tx_fsm is (
        IDDLE,
        START_BIT_TX_PHASE,
        DATA_TX_PHASE,
        STOP_BIT_TX_PHASE,
        SYNCHRO_PHASE
    );
	signal state_tx_fsm     : tx_fsm;
    signal nxt_state_tx_fsm : tx_fsm;
	
	signal ena_sample_cnt       : std_logic;                     -- Enable sample counter
    signal sample_cnt           : std_logic_vector (3 downto 0); -- Sample counter
    signal tx_data_bit      : std_logic;  -- enbale data bits Tx
	signal serialized_data  : std_logic;  -- = tx pin
    
	signal tx_bit_cnt   : std_logic_vector (2 downto 0);  -- data bits counter
	signal tx_buffer    : std_logic_vector (7 downto 0);  -- = tx_data pins

begin
    -- Tx register.
    TX_REG: process (clk)
    begin
        if rising_edge (clk) then
            if tx_load = '1' then
                tx_buffer <= tx_data;
            end if;
        end if; 
    end process;
    
    -- Multiplexor to serialize Tx register bits.    
    with tx_bit_cnt select
    serialized_data <=  tx_buffer (0) when "000",
                        tx_buffer (1) when "001",
                        tx_buffer (2) when "010",
                        tx_buffer (3) when "011",
                        tx_buffer (4) when "100",
                        tx_buffer (5) when "101",
                        tx_buffer (6) when "110",
                        tx_buffer (7) when others;
    
    -- Sending Start bit, Stop bit and Data bits synchronized with clk.
    OUTPUT_REGS: process (clk)
    begin
        if rising_edge (clk) then
            case state_tx_fsm is
                when START_BIT_TX_PHASE =>
                    tx <= '0';
                when DATA_TX_PHASE =>
                    tx <= serialized_data;
                when others =>
                    tx <= '1';
            end case;
        end if;
    end process;  
    
    
    -- Sample counter and Bits counter.
    CNTs: process (clk, rst)
    begin
        if rst = '0' then
            sample_cnt <= (others => '0');
            tx_bit_cnt   <= (others => '0');
        elsif rising_edge (clk) then
            if (sample_cnt = x"F" and tx_data_bit = '1' and rate = '1') then
                tx_bit_cnt <= tx_bit_cnt + 1;
            end if;
            --
            if (ena_sample_cnt = '1' and rate = '1') then
                sample_cnt <= sample_cnt + 1;
            end if; 	
        end if;
    end process;
    
    FSM_TX: process (state_tx_fsm, tx_load,rate, sample_cnt, tx_bit_cnt)    
    begin       
       -- Value signals by default
        nxt_state_tx_fsm <= state_tx_fsm;
        tx_rdy <= '0';
        tx_data_bit <= '0';
        ena_sample_cnt <= '0';
        
        case state_tx_fsm is
        -- Init State
        when IDDLE =>
            tx_rdy <= '1';
            if tx_load = '1' then	
                nxt_state_tx_fsm <= SYNCHRO_PHASE;
            else
                nxt_state_tx_fsm <= IDDLE;
            end if;
        -- Synchronize sending Start bit with rate clk
        when SYNCHRO_PHASE =>
            if rate = '1' then
                nxt_state_tx_fsm <= START_BIT_TX_PHASE;
            else
                nxt_state_tx_fsm <= SYNCHRO_PHASE;
            end if;
        -- Enable Start bit Detection. OUTPUT_REGS process sends bit Start by Tx
        -- output pin (Tx=0). And this state takes 15 samples of that bit.
        when START_BIT_TX_PHASE =>
            ena_sample_cnt <= '1';
            if (sample_cnt = x"F" and rate = '1') then
                nxt_state_tx_fsm <= DATA_TX_PHASE;	
            else
                nxt_state_tx_fsm	<= START_BIT_TX_PHASE;
            end if;
        -- If data bit is sending properly, 7 data bits are sending. By each data
        -- bit 15 samples are taking.
        when DATA_TX_PHASE => 
            ena_sample_cnt <= '1';
            tx_data_bit    <= '1';
            if (sample_cnt = x"F" and rate = '1' and tx_bit_cnt = "111") then
                nxt_state_tx_fsm <= STOP_BIT_TX_PHASE; 	
            else
                nxt_state_tx_fsm <= DATA_TX_PHASE;	
            end if;
        -- Finllay a Stop bit is sending (Tx = 1 during 15 "rates" ticks). This
        -- state only sampling stop bit. OUTPUT_REGS process sends that bit.
        when STOP_BIT_TX_PHASE =>
            ena_sample_cnt <= '1';
            if (sample_cnt = x"F" and rate = '1') then
                nxt_state_tx_fsm <= IDDLE;	
            else
                nxt_state_tx_fsm	<= STOP_BIT_TX_PHASE;
            end if;
        end case;
    end process;

    TX_FSM_CLK: process (clk, rst)
    begin
        if rst = '0' then
            state_tx_fsm <= IDDLE; 
        elsif rising_edge (clk) then
            state_tx_fsm <= nxt_state_tx_fsm;
        end if;
    end process;

end rtl;