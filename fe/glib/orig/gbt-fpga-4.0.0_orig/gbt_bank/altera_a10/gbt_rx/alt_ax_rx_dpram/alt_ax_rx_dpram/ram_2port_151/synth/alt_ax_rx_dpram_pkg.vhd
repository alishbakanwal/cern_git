library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package alt_ax_rx_dpram_pkg is
	component alt_ax_rx_dpram_ram_2port_151_ml2beca is
		port (
			data      : in  std_logic_vector(19 downto 0)  := (others => 'X'); -- datain
			wraddress : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- wraddress
			rdaddress : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rdaddress
			wren      : in  std_logic                      := 'X';             -- wren
			wrclock   : in  std_logic                      := 'X';             -- wrclock
			rdclock   : in  std_logic                      := 'X';             -- rdclock
			q         : out std_logic_vector(159 downto 0)                     -- dataout
		);
	end component alt_ax_rx_dpram_ram_2port_151_ml2beca;

end alt_ax_rx_dpram_pkg;
