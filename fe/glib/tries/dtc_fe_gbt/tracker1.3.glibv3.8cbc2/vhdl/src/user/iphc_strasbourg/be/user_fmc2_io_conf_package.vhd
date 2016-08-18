library ieee;
use ieee.std_logic_1164.all;
use work.fmc_package.all;
 
package user_fmc2_io_conf_package is


------**********************************TTC_FMC*****************************------------
	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "out_", "out_",		--FMC2_LA00 
		"cmos", "out_", "out_",		--FMC2_LA01 
		"cmos", "out_", "out_",		--FMC2_LA02 
		"cmos", "out_", "out_",		--FMC2_LA03 
		"cmos", "out_", "out_",		--FMC2_LA04 
		"cmos", "out_", "out_",		--FMC2_LA05 
		"lvds", "in__", "in__",		--FMC2_LA06 
		"cmos", "out_", "i_o_",		--FMC2_LA07 
		"cmos", "in__", "in__",		--FMC2_LA08 
		"lvds", "in__", "in__",		--FMC2_LA09 
		"cmos", "out_", "out_",		--FMC2_LA10 
		"cmos", "in__", "in__",		--FMC2_LA11 
		"cmos", "in__", "in__",		--FMC2_LA12 
		"cmos", "in__", "in__",		--FMC2_LA13 
		"cmos", "in__", "in__",		--FMC2_LA14 
		"cmos", "out_", "in__",		--FMC2_LA15 
		"cmos", "in__", "in__",		--FMC2_LA16 
		"cmos", "in__", "in__",		--FMC2_LA17 
		"cmos", "in__", "in__",		--FMC2_LA18 
		"cmos", "in__", "in__",		--FMC2_LA19 
		"cmos", "in__", "in__",		--FMC2_LA20 
		"cmos", "in__", "in__",		--FMC2_LA21 
		"cmos", "in__", "in__",		--FMC2_LA22 
		"cmos", "in__", "in__",		--FMC2_LA23 
		"cmos", "in__", "in__",		--FMC2_LA24 
		"cmos", "in__", "in__",		--FMC2_LA25 
		"cmos", "in__", "in__",		--FMC2_LA26 
		"cmos", "in__", "in__",		--FMC2_LA27 
		"cmos", "in__", "in__",		--FMC2_LA28 
		"cmos", "in__", "in__",		--FMC2_LA29 
		"cmos", "in__", "in__",		--FMC2_LA30 
		"cmos", "in__", "in__",		--FMC2_LA31 
		"cmos", "in__", "in__",		--FMC2_LA32 
		"cmos", "in__", "in__"		--FMC2_LA33 
	);  --"out_"   "in__"	"i_o_" "ckin" "lvds"	"cmos"       	
              	


--	--CBCv2 + FMC_carrier
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_LA00		-- TRIGDATA_CBC2_B_LVDS
--		"lvds", "in__", "in__",		--FMC2_LA01		
--		"lvds", "in__", "in__",		--FMC2_LA02		-- STUBDATA_CBC2_B_LVDS		
--		"lvds", "in__", "in__",		--FMC2_LA03			
--		"lvds", "in__", "in__",		--FMC2_LA04		-- TRIGGER_CBC2_B_LVDS	  
--		"lvds", "in__", "in__",		--FMC2_LA05	 
--		"lvds", "in__", "in__",		--FMC2_LA06	 
--		"lvds", "in__", "in__",		--FMC2_LA07		-- TRIGDATA_CBC2_A_LVDS	 
--		"lvds", "in__", "in__",		--FMC2_LA08	 
--		"lvds", "in__", "in__",		--FMC2_LA09	
--		"lvds", "in__", "in__",		--FMC2_LA10	
--		"lvds", "in__", "in__",		--FMC2_LA11		-- STUBDATA_CBC2_A_LVDS		 
--		"lvds", "in__", "in__",		--FMC2_LA12		
--		"lvds", "in__", "in__",		--FMC2_LA13	 
--		"lvds", "in__", "in__",		--FMC2_LA14	
--		"lvds", "out_", "out_",		--FMC2_LA15		-- T1_TRIGGER_LVDS	
--		"lvds", "in__", "in__",		--FMC2_LA16		-- TRIGGER_CBC2_A_LVDS		
--		"lvds", "in__", "in__",		--FMC2_LA17		
--		"lvds", "in__", "in__",		--FMC2_LA18		
--		"lvds", "out_", "out_",		--FMC2_LA19		-- TEST_PULSE_LVDS			 
--		"lvds", "out_", "out_",		--FMC2_LA20		-- FAST_RESET_LVDS		
--		"lvds", "out_", "out_",		--FMC2_LA21		-- I2C_REFRESH_LVDS		 
--		"lvds", "in__", "in__",		--FMC2_LA22		
--		"lvds", "in__", "in__",		--FMC2_LA23		
--		"lvds", "out_", "out_",		--FMC2_LA24		-- CLKIN_40_LVDS		
--		"lvds", "out_", "out_",		--FMC2_LA25		-- CLK_DCDC_LVDS <=> 1MHz towards DC-DC converter			 
--		"lvds", "in__", "in__",		--FMC2_LA26		
--		"lvds", "in__", "in__",		--FMC2_LA27		 
--		"lvds", "out_", "out_",		--FMC2_LA28		-- SDA_TO_CBC		
--		"lvds", "in__", "in__",		--FMC2_LA29		-- SDA_FROM_CBC		
--		"lvds", "out_", "out_",		--FMC2_LA30		-- RESET_2V5	
--		"lvds", "out_", "out_",		--FMC2_LA31		-- SCLK_2V5		
--		"lvds", "out_", "out_",		--FMC2_LA32		-- LVDS_DATA_OUT	-> TEST
--		"lvds", "in__", "in__"		--FMC2_LA33		-- LVDS_DATA_IN	-> TEST	
--	);  --"out_"   "in__"	"i_o_" "ckin" "lvds"	"cmos"





