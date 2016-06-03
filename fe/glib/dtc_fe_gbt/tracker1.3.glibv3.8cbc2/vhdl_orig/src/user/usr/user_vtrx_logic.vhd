library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! xilinx packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.system_package.all;
use work.ipbus.all;
use work.wb_package.all;
use work.gbt_package.all;
use work.gtx_package.all;
use work.sram_package.all;
use work.fmc_package.all;
use work.system_pcie_package.all;
--! user packages
use work.user_package.all;
use work.user_fmc1_io_conf_package.all;
use work.user_fmc2_io_conf_package.all;

entity user_logic is
port
(
	--================================--
	-- USER MGT REFCLKs
	--================================--
   -- BANK_112(Q0):  
   clk125_1_p	                        : in	  std_logic;  		    
   clk125_1_n	                        : in	  std_logic;  		  
   cdce_out0_p	                        : in	  std_logic;  		  
   cdce_out0_n	                        : in	  std_logic; 		  
   -- BANK_113(Q1):                 
   fmc2_clk0_m2c_xpoint2_p	            : in	  std_logic;
   fmc2_clk0_m2c_xpoint2_n	            : in	  std_logic;
   cdce_out1_p	                        : in	  std_logic;       
   cdce_out1_n	                        : in	  std_logic;         
   -- BANK_114(Q2):                 
   pcie_clk_p	                        : in	  std_logic; 			  
   pcie_clk_n	                        : in	  std_logic;			  
   cdce_out2_p  	                     : in	  std_logic;			  
   cdce_out2_n  	                     : in	  std_logic;			  
   -- BANK_115(Q3):                 
   clk125_2_i                          : in	  std_logic;		      
   clk125_2_bufg_i                     : in	  std_logic;       
   fmc1_gbtclk1_m2c_p	               : in	  std_logic;     
   fmc1_gbtclk1_m2c_n	               : in	  std_logic;     
   -- BANK_116(Q4):                 
   fmc1_gbtclk0_m2c_p	               : in	  std_logic;	  
   fmc1_gbtclk0_m2c_n	               : in	  std_logic;	  
   cdce_out3_p	                        : in	  std_logic;		  
   cdce_out3_n	                        : in	  std_logic;		    
   --================================--
	-- USER FABRIC CLOCKS
	--================================--
	xpoint1_clk1_i                      : in	  std_logic;	      
   xpoint1_clk3_p	                     : in	  std_logic;		   
   xpoint1_clk3_n	                     : in	  std_logic;		   
   ------------------------------------  
   cdce_out4_p                         : in	  std_logic;                
   cdce_out4_n                         : in	  std_logic;              
   ------------------------------------
   amc_tclkb_o					            : out	  std_logic;
   ------------------------------------      
   fmc1_clk0_m2c_xpoint2_p	            : in	  std_logic;
   fmc1_clk0_m2c_xpoint2_n	            : in	  std_logic;
   fmc1_clk1_m2c_p		               : in	  std_logic;	
   fmc1_clk1_m2c_n		               : in	  std_logic;	
   fmc1_clk2_bidir_p		               : in	  std_logic;	
   fmc1_clk2_bidir_n		               : in	  std_logic;	
   fmc1_clk3_bidir_p		               : in	  std_logic;	
   fmc1_clk3_bidir_n		               : in	  std_logic;	
   ------------------------------------
   fmc2_clk1_m2c_p	                  : in	  std_logic;		
   fmc2_clk1_m2c_n	                  : in	  std_logic;		
	--================================--
	-- GBT PHASE MONITORING MGT REFCLK
	--================================--
   cdce_out0_gtxe1_o                   : out   std_logic;  		  
   cdce_out3_gtxe1_o                   : out   std_logic;  
	--================================--
	-- AMC PORTS
	--================================--
   amc_port_tx_p				            : out	  std_logic_vector(1 to 15);
	amc_port_tx_n				            : out	  std_logic_vector(1 to 15);
	amc_port_rx_p				            : in	  std_logic_vector(1 to 15);
	amc_port_rx_n				            : in	  std_logic_vector(1 to 15);
	------------------------------------
	amc_port_tx_out			            : out	  std_logic_vector(17 to 20);	
	amc_port_tx_in				            : in	  std_logic_vector(17 to 20);		
	amc_port_tx_de				            : out	  std_logic_vector(17 to 20);	
	amc_port_rx_out			            : out	  std_logic_vector(17 to 20);	
	amc_port_rx_in				            : in	  std_logic_vector(17 to 20);	
	amc_port_rx_de				            : out	  std_logic_vector(17 to 20);	
	--================================--
	-- SFP QUAD
	--================================--
	sfp_tx_p						            : out	  std_logic_vector(1 to 4);
	sfp_tx_n						            : out	  std_logic_vector(1 to 4);
	sfp_rx_p						            : in	  std_logic_vector(1 to 4);
	sfp_rx_n						            : in	  std_logic_vector(1 to 4);
	sfp_mod_abs					            : in	  std_logic_vector(1 to 4);		
	sfp_rxlos					            : in	  std_logic_vector(1 to 4);		
	sfp_txfault					            : in	  std_logic_vector(1 to 4);				
	--================================--
	-- FMC1
	--================================--
	fmc1_tx_p					            : out	  std_logic_vector(1 to 4);
	fmc1_tx_n                           : out	  std_logic_vector(1 to 4);
	fmc1_rx_p                           : in	  std_logic_vector(1 to 4);
	fmc1_rx_n                           : in	  std_logic_vector(1 to 4);
	------------------------------------
	fmc1_io_pin					            : inout fmc_io_pin_type;
	------------------------------------
	fmc1_clk_c2m_p				            : out	  std_logic_vector(0 to 1);
	fmc1_clk_c2m_n				            : out	  std_logic_vector(0 to 1);
	fmc1_present_l				            : in	  std_logic;
	--================================--
	-- FMC2
	--================================--
	fmc2_io_pin					            : inout fmc_io_pin_type;
	------------------------------------
	fmc2_clk_c2m_p				            : out	  std_logic_vector(0 to 1);
	fmc2_clk_c2m_n				            : out	  std_logic_vector(0 to 1);
	fmc2_present_l				            : in	  std_logic;
   --================================--      
	-- SYSTEM GBE   
	--================================--      
   sys_eth_amc_p1_tx_p		            : in	  std_logic;	
   sys_eth_amc_p1_tx_n		            : in	  std_logic;	
   sys_eth_amc_p1_rx_p		            : out	  std_logic;	
   sys_eth_amc_p1_rx_n		            : out	  std_logic;	
	------------------------------------
	user_mac_syncacqstatus_i            : in	  std_logic_vector(0 to 3);
	user_mac_serdes_locked_i            : in	  std_logic_vector(0 to 3);
	--================================--   										
	-- SYSTEM PCIe				   												
	--================================--   
   sys_pcie_mgt_refclk_o	            : out	  std_logic;	  
   user_sys_pcie_dma_clk_i             : in	  std_logic;	  
   ------------------------------------
	sys_pcie_amc_tx_p		               : in	  std_logic_vector(0 to 3);    
   sys_pcie_amc_tx_n		               : in	  std_logic_vector(0 to 3);    
   sys_pcie_amc_rx_p		               : out	  std_logic_vector(0 to 3);    
   sys_pcie_amc_rx_n		               : out	  std_logic_vector(0 to 3);    
   ------------------------------------
	user_sys_pcie_slv_o	               : out   R_slv_to_ezdma2;									   	
	user_sys_pcie_slv_i	               : in    R_slv_from_ezdma2; 	   						    
	user_sys_pcie_dma_o                 : out   R_userDma_to_ezdma2_array  (1 to 7);		   					
	user_sys_pcie_dma_i                 : in 	  R_userDma_from_ezdma2_array(1 to 7);		   	
	user_sys_pcie_int_o 	               : out   R_int_to_ezdma2;									   	
	user_sys_pcie_int_i 	               : in    R_int_from_ezdma2; 								    
	user_sys_pcie_cfg_i 	               : in	  R_cfg_from_ezdma2; 								   	
	--================================--
	-- SRAMs
	--================================--
	user_sram_control_o		            : out	  userSramControlR_array(1 to 2);
	user_sram_addr_o			            : out	  array_2x21bit;
	user_sram_wdata_o			            : out	  array_2x36bit;
	user_sram_rdata_i			            : in 	  array_2x36bit;
	--================================--               
	-- CLK CIRCUITRY              
	--================================--    
   fpga_clkout_o	  			            : out	  std_logic;	
   ------------------------------------
   sec_clk_o		                     : out	  std_logic;	
	------------------------------------
	user_cdce_locked_i			         : in	  std_logic;
	user_cdce_sel_o			            : out	  std_logic;
	user_cdce_sync_o			            : out	  std_logic;
	--================================--  
	-- USER BUS  
	--================================--       
	wb_miso_o				               : out	  wb_miso_bus_array(0 to number_of_wb_slaves-1);
	wb_mosi_i				               : in 	  wb_mosi_bus_array(0 to number_of_wb_slaves-1);
	------------------------------------
	ipb_clk_i				               : in 	  std_logic;
	ipb_miso_o			                  : out	  ipb_rbus_array(0 to number_of_ipb_slaves-1);
	ipb_mosi_i			                  : in 	  ipb_wbus_array(0 to number_of_ipb_slaves-1);   
   --================================--
	-- VARIOUS
	--================================--
   reset_i						            : in	  std_logic;	 
   ------------------------------------   
   sn			                           : in    std_logic_vector(7 downto 0);	   
   ------------------------------------   
   mac_addr_o 					            : out   std_logic_vector(47 downto 0);
   ip_addr_o					            : out   std_logic_vector(31 downto 0);
   ------------------------------------	
   user_v6_led_o                       : out	  std_logic_vector(1 to 2)
);                         	
end user_logic;
							
