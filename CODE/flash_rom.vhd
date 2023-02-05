-- Sure! Here is a program in VHDL that communicates with a flash ROM (W25Q32) using the Serial Peripheral Interface (SPI) protocol:
-- W25Q32 flash ROM module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flash_rom is
    Port ( clk : in  STD_LOGIC;  -- xung he thong
           cs : in  STD_LOGIC;
           spi_mosi : in  STD_LOGIC;    -- master out, slave in
           spi_miso : out  STD_LOGIC;   -- master in, slave out
           spi_sck : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (23 downto 0); -- dia chi thanh ghi can doc ghi
           data_out : out  STD_LOGIC_VECTOR (7 downto 0)); --  du lieu ra song song
end flash_rom;

architecture Behavioral of flash_rom is
    type state_type is (idle, send_cmd, send_addr, read_data);
    signal current_state, next_state : state_type;
    signal counter : integer range 0 to 23;
    signal data_in : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- state machine
    process (clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
            case current_state is
                when idle =>
                    if cs = '0' then
                        next_state <= send_cmd;
                        counter <= 0;
                    else
                        next_state <= idle;
                    end if;
                when send_cmd =>
                    spi_mosi <= '1';
                    spi_sck <= '0';
                    if counter = 7 then
                        next_state <= send_addr;
                    else
                        next_state <= send_cmd;
                        counter <= counter + 1;
                    end if;
                when send_addr =>
                    spi_mosi <= addr(counter);
                    spi_sck <= '0';
                    if counter = 23 then
                        next_state <= read_data;
                    else
                        next_state <= send_addr;
                        counter <= counter + 1;
                    end if;
                when read_data =>
                    spi_mosi <= '1';
                    spi_sck <= '0';
                    data_out <= data_in;
                    if counter = 23 then
                        next_state <= idle;
                    else
                        next_state <= read_data;
                        counter <= counter + 1;
                    end if;
            end case;
        end if;
    end process;

    -- data transfer
    process (current_state, spi_mosi, spi_sck)
    begin
        if spi_sck = '1' then
            if current_state = read_data then
                data_in(0) <= spi_mosi;
                for i in 1 to 7 loop
                    data_in(i) <= data_in(i-1);
                end loop;
            else
                data_in <= (others => 'Z');
            end if;
            spi_miso <= data_in(7);
        else
            spi_miso <= 'Z';
	end if;
    end process;
end Behavioral;

-- This is the complete VHDL program for communicating with a W25Q32 flash ROM using the SPI protocol. The program includes a state machine that controls the flow of data and a data transfer process that handles the actual transmission and reception of data.

-- In the state machine, the idle state represents the default state where the module is waiting for a command from the host. When a command is received (indicated by the cs signal going low), the state machine transitions to the send_cmd state, where it sends the command byte to the flash ROM.

-- Next, the state machine transitions to the send_addr state, where it sends the address of the memory location being accessed. Finally, the state machine enters the read_data state, where it reads the data from the flash ROM and outputs it on the data_out signal.

-- The data transfer process handles the actual transmission and reception of data on the SPI lines. It shifts the received data into a shift register, with the most recently received bit being stored in the least significant bit. The data in the shift register is output on the spi_miso signal, with the most significant bit being transmitted first.

-- I hope this helps! Let me know if you have any questions or need further clarification.
