library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
entity count_compare is
    port (
        ckht : in std_logic;
        rst : in std_logic;

        data_in : in std_logic_vector(7 downto 0);
        ena_cnt : in std_logic;

        xdgm : out std_logic;
        rd_ena : out std_logic
    );
end entity count_compare;

architecture behavioral of count_compare is
signal cnt_t : std_logic_vector(6 downto 0); 
signal ena_rst : std_logic;
begin 
    rd_ena <= ena_rst;
B1: entity work.dem_7bit
port map(
    ckht => ckht,
    q => cnt_t,
    rst => ena_rst,
    ena1khz => ena_cnt
);
B2: entity work.sosanh_7bit
port map(
    ckht => ckht,
    cnt_in => cnt_t,
    data_in => data_in,
    ena_rd => ena_rst,
    xdgm => xdgm
);
end behavioral;