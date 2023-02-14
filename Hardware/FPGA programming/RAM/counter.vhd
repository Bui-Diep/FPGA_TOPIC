library IEEE; 
-- library containing digital components and primitives
use IEEE.STD_LOGIC_1164.ALL; 
-- required for proper declaration of std_logic

entity counter is
generic
    -- generic parameter "n" used to control depth of counter
    ( n : integer := 4 ); 
port 
    ( CLK : in std_logic; 
  Q   : out std_logic_vector (n-1 downto 0) );
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
    q <= std_logic_vector(count);
  end process;
end dataflow;
