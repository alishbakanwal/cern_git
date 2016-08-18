--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Custom libraries and packages: 
use work.gbt_link_user_setup.all;
use work.vendor_specific_gbt_link_package.all;
--Comment: 
--> GBTRX_SLIDE_NBR_MSB 	declared in xlx_v6_gbt_link_package.vhd (vendor_specific_gbt_link_package)
--> NUM_GBT_LINK 				declared in xlx_v6_gbt_link_user_setup.vhd (gbt_link_user_setup)


use work.fmc_package.all; 

package pkg_generic is



	--=======================--
   -- Constants declaration --
   --=======================--

--	constant FMC_NB			: positive := 2;	
--	constant CBC_NB_BY_FMC 	: positive := 2;
--	constant FMC1 				: positive := 0;
--	constant FMC2 				: positive := 1;
--	constant CBC_A 			: positive := 0;
--	constant CBC_B 			: positive := 1;	

	constant CBC_DATA_BITS_NB 											: positive := 264;  --CBC1 : 138 / CBC2 : 264
	constant CBC_NB 														: positive := 8;--16;--2;
	constant FE_NB 														: positive := 1;--2; --1 or 2

	constant SIGNALS_TO_HYBRID_NB 									: positive := 9; --	
	constant SIGNALS_FROM_HYBRID_NB							      : positive := 1+CBC_NB*2; 

	--
	constant TTC_CLK_USED 					: boolean := false ;--true or false 
	--NEGATIVE_POLARITY_CBC = TRUE like in beam test at DESY in 2013 / FALSE for LOUVAIN
	--constant NEGATIVE_POLARITY_CBC 		: boolean := true ;--true or false 
	--if '0' : polar + (LOUVAIN) / if '1' : polar - (DESY)
	signal NEGATIVE_POLARITY_CBC 		: std_logic := '0';--'0' or '1' 


	constant fmc1_j2 : integer := 0; --J2
	constant fmc2_j1 : integer := 1; --J1
	
	--test