--	--CASE_BEAM_TEST DESY - LVDS CARD
--	--CASE RJ45 n°1 : tlu
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "out_", "out_",		--FMC2_LA00		--B_TLD0 --CC
--		"lvds", "in__", "in__",		--FMC2_LA01		--B_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA03		-- 
--		"lvds", "in__", "in__",		--FMC2_LA04		--A_TLB0  
--		"lvds", "in__", "in__",		--FMC2_LA05		--B_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA06		--B_TLB0 
--		"lvds", "in__", "in__",		--FMC2_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA08		-- 
--		"lvds", "in__", "in__",		--FMC2_LA09		--B_TLE0  
--		"lvds", "in__", "in__",		--FMC2_LA10		--B_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC2_LA12		-- 
--		"lvds", "in__", "in__",		--FMC2_LA13		--B_TLB1 
--		"lvds", "out_", "out_",		--FMC2_LA14		--B_TLC1 
--		"lvds", "in__", "in__",		--FMC2_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC2_LA16		-- 
--		"lvds", "in__", "in__",		--FMC2_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "in__", "in__",		--FMC2_LA18		--B_TLD1
--		"lvds", "in__", "in__",		--FMC2_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA20		-- 
--		"lvds", "in__", "in__",		--FMC2_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA22		-- 
--		"lvds", "in__", "in__",		--FMC2_LA23		--B_TLE1 
--		"lvds", "in__", "in__",		--FMC2_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC2_LA25		-- 
--		"lvds", "in__", "in__",		--FMC2_LA26		--B_TLF0 
--		"lvds", "in__", "in__",		--FMC2_LA27		--B_TLF1 
--		"lvds", "in__", "in__",		--FMC2_LA28		--A_TLCLK1 / NOT IO_CC !!!!
--		"lvds", "in__", "in__",		--FMC2_LA29		--
--		"lvds", "in__", "in__",		--FMC2_LA30		--A_TLD1 
--		"lvds", "in__", "in__",		--FMC2_LA31		--A_TLF0
--		"lvds", "in__", "in__",		--FMC2_LA32		--A_TLE1
--		"lvds", "in__", "in__"		--FMC2_LA33		--A_TLF1
--	);  --"out_"   "in__"	"i_o_" "ckin" "lvds"	"cmos"




	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
	(
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"lvds", "in__", "in__",		--FMC2_HA00		--
		"lvds", "in__", "in__",		--FMC2_HA01		-- 
		"lvds", "in__", "in__",		--FMC2_HA02		-- 
		"lvds", "in__", "in__",		--FMC2_HA03		-- 
		"lvds", "in__", "in__",		--FMC2_HA04		-- 
		"lvds", "in__", "in__",		--FMC2_HA05		--
		"lvds", "in__", "in__",		--FMC2_HA06		--
		"lvds", "in__", "in__",		--FMC2_HA07		--    
		"lvds", "in__", "in__",		--FMC2_HA08		-- 
		"lvds", "in__", "in__",		--FMC2_HA09		-- 
		"lvds", "in__", "in__",		--FMC2_HA10		-- 
		"lvds", "in__", "in__",		--FMC2_HA11		-- 
		"lvds", "in__", "in__",		--FMC2_HA12		-- 
		"lvds", "in__", "in__",		--FMC2_HA13		-- 
		"lvds", "in__", "in__",		--FMC2_HA14		-- 
		"lvds", "in__", "in__",		--FMC2_HA15		-- 
		"lvds", "in__", "in__",		--FMC2_HA16		--
		"lvds", "in__", "in__",		--FMC2_HA17		-- 
		"lvds", "in__", "in__",		--FMC2_HA18		--
		"lvds", "in__", "in__",		--FMC2_HA19		-- 
		"lvds", "in__", "in__",		--FMC2_HA20		--
		"lvds", "in__", "in__",		--FMC2_HA21		-- 
		"lvds", "in__", "in__",		--FMC2_HA22		-- 
		"lvds", "in__", "in__"		--FMC2_HA23		-- 
	);        

	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
	( 
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"lvds", "in__", "in__",		--FMC2_HB00		--  
		"lvds", "in__", "in__",		--FMC2_HB01		-- 
		"lvds", "in__", "in__",		--FMC2_HB02		-- 
		"lvds", "in__", "in__",		--FMC2_HB03		-- 
		"lvds", "in__", "in__",		--FMC2_HB04		--
		"lvds", "in__", "in__",		--FMC2_HB05		--
		"lvds", "in__", "in__",		--FMC2_HB06		--
		"lvds", "in__", "in__",		--FMC2_HB07		-- 	
		"lvds", "in__", "in__",		--FMC2_HB08		-- 
		"lvds", "in__", "in__",		--FMC2_HB09		--
		"lvds", "in__", "in__",		--FMC2_HB10		-- 
		"lvds", "in__", "in__",		--FMC2_HB11		-- 
		"lvds", "in__", "in__",		--FMC2_HB12		-- 
		"lvds", "in__", "in__",		--FMC2_HB13		--
		"lvds", "in__", "in__",		--FMC2_HB14		-- 
		"lvds", "in__", "in__",		--FMC2_HB15		-- 
		"lvds", "in__", "in__",		--FMC2_HB16		-- 
		"lvds", "in__", "in__",		--FMC2_HB17		-- 
		"lvds", "in__", "in__",		--FMC2_HB18		-- 
		"lvds", "in__", "in__",		--FMC2_HB19		--
		"lvds", "in__", "in__",		--FMC2_HB20		-- 
		"lvds", "in__", "in__"	   --FMC2_HB21		--
	);       					  



