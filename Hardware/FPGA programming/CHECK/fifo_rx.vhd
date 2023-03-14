----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:56 10/22/2008 
-- Design Name: 
-- Module Name:    fifo - Behavioral 
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

entity fifo_rx is
	 generic (
				b:natural:=8;
				w:natural:=2);
    port ( ckht: 		in  std_logic;
           rst: 		in  std_logic;
           rd: 		in  std_logic;
           wr: 		in  std_logic;
           wr_data: 	in  std_logic_vector(b-1 downto 0);
           empty: 	out  std_logic;
           --full: 	out  std_logic;
           rd_data: 	out  std_logic_vector(b-1 downto 0));
end fifo_rx;

architecture arch of fifo_rx is
type reg_file_type is array (2**w-1 downto 0) of std_logic_vector(b-1 downto 0);
signal array_r: reg_file_type;

signal wr_ptr_r: std_logic_vector(w-1 downto 0);
signal wr_ptr_n: std_logic_vector(w-1 downto 0);
signal wr_ptr_s: std_logic_vector(w-1 downto 0);

signal rd_ptr_r: std_logic_vector(w-1 downto 0);	
signal rd_ptr_n: std_logic_vector(w-1 downto 0);	
signal rd_ptr_s: std_logic_vector(w-1 downto 0);	

signal full_r:  std_logic;
signal full_n:  std_logic;
signal empty_r: std_logic;
signal empty_n: std_logic;

signal wr_op: std_logic_vector(1 downto 0);
signal wr_en: std_logic;	
begin
	process(ckht,rst)
	begin
		if rst='1' then array_r <= (others=>(others=>'0'));
		elsif falling_edge(ckht) then
			if wr_en='1' then	array_r(conv_integer(unsigned(wr_ptr_r)))<= wr_data;
			end if;
		end if;		
	end process;
		
	rd_data 	<= array_r(conv_integer(unsigned(rd_ptr_r)));		--doc tai vi tri
	wr_en 	<= wr and (not full_r);
	wr_ptr_s <= wr_ptr_r + 1;
	rd_ptr_s <= rd_ptr_r + 1;		
	wr_op 	<= wr & rd;			
	-------------------
	process(ckht,rst)
	begin
		if rst='1' then wr_ptr_r <= (others=> '0');
							 rd_ptr_r <= (others=> '0');
							 full_r	<= '0';
							 empty_r	<=	'1';
		elsif falling_edge(ckht) then wr_ptr_r <= wr_ptr_n;
												rd_ptr_r <= rd_ptr_n;
												full_r  <= full_n;
												empty_r <= empty_n;
		end if;
	end process;

	process(wr_ptr_r,wr_ptr_s,rd_ptr_r,rd_ptr_s,wr_op,empty_r,full_r)
	begin
		wr_ptr_n <= wr_ptr_r;
		rd_ptr_n <= rd_ptr_r;
		full_n  <= full_r;
		empty_n <= empty_r;
	
		case wr_op is
			when "00" => 
			when "01" => 	if empty_r ='0' then	rd_ptr_n <= rd_ptr_s;
															full_n  <='0';
									if rd_ptr_s = wr_ptr_r then empty_n	<=	'1';
									end if;
								end if;
					
			when "10" =>	if full_r ='0' then wr_ptr_n <= wr_ptr_s;
															 empty_n	<=	'0';
									if wr_ptr_s = rd_ptr_r then full_n <= '1';
									end if;
								end if;
								
			when others	=>	wr_ptr_n <= wr_ptr_s;
								rd_ptr_n <= rd_ptr_s;
		end case;
	end process;

	--full	<= full_reg;
	empty	<=	empty_r;
end arch;