--	constant USER_HYBRIDE_TYPE 		: integer := 2; --1: 2xCBC2 / 2: 8xCBC2	
--	constant EXT_TRIG_CARD 				: boolean := true ;--true or false
--		--> if true select one among them
--		constant TTC_FMC 					: boolean := true ;--true or false 
-- 		constant FMC_DIO 					: boolean := false ;--true or false 

	--signal USER_HYBRIDE_TYPE 			: std_logic_vector(3 downto 0) := "0010"; --1: 2xCBC2 / 2: 8xCBC2	
	signal USER_HYBRIDE_TYPE 			: integer range 0 to 15:=1; --1: 2xCBC2 / 2: 8xCBC2	
	constant EXT_TRIG_CARD 				: boolean := true ;--true or false
		--> if true select one among them
		constant TTC_FMC 					: boolean := true ;--true or false 
 		constant FMC_DIO 					: boolean := false ;--true or false		
		
		
	--USER_HYBRIDE_TYPE <= to_integer(unsigned(param))
		
		
	signal USER_CBC_NB 					: positive range 2 to 16; -- 0:0 / 2:2 / 16:16
	signal USER_FE_NB 					: positive range 1 to 2;


	



	
	--===================--
   -- Types declaration --
   --===================--
	
	--arrays declaration
	type array_FE_NBx1bit 												is array(FE_NB-1 downto 0) 										of std_logic;
	type array_FE_NBx2bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(1 downto 0);	
	type array_FE_NBx16bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(15 downto 0);	
	type array_FE_NBx32bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(31 downto 0);
	type array_FE_NBx84bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(83 downto 0);
	type array_FE_NBxGBTRX_SLIDE_NBR_MSB 							is array(FE_NB-1 downto 0) 										of std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);	
	type array_FE_NBxSIGNALS_TO_HYBRID_NB 							is array(FE_NB-1 downto 0) 										of std_logic_vector(SIGNALS_TO_HYBRID_NB-1 downto 0);	
	type array_FE_NBxSIGNALS_FROM_HYBRID_NB						is array(FE_NB-1 downto 0) 										of std_logic_vector(SIGNALS_FROM_HYBRID_NB-1 downto 0);	

	type array_FE_NBxCBC_NB_bit 										is array(FE_NB-1 downto 0) 										of std_logic_vector(CBC_NB-1 downto 0);	

	--
	type array_FE_NBxCBC_NBx1bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic;
	type array_FE_NBxCBC_NBx24bit		 								is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(23 downto 0);
	type array_FE_NBxCBC_NBx12b 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(11 downto 0);	
	type array_FE_NBxCBC_NBx7bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(6 downto 0);	
	type array_FE_NBxCBC_NBx8bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(7 downto 0);
	type array_FE_NBxCBC_NBx16bit 									is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(15 downto 0);	
	type array_FE_NBxCBC_NBxCBC_DATA_BITS_NB 						is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(CBC_DATA_BITS_NB-1 downto 0);
	--

	--NUM_GBT_LINK
	type array_NUM_GBT_LINKx1bit 										is array(NUM_GBT_LINK-1 downto 0) 								of std_logic;
	type array_NUM_GBT_LINKx32bit 									is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(31 downto 0);
	type array_NUM_GBT_LINKx84bit 									is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(83 downto 0);
	type array_NUM_GBT_LINKxGBTRX_SLIDE_NBR_MSB 					is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);


   --Comment: 
	--> GBTRX_SLIDE_NBR_MSB 	declared in xlx_v6_gbt_link_package.vhd (vendor_specific_gbt_link_package)
	--> NUM_GBT_LINK 				declared in xlx_v6_gbt_link_user_setup.vhd (gbt_link_user_setup)
   ----------	

   --=======================--
   -- Functions declaration --
   --=======================--
	
	-- busOR_array_FE_NBxCBC_NBx1bit:
	---------------------------------	
	function busOR_array_FE_NBxCBC_NBx1bit( din : array_FE_NBxCBC_NBx1bit; FE_NB : positive; CBC_NB : positive  ) return std_logic;

	-- busAND_array_FE_NBxCBC_NBx1bit:
	---------------------------------	
	function busAND_array_FE_NBxCBC_NBx1bit( din : array_FE_NBxCBC_NBx1bit; FE_NB : positive; CBC_NB : positive  ) return std_logic;

	-- busOR_array_FE_NBx1bit:
	--------------------------	
	function busOR_array_FE_NBx1bit( din : array_FE_NBx1bit; FE_NB : positive ) return std_logic;

	-- busAND_array_FE_NBx1bit:
	--------------------------
	function busAND_array_FE_NBx1bit( din : array_FE_NBx1bit; FE_NB : positive ) return std_logic;

	--words32bNbComputing:
	----------------------
	function words32bNbComputing ( x : natural ) return natural;
	
	

	--=======================--
   -- Constants declaration --
   --=======================--

	--constant CBC_DATA_FIFO_BITS_NB 								: positive := CBC_DATA_BITS_NB;
	--constant TIME_TRIGGER_FIFO_BITS_NB 							: natural 	:= 96;
	constant CBC_COUNTER_FIFO_BITS_NB 							: natural 	:= 24;
	constant CBC_STUBDATA_BITS_NB 								: natural 	:= 1;
	constant TDC_COUNTER_BITS_NB									: positive 	:= 6;	
	constant TDC_COUNTER_FIFO_BITS_NB							: positive 	:= 6;

	constant ACQ_COUNTERS_BITS_NB									: natural 	:= 24; --CBC_COUNTER_FIFO_BITS_NB --	
	constant TIME_COUNTER_BITS_NB									: natural 	:= ACQ_COUNTERS_BITS_NB; --24; --CBC_COUNTER_FIFO_BITS_NB --
	constant L1A_COUNTER_BITS_NB									: natural 	:= ACQ_COUNTERS_BITS_NB;--24; --CBC_COUNTER_FIFO_BITS_NB -- 	
	constant CBC_COUNTER_BITS_NB									: natural 	:= ACQ_COUNTERS_BITS_NB;--24; --CBC_COUNTER_FIFO_BITS_NB -- 

	
	constant TIME_TRIGGER_FIFO_BITS_NB 							: natural 	:= 4*ACQ_COUNTERS_BITS_NB; --3*TIME_COUNTER_BITS_NB + L1A_COUNTER_BITS_NB;	--96
	type array_FE_NBxCBC_NBxCBC_COUNTER_BITS_NB				is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) of std_logic_vector(ACQ_COUNTERS_BITS_NB-1 downto 0); --	of std_logic_vector(CBC_COUNTER_BITS_NB-1 downto 0);

	
	--32b words necessary for the readout
	constant TIME_WORDS_NB 											: natural 	:= 3;
	constant L1A_COUNTER_WORDS_NB 								: natural 	:= 1;
	constant CBC_COUNTER_WORDS_NB									: natural 	:= 1;
	constant TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB 		: natural 	:= TIME_WORDS_NB + L1A_COUNTER_WORDS_NB + CBC_COUNTER_WORDS_NB; --5
	constant CBC_DATA_AND_STUB_WORDS_NB							: natural 	:= 9;--words32bNbComputing(CBC_DATA_BITS_NB+CBC_STUBDATA_BITS_NB);--9; -- (264+1)/32 = 8,2  (stub bit comprised)
	constant TDC_WORDS_NB 											: natural 	:= 1;
	constant TOTAL_WORDS_NB 										: natural 	:=   TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB 
																								+ (CBC_DATA_AND_STUB_WORDS_NB * FE_NB * CBC_NB) 
																								+ TDC_WORDS_NB; --42
	constant TOTAL_BITS_NB 											: natural 	:= TOTAL_WORDS_NB * 32;
	