architecture user_logic_arch of user_logic is                      	


   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@ PLACE YOUR DECLARATIONS BELOW THIS COMMENT @@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--


   attribute keep                               : boolean; 
   
   ---------------------------------------
   signal 	cdce_out0									: std_logic;	
   signal 	cdce_out3								   : std_logic;
   signal 	cdce_out4								   : std_logic;	
   ---------------------------------------
   signal	pg_clk_i										: std_logic_vector(0 to 1);
   type		array_2x84bit								is array(0 to 1) of std_logic_vector(83 downto 0);
   signal 	pg_frame_o									: array_2x84bit;
   ---------------------------------------                                 
   signal 	phase_aligner_sync 						: std_logic_vector(0 to 1);
   signal 	phase_aligner_reset    	  	  			: std_logic_vector(0 to 1);
   signal 	phase_aligner_clk240   	  	  			: std_logic_vector(0 to 1);
   signal 	phase_aligner_clk40    	  	  			: std_logic_vector(0 to 1);
   signal 	phase_aligner_done            		: std_logic_vector(0 to 1);
   ---------------------------------------                               
   signal 	tx_frameclk									: std_logic_vector(0 to 1);
   signal 	rx_frameclk									: std_logic_vector(0 to 1);
   signal 	rx_frameclk_x4								: std_logic_vector(0 to 1);
   ---------------------------------------
   signal 	fmc1_from_pin_to_fabric					: fmc_from_pin_to_fabric_type;
   signal 	fmc1_from_fabric_to_pin					: fmc_from_fabric_to_pin_type;
   signal 	fmc2_from_pin_to_fabric					: fmc_from_pin_to_fabric_type;
   signal 	fmc2_from_fabric_to_pin					: fmc_from_fabric_to_pin_type;
   
   signal 	fmc1_led										: std_logic_vector(1 to 4);
   signal 	fmc2_led										: std_logic_vector(1 to 4);
   
   signal 	fmc1_rate_sel								: std_logic:='0'; -- std_logic_vector(1 to 4);
   signal 	fmc1_tx_disable							: std_logic:='0'; -- std_logic_vector(1 to 4);
   
   signal 	fmc2_rate_sel								: std_logic:='0';
   signal 	fmc2_tx_disable							: std_logic:='0';
   
   constant fmc_output_enable							: std_logic:='0';
   constant fmc_output_disable						: std_logic:='1';
   ---------------------------------------
   signal 	gbt_dec_i 									: gbt_dec_in_array 	(0 to 1);
   signal 	gbt_dec_o 									: gbt_dec_out_array	(0 to 1);
   signal 	gbt_enc_i 									: gbt_enc_in_array 	(0 to 1);
   signal 	gbt_enc_o 									: gbt_enc_out_array	(0 to 1);
   signal 	gtx_i											: gtx_in_array   		(0 to 1);
   signal 	gtx_o											: gtx_out_array  		(0 to 1); 	
   
   constant fmc1 											: integer:= 0 ;
   constant sfp  											: integer:= 1 ;
   ---------------------------------------
   signal 	gtx_tx_reset_from_gbt_link_rst		: std_logic;
   attribute keep of gtx_tx_reset_from_gbt_link_rst : signal is true; 
   signal 	gtx_rx_reset_from_gbt_link_rst		: std_logic;
   attribute keep of gtx_rx_reset_from_gbt_link_rst : signal is true; 
   signal 	gbt_enc_reset_from_gbt_link_rst		: std_logic;
   signal 	gbt_dec_reset_from_gbt_link_rst		: std_logic;
   ---------------------------------------
   signal 	regs_from_wb								: array_64x32bit;
   signal 	regs_to_wb									: array_64x32bit;
   ---------------------------------------
   constant	mux_word_width								: positive:= 32;
   constant mux_wordcount_width						: positive:= 21;
   ---------------------------------------
   signal 	mux_rst_i    	 							: std_logic_vector(1 to 2);
   signal 	mux_clk_4x_i_bufg							: std_logic_vector(1 to 2);
   signal 	mux_clk_4x_i 								: std_logic_vector(1 to 2);
   signal 	mux_clk_1x_i  								: std_logic_vector(1 to 2);
   signal 	mux_busy_o									: std_logic_vector(1 to 2);
   signal 	mux_lsb_o									: std_logic_vector(1 to 2);
   type 		mux_frame_type								is array (1 to 2) of std_logic_vector(4*mux_word_width-1 downto 0);
   signal 	mux_frame_i       						: mux_frame_type;
   type		mux_word_type								is array (1 to 2) of std_logic_vector(mux_word_width-1 downto 0);
   signal 	mux_word_o       							: mux_word_type;
   type		mux_wordcount_type						is array (1 to 2) of std_logic_vector(mux_wordcount_width-1 downto 0);
   signal	mux_wordcount_o							: mux_wordcount_type;
   ---------------------------------------
   signal 	reg_fmc1_bitslip_ctrl					: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_link_ctrl						: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_sram_ctrl						: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_gtx_ctrl							: std_logic_vector(31 downto 0);
   
   signal 	reg_fmc1_slow_bert_ctrl					: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_slow_bert_status_words_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_fmc1_slow_bert_status_words_hi	: std_logic_vector(31 downto 0);	
   signal 	reg_fmc1_slow_bert_status_errors_lo	: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_slow_bert_status_errors_hi	: std_logic_vector(31 downto 0);
   
   signal 	reg_fmc1_fast_bert_ctrl					: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_fast_bert_status_words_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_fmc1_fast_bert_status_words_hi	: std_logic_vector(31 downto 0);	
   signal 	reg_fmc1_fast_bert_status_errors_lo	: std_logic_vector(31 downto 0);
   signal 	reg_fmc1_fast_bert_status_errors_hi	: std_logic_vector(31 downto 0);
   
   signal 	reg_fmc1_gbt_status						: std_logic_vector(31 downto 0);
   
   signal 	reg_sfp_bitslip_ctrl						: std_logic_vector(31 downto 0);
   signal 	reg_sfp_link_ctrl							: std_logic_vector(31 downto 0);
   signal 	reg_sfp_sram_ctrl							: std_logic_vector(31 downto 0);
   signal 	reg_sfp_gtx_ctrl							: std_logic_vector(31 downto 0);
   
   signal 	reg_sfp_slow_bert_ctrl					: std_logic_vector(31 downto 0);
   signal 	reg_sfp_slow_bert_status_words_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_slow_bert_status_words_hi	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_slow_bert_status_errors_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_slow_bert_status_errors_hi	: std_logic_vector(31 downto 0);	
   
   signal 	reg_sfp_gbt_status						: std_logic_vector(31 downto 0);
   
   signal 	reg_sfp_fast_bert_ctrl					: std_logic_vector(31 downto 0);
   signal 	reg_sfp_fast_bert_status_words_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_fast_bert_status_words_hi	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_fast_bert_status_errors_lo	: std_logic_vector(31 downto 0);	
   signal 	reg_sfp_fast_bert_status_errors_hi	: std_logic_vector(31 downto 0);	
   ---------------------------------------
   type		rx_slide_nbr_type 						is array(0 to 1) of std_logic_vector(4 downto 0);
   
   signal 	rx_slide_enable 							: std_logic_vector(0 to 1);
   signal 	rx_slide_ctrl								: std_logic_vector(0 to 1);
   signal 	rx_slide_run_from_wb 					: std_logic_vector(0 to 1);
   signal 	rx_slide_nbr_from_wb 					: rx_slide_nbr_type;
   signal 	rx_slide										: std_logic_vector(0 to 1);
   signal 	rx_slide_run								: std_logic_vector(0 to 1);
   signal 	rx_slide_nbr								: rx_slide_nbr_type;
         
   signal 	reg_i2c_settings							: std_logic_vector(31 downto 0);
   signal 	reg_i2c_command							: std_logic_vector(31 downto 0);
   signal 	reg_i2c_reply								: std_logic_vector(31 downto 0);
   
   signal 	scl_i											: std_logic;
   signal 	scl_o											: std_logic;
   signal 	scl_oe_l										: std_logic;
   signal 	sda_i											: std_logic;
   signal 	sda_o											: std_logic;
   signal 	sda_oe_l										: std_logic;
   
   ---------------------------------------
   constant usr_ver_major								:integer range 0 to 15 := 1;
   constant usr_ver_minor								:integer range 0 to 15 := 0;
   constant usr_ver_build								:integer range 0 to 255:= 0;
   constant usr_ver_year 								:integer range 0 to 99 :=12;
   constant usr_ver_month								:integer range 0 to 12 :=06;
   constant usr_ver_day  								:integer range 0 to 31 :=05;


