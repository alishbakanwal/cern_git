library ieee;
use ieee.std_logic_1164.all;
use work.fmc_package.all;
 
package user_fmc2_io_conf_package is

	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
	(
--=============================--
--        std   type_p  type_n	
--=============================--
		"cmos", "in__", "in__",		--fmc2_la00_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_la01_cc -- SRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_la02 
		"cmos", "in__", "in__",		--fmc2_la03 
		"cmos", "in__", "out_",		--fmc2_la04 
		"cmos", "in__", "in__",		--fmc2_la05 
		"cmos", "in__", "out_",		--fmc2_la06 
		"cmos", "in__", "in__",		--fmc2_la07 
		"cmos", "in__", "in__",		--fmc2_la08 
		"cmos", "in__", "in__",		--fmc2_la09 
		"cmos", "in__", "in__",		--fmc2_la10 
		"cmos", "in__", "in__",		--fmc2_la11 
		"cmos", "in__", "in__",		--fmc2_la12 
		"cmos", "in__", "in__",		--fmc2_la13 
		"cmos", "in__", "in__",		--fmc2_la14 
		"cmos", "in__", "in__",		--fmc2_la15 
		"cmos", "in__", "in__",		--fmc2_la16 
		"cmos", "in__", "in__",		--fmc2_la17_cc -- MRCC, COLUMN: INNER RIGHT
		"cmos", "out_", "out_",		--fmc2_la18_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "out_", "out_",		--fmc2_la19 
		"cmos", "in__", "in__",		--fmc2_la20 
		"cmos", "in__", "in__",		--fmc2_la21 
		"cmos", "in__", "in__",		--fmc2_la22 
		"cmos", "in__", "in__",		--fmc2_la23 
		"cmos", "in__", "in__",		--fmc2_la24 
		"cmos", "in__", "in__",		--fmc2_la25 
		"cmos", "in__", "in__",		--fmc2_la26 
		"cmos", "in__", "in__",		--fmc2_la27 
		"cmos", "in__", "in__",		--fmc2_la28 
		"cmos", "in__", "in__",		--fmc2_la29 
		"cmos", "in__", "in__",		--fmc2_la30 
		"cmos", "in__", "in__",		--fmc2_la31 
		"cmos", "in__", "in__",		--fmc2_la32 
		"cmos", "in__", "in__"		--fmc2_la33 
	);         	
              	
	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc2_ha00_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_ha01_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_ha02 
		"cmos", "in__", "in__",		--fmc2_ha03 
		"cmos", "in__", "in__",		--fmc2_ha04 
		"cmos", "in__", "in__",		--fmc2_ha05 
		"cmos", "in__", "in__",		--fmc2_ha06 
		"cmos", "in__", "in__",		--fmc2_ha07 
		"cmos", "in__", "in__",		--fmc2_ha08 
		"cmos", "in__", "in__",		--fmc2_ha09 
		"cmos", "in__", "in__",		--fmc2_ha10 
		"cmos", "in__", "in__",		--fmc2_ha11 
		"cmos", "in__", "in__",		--fmc2_ha12 
		"cmos", "in__", "in__",		--fmc2_ha13 
		"cmos", "in__", "in__",		--fmc2_ha14 
		"cmos", "in__", "in__",		--fmc2_ha15 
		"cmos", "in__", "in__",		--fmc2_ha16 
		"cmos", "in__", "in__",		--fmc2_ha17_cc -- MRCC, COLUMN: INNER RIGHT
		"cmos", "in__", "in__",		--fmc2_ha18 
		"cmos", "in__", "in__",		--fmc2_ha19 
		"cmos", "in__", "in__",		--fmc2_ha20 
		"cmos", "in__", "in__",		--fmc2_ha21 
		"cmos", "in__", "in__",		--fmc2_ha22 
		"cmos", "in__", "in__"		--fmc2_ha23 
	);        

	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
	( 
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--fmc2_hb00_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_hb01 
		"cmos", "in__", "in__",		--fmc2_hb02 
		"cmos", "in__", "in__",		--fmc2_hb03 
		"cmos", "in__", "in__",		--fmc2_hb04 
		"cmos", "in__", "in__",		--fmc2_hb05 
		"cmos", "in__", "in__",		--fmc2_hb06_cc -- MRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_hb07 
		"cmos", "in__", "in__",		--fmc2_hb08 
		"cmos", "in__", "in__",		--fmc2_hb09 
		"cmos", "in__", "in__",		--fmc2_hb10 
		"cmos", "in__", "in__",		--fmc2_hb11 
		"cmos", "in__", "in__",		--fmc2_hb12 
		"cmos", "in__", "in__",		--fmc2_hb13 
		"cmos", "in__", "in__",		--fmc2_hb14 
		"cmos", "in__", "in__",		--fmc2_hb15 
		"cmos", "in__", "in__",		--fmc2_hb16 
		"cmos", "in__", "in__",		--fmc2_hb17_cc -- SRCC, COLUMN: INNER LEFT
		"cmos", "in__", "in__",		--fmc2_hb18 
		"cmos", "in__", "in__",		--fmc2_hb19 
		"cmos", "in__", "in__",		--fmc2_hb20 
		"cmos", "in__", "in__"	    --fmc2_hb21
	);       	
            	

end user_fmc2_io_conf_package;
   
package body user_fmc2_io_conf_package is
end user_fmc2_io_conf_package;