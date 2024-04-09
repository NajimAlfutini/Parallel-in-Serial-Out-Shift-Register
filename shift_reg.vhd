library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg is 
generic (number_reg: integer:=10; -- number of shift register
			number_bit: integer:=8); -- number of bits for each number
port(
	reset:  in std_logic;
	clk: 	  in std_logic;
	shift:  in std_logic;
	load:   in std_logic;
	data_in:in std_logic_vector(((number_bit*number_reg)-1) downto 0);
	a: 	  in std_logic_vector((number_bit-1) downto 0);
	b: 	  out std_logic_vector((number_bit-1) downto 0)
);
end shift_reg;

architecture rtl of shift_reg is 

component reg is
generic (number_bit: integer:=8); 
port(
	reset: 	in std_logic;
	clk: 	 	in std_logic;
	shift: 	in std_logic;
	load:  	in std_logic;
	data_in: in std_logic_vector((number_bit-1) downto 0);
	a: 	 	in std_logic_vector((number_bit-1) downto 0);
	b: 	 	out std_logic_vector((number_bit-1) downto 0)
);
end component;

type my_array1 is array (0 to number_reg) of std_logic_vector((number_bit-1) downto 0);
signal sig1: my_array1;

type my_array2 is array (0 to number_reg-1) of std_logic_vector((number_bit-1) downto 0);
signal sig2: my_array2;


begin

sig1(0) <= a;
b <= sig1(number_reg);

-- slice data_in into (number_reg) signals
process(data_in)
begin 
for i in 0 to (number_reg-1) loop 
sig2(i) <= data_in( (number_bit*(number_reg-i))-1 downto (((number_bit*(number_reg-i)))-number_bit) ); 
end loop;
end process;

-- (number_reg) Instnces of reg
regs: for i in 0 to (number_reg-1) generate 
begin 
reg_inst: reg generic map(number_bit) port map (reset, clk, shift, load, sig2(i), sig1(i), sig1(i+1));
end generate;

end rtl;