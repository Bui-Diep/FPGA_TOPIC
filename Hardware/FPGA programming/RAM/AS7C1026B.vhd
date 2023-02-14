library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity AS7C1026B is 
  generic ( WORD_SIZE : integer := 4;   
          MEMORY_SIZE : integer := 48 );
  Port (  
  we  : in  STD_LOGIC;                   -- Write Enable
  ce  : in  STD_LOGIC;                   -- Chip Enable
  oe  : in  STD_LOGIC;                   -- Output Enable
  addr  : in  STD_LOGIC_VECTOR (3 downto 0); -- Address
  Data  : inout  STD_LOGIC_VECTOR (MEMORY_SIZE-1 downto 0)); -- Data In/out
end AS7C1026B;

architecture Behavioral of AS7C1026B is 
     type rom_type is array (0 to 2**WORD_SIZE-1) of std_logic_vector(MEMORY_SIZE-1 downto 0);
     signal my_rom : rom_type;

begin
-- Read data from ROM
  process (addr, we, ce)
  begin
    if (ce = '1') then 
      if (we = '1') then
        my_rom (conv_integer(addr)) <= Data;
      elsif (oe = '1') then
        Data <= my_rom(conv_integer(addr));
      end if;
    end if;
  end process;
end Behavioral;
