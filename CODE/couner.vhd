library ieee;
use ieee.std_logic_1164.all;

entity counter is
    port(
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        set : in std_logic;
        add_in : in std_logic_vector(15 downto 0);
        add_out : out std_logic_vector(15 downto 0)
    );
end counter;

architecture rtl of counter is
    -- signal set_temp : std_logic_vector(15 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            add_out <= (others => '0');
        elsif rising_edge(clk) then
            if set = '1' then
                add_out(15 downto 0) <= add_in(15 downto 0);  -- set count to a random value
            elsif en = '1' then
                add_out <= add_out + 1;
            else null;
            end if;
        end if;
    end process;
end rtl;
