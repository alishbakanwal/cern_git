library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;
use work.fmc_package.all;

entity fmc_io_buffers is
generic
(
	fmc_la_io_settings		: fmc_la_io_settings_array:= fmc_la_io_settings_defaults;
	fmc_ha_io_settings		: fmc_ha_io_settings_array:= fmc_ha_io_settings_defaults;
	fmc_hb_io_settings		: fmc_hb_io_settings_array:= fmc_hb_io_settings_defaults
);
port
(
	fmc_io_pin					: inout	fmc_io_pin_type;
	fmc_from_fabric_to_pin	: in		fmc_from_fabric_to_pin_type;
	fmc_from_pin_to_fabric	: out		fmc_from_pin_to_fabric_type
);                    	
end fmc_io_buffers;
							
architecture fmc_io_buffers_arch of fmc_io_buffers is                    	
     	
	
begin -- architecture

--=============================--
--== fmc LA buffers ==-- 
--=============================--
la: for i in 0 to 33 
generate
	fmc_la_buf		: 	entity work.fmc_io_pair 
	generic map 	( 	
							standard 	=> fmc_la_io_settings(3*i+0), 
							direction_p => fmc_la_io_settings(3*i+1), 
							direction_n => fmc_la_io_settings(3*i+2)
						)
	port map 		( 	
							io_p 			=> fmc_io_pin.la_p(i), 			
							io_n 			=> fmc_io_pin.la_n(i), 	 		
							------------
							lvds_i		=> fmc_from_pin_to_fabric.la_lvds(i), 		
							lvds_o		=> fmc_from_fabric_to_pin.la_lvds(i), 		
							lvds_oe_l 	=> fmc_from_fabric_to_pin.la_lvds_oe_l(i), 
							
							cmos_p_i		=> fmc_from_pin_to_fabric.la_cmos_p(i),   
							cmos_p_o		=> fmc_from_fabric_to_pin.la_cmos_p(i),   
							cmos_p_oe_l => fmc_from_fabric_to_pin.la_cmos_p_oe_l(i),
							
							cmos_n_i		=> fmc_from_pin_to_fabric.la_cmos_n(i), 	
							cmos_n_o		=> fmc_from_fabric_to_pin.la_cmos_n(i), 	
							cmos_n_oe_l => fmc_from_fabric_to_pin.la_cmos_n_oe_l(i)
						);
end generate;
--=============================--



--=============================--
--== fmc HA buffers ==-- 
--=============================--
ha: for i in 0 to 23 
generate
	fmc_ha_buf		: 	entity work.fmc_io_pair 
	generic map 	( 	
							standard 	=> fmc_ha_io_settings(3*i+0), 
							direction_p => fmc_ha_io_settings(3*i+1), 
							direction_n => fmc_ha_io_settings(3*i+2)
						)
	port map 		( 	
							io_p 			=> fmc_io_pin.ha_p(i), 			
							io_n 			=> fmc_io_pin.ha_n(i), 	 		
							------------
							lvds_i		=> fmc_from_pin_to_fabric.ha_lvds(i), 		
							lvds_o		=> fmc_from_fabric_to_pin.ha_lvds(i), 		
							lvds_oe_l 	=> fmc_from_fabric_to_pin.ha_lvds_oe_l(i), 
							
							cmos_p_i		=> fmc_from_pin_to_fabric.ha_cmos_p(i),   
							cmos_p_o		=> fmc_from_fabric_to_pin.ha_cmos_p(i),   
							cmos_p_oe_l => fmc_from_fabric_to_pin.ha_cmos_p_oe_l(i),
							
							cmos_n_i		=> fmc_from_pin_to_fabric.ha_cmos_n(i), 	
							cmos_n_o		=> fmc_from_fabric_to_pin.ha_cmos_n(i), 	
							cmos_n_oe_l => fmc_from_fabric_to_pin.ha_cmos_n_oe_l(i)
						);
end generate;
--=============================--



--=============================--
--== fmc HB buffers ==-- 
--=============================--
hb: for i in 0 to 21 
generate
	fmc_hb_buf		: 	entity work.fmc_io_pair 
	generic map 	( 	
							standard 	=> fmc_hb_io_settings(3*i+0), 
							direction_p => fmc_hb_io_settings(3*i+1), 
							direction_n => fmc_hb_io_settings(3*i+2)
						)
	port map 		( 	
							io_p 			=> fmc_io_pin.hb_p(i), 			
							io_n 			=> fmc_io_pin.hb_n(i), 	 		
							------------
							lvds_i		=> fmc_from_pin_to_fabric.hb_lvds(i), 		
							lvds_o		=> fmc_from_fabric_to_pin.hb_lvds(i), 		
							lvds_oe_l 	=> fmc_from_fabric_to_pin.hb_lvds_oe_l(i), 
							
							cmos_p_i		=> fmc_from_pin_to_fabric.hb_cmos_p(i),   
							cmos_p_o		=> fmc_from_fabric_to_pin.hb_cmos_p(i),   
							cmos_p_oe_l => fmc_from_fabric_to_pin.hb_cmos_p_oe_l(i),
							
							cmos_n_i		=> fmc_from_pin_to_fabric.hb_cmos_n(i), 	
							cmos_n_o		=> fmc_from_fabric_to_pin.hb_cmos_n(i), 	
							cmos_n_oe_l => fmc_from_fabric_to_pin.hb_cmos_n_oe_l(i)
						);
end generate;
--=============================--


	
end fmc_io_buffers_arch;