--	--CBCv1 + FMC_carrier
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"cmos", "out_", "in__",		--FMC2_LA00		-- CLK_2V5 <=> 1MHz towards DC-DC converter
--		"cmos", "in__", "in__",		--FMC2_LA01		-- DATA_2V5 <=> 140b serie
--		"cmos", "out_", "in__",		--FMC2_LA02		-- TRG_2V5	
--		"cmos", "out_", "in__",		--FMC2_LA03		-- DATA_CLK_2V5	
--		"lvds", "in__", "in__",		--FMC2_LA04	  
--		"lvds", "in__", "in__",		--FMC2_LA05	 
--		"lvds", "in__", "in__",		--FMC2_LA06	 
--		"lvds", "in__", "in__",		--FMC2_LA07	 
--		"lvds", "in__", "in__",		--FMC2_LA08	 
--		"lvds", "in__", "in__",		--FMC2_LA09	
--		"lvds", "in__", "in__",		--FMC2_LA10	
--		"lvds", "in__", "in__",		--FMC2_LA11	 
--		"lvds", "in__", "in__",		--FMC2_LA12		
--		"lvds", "in__", "in__",		--FMC2_LA13	 
--		"lvds", "in__", "in__",		--FMC2_LA14	
--		"lvds", "in__", "in__",		--FMC2_LA15	
--		"cmos", "out_", "in__",		--FMC2_LA16		-- RESET_2V5		
--		"cmos", "in__", "in__",		--FMC2_LA17		-- SDA_IN 	<=> SDA_FROMCBC_2V5	
--		"cmos", "out_", "in__",		--FMC2_LA18		--	SDA_OUT 	<=> SDA_TOCBC_2V5	
--		"cmos", "out_", "in__",		--FMC2_LA19		-- SCL_OUT	<=> SCL_2V5		 
--		"lvds", "in__", "in__",		--FMC2_LA20		
--		"lvds", "in__", "in__",		--FMC2_LA21		 
--		"lvds", "in__", "in__",		--FMC2_LA22		
--		"lvds", "in__", "in__",		--FMC2_LA23		
--		"lvds", "in__", "in__",		--FMC2_LA24		
--		"lvds", "in__", "in__",		--FMC2_LA25		 
--		"lvds", "in__", "in__",		--FMC2_LA26		
--		"lvds", "in__", "in__",		--FMC2_LA27		 
--		"lvds", "in__", "in__",		--FMC2_LA28		
--		"lvds", "in__", "in__",		--FMC2_LA29		
--		"lvds", "in__", "in__",		--FMC2_LA30		
--		"lvds", "in__", "in__",		--FMC2_LA31		
--		"lvds", "in__", "in__",		--FMC2_LA32		
--		"lvds", "in__", "in__"		--FMC2_LA33		
--	);  --"out_"   "in__"	"i_o_" "ckin" "lvds"	"cmos"
--
--
--
--	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HA00		--
--		"lvds", "in__", "in__",		--FMC2_HA01		-- 
--		"lvds", "in__", "in__",		--FMC2_HA02		-- 
--		"lvds", "in__", "in__",		--FMC2_HA03		-- 
--		"lvds", "in__", "in__",		--FMC2_HA04		-- 
--		"lvds", "in__", "in__",		--FMC2_HA05		--
--		"lvds", "in__", "in__",		--FMC2_HA06		--
--		"lvds", "in__", "in__",		--FMC2_HA07		--    
--		"lvds", "in__", "in__",		--FMC2_HA08		-- 
--		"lvds", "in__", "in__",		--FMC2_HA09		-- 
--		"lvds", "in__", "in__",		--FMC2_HA10		-- 
--		"lvds", "in__", "in__",		--FMC2_HA11		-- 
--		"lvds", "in__", "in__",		--FMC2_HA12		-- 
--		"lvds", "in__", "in__",		--FMC2_HA13		-- 
--		"lvds", "in__", "in__",		--FMC2_HA14		-- 
--		"lvds", "in__", "in__",		--FMC2_HA15		-- 
--		"lvds", "in__", "in__",		--FMC2_HA16		--
--		"lvds", "in__", "in__",		--FMC2_HA17		-- 
--		"lvds", "in__", "in__",		--FMC2_HA18		--
--		"lvds", "in__", "in__",		--FMC2_HA19		-- 
--		"lvds", "in__", "in__",		--FMC2_HA20		--
--		"lvds", "in__", "in__",		--FMC2_HA21		-- 
--		"lvds", "in__", "in__",		--FMC2_HA22		-- 
--		"lvds", "in__", "in__"		--FMC2_HA23		-- 
--	);        
--
--	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
--	( 
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HB00		--  
--		"lvds", "in__", "in__",		--FMC2_HB01		-- 
--		"lvds", "in__", "in__",		--FMC2_HB02		-- 
--		"lvds", "in__", "in__",		--FMC2_HB03		-- 
--		"lvds", "in__", "in__",		--FMC2_HB04		--
--		"lvds", "in__", "in__",		--FMC2_HB05		--
--		"lvds", "in__", "in__",		--FMC2_HB06		--
--		"lvds", "in__", "in__",		--FMC2_HB07		-- 	
--		"lvds", "in__", "in__",		--FMC2_HB08		-- 
--		"lvds", "in__", "in__",		--FMC2_HB09		--
--		"lvds", "in__", "in__",		--FMC2_HB10		-- 
--		"lvds", "in__", "in__",		--FMC2_HB11		-- 
--		"lvds", "in__", "in__",		--FMC2_HB12		-- 
--		"lvds", "in__", "in__",		--FMC2_HB13		--
--		"lvds", "in__", "in__",		--FMC2_HB14		-- 
--		"lvds", "in__", "in__",		--FMC2_HB15		-- 
--		"lvds", "in__", "in__",		--FMC2_HB16		-- 
--		"lvds", "in__", "in__",		--FMC2_HB17		-- 
--		"lvds", "in__", "in__",		--FMC2_HB18		-- 
--		"lvds", "in__", "in__",		--FMC2_HB19		--
--		"lvds", "in__", "in__",		--FMC2_HB20		-- 
--		"lvds", "in__", "in__"	   --FMC2_HB21		--
--	);       					  


