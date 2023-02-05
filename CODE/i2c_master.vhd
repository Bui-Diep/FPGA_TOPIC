library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_master is
    Port ( scl : in  STD_LOGIC;
           sda : in  STD_LOGIC;
           start : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           address : in  STD_LOGIC_VECTOR (7 downto 0);
           rw : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end i2c_master;

architecture Behavioral of i2c_master is
    signal state : std_logic_vector(1 downto 0);
    signal count : integer range 0 to 8;
    signal data : std_logic_vector(7 downto 0);
    signal scl_int : std_logic;
    signal sda_int : std_logic;
    signal ack : std_logic;
    signal start_int : std_logic;
    signal stop_int : std_logic;
begin
    -- State machine
    process(scl, reset)
    begin
        if reset = '1' then
            state <= "00";
        elsif rising_edge(scl) then
            case state is
                when "00" =>
                    if start = '1' then
                        state <= "01";
                    end if;
                when "01" =>
                    state <= "10";
                when "10" =>
                    if sda_int = '0' then
                        state <= "11";
                    else
                        state <= "00";
                    end if;
                when "11" =>
                    if count = 7 then
                        if rw = '1' then
                            state <= "100";
                        else
                            state <= "101";
                        end if;
                    else
                        state <= "11";
                    end if;
                when "100" =>
                    if ack = '1' then
                        state <= "101";
                    else
                        state <= "00";
                    end if;
                when "101" =>
                    if count = 0 then
                        if stop = '1' then
                            state <= "110";
                        else
                            state <= "101";
                        end if;
                    else
                        state <= "101";
                    end if;
                when "110" =>
                    state <= "00";
                when others =>
                    state <= "00";
            end case;
        end if;
    end process;

    -- Data register
    process(scl, reset)
    begin
        if reset = '1' then
            data <= (others => '0');
        elsif rising_edge(scl) then
            if state = "11" or state = "101" then
                if sda = '1' then
                    data(count) <= '1';
                else
                    data(count) <= '0';
                end if;
