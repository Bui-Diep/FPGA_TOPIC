library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spi is
    port(
        clk : in std_logic;       -- clock signal
        reset : in std_logic;     -- reset signal
        ss : in std_logic;        -- slave select
        sck : out std_logic;      -- clock output
        mosi : out std_logic;     -- master out, slave in
        miso : in std_logic;      -- master in, slave out
        data_out : buffer std_logic_vector(7 downto 0); -- parallel output data
        data_in : in std_logic_vector(7 downto 0)       -- parallel input data
    );
end spi;

architecture rtl of spi is
    type state_type is (idle, transfer);
    signal state, next_state : state_type;
    signal counter : integer range 0 to 7;
    signal tx_reg, rx_reg : std_logic_vector(7 downto 0);
begin
    -- state machine
    process(clk, reset)
    begin
        if (reset = '1') then
            state <= idle;
        elsif (clk'event and clk = '1') then
            state <= next_state;
        end if;
    end process;
    
    -- next state logic
    process(state, ss, counter)
    begin
        case state is
            when idle =>
                if (ss = '0') then
                    next_state <= transfer;
                    counter <= 0;
                else
                    next_state <= idle;
                end if;
            when transfer =>
                if (counter = 7) then
                    next_state <= idle;
                else
                    next_state <= transfer;
                    counter <= counter + 1;
                end if;
        end case;
    end process;
    
    -- output logic
    process(state, counter, tx_reg, rx_reg)
    begin
        case state is
            when idle =>
                sck <= '0';
                mosi <= '0';
            when transfer =>
                if (counter = 0) then
                    rx_reg <= miso;
                end if;
                sck <= '1';
                mosi <= tx_reg(counter);
                sck <= '0';
        end case;
    end process;
    
    -- parallel output logic
    process(state, data_in, rx_reg)
    begin
        case state is
            when idle =>
                data_out <= "00000000";
            when transfer =>
                data_out <= rx_reg;
            when others =>
                data_out <= "00000000";
        end case;
    end process;
    
    -- parallel input logic
    process(state, data_in, tx_reg)
    begin
        case state is
            when idle =>
                tx_reg <= data_in;
            when others =>
                null;
        end case;
    end process;
end rtl;
