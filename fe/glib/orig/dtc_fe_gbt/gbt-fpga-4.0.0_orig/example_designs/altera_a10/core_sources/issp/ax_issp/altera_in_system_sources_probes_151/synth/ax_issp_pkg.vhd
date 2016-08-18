library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ax_issp_pkg is
	component altsource_probe is
		generic (
			sld_auto_instance_index : string  := "YES";
			sld_instance_index      : integer := 0;
			instance_id             : string  := "NONE";
			probe_width             : integer := 1;
			source_width            : integer := 1;
			source_initial_value    : string  := "0";
			enable_metastability    : string  := "NO"
		);
		port (
			source     : out std_logic_vector(8 downto 0);                     -- source
			probe      : in  std_logic_vector(14 downto 0) := (others => 'X'); -- probe
			source_ena : in  std_logic                     := 'X'              -- source_ena
		);
	end component altsource_probe;

end ax_issp_pkg;
