library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_analyzer is
    Port ( clk : in  STD_LOGIC;
           channel0 : in  STD_LOGIC;
           channel1 : in  STD_LOGIC;
           channel2 : in  STD_LOGIC;
           channel3 : in  STD_LOGIC;
           channel4 : in  STD_LOGIC;
           channel5 : in  STD_LOGIC;
           channel6 : in  STD_LOGIC;
           channel7 : in  STD_LOGIC;
           analyzer_enable : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_valid : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0));
end logic_analyzer;

architecture Behavioral of logic_analyzer is
    signal state : integer range 0 to 3 := 0;
    signal count : integer range 0 to 23 := 0;
    signal sample : STD_LOGIC_VECTOR (7 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count <= 0;
                state <= 0;
                data_valid <= '0';
            elsif analyzer_enable = '1' then
                case state is
                    when 0 =>
                        sample <= channel0 & channel1 & channel2 & channel3 & channel4 & channel5 & channel6 & channel7;
                        count <= count + 1;
                        if count = 23 then
                            data <= sample;
                            data_valid <= '1';
                            count <= 0;
                            state <= 1;
                        end if;
                    when 1 =>
                        sample <= channel0 & channel1 & channel2 & channel3 & channel4 & channel5 & channel6 & channel7;
                        count <= count + 1;
                        if count = 23 then
                            data <= sample;
                            data_valid <= '1';
                            count <= 0;
                            state <= 2;
                        end if;
                    when 2 =>
                        sample <= channel0 & channel1 & channel2 & channel3 & channel4 & channel5 & channel6 & channel7;
                        count <= count + 1;
                        if count = 23 then
                            data <= sample;
                            data_valid <= '1';
                            count <= 0;
                            state <= 3;
                        end if;
                    when 3 =>
                        sample <= channel0 & channel1 & channel2 & channel3 & channel4 & channel5 & channel6 & channel7;
                        count <= count + 1;
                        if count = 23 then
                            data <= sample;
                            data_valid <= '1';
                            count <= 0;
                            state <= 0;
                        end if;
                end case;
            else
                data_valid <= '0';
            end if;
        end if;
    end process;
end Behavioral;
