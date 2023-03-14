----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:59 01/11/2015 
-- Design Name: 
-- Module Name:    DEBOUNCE_SW - Behavioral 
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

entity debounce_btn is
    port(ckht:    in  std_logic;
         btn:     in  std_logic;         
         db_tick: out std_logic);
end debounce_btn;


architecture Behavioral of debounce_btn is
constant n: integer:=20;
type db_state is (zero, wait0, one, wait1);

signal db_r, db_n: db_state:= zero;
signal dl_r, dl_n: unsigned(n-1 downto 0);

begin
	process(ckht)
   begin
		if falling_edge(ckht) then db_r <= db_n;
                                 dl_r <= dl_n;
		end if;
   end process;


  process(dl_r, db_r, btn)
    begin
		dl_n <= dl_r;
      db_n <= db_r;
		
	case db_r is
		when zero  => 
			db_tick <=  '0';
			if btn ='1' then db_n <= wait1;
								dl_n <= (others=>'1');
			end if;
									
		when wait1 => 
			db_tick <= '0';
			dl_n    <= dl_r - 1;
			if dl_r = 0 then 
				if btn ='1' then db_n <= one;
				else             db_n <= zero;
				end if;
			end if;

		when one =>  db_tick <= '1';
			if btn='0' then 	
				db_n <=  wait0;
				dl_n <= (others =>'1');
			end if;

		when wait0  =>  db_tick <= '1';
					dl_n    <= dl_r -1;
			if dl_r =0 then 
				if btn='0' then db_n <= zero;
				else            db_n <= one;
				end if;
			end if;
			end case;

		end process;
end behavioral;  



