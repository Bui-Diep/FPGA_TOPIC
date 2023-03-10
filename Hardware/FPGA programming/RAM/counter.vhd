library IEEE; 
-- library containing digital components and primitives
use IEEE.STD_LOGIC_1164.ALL; 
-- required for proper declaration of std_logic
use IEEE.std_logic_arith.all;

entity counter is
generic
    -- generic parameter "n" used to control depth of counter
    ( n : integer := 4 ); 
port 
    ( CLK : in std_logic; 
        q   : out std_logic_vector (7 downto 0) );
end counter;

architecture dataflow of counter is
begin 
  process (CLK)
    variable count : integer := 0;
  begin 
    if rising_edge(CLK) then
      if count = 2**n-1 then
        count := 0;
      else
        count := count + 1;
      end if;
    end if;
    q <= std_logic_vector(conv_unsigned(count, 8));
  end process;
end dataflow;
