----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:02:53 10/23/2008 
-- Design Name: 
-- Module Name:    uart_rx - arch 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart_controller_rx is
	generic (
				d_bit:  integer:=8;
				sb_tick:integer:=16);
				
    port ( ckht: 	  in  std_logic;
           rst: 	  in  std_logic;
           rx: 	  in  std_logic;
           s_tick:  in  std_logic;
           rx_done_tick: out std_logic;
           rx_data: 		 out std_logic_vector(7 downto 0));
end uart_controller_rx;

architecture arch of uart_controller_rx is
type state_type is (idle,start,data,stop);
signal state_r: state_type;
signal state_n: state_type;

signal s_r, s_n: unsigned(3 downto 0);
signal n_r, n_n: unsigned(2 downto 0);
signal b_r, b_n: std_logic_vector(7 downto 0);
begin
	process(ckht,rst)
	begin
		if rst = '1' then	state_r <= idle;
								s_r	  <= (others=> '0');
								n_r	  <= (others=> '0');
								b_r	  <= (others=> '0');
		elsif falling_edge(ckht) then	state_r <= state_n;
												s_r	  <= s_n;
												n_r	  <= n_n;
												b_r	  <= b_n;
		end if;
	end process;
		
	process(state_r,s_r,n_r,b_r,s_tick,rx)
	begin
		state_n	 <= state_r;
		s_n		 <= s_r;
		n_n		 <= n_r;
		b_n		 <= b_r;
		rx_done_tick <='0';
		case state_r is
			when idle => if rx = '0' then state_n <= start;
							 				  	   s_n	  <= (others=>'0');
							 end if;
								
			when start => if s_tick = '1' then 
									if s_r = 7 then state_n <= data;
														 s_n	  <= (others=>'0');
														 n_n	  <= (others=>'0');
									else				 s_n	  <= s_r+1;
									end if;
								end if;
								
			when data =>	if s_tick = '1' then
									if s_r = 15 then s_n <= (others=>'0');
														  b_n <= rx & b_r(7 downto 1);
										if n_r = d_bit-1 then state_n <= stop;
										else						 n_n	  <= n_r+1;
										end if;
									else 							 s_n	  <= s_r+1;
									end if;
								end if;	
								
			when stop =>	if s_tick = '1' then
									if s_r = sb_tick-1 then state_n 	<= idle;
																   rx_done_tick <= '1';
									else							s_n		 <= s_r+1;
									end if;	
								end if;		
			end case;
	end process;
	rx_data <=b_r;				
end arch;