--	constant ALL_FIFOS_BITS_NB 									: natural 	:= 	  TIME_TRIGGER_FIFO_BITS_NB 
--																									+ CBC_COUNTER_FIFO_BITS_NB  
--																									+ ((CBC_DATA_BITS_NB + CBC_STUBDATA_BITS_NB) * FE_NB * CBC_NB) 
--																									+ TDC_COUNTER_BITS_NB ;
		
	
	
	signal DATA_TO_SRAM_ACQ_COUNTERS_CONTENT 	: std_logic_vector(TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB*32-1 downto 0):=(others=>'0'); --160b

	signal DATA_TO_SRAM_CBC_CONTENT 				: std_logic_vector(CBC_DATA_AND_STUB_WORDS_NB*32*FE_NB*CBC_NB-1 downto 0):=(others=>'0'); --1152b

	signal DATA_TO_SRAM_TDC_CONTENT 				: std_logic_vector(TDC_WORDS_NB*32-1 downto 0):=(others=>'0'); --32b



	--new dev 10-06-14
	--attribute keep: boolean;
	--attribute keep of sig: signal is true;
	--attribute init: string;
	--attribute init of sig: signal is "BEB8" or "0"; 

	
	
	
--	--===========--
--	type fmc_io_buf_type is
--	--===========--
--	record
--		la				: std_logic_vector(0 to 33);
--		ha				: std_logic_vector(0 to 23);
--		hb				: std_logic_vector(0 to 21);
--	end record;
--	--===========-- 
--	type fmc_io_buf_array_type is array (1 downto 0) of fmc_io_buf_type;
--	
--
--
--	--===========--
--	type fmc_io_pin_dir_type is
--	--===========--
--	record
--		la				: std_logic_vector(0 to 33);
--		ha				: std_logic_vector(0 to 23);
--		hb				: std_logic_vector(0 to 21);
--	end record;
--	--===========-- 	
--	type fmc_io_pin_dir_array_type is array (1 downto 0) of fmc_io_pin_dir_type;	
--
--
--	signal fmc_from_fabric_to_pin_lvds_array 		: fmc_io_buf_array_type;
--	signal fmc_from_pin_to_fabric_lvds_array		: fmc_io_buf_array_type;
--	signal fmc_io_pin_dir_lvds_array 				: fmc_io_pin_dir_array_type; --0 by def
--	signal fmc_io_pin_dir_lvds_inv_array 			: fmc_io_pin_dir_array_type; --1 by def
--	
--	--signal init : fmc_io_pin_dir => 1 (IN MODE by def)		
--
--
--	signal fmc_from_fabric_to_pin_p_array 			: fmc_io_buf_array_type;
--	signal fmc_from_fabric_to_pin_n_array 			: fmc_io_buf_array_type;	
--	signal fmc_from_pin_to_fabric_p_array 			: fmc_io_buf_array_type;
--	signal fmc_from_pin_to_fabric_n_array 			: fmc_io_buf_array_type;	
--	signal fmc_io_pin_dir_p_array 					: fmc_io_pin_dir_array_type; --0 by def
--	signal fmc_io_pin_dir_n_array 					: fmc_io_pin_dir_array_type; --0 by def  
--	signal fmc_io_pin_dir_p_inv_array 				: fmc_io_pin_dir_array_type; --0 by def
--	signal fmc_io_pin_dir_n_inv_array 				: fmc_io_pin_dir_array_type; --0 by def  
	

