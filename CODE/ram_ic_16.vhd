library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;

-- Declare the RAM IC as an entity
entity ram_ic_16 is
    Port (
        clk : in  std_logic;
        addr : in  std_logic_vector(15 downto 0);  -- Address bus
        data_in : in  std_logic_vector(15 downto 0);  -- Data input bus
        data_out : out std_logic_vector(15 downto 0); -- Data output bus
        we : in  std_logic;  -- Write enable
        oe : in  std_logic  -- Output enable
    );
end ram_ic_16;

-- Implement the RAM IC as a behavioral model
architecture ram_ic_arch of ram_ic_16 is
    type ram_array is array (0 to 65535) of std_logic_vector(15 downto 0);
    signal ram : ram_array;
begin
    -- Read operation
    process(clk, oe)
    begin
        if rising_edge(clk) and oe = '1' then
            data_out <= ram(to_integer(unsigned(addr)));
        end if;
    end process;

    -- Write operation
    process(clk, we)
    begin
        if rising_edge(clk) and we = '1' then
            ram(to_integer(unsigned(addr))) <= data_in;
        end if;
    end process;
end ram_ic_arch;

/* This VHDL program defines an entity ram_ic that represents the RAM IC, with input and output ports for the address bus, data bus, write enable, and output enable. It also defines an architecture ram_ic_arch that implements the behavior of the RAM IC using a signal ram that represents the memory array. The program includes two processes: one for reading from the RAM and one for writing to the RAM. Each process is triggered by the rising edge of the clock signal and either the output enable or the write enable signal, respectively. */