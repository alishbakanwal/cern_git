library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library work;

entity pattern_generator is 
	port
	(
		clk_i 	:  in  std_logic;
		frame_o 	:  out  std_logic_vector(83 downto 0)
	);
end pattern_generator;


architecture rtl of pattern_generator is 
signal counter	: std_logic_vector(83 downto 0):=(others=>'0');
begin

frame_o <= counter;

process(clk_i)
begin
if clk_i'event and clk_i='1' then
	counter<=counter+1;
end if;
end process;

end rtl;