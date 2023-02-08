library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity declaration for the FIFO-to-RAM converter
entity FIFO_to_RAM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           fifo_data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           fifo_wr_en : in  STD_LOGIC;
           ram_data_out : out STD_LOGIC_VECTOR (47 downto 0));
end FIFO_to_RAM;

-- Architecture for the FIFO-to-RAM converter
architecture Behavioral of FIFO_to_RAM is

-- Declare a 48-bit shift register to hold the data
signal shift_reg : STD_LOGIC_VECTOR (47 downto 0) := (others => '0');

begin

-- Process to shift the data from the FIFO into the shift register
shift_process : process (clk, rst)
begin
    if rst = '1' then
        shift_reg <= (others => '0');  -- Clear the shift register on reset
    elsif rising_edge(clk) then
        if fifo_wr_en = '1' then
            shift_reg(47 downto 8) <= shift_reg(39 downto 0);  -- Shift the data left by 8 bits
            shift_reg(7 downto 0) <= fifo_data_in;  -- Load the FIFO data into the shift register
        end if;
    end if;
end process;

-- Assign the output of the shift register to the RAM data output
ram_data_out <= shift_reg;

end Behavioral;

/* This code defines an entity called FIFO_to_RAM_converter with input ports for the clock (clk), reset (rst), FIFO data (fifo_data_in), and FIFO write enable (fifo_wr_en) signals, and an output port for the RAM data (ram_data_out). The architecture for the entity includes a 48-bit shift register (shift_reg) and a process that shifts the data from the FIFO into the shift register on each clock cycle. The output of the shift register is then assigned to the RAM data output. */
