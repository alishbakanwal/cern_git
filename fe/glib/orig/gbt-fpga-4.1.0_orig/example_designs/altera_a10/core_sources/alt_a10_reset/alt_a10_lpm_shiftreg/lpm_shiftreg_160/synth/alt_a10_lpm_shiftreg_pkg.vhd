library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package alt_a10_lpm_shiftreg_pkg is
	component alt_a10_lpm_shiftreg_lpm_shiftreg_160_riayjpq is
		port (
			clock    : in  std_logic := 'X'; -- clock
			shiftin  : in  std_logic := 'X'; -- shiftin
			shiftout : out std_logic         -- shiftout
		);
	end component alt_a10_lpm_shiftreg_lpm_shiftreg_160_riayjpq;

end alt_a10_lpm_shiftreg_pkg;
