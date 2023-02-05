library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart is
    port(
        rx : in std_logic;  -- serial input
        tx : out std_logic; -- serial output
        clk : in std_logic; -- clock signal
        reset : in std_logic; -- reset signal
        data_out : buffer std_logic_vector(7 downto 0); -- parallel output data
        data_in : in std_logic_vector(7 downto 0) -- parallel input data
    );
end uart;

architecture rtl of uart is
    type state_type is (idle, start, data, stop);
    signal state, next_state : state_type;
    signal counter : integer range 0 to 11;
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
    process(state, rx, counter)
    begin
        case state is
            when idle =>
                if (rx = '1') then
                    next_state <= start;
                else
                    next_state <= idle;
                end if;
            when start =>
                next_state <= data;
                counter <= 0;
            when data =>
                if (counter = 7) then
                    next_state <= stop;
                else
                    next_state <= data;
                    counter <= counter + 1;
                end if;
            when stop =>
                next_state <= idle;
        end case;
    end process;
    
    -- output logic
    process(state, tx_reg, rx_reg, counter)
    begin
        case state is
            when idle =>
                tx <= '1';
            when start =>
                tx <= '0';
            when data =>
                if (counter = 0) then
                    rx_reg <= rx;
                end if;
                tx <= rx_reg(counter);
            when stop =>
                tx <= '1';
        end case;
    end process;
    
    -- parallel output logic
    process(state, data_in, rx_reg)
    begin
        case state is
            when idle =>
                data_out <= "00000000";
            when data =>
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
