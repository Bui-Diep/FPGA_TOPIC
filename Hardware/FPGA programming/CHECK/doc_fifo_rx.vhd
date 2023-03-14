----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:46:31 09/09/2022 
-- Design Name: 
-- Module Name:    doc_fifo_rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity doc_fifo_rx is
 port ( ckht: in std_logic;
        rst:  in std_logic;
		  
		  ena_rx:    		in  std_logic;
		  uart_rx_empty:  in  std_logic;
		  uart_rx_data: 	in  std_logic_vector(7 downto 0);			  			 

		  uart_rx_ena: 	out std_logic;
		  data_rx: 			out std_logic_vector(7 downto 0));
end doc_fifo_rx;

architecture Behavioral of doc_fifo_rx is
signal data_rx_r:std_logic_vector(7 downto 0);
signal data_rx_n:std_logic_vector(7 downto 0);
signal uart_rx_ena_t: std_logic;

begin
	uart_rx_ena_t	<= ena_rx and (not uart_rx_empty); -- tao xung doc 
	process(ckht, rst)	
	begin
		if rst = '1' then data_rx_r <= x"00";
		elsif falling_edge(ckht) then data_rx_r <= data_rx_n;
		end if;
	end process;			

	process(data_rx_r,uart_rx_ena_t,uart_rx_data)
	begin
		data_rx_n <= data_rx_r; 
		if uart_rx_ena_t = '1' then data_rx_n <= uart_rx_data;			
		end if;
	end process;
	data_rx <= data_rx_r;
	uart_rx_ena <= uart_rx_ena_t;
end Behavioral;

