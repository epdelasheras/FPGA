----------------------------------------------------------------------------------
--! Company: 
--! Engineer: Enrique Pérez de las Heras
--! 
--! Create Date:    12:42:26 22/04/2008 
--! Design Name:    My_Components
--! Module Name:    uart_rx_module - Behavioral
--! Project Name:   Component reciver UART module
--!
--! Tool versions: XILINX ISE 8.2.1
--! Description: This design implements a receiver UART module. Register serial 
--! data received by Rx input. The protocol is next: By deafult Rx input is in 
--! high livel. When data is ready to receive Rx=Low level during 7 "rate" ticks 
--! (bit Start). And after data bits ara received by Rx in. The transfer finish
--! when a Stop bit is received (Rx input=1 during 16 "rate" ticks).

--! <----------------------Rx input-------------------------
--! |------|----|----|----|----|----|----|----|----|-------|
--! | Stop | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Start |
--! |______|____|____|____|____|____|____|____|____|_______|

--! Note: First bit received is allocated in the position zero of array (register).

--! Revision 0.01 - File Created
--!
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_rx_module is
port (
    clk     : in std_logic;                      --! System clock
	rst     : in std_logic;                      --! System Reset
    rate    : in std_logic;                      --! Clock Rate (115200 bps by default)
    rx      : in std_logic;                      --! Serial pin Rx
	rx_data : out std_logic_vector (7 downto 0); --! Register where sotore serial data received by Rx pin
	rx_rdy  : out std_logic;                     --! flag=1 when transfer is succesfull. 7 bits are received ok
	rx_ok   : out std_logic                      --! flag=0 when an error frame is occured -> Fail Trnasfer
);
end uart_rx_module;

architecture rtl of uart_rx_module is
    
    type rx_fsm is(
        SYNCHRO_PHASE,
        START_BIT_RX_PHASE,
        RESET_SAMPLE_CNT,
        DATA_RX_PHASE,
        STOP_BIT_RX_PHASE,
        DATA_READY,
        FRAME_ERROR
    );
    signal state_rx_fsm     : rx_fsm; 
    signal nxt_state_rx_fsm : rx_fsm;
    
    -- Control signals FSM
    signal clear_frame_error        : std_logic;    -- Clear frame error bit
    signal ena_edge_detection       : std_logic;    -- Enable edge detection
    signal ena_rx_buffer            : std_logic;    -- Enable RX buffer
    signal ena_sample_cnt           : std_logic;    -- Enable sample counter
    signal ena_start_bit_detection  : std_logic;    -- Enable start bit detection
    signal ena_stop_bit_detection   : std_logic;    -- Enable stop bit detection
    signal load_rx_reg              : std_logic;    -- Load RX register
    signal load_sample_cnt          : std_logic;    -- Load sample counter
    signal set_frame_error          : std_logic;    -- Set frame error bit
    signal set_data_ready           : std_logic;    -- Set data ready bit
    
    signal sync_serial         : std_logic; -- It's Rx synchronized with CLK System
    
    -- Next signals are used to detect Start bit.
    signal sync_serial_1xdelay : std_logic; 
    signal sync_serial_2xdelay : std_logic;    
    signal falling_edge_detected : std_logic;
    
    signal bit_cnt     : std_logic_vector (2 downto 0);   -- Received bit counter
    
    signal rx_buffer   : std_logic_vector (7 downto 0);   -- RX buffer
    
    signal sample_cnt  : std_logic_vector (3 downto 0);   -- Sample counter
    
    signal end_data_rx_phase     : std_logic;
    signal start_bit_sample_time : std_logic;
    signal stop_bit_sample_time  : std_logic;
    