--	--CASE_BEAM_TEST : B : CN2
--	--CASE RJ45 n°2 : IN CBC DATA / RJ45 n°1 : OUT sTTS
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "out_", "out_",		--FMC2_LA00		--B_TLD0 --CC
--		"lvds", "in__", "in__",		--FMC2_LA01		--B_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA03		-- 
--		"lvds", "in__", "in__",		--FMC2_LA04		--A_TLB0  
--		"lvds", "in__", "in__",		--FMC2_LA05		--B_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA06		--B_TLB0 
--		"lvds", "in__", "in__",		--FMC2_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA08		-- 
--		"lvds", "in__", "in__",		--FMC2_LA09		--B_TLE0  
--		"lvds", "out_", "out_",		--FMC2_LA10		--B_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC2_LA12		-- 
--		"lvds", "out_", "out_",		--FMC2_LA13		--B_TLB1 
--		"lvds", "out_", "out_",		--FMC2_LA14		--B_TLC1 
--		"lvds", "in__", "in__",		--FMC2_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC2_LA16		-- 
--		"lvds", "in__", "in__",		--FMC2_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "in__", "in__",		--FMC2_LA18		--B_TLD1
--		"lvds", "in__", "in__",		--FMC2_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA20		-- 
--		"lvds", "in__", "in__",		--FMC2_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA22		-- 
--		"lvds", "in__", "in__",		--FMC2_LA23		--B_TLE1 
--		"lvds", "in__", "in__",		--FMC2_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC2_LA25		-- 
--		"lvds", "in__", "in__",		--FMC2_LA26		--B_TLF0 
--		"lvds", "in__", "in__",		--FMC2_LA27		--B_TLF1 
--		"lvds", "in__", "in__",		--FMC2_LA28		--A_TLCLK1 / NOT IO_CC !!!!
--		"lvds", "in__", "in__",		--FMC2_LA29		--
--		"lvds", "in__", "in__",		--FMC2_LA30		--A_TLD1 
--		"lvds", "in__", "in__",		--FMC2_LA31		--A_TLF0
--		"lvds", "in__", "in__",		--FMC2_LA32		--A_TLE1
--		"lvds", "in__", "in__"		--FMC2_LA33		--A_TLF1
--	);  --out_   in__
    	
  
--	--CASE1 : B : OUT / A : IN
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "out_", "out_",		--FMC2_LA00		--B_TLD0
--		"lvds", "out_", "out_",		--FMC2_LA01		--B_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA03		-- 
--		"lvds", "in__", "in__",		--FMC2_LA04		--A_TLB0  
--		"lvds", "out_", "out_",		--FMC2_LA05		--B_TLC0 
--		"lvds", "out_", "out_",		--FMC2_LA06		--B_TLB0 
--		"lvds", "in__", "in__",		--FMC2_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA08		-- 
--		"lvds", "out_", "out_",		--FMC2_LA09		--B_TLE0  
--		"lvds", "out_", "out_",		--FMC2_LA10		--B_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC2_LA12		-- 
--		"lvds", "out_", "out_",		--FMC2_LA13		--B_TLB1 
--		"lvds", "out_", "out_",		--FMC2_LA14		--B_TLC1 
--		"lvds", "in__", "in__",		--FMC2_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC2_LA16		-- 
--		"lvds", "out_", "out_",		--FMC2_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "out_", "out_",		--FMC2_LA18		--B_TLD1
--		"lvds", "in__", "in__",		--FMC2_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA20		-- 
--		"lvds", "in__", "in__",		--FMC2_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA22		-- 
--		"lvds", "out_", "out_",		--FMC2_LA23		--B_TLE1 
--		"lvds", "in__", "in__",		--FMC2_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC2_LA25		-- 
--		"lvds", "out_", "out_",		--FMC2_LA26		--B_TLF0 
--		"lvds", "out_", "out_",		--FMC2_LA27		--B_TLF1 
--		"lvds", "ckin", "in__",		--FMC2_LA28		--A_TLCLK1 / IO_CC 
--		"lvds", "in__", "in__",		--FMC2_LA29		--
--		"lvds", "in__", "in__",		--FMC2_LA30		--A_TLD1 
--		"lvds", "in__", "in__",		--FMC2_LA31		--A_TLF0
--		"lvds", "in__", "in__",		--FMC2_LA32		--A_TLE1
--		"lvds", "in__", "in__"		--FMC2_LA33		--A_TLF1
--	);         	
 
