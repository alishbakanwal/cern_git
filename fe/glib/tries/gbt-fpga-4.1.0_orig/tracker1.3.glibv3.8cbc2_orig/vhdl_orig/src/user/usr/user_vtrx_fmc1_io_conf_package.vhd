library ieee;
use ieee.std_logic_1164.all;
use work.fmc_package.all;
 
package user_fmc1_io_conf_package is

	constant fmc1_la_io_settings_constants:fmc_la_io_settings_array:=
	(
--=============================--
--        std   type_p  type_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_la00_cc 
		"cmos", "in__", "in__",		--fmc1_la01_cc 
		"cmos", "in__", "in__",		--fmc1_la02 
		"cmos", "in__", "in__",		--fmc1_la03 
		"cmos", "in__", "out_",		--fmc1_la04 
		"cmos", "in__", "in__",		--fmc1_la05 
		"cmos", "in__", "out_",		--fmc1_la06 
		"cmos", "in__", "in__",		--fmc1_la07 
		"cmos", "in__", "in__",		--fmc1_la08 
		"cmos", "in__", "in__",		--fmc1_la09 
		"cmos", "in__", "in__",		--fmc1_la10 
		"cmos", "in__", "in__",		--fmc1_la11 
		"cmos", "in__", "in__",		--fmc1_la12 
		"cmos", "in__", "in__",		--fmc1_la13 
		"cmos", "in__", "in__",		--fmc1_la14 
		"cmos", "i_o_", "in__",		--fmc1_la15 
		"cmos", "in__", "in__",		--fmc1_la16 
		"cmos", "in__", "in__",		--fmc1_la17_cc 
		"cmos", "out_", "out_",		--fmc1_la18_cc 
		"cmos", "in__", "i_o_",		--fmc1_la19 
		"cmos", "in__", "in__",		--fmc1_la20 
		"cmos", "in__", "in__",		--fmc1_la21 
		"cmos", "in__", "in__",		--fmc1_la22 
		"cmos", "in__", "in__",		--fmc1_la23 
		"cmos", "in__", "in__",		--fmc1_la24 
		"cmos", "in__", "in__",		--fmc1_la25 
		"cmos", "in__", "in__",		--fmc1_la26 
		"cmos", "in__", "in__",		--fmc1_la27 
		"cmos", "in__", "in__",		--fmc1_la28 
		"cmos", "in__", "in__",		--fmc1_la29 
		"cmos", "in__", "in__",		--fmc1_la30 
		"cmos", "in__", "in__",		--fmc1_la31 
		"cmos", "in__", "in__",		--fmc1_la32 
		"cmos", "in__", "in__"		--fmc1_la33 
	);         	
              	
	constant fmc1_ha_io_settings_constants:fmc_ha_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_ha00_cc 
		"cmos", "in__", "in__",		--fmc1_ha01_cc 
		"cmos", "in__", "in__",		--fmc1_ha02 
		"cmos", "in__", "in__",		--fmc1_ha03 
		"cmos", "in__", "in__",		--fmc1_ha04 
		"cmos", "in__", "in__",		--fmc1_ha05 
		"cmos", "in__", "in__",		--fmc1_ha06 
		"cmos", "in__", "in__",		--fmc1_ha07 
		"cmos", "in__", "in__",		--fmc1_ha08 
		"cmos", "in__", "in__",		--fmc1_ha09 
		"cmos", "in__", "in__",		--fmc1_ha10 
		"cmos", "in__", "in__",		--fmc1_ha11 
		"cmos", "in__", "in__",		--fmc1_ha12 
		"cmos", "in__", "in__",		--fmc1_ha13 
		"cmos", "in__", "in__",		--fmc1_ha14 
		"cmos", "in__", "in__",		--fmc1_ha15 
		"cmos", "in__", "in__",		--fmc1_ha16 
		"cmos", "in__", "in__",		--fmc1_ha17_cc 
		"cmos", "in__", "in__",		--fmc1_ha18 
		"cmos", "in__", "in__",		--fmc1_ha19 
		"cmos", "in__", "in__",		--fmc1_ha20 
		"cmos", "in__", "in__",		--fmc1_ha21 
		"cmos", "in__", "in__",		--fmc1_ha22 
		"cmos", "in__", "in__"		--fmc1_ha23 
	);        

	constant fmc1_hb_io_settings_constants:fmc_hb_io_settings_array:=
	( 
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc1_hb00_cc 
		"cmos", "in__", "in__",		--fmc1_hb01 
		"cmos", "in__", "in__",		--fmc1_hb02 
		"cmos", "in__", "in__",		--fmc1_hb03 
		"cmos", "in__", "in__",		--fmc1_hb04 
		"cmos", "in__", "in__",		--fmc1_hb05 
		"cmos", "in__", "in__",		--fmc1_hb06_cc 
		"cmos", "in__", "in__",		--fmc1_hb07 
		"cmos", "in__", "in__",		--fmc1_hb08 
		"cmos", "in__", "in__",		--fmc1_hb09 
		"cmos", "in__", "in__",		--fmc1_hb10 
		"cmos", "in__", "in__",		--fmc1_hb11 
		"cmos", "in__", "in__",		--fmc1_hb12 
		"cmos", "in__", "in__",		--fmc1_hb13 
		"cmos", "in__", "in__",		--fmc1_hb14 
		"cmos", "in__", "in__",		--fmc1_hb15 
		"cmos", "in__", "in__",		--fmc1_hb16 
		"cmos", "in__", "in__",		--fmc1_hb17_cc 
		"cmos", "in__", "in__",		--fmc1_hb18 
		"cmos", "in__", "in__",		--fmc1_hb19 
		"cmos", "in__", "in__",		--fmc1_hb20 
		"cmos", "in__", "in__"	   --fmc1_hb21
	);       	
            	

end user_fmc1_io_conf_package;
   
package body user_fmc1_io_conf_package is
end user_fmc1_io_conf_package;