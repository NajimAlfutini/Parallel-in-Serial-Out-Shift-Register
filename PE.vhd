library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PE is
generic (number_bit: integer:=8);  
port (
	clk: 				in std_logic;
	reset:		 	in std_logic;
	number_in:	 	in std_logic_vector((number_bit-1) downto 0);
	enable_in: 		in std_logic;
	number_out:		out std_logic_vector((number_bit-1) downto 0);
	enable_out: 	out std_logic;
	number:			out std_logic_vector((number_bit-1) downto 0)
);
end entity;


architecture rtl of PE is 

signal stored_number: std_logic_vector((number_bit-1) downto 0):= (others => '0');

begin

process(reset, clk)
begin

if reset = '1' then
	number_out    <= (others => '0');
	enable_out    <= '0';
	stored_number <= (others => '0');

elsif rising_edge(clk) then
	if enable_in = '1' then
		if(number_in > stored_number) then
			enable_out <= '1';
			number_out <= stored_number;
			stored_number <= number_in;
		else
			enable_out <= '1';
			number_out <= number_in;
		end if;
	end if;
end if;
end process; 

number <= stored_number;

end rtl;