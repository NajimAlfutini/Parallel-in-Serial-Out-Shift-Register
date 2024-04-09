library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project is 
generic(number_pe_reg: integer:= 10; -- the number of the top-numbers 
		  number_bits: integer:= 8);   -- the number's bits of numbers
port(
	enable_in:    in std_logic;
	number_in: 	  in std_logic_vector((number_bits-1) downto 0);
	reset:    	  in std_logic;
	clk: 	     	  in std_logic;
	shift:     	  in std_logic;
	load:     	  in std_logic;
	top_numbers:  out std_logic_vector((number_bits-1) downto 0)
);
end Project;

architecture rtl of Project is
 
component PE_array is
generic (number_pe: integer:= 10; number_bit: integer:= 8);
port (
	clk:		    in std_logic;
	reset:		 in std_logic;
	enable_in :	 in std_logic;
	number_in :  in std_logic_vector((number_bit-1) downto 0);
	numbers:     out std_logic_vector(((number_bit * number_pe)-1) downto 0)
	
);
end component;

component shift_reg is 
generic (number_reg: integer:=10; number_bit: integer:=8); 
port(
	reset:  in std_logic;
	clk: 	  in std_logic;
	shift:  in std_logic;
	load:   in std_logic;
	data_in:in std_logic_vector(((number_bit*number_reg)-1) downto 0);
	a: 	  in std_logic_vector((number_bit-1) downto 0);
	b: 	  out std_logic_vector((number_bit-1) downto 0)
);
end component;

signal number: std_logic_vector(((number_bits * number_pe_reg)-1) downto 0);
begin 

PE_array_inst: PE_array generic map (number_pe_reg, number_bits) 
								port    map (clk, reset, enable_in, number_in,number);
	
shift_reg_inst: shift_reg generic map (number_pe_reg, number_bits) 
									port   map (reset, clk, shift, load, number, (others=>'0') ,top_numbers);

end rtl;