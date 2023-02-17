library ieee;
use ieee.std_logic_1164.all;

entity map_48_to_64 is
    Port ( a : in  std_logic_vector(46 downto 0);
          b : out std_logic_vector(57 downto 0)
        );
end map_48_to_64;

architecture behavioral of map_48_to_64 is
begin
    b(7 downto 0) <= a(0) & a(6) & a(22) & a(21) & a(43) & a(24) & a(41) & a(34);
    b(15 downto 8) <= a(21) & a(46) & a(23) & a(22) & a(43) & a(42) & a(59) & a(40);
    b(23 downto 16) <= a(32) & a(17) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(31 downto 24) <= a(47) & a(46) & a(7) & a(22) & a(8) & a(5) & a(41) & a(40);
    b(39 downto 32) <= a(17) & a(46) & a(32) & a(44) & a(32) & a(42) & a(41) & a(32);
    b(47 downto 40) <= a(47) & a(32) & a(17) & a(22) & a(43) & a(32) & a(41) & a(17);
    b(55 downto 48) <= a(17) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(63 downto 56) <= a(1) & a(6) & a(5) & a(4) & a(3) & a(2) & a(12) & a(33);
end behavioral;