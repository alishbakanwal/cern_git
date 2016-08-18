library IEEE;
use IEEE.STD_LOGIC_1164.all;

package wb_package is

-- The signals going from master to slaves
  type wb_mosi_bus is
    record
			wb_rst 		: std_logic;
			wb_clk 		: std_logic;
			wb_adr 		: std_logic_vector(31 downto 0);
			wb_dat 		: std_logic_vector(31 downto 0);
			wb_stb 		: std_logic;
			wb_we 		: std_logic;
			wb_sel		: std_logic_vector( 3 downto 0);
			wb_cyc		: std_logic;
    end record;

	type wb_mosi_bus_array is array(natural range <>) of wb_mosi_bus;
	 
	 type wb_miso_bus is
    record
		  wb_dat 		: std_logic_vector(31 downto 0);
		  wb_ack 		: std_logic;
		  wb_err 		: std_logic;
    end record;

	type wb_miso_bus_array is array(natural range <>) of wb_miso_bus;

end wb_package;