----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:55:01 01/13/2015 
-- Design Name: 
-- Module Name:    GIAI_MA_HIENTHI_4LED_7DOAN - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dem_7bit is
	port(ckht:	  in  std_logic;
		rst : 	in std_logic;
		ena1khz: in  std_logic;
		q:		  out std_logic_vector(6 downto 0));
end dem_7bit;

architecture behavioral of dem_7bit is
signal q_r: std_logic_vector(6 downto 0):= (others => '0');
signal q_n: std_logic_vector(6 downto 0):= (others => '0');
begin
	process(ckht, rst)
	begin
		if rst = '1' then 
			q_r <= (others => '0');
		elsif falling_edge(ckht) then q_r <= q_n;
		end if;
	end process;
	
	q_n <= q_r +1 when ena1khz = '1' else 
		    q_r;
	
	q <= q_r;
end behavioral;

