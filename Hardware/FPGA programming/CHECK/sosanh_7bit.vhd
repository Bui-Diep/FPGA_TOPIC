library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sosanh_7bit is
    port (
        ckht : in std_logic;
        cnt_in : in std_logic_vector(6 downto  0); --nhan tu bo dem
        data_in : in std_logic_vector(7 downto 0);  --data nhan tu fifo
        ena_rd : out std_logic; -- tin hieu cho phep doc data tu fifo va tin hieu reset cho bo dem
        xdgm : out std_logic    -- xung da giai ma
    );
end entity sosanh_7bit;

architecture behavioral of sosanh_7bit is
signal ena_rd_r, ena_rd_n : std_logic;
begin
	process(ckht)
	begin
		if falling_edge(ckht) then ena_rd_r <= ena_rd_n;
		end if;
	end process;
	
	ena_rd_n <= '1' when cnt_in(6 downto 0) = data_in(6 downto 0) else 
		    '0';
	
ena_rd <= ena_rd_r;
xdgm <= data_in(7);
end behavioral;