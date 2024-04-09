library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PE_array is
generic (number_pe: integer:= 10; number_bit: integer:= 8);
port (
	clk:		    in std_logic;
	reset:		 in std_logic;
	enable_in :	 in std_logic;
	number_in :  in std_logic_vector((number_bit-1) downto 0);
	numbers:     out std_logic_vector(((number_bit * number_pe)-1) downto 0)
);
end entity; 

architecture rtl of PE_array is 

-- this array for numbers in and out 
type my_array1 is array (0 to number_pe) of std_logic_vector((number_bit-1) downto 0);
signal number_sig: my_array1;

-- this array for enable in and out
type my_array2 is array (0 to number_pe) of std_logic;
signal enable_sig: my_array2;

component PE is
generic (number_bit: integer:= 8);
port (
	clk: 				in  std_logic;
	reset:		 	in  std_logic;
	number_in:	 	in  std_logic_vector((number_bit-1) downto 0);
	enable_in: 		in  std_logic;
	number_out:		out std_logic_vector((number_bit-1) downto 0);
	enable_out: 	out std_logic;
	number:			out std_logic_vector((number_bit-1) downto 0)
);
end component;

begin

enable_sig(0) <= enable_in;
number_sig(0) <= number_in;

array_pe: for i in 0 to (number_pe-1) generate 
begin 
PE_inst: PE generic map(number_bit) port map(clk, reset, 
															number_sig(i), 
															enable_sig(i),
															number_sig(i+1), 
															enable_sig(i+1), 
															numbers((number_bit*(i+1))-1 downto number_bit*(i))
);
end generate;

end rtl;