--	--===========--
--	type fmc_from_fabric_to_pin_type is
--	--===========--
--	record
--		la_lvds			: std_logic_vector(0 to 33);
--		ha_lvds			: std_logic_vector(0 to 23);
--		hb_lvds			: std_logic_vector(0 to 21);
--		la_lvds_oe_l	: std_logic_vector(0 to 33);
--		ha_lvds_oe_l	: std_logic_vector(0 to 23);
--		hb_lvds_oe_l	: std_logic_vector(0 to 21);
--		
--		la_cmos_p		: std_logic_vector(0 to 33);
--		ha_cmos_p		: std_logic_vector(0 to 23);
--		hb_cmos_p		: std_logic_vector(0 to 21);
--		la_cmos_p_oe_l	: std_logic_vector(0 to 33);
--		ha_cmos_p_oe_l	: std_logic_vector(0 to 23);
--		hb_cmos_p_oe_l	: std_logic_vector(0 to 21);
--
--		la_cmos_n		: std_logic_vector(0 to 33);
--		ha_cmos_n		: std_logic_vector(0 to 23);
--		hb_cmos_n		: std_logic_vector(0 to 21);
--		la_cmos_n_oe_l	: std_logic_vector(0 to 33);
--		ha_cmos_n_oe_l	: std_logic_vector(0 to 23);
--		hb_cmos_n_oe_l	: std_logic_vector(0 to 21);
--
--	end record;
--	--===========--
--
--
--	--===========--
--	type fmc_from_pin_to_fabric_type is
--	--===========--
--	record
--		la_lvds			: std_logic_vector(0 to 33);
--		ha_lvds			: std_logic_vector(0 to 23);
--		hb_lvds			: std_logic_vector(0 to 21);
--		
--		la_cmos_p		: std_logic_vector(0 to 33);
--		ha_cmos_p		: std_logic_vector(0 to 23);
--		hb_cmos_p		: std_logic_vector(0 to 21);
--
--		la_cmos_n		: std_logic_vector(0 to 33);
--		ha_cmos_n		: std_logic_vector(0 to 23);
--		hb_cmos_n		: std_logic_vector(0 to 21);
--
--	end record;
--	--===========--

	--new
	type fmc_from_fabric_to_pin_array_type is array (0 to 1) of fmc_from_fabric_to_pin_type; --see fmc_package
	type fmc_from_pin_to_fabric_array_type is array (0 to 1) of fmc_from_pin_to_fabric_type;	--see fmc_package	

	signal fmc_from_fabric_to_pin_array : fmc_from_fabric_to_pin_array_type;
	signal fmc_from_pin_to_fabric_array : fmc_from_pin_to_fabric_array_type;


	--attribute init of fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l: signal is "FFFFFFFF"&"11";
	--attribute init of fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l(0): signal is "1";
	


	constant fmc_la_io_settings_lvds_bidir_constants : fmc_la_io_settings_array:= --mode lvds/io
	(
--CHOICE : "lvds" / "cmos" - "in__" / "out_" / "i_o_" / "ckin"
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"lvds", "i_o_", "i_o_",		--LA00		
		"lvds", "i_o_", "i_o_",		--LA01		
		"lvds", "i_o_", "i_o_",		--LA02			
		"lvds", "i_o_", "i_o_",		--LA03			
		"lvds", "i_o_", "i_o_",		--LA04			  
		"lvds", "i_o_", "i_o_",		--LA05	 
		"lvds", "i_o_", "i_o_",		--LA06	 
		"lvds", "i_o_", "i_o_",		--LA07			 
		"lvds", "i_o_", "i_o_",		--LA08	 
		"lvds", "i_o_", "i_o_",		--LA09	
		"lvds", "i_o_", "i_o_",		--LA10	
		"lvds", "i_o_", "i_o_",		--LA11				 
		"lvds", "i_o_", "i_o_",		--LA12		
		"lvds", "i_o_", "i_o_",		--LA13	 
		"lvds", "i_o_", "i_o_",		--LA14	
		"lvds", "i_o_", "i_o_",		--LA15			
		"lvds", "i_o_", "i_o_",		--LA16				
		"lvds", "i_o_", "i_o_",		--LA17		
		"lvds", "i_o_", "i_o_",		--LA18		
		"lvds", "i_o_", "i_o_",		--LA19					 	
		"lvds", "i_o_", "i_o_",		--LA20			
		"lvds", "i_o_", "i_o_",		--LA21		 
		"lvds", "i_o_", "i_o_",		--LA22		
		"lvds", "i_o_", "i_o_",		--LA23		
		"lvds", "i_o_", "i_o_",		--LA24			
		"lvds", "i_o_", "i_o_",		--LA25					 
		"lvds", "i_o_", "i_o_",		--LA26		
		"lvds", "i_o_", "i_o_",		--LA27		 
		"lvds", "i_o_", "i_o_",		--LA28	
		"lvds", "i_o_", "i_o_",		--LA29			
		"lvds", "i_o_", "i_o_",		--LA30		
		"lvds", "i_o_", "i_o_",		--LA31			
		"lvds", "i_o_", "i_o_",		--LA32		
		"lvds", "i_o_", "i_o_"		--LA33		
	);  

	
