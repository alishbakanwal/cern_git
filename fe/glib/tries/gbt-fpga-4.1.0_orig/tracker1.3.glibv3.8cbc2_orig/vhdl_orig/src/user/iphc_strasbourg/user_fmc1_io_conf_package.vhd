library ieee;
use ieee.std_logic_1164.all;
use work.fmc_package.all;
 
package user_fmc1_io_conf_package is

------**********************************TTC_FMC*****************************------------
	constant fmc1_la_io_settings_constants:fmc_la_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "out_", "out_",		--FMC1_LA00 
		"cmos", "out_", "out_",		--FMC1_LA01 
		"cmos", "out_", "out_",		--FMC1_LA02 
		"cmos", "out_", "out_",		--FMC1_LA03 
		"cmos", "out_", "out_",		--FMC1_LA04 
		"cmos", "out_", "out_",		--FMC1_LA05 
		"lvds", "in__", "in__",		--FMC1_LA06 
		"cmos", "out_", "i_o_",		--FMC1_LA07 
		"cmos", "in__", "in__",		--FMC1_LA08 
		"lvds", "in__", "in__",		--FMC1_LA09 
		"cmos", "out_", "out_",		--FMC1_LA10 
		"cmos", "in__", "in__",		--FMC1_LA11 
		"cmos", "in__", "in__",		--FMC1_LA12 
		"cmos", "in__", "in__",		--FMC1_LA13 
		"cmos", "in__", "in__",		--FMC1_LA14 
		"cmos", "out_", "in__",		--FMC1_LA15 
		"cmos", "in__", "in__",		--FMC1_LA16 
		"cmos", "in__", "in__",		--FMC1_LA17 
		"cmos", "in__", "in__",		--FMC1_LA18 
		"cmos", "in__", "in__",		--FMC1_LA19 
		"cmos", "in__", "in__",		--FMC1_LA20 
		"cmos", "in__", "in__",		--FMC1_LA21 
		"cmos", "in__", "in__",		--FMC1_LA22 
		"cmos", "in__", "in__",		--FMC1_LA23 
		"cmos", "in__", "in__",		--FMC1_LA24 
		"cmos", "in__", "in__",		--FMC1_LA25 
		"cmos", "in__", "in__",		--FMC1_LA26 
		"cmos", "in__", "in__",		--FMC1_LA27 
		"cmos", "in__", "in__",		--FMC1_LA28 
		"cmos", "in__", "in__",		--FMC1_LA29 
		"cmos", "in__", "in__",		--FMC1_LA30 
		"cmos", "in__", "in__",		--FMC1_LA31 
		"cmos", "in__", "in__",		--FMC1_LA32 
		"cmos", "in__", "in__"		--FMC1_LA33 
	);  --"out_"   "in__"	"i_o_" "ckin" "lvds"	"cmos"       	
              	
	constant fmc1_ha_io_settings_constants:fmc_ha_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--FMC1_HA00 
		"cmos", "in__", "in__",		--FMC1_HA01 
		"cmos", "in__", "in__",		--FMC1_HA02 
		"cmos", "in__", "in__",		--FMC1_HA03 
		"cmos", "in__", "in__",		--FMC1_HA04 
		"cmos", "in__", "in__",		--FMC1_HA05 
		"cmos", "in__", "in__",		--FMC1_HA06 
		"cmos", "in__", "in__",		--FMC1_HA07 
		"cmos", "in__", "in__",		--FMC1_HA08 
		"cmos", "in__", "in__",		--FMC1_HA09 
		"cmos", "in__", "in__",		--FMC1_HA10 
		"cmos", "in__", "in__",		--FMC1_HA11 
		"cmos", "in__", "in__",		--FMC1_HA12 
		"cmos", "in__", "in__",		--FMC1_HA13 
		"cmos", "in__", "in__",		--FMC1_HA14 
		"cmos", "in__", "in__",		--FMC1_HA15 
		"cmos", "in__", "in__",		--FMC1_HA16 
		"cmos", "in__", "in__",		--FMC1_HA17 
		"cmos", "in__", "in__",		--FMC1_HA18 
		"cmos", "in__", "in__",		--FMC1_HA19 
		"cmos", "in__", "in__",		--FMC1_HA20 
		"cmos", "in__", "in__",		--FMC1_HA21 
		"cmos", "in__", "in__",		--FMC1_HA22 
		"cmos", "in__", "in__"		--FMC1_HA23 
	);        

	constant fmc1_hb_io_settings_constants:fmc_hb_io_settings_array:=
	( 
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "in__", "in__",		--FMC1_HB00 
		"cmos", "in__", "in__",		--FMC1_HB01 
		"cmos", "in__", "in__",		--FMC1_HB02 
		"cmos", "in__", "in__",		--FMC1_HB03 
		"cmos", "in__", "in__",		--FMC1_HB04 
		"cmos", "in__", "in__",		--FMC1_HB05 
		"cmos", "in__", "in__",		--FMC1_HB06 
		"cmos", "in__", "in__",		--FMC1_HB07 
		"cmos", "in__", "in__",		--FMC1_HB08 
		"cmos", "in__", "in__",		--FMC1_HB09 
		"cmos", "in__", "in__",		--FMC1_HB10 
		"cmos", "in__", "in__",		--FMC1_HB11 
		"cmos", "in__", "in__",		--FMC1_HB12 
		"cmos", "in__", "in__",		--FMC1_HB13 
		"cmos", "in__", "in__",		--FMC1_HB14 
		"cmos", "in__", "in__",		--FMC1_HB15 
		"cmos", "in__", "in__",		--FMC1_HB16 
		"cmos", "in__", "in__",		--FMC1_HB17 
		"cmos", "in__", "in__",		--FMC1_HB18 
		"cmos", "in__", "in__",		--FMC1_HB19 
		"cmos", "in__", "in__",		--FMC1_HB20 
		"cmos", "in__", "in__"	    --FMC1_HB21
	);       	