begin
    
    -- Adaptation of Rx in with CLK System.
    SYNC_REG: process (clk)
    begin
        if rising_edge (clk) then
            sync_serial <= rx;
        end if;
    end process;
    
    -- Low edge detection in Rx input. This process and concurrent sentence 
    -- "falling_edge_detected" are actived by "SYNCHRO_PHASE" of rx_fsm and
    -- detect a possible Start bit. 
    EDGE_DETECTION: process (clk, rst)
    begin
        if rst = '0' then
            sync_serial_1xdelay <= '1';
            sync_serial_2xdelay <= '1';
        elsif rising_edge (clk) then
            -- Reset síncrono
            if ena_edge_detection = '0' then
                sync_serial_1xdelay <= '1';
                sync_serial_2xdelay <= '1';
            elsif ena_edge_detection = '1' and rate = '1' then
                sync_serial_1xdelay <= sync_serial;
                sync_serial_2xdelay <= sync_serial_1xdelay;
            end if;
            ---
        end if;
    end process;
    
    falling_edge_detected <= sync_serial_2xdelay and not sync_serial_1xdelay;
    
    -- This process implements a shift serial register where data received by Rx input
    -- are stored in a 8 bit buffer: rx_buffer. Taking 15 samples for each bit received.
    -- Really sample_cnt is a timer which function is wating 15 "rates" pulses to verify
    -- when bit received by Rx input is right.
    RX_BUF: process (clk)
    begin
        if rising_edge (clk) then
            if ena_rx_buffer = '1' and sample_cnt = x"F" and rate = '1' then
                rx_buffer <= sync_serial & rx_buffer (7 downto 1);
            end if;
        end if;
    end process;
    
    -- Handling Rx module outputs. When transfer is right -> rx_data = rx_buffer
    -- and rx_rdy = 1. When an error transfer is occured -> rx_ok = 0.
    OUTPUT_REGS: process (clk, rst)
    begin
        if rst = '0' then
            rx_rdy <= '0';
            rx_ok <= '1';
        elsif rising_edge (clk) then
            if load_rx_reg = '1' then 
                rx_data <= rx_buffer;
            end if;
            if set_frame_error = '1' then
                rx_ok <= '0';
            elsif clear_frame_error = '1' then
                rx_ok <= '1';
            end if;
            if set_data_ready = '1' then
                rx_rdy <= '1';
            else
                rx_rdy <= '0';
            end if;
        end if;
    end process;
    
    
    -- Sample counter and Bit counter are handling in this process.
    COUNTERS: process (clk, rst)
    begin
        if rst = '0' then
            sample_cnt <= (others => '0');
            bit_cnt <= (others => '0');
        elsif rising_edge (clk) then
            if load_sample_cnt = '1' then
                sample_cnt <= (others => '0');
            elsif (ena_sample_cnt = '1' and rate = '1') then
                sample_cnt <= sample_cnt + 1;
            end if;            
            if (ena_rx_buffer = '1' and sample_cnt = x"F" and rate = '1') then
                bit_cnt <= bit_cnt + 1;
            end if;
        end if;
    end process;
    
    
    -- Next flags are using to indicate when Start/Stop is detected and whem the
    -- transfer is finished.
    start_bit_sample_time <= '1' when (ena_start_bit_detection = '1' and sample_cnt = x"6" and rate = '1') else '0';
    end_data_rx_phase     <= '1' when (bit_cnt = "111" and sample_cnt = x"F" and rate = '1') else '0';
    stop_bit_sample_time  <= '1' when (ena_stop_bit_detection = '1' and sample_cnt = x"F" and rate = '1') else '0';


    FSM_RX: process(state_rx_fsm, falling_edge_detected, sync_serial,
    start_bit_sample_time, end_data_rx_phase, stop_bit_sample_time)
    begin
    
        -- Value signals by default
        nxt_state_rx_fsm <= state_rx_fsm;
        ena_edge_detection         <= '0';
        ena_start_bit_detection    <= '0';
        load_sample_cnt            <= '0';
        ena_sample_cnt             <= '0';
        ena_rx_buffer              <= '0';
        ena_stop_bit_detection     <= '0';
        set_frame_error            <= '0';
        clear_frame_error          <= '0';
        set_data_ready             <= '0';
        load_rx_reg                <= '0';

        case state_rx_fsm is
            -- Detect a posible Rx init with a low level in RX input -> Start bit
            when SYNCHRO_PHASE =>
                ena_edge_detection <= '1';
                if falling_edge_detected = '1' then
                    nxt_state_rx_fsm <= START_BIT_RX_PHASE;
                else
                    nxt_state_rx_fsm <= SYNCHRO_PHASE;
                end if;
            -- Confirm Start bit. 6 samples are captured in Rx input = sync_serial
            -- in the high edge of "rate". If sync_serial = 0 and start_bit_sample = 1
            -- then bit Start is detected. Both signals are evaluated in rising edge of
            -- "rate"
            when START_BIT_RX_PHASE =>
                ena_sample_cnt <= '1';          -- sample_cnt <= (others => '0');
                ena_start_bit_detection <= '1'; 
                if (start_bit_sample_time = '1' and sync_serial = '0') then
                    nxt_state_rx_fsm <= RESET_SAMPLE_CNT;
                elsif (start_bit_sample_time <= '1' and sync_serial = '1') then
                    nxt_state_rx_fsm <= SYNCHRO_PHASE;
                else
                    nxt_state_rx_fsm <= START_BIT_RX_PHASE;
                end if;            
            when RESET_SAMPLE_CNT =>
                load_sample_cnt <= '1';
                nxt_state_rx_fsm <= DATA_RX_PHASE;
            -- After receiving Start bit, now 7 Data bits is receiving and storing
            -- in a buffer->buffer_rx.
            when DATA_RX_PHASE =>
                ena_rx_buffer <= '1';
                ena_sample_cnt <= '1';
                if end_data_rx_phase = '1' then
                    nxt_state_rx_fsm <= STOP_BIT_RX_PHASE; 
                else
                    nxt_state_rx_fsm <= DATA_RX_PHASE;
                end if;
            -- When all data bits is receiving, a Stop bit is sending to indicate
            -- the final transfer. Stop bit is deteced when Rx input = 1 during 15
            -- "rate" ticks. If Rx input = 0, an error frame is occured.
            when STOP_BIT_RX_PHASE =>
                ena_sample_cnt <= '1';          -- sample_cnt <= (others => '0');
                ena_stop_bit_detection <= '1';  
                if (stop_bit_sample_time = '1' and sync_serial = '1') then
                    nxt_state_rx_fsm <= DATA_READY;
                elsif (stop_bit_sample_time = '1' and sync_serial = '0') then
                    nxt_state_rx_fsm <= FRAME_ERROR;
                else
                    nxt_state_rx_fsm <= STOP_BIT_RX_PHASE; 
                end if;
            -- Error tranfer -> rx_ok = 0.
            when FRAME_ERROR =>
                set_frame_error  <= '1';
                set_data_ready   <= '1';
                nxt_state_rx_fsm <= SYNCHRO_PHASE;
            -- Succesfull tranfer -> rx_rdy = 1.
            when DATA_READY =>
                load_rx_reg       <= '1';
                clear_frame_error <= '1';
                set_data_ready    <= '1';
                nxt_state_rx_fsm  <= SYNCHRO_PHASE;
        end case;

    end process;

    RX_FSM_CLK: process(clk, rst)
    begin
        if rst = '0' then
            state_rx_fsm <= SYNCHRO_PHASE; 
        elsif rising_edge (clk) then
            state_rx_fsm <= nxt_state_rx_fsm;
        end if;
    end process;

end rtl;

