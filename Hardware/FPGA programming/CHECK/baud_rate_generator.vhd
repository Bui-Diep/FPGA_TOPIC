----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:59:14 10/22/2008 
-- Design Name: 
-- Module Name:    mod_m_counter - Behavioral 
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

entity baud_rate_generator is
generic (
			n: integer:=4;
			m:integer:=10);
			
    port ( ckht 	: in  std_logic;
           rst 	: in  std_logic;
           tick 	: out  std_logic
			  );
end baud_rate_generator;

architecture arch of baud_rate_generator is
signal r_r: unsigned(n-1 downto 0);
signal r_n: unsigned(n-1 downto 0);

begin
		process(ckht,rst)
		begin
			if (rst = '1') then r_r <= (others => '0');
			elsif falling_edge(ckht) then r_r <= r_n;
			end if;
		end process;
		r_n <= (others => '0') when r_r =(m-1) else
				 r_r+1;

		tick <= '1' when r_r = (m-1) else '0';
end arch;


