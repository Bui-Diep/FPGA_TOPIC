library ieee;
use ieee.std_logic_1164.all;

entity map_48_to_56 is
    Port ( a : in  std_logic_vector(47 downto 0);
          b : out std_logic_vector(55 downto 0)
        );
end map_48_to_56;

architecture behavioral of map_48_to_56 is
begin
    b(7 downto 0) <= a(0) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(15 downto 8) <= a(47) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(23 downto 16) <= a(47) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(31 downto 24) <= a(47) & a(46) & a(7) & a(44) & a(8) & a(5) & a(41) & a(40);
    b(39 downto 32) <= a(47) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(47 downto 40) <= a(47) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
    b(54 downto 48) <= a(47) & a(46) & a(45) & a(44) & a(43) & a(42) & a(41) & a(40);
end behavioral;