--	--CASE2 : A : OUT / B : IN
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_LA00		--B_TLD0
--		"lvds", "in__", "in__",		--FMC2_LA01		--B_TLA0 
--		"lvds", "out_", "out_",		--FMC2_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA03		-- 
--		"lvds", "out_", "out_",		--FMC2_LA04		--A_TLB0  
--		"lvds", "in__", "in__",		--FMC2_LA05		--B_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA06		--B_TLB0 
--		"lvds", "out_", "out_",		--FMC2_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA08		-- 
--		"lvds", "in__", "in__",		--FMC2_LA09		--B_TLE0  
--		"lvds", "in__", "in__",		--FMC2_LA10		--B_TLA1 
--		"lvds", "out_", "out_",		--FMC2_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC2_LA12		-- 
--		"lvds", "in__", "in__",		--FMC2_LA13		--B_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA14		--B_TLC1 
--		"lvds", "out_", "out_",		--FMC2_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC2_LA16		-- 
--		"lvds", "ckin", "in__",		--FMC2_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "in__", "in__",		--FMC2_LA18		--B_TLD1
--		"lvds", "out_", "out_",		--FMC2_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA20		-- 
--		"lvds", "out_", "out_",		--FMC2_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA22		-- 
--		"lvds", "in__", "in__",		--FMC2_LA23		--B_TLE1 
--		"lvds", "out_", "out_",		--FMC2_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC2_LA25		-- 
--		"lvds", "in__", "in__",		--FMC2_LA26		--B_TLF0 
--		"lvds", "in__", "in__",		--FMC2_LA27		--B_TLF1 
--		"lvds", "out_", "out_",		--FMC2_LA28		--A_TLCLK1 / NOT IO_CC !!!!
--		"lvds", "in__", "in__",		--FMC2_LA29		--
--		"lvds", "out_", "out_",		--FMC2_LA30		--A_TLD1 
--		"lvds", "out_", "out_",		--FMC2_LA31		--A_TLF0
--		"lvds", "out_", "out_",		--FMC2_LA32		--A_TLE1
--		"lvds", "out_", "out_"		--FMC2_LA33		--A_TLF1
--	);
--	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HA00		--
--		"lvds", "in__", "in__",		--FMC2_HA01		-- 
--		"lvds", "in__", "in__",		--FMC2_HA02		-- 
--		"lvds", "in__", "in__",		--FMC2_HA03		-- 
--		"lvds", "in__", "in__",		--FMC2_HA04		-- 
--		"lvds", "in__", "in__",		--FMC2_HA05		--
--		"lvds", "in__", "in__",		--FMC2_HA06		--
--		"lvds", "in__", "in__",		--FMC2_HA07		--    
--		"lvds", "in__", "in__",		--FMC2_HA08		-- 
--		"lvds", "in__", "in__",		--FMC2_HA09		-- 
--		"lvds", "in__", "in__",		--FMC2_HA10		-- 
--		"lvds", "in__", "in__",		--FMC2_HA11		-- 
--		"lvds", "in__", "in__",		--FMC2_HA12		-- 
--		"lvds", "in__", "in__",		--FMC2_HA13		-- 
--		"lvds", "in__", "in__",		--FMC2_HA14		-- 
--		"lvds", "in__", "in__",		--FMC2_HA15		-- 
--		"lvds", "in__", "in__",		--FMC2_HA16		--
--		"lvds", "in__", "in__",		--FMC2_HA17		-- 
--		"lvds", "in__", "in__",		--FMC2_HA18		--
--		"lvds", "in__", "in__",		--FMC2_HA19		-- 
--		"lvds", "in__", "in__",		--FMC2_HA20		--
--		"lvds", "in__", "in__",		--FMC2_HA21		-- 
--		"lvds", "in__", "in__",		--FMC2_HA22		-- 
--		"lvds", "in__", "in__"		--FMC2_HA23		-- 
--	);        
--
--	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
--	( 
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HB00		--  
--		"lvds", "in__", "in__",		--FMC2_HB01		-- 
--		"lvds", "in__", "in__",		--FMC2_HB02		-- 
--		"lvds", "in__", "in__",		--FMC2_HB03		-- 
--		"lvds", "in__", "in__",		--FMC2_HB04		--
--		"lvds", "in__", "in__",		--FMC2_HB05		--
--		"lvds", "in__", "in__",		--FMC2_HB06		--
--		"lvds", "in__", "in__",		--FMC2_HB07		-- 	
--		"lvds", "in__", "in__",		--FMC2_HB08		-- 
--		"lvds", "in__", "in__",		--FMC2_HB09		--
--		"lvds", "in__", "in__",		--FMC2_HB10		-- 
--		"lvds", "in__", "in__",		--FMC2_HB11		-- 
--		"lvds", "in__", "in__",		--FMC2_HB12		-- 
--		"lvds", "in__", "in__",		--FMC2_HB13		--
--		"lvds", "in__", "in__",		--FMC2_HB14		-- 
--		"lvds", "in__", "in__",		--FMC2_HB15		-- 
--		"lvds", "in__", "in__",		--FMC2_HB16		-- 
--		"lvds", "in__", "in__",		--FMC2_HB17		-- 
--		"lvds", "in__", "in__",		--FMC2_HB18		-- 
--		"lvds", "in__", "in__",		--FMC2_HB19		--
--		"lvds", "in__", "in__",		--FMC2_HB20		-- 
--		"lvds", "in__", "in__"	   --FMC2_HB21		--
--	);       					           	