--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin-- ARCHITECTURE
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--


   --#############################--
   --## GLIB IP & MAC ADDRESSES ##--
   --#############################--

   mac_addr_o 				               <= x"080030F10000";  -- 08:00:30:F1:00:00 
   ip_addr_o				               <= x"c0a8006f";      -- 192.168.0.111


   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@ PLACE YOUR LOGIC BELOW THIS COMMENT @@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

  
	--===============================================================================================--
	wb_regs: entity work.wb_user_regs
	--===============================================================================================--
	port map
	(
		wb_mosi						=> wb_mosi_i(user_wb_regs),
		wb_miso						=> wb_miso_o(user_wb_regs),
		---------------
		regs_o						=> regs_from_wb,
		regs_i						=> regs_to_wb
	);
	--===============================================================================================--



	--===============================================================================================--
	-- reg mapping
	--===============================================================================================--
	
	regs_to_wb(0)				<= x"55534552"								; --"USER"	
	regs_to_wb(1)				<= x"56545278"								; --"VTRx"	
	regs_to_wb(2) 				<= std_logic_vector(to_unsigned(usr_ver_major,4)) &
										std_logic_vector(to_unsigned(usr_ver_minor,4)) &
										std_logic_vector(to_unsigned(usr_ver_build,8)) &
										std_logic_vector(to_unsigned(usr_ver_year ,7)) &
										std_logic_vector(to_unsigned(usr_ver_month,4)) &
										std_logic_vector(to_unsigned(usr_ver_day  ,5)) ;
--	regs_to_wb(3)				<= 
	------------------
	regs_to_wb(4)				<= reg_fmc1_gbt_status						;	
	regs_to_wb(5)				<= reg_fmc1_slow_bert_status_words_lo	;	
	regs_to_wb(6)				<= reg_fmc1_slow_bert_status_words_hi	;	
	regs_to_wb(7)				<= reg_fmc1_slow_bert_status_errors_lo	;	
	regs_to_wb(8)				<= reg_fmc1_slow_bert_status_errors_hi	;	
--	regs_to_wb(9)				<= 
	------------------
	regs_to_wb(10)				<= reg_sfp_gbt_status						;	
	regs_to_wb(11)				<= reg_sfp_slow_bert_status_words_lo	;	
	regs_to_wb(12)				<= reg_sfp_slow_bert_status_words_hi	;	
	regs_to_wb(13)				<= reg_sfp_slow_bert_status_errors_lo	;	
	regs_to_wb(14)				<= reg_sfp_slow_bert_status_errors_hi	;	
	regs_to_wb(15)				<= reg_i2c_reply								;
	------------------
	reg_fmc1_bitslip_ctrl	<= regs_from_wb(16)							;
	reg_fmc1_link_ctrl		<= regs_from_wb(17)							;
	reg_fmc1_sram_ctrl		<= regs_from_wb(18)							;
	reg_fmc1_gtx_ctrl 		<= regs_from_wb(19)							;
	reg_fmc1_slow_bert_ctrl	<= regs_from_wb(20)							;
