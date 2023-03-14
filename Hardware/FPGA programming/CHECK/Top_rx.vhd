library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Top_rx is
    generic(
        n : integer := 9;
        m : integer := 163;
        d_bit:  integer:=8;
        sb_tick:integer:=16;
        b:natural:=8;
        w:natural:=8
    );
    port (
        ckht : in std_logic;
        btn_rst : in std_logic;

        rx : in std_logic;
        data_out : inout std_logic_vector(7 downto 0);
        empty : inout std_logic;
        xdgm : out std_logic
    );
end entity Top_rx;

architecture behav of Top_rx is
    signal s_tick, rst : std_logic;
    signal ENA1KHZ, ena_wr, ena_rd, ena_rx: std_logic;
    signal data_temp, rd_data : std_logic_vector(7 downto 0); 
begin
    
A1: entity work.baud_rate_generator
generic map (
    n => n,
    m => m
)
port map (
    ckht => ckht,
    rst => rst,
    tick => s_tick
);
A2: entity work.uart_controller_rx
generic map (
    d_bit => d_bit,
    sb_tick => sb_tick
    )
port map (
    ckht => ckht,
    rst => rst,
    rx => rx,
    s_tick => s_tick,
    rx_done_tick => ena_wr,
    rx_data => data_temp
);
A3: entity work.fifo_rx
generic map(
    b => b,
    w => w
)
port map(
    ckht => ckht,
    rst => rst,
    rd => ena_rd,
    wr => ena_wr,
    wr_data => data_temp,
    empty => empty,
    rd_data => rd_data
);
A4: entity work.CHIA_10ENA
port map (
    ckht => ckht,
    ENA1KHZ => ENA1KHZ
);
A5: entity work.doc_fifo_rx
port map (
    ckht => ckht,
    rst => rst,
    ena_rx => ena_rx,
    uart_rx_empty => empty,
    uart_rx_data => rd_data,
    uart_rx_ena => ena_rd,
    data_rx => data_out
);
A6: entity work.count_compare
port map(
    ckht => ckht,
    rst => rst,
    data_in => data_out,
    ena_cnt => ENA1KHZ,
    xdgm => xdgm,
    rd_ena => ena_rx
);
A7 : entity work.debounce_btn
port map(
    ckht => ckht,
    btn => not(btn_rst),
    db_tick => rst
);
end behav;