------******************************END TTC_FMC*****************************------------




------**********************************TEST*****************************------------
--	
----	--CASE1 : B : OUT / A : IN
----	constant fmc1_la_io_settings_constants:fmc_la_io_settings_array:=
----	(
------=============================--
------    std     dir_p   dir_n	
------=============================--
----		"lvds", "out_", "out_",		--FMC1_LA00		--B_TLD0
----		"lvds", "out_", "out_",		--FMC1_LA01		--B_TLA0 
----		"lvds", "in__", "in__",		--FMC1_LA02		--A_TLA0 
----		"lvds", "in__", "in__",		--FMC1_LA03		-- 
----		"lvds", "in__", "in__",		--FMC1_LA04		--A_TLB0  
----		"lvds", "out_", "out_",		--FMC1_LA05		--B_TLC0 
----		"lvds", "out_", "out_",		--FMC1_LA06		--B_TLB0 
----		"lvds", "in__", "in__",		--FMC1_LA07		--A_TLC0 
----		"lvds", "in__", "in__",		--FMC1_LA08		-- 
----		"lvds", "out_", "out_",		--FMC1_LA09		--B_TLE0  
----		"lvds", "out_", "out_",		--FMC1_LA10		--B_TLA1 
----		"lvds", "in__", "in__",		--FMC1_LA11		--A_TLD0 
----		"lvds", "in__", "in__",		--FMC1_LA12		-- 
----		"lvds", "out_", "out_",		--FMC1_LA13		--B_TLB1 
----		"lvds", "out_", "out_",		--FMC1_LA14		--B_TLC1 
----		"lvds", "in__", "in__",		--FMC1_LA15		--A_TLE0 
----		"lvds", "in__", "in__",		--FMC1_LA16		-- 
----		"lvds", "out_", "out_",		--FMC1_LA17		--B_TLCLK1 / IO_CC
----		"lvds", "out_", "out_",		--FMC1_LA18		--B_TLD1
----		"lvds", "in__", "in__",		--FMC1_LA19		--A_TLA1 
----		"lvds", "in__", "in__",		--FMC1_LA20		-- 
----		"lvds", "in__", "in__",		--FMC1_LA21		--A_TLB1 
----		"lvds", "in__", "in__",		--FMC1_LA22		-- 
----		"lvds", "out_", "out_",		--FMC1_LA23		--B_TLE1 
----		"lvds", "in__", "in__",		--FMC1_LA24		--A_TLC1
----		"lvds", "in__", "in__",		--FMC1_LA25		-- 
----		"lvds", "out_", "out_",		--FMC1_LA26		--B_TLF0 
----		"lvds", "out_", "out_",		--FMC1_LA27		--B_TLF1 
----		"lvds", "ckin", "in__",		--FMC1_LA28		--A_TLCLK1 / IO_CC 
----		"lvds", "in__", "in__",		--FMC1_LA29		--
----		"lvds", "in__", "in__",		--FMC1_LA30		--A_TLD1 
----		"lvds", "in__", "in__",		--FMC1_LA31		--A_TLF0
----		"lvds", "in__", "in__",		--FMC1_LA32		--A_TLE1
----		"lvds", "in__", "in__"		--FMC1_LA33		--A_TLF1
----	);         	
-- 
----	--CASE2 : A : OUT / B : IN
----	constant fmc1_la_io_settings_constants:fmc_la_io_settings_array:=
----	(
------=============================--
------    std     dir_p   dir_n	
------=============================--
----		"lvds", "in__", "in__",		--FMC1_LA00		--B_TLD0
----		"lvds", "in__", "in__",		--FMC1_LA01		--B_TLA0 
----		"lvds", "out_", "out_",		--FMC1_LA02		--A_TLA0 
----		"lvds", "in__", "in__",		--FMC1_LA03		-- 
----		"lvds", "out_", "out_",		--FMC1_LA04		--A_TLB0  
----		"lvds", "in__", "in__",		--FMC1_LA05		--B_TLC0 
----		"lvds", "in__", "in__",		--FMC1_LA06		--B_TLB0 
----		"lvds", "out_", "out_",		--FMC1_LA07		--A_TLC0 
----		"lvds", "in__", "in__",		--FMC1_LA08		-- 
----		"lvds", "in__", "in__",		--FMC1_LA09		--B_TLE0  
----		"lvds", "in__", "in__",		--FMC1_LA10		--B_TLA1 
----		"lvds", "out_", "out_",		--FMC1_LA11		--A_TLD0 
----		"lvds", "in__", "in__",		--FMC1_LA12		-- 
----		"lvds", "in__", "in__",		--FMC1_LA13		--B_TLB1 
----		"lvds", "in__", "in__",		--FMC1_LA14		--B_TLC1 
----		"lvds", "out_", "out_",		--FMC1_LA15		--A_TLE0 
----		"lvds", "in__", "in__",		--FMC1_LA16		-- 
----		"lvds", "ckin", "in__",		--FMC1_LA17		--B_TLCLK1 / IO_CC
----		"lvds", "in__", "in__",		--FMC1_LA18		--B_TLD1
----		"lvds", "out_", "out_",		--FMC1_LA19		--A_TLA1 
----		"lvds", "in__", "in__",		--FMC1_LA20		-- 
----		"lvds", "out_", "out_",		--FMC1_LA21		--A_TLB1 
----		"lvds", "in__", "in__",		--FMC1_LA22		-- 
----		"lvds", "in__", "in__",		--FMC1_LA23		--B_TLE1 
----		"lvds", "out_", "out_",		--FMC1_LA24		--A_TLC1
----		"lvds", "in__", "in__",		--FMC1_LA25		-- 
----		"lvds", "in__", "in__",		--FMC1_LA26		--B_TLF0 
----		"lvds", "in__", "in__",		--FMC1_LA27		--B_TLF1 
----		"lvds", "out_", "out_",		--FMC1_LA28		--A_TLCLK1 / NOT IO_CC !!!!
----		"lvds", "in__", "in__",		--FMC1_LA29		--
----		"lvds", "out_", "out_",		--FMC1_LA30		--A_TLD1 
----		"lvds", "out_", "out_",		--FMC1_LA31		--A_TLF0
----		"lvds", "out_", "out_",		--FMC1_LA32		--A_TLE1
----		"lvds", "out_", "out_"		--FMC1_LA33		--A_TLF1
----	);         	
--
--	--CASE3 : B : IN/OUT - test RJ45 1/2 connected on CN2=B
--	--CASE RJ45 n°1 : OUT / RJ45 n°2 : IN
--	constant fmc1_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "out_", "out_",		--FMC1_LA00		--B_TLD0 --CC
--		"lvds", "in__", "in__",		--FMC1_LA01		--B_TLA0 
--		"lvds", "in__", "in__",		--FMC1_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC1_LA03		-- 
--		"lvds", "in__", "in__",		--FMC1_LA04		--A_TLB0  
--		"lvds", "in__", "in__",		--FMC1_LA05		--B_TLC0 
--		"lvds", "in__", "in__",		--FMC1_LA06		--B_TLB0 
--		"lvds", "in__", "in__",		--FMC1_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC1_LA08		-- 
--		"lvds", "in__", "in__",		--FMC1_LA09		--B_TLE0  
--		"lvds", "out_", "out_",		--FMC1_LA10		--B_TLA1 
--		"lvds", "in__", "in__",		--FMC1_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC1_LA12		-- 
--		"lvds", "out_", "out_",		--FMC1_LA13		--B_TLB1 
--		"lvds", "out_", "out_",		--FMC1_LA14		--B_TLC1 
--		"lvds", "in__", "in__",		--FMC1_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC1_LA16		-- 
--		"lvds", "in__", "in__",		--FMC1_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "in__", "in__",		--FMC1_LA18		--B_TLD1
--		"lvds", "in__", "in__",		--FMC1_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC1_LA20		-- 
--		"lvds", "in__", "in__",		--FMC1_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC1_LA22		-- 
--		"lvds", "in__", "in__",		--FMC1_LA23		--B_TLE1 
--		"lvds", "in__", "in__",		--FMC1_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC1_LA25		-- 
--		"lvds", "in__", "in__",		--FMC1_LA26		--B_TLF0 
--		"lvds", "in__", "in__",		--FMC1_LA27		--B_TLF1 
--		"lvds", "in__", "in__",		--FMC1_LA28		--A_TLCLK1 / NOT IO_CC !!!!
--		"lvds", "in__", "in__",		--FMC1_LA29		--
--		"lvds", "in__", "in__",		--FMC1_LA30		--A_TLD1 
--		"lvds", "in__", "in__",		--FMC1_LA31		--A_TLF0
--		"lvds", "in__", "in__",		--FMC1_LA32		--A_TLE1
--		"lvds", "in__", "in__"		--FMC1_LA33		--A_TLF1
--	); 
--	
--	
--	
--              	
--	constant fmc1_ha_io_settings_constants:fmc_ha_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"cmos", "in__", "in__",		--FMC1_HA00 
--		"cmos", "in__", "in__",		--FMC1_HA01 
--		"cmos", "in__", "in__",		--FMC1_HA02 
--		"cmos", "in__", "in__",		--FMC1_HA03 
--		"cmos", "in__", "in__",		--FMC1_HA04 
--		"cmos", "in__", "in__",		--FMC1_HA05 
--		"cmos", "in__", "in__",		--FMC1_HA06 
--		"cmos", "in__", "in__",		--FMC1_HA07 
--		"cmos", "in__", "in__",		--FMC1_HA08 
--		"cmos", "in__", "in__",		--FMC1_HA09 
--		"cmos", "in__", "in__",		--FMC1_HA10 
--		"cmos", "in__", "in__",		--FMC1_HA11 
--		"cmos", "in__", "in__",		--FMC1_HA12 
--		"cmos", "in__", "in__",		--FMC1_HA13 
--		"cmos", "in__", "in__",		--FMC1_HA14 
--		"cmos", "in__", "in__",		--FMC1_HA15 
--		"cmos", "in__", "in__",		--FMC1_HA16 
--		"cmos", "in__", "in__",		--FMC1_HA17 
--		"cmos", "in__", "in__",		--FMC1_HA18 
--		"cmos", "in__", "in__",		--FMC1_HA19 
--		"cmos", "in__", "in__",		--FMC1_HA20 
--		"cmos", "in__", "in__",		--FMC1_HA21 
--		"cmos", "in__", "in__",		--FMC1_HA22 
--		"cmos", "in__", "in__"		--FMC1_HA23 
--	);        
--
--	constant fmc1_hb_io_settings_constants:fmc_hb_io_settings_array:=
--	( 
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"cmos", "in__", "in__",		--FMC1_HB00 
--		"cmos", "in__", "in__",		--FMC1_HB01 
--		"cmos", "in__", "in__",		--FMC1_HB02 
--		"cmos", "in__", "in__",		--FMC1_HB03 
--		"cmos", "in__", "in__",		--FMC1_HB04 
--		"cmos", "in__", "in__",		--FMC1_HB05 
--		"cmos", "in__", "in__",		--FMC1_HB06 
--		"cmos", "in__", "in__",		--FMC1_HB07 
--		"cmos", "in__", "in__",		--FMC1_HB08 
--		"cmos", "in__", "in__",		--FMC1_HB09 
--		"cmos", "in__", "in__",		--FMC1_HB10 
--		"cmos", "in__", "in__",		--FMC1_HB11 
--		"cmos", "in__", "in__",		--FMC1_HB12 
--		"cmos", "in__", "in__",		--FMC1_HB13 
--		"cmos", "in__", "in__",		--FMC1_HB14 
--		"cmos", "in__", "in__",		--FMC1_HB15 
--		"cmos", "in__", "in__",		--FMC1_HB16 
--		"cmos", "in__", "in__",		--FMC1_HB17 
--		"cmos", "in__", "in__",		--FMC1_HB18 
--		"cmos", "in__", "in__",		--FMC1_HB19 
--		"cmos", "in__", "in__",		--FMC1_HB20 
--		"cmos", "in__", "in__"	    --FMC1_HB21
--	);       	
--
------*******************************END TEST*****************************------------

            	

end user_fmc1_io_conf_package;
   
package body user_fmc1_io_conf_package is
end user_fmc1_io_conf_package;