--	--CASE3 : B : IN/OUT - test RJ45 1/2 connected on CN2=B
--	--CASE RJ45 n°1 : OUT / RJ45 n°2 : IN
--	constant fmc2_la_io_settings_constants:fmc_la_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "out_", "out_",		--FMC2_LA00		--B_TLD0 --CC
--		"lvds", "in__", "in__",		--FMC2_LA01		--B_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA02		--A_TLA0 
--		"lvds", "in__", "in__",		--FMC2_LA03		-- 
--		"lvds", "in__", "in__",		--FMC2_LA04		--A_TLB0  
--		"lvds", "in__", "in__",		--FMC2_LA05		--B_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA06		--B_TLB0 
--		"lvds", "in__", "in__",		--FMC2_LA07		--A_TLC0 
--		"lvds", "in__", "in__",		--FMC2_LA08		-- 
--		"lvds", "in__", "in__",		--FMC2_LA09		--B_TLE0  
--		"lvds", "out_", "out_",		--FMC2_LA10		--B_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA11		--A_TLD0 
--		"lvds", "in__", "in__",		--FMC2_LA12		-- 
--		"lvds", "out_", "out_",		--FMC2_LA13		--B_TLB1 
--		"lvds", "out_", "out_",		--FMC2_LA14		--B_TLC1 
--		"lvds", "in__", "in__",		--FMC2_LA15		--A_TLE0 
--		"lvds", "in__", "in__",		--FMC2_LA16		-- 
--		"lvds", "in__", "in__",		--FMC2_LA17		--B_TLCLK1 / IO_CC
--		"lvds", "in__", "in__",		--FMC2_LA18		--B_TLD1
--		"lvds", "in__", "in__",		--FMC2_LA19		--A_TLA1 
--		"lvds", "in__", "in__",		--FMC2_LA20		-- 
--		"lvds", "in__", "in__",		--FMC2_LA21		--A_TLB1 
--		"lvds", "in__", "in__",		--FMC2_LA22		-- 
--		"lvds", "in__", "in__",		--FMC2_LA23		--B_TLE1 
--		"lvds", "in__", "in__",		--FMC2_LA24		--A_TLC1
--		"lvds", "in__", "in__",		--FMC2_LA25		-- 
--		"lvds", "in__", "in__",		--FMC2_LA26		--B_TLF0 
--		"lvds", "in__", "in__",		--FMC2_LA27		--B_TLF1 
--		"lvds", "in__", "in__",		--FMC2_LA28		--A_TLCLK1 / NOT IO_CC !!!!
--		"lvds", "in__", "in__",		--FMC2_LA29		--
--		"lvds", "in__", "in__",		--FMC2_LA30		--A_TLD1 
--		"lvds", "in__", "in__",		--FMC2_LA31		--A_TLF0
--		"lvds", "in__", "in__",		--FMC2_LA32		--A_TLE1
--		"lvds", "in__", "in__"		--FMC2_LA33		--A_TLF1
--	);  
--
--	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HA00		--
--		"lvds", "in__", "in__",		--FMC2_HA01		-- 
--		"lvds", "in__", "in__",		--FMC2_HA02		-- 
--		"lvds", "in__", "in__",		--FMC2_HA03		-- 
--		"lvds", "in__", "in__",		--FMC2_HA04		-- 
--		"lvds", "in__", "in__",		--FMC2_HA05		--
--		"lvds", "in__", "in__",		--FMC2_HA06		--
--		"lvds", "in__", "in__",		--FMC2_HA07		--    
--		"lvds", "in__", "in__",		--FMC2_HA08		-- 
--		"lvds", "in__", "in__",		--FMC2_HA09		-- 
--		"lvds", "in__", "in__",		--FMC2_HA10		-- 
--		"lvds", "in__", "in__",		--FMC2_HA11		-- 
--		"lvds", "in__", "in__",		--FMC2_HA12		-- 
--		"lvds", "in__", "in__",		--FMC2_HA13		-- 
--		"lvds", "in__", "in__",		--FMC2_HA14		-- 
--		"lvds", "in__", "in__",		--FMC2_HA15		-- 
--		"lvds", "in__", "in__",		--FMC2_HA16		--
--		"lvds", "in__", "in__",		--FMC2_HA17		-- 
--		"lvds", "in__", "in__",		--FMC2_HA18		--
--		"lvds", "in__", "in__",		--FMC2_HA19		-- 
--		"lvds", "in__", "in__",		--FMC2_HA20		--
--		"lvds", "in__", "in__",		--FMC2_HA21		-- 
--		"lvds", "in__", "in__",		--FMC2_HA22		-- 
--		"lvds", "in__", "in__"		--FMC2_HA23		-- 
--	);        
--
--	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
--	( 
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HB00		--  
--		"lvds", "in__", "in__",		--FMC2_HB01		-- 
--		"lvds", "in__", "in__",		--FMC2_HB02		-- 
--		"lvds", "in__", "in__",		--FMC2_HB03		-- 
--		"lvds", "in__", "in__",		--FMC2_HB04		--
--		"lvds", "in__", "in__",		--FMC2_HB05		--
--		"lvds", "in__", "in__",		--FMC2_HB06		--
--		"lvds", "in__", "in__",		--FMC2_HB07		-- 	
--		"lvds", "in__", "in__",		--FMC2_HB08		-- 
--		"lvds", "in__", "in__",		--FMC2_HB09		--
--		"lvds", "in__", "in__",		--FMC2_HB10		-- 
--		"lvds", "in__", "in__",		--FMC2_HB11		-- 
--		"lvds", "in__", "in__",		--FMC2_HB12		-- 
--		"lvds", "in__", "in__",		--FMC2_HB13		--
--		"lvds", "in__", "in__",		--FMC2_HB14		-- 
--		"lvds", "in__", "in__",		--FMC2_HB15		-- 
--		"lvds", "in__", "in__",		--FMC2_HB16		-- 
--		"lvds", "in__", "in__",		--FMC2_HB17		-- 
--		"lvds", "in__", "in__",		--FMC2_HB18		-- 
--		"lvds", "in__", "in__",		--FMC2_HB19		--
--		"lvds", "in__", "in__",		--FMC2_HB20		-- 
--		"lvds", "in__", "in__"	   --FMC2_HB21		--
--	);       					  
--
--
-- 
--	constant fmc2_ha_io_settings_constants:fmc_ha_io_settings_array:=
--	(
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HA00		--
--		"lvds", "in__", "in__",		--FMC2_HA01		-- 
--		"lvds", "in__", "in__",		--FMC2_HA02		-- 
--		"lvds", "in__", "in__",		--FMC2_HA03		-- 
--		"lvds", "in__", "in__",		--FMC2_HA04		-- 
--		"lvds", "in__", "in__",		--FMC2_HA05		--
--		"lvds", "in__", "in__",		--FMC2_HA06		--
--		"lvds", "in__", "in__",		--FMC2_HA07		--    
--		"lvds", "in__", "in__",		--FMC2_HA08		-- 
--		"lvds", "in__", "in__",		--FMC2_HA09		-- 
--		"lvds", "in__", "in__",		--FMC2_HA10		-- 
--		"lvds", "in__", "in__",		--FMC2_HA11		-- 
--		"lvds", "in__", "in__",		--FMC2_HA12		-- 
--		"lvds", "in__", "in__",		--FMC2_HA13		-- 
--		"lvds", "in__", "in__",		--FMC2_HA14		-- 
--		"lvds", "in__", "in__",		--FMC2_HA15		-- 
--		"lvds", "in__", "in__",		--FMC2_HA16		--
--		"lvds", "in__", "in__",		--FMC2_HA17		-- 
--		"lvds", "in__", "in__",		--FMC2_HA18		--
--		"lvds", "in__", "in__",		--FMC2_HA19		-- 
--		"lvds", "in__", "in__",		--FMC2_HA20		--
--		"lvds", "in__", "in__",		--FMC2_HA21		-- 
--		"lvds", "in__", "in__",		--FMC2_HA22		-- 
--		"lvds", "in__", "in__"		--FMC2_HA23		-- 
--	);        
--
--	constant fmc2_hb_io_settings_constants:fmc_hb_io_settings_array:=
--	( 
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "in__", "in__",		--FMC2_HB00		--  
--		"lvds", "in__", "in__",		--FMC2_HB01		-- 
--		"lvds", "in__", "in__",		--FMC2_HB02		-- 
--		"lvds", "in__", "in__",		--FMC2_HB03		-- 
--		"lvds", "in__", "in__",		--FMC2_HB04		--
--		"lvds", "in__", "in__",		--FMC2_HB05		--
--		"lvds", "in__", "in__",		--FMC2_HB06		--
--		"lvds", "in__", "in__",		--FMC2_HB07		-- 	
--		"lvds", "in__", "in__",		--FMC2_HB08		-- 
--		"lvds", "in__", "in__",		--FMC2_HB09		--
--		"lvds", "in__", "in__",		--FMC2_HB10		-- 
--		"lvds", "in__", "in__",		--FMC2_HB11		-- 
--		"lvds", "in__", "in__",		--FMC2_HB12		-- 
--		"lvds", "in__", "in__",		--FMC2_HB13		--
--		"lvds", "in__", "in__",		--FMC2_HB14		-- 
--		"lvds", "in__", "in__",		--FMC2_HB15		-- 
--		"lvds", "in__", "in__",		--FMC2_HB16		-- 
--		"lvds", "in__", "in__",		--FMC2_HB17		-- 
--		"lvds", "in__", "in__",		--FMC2_HB18		-- 
--		"lvds", "in__", "in__",		--FMC2_HB19		--
--		"lvds", "in__", "in__",		--FMC2_HB20		-- 
--		"lvds", "in__", "in__"	   --FMC2_HB21		--
--	);       					  

end user_fmc2_io_conf_package;
   
package body user_fmc2_io_conf_package is
end user_fmc2_io_conf_package;