--	constant fmc_la_io_settings_lvds_bidir_constants : fmc_la_io_settings_array:= --mode lvds/io
--	(
----CHOICE : "lvds" / "cmos" - "in__" / "out_" / "i_o_" / "ckin"
----=============================--
----    std     dir_p   dir_n	
----=============================--
--		"lvds", "i_o_", "i_o_",		--LA00		
--		--"lvds", "i_o_", "i_o_",		--LA01		
--		--
--		"lvds", "in__", "in__",		--LA01
--		--
--		"lvds", "i_o_", "i_o_",		--LA02			
--		"lvds", "i_o_", "i_o_",		--LA03			
--		"lvds", "i_o_", "i_o_",		--LA04			  
--		"lvds", "i_o_", "i_o_",		--LA05	 
--		"lvds", "i_o_", "i_o_",		--LA06	 
--		"lvds", "i_o_", "i_o_",		--LA07			 
--		"lvds", "i_o_", "i_o_",		--LA08	 
--		"lvds", "i_o_", "i_o_",		--LA09	
--		--"lvds", "i_o_", "i_o_",		--LA10	
--		--
--		"lvds", "in__", "in__",		--LA10		
--		--
--		"lvds", "i_o_", "i_o_",		--LA11				 
--		"lvds", "i_o_", "i_o_",		--LA12		
--		"lvds", "i_o_", "i_o_",		--LA13	 
--		--"lvds", "i_o_", "i_o_",		--LA14	
--		--
--		"lvds", "in__", "in__",		--LA14
--		--
--		"lvds", "i_o_", "i_o_",		--LA15			
--		"lvds", "i_o_", "i_o_",		--LA16				
--		--"lvds", "i_o_", "i_o_",		--LA17		
--		--
--		"lvds", "in__", "in__",		--LA17
--		--
--		--"lvds", "i_o_", "i_o_",		--LA18		
--		--
--		"lvds", "in__", "in__",		--LA18
--		--
--		--"lvds", "i_o_", "i_o_",		--LA19					 
--		--
--		"lvds", "out_", "out_",		--LA19
--		--		
--		"lvds", "i_o_", "i_o_",		--LA20			
--		"lvds", "i_o_", "i_o_",		--LA21		 
--		--"lvds", "i_o_", "i_o_",		--LA22		
--		--
--		"lvds", "in__", "in__",		--LA22
--		--
--		--"lvds", "i_o_", "i_o_",		--LA23		
--		--
--		"lvds", "in__", "in__",		--LA23
--		--
--		"lvds", "i_o_", "i_o_",		--LA24			
--		"lvds", "i_o_", "i_o_",		--LA25					 
--		"lvds", "i_o_", "i_o_",		--LA26		
--		"lvds", "i_o_", "i_o_",		--LA27		 
--		"lvds", "i_o_", "i_o_",		--LA28	
--		"lvds", "i_o_", "i_o_",		--LA29			
--		"lvds", "i_o_", "i_o_",		--LA30		
--		"lvds", "i_o_", "i_o_",		--LA31			
--		"lvds", "i_o_", "i_o_",		--LA32		
--		"lvds", "i_o_", "i_o_"		--LA33		
--	);  



	constant fmc_la_io_settings_2cbc2_constants : fmc_la_io_settings_array:=
	(
--CHOICE : "lvds" / "cmos" - "in__" / "out_" / "i_o_" / "ckin"	
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"lvds", "in__", "in__",		--LA00		-- TRIGDATA_CBC2_B_LVDS
		--
		--"lvds", "i_o_", "i_o_",		--LA00
		--
		"lvds", "in__", "in__",		--LA01		
		"lvds", "in__", "in__",		--LA02		-- STUBDATA_CBC2_B_LVDS		
		"lvds", "in__", "in__",		--LA03			
		"lvds", "in__", "in__",		--LA04		-- TRIGGER_CBC2_B_LVDS	  
		"lvds", "in__", "in__",		--LA05	 
		"lvds", "in__", "in__",		--LA06	 
		"lvds", "in__", "in__",		--LA07		-- TRIGDATA_CBC2_A_LVDS	 
		"lvds", "in__", "in__",		--LA08	 
		"lvds", "in__", "in__",		--LA09	
		"lvds", "in__", "in__",		--LA10	
		--
		--"lvds", "i_o_", "i_o_",		--LA10
		--
		"lvds", "in__", "in__",		--LA11		-- STUBDATA_CBC2_A_LVDS		 
		"lvds", "in__", "in__",		--LA12		
		"lvds", "in__", "in__",		--LA13	 
		"lvds", "in__", "in__",		--LA14	
		--
		--"lvds", "i_o_", "i_o_",		--LA14		
		--
		"lvds", "out_", "out_",		--LA15		-- T1_TRIGGER_LVDS	
		--
		--"lvds", "i_o_", "i_o_",		--LA15		
		--
		"lvds", "in__", "in__",		--LA16		-- TRIGGER_CBC2_A_LVDS		
		"lvds", "in__", "in__",		--LA17		
		"lvds", "in__", "in__",		--LA18		
		"lvds", "out_", "out_",		--LA19		-- TEST_PULSE_LVDS			 
		--
		--"lvds", "i_o_", "i_o_",		--LA19
		--
		"lvds", "out_", "out_",		--LA20		-- FAST_RESET_LVDS		
		"lvds", "out_", "out_",		--LA21		-- I2C_REFRESH_LVDS		 
		"lvds", "in__", "in__",		--LA22		
		"lvds", "in__", "in__",		--LA23		
		"lvds", "out_", "out_",		--LA24		-- CLKIN_40_LVDS		
		"lvds", "out_", "out_",		--LA25		-- CLK_DCDC_LVDS <=> 1MHz towards DC-DC converter			 
		"lvds", "in__", "in__",		--LA26		
		"lvds", "in__", "in__",		--LA27		 
		"lvds", "out_", "out_",		--LA28		-- SDA_TO_CBC		
		"lvds", "in__", "in__",		--LA29		-- SDA_FROM_CBC		
		"lvds", "out_", "out_",		--LA30		-- RESET_2V5	
		"lvds", "out_", "out_",		--LA31		-- SCLK_2V5		
		"lvds", "out_", "out_",		--LA32		-- LVDS_DATA_OUT	-> TEST
		"lvds", "in__", "in__"		--LA33		-- LVDS_DATA_IN	-> TEST	
	);  


	constant fmc_la_io_settings_8cbc2_constants : fmc_la_io_settings_array:=
	(
--CHOICE : "lvds" / "cmos" - "in__" / "out_" / "i_o_" / "ckin"	
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"lvds", "out_", "out_",		--LA00		-- SCL_TO_CBC2_LVDS
		"lvds", "out_", "out_",		--LA01		-- RESET_LVDS		
		"lvds", "out_", "out_",		--LA02		-- CLKIN_40_LVDS 		
		"lvds", "in__", "in__",		--LA03		--			
		"lvds", "out_", "out_",		--LA04		-- CLK_DCDC_LVDS <=> 1MHz towards DC-DC converter	  
		"lvds", "out_", "out_",		--LA05		-- I2C_REFRESH_LVDS	 
		"lvds", "out_", "out_",		--LA06		-- TEST_PULSE_LVDS	 
		"lvds", "out_", "out_",		--LA07		-- FAST_RESET_LVDS 	 
		"lvds", "out_", "out_",		--LA08		-- T1_TRIGGER_LVDS	 
		"lvds", "in__", "in__",		--LA09		-- TRIGGER_CBC2_A_LVDS(0) 	<=> (0)
		"lvds", "out_", "out_",		--LA10		-- SDA_TO_CBC2_LVDS(0)		<=> (0)
		"lvds", "in__", "in__",		--LA11		-- TRIGGER_CBC2_B_LVDS(0) 	<=> (0)	  
		"lvds", "in__", "in__",		--LA12		-- TRIGDATA_CBC2_A_LVDS(0) <=> (0)		
		"lvds", "in__", "in__",		--LA13		-- TRIGDATA_CBC2_B_LVDS(0) <=> (1)	 
		"lvds", "in__", "in__",		--LA14		-- SDA_FROM_CBC2_LVDS(0) 	<=> (0) 
		"lvds", "in__", "in__",		--LA15		-- TRIGGER_CBC2_A_LVDS(1) 	<=> (1)	
		"lvds", "out_", "out_",		--LA16		-- SDA_TO_CBC2_LVDS(1) 		<=> (1)		
		"lvds", "in__", "in__",		--LA17		-- TRIGDATA_CBC2_A_LVDS(1) <=> (1)		
		"lvds", "in__", "in__",		--LA18		-- SDA_FROM_CBC2_LVDS(1) 	<=> (1)		
		"lvds", "in__", "in__",		--LA19		-- TRIGDATA_CBC2_B_LVDS(1)	<=> (1)		 
		"lvds", "in__", "in__",		--LA20		-- TRIGGER_CBC2_B_LVDS(1) 	<=> (1)		
		"lvds", "in__", "in__",		--LA21		-- TRIGGER_CBC2_B_LVDS(2) 	<=> (2)
		"lvds", "in__", "in__",		--LA22		-- TRIGGER_CBC2_A_LVDS(2) 	<=> (2)		
		"lvds", "out_", "out_",		--LA23		-- SDA_TO_CBC2_LVDS(2) 		<=> (2)		
		"lvds", "in__", "in__",		--LA24		-- TRIGDATA_CBC2_A_LVDS(2)	<=> (2)	
		"lvds", "in__", "in__",		--LA25		-- TRIGGER_CBC2_A_LVDS(3) 	<=> (3)		 
		"lvds", "in__", "in__",		--LA26		-- SDA_FROM_CBC2_LVDS(2) 	<=> (2)		
		"lvds", "in__", "in__",		--LA27		-- TRIGDATA_CBC2_B_LVDS(2)	<=> (2)		 
		"lvds", "in__", "in__",		--LA28		-- TRIGDATA_CBC2_A_LVDS(3)	<=> (3) 	
		"lvds", "out_", "out_",		--LA29		-- SDA_TO_CBC2_LVDS(3) 		<=> (3)	
		"lvds", "in__", "in__",		--LA30		-- TRIGGER_CBC2_B_LVDS(3) 	<=> (3)	
		"lvds", "in__", "in__",		--LA31		-- 	
		"lvds", "in__", "in__",		--LA32		-- TRIGDATA_CBC2_B_LVDS(3)	<=> (3)
		"lvds", "in__", "in__"		--LA33		-- SDA_FROM_CBC2_LVDS(3) 	<=> (3)	
	); 



	constant fmc_la_io_settings_ttc_constants : fmc_la_io_settings_array:=
	(
--CHOICE : "lvds" / "cmos" - "in__" / "out_" / "i_o_" / "ckin"
--=============================--
--    std     dir_p   dir_n	
--=============================--
		"cmos", "out_", "out_",		--LA00 
		"cmos", "out_", "out_",		--LA01 
		"cmos", "out_", "out_",		--LA02 
		"cmos", "out_", "out_",		--LA03 
		"cmos", "out_", "out_",		--LA04 
		"cmos", "out_", "out_",		--LA05 
		"lvds", "in__", "in__",		--LA06 
		"cmos", "out_", "i_o_",		--LA07 
		"cmos", "in__", "in__",		--LA08 
		"lvds", "in__", "in__",		--LA09 
		"cmos", "out_", "out_",		--LA10 
		"cmos", "in__", "in__",		--LA11 
		"cmos", "in__", "in__",		--LA12 
		"cmos", "in__", "in__",		--LA13 
		"cmos", "in__", "in__",		--LA14 
		"cmos", "out_", "in__",		--LA15 
		"cmos", "in__", "in__",		--LA16 
		"cmos", "in__", "in__",		--LA17 
		"cmos", "in__", "in__",		--LA18 
		"cmos", "in__", "in__",		--LA19 
		"cmos", "in__", "in__",		--LA20 
		"cmos", "in__", "in__",		--LA21 
		"cmos", "in__", "in__",		--LA22 
		"cmos", "in__", "in__",		--LA23 
		"cmos", "in__", "in__",		--LA24 
		"cmos", "in__", "in__",		--LA25 
		"cmos", "in__", "in__",		--LA26 
		"cmos", "in__", "in__",		--LA27 
		"cmos", "in__", "in__",		--LA28 
		"cmos", "in__", "in__",		--LA29 
		"cmos", "in__", "in__",		--LA30 
		"cmos", "in__", "in__",		--LA31 
		"cmos", "in__", "in__",		--LA32 
		"cmos", "in__", "in__"		--LA33 	
	); 	
	





