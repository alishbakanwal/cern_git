library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package frameclk_pll_pkg is
	component frameclk_pll_altera_iopll_151_va2pmui is
		port (
			rst              : in  std_logic                    := 'X';             -- reset
			refclk           : in  std_logic                    := 'X';             -- clk
			locked           : out std_logic;                                       -- export
			scanclk          : in  std_logic                    := 'X';             -- scanclk
			phase_en         : in  std_logic                    := 'X';             -- phase_en
			updn             : in  std_logic                    := 'X';             -- updn
			cntsel           : in  std_logic_vector(4 downto 0) := (others => 'X'); -- cntsel
			phase_done       : out std_logic;                                       -- phase_done
			num_phase_shifts : in  std_logic_vector(2 downto 0) := (others => 'X'); -- num_phase_shifts
			outclk_0         : out std_logic                                        -- clk
		);
	end component frameclk_pll_altera_iopll_151_va2pmui;

end frameclk_pll_pkg;
