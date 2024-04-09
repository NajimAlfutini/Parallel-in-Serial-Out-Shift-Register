library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library STD;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity Project_TB is
end entity;


architecture rtl of Project_tb is 

component Project is 
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
end component;

constant number_pe_reg: integer:= 10; 
constant number_bits:    integer:= 8;

signal enable_in, reset, clk, shift, load: std_logic;
signal number_in, top_numbers: std_logic_vector((number_bits-1) downto 0);

begin

UUT: Project 	generic map (number_pe_reg, number_bits)
					port map (enable_in, number_in, reset, clk, shift, load, top_numbers);

-- generate clk process
process
begin
clk <= '0';
wait for 50 ps;
clk <= '1';
wait for 50 ps;
end process;


-- stimulus process
process

file File_in: TEXT open READ_MODE is "input_file.txt";              -- chosing file to read from
variable current_reader : line;                                     -- variable to refer to the line
variable current_data : std_logic_vector((number_bits-1) downto 0); -- variable to hold the data from the line that have been read

file File_out: TEXT open WRITE_MODE is "output_file.txt";           -- chosing/making file to write in
variable current_write : line;                                      -- variableto refer to the line
 
begin 
 
enable_in <= '1';
reset <= '0';
shift <= '0';
load <= '0';


while (not endfile(File_in)) loop -- keep reading till the end of the file.

readline(File_in, current_reader);
read(current_reader, current_data);
number_in <= current_data;
wait until rising_edge(clk);

end loop;


-- flush the PE (adding zero's (number of registers) times to flush the numbers)
for i in 0 to (number_pe_reg - 1) loop 
number_in <= (others => '0');
wait until rising_edge(clk);
end loop;


enable_in <= '0';
load <= '1';

wait until rising_edge(clk);

load <= '0';
shift <= '1';

wait until rising_edge(clk);

for i in 0 to (number_pe_reg - 1) loop

write (current_write, string'("Top #"));
write (current_write, (i+1));
write (current_write, string'(" number is : "));
write (current_write, top_numbers);
write (current_write, string'("  ||  to integer :  "));
write (current_write, to_integer(unsigned(top_numbers))); -- writing the numbers in "integer".
writeline(File_out, current_write);

wait until rising_edge(clk);
end loop;

shift <= '0';

wait;
end process;

end rtl;