end pkg_generic;

package body pkg_generic is

   --===========--
   -- Functions --
   --============--
	
	-- busOR_array_FE_NBxCBC_NBx1bit:
	---------------------------------	
	function busOR_array_FE_NBxCBC_NBx1bit( din : array_FE_NBxCBC_NBx1bit; FE_NB : positive; CBC_NB : positive  )
	return std_logic is
		variable bOR	: std_logic := '0';
	begin
		--
		for i_fe in 0 to FE_NB-1 loop
			for i_cbc in 0 to CBC_NB-1 loop
				bOR := bOR or din(i_fe,i_cbc);
			end loop;
		end loop;
		--
		return bOR;
	end;

	-- busAND_array_FE_NBxCBC_NBx1bit:
	---------------------------------	
	function busAND_array_FE_NBxCBC_NBx1bit( din : array_FE_NBxCBC_NBx1bit; FE_NB : positive; CBC_NB : positive )
	return std_logic is
		variable bAND	: std_logic := '1';
	begin
		--
		for i_fe in 0 to FE_NB-1 loop
			for i_cbc in 0 to CBC_NB-1 loop
				bAND := bAND and din(i_fe,i_cbc);
			end loop;
		end loop;
		--
		return bAND;
	end;	

	-- busOR_array_FE_NBx1bit:
	---------------------------------	
	function busOR_array_FE_NBx1bit( din : array_FE_NBx1bit; FE_NB : positive )
	return std_logic is
		variable bOR	: std_logic := '0';
	begin
		--
		for i_fe in 0 to FE_NB-1 loop
			bOR := bOR or din(i_fe);
		end loop;
		--
		return bOR;
	end;
	
	-- busAND_array_FE_NBx1bit:
	---------------------------------	
	function busAND_array_FE_NBx1bit( din : array_FE_NBx1bit; FE_NB : positive )
	return std_logic is
		variable bAND	: std_logic := '1';
	begin
		--
		for i_fe in 0 to FE_NB-1 loop
			bAND := bAND and din(i_fe);
		end loop;
		--
		return bAND;
	end;	

	-- words32bNbComputing
	----------------------
	function words32bNbComputing ( x : natural ) 
	return natural is
		variable words32bNb	: natural;
	begin
		--
		if x mod 32 = 0 then
			words32bNb := (x / 32);
		else
			words32bNb := (x / 32) + 1; --INT SUP
		end if;
		--
		return words32bNb;
	end;	



	
 
end pkg_generic;
