library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
generic (number_bit: integer:=10); 
port(
	reset: 	in std_logic;
	clk: 	 	in std_logic;
	shift: 	in std_logic;
	load:  	in std_logic;
	data_in: in std_logic_vector((number_bit-1) downto 0);
	a: 	 	in std_logic_vector((number_bit-1) downto 0);
	b: 	 	out std_logic_vector((number_bit-1) downto 0)
);
end reg;


architecture rtl of reg is 

begin

process(clk, reset, load, data_in)
begin 

if reset = '1' then
	b <= (others => '0');
elsif load = '1' then
	b <= data_in;
elsif rising_edge(clk) then
	if shift = '1' then
		b <= a;
	end if;
end if;

end process;

end rtl;