--										regs_from_wb(21)							;
--										regs_from_wb(22)							;
--										regs_from_wb(23)							;
	------------------
	reg_sfp_bitslip_ctrl		<=	regs_from_wb(24)							;
	reg_sfp_link_ctrl			<= regs_from_wb(25)							;
	reg_sfp_sram_ctrl			<= regs_from_wb(26)							;
	reg_sfp_gtx_ctrl 			<= regs_from_wb(27)							;
	reg_sfp_slow_bert_ctrl	<= regs_from_wb(28)							;
--										regs_from_wb(29)							;
	reg_i2c_settings			<=	regs_from_wb(30)							;
	reg_i2c_command			<=	regs_from_wb(31)							;
	
--	regs_to_wb(32+0)			
--	regs_to_wb(32+1)			 
--	regs_to_wb(32+2) 			 
--	regs_to_wb(32+3)			 
	------------------
--	regs_to_wb(32+4)			 
	regs_to_wb(32+5)			<= reg_fmc1_fast_bert_status_words_lo	;	
	regs_to_wb(32+6)			<= reg_fmc1_fast_bert_status_words_hi	;	
	regs_to_wb(32+7)			<= reg_fmc1_fast_bert_status_errors_lo	;	
	regs_to_wb(32+8)			<= reg_fmc1_fast_bert_status_errors_hi	;	
--	regs_to_wb(32+9)				 
	------------------
--	regs_to_wb(32+10)			 
	regs_to_wb(32+11)			<= reg_sfp_fast_bert_status_words_lo	;	
	regs_to_wb(32+12)			<= reg_sfp_fast_bert_status_words_hi	;	
	regs_to_wb(32+13)			<= reg_sfp_fast_bert_status_errors_lo	;	
	regs_to_wb(32+14)			<= reg_sfp_fast_bert_status_errors_hi	;	
--	regs_to_wb(32+15)			
	------------------
--										regs_from_wb(32+16)						;
--										regs_from_wb(32+17)						;
--										regs_from_wb(32+18)						;
--										regs_from_wb(32+19)						;
	reg_fmc1_fast_bert_ctrl	<= regs_from_wb(32+20)						;
--										regs_from_wb(32+21)						;
--										regs_from_wb(32+22)						;
--										regs_from_wb(32+23)						;
	------------------
--										regs_from_wb(32+24)						;
--										regs_from_wb(32+25)						;
--										regs_from_wb(32+26)						;
--										regs_from_wb(32+27)						;
	reg_sfp_fast_bert_ctrl	<= regs_from_wb(32+28)						;
