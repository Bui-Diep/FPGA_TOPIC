library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Entity declaration
entity Sram_48 is
  port (
    clk : in std_logic; -- clock signal
    rst : in std_logic; -- reset signal
    addr : in std_logic_vector(15 downto 0); -- address input
    wr_en : in std_logic; -- write enable input
    rd_en : in std_logic; -- read enable input
    data_in : in std_logic_vector(47 downto 0); -- data input
    data_out : out std_logic_vector(47 downto 0) -- data output
  );
end Sram_48;

-- Architecture declaration
architecture rtl of Sram_48 is
  type mem_array is array (2**16-1 downto 0) of std_logic_vector(47 downto 0);
  signal memory : mem_array; -- internal memory array
begin
  -- Read operation
  process (clk)
  begin
    if rising_edge(clk) then
      if rd_en = '1' then
        data_out <= memory(to_integer(unsigned(addr))); -- read data from memory
      end if;
    end if;
  end process;
  
  -- Write operation
  process (clk)
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
        memory(to_integer(unsigned(addr))) <= data_in; -- write data to memory
      end if;
    end if;
  end process;
end rtl;

/* This program defines an entity called sram with the following inputs and outputs:

clk: clock signal
rst: reset signal
addr: 16-bit address input
wr_en: write enable input
rd_en: read enable input
data_in: 48-bit data input
data_out: 48-bit data output
The sram entity has two processes: one for reading from the SRAM and one for writing to the SRAM. The read process is triggered on the rising edge of the clock signal and reads data from the memory array at the address specified by the addr input. The write process is also triggered on the rising edge of the clock signal and writes data to the memory array at the address specified by the addr input.

This is just a simple example, and you may need to modify it depending on the specific requirements of your SRAM IC and your overall system design. */