--										regs_from_wb(32+29)						;
--										regs_from_wb(32+30)						;
--										regs_from_wb(32+31)						;

	--===============================================================================================--	



	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	
   
   --===============================================================================================--
	cdce_out4_ibufgds: ibufgds
   --===============================================================================================--
  	generic map (capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", ibuf_low_pwr => true, iostandard => "lvds_25")	
   port map 	(i => cdce_out4_p, ib => cdce_out4_n, o => cdce_out4);	
   --===============================================================================================-- 
    

	--===============================================================================================--	
	usr_i2c: entity work.i2c_master_no_iobuf
	--===============================================================================================--	
	port map
	(
		clk			=> wb_mosi_i(user_wb_regs).wb_clk,
		reset			=> wb_mosi_i(user_wb_regs).wb_rst,
		--- i2c registers ------------
		settings		=> reg_i2c_settings(12 downto 0),
		command		=> reg_i2c_command,
		reply			=> reg_i2c_reply,
		--- ctrlsignals --------------
		busy			=> open,
		------------------------------
		scl_i(0)		=> scl_i,
		scl_i(1)		=>	'0',		
		scl_o(0)		=>	scl_o,	
		scl_o(1)		=>	open,	
		scl_oe_l(0)	=>	scl_oe_l,		
		scl_oe_l(1)	=>	open,		
		sda_i(0)		=> sda_i,
		sda_i(1)		=> '0',
		sda_o(0)		=> sda_o,
		sda_o(1)		=> open,
		sda_oe_l(0)	=> sda_oe_l,
		sda_oe_l(1)	=> open
	); 			
	--===============================================================================================--	
	


	--===============================================================================================--
	gbt_link_rst: entity work.glibLink_rst_ctrl 
	--===============================================================================================--
	port map 
	(
		clk_i 					=> wb_mosi_i(user_wb_regs).wb_clk,
		reset_i 					=>	reset_i,
		gtx_txreset_o 			=> gtx_tx_reset_from_gbt_link_rst,
		gtx_rxreset_o 			=> gtx_rx_reset_from_gbt_link_rst,
		gbt_txreset_o 			=> gbt_enc_reset_from_gbt_link_rst,
		gbt_rxreset_o 			=> gbt_dec_reset_from_gbt_link_rst,
		busy_o 					=> open,
		done_o 					=> open
	);			
	--===============================================================================================--
	
	
	
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--	




	--===============================================================================================--
	fmc1_gtxe1: ibufds_gtxe1 port map ( i => cdce_out3_p, ib => cdce_out3_n, o => cdce_out3, ceb => '0');
	--===============================================================================================--

   tx_frameclk(fmc1)             <= xpoint1_clk1_i;
   

	--===============================================================================================--
	fmc1_pg: entity work.pattern_generator
	--===============================================================================================--
	port map
	(
		clk_i 							=> pg_clk_i		(fmc1),
		frame_o 							=> pg_frame_o	(fmc1)
	);
		pg_clk_i(fmc1)					<= tx_frameclk	(fmc1);
	--===============================================================================================--	



	--===============================================================================================--
	fmc1_gbt_dec: entity work.gbt_dec_top
	--===============================================================================================--
	port map
	(
		ext_reset_i		=> gbt_dec_reset_from_gbt_link_rst,
		gbt_dec_o		=> gbt_dec_o(fmc1),
		gbt_dec_i		=> gbt_dec_i(fmc1)
	);
	--===============================================================================================--



	--===============================================================================================--
	fmc1_gbt_enc: entity work.gbt_enc_top
	--===============================================================================================--
	port map
	(
		ext_reset_i		=> gbt_enc_reset_from_gbt_link_rst,
		gbt_enc_o		=> gbt_enc_o(fmc1),
		gbt_enc_i		=> gbt_enc_i(fmc1)
	);
	--===============================================================================================--
	
	

	--===============================================================================================--
	fmc1_gtx: entity work.gtx_top
	--===============================================================================================--
	port map
	(
		ext_tx_reset	=> gtx_tx_reset_from_gbt_link_rst,
		ext_rx_reset	=> gtx_tx_reset_from_gbt_link_rst,
		gtx_i				=> gtx_i(fmc1),
		gtx_o				=> gtx_o(fmc1)
	);                    	
	--===============================================================================================--


	
	--===============================================================================================--
		-- fmc1 on fmc1 gtx/gbt mapping
	--===============================================================================================--

	--%%%%% gtx drp/conf <- user %%%%%%%
												gtx_i(fmc1).drp_daddr      <= x"00"											;
												gtx_i(fmc1).drp_dclk       <= '0'											;
												gtx_i(fmc1).drp_den        <= '0'											;
												gtx_i(fmc1).drp_di         <= x"0000"										;
												gtx_i(fmc1).drp_dwe			<= '0'											;
												
												gtx_i(fmc1).conf_diff		<= reg_fmc1_gtx_ctrl( 3 downto  0)		;
												gtx_i(fmc1).conf_pstemph	<= reg_fmc1_gtx_ctrl( 8 downto  4)		;
												gtx_i(fmc1).conf_preemph	<= reg_fmc1_gtx_ctrl(15 downto 12)		;
												gtx_i(fmc1).conf_eqmix     <= reg_fmc1_gtx_ctrl(18 downto 16)		;
												gtx_i(fmc1).conf_rxpol		<= reg_fmc1_gtx_ctrl(20)					;
												gtx_i(fmc1).conf_txpol 		<= reg_fmc1_gtx_ctrl(24)					;
	--%%%%% gtx in <- user %%%%%%%                                                                  	
												gtx_i(fmc1).loopback 		<=	reg_fmc1_link_ctrl(30 downto 28)		;												
												gtx_i(fmc1).tx_powerdown	<=	reg_fmc1_link_ctrl( 5 downto  4)		;												
												gtx_i(fmc1).tx_sync_reset 	<=	reg_fmc1_link_ctrl( 1)					;										
												gtx_i(fmc1).tx_reset 		<=	reg_fmc1_link_ctrl( 0)					;										
												gtx_i(fmc1).rx_powerdown	<=	reg_fmc1_link_ctrl(13 downto 12)		;												
												gtx_i(fmc1).rx_reset 		<=	reg_fmc1_link_ctrl( 8)					;										
												gtx_i(fmc1).rx_sync_reset	<=	reg_fmc1_link_ctrl( 9)					;										
	                                 
                                    gtx_i(fmc1).prbs_txen       <= "000"                              ;
                                    gtx_i(fmc1).prbs_rxen       <= "000"                              ;
                                    gtx_i(fmc1).prbs_forcerr    <= '0'                                ;
                                    gtx_i(fmc1).prbs_errcntrst  <= '0'                                ;   
                                    
												gtx_i(fmc1).tx_refclk		<=	cdce_out3								   ; 
												gtx_i(fmc1).tx_data 			<= gbt_enc_o(fmc1).word						;
												gtx_i(fmc1).rx_refclk		<=	cdce_out3								   ; 
												gtx_i(fmc1).rxp				<= fmc1_rx_p(1)								; 							
												gtx_i(fmc1).rxn 				<=	fmc1_rx_n(1)								; 
												
												gtx_i(fmc1).rx_slide			<= rx_slide(fmc1)								;
												gtx_i(fmc1).rx_slide_run	<= rx_slide_run(fmc1)						;
												gtx_i(fmc1).rx_slide_nbr	<= rx_slide_nbr(fmc1)						;
	--%%%%% user <- gtx out %%%%%%
   fmc1_tx_p(1)						<=	gtx_o(fmc1).txp 																	;		
   fmc1_tx_n(1)						<=	gtx_o(fmc1).txn 																	;		
   fmc2_led(3)	 						<=	gtx_o(fmc1).resetdone 															;
	--%%%%% gbt_enc in <- user %%%%%		
												gbt_enc_i(fmc1).reset 			<= reg_fmc1_link_ctrl(2)				;
												gbt_enc_i(fmc1).word_clk 		<= gtx_o(fmc1).tx_wordclk 				;
												gbt_enc_i(fmc1).frame_clk		<= tx_frameclk(fmc1)						;
												gbt_enc_i(fmc1).data 			<= pg_frame_o(fmc1)						;
	--%%%%% gbt_dec in <- user %%%%%	
												gbt_dec_i(fmc1).reset 			<= reg_fmc1_link_ctrl(10)				;
												gbt_dec_i(fmc1).word_clk 		<= gtx_o(fmc1).rx_wordclk 				;
												gbt_dec_i(fmc1).frame_clk 		<= rx_frameclk(fmc1)						;
												gbt_dec_i(fmc1).word 			<= gtx_o(fmc1).rx_data					;
												gbt_dec_i(fmc1).gtx_aligned 	<=	gtx_o(fmc1).phasealingdone			;
	--===============================================================================================--


	--===============================================================================================--
	-- rx_slide select
	--===============================================================================================--
	rx_slide(fmc1)	<= 	gtx_o(fmc1).rx_slide						when  rx_slide_enable(fmc1)='1'											else 
								'0'											when  rx_slide_enable(fmc1)='0'											else 								
								'0'; 
							
	rx_slide_run(fmc1)	<= rx_slide_run_from_wb(fmc1) 		when (rx_slide_enable(fmc1)='1' and rx_slide_ctrl(fmc1)='1') 	else 
								gbt_dec_o(fmc1).aligned					when (rx_slide_enable(fmc1)='1' and rx_slide_ctrl(fmc1)='0')	else
								'0'											when  rx_slide_enable(fmc1)='0'											else
								'0';
	
	rx_slide_nbr(fmc1)	<= rx_slide_nbr_from_wb(fmc1) 		when (rx_slide_enable(fmc1)='1' and rx_slide_ctrl(fmc1)='1') 	else 
								gbt_dec_o(fmc1).bit_slip_nbr			when (rx_slide_enable(fmc1)='1' and rx_slide_ctrl(fmc1)='0') 	else
								"00000"										when  rx_slide_enable(fmc1)='0'											else
								"00000";		
	--===============================================================================================--



	rx_frameclk	(fmc1) 				<= tx_frameclk (fmc1);
	
	
	
	--===============================================================================================--
	fmc1_slow_ber: entity work.bert(fifo_based_arch)
	--===============================================================================================--
	generic map (n => 84)
	port map
	(
		tx_clk_i							=> tx_frameclk		(fmc1),
		rx_clk_i							=> rx_frameclk		(fmc1),
		tx_i								=> pg_frame_o		(fmc1),
		rx_i								=> gbt_dec_o		(fmc1).data,
		tx_o_reg_o						=> open,
		rx_o_reg_o						=> open,
		number_of_words_o				=> open,	
		number_of_word_errors_o		=> open,
		word_error_o					=> open,
		------------------------------------------
		clk_if_i												=> wb_mosi_i(user_wb_regs).wb_clk,
		reset_if_i											=> wb_mosi_i(user_wb_regs).wb_rst,
		clear_if_i											=> reg_fmc1_slow_bert_ctrl(20),		
		latch_if_i											=> reg_fmc1_slow_bert_ctrl(16),	
		enable_if_i											=> reg_fmc1_slow_bert_ctrl(12),	
		load_if_i											=> reg_fmc1_slow_bert_ctrl(8),		
		latency_if_i										=> reg_fmc1_slow_bert_ctrl(5 downto 0),
		number_of_words_if_o(31 downto  0) 			=> reg_fmc1_slow_bert_status_words_lo,	
		number_of_words_if_o(63 downto 32) 			=> reg_fmc1_slow_bert_status_words_hi,	
		number_of_word_errors_if_o	(31 downto  0) => reg_fmc1_slow_bert_status_errors_lo,
		number_of_word_errors_if_o	(63 downto 32) => reg_fmc1_slow_bert_status_errors_hi
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	fmc1_fast_ber: entity work.bert(fifo_based_arch)
	--===============================================================================================--
	generic map (n => 20)
	port map
	(
		tx_clk_i							=> gtx_o  (fmc1).tx_wordclk,	
		rx_clk_i							=> gtx_o  (fmc1).rx_wordclk, 
		tx_i								=> gbt_enc_o(fmc1).word,			
		rx_i								=> gtx_o  (fmc1).rx_data,		
		tx_o_reg_o						=> open,
		rx_o_reg_o						=> open,
		number_of_words_o				=> open,	
		number_of_word_errors_o		=> open,
		word_error_o					=> open,
		------------------------------------------
		clk_if_i												=> wb_mosi_i(user_wb_regs).wb_clk,
		reset_if_i											=> wb_mosi_i(user_wb_regs).wb_rst,
		clear_if_i											=> reg_fmc1_fast_bert_ctrl(20),		
		latch_if_i											=> reg_fmc1_fast_bert_ctrl(16),	
		enable_if_i											=> reg_fmc1_fast_bert_ctrl(12),	
		load_if_i											=> reg_fmc1_fast_bert_ctrl(8),		
		latency_if_i										=> reg_fmc1_fast_bert_ctrl(5 downto 0),
		number_of_words_if_o(31 downto  0) 			=> reg_fmc1_fast_bert_status_words_lo,	
		number_of_words_if_o(63 downto 32) 			=> reg_fmc1_fast_bert_status_words_hi,	
		number_of_word_errors_if_o	(31 downto  0) => reg_fmc1_fast_bert_status_errors_lo,
		number_of_word_errors_if_o	(63 downto 32) => reg_fmc1_fast_bert_status_errors_hi
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	fmc1_gbt_rx_wordclk_to_wb_domain: entity work.clk_domain_bridge
	--===============================================================================================--
	generic map (n => 6)
	port map
	(
		wrclk_i							=> gtx_o(fmc1).rx_wordclk,
		rdclk_i							=> wb_mosi_i(user_wb_regs).wb_clk,
		wdata_i(5)						=> gbt_dec_o(fmc1).aligned,
		wdata_i(4 downto 0)			=> gbt_dec_o(fmc1).bit_slip_nbr,
		rdata_o(5)						=> reg_fmc1_gbt_status(8),
		rdata_o(4 downto 0)			=> reg_fmc1_gbt_status(4 downto 0)
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	fmc1_wb_to_gbt_rx_wordclk_domain: entity work.clk_domain_bridge
	--===============================================================================================--
	generic map (n => 8)
	port map
	(
		wrclk_i							=> wb_mosi_i(user_wb_regs).wb_clk,
		wdata_i(7)						=> reg_fmc1_bitslip_ctrl(16),
		wdata_i(6)						=> reg_fmc1_bitslip_ctrl(12),
		wdata_i(5)						=> reg_fmc1_bitslip_ctrl(8),
		wdata_i(4 downto 0)			=> reg_fmc1_bitslip_ctrl(4 downto 0),
		---------------------------
		rdclk_i							=> gtx_o						(fmc1).rx_wordclk,
		rdata_o(7)						=> rx_slide_enable		(fmc1),
		rdata_o(6)						=> rx_slide_ctrl			(fmc1), 	-- 0: auto, 1: external
		rdata_o(5)						=> rx_slide_run_from_wb	(fmc1),
		rdata_o(4 downto 0)			=> rx_slide_nbr_from_wb	(fmc1)
	);
	--===============================================================================================--



	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--



	--===============================================================================================--
	sfp_gtxe1: ibufds_gtxe1 port map ( i => cdce_out0_p, ib => cdce_out0_n, o => cdce_out0, ceb => '0');
	--===============================================================================================--

   tx_frameclk(sfp)              <= xpoint1_clk1_i;


	--===============================================================================================--
	sfp_pg: entity work.pattern_generator
	--===============================================================================================--
	port map
	(
		clk_i 							=> pg_clk_i		(sfp),
		frame_o 							=> pg_frame_o	(sfp)
	);
		pg_clk_i(sfp)					<= tx_frameclk	(sfp);
	--===============================================================================================--	
	
	

	--===============================================================================================--
	sfp_gbt_dec: entity work.gbt_dec_top
	--===============================================================================================--
	port map
	(
		ext_reset_i		=> gbt_dec_reset_from_gbt_link_rst,
		gbt_dec_o		=> gbt_dec_o(sfp),
		gbt_dec_i		=> gbt_dec_i(sfp)
	);
	--===============================================================================================--



	--===============================================================================================--
	sfp_gbt_enc: entity work.gbt_enc_top
	--===============================================================================================--
	port map
	(
		ext_reset_i		=> gbt_enc_reset_from_gbt_link_rst,
		gbt_enc_o		=> gbt_enc_o(sfp),
		gbt_enc_i		=> gbt_enc_i(sfp)
	);
	--===============================================================================================--
	
	

	--===============================================================================================--
	sfp_gtx: entity work.gtx_top
	--===============================================================================================--
	port map
	(
		ext_tx_reset	=> gtx_tx_reset_from_gbt_link_rst,
		ext_rx_reset	=> gtx_tx_reset_from_gbt_link_rst,
		gtx_i				=> gtx_i(sfp),
		gtx_o				=> gtx_o(sfp)
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	-- on-board sfp gtx/gbt mapping
	--===============================================================================================--

	--%%%%% gtx drp/conf <- user %%%%%%%
												gtx_i(sfp).drp_daddr      	<= x"00"										;
												gtx_i(sfp).drp_dclk       	<= '0'										;
												gtx_i(sfp).drp_den        	<= '0'										;
												gtx_i(sfp).drp_di         	<= x"0000"									;
												gtx_i(sfp).drp_dwe			<= '0'										;
												
												gtx_i(sfp).conf_diff			<= "0000"									;
												gtx_i(sfp).conf_pstemph		<= "00000"									;
												gtx_i(sfp).conf_preemph		<= "0000"									;
												gtx_i(sfp).conf_eqmix     	<= "000"										;
												gtx_i(sfp).conf_rxpol		<= '0'										;
												gtx_i(sfp).conf_txpol 		<= '0'										;
	--%%%%% gtx in <- user %%%%%%%
												gtx_i(sfp).loopback 			<=	reg_sfp_link_ctrl(30 downto 28)	;												
												gtx_i(sfp).tx_powerdown		<=	reg_sfp_link_ctrl( 5 downto  4)	;												
												gtx_i(sfp).tx_sync_reset 	<=	reg_sfp_link_ctrl( 1)				;										
												gtx_i(sfp).tx_reset 			<=	reg_sfp_link_ctrl( 0)				;										
												gtx_i(sfp).rx_powerdown		<=	reg_sfp_link_ctrl(13 downto 12)	;												
												gtx_i(sfp).rx_reset 			<=	reg_sfp_link_ctrl( 8)				;										
												gtx_i(sfp).rx_sync_reset	<=	reg_sfp_link_ctrl( 9)				;
                                    
                                    gtx_i(sfp).prbs_txen       <= "000"                            ;
                                    gtx_i(sfp).prbs_rxen       <= "000"                            ;
                                    gtx_i(sfp).prbs_forcerr    <= '0'                              ;
                                    gtx_i(sfp).prbs_errcntrst  <= '0'                              ;
	
												gtx_i(sfp).tx_refclk			<=	cdce_out0								; 
												gtx_i(sfp).tx_data 			<= gbt_enc_o(sfp).word					;
												gtx_i(sfp).rx_refclk			<=	cdce_out0								; 
												gtx_i(sfp).rxp					<= sfp_rx_p(2)								; 							
												gtx_i(sfp).rxn 				<=	sfp_rx_n(2)								; 

												gtx_i(sfp).rx_slide			<= rx_slide(sfp)							;
												gtx_i(sfp).rx_slide_run		<= rx_slide_run(sfp)						;
												gtx_i(sfp).rx_slide_nbr		<= rx_slide_nbr(sfp)						;
	--%%%%% user <- gtx out %%%%%%
   sfp_tx_p(2)							<=	gtx_o(sfp).txp 																;		
   sfp_tx_n(2)							<=	gtx_o(sfp).txn 																;		
   fmc2_led(4)	 						<=	gtx_o(sfp).resetdone 														;
	--%%%%% gbt_enc in <- user %%%%%		
												gbt_enc_i(sfp).reset 		<= reg_sfp_link_ctrl(2)					;
												gbt_enc_i(sfp).word_clk 	<= gtx_o(sfp).tx_wordclk 				;
												gbt_enc_i(sfp).frame_clk	<= tx_frameclk(sfp)						;
												gbt_enc_i(sfp).data 			<= pg_frame_o(sfp)						;
	--%%%%% gbt_dec in <- user %%%%%	
												gbt_dec_i(sfp).reset 		<= reg_sfp_link_ctrl(10)				;
												gbt_dec_i(sfp).word_clk 	<= gtx_o(sfp).rx_wordclk 				;
												gbt_dec_i(sfp).frame_clk 	<= rx_frameclk (sfp)						;
												gbt_dec_i(sfp).word 			<= gtx_o(sfp).rx_data					;
												gbt_dec_i(sfp).gtx_aligned <=	gtx_o(sfp).phasealingdone			;
	--===============================================================================================--



	--===============================================================================================--
	-- rx_slide select
	--===============================================================================================--
	rx_slide(sfp)	<= 	gtx_o(sfp).rx_slide			 when  rx_slide_enable(sfp)='1'										else 
								'0'								 when  rx_slide_enable(sfp)='0'										else 								
								'0'; 
							
	rx_slide_run(sfp)	<= rx_slide_run_from_wb(sfp) 	 when (rx_slide_enable(sfp)='1' and rx_slide_ctrl(sfp)='1') else 
								gbt_dec_o(sfp).aligned		 when (rx_slide_enable(sfp)='1' and rx_slide_ctrl(sfp)='0')	else
								'0'								 when  rx_slide_enable(sfp)='0'										else
								'0';
	
	rx_slide_nbr(sfp)	<= rx_slide_nbr_from_wb(sfp) 	 when (rx_slide_enable(sfp)='1' and rx_slide_ctrl(sfp)='1') else 
								gbt_dec_o(sfp).bit_slip_nbr when (rx_slide_enable(sfp)='1' and rx_slide_ctrl(sfp)='0') else
								"00000"							 when  rx_slide_enable(sfp)='0'										else
								"00000";		
	--===============================================================================================--



	rx_frameclk			(sfp) <= tx_frameclk (sfp);
	


	--===============================================================================================--
	sfp_slow_ber: entity work.bert(fifo_based_arch)
	--===============================================================================================--
	generic map (n => 84)
	port map
	(
		tx_clk_i							=> tx_frameclk	(sfp),
		rx_clk_i							=> rx_frameclk	(sfp),
		tx_i								=> pg_frame_o	(sfp),
		rx_i								=> gbt_dec_o	(sfp).data,
		tx_o_reg_o						=> open,
		rx_o_reg_o						=> open,
		number_of_words_o				=> open,	
		number_of_word_errors_o		=> open,
		word_error_o					=> open,
		------------------------------------------
		clk_if_i												=> wb_mosi_i(user_wb_regs).wb_clk,
		reset_if_i											=> wb_mosi_i(user_wb_regs).wb_rst,
		clear_if_i											=> reg_sfp_slow_bert_ctrl(20),		
		latch_if_i											=> reg_sfp_slow_bert_ctrl(16),	
		enable_if_i											=> reg_sfp_slow_bert_ctrl(12),	
		load_if_i											=> reg_sfp_slow_bert_ctrl(8),		
		latency_if_i										=> reg_sfp_slow_bert_ctrl(5 downto 0),
		number_of_words_if_o(31 downto  0) 			=> reg_sfp_slow_bert_status_words_lo,	
		number_of_words_if_o(63 downto 32) 			=> reg_sfp_slow_bert_status_words_hi,	
		number_of_word_errors_if_o	(31 downto  0) => reg_sfp_slow_bert_status_errors_lo,
		number_of_word_errors_if_o	(63 downto 32) => reg_sfp_slow_bert_status_errors_hi
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	sfp_fast_ber: entity work.bert(fifo_based_arch)
	--===============================================================================================--
	generic map (n => 20)
	port map
	(
		tx_clk_i							=> gtx_o    (sfp).tx_wordclk, 	
		rx_clk_i							=> gtx_o    (sfp).rx_wordclk, 	
		tx_i								=> gbt_enc_o(sfp).word,			
		rx_i								=> gtx_o    (sfp).rx_data,		
		tx_o_reg_o						=> open,
		rx_o_reg_o						=> open,
		number_of_words_o				=> open,	
		number_of_word_errors_o		=> open,
		word_error_o					=> open,
		------------------------------------------
		clk_if_i												=> wb_mosi_i(user_wb_regs).wb_clk,
		reset_if_i											=> wb_mosi_i(user_wb_regs).wb_rst,
		clear_if_i											=> reg_sfp_fast_bert_ctrl(20),		
		latch_if_i											=> reg_sfp_fast_bert_ctrl(16),	
		enable_if_i											=> reg_sfp_fast_bert_ctrl(12),	
		load_if_i											=> reg_sfp_fast_bert_ctrl(8),		
		latency_if_i										=> reg_sfp_fast_bert_ctrl(5 downto 0),
		number_of_words_if_o(31 downto  0) 			=> reg_sfp_fast_bert_status_words_lo,	
		number_of_words_if_o(63 downto 32) 			=> reg_sfp_fast_bert_status_words_hi,	
		number_of_word_errors_if_o	(31 downto  0) => reg_sfp_fast_bert_status_errors_lo,
		number_of_word_errors_if_o	(63 downto 32) => reg_sfp_fast_bert_status_errors_hi
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	sfp_gbt_rx_wordclk_to_wb_domain: entity work.clk_domain_bridge
	--===============================================================================================--
	generic map (n => 6)
	port map
	(
		wrclk_i							=> gtx_o(sfp).rx_wordclk,
		rdclk_i							=> wb_mosi_i(user_wb_regs).wb_clk,
		wdata_i(5)						=> gbt_dec_o(sfp).aligned,
		wdata_i(4 downto 0)			=> gbt_dec_o(sfp).bit_slip_nbr,
		rdata_o(5)						=> reg_sfp_gbt_status(8),
		rdata_o(4 downto 0)			=> reg_sfp_gbt_status(4 downto 0)
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	sfp_wb_to_gbt_rx_wordclk_domain: entity work.clk_domain_bridge
	--===============================================================================================--
	generic map (n => 8)
	port map
	(
		wrclk_i							=> wb_mosi_i(user_wb_regs).wb_clk,
		wdata_i(7)						=> reg_sfp_bitslip_ctrl(16),
		wdata_i(6)						=> reg_sfp_bitslip_ctrl(12),
		wdata_i(5)						=> reg_sfp_bitslip_ctrl(8),
		wdata_i(4 downto 0)			=> reg_sfp_bitslip_ctrl(4 downto 0),
		---------------------------
		rdclk_i							=> gtx_o						(sfp).rx_wordclk,
		rdata_o(7)						=> rx_slide_enable		(sfp),
		rdata_o(6)						=> rx_slide_ctrl			(sfp), 	-- 0: auto, 1: external
		rdata_o(5)						=> rx_slide_run_from_wb	(sfp),
		rdata_o(4 downto 0)			=> rx_slide_nbr_from_wb	(sfp)
	);
	--===============================================================================================--



	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--



	--===============================================================================================--
	-- enable fmc sfps (applicable only when using FM-S14 Quad SFP FMC module)
	--===============================================================================================--
		fmc2_rate_sel				<= '0';
		fmc2_tx_disable			<= '0';		

		fmc1_rate_sel				<= '0'; --"0000";
		fmc1_tx_disable			<= '0'; --"0000";	
	--===============================================================================================--
	


	--===============================================================================================--
	-- drive fmc leds (applicable only when using FM-S14 Quad SFP FMC module)
	--===============================================================================================--
		fmc2_led(1)					<= user_mac_syncacqstatus_i(phy)  and user_mac_serdes_locked_i(phy);--mac_syncacqstatus_i(phy);
		fmc2_led(2)					<= user_mac_syncacqstatus_i(fmc2) and user_mac_serdes_locked_i(fmc2);--mac_syncacqstatus_i(phy);



	--===============================================================================================--
	hb: entity work.heartbeat
	--===============================================================================================--
   generic 	map(period_clka => 125000000, period_clkb	=> 40000000)
   port		map(reset => reset_i, clka => clk125_2_bufg_i, clkb => xpoint1_clk1_i, heartbeat_clka => fmc1_led(1), heartbeat_clkb => fmc1_led(2));--cdce_out4
	--===============================================================================================--

	
	
	--===============================================================================================--
	-- io mapping
	--===============================================================================================--
   fmc1_from_fabric_to_pin.la_cmos_p		(18)	<= fmc1_led(1);		fmc1_from_fabric_to_pin.la_cmos_p_oe_l	(18)	<= fmc_output_enable;
	fmc1_from_fabric_to_pin.la_cmos_n		(18)	<= fmc1_led(2);		fmc1_from_fabric_to_pin.la_cmos_n_oe_l	(18)	<= fmc_output_enable;	
   
   fmc2_from_fabric_to_pin.la_cmos_p		(18)	<= fmc2_led(1);		fmc2_from_fabric_to_pin.la_cmos_p_oe_l	(18)	<= fmc_output_enable;
	fmc2_from_fabric_to_pin.la_cmos_n		(18)	<= fmc2_led(2);		fmc2_from_fabric_to_pin.la_cmos_n_oe_l	(18)	<= fmc_output_enable;
	fmc2_from_fabric_to_pin.la_cmos_p		(19)	<= fmc2_led(3);		fmc2_from_fabric_to_pin.la_cmos_p_oe_l	(19)	<= fmc_output_enable;
	fmc2_from_fabric_to_pin.la_cmos_n 		(19)	<= fmc2_led(4);		fmc2_from_fabric_to_pin.la_cmos_n_oe_l	(19)	<= fmc_output_enable;
	
	fmc2_from_fabric_to_pin.la_cmos_n		( 6)	<= fmc2_tx_disable;	fmc2_from_fabric_to_pin.la_cmos_n_oe_l	( 6)	<= fmc_output_enable;
	fmc2_from_fabric_to_pin.la_cmos_n		( 4)	<= fmc2_rate_sel;		fmc2_from_fabric_to_pin.la_cmos_n_oe_l	( 4)	<= fmc_output_enable;

	fmc1_from_fabric_to_pin.la_cmos_n		( 6)	<= fmc1_tx_disable;	fmc1_from_fabric_to_pin.la_cmos_n_oe_l	( 6)	<= fmc_output_enable;
	fmc1_from_fabric_to_pin.la_cmos_n		( 4)	<= fmc1_rate_sel;		fmc1_from_fabric_to_pin.la_cmos_n_oe_l	( 4)	<= fmc_output_enable;

	fmc1_from_fabric_to_pin.la_cmos_p_oe_l	(15)	<= scl_oe_l;
	fmc1_from_fabric_to_pin.la_cmos_p		(15)	<= scl_o; 
																	scl_i				<= fmc1_from_pin_to_fabric.la_cmos_p		(15);					

	fmc1_from_fabric_to_pin.la_cmos_n_oe_l (19)	<= sda_oe_l;
	fmc1_from_fabric_to_pin.la_cmos_n      (19)	<= sda_o;
																	sda_i				<= fmc1_from_pin_to_fabric.la_cmos_n		(19);	   				
	--===============================================================================================--	



	--===============================================================================================--
	fmc1_map: entity work.fmc_io_buffers
	--===============================================================================================--
	generic map
	(
		fmc_la_io_settings		=> fmc1_la_io_settings_constants,
		fmc_ha_io_settings		=> fmc1_ha_io_settings_constants,
		fmc_hb_io_settings		=> fmc1_hb_io_settings_constants
	)
	port map
	(
		fmc_io_pin					=> FMC1_IO_PIN,
		fmc_from_fabric_to_pin	=> fmc1_from_fabric_to_pin,
		fmc_from_pin_to_fabric	=> fmc1_from_pin_to_fabric
	);                    	
	--===============================================================================================--



	--===============================================================================================--
	fmc2_map: entity work.fmc_io_buffers
	--===============================================================================================--
	generic map
	(
		fmc_la_io_settings		=> fmc2_la_io_settings_constants,
		fmc_ha_io_settings		=> fmc2_ha_io_settings_constants,
		fmc_hb_io_settings		=> fmc2_hb_io_settings_constants
	)
	port map
	(
		fmc_io_pin					=> FMC2_IO_PIN,
		fmc_from_fabric_to_pin	=> fmc2_from_fabric_to_pin,
		fmc_from_pin_to_fabric	=> fmc2_from_pin_to_fabric
	);          
	--===============================================================================================--




--	--===============================================================================================--
--	-- debug outputs
--	--===============================================================================================--
--	amc_port_tx_p(2)			<= tx_frameclk(fmc1);
--	amc_port_tx_p(3)			<=	tx_frameclk(sfp);
--	amc_port_tx_p(12)			<=	rx_frameclk(fmc1);
--	amc_port_tx_p(13)			<= rx_frameclk(sfp);
--	amc_port_tx_p(14)			<=	gtx_o(fmc1).tx_wordclk;
--	amc_port_tx_p(15)			<= gtx_o(fmc1).rx_wordclk;
--	--===============================================================================================--	


end user_logic_arch;