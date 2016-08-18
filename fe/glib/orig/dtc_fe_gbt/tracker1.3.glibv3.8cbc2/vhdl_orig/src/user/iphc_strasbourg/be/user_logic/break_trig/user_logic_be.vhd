library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! xilinx packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
use work.system_package.all;
use work.fmc_package.all;
use work.wb_package.all;
use work.ipbus.all;
--! user packages
use work.user_package.all;



-- Custom libraries and packages: 
use work.gbt_link_user_setup.all;
use work.gbt_link_package.all;
use work.vendor_specific_gbt_link_package.all;

--fmc configuration
use work.user_fmc1_io_conf_package.all;
use work.user_fmc2_io_conf_package.all;

--iphc_strasbourg
use work.pkg_generic.all;



entity user_logic is
   generic (    
      COMMON_STATIC_PATTERN                   	: std_logic_vector(83 downto 0) := x"0000BABEAC1DACDCFFFFF"; --used for SyncTest
		--
		STATIC_PATTERN	                 				: std_logic_vector(1 downto 0) := "10"; --from pattGen
		COUNTER_PATTERN	                 			: std_logic_vector(1 downto 0) := "01";
		--
		SYNC_TEST_IDLE										: std_logic_vector(1 downto 0) := "00";
		SYNC_TEST_GOOD										: std_logic_vector(1 downto 0) := "01";
		SYNC_TEST_FAIL										: std_logic_vector(1 downto 0) := "10"			
				);
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
	------------------------------------
   sram1_bwa                           : out	  std_logic;  
   sram1_bwb                           : out	  std_logic;  
   sram1_bwc                           : out	  std_logic;  
   sram1_bwd                           : out	  std_logic;  
   sram2_bwa                           : out	  std_logic;  
   sram2_bwb                           : out	  std_logic;  
   sram2_bwc                           : out	  std_logic;  
   sram2_bwd                           : out	  std_logic;    
   --================================--               
	-- CLK CIRCUITRY              
	--================================--    
   fpga_clkout_o	  			            : out	  std_logic;	
   ------------------------------------
   sec_clk_o		                     : out	  std_logic;	
	------------------------------------
	user_cdce_locked_i			         : in	  std_logic;
	user_cdce_sync_done_i		         : in	  std_logic;
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
   user_clk125_i	                     : in	  std_logic;       
   user_clk200_i	                     : in	  std_logic;  	
   ------------------------------------   
   sn			                           : in    std_logic_vector(7 downto 0);	   
   ------------------------------------   
   amc_slot_i									: in    std_logic_vector( 3 downto 0);	   	
	mac_addr_o 					            : out   std_logic_vector(47 downto 0);
   ip_addr_o					            : out   std_logic_vector(31 downto 0);
   ------------------------------------	
   user_v6_led_o                       : out	  std_logic_vector(1 to 2)
);                         	
end user_logic;
							
architecture user_logic_arch of user_logic is                    	


   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@ PLACE YOUR DECLARATIONS BELOW THIS COMMENT @@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--


	--==================================== Attributes =====================================--
   
   -- Comment: The "keep" constant is used to avoid that ISE changes the name of 
   --          the signals to be analysed with Chipscope.
   
   attribute keep                               : string;   
  
     
 	--==================================== Constants Declaration =====================================--  

   --===============--
   -- FMC INTERFACE --
   --===============--

	signal fmc1_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc1_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;
	
	signal fmc2_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc2_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;

	
----	constant FMC_NB			: positive := 2;	
----	constant CBC_NB_BY_FMC 	: positive := 2;
----	constant FMC1 				: positive := 0;
----	constant FMC2 				: positive := 1;
----	constant CBC_A 			: positive := 0;
----	constant CBC_B 			: positive := 1;	
--
--	constant CBC_DATA_BITS_NB 											: positive := 264;  --CBC1 : 138 / CBC2 : 264
--	constant CBC_NB 														: positive := 2;
--	constant FE_NB 														: positive := 2; --1 or 2
--
--	constant SIGNALS_TO_HYBRID_NB 									: positive := 9; --	
--	constant SIGNALS_FROM_HYBRID_NB							      : positive := 1+CBC_NB*2; 
--
--	
--	--arrays declaration
--	type array_FE_NBx1bit 												is array(FE_NB-1 downto 0) 										of std_logic;
--	type array_FE_NBx2bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(1 downto 0);	
--	type array_FE_NBx32bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(31 downto 0);
--	type array_FE_NBx84bit 												is array(FE_NB-1 downto 0) 										of std_logic_vector(83 downto 0);
--	type array_FE_NBxGBTRX_SLIDE_NBR_MSB 							is array(FE_NB-1 downto 0) 										of std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);	
--	type array_FE_NBxSIGNALS_TO_HYBRID_NB 							is array(FE_NB-1 downto 0) 										of std_logic_vector(SIGNALS_TO_HYBRID_NB-1 downto 0);	
--	type array_FE_NBxSIGNALS_FROM_HYBRID_NB						is array(FE_NB-1 downto 0) 										of std_logic_vector(SIGNALS_FROM_HYBRID_NB-1 downto 0);	
--
--
--	--
--	type array_FE_NBxCBC_NBx1bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic;
--	type array_FE_NBxCBC_NBx24bit		 								is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(23 downto 0);
--	type array_FE_NBxCBC_NBx12b 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(11 downto 0);	
--	type array_FE_NBxCBC_NBx8bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(7 downto 0);
--	type array_FE_NBxCBC_NBxCBC_DATA_BITS_NB 						is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(CBC_DATA_BITS_NB-1 downto 0);
--	--
--
--	--NUM_GBT_LINK
--	type array_NUM_GBT_LINKx1bit 										is array(NUM_GBT_LINK-1 downto 0) 								of std_logic;
--	type array_NUM_GBT_LINKx32bit 									is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(31 downto 0);
--	type array_NUM_GBT_LINKx84bit 									is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(83 downto 0);
--	type array_NUM_GBT_LINKxGBTRX_SLIDE_NBR_MSB 					is array(NUM_GBT_LINK-1 downto 0) 								of std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
--
--
--   --Comment: 
--	--> GBTRX_SLIDE_NBR_MSB 	declared in xlx_v6_gbt_link_package.vhd (vendor_specific_gbt_link_package)
--	--> NUM_GBT_LINK 				declared in xlx_v6_gbt_link_user_setup.vhd (gbt_link_user_setup)
--   ----------	
--> now in pkg_generic	




	
	
	
   --================================ Signal Declarations ================================--

   --===============--
   -- General reset --
   --===============--
   
   signal reset_from_or_gate                    : std_logic;         
         
   --=============--      
   -- GLIB status --      
   --=============--            
    
   signal userCdceLocked_r                      : std_logic;              
         
   --====================--                     
   -- GLIB clocks scheme --                     
   --====================--   
         
   signal cdce_out0                             : std_logic;
   signal cdce_out0_bufg                        : std_logic;
   signal xpoint1_clk3                          : std_logic;



--array_FE_NBx1bit
--array_FE_NBx32bit
--array_FE_NBx84bit
--array_FE_NBxGBTRX_SLIDE_NBR_MSB	
--
--array_NUM_GBT_LINKx1bit
--array_NUM_GBT_LINKx32bit
--array_NUM_GBT_LINKx84bit
--array_NUM_GBT_LINKxGBTRX_SLIDE_NBR_MSB	
   
   --===========================--
   -- GBT Link reference design --
   --===========================--
   
   -- Control:
   -----------
   
   signal reset_from_user                       : std_logic;      
   signal clkMuxSel_from_user                   : std_logic;       
   signal testPatterSel_from_user               : std_logic_vector(1 downto 0); 
   signal loopback_from_user                    : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user      : std_logic; 
   signal resetRxGbtReadyLostFlag_from_user     : std_logic; 
   signal txIsDataSel_from_user                 : std_logic;   
   signal encodingSel_from_user                 : std_logic_vector(1 downto 0); 
   
   -- Status:                                   
   ----------                                   
   
   signal latencyOptGbtLink_from_gbtRefDesign   : array_NUM_GBT_LINKx1bit;
   signal rxHeaderLocked_from_gbtRefDesign      : array_NUM_GBT_LINKx1bit;
   signal rxBitSlipNbr_from_gbtRefDesign        : array_NUM_GBT_LINKxGBTRX_SLIDE_NBR_MSB;
   signal rxWordClkAligned_from_gbtRefDesign    : array_NUM_GBT_LINKx1bit; 
   signal mgtReady_from_gbtRefDesign            : array_NUM_GBT_LINKx1bit; 
   signal rxGbtReady_from_gbtRefDesign          : array_NUM_GBT_LINKx1bit;    
   signal rxFrameClkAligned_from_gbtRefDesign   : array_NUM_GBT_LINKx1bit; 
   signal rxIsDataFlag_from_gbtRefDesign        : array_NUM_GBT_LINKx1bit;        
   signal rxGbtReadyLostFlag_from_gbtRefDesign  : array_NUM_GBT_LINKx1bit; 
   signal commDataErrSeen_from_gbtRefDesign     : array_NUM_GBT_LINKx1bit; 
   signal widebusDataErrSeen_from_gbtRefDesign  : array_NUM_GBT_LINKx1bit; 
   
   -- Data:
   --------
   
   signal txCommonData_from_gbtRefDesign        : array_NUM_GBT_LINKx84bit;
   signal rxCommonData_from_gbtRefDesign        : array_NUM_GBT_LINKx84bit;
   
   signal txWidebusExtraData_from_gbtRefDesign  : array_NUM_GBT_LINKx32bit;
   signal rxWidebusExtraData_from_gbtRefDesign  : array_NUM_GBT_LINKx32bit;
   
   --===========--
   -- Chipscope --
   --===========--
   
   signal vio_control                           : std_logic_vector(35 downto 0); 
   signal txIla_control                         : std_logic_vector(35 downto 0); 
   signal rxIla_control                         : std_logic_vector(35 downto 0); 
   signal sync_from_vio                         : std_logic_vector(11 downto 0);
   signal async_to_vio                          : std_logic_vector(14 downto 0);
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   signal txFrameClk_from_gbtRefDesign          : array_NUM_GBT_LINKx1bit;
   signal rxFrameClk_from_gbtRefDesign          : array_NUM_GBT_LINKx1bit;
   signal txWordClk_from_gbtRefDesign           : array_NUM_GBT_LINKx1bit;
   signal rxWordClk_from_gbtRefDesign           : array_NUM_GBT_LINKx1bit;
                                       
   signal txMatchFlag_from_gbtRefDesign         : array_NUM_GBT_LINKx1bit;
   signal rxMatchFlag_from_gbtRefDesign         : array_NUM_GBT_LINKx1bit;
   
   --=====================================================================================--  


	--lcharles
	--===============--
   -- MGT GBT RESET --
   --================--		
	-- User Indivudual Resets
	signal mgt_TxReset_from_user : std_logic := '0';
	signal gbt_TxReset_from_user : std_logic := '0';	
	signal mgt_RxReset_from_user : std_logic := '0';
	signal gbt_RxReset_from_user : std_logic := '0';	
	

   signal from_gbtRx_data_resync       			: array_NUM_GBT_LINKx84bit;	
	
	signal to_gbtTx_from_user 							: array_NUM_GBT_LINKx84bit; --:=x"aaaaaaaaaaaaaaaaaaaaa";	
	


	--==========--
   -- CLOCKING --
   --===========--		
	--> internal crystal from GLIB
	signal xpoint1_clk3_ibufgds 							: std_logic := '0';
	signal xpoint1_clk3_bufg 								: std_logic := '0';
	--> cdce_out4 from GLIB + MMCM
	signal cdce_out4_40M										: std_logic:='0';
	attribute keep of cdce_out4_40M						: signal is "true";	
 	-->TTC_FMC_v3					
	--if cdr_40M routed from TTC_FMC
	signal fmc1_clk0_m2c_xpoint2_bufgds 				: std_logic:='0';
	signal fmc1_clk0_m2c_xpoint2_bufg 					: std_logic:='0';
	attribute keep of fmc1_clk0_m2c_xpoint2_bufg		: signal is "true";	
	--if cdr_160M routed from TTC_FMC / direct link => FMC1
	signal fmc1_clk2_bidir_bufgds 						: std_logic:='0';
	signal fmc1_clk2_bidir_bufg 							: std_logic:='0';
	attribute keep of fmc1_clk2_bidir_bufg				: signal is "true";	
	--if cdr_160M routed from TTC_FMC / direct link => FMC2
	signal fmc2_clk1_m2c_bufgds 							: std_logic:='0';
	signal fmc2_clk1_m2c_bufg 								: std_logic:='0';
	attribute keep of fmc2_clk1_m2c_bufg				: signal is "true";


	--==============--
   -- tx_frame_clk --
   --===============--	
	signal tx_frame_clk 										: std_logic := '0';
	attribute keep of tx_frame_clk						: signal is "true";
	signal tdc_counter_clk 									: std_logic := '0';
	attribute keep of tdc_counter_clk					: signal is "true"; 




	--============--
   -- PARAMETERS --
   --============--	
	
	-- registers mapping:           
	--------------------- 	
	signal user_be_regs_from_wb 			: array_32x32bit; --array_32x32bit see system_package
	signal user_be_regs_to_wb 				: array_32x32bit;		

	-- control:           
	-----------	
	signal FPGA_CLKOUT_MUXSEL 			: std_logic:='0';
	signal BE_FE_RESYNC_DELAY 			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal BE_FE_SYNC_TEST_DELAY 		: std_logic_vector(31 downto 0):=(others=>'0');		
	
	signal resyncWait_from_user		: std_logic:='1';
	
	-- status:           
	----------	
	
	--================--
   -- BE_FE_syncTest --
   --=================--	
	signal BE_FE_syncTest_done 			: std_logic:='0';
	signal BE_FE_syncTest_ErrorSeen 	: std_logic:='0';
	signal BE_FE_syncTest_result 		: std_logic_vector(1 downto 0):=(others=>'0');	
	

	--===========--
   -- Chipscope --
   --===========--
	constant DATA_ILA_BITS_NBR 		: positive:= 208;--208;--40; 
	signal CONTROL0 						: std_logic_vector(35 downto 0):=(others=>'0');
	signal DATA_ILA_TEST 				: std_logic_vector(DATA_ILA_BITS_NBR-1 downto 0):=(others=>'0');
	signal DATA_ILA_TEST_TMP 			: std_logic_vector(DATA_ILA_BITS_NBR-1 downto 0):=(others=>'0');	
	signal TRIGGER_ILA_TEST 			: std_logic:='0';
	signal CLK_ILA_TEST 					: std_logic:='0';
	signal ILA_TRIG0 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG1 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG2 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG3 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG4 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG5 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG6 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG7 						: std_logic_vector(0 downto 0):=(others=>'0');	
	signal ILA_TRIG8 						: std_logic_vector(0 downto 0):=(others=>'0');
	signal ILA_TRIG9 						: std_logic_vector(0 downto 0):=(others=>'0');



	--gbt_data_interface
	--ctrl
	signal rq_cmd_from_sw : std_logic_vector(7 downto 0):=(others=>'0');
	signal gbt_sram_wordNb : std_logic_vector(20 downto 0):=(others=>'0');	
	signal SRAM_RdLatency : std_logic_vector(2 downto 0):=(others=>'0');	
	--status
	signal rq_ack_from_be : std_logic_vector(1 downto 0):=(others=>'0');	

	--======--
   -- SRAM --
   --======--
	signal user_sram_control_tmp : userSramControlR_array(1 to 2);
	signal user_sram_addr_tmp : array_2x21bit;							
	signal user_sram_wdata_tmp : array_2x36bit;	



   --===========--
   -- Dual CBC2 --
   --===========--	
	

	
	-->I2C / circuit interface
	--SCL : SCLK_2V5
	signal cbc_fabric_scl_o					: array_FE_NBx1bit;
	signal cbc_fabric_scl_oe_l				: array_FE_NBx1bit;	
	--SDA_i : SDA_FROM_CBC
	signal cbc_fabric_sda_i					: array_FE_NBx1bit;	
	--SDA_o : SDA_TO_CBC
	signal cbc_fabric_sda_o					: array_FE_NBx1bit;	
	signal cbc_fabric_sda_oe_l				: array_FE_NBx1bit;	
	--> FAST CTRL
	signal cbc_i2c_refresh					: array_FE_NBx1bit;
	signal cbc_test_pulse					: array_FE_NBx1bit;	
	signal cbc_fast_reset					: array_FE_NBx1bit; --used to be the rst_101 in CBC1	
	signal cbc_t1_trigger 					: array_FE_NBx1bit; --T1_TRIGGER, the readout trigger	
	--> CTRL
	signal cbc_hard_reset 					: array_FE_NBx1bit; --RESET_2V5 : juste i2c ??
	--> TRIGDATA_CBC2_LVDS
	--0 :A / 1 : B
	signal cbc_trigdata						: array_FE_NBxCBC_NBx1bit; 
	--> STUBDATA_CBC2_LVDS
	--0 :A / 1 : B	
	signal cbc_stubdata						: array_FE_NBxCBC_NBx1bit;
	signal cbc_stubdata_tmp					: array_FE_NBxCBC_NB_bit;	
	--> DC-DC
	signal cbc_clk_dcdc						: array_FE_NBx1bit;	--CLK_DCDC_LVDS
 

--	signal cbc_stubdata_readout 			: array_FE_NBxCBC_NBx12b; 
	attribute keep of cbc_trigdata		: signal is "true";
	attribute keep of cbc_stubdata		: signal is "true"; 

	--new
	attribute keep of cbc_fast_reset		: signal is "true"; 
	attribute keep of cbc_test_pulse		: signal is "true";	
--	attribute keep of cbc_i2c_refresh	: signal is "true"; 

	signal cbc_fast_reset_tmp						: array_FE_NBx1bit;	
	signal cbc_fast_reset_ipbusCtrl				: array_FE_NBx1bit;
	signal cbc_fast_reset_ipbusCtrlOnePulse	: array_FE_NBx1bit;
	attribute keep of cbc_fast_reset_tmp		: signal is "true";	
	--signal cbc_fast_reset_ipbusCtrl_del 		: array_FE_NBx2bit;
	
	--new
	signal cbc_fast_reset_ipbusCtrlSpared_del1 		: std_logic:='0';
	signal cbc_fast_reset_ipbusCtrlSpared_del2 		: std_logic:='0';
	signal cbc_fast_reset_ipbusCtrlOnePulseSpared 	: std_logic:='0';
	
	--===============--
   -- End Dual CBC2 --
   --===============--


	--================--
   -- I2C CONTROLLER --
   --================--

	----> CBC
	--I2C / SW interface 
--	signal cbc_ctrl_i2c_settings			: array_FE_NBx32bit;	
--	signal cbc_ctrl_i2c_command			: array_FE_NBx32bit;	
--	signal cbc_ctrl_i2c_reply				: array_FE_NBx32bit;	
--	signal cbc_ctrl_i2c_done 				: array_FE_NBx1bit;
	--new lcharles
	signal cbc_ctrl_i2c_settings			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal cbc_ctrl_i2c_command			: std_logic_vector(31 downto 0):=(others=>'0');		
	signal cbc_ctrl_i2c_reply				: std_logic_vector(31 downto 0):=(others=>'0');		
	signal cbc_ctrl_i2c_done 				: std_logic:='0';


	signal cbc_fabric_scl_o_tmp 			: std_logic:='1';
	signal cbc_fabric_sda_o_tmp 			: std_logic:='1';	
	signal cbc_fabric_sda_i_tmp 			: std_logic:='1';
	




	--new
	signal cbc_i2c_access_busy 			: std_logic:='0';
	signal cbc_i2c_param_word_fePart 	: std_logic_vector(2 downto 0):=(others=>'0');	


	--gbt_sram
	--system_flash_sram_package.vhd
	signal gbt_sram_control					: userSramControlR_array(1 to 2);
	signal gbt_sram_addr						: array_2x21bit;									
	signal gbt_sram_wdata					: array_2x36bit;	
	

	--cbc_i2c
	--system_flash_sram_package.vhd
	signal cbc_i2c_user_sram_control		: userSramControlR_array(1 to 2); 
	signal cbc_i2c_user_sram_addr			: array_2x21bit; --std_logic_vector(20 downto 0); --array_2x21bit							
	signal cbc_i2c_user_sram_rdata		: array_2x36bit;--std_logic_vector(35 downto 0); --array_2x36bit		
	signal cbc_i2c_user_sram_wdata		: array_2x36bit;--std_logic_vector(35 downto 0); --array_2x36bit

	

--	--Parameter Word for Test
--	signal cbc_i2c_param_word_i		: std_logic_vector(31 downto 0) := (others=>'0');
--	signal cbc_i2c_param_word_o		: std_logic_vector(31 downto 0) := (others=>'0');
--	signal cbc_i2c_cmd_rq				: std_logic_vector(1 downto 0)  := (others=>'0');	
--	signal cbc_i2c_cmd_ack				: std_logic_vector(1 downto 0)  := (others=>'0');

	--modif / i2c ctrl in BE
--	signal to_gbtTx_cbc 							: array_NUM_GBT_LINKx84bit; --std_logic_vector(83 downto 0);
	signal to_gbtTx_cbc 							: array_FE_NBxSIGNALS_TO_HYBRID_NB;
	signal from_gbtRx_cbc 						: array_FE_NBxSIGNALS_FROM_HYBRID_NB;
 	
	
	signal to_gbtTx_from_gbtDataInterface 	: std_logic_vector(83 downto 0);

--	--cmd ipbus
--	signal cbc_t1_trigger_ipbus_user	: std_logic:='0';
	--signal LongTrigger : std_logic_vector(2 downto 0):= std_logic_vector(to_unsigned(2,3));

	--signal INT_TRIGGER_FREQ_SEL 			: std_logic_vector(3 downto 0):=(others=>'0');
	--signal int_trigger 						: std_logic;	
	


	--acq
	
	---------------********************************CLOCKING************************************----------------
	--clock really used
	signal BC_CLK 								: std_logic:='0';	
	signal SRAM_CLK 							: std_logic:='0';
	---------------******************************END CLOCKING**********************************----------------		


	---------------********************************TRIGGER************************************----------------
	--test l1a
	signal l1accept_sync 				: std_logic_vector(1 downto 0):=(others=>'0');
	signal l1accept_sync_one_cycle 	: std_logic:='0';			
	signal L1A_VALID 						: std_logic:='0';
	signal L1A_VALID_del1				: std_logic:='0';		
	--Internal trigger
	signal int_trigger 					: std_logic:='0';
	--TLU trigger
	signal tlu_trigger 					: std_logic:='0';	
	signal tlu_busy_o 					: std_logic:='0';
	signal tlu_trigger_i 				: std_logic:='0';	
	--signal tlu_trigger_one_pulse 		: std_logic:='0';
	signal tlu_trigger_del				: std_logic_vector(2 downto 0) := (others=>'0');	

	---------------******************************END TRIGGER**********************************----------------	


	--============--
   -- TTC_FMC_v3 --
   --============--
	--cdr_ttc3 interface
	signal cdr_clk 						: std_logic:='0';	
	attribute keep of cdr_clk			: signal is "true"; 	
	signal cdr_lol 						: std_logic:='0';
	signal cdr_los 						: std_logic:='0';	
	signal cdr_clk_locked 				: std_logic:='0';	
	signal cdr_data 						: std_logic:='0';
	signal divider_div4 					: std_logic:='0';
	signal divider_rst_b 				: std_logic:='0';	
	--
	signal ttc3_3DE, ttc3_2DE 			: std_logic:='1';	
	signal ttc3_user_led_n 				: std_logic:='0';
	signal lemo_lm2 						: std_logic:='0';	
	--logic
	signal ttcclk 							: std_logic:='0';	
	signal l1accept 						: std_logic:='0';
	signal bcntres 						: std_logic:='0';
	signal evcntres 						: std_logic:='0';
	signal sinerrstr 						: std_logic:='0';	
	signal dberrstr 						: std_logic:='0';	
	signal brcststr						: std_logic:='0';	
	signal brcst							: std_logic_vector(7 downto 2):=(others=>'0');	
	signal dummy_out						: std_logic:='0';		
	--clk out
	signal cdr_clk_40M_0_180						: std_logic:='0';
	attribute keep of cdr_clk_40M_0_180			: signal is "true"; 
	signal cdr_clk_160M_0							: std_logic:='0';
	attribute keep of cdr_clk_160M_0				: signal is "true"; 	

	--parameters
--	signal ttc_fmc_reg_ctrl				: std_logic_vector(31 downto 0):=(others=>'0');	
--	signal ttc_fmc_reg_status			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal ttc_fmc_xpoint_4x4_s10		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s11		: std_logic:='1';	
	signal ttc_fmc_xpoint_4x4_s20		: std_logic:='1';	
	signal ttc_fmc_xpoint_4x4_s21		: std_logic:='1';	
	signal ttc_fmc_xpoint_4x4_s30		: std_logic:='1';	
	signal ttc_fmc_xpoint_4x4_s31		: std_logic:='1';	
	signal ttc_fmc_xpoint_4x4_s40		: std_logic:='0';	
--	signal ttc_fmc_xpoint_4x4_s41		: std_logic:='0';	


	signal l1accept_resync 			: std_logic:='0';
	signal l1accept_resync_del 	: std_logic_vector(1 downto 0):=(others=>'0');	



	---------------********************************TTC_FMC************************************----------------
--	signal brcst							: std_logic_vector(7 downto 2):=(others=>'0');	
	---------------******************************END TTC_FMC**********************************----------------	



	---------------********************************TTC_CMD************************************----------------
--	--from paschalis
--	constant CMD_BC0 		: std_logic_vector(brcst'range):="00"&x"1";
--	constant CMD_RSN 		: std_logic_vector(brcst'range):="00"&x"5";
--	constant CMD_EC0 		: std_logic_vector(brcst'range):="00"&x"7";
--	constant CMD_OC0 		: std_logic_vector(brcst'range):="00"&x"8";
--	constant CMD_START 	: std_logic_vector(brcst'range):="00"&x"9";
--	constant CMD_STOP 	: std_logic_vector(brcst'range):="00"&x"a";

	--from chipscope during the Beam Test
	--constant CMD_BC0 		: std_logic_vector(brcst'range):="00"&x"1";
	--constant CMD_RSN 		: std_logic_vector(brcst'range):="00"&x"5";
	--constant CMD_EC0 		: std_logic_vector(brcst'range):="00"&x"7";
	--constant CMD_OC0 		: std_logic_vector(brcst'range):="00"&x"8";
	constant CMD_START 	: std_logic_vector(brcst'range):="100010";
	constant CMD_STOP 	: std_logic_vector(brcst'range):="00"&x"a";	
	---------------******************************END TTC_CMD**********************************----------------
		

	---------------********************************TTC_CMD_VALID************************************----------------
	signal cmd_stop_valid 			: std_logic:='0';	
	signal cmd_start_valid 			: std_logic:='0';	
	---------------******************************END TTC_CMD_VALID**********************************----------------	

	


	---------------********************************CBC_EMULATOR************************************----------------
	signal cbc_transmission_start 		: std_logic:='0';
	signal cbc_transmission_end 			: std_logic:='0';	
	signal cbc_frame_out 					: std_logic:='0';
	---------------******************************END CBC_EMULATOR**********************************----------------	
	
	
	---------------********************************CBC_RECEIVER************************************----------------
	--> aclr
	signal cbc_rcv_aclr 							: std_logic:='0';
	--> receiver / deserialiser
	signal cbc_rcv_frame_in 					: array_FE_NBxCBC_NBx1bit;	
	signal cbc_rcv_capture_out 				: array_FE_NBxCBC_NBx1bit;

	signal cbc_rcv_data 							: array_FE_NBxCBC_NBxCBC_DATA_BITS_NB;
	signal cbc_rcv_data_en 						: array_FE_NBxCBC_NBx1bit;		
	--selection
	signal cbc_rcv_data_test					: array_FE_NBxCBC_NBxCBC_DATA_BITS_NB; 
	signal cbc_rcv_data_test_FF				: std_logic_vector(CBC_DATA_BITS_NB-1 downto 0):=(others=>'0');
	signal cbc_rcv_data_test_x44				: std_logic_vector(CBC_DATA_BITS_NB-1 downto 0):=(others=>'0');	
	
	--> after selection
	signal cbc_rcv_data_selected				: array_FE_NBxCBC_NBxCBC_DATA_BITS_NB;
	signal cbc_rcv_data_selected_en			: array_FE_NBxCBC_NBx1bit;	
	--> delay
	signal cbc_rcv_data_selected_en_del1	: array_FE_NBxCBC_NBx1bit;
	---------------******************************END CBC_RECEIVER**********************************----------------		
	



	---------------********************************SRAM_INTERFACE_CBC_DATA************************************----------------
	--	constant user_sram_choice 						: positive:= 1 ; --1 : sram1 / 2 : sram2	
	-- constant sram_number  							: natural 	:= 2;
	-- constant sram1										: natural 	:= 1; --already declared into system_package
	-- constant sram2										: natural 	:= 2;	
	
	signal CBC_user_sram_control					: userSramControlR_array(1 to 2); 	--sram_package.vhd
	signal CBC_user_sram_addr						: array_2x21bit; 							--sram_package.vhd
	signal CBC_user_sram_wdata						: array_2x36bit:=((others=>'0'),(others=>'0'));	
	signal CBC_user_sram_addr_tmp1				: array_2x21bit; 							--sram_package.vhd
	signal CBC_user_sram_wdata_tmp1				: array_2x36bit:=((others=>'0'),(others=>'0'));	
	---------------******************************END SRAM_INTERFACE_CBC_DATA**********************************----------------	
	

	---------------********************************CTRL************************************----------------
	signal CBC_user_sram_write_cycle : std_logic_vector(2 downto 1):=(others=>'0'); --sram1 or sram2	
--	signal fsm1_CBC_data_packet_counter : integer range 0 to 63:=0;--
--	signal fsm2_CBC_data_packet_counter : integer range 0 to 63:=0;--	
--	--Handshaking between SRAM flags & SW
--	signal SRAM1_full : std_logic:='0';	
--	signal SRAM2_full : std_logic:='0';	
--	signal SRAM1_end_readout : std_logic:='0';		
--	signal SRAM2_end_readout : std_logic:='0';
--	--
--	signal SRAM1_full_one_cycle : std_logic:='0';
--	signal SRAM2_full_one_cycle : std_logic:='0';

	--new
	type fsm_CBC_data_packet_counter_type	 	is array(2 downto 1) of integer range 0 to TOTAL_WORDS_NB + 3 ;--63;
	signal fsm_CBC_data_packet_counter 			: fsm_CBC_data_packet_counter_type;
	
	type array_SRAM_NBx1bit			 				is array(2 downto 1) of std_logic;
	--Handshaking between SRAM flags & SW
	signal SRAM_full 									: array_SRAM_NBx1bit;			
	signal SRAM_end_readout 						: array_SRAM_NBx1bit;
	--
	signal SRAM_full_one_cycle						: array_SRAM_NBx1bit;

	--new
	--
	signal flags_pc_to_vhdl_2b 					: std_logic_vector(1 downto 0):=(others=>'0'); 
	signal flags_pc_to_vhdl_resync_2b 			: std_logic_vector(1 downto 0):=(others=>'0');	
	---------------******************************END CTRL**********************************----------------



	---------------********************************ACQ_COUNTERS************************************----------------
	signal BC_COUNTER_12b 							: std_logic_vector(11 downto 0):=(others=>'0'); --integer range 0 to 3563 		:= 0; --2**12-1=4095 max 
	signal BC_COUNTER_24b 							: std_logic_vector(23 downto 0):=(others=>'0'); --same range than 12b
	signal ORB_COUNTER_18b 							: std_logic_vector(17 downto 0):=(others=>'0'); --integer range 0 to 2**18-1 	:= 0;
	signal ORB_COUNTER_24b 							: std_logic_vector(23 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;
	signal LS_COUNTER_24b 							: std_logic_vector(23 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;
	signal L1A_COUNTER 								: std_logic_vector(L1A_COUNTER_BITS_NB-1 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;	
	signal CBC_DATA_COUNTER 						: array_FE_NBxCBC_NBxCBC_COUNTER_BITS_NB; --array_FE_NBxCBC_NBx24bit;
	---------------******************************END ACQ_COUNTERS**********************************----------------
	signal BC_COUNTER_full_32b 					: std_logic_vector(31 downto 0):=(others=>'0'); --integer range 0 to 2**32-1 	:= 0;
	signal BC_COUNTER_full_32b_resync			: std_logic_vector(31 downto 0):=(others=>'0'); --integer range 0 to 2**32-1 	:= 0;



	---------------********************************FIFO_TIME_TRIGGER************************************----------------
	--> Storage of Time&Trigger - FIFO2
	--constant TIME_TRIGGER_FIFO_BITS_NB 				: natural := 96;
	signal TIME_TRIGGER_FIFO_DIN 						: std_logic_vector(TIME_TRIGGER_FIFO_BITS_NB-1 downto 0):=(others=>'0');  
	signal TIME_TRIGGER_FIFO_DOUT 					: std_logic_vector(TIME_TRIGGER_FIFO_DIN'range):=(others=>'0');
	signal TIME_TRIGGER_FIFO_WR_EN					: std_logic:='0';
	signal TIME_TRIGGER_FIFO_WR_ACK					: std_logic:='0';	
	signal TIME_TRIGGER_FIFO_RD_EN					: std_logic:='0';
	signal TIME_TRIGGER_FIFO_VALID					: std_logic:='0';
	signal TIME_TRIGGER_FIFO_FULL						: std_logic:='0';
	signal TIME_TRIGGER_FIFO_EMPTY					: std_logic:='0'; 	
	signal TIME_TRIGGER_FIFO_PROG_FULL				: std_logic:='0';
	signal TIME_TRIGGER_FIFO_PROG_EMPTY				: std_logic:='0';
	---------------******************************END FIFO_TIME_TRIGGER**********************************----------------


	---------------********************************FIFO_CBC_DATA************************************----------------
	--> Storage of CBC DATA - FIFO1
	signal CBC_DATA_FIFO_DIN 								: array_FE_NBxCBC_NBxCBC_DATA_BITS_NB; 
	signal CBC_DATA_FIFO_DOUT 								: array_FE_NBxCBC_NBxCBC_DATA_BITS_NB;
	signal CBC_DATA_FIFO_WR_EN								: array_FE_NBxCBC_NBx1bit;
	signal CBC_DATA_FIFO_WR_ACK							: array_FE_NBxCBC_NBx1bit;	
	signal CBC_DATA_FIFO_RD_EN								: array_FE_NBxCBC_NBx1bit;
	signal CBC_DATA_FIFO_VALID								: array_FE_NBxCBC_NBx1bit;	
	signal CBC_DATA_FIFO_FULL								: array_FE_NBxCBC_NBx1bit;
	signal CBC_DATA_FIFO_EMPTY								: array_FE_NBxCBC_NBx1bit; 	
	signal CBC_DATA_FIFO_PROG_FULL						: array_FE_NBxCBC_NBx1bit;
	signal CBC_DATA_FIFO_PROG_EMPTY						: array_FE_NBxCBC_NBx1bit;	
	---------------******************************END FIFO_CBC_DATA**********************************----------------


	---------------********************************FIFO_CBC_COUNTER************************************----------------
	--> Storage of CBC COUNTER
	signal CBC_COUNTER_FIFO_DIN 								: array_FE_NBxCBC_NBx24bit; 
	signal CBC_COUNTER_FIFO_DOUT 								: array_FE_NBxCBC_NBx24bit;
	signal CBC_COUNTER_FIFO_WR_EN								: array_FE_NBxCBC_NBx1bit;
	signal CBC_COUNTER_FIFO_WR_ACK							: array_FE_NBxCBC_NBx1bit;	
	signal CBC_COUNTER_FIFO_RD_EN								: array_FE_NBxCBC_NBx1bit;
	signal CBC_COUNTER_FIFO_VALID								: array_FE_NBxCBC_NBx1bit;	
	signal CBC_COUNTER_FIFO_FULL								: array_FE_NBxCBC_NBx1bit;
	signal CBC_COUNTER_FIFO_EMPTY								: array_FE_NBxCBC_NBx1bit; 	
	signal CBC_COUNTER_FIFO_PROG_FULL						: array_FE_NBxCBC_NBx1bit;
	signal CBC_COUNTER_FIFO_PROG_EMPTY						: array_FE_NBxCBC_NBx1bit;	
	---------------******************************END FIFO_CBC_COUNTER**********************************----------------


	---------------********************************TDC_COUNTER************************************----------------
	--constant TDC_COUNTER_BITS_NB									: positive := 6;
	signal TDC_COUNTER 												: std_logic_vector(TDC_COUNTER_BITS_NB-1 downto 0):=(others=>'0');
	--new
	signal TDC_COUNTER_resync										: std_logic_vector(TDC_COUNTER_BITS_NB-1 downto 0):=(others=>'0');
	--
	signal TDC_COUNTER_latched										: std_logic_vector(TDC_COUNTER_BITS_NB-1 downto 0):=(others=>'0');	
	signal TDC_COUNTER_latched_valid								: std_logic:='0';	
	---------------******************************END TDC_COUNTER**********************************----------------

	---------------********************************FIFO_TDC************************************----------------
	--constant TDC_COUNTER_FIFO_BITS_NB							: positive := 6;
	--> Storage of TDC_COUNTER
	signal TDC_COUNTER_FIFO_DIN 									: std_logic_vector(TDC_COUNTER_FIFO_BITS_NB-1 downto 0):=(others=>'0'); 
	signal TDC_COUNTER_FIFO_DOUT 									: std_logic_vector(TDC_COUNTER_FIFO_BITS_NB-1 downto 0):=(others=>'0');
	signal TDC_COUNTER_FIFO_WR_EN									: std_logic:='0';
	signal TDC_COUNTER_FIFO_WR_ACK								: std_logic:='0';	
	signal TDC_COUNTER_FIFO_RD_EN									: std_logic:='0';
	signal TDC_COUNTER_FIFO_VALID									: std_logic:='0';	
	signal TDC_COUNTER_FIFO_FULL									: std_logic:='0';
	signal TDC_COUNTER_FIFO_EMPTY									: std_logic:='0';	
	signal TDC_COUNTER_FIFO_PROG_FULL							: std_logic:='0';
	signal TDC_COUNTER_FIFO_PROG_EMPTY							: std_logic:='0';
	---------------******************************END FIFO_TDC**********************************----------------

	--flag FSM FIFO_TDC
	signal FSM_FIFO_TDC_flag 			: std_logic_vector(7 downto 0):=(others=>'0');	


	---------------********************************FIFO_STUBDATA************************************----------------
	--> Storage of STUBDATA
--	signal CBC_STUBDATA_FIFO_DIN 									: array_FE_NBx2bit; 
--	signal CBC_STUBDATA_FIFO_DOUT 								: array_FE_NBx2bit;
	signal CBC_STUBDATA_FIFO_WR_EN								: array_FE_NBx1bit;
	signal CBC_STUBDATA_FIFO_WR_ACK								: array_FE_NBx1bit;	
	signal CBC_STUBDATA_FIFO_RD_EN								: array_FE_NBx1bit;
	signal CBC_STUBDATA_FIFO_VALID								: array_FE_NBx1bit;	
	signal CBC_STUBDATA_FIFO_FULL									: array_FE_NBx1bit;
	signal CBC_STUBDATA_FIFO_EMPTY								: array_FE_NBx1bit;	
	signal CBC_STUBDATA_FIFO_PROG_FULL							: array_FE_NBx1bit;
	signal CBC_STUBDATA_FIFO_PROG_EMPTY							: array_FE_NBx1bit;
	
	signal CBC_STUBDATA_FIFO_DIN 									: array_FE_NBxCBC_NB_bit; 
	signal CBC_STUBDATA_FIFO_DOUT 								: array_FE_NBxCBC_NB_bit;

	
	---------------******************************END FIFO_STUBDATA**********************************----------------

	---------------********************************STUBDATA_VAR_DELAY************************************----------------
--	--param
	constant StubLatAdjLogDepth 						: positive := 7; --2**7 = 128 
	type array_FE_NBxStubLatAdjLogDepth				is array(FE_NB-1 downto 0) of std_logic_vector(StubLatAdjLogDepth-1 downto 0);	
	
	signal CBC_STUBDATA_LATENCY_ADJUST 				: array_FE_NBxStubLatAdjLogDepth; --param
	signal L1A_VALID_ADJUST_FOR_CBC_STUBDATA		: array_FE_NBx1bit;

--	signal cbc_stubdata_all                		: array_FE_NBx2bit;
--	signal cbc_stubdata_all_varDelay 				: array_FE_NBx2bit;

	signal cbc_stubdata_all                		: array_FE_NBxCBC_NB_bit;
	signal cbc_stubdata_all_varDelay 				: array_FE_NBxCBC_NB_bit;	
	
	
	---------------******************************END STUBDATA_VAR_DELAY**********************************----------------



	---------------********************************FSM_FIFO2************************************----------------
--	--> FOR FIFO2
--	type FSM_FIFO2_states is (		FSM_FIFO2_idle, 			FSM_FIFO2_wait_start,		FSM_FIFO2_write_data1,		 		
--											FSM_FIFO2_write_data_OOS,		FSM_FIFO2_BUSY, 				FSM_FIFO2_BUSY2
--										);
--	signal FSM_FIFO2_state : FSM_FIFO2_states; 
	
	--FSM FIFO flags
	signal FSM_FIFO2_flag 								: std_logic_vector(7 downto 0):=(others=>'0');	
	signal fifo2_busy										: std_logic:='0';
	---------------******************************END FSM_FIFO2**********************************----------------	





	---------------********************************FSM_FIFO1************************************----------------
--	--> FOR FIFO1
--	type FSM_FIFO1_states is (		FSM_FIFO1_idle, 			FSM_FIFO1_wait_start, 		FSM_FIFO1_write_data1, 		
--											FSM_FIFO1_write_data_OOS,		FSM_FIFO1_BUSY, 				FSM_FIFO1_BUSY2
--										);
--	signal FSM_FIFO1_state : FSM_FIFO1_states; 
	
	--FSM FIFO flags

	signal FSM_FIFO1_flag 								: array_FE_NBxCBC_NBx8bit;	
	---------------******************************END FSM_FIFO1**********************************----------------	




	---------------********************************FSM_SRAM************************************----------------
--	--> FOR FIFO_TO_SRAM1
--	type FSM_FIFO_TO_SRAM1_states is (		FSM_FIFO_TO_SRAM1_idle,	FSM_FIFO_TO_SRAM1_empty_FIFO, FSM_FIFO_TO_SRAM1_init,
--														FSM_FIFO_TO_SRAM1_test_2FIFO_not_empty,	FSM_FIFO_TO_SRAM1_latch_data,	FSM_FIFO_TO_SRAM1_store_data,
--														FSM_FIFO_TO_SRAM1_test_packet_sent,	FSM_FIFO_TO_SRAM1_flag_full,	FSM_FIFO_TO_SRAM1_test_end_readout
--												);
--	signal FSM_FIFO_TO_SRAM1_state : FSM_FIFO_TO_SRAM1_states;	
--	
--	--> FOR FIFO_TO_SRAM2
--	type FSM_FIFO_TO_SRAM2_states is (		FSM_FIFO_TO_SRAM2_idle,	FSM_FIFO_TO_SRAM2_empty_FIFO, FSM_FIFO_TO_SRAM2_init,
--														FSM_FIFO_TO_SRAM2_test_2FIFO_not_empty,	FSM_FIFO_TO_SRAM2_latch_data, FSM_FIFO_TO_SRAM2_store_data,
--														FSM_FIFO_TO_SRAM2_test_packet_sent,	FSM_FIFO_TO_SRAM2_flag_full,	FSM_FIFO_TO_SRAM2_test_end_readout
--												);											
--	signal FSM_FIFO_TO_SRAM2_state : FSM_FIFO_TO_SRAM2_states;	

--	--FSM SRAM flags
--	signal FSM_FIFO_TO_SRAM1_flag 	: std_logic_vector(7 downto 0):=(others=>'0');
--	signal FSM_FIFO_TO_SRAM2_flag 	: std_logic_vector(7 downto 0):=(others=>'0');

	--FSM SRAM flags
	type array_SRAM_NBx8bit 						is array(2 downto 1) of std_logic_vector(7 downto 0);
	signal FSM_FIFO_TO_SRAM_flag 					: array_SRAM_NBx8bit;	
	

	

--	--new
--	constant CBC_COUNTER_FIFO_BITS_NB 			: natural := 24;
--	constant CBC_STUBDATA_BITS_NB 				: natural := 1;	
----	constant DATA_TO_SRAM_BITS_NB 				: natural := 	TIME_TRIGGER_FIFO_BITS_NB 
----																				+ CBC_COUNTER_FIFO_BITS_NB  
----																				+ ((CBC_DATA_BITS_NB + CBC_STUBDATA_BITS_NB) * FE_NB * CBC_NB) 
----																				+ TDC_COUNTER_BITS_NB ;
----	
----	type DATA_TO_SRAM_type 							is array (1 to 2) of std_logic_vector(DATA_TO_SRAM_BITS_NB-1 downto 0);	
----	signal DATA_TO_SRAM 								: DATA_TO_SRAM_type;
--
--
--	--new
--	constant TIME_WORDS_NB 										: natural := 3;
--	constant L1A_COUNTER_WORDS_NB 							: natural := 1;
--	constant CBC_COUNTER_WORDS_NB								: natural := 1;
--	constant TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB 	: natural := TIME_WORDS_NB + L1A_COUNTER_WORDS_NB + CBC_COUNTER_WORDS_NB; --5
--	constant TIME_AND_TRIGGER_EVENTS_COUNTER_FORMAT		: natural := 24;
--	constant TIME_AND_TRIGGER_EVENTS_COUNTER_BITS_NB	: natural := TIME_AND_TRIGGER_EVENTS_COUNTER_FORMAT * TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB; --120
--	constant CBC_DATA_AND_STUB_WORDS_NB						: natural := 9; -- (264+1)/32 = 8,2  (stub bit comprised)
--	constant TDC_WORDS_NB 										: natural := 1;
--	constant TOTAL_WORDS_NB 									: natural := TIME_AND_TRIGGER_EVENTS_COUNTER_WORDS_NB + (CBC_DATA_AND_STUB_WORDS_NB * FE_NB * CBC_NB) + TDC_WORDS_NB; --42
--	constant TOTAL_BITS_NB 										: natural := TOTAL_WORDS_NB * 32;
--	constant ALL_FIFOS_BITS_NB 								: natural := 	  TIME_TRIGGER_FIFO_BITS_NB 
--																							+ CBC_COUNTER_FIFO_BITS_NB  
--																							+ ((CBC_DATA_BITS_NB + CBC_STUBDATA_BITS_NB) * FE_NB * CBC_NB) 
--																							+ TDC_COUNTER_BITS_NB ;
	
	
	constant DATA_TO_SRAM_BITS_NB 							: natural := TOTAL_BITS_NB;
	type DATA_TO_SRAM_type 										is array (1 to 2) of std_logic_vector(DATA_TO_SRAM_BITS_NB-1 downto 0);	
	signal DATA_TO_SRAM 											: DATA_TO_SRAM_type;
	signal DATA_TO_SRAM_tmp 									: std_logic_vector(DATA_TO_SRAM_BITS_NB-1 downto 0);
	signal DATA_TO_SRAM_tmp2 									: std_logic_vector(DATA_TO_SRAM_BITS_NB-1 downto 0);
	
	--rd_en fifo
	signal RD_EN_FIFO_ALL_tmp						: std_logic_vector(2 downto 1):=(others=>'0');	
	signal RD_EN_FIFO_ALL			   			: std_logic:='0';


	signal ALL_FIFO_empty_ok						: std_logic_vector(2 downto 1):=(others=>'0');
	---------------******************************END FSM_SRAM**********************************----------------	






--new
	signal condition_oos								: std_logic:='0'; 
	
	signal spurious_flag 							: std_logic:='0';
	signal spurious_flag_for_each_cbc			: array_FE_NBxCBC_NBx1bit;


	signal ALL_FIFOS_ARE_EMPTY 					: std_logic:='0';
	signal ALL_FIFOS_ARE_NOT_EMPTY 				: std_logic:='0';





--	---------------********************************FLAGS************************************----------------
--
	--flags linked with the SW 
	signal flags_vhdl_to_pc_32b 					: std_logic_vector(31 downto 0):=(others=>'0');
	--new
	signal flags_vhdl_to_pc_resync_32b 			: std_logic_vector(31 downto 0):=(others=>'0');
--	---------------******************************END FLAGS**********************************----------------	


	
	--TEST
	signal TIME_TRIGGER_FIFO_DIN_del					: std_logic_vector(TIME_TRIGGER_FIFO_DIN'range):=(others=>'0'); 

--	---------------********************************CHIPSCOPE************************************----------------
--	signal CONTROL0 						: std_logic_vector(35 downto 0);
--
--	constant DATA_ILA_BITS_NB : positive := 278; --150 for CBC1
--	signal data_ila_ttc_fmc 		: std_logic_vector(DATA_ILA_BITS_NB-1 downto 0):=(others=>'0');
--	signal trigger_ila_ttc_fmc 		: std_logic:='0'; 
--	---------------******************************END CHIPSCOPE**********************************----------------	
	
	
	
   -- Control:	cbonnin
	signal control_setup1 : std_logic_vector(31 downto 0):=(others=>'0');
	signal control_setup2 : std_logic_vector(31 downto 0):=(others=>'0');	



	signal COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID		: std_logic:='0';
	signal COMMISSIONNING_MODE_CBC_FAST_RESET_VALID		: std_logic:='0';	
	
	signal BREAK_TRIGGER 										: std_logic:='0';
	signal COMMISSIONNING_MODE_RQ 							: std_logic:='0';
	signal COMMISSIONNING_MODE_RQ_to_resync				: std_logic:='0';

	signal COMMISSIONNING_MODE_ACK_END 						: std_logic_vector(1 downto 0):=(others=>'0');	
	constant COMMISSIONNING_MODE_DELAY_BITS_NB 			: positive := 16; --16-bit format	
	signal COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET	: std_logic_vector(COMMISSIONNING_MODE_DELAY_BITS_NB-1 downto 0):=(others=>'0');
	signal COMMISSIONNING_MODE_DELAY_AFTER_TEST_PULSE	: std_logic_vector(COMMISSIONNING_MODE_DELAY_BITS_NB-1 downto 0):=(others=>'0');
	signal COMMISSIONNING_MODE_DELAY_AFTER_L1A			: std_logic_vector(COMMISSIONNING_MODE_DELAY_BITS_NB-1 downto 0):=(others=>'0');
	signal COMMISSIONNING_MODE_LOOPS_NB						: std_logic_vector(31 downto 0):=(others=>'0');	





	---------------********************************PARAMETERS************************************----------------
	--cmd ipbus
	signal cbc_t1_trigger_ipbus_user	: std_logic:='0';
	--signal LongTrigger : std_logic_vector(2 downto 0):= std_logic_vector(to_unsigned(2,3));
	--signal INT_TRIGGER_FREQ_SEL 			: std_logic_vector(3 downto 0):=(others=>'0');


	--Parameter Word for Test
	signal cbc_i2c_param_word_i		: std_logic_vector(31 downto 0) := (others=>'0');
	signal cbc_i2c_param_word_o		: std_logic_vector(31 downto 0) := (others=>'0');
--	signal cbc_i2c_cmd_rq				: std_logic_vector(1 downto 0)  := (others=>'0');	
--	signal cbc_i2c_cmd_ack				: std_logic_vector(1 downto 0)  := (others=>'0');
	signal cbc_i2c_cmd_rq				: array_FE_NBx2bit;	
	signal cbc_i2c_cmd_ack				: array_FE_NBx2bit;
	signal cbc_i2c_cmd_rq_to_resync	: array_FE_NBx2bit;	
	signal cbc_i2c_cmd_ack_resync		: array_FE_NBx2bit;




	
	
	
		----> registers mapping
	signal ttc_fmc_regs_from_wb 			: array_32x32bit; --array_32x32bit see system_package
	signal ttc_fmc_regs_to_wb 				: array_32x32bit;	

	----> readout/acq
	signal CBC_DATA_PACKET_NUMBER			: std_logic_vector(20 downto 0):=(others=>'0');	
	signal TRIGGER_SEL 						: std_logic:='0';
	signal ACQ_MODE 							: std_logic:='0';	
--	signal CBC_DATA_GENE 					: std_logic:='0';
	signal CBC_DATA_GENE 					: array_FE_NBxCBC_NBx1bit;	
	signal SPURIOUS_FRAME 					: std_logic:='0';		
	signal CLK_DEPHASING 					: std_logic:='0';
	signal POLARITY_sTTS 					: std_logic:='0';
	signal POLARITY_CBC 						: std_logic:='0';
	signal CMD_START_BY_PC 					: std_logic:='0';		
	signal PC_config_ok 						: std_logic:='0';
	signal INT_TRIGGER_FREQ_SEL 			: std_logic_vector(3 downto 0):=(others=>'0');
	signal POLARITY_TRIGGER_TO_CBC		: std_logic:='0';	
	--i2c polar
	signal POLARITY_SDA_FROM_CBC			: std_logic:='0';	
	signal POLARITY_SDA_TO_CBC				: std_logic:='0';	
	signal POLARITY_SCL						: std_logic:='0';	
	--new
	signal POLARITY_TLU 						: std_logic:='0';	
	--new
	signal FE_MASK 							: array_FE_NBx1bit;	
	signal CBC_MASK							: array_FE_NBxCBC_NBx1bit; --array_FE_NBx16bit;
	signal CBC_MASK_TMP						: array_FE_NBxCBC_NB_bit;		

	----> CBC
	--
	signal CBC_RESET_SEL 					: std_logic_vector(1 downto 0) := (others=>'0');
--	--I2C / SW interface 
--	signal cbc_ctrl_i2c_settings			: std_logic_vector(31 downto 0):=(others=>'0');	
--	signal cbc_ctrl_i2c_command			: std_logic_vector(31 downto 0):=(others=>'0');	
--	signal cbc_ctrl_i2c_reply				: std_logic_vector(31 downto 0):=(others=>'0');	
--	signal cbc_ctrl_i2c_done				: std_logic:='0';
	
	--resync param
	signal ACQ_MODE_RESYNC 				: std_logic:='0';		
	
	---------------******************************END PARAMETERS**********************************----------------
	
	signal cbc_i2c_phy_ctrl_reset 						: std_logic := '1';
	signal cbc_i2c_phy_ctrl_reset_from_user 			: std_logic := '1';	
	
	signal FPGA_CLKOUT_MUXSEL_NEW : std_logic_vector(4 downto 0):=(others=>'0');
	
	--new
	signal TDC_COUNTER_resync_chipscope							: std_logic_vector(TDC_COUNTER_BITS_NB-1 downto 0):=(others=>'0');
	signal TDC_COUNTER_FIFO_DIN_resync_chipscope				: std_logic_vector(TDC_COUNTER_FIFO_BITS_NB-1 downto 0):=(others=>'0'); 
	signal TDC_COUNTER_FIFO_WR_EN_resync_chipscope			: std_logic:='0';
	

	signal sclr_tdc_counter : std_logic := '0';
	signal tlu_trigger_i_320M_del : std_logic:='0';
	signal ce_tdc_counter : std_logic:='0';
	
	
	signal SW_USER_HYBRIDE_TYPE : std_logic:='0';	
	

	
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
   
   ip_addr_o				               <= x"c0_a8_00_a"     	& amc_slot_i;  -- 192.168.0.[160:175]
   mac_addr_o 				               <= x"08_00_30_F1_00_0"  & amc_slot_i;  -- 08:00:30:F1:00:0[0:F] 
  
  
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@ PLACE YOUR LOGIC BELOW THIS COMMENT @@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--


--	---------------********************************FMC_IO************************************----------------
--	--===============================================================================================--
--	fmc1_map: entity work.fmc_io_buffers
--	--===============================================================================================--
--	generic map
--	(
--		fmc_la_io_settings		=> fmc1_la_io_settings_constants,
--		fmc_ha_io_settings		=> fmc1_ha_io_settings_constants,
--		fmc_hb_io_settings		=> fmc1_hb_io_settings_constants
--	)
--	port map
--	(
--		fmc_io_pin					=> FMC1_IO_PIN,
--		fmc_from_fabric_to_pin	=> fmc1_from_fabric_to_pin,
--		fmc_from_pin_to_fabric	=> fmc1_from_pin_to_fabric
--	);                    	
--	--===============================================================================================--
--
--
--
--	--===============================================================================================--
--	fmc2_map: entity work.fmc_io_buffers
--	--===============================================================================================--
--	generic map
--	(
--		fmc_la_io_settings		=> fmc2_la_io_settings_constants,
--		fmc_ha_io_settings		=> fmc2_ha_io_settings_constants,
--		fmc_hb_io_settings		=> fmc2_hb_io_settings_constants
--	)
--	port map
--	(
--		fmc_io_pin					=> FMC2_IO_PIN,
--		fmc_from_fabric_to_pin	=> fmc2_from_fabric_to_pin,
--		fmc_from_pin_to_fabric	=> fmc2_from_pin_to_fabric
--	);          
--	--===============================================================================================--
--	---------------******************************END FMC_IO**********************************----------------

     
   
   --==================================== User Logic =====================================--
   
   --===============--
   -- General reset -- 
   --===============--
   
   reset_from_or_gate                           <= RESET_I or reset_from_user;   
   
   --===============--
   -- Clock buffers -- 
   --===============--   

   -- Fabric clock (40MHz) :
   -------------------------       
   xpoint1_clk3_ibufgds_inst: IBUFGDS
      generic map (
         IBUF_LOW_PWR                           => FALSE,
         IOSTANDARD                             => "LVDS_25")
      port map (                 
         O                                      => xpoint1_clk3_ibufgds,
         I                                      => XPOINT1_CLK3_P,
         IB                                     => XPOINT1_CLK3_N
      );
   

   xpoint1_clk3_bufg_inst: bufg               
      port map (              
         O                                      => xpoint1_clk3_bufg,
         I                                      => xpoint1_clk3_ibufgds 
      );   
			
		
   -- CDCE_OUT4 (if internal crystal used) / cdce_out4=240M :
   ---------------------------------------------------------- 

	--===============================================================================================--	
	ipcore_mmcm1_inst : entity work.mmcm1 
	--===============================================================================================--	
	PORT MAP (		-- Clock in ports
						CLK_IN1_P 			=> cdce_out4_p,
						CLK_IN1_N 			=> cdce_out4_n,
						-- Clock out ports
						CLK_OUT1 			=> cdce_out4_40M, --tx_frame_clk, 		--40M
						CLK_OUT2 			=> tdc_counter_clk, 	--240M
						-- Status and control signals
						RESET  				=> '0',
						LOCKED 				=> open
				);
	--==============================================================================================--

	
	

   -- TTC_FMC_v3
   -----------------	
	--===============================================================================================--
	--CDR 160M 	--cf user_clk.ucf : sur CON FMC = K4/K5 - ucf = D11/D12
	--===============================================================================================--
	--IF TTC_FMC_v3 on FMC1 = J2
	--===============================================================================================--
	fmc1_clk2_bidir_bufgds_inst: ibufgds --cdr 160M
	--===============================================================================================--
	generic map(	DIFF_TERM 	=> TRUE,
						IOSTANDARD 	=> "LVDS_25") 
	port map(		i 				=> fmc1_clk2_bidir_p, 
						ib 			=> fmc1_clk2_bidir_n, 
						o 				=> fmc1_clk2_bidir_bufgds
				);
	--===============================================================================================--	--===============================================================================================--

	--===============================================================================================--	
	fmc1_clk2_bidir_bufg_inst: bufg --cdr 160M
	--===============================================================================================--
	port map(		i => fmc1_clk2_bidir_bufgds,--xpoint1_clk1_i, --fmc1_clk2_bidir_bufgds, -bufgmux!!
						o => fmc1_clk2_bidir_bufg
				);
	--===============================================================================================--

	--IF TTC_FMC_v3 on FMC2 = J1
	--===============================================================================================--
	fmc2_clk1_m2c_bufgds_inst: ibufgds --cdr 160M
	--===============================================================================================--
	generic map(	DIFF_TERM 	=> TRUE,
						IOSTANDARD 	=> "LVDS_25") 
	port map(		i 				=> fmc2_clk1_m2c_p, 
						ib 			=> fmc2_clk1_m2c_n, 
						o 				=> fmc2_clk1_m2c_bufgds
				);
	--===============================================================================================--	--===============================================================================================--

	--===============================================================================================--	
	fmc2_clk1_m2c_bufg_inst: bufg --cdr 160M
	--===============================================================================================--
	port map(		i => fmc2_clk1_m2c_bufgds,
						o => fmc2_clk1_m2c_bufg
				);
	--===============================================================================================--




	--IF TTC_FMC_v3 on FMC1 = J2
	--cdr_clk 		<= fmc1_clk2_bidir_bufg; --input of ttcrx
	--IF TTC_FMC_v3 on FMC2 = J1
	cdr_clk 		<= fmc2_clk1_m2c_bufg; --input of ttcrx



	
	
	clock_select_1 : if TTC_CLK_USED = true generate
   begin
		--clock from ttcrx
		tx_frame_clk 		<= cdr_clk_40M_0_180;
	end generate;

	clock_select_2 : if TTC_CLK_USED = false generate
   begin
		--clock from internal OSC of GLIBv3
		tx_frame_clk 		<= xpoint1_clk3_bufg;
		--from cdce_out4
		--tx_frame_clk 		<= cdce_out4_40M;
	end generate;		




	
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: Note!! CDCE_OUT0 must be set to 240 MHz for the LATENCY-OPTIMIZED GBT Link.   
   
   sfp_ibufds_gtxe1: ibufds_gtxe1
      port map (
         I                                      => CDCE_OUT0_P,
         IB                                     => CDCE_OUT0_N,
         O                                      => cdce_out0,
         ceb                                    => '0'
      );                
         
   sfp_ibufds_bufg: bufg               
      port map (              
         O                                      => cdce_out0_bufg,
         I                                      => cdce_out0 
      );     
  
 


   --===========================--
   -- GBT Link reference design --
   --===========================--
	i_NUM_GBT_LINK_gene1 : for i_NUM_GBT_LINK in 1 to NUM_GBT_LINK generate    
		gbtRefDesign: entity work.xlx_v6_gbt_ref_design
			generic map (
				FABRIC_CLK_FREQ                        => 40e6)      
			port map (
				-- Resets scheme:      
				GENERAL_RESET_I                        => reset_from_or_gate,                   
				-- Clocks scheme:                      
				FABRIC_CLK_I                           => tx_frame_clk,--xpoint1_clk3, --used for reset
				MGT_REFCLKS_I                          => (tx => cdce_out0, rx => cdce_out0),              
				TX_OUTCLK_O                            => open,                                 -- Comment: TX_WORDCLK is generated internally  
				TX_WORDCLK_I                           => '0',                                  --          by GBT Link  
				TX_FRAMECLK_I                          => tx_frame_clk,--xpoint1_clk3,                      
				-- Serial lanes:                       
				MGT_TX_P                               => SFP_TX_P(i_NUM_GBT_LINK),                
				MGT_TX_N                               => SFP_TX_N(i_NUM_GBT_LINK),                
				MGT_RX_P                               => SFP_RX_P(i_NUM_GBT_LINK),                 
				MGT_RX_N                               => SFP_RX_N(i_NUM_GBT_LINK),
				-- GBT Link control:                   
				LOOPBACK_I                             => loopback_from_user,  
				TX_ENCODING_SEL_I                      => encodingSel_from_user,
				RX_ENCODING_SEL_I                      => encodingSel_from_user,
				TX_ISDATA_SEL_I                        => txIsDataSel_from_user,                 
				-- GBT Link status:                    
				LATENCY_OPT_GBTLINK_O                  => latencyOptGbtLink_from_gbtRefDesign(i_NUM_GBT_LINK-1),             
				MGT_READY_O                            => mgtReady_from_gbtRefDesign(i_NUM_GBT_LINK-1),             
				RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_gbtRefDesign(i_NUM_GBT_LINK-1),
				RX_BITSLIP_NUMBER_O                    => rxBitSlipNbr_from_gbtRefDesign(i_NUM_GBT_LINK-1),            
				RX_WORDCLK_ALIGNED_O                   => rxWordClkAligned_from_gbtRefDesign(i_NUM_GBT_LINK-1),           
				RX_FRAMECLK_ALIGNED_O                  => rxFrameClkAligned_from_gbtRefDesign(i_NUM_GBT_LINK-1),            
				RX_GBT_READY_O                         => rxGbtReady_from_gbtRefDesign(i_NUM_GBT_LINK-1),
				RX_ISDATA_FLAG_O                       => rxIsDataFlag_from_gbtRefDesign(i_NUM_GBT_LINK-1),            
				-- GBT Link data:                      
				TX_DATA_O                              => txCommonData_from_gbtRefDesign(i_NUM_GBT_LINK-1),            
				TX_WIDEBUS_EXTRA_DATA_O                => txWidebusExtraData_from_gbtRefDesign(i_NUM_GBT_LINK-1),
				---------------------------------------
				RX_DATA_O                              => rxCommonData_from_gbtRefDesign(i_NUM_GBT_LINK-1),           
				RX_WIDEBUS_EXTRA_DATA_O                => rxWidebusExtraData_from_gbtRefDesign(i_NUM_GBT_LINK-1),
				-- Test control & status:              
				TEST_PATTERN_SEL_I                     => testPatterSel_from_user,        
				---------------------------------------                    
				RESET_DATA_ERROR_SEEN_FLAG_I           => resetDataErrorSeenFlag_from_user,     
				RESET_RX_GBT_READY_LOST_FLAG_I         => resetRxGbtReadyLostFlag_from_user,     
				---------------------------------------                    
				RX_GBT_READY_LOST_FLAG_O               => rxGbtReadyLostFlag_from_gbtRefDesign(i_NUM_GBT_LINK-1),       
				COMMONDATA_ERROR_SEEN_FLAG_O           => commDataErrSeen_from_gbtRefDesign(i_NUM_GBT_LINK-1),      
				WIDEBUSDATA_ERROR_SEEN_FLAG_O          => widebusDataErrSeen_from_gbtRefDesign(i_NUM_GBT_LINK-1),      
				-- Latency measurement:                
				TX_FRAMECLK_O                          => txFrameClk_from_gbtRefDesign(i_NUM_GBT_LINK-1),   -- Comment: This clock is tx_frame_clk --is "xpoint1_clk3"           
				RX_FRAMECLK_O                          => rxFrameClk_from_gbtRefDesign(i_NUM_GBT_LINK-1),         
				TX_WORDCLK_O                           => txWordClk_from_gbtRefDesign(i_NUM_GBT_LINK-1),          
				RX_WORDCLK_O                           => rxWordClk_from_gbtRefDesign(i_NUM_GBT_LINK-1),          
				---------------------------------------                
				TX_MATCHFLAG_O                         => txMatchFlag_from_gbtRefDesign(i_NUM_GBT_LINK-1),          
				RX_MATCHFLAG_O                         => rxMatchFlag_from_gbtRefDesign(i_NUM_GBT_LINK-1),
				---------------------------------------
				--lcharles
				-- User Indivudual Resets - lcharles
				MGT_TXRESET_FROM_USER_I						=> mgt_TxReset_from_user,
				MGT_RXRESET_FROM_USER_I						=> mgt_RxReset_from_user,
				GBT_TXRESET_FROM_USER_I						=> gbt_TxReset_from_user,
				GBT_RXRESET_FROM_USER_I						=> gbt_RxReset_from_user,					
				--data to send
				to_gbtTx_from_user_i							=> to_gbtTx_from_user(i_NUM_GBT_LINK-1),
				be_fe_sync_done_i								=> '1' --BE_FE_syncTest_done   				
			); 
	end generate;












   --=======================--   
   -- Test control & status --   
   --=======================--      
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 
         
   cdceLockedReg: process(reset_from_or_gate, tx_frame_clk) 
   begin
      if reset_from_or_gate = '1' then
         userCdceLocked_r                       <= '0';
      elsif rising_edge(tx_frame_clk) then
         userCdceLocked_r                       <= USER_CDCE_LOCKED_I;
      end if;
   end process;   









   
	
   -- Signals mapping:
   -------------------
	--===============================================================================================--
	user_be_wb_regs_inst: entity work.user_be_wb_regs --registers mapping
	--===============================================================================================--
	port map 
	(
		wb_mosi	=> wb_mosi_i(user_wb_be),
		wb_miso 	=> wb_miso_o(user_wb_be),	
		regs_o 	=> user_be_regs_from_wb, 
		regs_i 	=> user_be_regs_to_wb
	);
	--===============================================================================================--			


   -- Control:
   reset_from_user								<= user_be_regs_from_wb(3)(0);
	FPGA_CLKOUT_MUXSEL							<= user_be_regs_from_wb(3)(1);	
	testPatterSel_from_user						<= user_be_regs_from_wb(3)(3 downto 2); --by def "10" 
	loopback_from_user							<= user_be_regs_from_wb(3)(6 downto 4);
	encodingSel_from_user	 					<= "00"; --GBT Frames by def
	resetDataErrorSeenFlag_from_user			<= user_be_regs_from_wb(3)(7); --not used
	resetRxGbtReadyLostFlag_from_user		<= user_be_regs_from_wb(3)(8); --not used
	--
	resyncWait_from_user							<= '0'; --user_be_regs_from_wb(3)(9); --'1' by def
	--
	FPGA_CLKOUT_MUXSEL_NEW						<= user_be_regs_from_wb(3)(14 downto 10);
	--
	BE_FE_RESYNC_DELAY							<= user_be_regs_from_wb(4);
	BE_FE_SYNC_TEST_DELAY						<= user_be_regs_from_wb(5);
	--
  
  
   -- Status:
   user_be_regs_to_wb(6)(0)  					<= userCdceLocked_r;
   user_be_regs_to_wb(6)(1)  					<= latencyOptGbtLink_from_gbtRefDesign(0);
   user_be_regs_to_wb(6)(2)  					<= mgtReady_from_gbtRefDesign(0);
   user_be_regs_to_wb(6)(3)  					<= rxWordClkAligned_from_gbtRefDesign(0);
   user_be_regs_to_wb(6)(4)  					<= rxFrameClkAligned_from_gbtRefDesign(0);
   user_be_regs_to_wb(6)(5)  					<= rxGbtReady_from_gbtRefDesign(0);	
   user_be_regs_to_wb(6)(6)  					<= rxGbtReadyLostFlag_from_gbtRefDesign(0); --to put into my block	
   user_be_regs_to_wb(6)(7)  					<= BE_FE_syncTest_done;	   
	user_be_regs_to_wb(6)(8)  					<= BE_FE_syncTest_ErrorSeen;	  
	user_be_regs_to_wb(6)(10 downto 9)  	<= BE_FE_syncTest_result;	  

   -- Control:
	rq_cmd_from_sw 								<= user_be_regs_from_wb(7)(7 downto 0);
	gbt_sram_wordNb								<= user_be_regs_from_wb(7)(28 downto 8);
	SRAM_RdLatency 								<= user_be_regs_from_wb(7)(31 downto 29); 
   
	-- Status:		
	user_be_regs_to_wb(8)(1 downto 0)		<= rq_ack_from_be;

--	user_be_regs_to_wb(8)(3 downto 2)		<= cbc_i2c_cmd_ack(0);
--	user_be_regs_to_wb(8)(5 downto 4)		<= cbc_i2c_cmd_ack(1);
	user_be_regs_to_wb(8)(3 downto 2)		<= cbc_i2c_cmd_ack_resync(0);
--	user_be_regs_to_wb(8)(5 downto 4)		<= cbc_i2c_cmd_ack_resync(1);
--	process
--	begin
--	wait until rising_edge(wb_mosi_i(user_wb_be).wb_clk);
--		user_be_regs_to_wb(8)(3 downto 2)		<= cbc_i2c_cmd_ack_resync(0) and cbc_i2c_cmd_ack_resync(1);
--		user_be_regs_to_wb(8)(5 downto 4)		<= cbc_i2c_cmd_ack_resync(0) and cbc_i2c_cmd_ack_resync(1);
--	end process;
	--===============================================================================================--
	i_fe_cbc_i2c_cmd_ack_resync_loop : for i_fe in 1 to FE_NB generate	
		--===============================================================================================--
		cbc_i2c_cmd_ack_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
		--===============================================================================================--
		generic map (n => 2) 
		port map 
		(
			wrclk_i							=> tx_frame_clk,
			rdclk_i							=> wb_mosi_i(user_wb_be).wb_clk, 
			wdata_i							=> cbc_i2c_cmd_ack(i_fe-1),
			rdata_o							=> cbc_i2c_cmd_ack_resync(i_fe-1)
		); 
		--===============================================================================================--
	end generate;
	--===============================================================================================--		--



	user_be_regs_to_wb(8)(7 downto 6)		<= COMMISSIONNING_MODE_ACK_END; --"00" : end / "01 : ACK_OK / "10" : ACK_KO


	--===============================================================================================--
	i_fe_cbc_i2c_cmd_rq_to_resync_loop : for i_fe in 1 to FE_NB generate	
		--===============================================================================================--
		cbc_i2c_cmd_rq_to_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
		--===============================================================================================--
		generic map (n => 2) 
		port map 
		(
			wrclk_i							=> wb_mosi_i(user_wb_be).wb_clk, 
			rdclk_i							=> tx_frame_clk, 
			wdata_i							=> cbc_i2c_cmd_rq_to_resync(i_fe-1),
			rdata_o							=> cbc_i2c_cmd_rq(i_fe-1)
		); 
		--===============================================================================================--
	end generate;
	--===============================================================================================--		--


		--===============================================================================================--
		COMMISSIONNING_MODE_RQ_to_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
		--===============================================================================================--
		generic map (n => 1) 
		port map 
		(
			wrclk_i							=> wb_mosi_i(user_wb_be).wb_clk, 
			rdclk_i							=> tx_frame_clk, 
			wdata_i(0)						=> COMMISSIONNING_MODE_RQ_to_resync,
			rdata_o(0)						=> COMMISSIONNING_MODE_RQ
		); 
		--===============================================================================================--


	
	--new
   -- Control:	
	cbc_t1_trigger_ipbus_user					<= user_be_regs_from_wb(9)(0);
	--
	cbc_hard_reset(0)								<= user_be_regs_from_wb(9)(1);
	cbc_i2c_refresh(0)							<= user_be_regs_from_wb(9)(2);
--	cbc_test_pulse(0)								<= user_be_regs_from_wb(9)(3);
--	cbc_fast_reset(0)								<= user_be_regs_from_wb(9)(4);
	cbc_fast_reset_ipbusCtrl(0)				<= user_be_regs_from_wb(9)(4);
--	--===============================================================================================--
--	fast_reset_0_to_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
--	--===============================================================================================--
--	generic map (n => 1) 
--	port map 
--	(
--		wrclk_i							=> wb_mosi_i(user_wb_be).wb_clk, 
--		rdclk_i							=> tx_frame_clk, 
--		wdata_i(0)						=> user_be_regs_from_wb(9)(4),
--		rdata_o(0)						=> cbc_fast_reset_ipbusCtrl(0)
--	); 
--	--===============================================================================================--



	--
	--cbc_i2c_cmd_rq(0) 							<= user_be_regs_from_wb(9)(6 downto 5);
	cbc_i2c_cmd_rq_to_resync(0)				<= user_be_regs_from_wb(9)(6 downto 5);	
	
	--
	CBC_STUBDATA_LATENCY_ADJUST(0)			<= user_be_regs_from_wb(9)(13 downto 7);	
	--
	--
--	cbc_hard_reset(1)								<= cbc_hard_reset(0);--user_be_regs_from_wb(9)(14);
--	cbc_i2c_refresh(1)							<= cbc_i2c_refresh(0);--user_be_regs_from_wb(9)(15);
----	cbc_test_pulse(1)								<= user_be_regs_from_wb(9)(16);
----	cbc_fast_reset(1)								<= user_be_regs_from_wb(9)(17);
--	cbc_fast_reset_ipbusCtrl(1)				<= user_be_regs_from_wb(9)(17);
--	--===============================================================================================--
--	fast_reset_1_to_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
--	--===============================================================================================--
--	generic map (n => 1) 
--	port map 
--	(
--		wrclk_i							=> wb_mosi_i(user_wb_be).wb_clk, 
--		rdclk_i							=> tx_frame_clk, 
--		wdata_i(0)						=> user_be_regs_from_wb(9)(17),
--		rdata_o(0)						=> cbc_fast_reset_ipbusCtrl(1)
--	); 
--	--===============================================================================================--




	--
	--cbc_i2c_cmd_rq(1) 							<= cbc_i2c_cmd_rq(0); --user_be_regs_from_wb(9)(19 downto 18);
--	cbc_i2c_cmd_rq_to_resync(1) 				<= user_be_regs_from_wb(9)(19 downto 18);
--	cbc_i2c_cmd_rq_to_resync(1) 				<= cbc_i2c_cmd_rq_to_resync(0); --user_be_regs_from_wb(9)(19 downto 18);
	
	--
--	CBC_STUBDATA_LATENCY_ADJUST(1)			<= user_be_regs_from_wb(9)(26 downto 20);	

	--new 
   -- Control:	cbonnin
	control_setup1  								<= user_be_regs_from_wb(10);--12
	control_setup2  								<= user_be_regs_from_wb(11);--13

	--
	BREAK_TRIGGER											<= user_be_regs_from_wb(12)(0); --0 : NO / 1 : OK	
	--COMMISSIONNING MODE
	--	COMMISSIONNING_MODE_RQ								<= user_be_regs_from_wb(12)(1); 
	COMMISSIONNING_MODE_RQ_to_resync						<= user_be_regs_from_wb(12)(1);
	COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET 	<= user_be_regs_from_wb(12)(17 downto 2); --16b
	COMMISSIONNING_MODE_DELAY_AFTER_TEST_PULSE 	<= user_be_regs_from_wb(13)(15 downto 0); --16b
	COMMISSIONNING_MODE_DELAY_AFTER_L1A 			<= user_be_regs_from_wb(13)(31 downto 16); --16b
	COMMISSIONNING_MODE_LOOPS_NB 						<= user_be_regs_from_wb(14)(31 downto 0); --32b

	COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID     <= user_be_regs_from_wb(12)(18);
	
	COMMISSIONNING_MODE_CBC_FAST_RESET_VALID		<= user_be_regs_from_wb(12)(19);

	
--	-- Status:	
--	user_be_regs_to_wb(11)						<= cbc_i2c_param_word_o;
	--hard
	cbc_i2c_param_word_i 						<= std_logic_vector(to_unsigned(15,32)); --user_be_regs_from_wb(10); --[4:0] = 15 by def	




   --===================--
   -- resync gbt_RxData --
   --===================--
	i_NUM_GBT_LINK_resync_gbt_RxData_gen : for i_NUM_GBT_LINK in 1 to NUM_GBT_LINK generate
		--===============================================================================================--
		from_gbt_Rx_data_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
		--===============================================================================================--
		generic map (n => 84) 
		port map 
		(
			wrclk_i							=> rxFrameClk_from_gbtRefDesign(i_NUM_GBT_LINK-1),
			rdclk_i							=> tx_frame_clk, 
			wdata_i							=> rxCommonData_from_gbtRefDesign(i_NUM_GBT_LINK-1),
			rdata_o							=> from_gbtRx_data_resync(i_NUM_GBT_LINK-1)
		); 
		--===============================================================================================--
	end generate;


   --===================--
   -- Chipscope --
   --===================--
	
	CLK_ILA_TEST <= tx_frame_clk; --tdc_counter_clk; --tx_frame_clk; --common clock (TX/RX)

	--===============================================================================================--
	icon_ctrl: entity work.icon_OneCtrl
	--===============================================================================================--
		port map (	CONTROL0 	=> CONTROL0
					);
	--===============================================================================================--
	

	--===============================================================================================--
   ila_ctrl_io: entity work.ila_TenTrig1b    
 	--===============================================================================================--
	port map (     
         CONTROL                                => CONTROL0,
         CLK                                    => CLK_ILA_TEST,
         TRIG0                                  => ILA_TRIG0,
         TRIG1                                  => ILA_TRIG1,
         TRIG2                                  => ILA_TRIG2,
         TRIG3                                  => ILA_TRIG3,
         TRIG4                                  => ILA_TRIG4,
         TRIG5                                  => ILA_TRIG5,
         TRIG6                                  => ILA_TRIG6,
         TRIG7                                  => ILA_TRIG7,
         TRIG8                                  => ILA_TRIG8,
         TRIG9                                  => ILA_TRIG9			
      );  
	--===============================================================================================--



	
	--===============================================================================================--
	process	
	--===============================================================================================--
	begin
	wait until rising_edge(CLK_ILA_TEST);
		ILA_TRIG0(0)  	<= cbc_t1_trigger(0);
		ILA_TRIG1(0)  	<= cbc_rcv_frame_in(0,0);
		ILA_TRIG2(0)  	<= cbc_rcv_frame_in(0,1);
		ILA_TRIG3(0)  	<= cbc_rcv_frame_in(0,2);
		ILA_TRIG4(0)  	<= cbc_rcv_frame_in(0,3);
		ILA_TRIG5(0)  	<= cbc_rcv_frame_in(0,4);
		ILA_TRIG6(0)  	<= cbc_rcv_frame_in(0,5);
		ILA_TRIG7(0)  	<= cbc_rcv_frame_in(0,6);	
		ILA_TRIG8(0)  	<= cbc_rcv_frame_in(0,7);	
		ILA_TRIG9(0)  	<= cbc_rcv_capture_out(0,0);
	end process;
	--===============================================================================================--	


	--fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(32) <= CLK_ILA_TEST;				
				
						
			
						
						
   -- On-board LEDs:             
   -----------------
   
   -- Comment: * USER_V6_LED_O(1) -> LD5 on GLIB. 
   --          * USER_V6_LED_O(2) -> LD4 on GLIB.       
   
   USER_V6_LED_O(1)                             <= userCdceLocked_r;          
   USER_V6_LED_O(2)                             <= mgtReady_from_gbtRefDesign(0);
   
	
	
	
	
   --===========--
   -- SMA scope --
   --===========--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope. 
  
   -- Comment: FPGA_CLKOUT corresponds to SMA1 on GLIB.     
         
--   FPGA_CLKOUT_O                                <= tx_frame_clk when FPGA_CLKOUT_MUXSEL = '0'
--                                                   else cbc_t1_trigger(0); --rxFrameClk_from_gbtRefDesign(0);





	process(	FPGA_CLKOUT_MUXSEL_NEW, tx_frame_clk, l1accept_resync_del, cbc_rcv_frame_in, cbc_t1_trigger, cbc_rcv_data_en, 
				cbc_rcv_capture_out, cbc_rcv_data_selected_en, L1A_VALID
				)
	begin
		case to_integer(unsigned(FPGA_CLKOUT_MUXSEL_NEW)) is --5b
			when 0 =>
				FPGA_CLKOUT_O <= cbc_fabric_sda_i(0) ; ---l1accept_resync_del(1); --tx_frame_clk;
			when 1 =>
				FPGA_CLKOUT_O <= cbc_rcv_frame_in(0,0);			
			when 2 =>
				FPGA_CLKOUT_O <= cbc_t1_trigger(0);
			when 3 =>
				FPGA_CLKOUT_O <= cbc_rcv_data_en(0,0);	
			when 4 =>
				FPGA_CLKOUT_O <= cbc_rcv_capture_out(0,0);
			when 5 =>
				FPGA_CLKOUT_O <= cbc_rcv_data_selected_en(0,0);
			when 6 =>
				FPGA_CLKOUT_O <= L1A_VALID;		
			when others =>
				FPGA_CLKOUT_O <= tx_frame_clk;
		end case;
	end process; 


--
--	process(	FPGA_CLKOUT_MUXSEL_NEW, tx_frame_clk, tlu_trigger_i, 
--				tlu_trigger_del, cbc_t1_trigger(0), cbc_t1_trigger(1), 
--				tlu_busy_o,
--				cbc_fast_reset(0),cbc_fast_reset(1),
--				cbc_test_pulse(0),cbc_test_pulse(1),
--				TDC_COUNTER_FIFO_WR_EN,
--				fifo2_busy,
--				CBC_user_sram_write_cycle,
--				TIME_TRIGGER_FIFO_EMPTY,
--				CBC_DATA_FIFO_EMPTY,
--				CBC_COUNTER_FIFO_EMPTY,
--				CBC_STUBDATA_FIFO_EMPTY,
--				TDC_COUNTER_FIFO_EMPTY,
--				ALL_FIFOS_ARE_EMPTY,
--				ALL_FIFOS_ARE_NOT_EMPTY
--				)
--	begin
--		case to_integer(unsigned(FPGA_CLKOUT_MUXSEL_NEW)) is --5b
--			when 0 =>
--				FPGA_CLKOUT_O <= tx_frame_clk;
--			when 1 =>
--				FPGA_CLKOUT_O <= tlu_trigger_i;
--			when 2 =>
--				FPGA_CLKOUT_O <= tlu_trigger_del(0);	
--			when 3 =>
--				FPGA_CLKOUT_O <= tlu_trigger_del(1);
--			when 4 =>
--				FPGA_CLKOUT_O <= tlu_trigger_del(2);
--			when 5 =>
--				FPGA_CLKOUT_O <= L1A_VALID;
--			when 6 =>
--				FPGA_CLKOUT_O <= L1A_VALID_del1;				
--			when 7 =>
--				FPGA_CLKOUT_O <= cbc_t1_trigger(0);	
--			when 8 =>
--				FPGA_CLKOUT_O <= cbc_t1_trigger(0); --cbc_t1_trigger(1);					
--			when 9 =>
--				FPGA_CLKOUT_O <= tlu_busy_o;	
--			when 10 =>
--				FPGA_CLKOUT_O <= cbc_fast_reset(0);	
--			when 11 =>
--				FPGA_CLKOUT_O <= cbc_fast_reset(0);--cbc_fast_reset(1);	
--			when 12 =>
--				FPGA_CLKOUT_O <= cbc_test_pulse(0);	
--			when 13 =>
--				FPGA_CLKOUT_O <= cbc_test_pulse(0);--cbc_test_pulse(1);					
--			when 14 =>
--				FPGA_CLKOUT_O <= TDC_COUNTER_FIFO_WR_EN;	 
--			when 15 =>
--				FPGA_CLKOUT_O <= fifo2_busy;	
--			when 16 =>
--				FPGA_CLKOUT_O <= CBC_user_sram_write_cycle(sram1);	
--			when 17 =>
--				FPGA_CLKOUT_O <= CBC_user_sram_write_cycle(sram2);				
--			when 18 =>
--				FPGA_CLKOUT_O <= TIME_TRIGGER_FIFO_EMPTY;	
--			when 19 =>
--				FPGA_CLKOUT_O <= CBC_DATA_FIFO_EMPTY(0,0);
--			when 20 =>
--				FPGA_CLKOUT_O <= CBC_DATA_FIFO_EMPTY(0,1);
--			when 21 =>
--				FPGA_CLKOUT_O <= CBC_COUNTER_FIFO_EMPTY(0,0);
--			when 22 =>
--				FPGA_CLKOUT_O <= CBC_COUNTER_FIFO_EMPTY(0,1);
--			when 23 =>
--				FPGA_CLKOUT_O <= CBC_STUBDATA_FIFO_EMPTY(0);	
--			when 24 =>
--				FPGA_CLKOUT_O <= TDC_COUNTER_FIFO_EMPTY;
--			when 25 =>
--				FPGA_CLKOUT_O <= ALL_FIFOS_ARE_EMPTY;
--			when 26 =>
--				FPGA_CLKOUT_O <= ALL_FIFOS_ARE_NOT_EMPTY;				
--			when others =>
--				FPGA_CLKOUT_O <= tx_frame_clk;
--		end case;
--	end process; 
 
   --=====================================================================================-- 
	



   --========================----
   -- STARTUP : BE_FE_SyncTest --
   --========================----	

	--===============================================================================================--
	BE_FE_SyncOTest: entity work.BE_FE_SyncTest 
	--===============================================================================================--
	GENERIC MAP (
					COMMON_STATIC_PATTERN    		=> COMMON_STATIC_PATTERN --x"0000BABEAC1DACDCFFFFF"	--used for SyncTest
				)
	PORT MAP(
					GENERAL_RESET_I 					=> reset_from_user,
					CLK_I 								=> tx_frame_clk,
					TEST_PATTERN_SEL_I 				=> testPatterSel_from_user,
					sfp_presence_i 					=> '1', --by def
					MGT_READY_I 						=> mgtReady_from_gbtRefDesign(0),
					RX_WORD_CLK_ALIGNED_I 			=> rxWordClkAligned_from_gbtRefDesign(0),
					RX_FRAME_CLK_ALIGNED_I 			=> rxFrameClkAligned_from_gbtRefDesign(0),
					GBT_RX_READY_I 					=> rxGbtReady_from_gbtRefDesign(0),
					RESYNC_DELAY 						=> BE_FE_RESYNC_DELAY,
					SYNC_TEST_DELAY 					=> BE_FE_SYNC_TEST_DELAY,
					resyncWait_i						=> resyncWait_from_user,
					BE_FE_syncTest_done_o 			=> BE_FE_syncTest_done,
					BE_FE_syncTest_result_o 		=> BE_FE_syncTest_result,
					BE_FE_syncTest_ErrorSeen_o		=> BE_FE_syncTest_ErrorSeen,
					from_gbtRx_data_i 				=> from_gbtRx_data_resync(0)
	);	
	--===============================================================================================--	

--	process
--	begin
--	wait until rising_edge(tx_frame_clk);
--		if reset_from_user = '1' then
--			
--		if BE_FE_syncTest_done = '1' then
--			if 	BE_FE_syncTest_result = SYNC_TEST_GOOD then
--				patternGeneEnable = '0'; --DIS
--			elsif BE_FE_syncTest_result = SYNC_TEST_FAIL then
--				patternGeneEnable = '0'; --DIS


--	gbt_data_interface_int: entity work.gbt_data_interface 
--	PORT MAP(	common_frame_clk_i 			=> tx_frame_clk,
--					reset_from_user_i 			=> reset_from_or_gate,--reset_from_user,
--					--SW
--					rq_cmd_from_sw 				=> rq_cmd_from_sw,
--					gbt_sram_wordNb 				=> gbt_sram_wordNb,
--					SRAM_RdLatency 				=> SRAM_RdLatency,
--					rq_ack_from_be 				=> rq_ack_from_be,
--					--
--					from_gbtRx_data_i 			=> from_gbtRx_data_resync,
--					to_gbtTx_data_o 				=> to_gbtTx_from_gbtDataInterface, --to_gbtTx_from_user,
--					--			
--					gbt_sram_control_o 			=> gbt_sram_control,
--					gbt_sram_addr_o 				=> gbt_sram_addr,
--					gbt_sram_rdata_i 				=> user_sram_rdata_i,
--					gbt_sram_wdata_o 				=> gbt_sram_wdata					
--	);






	--===============--
   -- CBC INTERFACE --
   --===============--
	--comment: CBCv1 on FMC2 !! - see 


   -- I2C CONTROLLER:             
   ------------------
	--cbc_i2c_phy_ctrl_reset										--or cbc_hard_reset_all or remove it
	cbc_i2c_phy_ctrl_reset 			<= reset_from_or_gate or cbc_hard_reset(0) or cbc_i2c_phy_ctrl_reset_from_user;


--	--lcharles : modif 01/04/14

	--MUX serial lines :  version 1
	i_fe_GEN : for i_fe in 0 to FE_NB-1 generate
		--
		process (cbc_i2c_param_word_fePart, cbc_i2c_access_busy)
		begin
			--SCL & SDA_o
			if to_integer(unsigned(cbc_i2c_param_word_fePart)) = i_fe and cbc_i2c_access_busy = '1' then
				cbc_fabric_scl_o(i_fe)	<= cbc_fabric_scl_o_tmp;
				cbc_fabric_sda_o(i_fe)	<= cbc_fabric_sda_o_tmp;
			else
				cbc_fabric_scl_o(i_fe)	<= '1';
				cbc_fabric_sda_o(i_fe)	<= '1';
			end if;	
		end process;
		--
	end generate;	
	
	cbc_fabric_sda_i_tmp		<= cbc_fabric_sda_i(to_integer(unsigned(cbc_i2c_param_word_fePart)));


--	--MUX serial lines :  version 2
--	process (cbc_i2c_param_word_fePart, cbc_i2c_access_busy)
--	begin
--		--SCL & SDA_o
--		if 	to_integer(unsigned(cbc_i2c_param_word_fePart)) = 0 and cbc_i2c_access_busy = '1' then
--			cbc_fabric_scl_o(0)		<= cbc_fabric_scl_o_tmp;
--			cbc_fabric_sda_o(0)		<= cbc_fabric_sda_o_tmp;				
--			cbc_fabric_sda_i_tmp		<= cbc_fabric_sda_i(0);
--			--
--			cbc_fabric_scl_o(1)		<= '1';
--			cbc_fabric_sda_o(1)		<= '1';					
--		elsif to_integer(unsigned(cbc_i2c_param_word_fePart)) = 1 and cbc_i2c_access_busy = '1' then
--			cbc_fabric_scl_o(1)		<= cbc_fabric_scl_o_tmp;
--			cbc_fabric_sda_o(1)		<= cbc_fabric_sda_o_tmp;				
--			cbc_fabric_sda_i_tmp		<= cbc_fabric_sda_i(1);
--			--
--			cbc_fabric_scl_o(0)		<= '1';
--			cbc_fabric_sda_o(0)		<= '1';	
--		else
--			cbc_fabric_scl_o(0)		<= '1';
--			cbc_fabric_sda_o(0)		<= '1';					
--			cbc_fabric_scl_o(1)		<= '1';
--			cbc_fabric_sda_o(1)		<= '1';
--			cbc_fabric_sda_i_tmp		<= '1';
--		end if;
--	end process;
	
	
	
	--===============================================================================================--
	cbc_i2c_fe2: entity work.i2c_master_no_iobuf_lvds --i2c_master_no_iobuf --I2C interface
	--===============================================================================================--
	port map
	(
		reset						=> cbc_i2c_phy_ctrl_reset, --reset_from_or_gate,--wb_mosi_i(user_wb_fe).wb_rst,
		clk						=> tx_frame_clk,	--wb_mosi_i(user_wb_fe).wb_clk, --wb_mosi_i(user_wb_fe).wb_clk, 62.5M
		------------------------------
		settings					=> cbc_ctrl_i2c_settings(12 downto 0),
		command					=> cbc_ctrl_i2c_command, 			-- cbc_ctrl_i2c_command[31:28] clears automatically
		reply						=> cbc_ctrl_i2c_reply,
		busy						=> open,
		done						=> cbc_ctrl_i2c_done,
		------------------------------
		scl_i(0)					=> 'Z',							
		scl_i(1)					=> 'Z',
		--
		scl_o(0)					=> cbc_fabric_scl_o_tmp,			
		scl_o(1)					=> open,
		scl_oe_l(0)				=> open,	
		scl_oe_l(1)				=> open,
		--
		sda_i(0)					=> cbc_fabric_sda_i_tmp,			
		sda_i(1)					=> 'Z',
		--
		sda_o(0)					=> cbc_fabric_sda_o_tmp,			
		sda_o(1)					=> open,
		sda_oe_l(0)				=> open,	
		sda_oe_l(1)				=> open
	); 
	--===============================================================================================--

	--===============================================================================================--
	cbc_i2c_updating_ctrl_inst: entity work.cbc_i2c_updating_ctrl_v3 --v3 v4
	--===============================================================================================--
	PORT MAP(	--===============--
					-- GENERAL --
					--===============--	
					clk 									=> tx_frame_clk,			--wb_mosi_i(0).wb_clk,
					sclr_i 								=> reset_from_or_gate,	--wb_mosi_i(0).wb_rst,
					--===========--
					-- CBC RESET --
					--===========--					    ---set cbc_hard_reset_all
					cbc_hard_reset_i 					=> cbc_hard_reset(0), --cbc_i2c_phy_ctrl_reset, 	--cbc_hard_reset(1),
					cbc_fast_reset_i 					=> cbc_fast_reset(0), --just one for sw
					--===============--
					-- SW INTERFCACE --
					--===============--						
					cbc_i2c_cmd_rq_i 					=> cbc_i2c_cmd_rq(0),
					cbc_i2c_cmd_ack_o 				=> cbc_i2c_cmd_ack(0),
					--==============--
					-- I2C_PHY_CTRL --
					--==============--					
					cbc_ctrl_i2c_reply_i 			=> cbc_ctrl_i2c_reply,
					cbc_ctrl_i2c_done_i 				=> cbc_ctrl_i2c_done,
					cbc_ctrl_i2c_settings_o 		=> cbc_ctrl_i2c_settings,
					cbc_ctrl_i2c_command_o 			=> cbc_ctrl_i2c_command,
					cbc_i2c_phy_ctrl_reset_o		=> cbc_i2c_phy_ctrl_reset_from_user,
					--================--
					-- SRAM INTERFACE --
					--================--					
					cbc_i2c_user_sram_control_o 	=> cbc_i2c_user_sram_control(sram1),
					cbc_i2c_user_sram_addr_o		=> cbc_i2c_user_sram_addr(sram1),
					cbc_i2c_user_sram_rdata_i 		=> user_sram_rdata_i(sram1), --cbc_i2c_user_sram_rdata,
					cbc_i2c_user_sram_wdata_o 		=> cbc_i2c_user_sram_wdata(sram1),	
					--========--
					-- OTHERS --
					--========--						
					sram_read_latency_i 				=> "01111", --15 by def
					cbc_i2c_access_busy_o 			=> cbc_i2c_access_busy,
					cbc_i2c_param_word_fePart_o 	=> cbc_i2c_param_word_fePart,
					cbc_i2c_param_word_o 			=> open
					
			);
	--===============================================================================================--	







	--========================--
   -- TTC_FMC_v3 on J1= FMC2 --
   --========================--

	--===============================================================================================--
	ttcrx: entity work.cdr2ttc --cdr interface
	--===============================================================================================--
	port map
	(
		-- adn2814 cdr interface
		ttc_los 				=> cdr_los,
		ttc_lol 				=> cdr_lol,
		cdrclk_in			=> cdr_clk, --no bufg
		cdrdata_in 			=> cdr_data,
		--
		PC_config_ok 		=> '1',--inactive
		CLK_OUT_MUX_SEL 	=> '0', --CLK_DEPHASING,
		--
		cdrclk_locked		=> cdr_clk_locked,
		cdrclk_out			=> cdr_clk_160M_0, 
		cdrclk_div     	=> cdr_clk_40M_0_180,--BC_CLK, --160.316/4 =~ 40M...with bufg + mux
		cdrclk_div_40M_0 	=> open, --cdr_clk_40M_0,		
		--
		-- controls latency of l1a, broadcasr signals etc
		coarse_delay		=> "0000", 
		-- clock divider sy89872 div4/div2 control
		div4 					=> divider_div4,
		-- clock divider sy89872 async reset control, used to align the phase of 40mhz clock divider output relative to ttcdata_p(n)
		div_nrst 			=> divider_rst_b,
		-- ttc output signals
		ttcclk 				=> ttcclk,
		l1accept 			=> l1accept,
		bcntres 				=> bcntres,
		evcntres 			=> evcntres,
		sinerrstr 			=> sinerrstr,
		dberrstr 			=> dberrstr,
		brcststr 			=> brcststr,
		brcst					=> brcst
	);
	--===============================================================================================--




	--===============================================================================================--
	-- Register mapping
	--===============================================================================================--
	ttc_fmc_xpoint_4x4_s10		<= '0';--ttc_fmc_reg_ctrl(16); 	-- default S10=0, S11=1: in2 -> out1 (clk_40 -> tp R13)
	ttc_fmc_xpoint_4x4_s11		<= '1';--ttc_fmc_reg_ctrl(17); 
	ttc_fmc_xpoint_4x4_s20		<= '1';--ttc_fmc_reg_ctrl(18); 	-- default S20=0, S21=1: in2 -> out2 (clk_40 -> cdce_pri_clk)
	ttc_fmc_xpoint_4x4_s21		<= '1';--ttc_fmc_reg_ctrl(19);
	ttc_fmc_xpoint_4x4_s30		<= '1';--ttc_fmc_reg_ctrl(20); 	-- default S30=1, S31=1: in4 -> out3 (clk160 -> fmc_clk1_m2c)
	ttc_fmc_xpoint_4x4_s31		<= '1';--ttc_fmc_reg_ctrl(21); 
	ttc_fmc_xpoint_4x4_s40		<= '0';--ttc_fmc_reg_ctrl(22); 	-- default S40=0, S41=1: in2 -> out4 (clk_40 -> fmc_clk0_m2c)
	--ttc_fmc_xpoint_4x4_s41		<= ttc_fmc_reg_ctrl(23);

--	ttc_fmc_reg_status(29)		<= cdr_lol;
--	ttc_fmc_reg_status(30)		<= cdr_los;
--	ttc_fmc_reg_status(31)		<= cdr_clk_locked;
	--===============================================================================================--
	
	
	--===============================================================================================--
	-- TTC_FMC IO mapping / J1 = FMC2 	--===============================================================================================--
	--cdr_data 										<= 	fmc_from_pin_to_fabric_array.la_lvds(fmc2_j1)9)		;
	cdr_data 										<= 	fmc_from_pin_to_fabric_array(fmc2_j1).la_lvds(9)		;	
	lemo_lm2											<= 	fmc_from_pin_to_fabric_array(fmc2_j1).la_lvds(6)		;
	--fabric_sda_i									<= 	fmc_from_pin_to_fabric_array(fmc2_j1).la_cmos_n(7)	;	-- I/O
	cdr_lol 											<= 	fmc_from_pin_to_fabric_array(fmc2_j1).la_cmos_p(8)	;
	cdr_los 											<= 	fmc_from_pin_to_fabric_array(fmc2_j1).la_cmos_n(8)	;
	
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(0)	<= ttc_fmc_xpoint_4x4_s10; 	--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(0) <= '0';
	--fmc_from_fabric_to_pin(fmc2_j1).la_cmos_n(0)	<= ttc_fmc_xpoint_4x4_s41; 	--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(0) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(2)	<= ttc_fmc_xpoint_4x4_s11; 	--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(2) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(2)	<= ttc_fmc_xpoint_4x4_s20; 	--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(2) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(3)	<= ttc_fmc_xpoint_4x4_s21; 	--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(3) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(3)	<= ttc_fmc_xpoint_4x4_s40; 	--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(3) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(4)	<= ttc_fmc_xpoint_4x4_s30; 	--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(4) <= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(4)	<= ttc_fmc_xpoint_4x4_s31; 	--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(4) <= '0';
	--s41 modified

--	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(7)	<= fabric_scl_o;					--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(7)	<= fabric_scl_oe_l; 
--	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(7)	<= fabric_sda_o;					--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(7)	<= fabric_sda_oe_l; --I/O 
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(7)	<= '1';								--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(7)	<= '1'; --DIS
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(7)	<= '1';								--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(7)	<= '1'; --DIS
	--
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(10)	<= divider_rst_b;					--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(10)<= '0';
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(10)	<= divider_div4 ;					--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(10)<= '0';
	
	--new : 3DE & 2DE
	ttc3_3DE <= '1';--ttc_fmc_regs_from_wb(19)(4); --'1'; --param
	ttc3_2DE <= '1';--ttc_fmc_regs_from_wb(19)(5); --'1'; --param; 
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(0)	<= ttc3_3DE;						--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(0)	<= '0'; 	
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p(1)	<= ttc3_2DE;						--fmc2_from_fabric_to_pin.la_cmos_p_oe_l(1)	<= '0'; 	

	--new : user_led ctrl
	ttc3_user_led_n <= '0'; --ttc_fmc_regs_from_wb(19)(6); --'1'; --param '0'; --en if '0'
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n(5)	<= ttc3_user_led_n;				--fmc2_from_fabric_to_pin.la_cmos_n_oe_l(5)	<= '0'; 	
	--===============================================================================================--	
	---------------******************************END TTC_FMC**********************************----------------








	--=============--
   -- CBC TRIGGER --
   --=============--
	
	---------------********************************TRIGGER************************************----------------
	--===============================================================================================--
	process --internal trigger
	--===============================================================================================--	
	variable int_trigger_counter : integer range 0 to 40e6:=0; 
	begin
		wait until rising_edge(tx_frame_clk); --40M
			--if PC_config_ok = '0' or int_trigger = '1' then
			if reset_from_or_gate = '1' or int_trigger = '1' then
				int_trigger_counter := 0;
				int_trigger 	<= '0';
			else
				int_trigger_counter := int_trigger_counter + 1;
					if 	unsigned(INT_TRIGGER_FREQ_SEL) = 0 		and int_trigger_counter = 40e6  		then 	int_trigger <= '1'; --1Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 1 		and int_trigger_counter = 20e6  		then 	int_trigger <= '1'; --2Hz 
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 2 		and int_trigger_counter = 10e6  		then 	int_trigger <= '1'; --4Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 3 		and int_trigger_counter = 5e6  		then 	int_trigger <= '1'; --8Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 4 		and int_trigger_counter = 2500000  	then 	int_trigger <= '1'; --16Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 5 		and int_trigger_counter = 1250000 	then 	int_trigger <= '1'; --32Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 6 		and int_trigger_counter = 625000		then 	int_trigger <= '1'; --64Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 7 		and int_trigger_counter = 312500		then 	int_trigger <= '1'; --128Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 8 		and int_trigger_counter = 156250		then 	int_trigger <= '1'; --256Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 9 		and int_trigger_counter = 78125		then 	int_trigger <= '1'; --512Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 10 	and int_trigger_counter = 39062  	then 	int_trigger <= '1'; --1024Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 11 	and int_trigger_counter = 19531  	then 	int_trigger <= '1'; --2048Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 12 	and int_trigger_counter = 9766  		then 	int_trigger <= '1'; --4096Hz	
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 13 	and int_trigger_counter = 4883  		then 	int_trigger <= '1'; --8192Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 14 	and int_trigger_counter = 2441  		then 	int_trigger <= '1'; --16384Hz
					elsif unsigned(INT_TRIGGER_FREQ_SEL) = 15 	and int_trigger_counter = 1221  		then 	int_trigger <= '1'; --32768Hz					
					else 																								
						int_trigger <= '0';
					end if; 
			end if;
	end process;			
	--===============================================================================================--				
	



	
   -- CBC_T1_TRIGGER:	
   -----------------
	--comment: from L1A_VALID
	--===============================================================================================--
	i_fe_cbc_t1_trigger_gen : for i_fe in 1 to FE_NB generate	
	--===============================================================================================--
		cbc_t1_trigger(i_fe-1) <= L1A_VALID ;
	end generate;
	--===============================================================================================--	
	
	
	
	
--	--===============--
--   -- CBC DC-DC GENE--
--   --===============--
--   --comment: 1MHz from 40MHz             
--	
	--===============================================================================================--
	process -- 1MHz generation for DC-DC on CBC
	--===============================================================================================--
	constant freqInVal 		: natural 									:= 40; 
	constant div_counter 	: natural 									:= freqInVal/2-1; 
	variable counter 			: integer range 0 to div_counter		:= div_counter; 
	variable clock_1MHz 		: std_logic 								:= '0';
		begin
			wait until rising_edge(tx_frame_clk); 
				if counter = 0 then
					clock_1MHz := not clock_1MHz;
					counter := div_counter;
				else
					counter := counter - 1;
				end if;
				cbc_clk_dcdc(0) <= clock_1MHz;
	end process;
	--===============================================================================================--




--		--1 : Dual CBC2 = 2xCBC2
--			--1) I2C I/O:             
--			-------------			
--			--IN
--			-->SDA_IN : SDA_FROM_CBC	
--			cbc_fabric_sda_i(0) 												<= NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(29);
--			--OUT
--			-->SCL_OUT : SCLK_2V5
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(31) 		<= NEGATIVE_POLARITY_CBC xor cbc_fabric_scl_o(0);
--			-->SDA_OUT : SDA_TO_CBC
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(28) 		<= NEGATIVE_POLARITY_CBC xor cbc_fabric_sda_o(0);
--		
--		
--			--2) OTHERS I/O:             
--			----------------	
--			--IN
--			-->TRIGDATA (LVDS)
--			--A
--			cbc_trigdata(0,0)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(7);
--			--B
--			cbc_trigdata(0,1)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(0);
--			-->STUBDATA (LVDS)
--				--correc 27Nov2013
--				--		"lvds", "in__", "in__",		--FMC2_LA16		-- TRIGGER_CBC2_A_LVDS
--				--		"lvds", "in__", "in__",		--FMC2_LA04		-- TRIGGER_CBC2_B_LVDS	
--			--A
--			cbc_stubdata(0,0)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(16);			
--			--B
--			cbc_stubdata(0,1)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(4);					
--			--OUT
--			-->CLKIN_40_LVDS 
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(24)		<= tx_frame_clk;	
--			-->T1_TRIGGER (LVDS) 
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(15)		<= NEGATIVE_POLARITY_CBC xor cbc_t1_trigger(0);			
--			-->CLK_DCDC_LVDS
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(25)		<= cbc_clk_dcdc(0); --'0'; --'L'; --cbc_clk_dcdc;	--towards DC-DC converter
--			-->RESET_2V5
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(30)		<= NEGATIVE_POLARITY_CBC xor cbc_hard_reset(0);		
--			-->cbc_i2c_refresh (LVDS) 
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(21)		<= NEGATIVE_POLARITY_CBC xor cbc_i2c_refresh(0);		
--			-->cbc_test_pulse (LVDS)
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(19)		<= NEGATIVE_POLARITY_CBC xor cbc_test_pulse(0);	
--			-->cbc_fast_reset (LVDS)
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(20)		<= NEGATIVE_POLARITY_CBC xor cbc_fast_reset(0); --used to be the rst_101 in CBC1			
--		
--			--decomment if ised bufio_bidir
----			--others / fake reg val <=> connected to a logical net and not '0' (INIT reg val = '0')
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(0 to 14) 		<= user_be_regs_from_wb(30)(14 downto 0); 
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(16 to 18) 		<= user_be_regs_from_wb(30)(17 downto 15);
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(22 to 23) 		<= user_be_regs_from_wb(30)(19 downto 18);	
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(26 to 27) 		<= user_be_regs_from_wb(30)(21 downto 20);
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(29) 				<= user_be_regs_from_wb(30)(22);
----			--fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(32 to 33) 		<= user_be_regs_from_wb(30)(24 downto 23);	
----			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(33) 				<= user_be_regs_from_wb(30)(24);


--		--2 : 8xCBC2 
--			cbc_fabric_sda_i(0) 												<= NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(14);
--			--OUT
--			-->SCL_OUT : SCLK_2V5
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(0) 		<= NEGATIVE_POLARITY_CBC xor cbc_fabric_scl_o(0);
--			-->SDA_OUT : SDA_TO_CBC
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(10) 		<= NEGATIVE_POLARITY_CBC xor cbc_fabric_sda_o(0);		


--			cbc_fabric_sda_i(0) 												<= not fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(14);
--			--OUT
--			-->SCL_OUT : SCLK_2V5
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(0) 		<= cbc_fabric_scl_o(0); 
--			-->SDA_OUT : SDA_TO_CBC
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(10) 		<= not cbc_fabric_sda_o(0);		
			
			cbc_fabric_sda_i(0) 												<= fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(14);
			--OUT
			-->SCL_OUT : SCLK_2V5
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(0) 		<= cbc_fabric_scl_o(0); 
			-->SDA_OUT : SDA_TO_CBC
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(10) 		<= not cbc_fabric_sda_o(0);
			
			--2) OTHERS I/O:             
			----------------	
			--IN
			-->TRIGDATA (LVDS)
			--0/A
			cbc_trigdata(0,0)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(12);
			--0/B
			cbc_trigdata(0,1)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(13);		
			--1/A
			cbc_trigdata(0,2)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(17);
			--1/B
			cbc_trigdata(0,3)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(19);			
			--2/A
			cbc_trigdata(0,4)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(24);
			--2/B
			cbc_trigdata(0,5)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(27);	
			--3/A
			cbc_trigdata(0,6)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(28);
			--3/B
			cbc_trigdata(0,7)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(32);	
			-->STUBDATA (LVDS)
			--0/A
			cbc_stubdata(0,0)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(9);			
			--0/B
			cbc_stubdata(0,1)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(11);
			--1/A
			cbc_stubdata(0,2)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(15);			
			--1/B
			cbc_stubdata(0,3)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(20);
			--2/A
			cbc_stubdata(0,4)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(22);			
			--2/B
			cbc_stubdata(0,5)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(21);
			--3/A
			cbc_stubdata(0,6)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(25);			
			--3/B
			cbc_stubdata(0,7)													<=	NEGATIVE_POLARITY_CBC xor fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds(29);

			--OUT
			-->CLKIN_40_LVDS 
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(2)		<= tx_frame_clk;	
			-->T1_TRIGGER (LVDS) 
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(8)		<= NEGATIVE_POLARITY_CBC xor cbc_t1_trigger(0);			
			-->CLK_DCDC_LVDS
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(4)		<= cbc_clk_dcdc(0); --'0'; --'L'; --cbc_clk_dcdc;	--towards DC-DC converter
			-->RESET_2V5
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(1)		<= NEGATIVE_POLARITY_CBC xor cbc_hard_reset(0);		
			-->cbc_i2c_refresh (LVDS) 
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(5)		<= NEGATIVE_POLARITY_CBC xor cbc_i2c_refresh(0);		
			-->cbc_test_pulse (LVDS)
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(6)		<= NEGATIVE_POLARITY_CBC xor cbc_test_pulse(0);	
			-->cbc_fast_reset (LVDS)
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(7)		<= NEGATIVE_POLARITY_CBC xor cbc_fast_reset(0); --used to be the rst_101 in CBC1	


--			--decomment if ised bufio_bidir
--			--others / fake reg val <=> connected to a logical net and not '0' (INIT reg val = '0')
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(3) 				<= user_be_regs_from_wb(30)(0); 
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(9) 				<= user_be_regs_from_wb(30)(0); 			
			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds(11 to 33) 		<= user_be_regs_from_wb(30)(22 downto 0); --23b

			
	
	
			


	

	
	process		
	begin
	wait until rising_edge(tx_frame_clk);
		if reset_from_or_gate = '1' then
			cbc_fast_reset_ipbusCtrlSpared_del1		<= '0';
			cbc_fast_reset_ipbusCtrlSpared_del2    <= '0';
			cbc_fast_reset_ipbusCtrlOnePulseSpared	<= '0';
		else
			cbc_fast_reset_ipbusCtrlSpared_del1  	<= cbc_fast_reset_ipbusCtrl(0);
			cbc_fast_reset_ipbusCtrlSpared_del2  	<= cbc_fast_reset_ipbusCtrlSpared_del1;
			cbc_fast_reset_ipbusCtrlOnePulseSpared	<= cbc_fast_reset_ipbusCtrlSpared_del1 and not cbc_fast_reset_ipbusCtrlSpared_del2;	
		end if;
	end process;


   --=====================--
   -- CBC_FAST_RESET CTRL --
   --=====================--
--	process
--	begin
--	wait until rising_edge (tx_frame_clk);
--		cbc_fast_reset(0) 	<= cbc_fast_reset_tmp(0) or cbc_fast_reset_ipbusCtrlOnePulse(0);
--		cbc_fast_reset(1) 	<= cbc_fast_reset_tmp(1) or cbc_fast_reset_ipbusCtrlOnePulse(1);
--	end process;


	--===============================================================================================--
	i_fe_cbc_fast_reset_loop : for i_fe in 1 to FE_NB generate	
	--===============================================================================================--
		process
		begin
		wait until rising_edge(tx_frame_clk);
			--cbc_fast_reset(i_fe-1) 	<= cbc_fast_reset_tmp(i_fe-1) or cbc_fast_reset_ipbusCtrlOnePulse(i_fe-1);
			cbc_fast_reset(i_fe-1) 	<= cbc_fast_reset_tmp(i_fe-1) or cbc_fast_reset_ipbusCtrlOnePulseSpared;
		end process;
	end generate;
	--===============================================================================================--


   --==================--
   -- TRIGGER DELAYING --
   --==================--
	
	--L1A_VALID_del1
	--===============================================================================================--
	process
	--===============================================================================================--
	begin
	wait until rising_edge(tx_frame_clk);
		L1A_VALID_del1 								<= L1A_VALID;
	end process;
	--===============================================================================================--	
	
	--FROM TLU
	--===============================================================================================--
	process
	--===============================================================================================--
	begin
	wait until rising_edge(tx_frame_clk);
		tlu_trigger_del(0) 							<= tlu_trigger_i; --tlu_trigger
		tlu_trigger_del(1)							<= tlu_trigger_del(0);
		tlu_trigger_del(2)							<= tlu_trigger_del(1);
	end process;
	--===============================================================================================--

	--FROM cdr2ttc
	--===============================================================================================--
	l1accept_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 1) 
	port map 
	(
		wrclk_i							=> cdr_clk_160M_0,
		rdclk_i							=> tx_frame_clk, 
		wdata_i(0)						=> l1accept, 
		rdata_o(0)						=> l1accept_resync
	); 
	--===============================================================================================--
	
	--===============================================================================================--
	process
	--===============================================================================================--
	begin
	wait until rising_edge(tx_frame_clk);
		l1accept_resync_del(0) 							<= l1accept_resync;
		l1accept_resync_del(1)							<= l1accept_resync_del(0);
	end process;
	--===============================================================================================--

   --==============================--
   -- COMMISSIONNING_MODE + TRIGGER--
   --==============================--	
	
	--===============================================================================================--
	commissionning_mode_fsm_block : block						
	type states is (	idle, s0,s0_veto,s1,s2,s3,s4,s5,s6
									);
	signal state : states;
	--===============================================================================================--
	begin
		--===============================================================================================--
		process
		--===============================================================================================--
		variable counter_delay 								: integer range 0 to 2**COMMISSIONNING_MODE_DELAY_BITS_NB - 1;
		--variable var_commissionning_mode_loops_nb		: integer range 0 to 2**(CBC_DATA_PACKET_NUMBER'left+1) - 1;
		--variable var_commissionning_mode_loops_nb		: integer range 0 to 4294967295;
		variable var_unsigned_commissionning_mode_loops_nb		: unsigned(31 downto 0);
		variable vetoCounter 								: integer range 0 to 7 := 2;
		begin
		wait until rising_edge (tx_frame_clk);
			
			--
			if PC_config_ok = '0' or cmd_start_valid = '0'  or BREAK_TRIGGER = '1' or fifo2_busy = '1' then	
				state 											<= idle;
				counter_delay									:= to_integer(unsigned(COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET));
				L1A_VALID 										<= '0';
				tlu_busy_o 										<= '1'; --tlu_trig DIS by def
				--var_commissionning_mode_loops_nb			:= to_integer(unsigned(CBC_DATA_PACKET_NUMBER));				
				--var_commissionning_mode_loops_nb			:= to_integer(unsigned(COMMISSIONNING_MODE_LOOPS_NB));
				var_unsigned_commissionning_mode_loops_nb	:= unsigned(COMMISSIONNING_MODE_LOOPS_NB);
				--
				cbc_fast_reset_tmp(0) 						<= '0'; --DIS
				--cbc_fast_reset_tmp(1) 						<= '0';
				--
				cbc_test_pulse(0) 							<= '0'; --DIS
				--cbc_test_pulse(1) 							<= '0';				
				
			--
			else 
				--
				case state is
					--
					when idle =>
						--
						if COMMISSIONNING_MODE_RQ = '1' then	
							state 								<= s1;
							--
							cbc_fast_reset_tmp(0) 			<= '0'; --DIS
							--cbc_fast_reset_tmp(1) 			<= '0';
							--
							cbc_test_pulse(0) 				<= '0'; --DIS
							--cbc_test_pulse(1) 				<= '0';								
						else --normal mode
							--
							cbc_fast_reset_tmp(0) 			<= '1'; --EN
							--cbc_fast_reset_tmp(1) 			<= '1';	
							--
							cbc_test_pulse(0) 				<= '0'; --DIS
							--cbc_test_pulse(1) 				<= '0';							
							state									<= s0;
						end if;
						--
						counter_delay							:= to_integer(unsigned(COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET));
						L1A_VALID 								<= '0';
						tlu_busy_o 								<= '1'; --tlu_trig DIS by def
						--var_commissionning_mode_loops_nb	:= to_integer(unsigned(CBC_DATA_PACKET_NUMBER));
						--var_commissionning_mode_loops_nb	:= to_integer(unsigned(COMMISSIONNING_MODE_LOOPS_NB));
						var_unsigned_commissionning_mode_loops_nb	:= unsigned(COMMISSIONNING_MODE_LOOPS_NB);
						--new
						vetoCounter 							:= 2;
					
					--
					when s0 =>  --normal mode
						--
						if TRIGGER_SEL = '0' then 		
							tlu_busy_o 							<= '1'; --tlu_trig DIS
							L1A_VALID 							<= int_trigger; --one pulse
							state									<= s0;
						else
							tlu_busy_o 							<= '0'; --tlu_trig EN
							--from tlu
							--L1A_VALID 							<= tlu_trigger_del(0) and not tlu_trigger_del(1); --one pulse / tlu_trigger
							--from cdr2ttc
							L1A_VALID 							<= l1accept_resync_del(0) and not l1accept_resync_del(1); --one pulse / cdr2ttc trigger
							--
							
							--
							vetoCounter 						:= 2;
--							--if tlu: decomment
--							if L1A_VALID = '1' then 
--								state 							<= s0_veto;
--							else
--								state 							<= s0;
--							end if;
--							--
						end if;
						--
						cbc_fast_reset_tmp(0) 				<= '0'; --DIS
						--cbc_fast_reset_tmp(1) 				<= '0';						
						
					--
					when s0_veto =>
						--
						if vetoCounter = 0 and tlu_trigger_del(0) = '0' then
							state 								<= s0;
							L1A_VALID							<= '0';
						elsif vetoCounter = 0 and tlu_trigger_del(0) = '1' then
							L1A_VALID							<= '0';
							state 								<= s0_veto;
						else
							L1A_VALID							<= '0';
							vetoCounter 						:= vetoCounter - 1;
							state 								<= s0_veto;
						end if;
						--
						
					--commissionning mode
					when s1 => --FAST RESET
						counter_delay							:= to_integer(unsigned(COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET));
						cbc_fast_reset_tmp(0) 				<= '1'; --COMMISSIONNING_MODE_CBC_FAST_RESET_VALID; --'1'; --EN
						--cbc_fast_reset_tmp(1) 				<= '1'; --COMMISSIONNING_MODE_CBC_FAST_RESET_VALID; --'1';
						state 									<= s2;

					--
					when s2 => 
						cbc_fast_reset_tmp(0) 				<= '0'; --DIS
						--cbc_fast_reset_tmp(1) 				<= '0';	
						--
						if counter_delay = 0 then
							state 								<= s3;
						else
							counter_delay						:= counter_delay - 1;
						end if;
						--	
					--
					when s3 => --TEST PULSE
						cbc_test_pulse(0) 					<= COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID; --EN
						--cbc_test_pulse(1) 					<= COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID;
						counter_delay							:= to_integer(unsigned(COMMISSIONNING_MODE_DELAY_AFTER_TEST_PULSE));						
						state 									<= s4;
					--
					when s4 => --L1A
						cbc_test_pulse(0) 					<= '0'; --DIS
						--cbc_test_pulse(1) 					<= '0';
						--
						if counter_delay = 0 then
							L1A_VALID 							<= '1'; --EN
							state 								<= s5;
							counter_delay						:= to_integer(unsigned(COMMISSIONNING_MODE_DELAY_AFTER_L1A));
						else
							counter_delay						:= counter_delay - 1;
						end if;
						--
					--
					when s5 =>
						L1A_VALID 								<= '0'; --DIS

						--
						if counter_delay = 0 then
							state 								<= s1;
						else
							counter_delay						:= counter_delay - 1;
						end if;
						--	

						--
--						if var_commissionning_mode_loops_nb = 0 then 
--							state <= s6;
--						else
--							var_commissionning_mode_loops_nb := var_commissionning_mode_loops_nb - 1;
--							state <= s1;
--						end if;
--						if var_unsigned_commissionning_mode_loops_nb = 0 then 
--							state <= s6;
--						else
--							var_unsigned_commissionning_mode_loops_nb := var_unsigned_commissionning_mode_loops_nb - "01";
--							state <= s1;
--						end if;
								
						
						--state <= s1;
					--
					when s6 =>
--						if COMMISSIONNING_MODE_RQ = '0' then
--							state <= idle;
--						end if;
						null;  --BREAK_TRIGGER 
							
				--
				end case;
			end if;
		end process;
		--===============================================================================================--		
	end block;
	--===============================================================================================--	
						
					



	---------------********************************PARAMETERS************************************----------------
	--  config, ctrl & flags	

	--===============================================================================================--
	ttc_fmc_regs: entity work.wb_ttc_fmc_regs --registers mapping
	--===============================================================================================--
	port map 
	(
		wb_mosi	=> wb_mosi_i(user_wb_ttc_fmc_regs),
		wb_miso 	=> wb_miso_o(user_wb_ttc_fmc_regs),	
		regs_o 	=> ttc_fmc_regs_from_wb, 
		regs_i 	=> ttc_fmc_regs_to_wb);
	--===============================================================================================--

	--SW to VHDL
	PC_config_ok 						<= ttc_fmc_regs_from_wb(16)(0);
	INT_TRIGGER_FREQ_SEL 			<= ttc_fmc_regs_from_wb(16)(5 downto 2);  --0&1 reserved /BC_CLK
	CBC_DATA_PACKET_NUMBER 			<= ttc_fmc_regs_from_wb(16)(27 downto 7); --/SRAM_CLK
	TRIGGER_SEL							<= ttc_fmc_regs_from_wb(16)(28); --/BC_CLK
	ACQ_MODE								<= ttc_fmc_regs_from_wb(16)(29); --/BC_CLK
	--===============================================================================================--
	--resync ACQ_MODE
	--===============================================================================================--
	ACQ_MODE_RESYNC 					<= ACQ_MODE;	
	--===============================================================================================--
--	CBC_DATA_GENE 						<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
	CBC_DATA_GENE(0,0)				<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
--	CBC_DATA_GENE(0,1)				<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
--	CBC_DATA_GENE(1,0)				<= ttc_fmc_regs_from_wb(16)(30);--'0';
--	CBC_DATA_GENE(1,1)				<= ttc_fmc_regs_from_wb(16)(30);--'0';

--	CBC_DATA_GENE(2,0)				<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
--	CBC_DATA_GENE(2,1)				<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
--	CBC_DATA_GENE(3,0)				<= ttc_fmc_regs_from_wb(16)(30);--'0';
--	CBC_DATA_GENE(3,1)				<= ttc_fmc_regs_from_wb(16)(30);--'0';
	--
	SPURIOUS_FRAME						<= ttc_fmc_regs_from_wb(16)(31); --/BC_CLK 				
	CLK_DEPHASING 						<= ttc_fmc_regs_from_wb(19)(0);
	POLARITY_sTTS						<= ttc_fmc_regs_from_wb(19)(1);
	POLARITY_CBC						<= ttc_fmc_regs_from_wb(19)(2);
	CMD_START_BY_PC					<= ttc_fmc_regs_from_wb(19)(3);	
	--new
	--TTC3_USER_LED_N --> removed ?
	POLARITY_TLU						<= ttc_fmc_regs_from_wb(19)(7);
	--new
	FE_MASK(0)							<= ttc_fmc_regs_from_wb(19)(8);
--	FE_MASK(1)							<= '1'; --ttc_fmc_regs_from_wb(19)(9);
--	FE_MASK(2)							<= ttc_fmc_regs_from_wb(19)(10);
--	FE_MASK(3)							<= ttc_fmc_regs_from_wb(19)(11);
	
	--SRAM1&2_end_readout 
--	SRAM_end_readout(sram1)    	<= ttc_fmc_regs_from_wb(16)(1);
--	SRAM_end_readout(sram2)    	<= ttc_fmc_regs_from_wb(16)(6);	

	--SRAM1_end_readout
	flags_pc_to_vhdl_2b(0)    		<= ttc_fmc_regs_from_wb(16)(1); 
	--SRAM2_end_readout
	flags_pc_to_vhdl_2b(1) 			<= ttc_fmc_regs_from_wb(16)(6); 	
	--===============================================================================================--
	--resync SRAM1_end_readout & SRAM2_end_readout
	--===============================================================================================--
	inst_flags_pc_to_vhdl_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 2) --2
	port map 
	(
		wrclk_i							=> wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk,
		rdclk_i							=> tx_frame_clk, 
		wdata_i							=> flags_pc_to_vhdl_2b,
		rdata_o							=> flags_pc_to_vhdl_resync_2b
	); 
	

	SRAM_end_readout(sram1)    			<= flags_pc_to_vhdl_resync_2b(0);
	SRAM_end_readout(sram2)    			<= flags_pc_to_vhdl_resync_2b(1);	
	--===============================================================================================--




	-->VHDL to SW
	ttc_fmc_regs_to_wb(18)(14) 	<= cmd_start_valid;
	
	--flags
	--===============================================================================================--
	--FLAGS to store into registers mapping
	--===============================================================================================--
	flags_vhdl_to_pc_32b 			<= "00" & FSM_FIFO_TDC_flag(3 downto 0) & FSM_FIFO2_flag(3 downto 0) & FSM_FIFO1_flag(0,0)(3 downto 0) & FSM_FIFO_TO_SRAM_flag(sram2) & SRAM_full(sram2) & FSM_FIFO_TO_SRAM_flag(sram1) & SRAM_full(sram1);	
	ttc_fmc_regs_to_wb(17) 			<= flags_vhdl_to_pc_resync_32b; --flags_vhdl_to_pc_32b;	
	

	--===============================================================================================--
	inst_flags_to_pc_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 32) 
	port map 
	(
		wrclk_i							=> tx_frame_clk,
		rdclk_i							=> wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk, 
		wdata_i							=> flags_vhdl_to_pc_32b,
		rdata_o							=> flags_vhdl_to_pc_resync_32b 
	); 
	--===============================================================================================--



	

	---------------******************************END PARAMETERS**********************************----------------





	---------------********************************CBC_RECEIVER + FIFO STORAGE************************************----------------

--	--TEST DATA	
--	cbc_rcv_data_test(0,0)	<= x"11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11_11";
--	cbc_rcv_data_test(0,1)	<= x"22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22_22";
--	cbc_rcv_data_test(1,0)	<= x"33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33_33";
--	cbc_rcv_data_test(1,1)	<= x"44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44";
--	--from M.Pesaresi
--	cbc_rcv_data_test(0,0)	<=	x"8E_5B_1B_63_E4_9C_00_01_02_03_04_05_06_07_08_09_0A_0B_0C_0D_0E_0F_10_11_12_13_14_15_16_17_18_19_1A";
--	cbc_rcv_data_test(0,1)	<=	x"8E_64_E4_9C_1B_63_FE_FD_FC_FB_FA_F9_F8_F7_F6_F5_F4_F3_F2_F1_F0_EF_EE_ED_EC_EB_EA_E9_E8_E7_E6_E5_E4";
--	cbc_rcv_data_test(1,0)	<=	x"8E_5B_1B_63_E4_9C_00_01_02_03_04_05_06_07_08_09_0A_0B_0C_0D_0E_0F_10_11_12_13_14_15_16_17_18_19_1A";
--	cbc_rcv_data_test(1,1)	<=	x"8E_64_E4_9C_1B_63_FE_FD_FC_FB_FA_F9_F8_F7_F6_F5_F4_F3_F2_F1_F0_EF_EE_ED_EC_EB_EA_E9_E8_E7_E6_E5_E4";



	--new : data_FF / all1 --fill-in all 1
	cbc_rcv_data_test_FF_GEN : for i in CBC_DATA_BITS_NB-1 downto 0 generate	
		cbc_rcv_data_test_FF(i) <= '1';
	end generate;

	cbc_rcv_data_test_x44	<= x"44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44_44";	



	--fill-in by quartet
--	--v1
--	i_fe_gene1 : for i_fe in 1 to FE_NB generate	
--	process(cbc_rcv_data_test)
--	begin
--		cbc_rcv_data_test_loop : for i in CBC_DATA_BITS_NB/4 downto 1 loop
--			cbc_rcv_data_test( 4*i-1 downto (4*i-4) )  <= std_logic_vector(to_unsigned(i_fe-1,4));   
--		end loop; 
--	end process;   

   -- v2:	
   ------
	--===============================================================================================--
	cbc_rcv_data_test_i_fe_GEN : for i_fe in 0 to FE_NB-1 generate
	--===============================================================================================--
		cbc_rcv_data_test_i_cbc_GEN : for i_cbc in 0 to CBC_NB-1 generate
		--===============================================================================================--
			cbc_rcv_data_test_i_part_GEN : for i_part in 0 to CBC_DATA_BITS_NB/4-1 generate
			--===============================================================================================--					
				cbc_rcv_data_test(i_fe,i_cbc)		  (				cbc_rcv_data_test(i_fe,i_cbc)'left 			- 			4*i_part 
																	downto 	cbc_rcv_data_test(i_fe,i_cbc)'left + 1 	- 			4*(i_part+1)  
																)
																	<= 		std_logic_vector(to_unsigned(i_fe*CBC_NB + i_cbc + 1,4));						
			end generate;
			--===============================================================================================--
		end generate;
		--===============================================================================================--
	end generate; 
	--===============================================================================================--



--	CBC_DATA_BITS_NB
--	i_fe_gene1 : for i_fe in 1 to FE_NB generate	
--	process(DATA_TO_SRAM_tmp2)
--	begin
--		DATA_TO_SRAM_tmp2_loop : for i in 263 downto 0 loop
--			DATA_TO_SRAM_tmp2((32*(i+1))-1 downto (32*i))  <= std_logic_vector(to_unsigned(i_fe-1,32));   
--		end loop; 
--	end process;
	
	
	
	cbc_rcv_aclr <= not PC_config_ok;-- or cmd_start_valid;

	cbc_i_fe_GEN : for i_fe in 1 to FE_NB generate
		cbc_i_cbc_GEN : for i_cbc2 in 1 to CBC_NB generate --i_cbc2 : 0=>A, 1=>B
			--===============================================================================================--	
			process --Polarity select - not need / dome
			--===============================================================================================--
			begin
			wait until rising_edge(tx_frame_clk);
				cbc_rcv_frame_in(i_fe-1,i_cbc2-1) <= cbc_trigdata(i_fe-1,i_cbc2-1);	--polarity positive 		
			end process;
			--===============================================================================================--	

	
			--===============================================================================================--
			cbc_frame_detect_inst: entity work.cbc_frame_detect  --deserialiser (serie to //)
			--===============================================================================================--
			PORT MAP(	clk 				=> tx_frame_clk,
							async_reset 	=> cbc_rcv_aclr, --active high
							data_in 			=> cbc_rcv_frame_in(i_fe-1,i_cbc2-1),
							data_out 		=> cbc_rcv_data(i_fe-1,i_cbc2-1), 
							write_en 		=> cbc_rcv_data_en(i_fe-1,i_cbc2-1),--active high / one cycle
							capture_out		=> cbc_rcv_capture_out(i_fe-1,i_cbc2-1)
						);							
			--===============================================================================================--

			--===============================================================================================--
			process --cbc data select 
			--===============================================================================================--
			begin
				wait until rising_edge(tx_frame_clk);
					if PC_config_ok = '0' or cmd_start_valid = '0' then
						cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1) 	<= '0';
						cbc_rcv_data_selected(i_fe-1,i_cbc2-1) 		<= cbc_rcv_data_test(i_fe-1,i_cbc2-1);
					----internal data / debug
					--elsif CBC_DATA_GENE = '0' then
					elsif CBC_DATA_GENE(0,0) = '0' then
					--elsif CBC_DATA_GENE(i_fe-1,i_cbc2-1) = '0' then  
						cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1) 	<= L1A_VALID;-- or SPURIOUS_FRAME;
						if CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) = '1' then --once write made in fifo, word is reversed
							cbc_rcv_data_selected(i_fe-1,i_cbc2-1) 	<= not cbc_rcv_data_selected(i_fe-1,i_cbc2-1); 
						end if;
					----from cbc_receiver / true data 
					--elsif FE_MASK(i_fe-1) = '1' then
					elsif CBC_MASK(i_fe-1,i_cbc2-1) = '1' then
						cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1) 	<= L1A_VALID;
						cbc_rcv_data_selected(i_fe-1,i_cbc2-1)	   	<= cbc_rcv_data_test_FF;--cbc_rcv_data_test_x44; -- cbc_rcv_data_test_FF; --cbc_rcv_data_test(0,1); --cbc_rcv_data_test_FF;
					else 
						cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1) 	<= cbc_rcv_data_en(i_fe-1,i_cbc2-1);	--from cbc_frame_detect	
						cbc_rcv_data_selected(i_fe-1,i_cbc2-1)	   	<= cbc_rcv_data(i_fe-1,i_cbc2-1);								
					end if;
			end process;




			--===============================================================================================--	
			process(PC_config_ok,tx_frame_clk) --CBC_DATA_COUNTER
			--===============================================================================================--	
			begin
				if PC_config_ok = '0' then --async/TTC_FMC
					CBC_DATA_COUNTER(i_fe-1,i_cbc2-1) 	<= std_logic_vector(to_unsigned(0,24)); --0 : DIN_FIFO latch into process / 1 : DIN_FIFO no process
				elsif rising_edge(tx_frame_clk) then
					if cmd_start_valid = '0' then
						CBC_DATA_COUNTER(i_fe-1,i_cbc2-1) 	<= std_logic_vector(to_unsigned(0,24));
					elsif cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1) = '1' or SPURIOUS_FRAME = '1' then
					--elsif L1A_VALID = '1' or SPURIOUS_FRAME = '1' then 
						CBC_DATA_COUNTER(i_fe-1,i_cbc2-1) 	<= std_logic_vector(unsigned(CBC_DATA_COUNTER(i_fe-1,i_cbc2-1)) + "01");
					else
						null;
					end if;
				end if;
			end process;
			--===============================================================================================--	



			--===============================================================================================--	
			ipcore_fifo_cbcv2_inst : entity work.ipcore_fifo_cbcv2 
			--===============================================================================================--	
			PORT MAP (	clk 					=> tx_frame_clk,
							--
							rst 					=> '0',
							--write
							din 					=> CBC_DATA_FIFO_DIN(i_fe-1,i_cbc2-1), --264b
							wr_en 				=> CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1),
							wr_ack      		=> CBC_DATA_FIFO_WR_ACK(i_fe-1,i_cbc2-1),
							--read
							rd_en 				=> CBC_DATA_FIFO_RD_EN(i_fe-1,i_cbc2-1),
							dout 					=> CBC_DATA_FIFO_DOUT(i_fe-1,i_cbc2-1),--264b
							--flags
							full 					=> CBC_DATA_FIFO_FULL(i_fe-1,i_cbc2-1),
							empty 				=> CBC_DATA_FIFO_EMPTY(i_fe-1,i_cbc2-1),
							valid 				=> CBC_DATA_FIFO_VALID(i_fe-1,i_cbc2-1),
							prog_full 			=> CBC_DATA_FIFO_PROG_FULL(i_fe-1,i_cbc2-1),
							prog_empty 			=> CBC_DATA_FIFO_PROG_EMPTY(i_fe-1,i_cbc2-1)
						);
			
			CBC_DATA_FIFO_RD_EN(i_fe-1,i_cbc2-1) <= RD_EN_FIFO_ALL; --common for all FIFOs						
			--===============================================================================================--





			--===============================================================================================--	
			ipcore_fifo_cbcCounter_inst : entity work.ipcore_fifo_cbcCounter
			--===============================================================================================--	
			PORT MAP (	clk 					=> tx_frame_clk,
							--
							rst 					=> '0',
							--write
							din 					=> CBC_COUNTER_FIFO_DIN(i_fe-1,i_cbc2-1), --24b
							wr_en 				=> CBC_COUNTER_FIFO_WR_EN(i_fe-1,i_cbc2-1),
							wr_ack     	 		=> CBC_COUNTER_FIFO_WR_ACK(i_fe-1,i_cbc2-1),
							--read
							rd_en 				=> CBC_COUNTER_FIFO_RD_EN(i_fe-1,i_cbc2-1),
							dout 					=> CBC_COUNTER_FIFO_DOUT(i_fe-1,i_cbc2-1),--24b
							--flags
							full 					=> CBC_COUNTER_FIFO_FULL(i_fe-1,i_cbc2-1),
							empty 				=> CBC_COUNTER_FIFO_EMPTY(i_fe-1,i_cbc2-1),
							valid 				=> CBC_COUNTER_FIFO_VALID(i_fe-1,i_cbc2-1),
							prog_full 			=> CBC_COUNTER_FIFO_PROG_FULL(i_fe-1,i_cbc2-1),
							prog_empty 			=> CBC_COUNTER_FIFO_PROG_EMPTY(i_fe-1,i_cbc2-1)
						);

			CBC_COUNTER_FIFO_DIN(i_fe-1,i_cbc2-1) 			<= CBC_DATA_COUNTER(i_fe-1,i_cbc2-1);
			CBC_COUNTER_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1);
			CBC_COUNTER_FIFO_RD_EN(i_fe-1,i_cbc2-1) 		<= RD_EN_FIFO_ALL; --common for all FIFOs
			--===============================================================================================--


--CBC_DATA_FIFO_EMPTY <
--EMPTY_FIFO_ALL <= CBC_DATA_FIFO_EMPTY


			

			--===============================================================================================--
			fifo_cbcv2_fsm_block : block						
			type FSM_FIFO1_states is (		FSM_FIFO1_idle, 			FSM_FIFO1_wait_start, 		FSM_FIFO1_write_data, 		
													FSM_FIFO1_write_OOS,		FSM_FIFO1_BUSY 				
												);
			signal FSM_FIFO1_state : FSM_FIFO1_states;
			--===============================================================================================--
			begin 
				--===============================================================================================--		
				process (tx_frame_clk,PC_config_ok,BREAK_TRIGGER) --FIFO1 - FSM CTRL
				--===============================================================================================--	 	
				--variable wait_busy : integer range 0 to 7:=7;
					begin	
						--
						--if PC_config_ok = '0' then
						if PC_config_ok = '0' or BREAK_TRIGGER = '1' then						
							FSM_FIFO1_state 												<= FSM_FIFO1_idle;
							CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 					<= '0';
							FSM_FIFO1_flag(i_fe-1,i_cbc2-1) 							<= std_logic_vector(to_unsigned(0,8));
							
						elsif rising_edge(tx_frame_clk) then
						
						--true data
						CBC_DATA_FIFO_DIN(i_fe-1,i_cbc2-1) 							<= cbc_rcv_data_selected(i_fe-1,i_cbc2-1);
						--enable
						cbc_rcv_data_selected_en_del1(i_fe-1,i_cbc2-1) 			<= cbc_rcv_data_selected_en(i_fe-1,i_cbc2-1); --FIFO_CTRL_DELAY

							--
							case FSM_FIFO1_state is
								--
								when FSM_FIFO1_idle => 

									CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 			<= '0';
									FSM_FIFO1_state 										<= FSM_FIFO1_wait_start;
									FSM_FIFO1_flag(i_fe-1,i_cbc2-1)					<= std_logic_vector(to_unsigned(1,8));			
								
								--
								--when FSM_FIFO1_RAZ_FIFO1 => --dummy reading / test empty
								
								--
								when FSM_FIFO1_wait_start =>
									--
									if (
											CMD_START_BY_PC							= '1'
											and ALL_FIFO_empty_ok 					= "11"
										)										
									then								
										FSM_FIFO1_state 									<= FSM_FIFO1_write_data;
									end if;
									--
									FSM_FIFO1_flag(i_fe-1,i_cbc2-1)					<= std_logic_vector(to_unsigned(2,8));
								
								--					
								when FSM_FIFO1_write_data =>
									--condition for OOS
									if condition_oos = '1' then
										FSM_FIFO1_state 									<= FSM_FIFO1_write_OOS;						
--									--condition full fifo
--									elsif CBC_DATA_FIFO_FULL(i_fe-1,i_cbc2-1) = '1' then --100%
									--condition partial full fifo
									elsif CBC_DATA_FIFO_PROG_FULL(i_fe-1,i_cbc2-1) = '1' then --90%
										FSM_FIFO1_state 									<= FSM_FIFO1_BUSY;
									--storage in continue by def
									elsif cbc_rcv_data_selected_en_del1(i_fe-1,i_cbc2-1) = '1' then 
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= '1';
									else
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= '0';							
									end if;
									--												
									FSM_FIFO1_flag(i_fe-1,i_cbc2-1) 					<= std_logic_vector(to_unsigned(3,8));
								
								--
								when FSM_FIFO1_write_OOS => 
									if CBC_DATA_FIFO_FULL(i_fe-1,i_cbc2-1) = '1' then
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= '0';
									else
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= '1'; --'1' write in continue to fill-in FIFO
									end if;						
									
									FSM_FIFO1_flag(i_fe-1,i_cbc2-1) 					<= std_logic_vector(to_unsigned(5,8));
								
								--
								when FSM_FIFO1_BUSY => 
									--condition for OOS
									if condition_oos = '1' then
										FSM_FIFO1_state 									<= FSM_FIFO1_write_OOS;	
									--
									--elsif CBC_DATA_FIFO_EMPTY(i_fe-1,i_cbc2-1) = '1'  then

									elsif ( 		ALL_FIFOS_ARE_EMPTY					= '1'
											)
									then
										FSM_FIFO1_state 									<= FSM_FIFO1_write_data;
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= cbc_rcv_data_selected_en_del1(i_fe-1,i_cbc2-1); --cbc_rcv_data_selected_en(0);--if simultané raz;
									
									--
	--								elsif cbc_rcv_data_selected_en_del1(0) = '1' then 
	--									CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 	<= '1';
									--
									else
										CBC_DATA_FIFO_WR_EN(i_fe-1,i_cbc2-1) 		<= '0';								
									--
									end if;						
									--
									FSM_FIFO1_flag(i_fe-1,i_cbc2-1) 					<= std_logic_vector(to_unsigned(4,8));
													
							end case;
						end if;
				end process;
				--===============================================================================================--		
			end block;
			--===============================================================================================--	



			---------------********************************SPURIUOS_FRAME_DETECT************************************----------------	
			--===============================================================================================--		
			process(PC_config_ok,tx_frame_clk,cmd_start_valid) --if CBC_DATA_COUNTER > L1A_COUNTER
			--===============================================================================================--		
			begin
				if PC_config_ok = '0' or cmd_start_valid = '0' then --or cmd_stop_valid = '1' then --async/TTC_FMC
					spurious_flag_for_each_cbc(i_fe-1,i_cbc2-1) <= '0';
				elsif rising_edge(tx_frame_clk) then
					if unsigned(CBC_DATA_COUNTER(i_fe-1,i_cbc2-1)) > unsigned(L1A_COUNTER) then --if OVR ????
						spurious_flag_for_each_cbc(i_fe-1,i_cbc2-1) <= '1';
					end if;
				end if;
			end process;		
			--===============================================================================================--		
			---------------******************************END SPURIUOS_FRAME_DETECT**********************************----------------


		end generate;
	end generate;
	
	---------------******************************END CBC_RECEIVER + FIFO STORAGE**********************************----------------		





	---------------********************************ACQ_COUNTERS************************************----------------
	--===============================================================================================--
	process(PC_config_ok,tx_frame_clk) --Bunch Crossing Counter / not full counter !!!
	--===============================================================================================--
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			BC_COUNTER_12b <= (others=>'0');
			BC_COUNTER_full_32b <= (others=>'0');
		elsif rising_edge(tx_frame_clk) then 
			--if cmd_start_valid = '0' or BC_COUNTER_12b = 3563 then
			if cmd_start_valid = '0' or to_integer(unsigned(BC_COUNTER_12b)) = 3563 then
				BC_COUNTER_12b <= (others=>'0');
				BC_COUNTER_full_32b <= (others=>'0');
			else
				BC_COUNTER_12b <= std_logic_vector(unsigned(BC_COUNTER_12b) + "01");
				BC_COUNTER_full_32b <= std_logic_vector(unsigned(BC_COUNTER_full_32b) + "01");
			end if;
		end if;
	end process;

	--BC_COUNTER_24 : extension of bits
	BC_COUNTER_24b <= x"000" & std_logic_vector(BC_COUNTER_12b);
	--===============================================================================================--	


	--===============================================================================================--
	process(PC_config_ok,tx_frame_clk) --Orbit Counter / full counter
	--===============================================================================================--
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			ORB_COUNTER_18b <= (others=>'0');
		elsif rising_edge(tx_frame_clk) then
			if cmd_start_valid = '0' then
				ORB_COUNTER_18b <= (others=>'0');
			--elsif BC_COUNTER_12b = 3563 then
			elsif to_integer(unsigned(BC_COUNTER_12b)) = 3563 then
				ORB_COUNTER_18b <= std_logic_vector(unsigned(ORB_COUNTER_18b) + "01");
			else
				null;
			end if;
		end if;
	end process;
	
	--ORB_COUNTER_24b : extension of bits
	ORB_COUNTER_24b <= "000000" & std_logic_vector(ORB_COUNTER_18b);
	--===============================================================================================--	



	--===============================================================================================--	
	process(PC_config_ok,tx_frame_clk) --Lumi-Section Counter / full counter
	--===============================================================================================--	
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			LS_COUNTER_24b <= (others=>'0');
		elsif rising_edge(tx_frame_clk) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) then
			if cmd_start_valid = '0' then
				LS_COUNTER_24b <= (others=>'0');
			--elsif ORB_COUNTER_18b = 2**18-1 then
			elsif to_integer(unsigned(ORB_COUNTER_18b)) = 2**18-1 and to_integer(unsigned(BC_COUNTER_12b)) = 3563 then
				LS_COUNTER_24b <= std_logic_vector(unsigned(LS_COUNTER_24b) + "01");
			else
				null;
			end if;
		end if;
	end process;
	--===============================================================================================--	


	--===============================================================================================--	
	process(PC_config_ok,tx_frame_clk) --Trigger Counter
	--===============================================================================================--	
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			L1A_COUNTER <= std_logic_vector(to_unsigned(0,24));
		elsif rising_edge(tx_frame_clk) then
			if cmd_start_valid = '0' then
				L1A_COUNTER <= std_logic_vector(to_unsigned(0,24));
			elsif L1A_VALID = '1' then --cmd_start_valid = '1' and l1accept_sync_one_cycle = '1' then
				L1A_COUNTER <= std_logic_vector(unsigned(L1A_COUNTER) + "01");
			else
				null;
			end if;
		end if;
	end process;
	--===============================================================================================--


	---------------******************************END ACQ_COUNTERS**********************************----------------



	---------------********************************SPURIUOS_FRAME_DETECT************************************----------------	
	--===============================================================================================--		
	process(PC_config_ok,tx_frame_clk,cmd_start_valid) --if CBC_DATA_COUNTER > L1A_COUNTER
	--===============================================================================================--		
	begin
		if PC_config_ok = '0' or cmd_start_valid = '0' then --or cmd_stop_valid = '1' then --async/TTC_FMC
			spurious_flag <= '0';
		elsif rising_edge(tx_frame_clk) then
			if (		spurious_flag_for_each_cbc(0,0) = '1' 
					or spurious_flag_for_each_cbc(0,1) = '1'
					or spurious_flag_for_each_cbc(0,2) = '1'					
					or spurious_flag_for_each_cbc(0,3) = '1'
					or spurious_flag_for_each_cbc(0,4) = '1'
					or spurious_flag_for_each_cbc(0,5) = '1'
					or spurious_flag_for_each_cbc(0,6) = '1'
					or spurious_flag_for_each_cbc(0,7) = '1'					
--					or spurious_flag_for_each_cbc(1,0) = '1'
--					or spurious_flag_for_each_cbc(1,1) = '1'
				)
			then
				spurious_flag <= '1';
			end if;
		end if;
	end process;
	--===============================================================================================--		
	---------------******************************END SPURIUOS_FRAME_DETECT**********************************----------------









	---------------********************************FIFO2_STORAGE************************************----------------
	--> Storage of Time & Trigger Counters

	--===============================================================================================--	
	ipcore_fifo_time_triggerCounter_inst : entity work.ipcore_fifo_time_triggerCounter 
	--===============================================================================================--	
	PORT MAP (	clk 			=> tx_frame_clk,
					--
					rst 			=> '0',
					--write
					din 			=> TIME_TRIGGER_FIFO_DIN, --96b
					wr_en 		=> TIME_TRIGGER_FIFO_WR_EN,
					wr_ack      => TIME_TRIGGER_FIFO_WR_ACK,
					--read
					rd_en 		=> TIME_TRIGGER_FIFO_RD_EN,
					dout 			=> TIME_TRIGGER_FIFO_DOUT,--96b
					--flags
					full 			=> TIME_TRIGGER_FIFO_FULL,
					empty 		=> TIME_TRIGGER_FIFO_EMPTY,
					valid 		=> TIME_TRIGGER_FIFO_VALID,
					prog_full 	=> TIME_TRIGGER_FIFO_PROG_FULL,	
					prog_empty 	=> TIME_TRIGGER_FIFO_PROG_EMPTY  
				);
	TIME_TRIGGER_FIFO_RD_EN <= RD_EN_FIFO_ALL;
	--===============================================================================================--




	--===============================================================================================--
	fifo_time_triggerCounter_fsm_block : block						
	--> FOR FIFO2
	type FSM_FIFO2_states is (		FSM_FIFO2_idle, 			FSM_FIFO2_wait_start,		FSM_FIFO2_write_data,		 		
											FSM_FIFO2_write_OOS,		FSM_FIFO2_BUSY
										);
	signal FSM_FIFO2_state : FSM_FIFO2_states; 
	--===============================================================================================--
	begin 
		--===============================================================================================--		
		process (tx_frame_clk,PC_config_ok,BREAK_TRIGGER)--FIFO2 - FSM CTRL
		--===============================================================================================--	
		--variable wait_busy : integer range 0 to 7:=7;
			begin	
				--if PC_config_ok = '0' then
				if PC_config_ok = '0' or BREAK_TRIGGER = '1' then				
					FSM_FIFO2_state 											<= FSM_FIFO2_idle;
					TIME_TRIGGER_FIFO_WR_EN 								<= '0';
					cmd_start_valid 											<= '0';
					fifo2_busy													<= '0';					
					FSM_FIFO2_flag 											<= std_logic_vector(to_unsigned(0,8));

					
				elsif rising_edge(tx_frame_clk) then
				--DATA to store
				TIME_TRIGGER_FIFO_DIN 										<= BC_COUNTER_24b & ORB_COUNTER_24b & LS_COUNTER_24b & L1A_COUNTER;
				--enable
				--L1A_VALID_del1 												<= L1A_VALID; --FIFO_CTRL_DELAY
				--				
					
					case FSM_FIFO2_state is
						
						when FSM_FIFO2_idle => 
							TIME_TRIGGER_FIFO_WR_EN 						<= '0';
							FSM_FIFO2_state 									<= FSM_FIFO2_wait_start;
							cmd_start_valid 									<= '0';
							fifo2_busy											<= '0';							
							FSM_FIFO2_flag 									<= std_logic_vector(to_unsigned(1,8));			
						
						--when FSM_FIFO2_RAZ_FIFO2 => --dummy reading / test empty
						
						--
						when FSM_FIFO2_wait_start =>
							--
							if (
									CMD_START_BY_PC							= '1'
									and ALL_FIFO_empty_ok 					= "11"
								)
							then
								cmd_start_valid 								<= '1';		
								FSM_FIFO2_state 								<= FSM_FIFO2_write_data;
								fifo2_busy										<= '0';								
							end if;
							--
							FSM_FIFO2_flag <= std_logic_vector(to_unsigned(2,8));
						
						--
						when FSM_FIFO2_write_data =>
							--condition for OOS
							if condition_oos = '1' then
								FSM_FIFO2_state 								<= FSM_FIFO2_write_OOS;
								fifo2_busy										<= '0';
--							--condition full fifo
--							elsif TIME_TRIGGER_FIFO_FULL = '1' then  --100%
							--condition partial full fifo
							elsif TIME_TRIGGER_FIFO_PROG_FULL = '1' then --90% 							
								FSM_FIFO2_state 								<= FSM_FIFO2_BUSY;
								fifo2_busy										<= '1';
							--> storage in continue by def
							elsif L1A_VALID_del1 = '1' then 
								TIME_TRIGGER_FIFO_WR_EN 					<= '1';
								fifo2_busy										<= '0';								
							else
								TIME_TRIGGER_FIFO_WR_EN 					<= '0';
								fifo2_busy										<= '0';								
							end if;
							--						
							FSM_FIFO2_flag 									<= std_logic_vector(to_unsigned(3,8));
						
						--
						when FSM_FIFO2_write_OOS => 
							--
							if TIME_TRIGGER_FIFO_FULL = '1' then
								TIME_TRIGGER_FIFO_WR_EN 					<= '0';
							else
								TIME_TRIGGER_FIFO_WR_EN 					<= '1'; --write in continue to fill-in FIFO
							end if;						
							--
							FSM_FIFO2_flag 									<= std_logic_vector(to_unsigned(5,8));
					
						--
						when FSM_FIFO2_BUSY => 
							--condition for OOS
							if condition_oos = '1' then
								FSM_FIFO2_state 								<= FSM_FIFO2_write_OOS;	
							elsif ( 		ALL_FIFOS_ARE_EMPTY				= '1'
									)									
							then
								FSM_FIFO2_state 								<= FSM_FIFO2_write_data;
								TIME_TRIGGER_FIFO_WR_EN 					<= L1A_VALID_del1; --L1A_VALID; --if simultané???
							--
	--						elsif L1A_VALID_del1 = '1' then --L1A_VALID = '1' then
	--							TIME_TRIGGER_FIFO_WR_EN 					<= '1';
							--
							else
								TIME_TRIGGER_FIFO_WR_EN 					<= '0';								
							end if;						
							--
							FSM_FIFO2_flag 									<= std_logic_vector(to_unsigned(4,8));			
					--	
					end case;
				end if;
		end process;
	end block;
		--===============================================================================================--	
		---------------******************************END FIFO2_STORAGE**********************************----------------	





	
	---------------********************************STUBDATA************************************----------------
	--cbc_stubdata 		: array(i,j)x1b 
	--cbc_stubdata_tmp 	: array(i)(j)
	i_fe_stubdata_order_gene : for i_fe in 1 to FE_NB generate 
		i_cbc_stubdata_order_gene : for i_cbc in 1 to CBC_NB generate 	
			cbc_stubdata_tmp(i_fe-1)(i_cbc-1) <= cbc_stubdata(i_fe-1,i_cbc-1) or CBC_MASK(i_fe-1,i_cbc-1); --new
		end generate;
	end generate;

	i_fe_cbc_mask_order_gene : for i_fe in 1 to FE_NB generate 
		i_cbc_cbc_mask_order_gene : for i_cbc in 1 to CBC_NB generate 	
			--CBC_MASK_TMP(i_fe-1)(i_cbc-1) <= CBC_MASK(i_fe-1,i_cbc-1);
			CBC_MASK(i_fe-1,i_cbc-1) <= CBC_MASK_TMP(i_fe-1)(i_cbc-1);			
		end generate;
	end generate;	
	


	i_fe_stubdata_gene : for i_fe in 1 to FE_NB generate 
      --> VarDelay / L1A:
      -------------------
		--===============================================================================================--	
		ipcore_L1A_varDelay_inst : entity work.ipcore_L1A_varDelay
		--===============================================================================================--	
		PORT MAP (	clk 			=> tx_frame_clk,
						sclr 			=> '0',
						a	 			=> CBC_STUBDATA_LATENCY_ADJUST(i_fe-1), --7b
						--d 				=> (0 => L1A_VALID), --1b
						d(0)			=> L1A_VALID,
						q(0)     	=> L1A_VALID_ADJUST_FOR_CBC_STUBDATA(i_fe-1)--1b
					);
		--===============================================================================================--	


      --> VarDelay / StubData:
		--cbc_stubdata_all(i_fe-1) <= cbc_stubdata(i_fe-1,1) & cbc_stubdata(i_fe-1,0);
		cbc_stubdata_all(i_fe-1) <= cbc_stubdata_tmp(i_fe-1);
      -------------------
		--===============================================================================================--	
		ipcore_stubdata_varDelay_inst : entity work.ipcore_stubdata_varDelay
		--===============================================================================================--	
		PORT MAP (	clk 			=> tx_frame_clk,
						sclr 			=> '0',
						a	 			=> CBC_STUBDATA_LATENCY_ADJUST(i_fe-1), --7b
						d				=> cbc_stubdata_all(i_fe-1),--2b
						q     		=> cbc_stubdata_all_varDelay(i_fe-1)--2b
					);
		--===============================================================================================--	

		--===============================================================================================--
		process --cbc studata select 
		--===============================================================================================--
		begin
			wait until rising_edge(tx_frame_clk);
				if PC_config_ok = '0' or cmd_start_valid = '0' then
					CBC_STUBDATA_FIFO_DIN(i_fe-1) 	<= (others=>'0');
				----internal stubdata / debug
				--elsif CBC_DATA_GENE = '0' then
				elsif CBC_DATA_GENE(0,0) = '0' then  --spared ctrl signal
					CBC_STUBDATA_FIFO_DIN(i_fe-1) 	<= (others=>'1');
				----from cbc / true stubdata
				elsif FE_MASK(i_fe-1) = '1' then
					CBC_STUBDATA_FIFO_DIN(i_fe-1) 	<= (others=>'1');	
				else --TRUE DATA
					-->version setup DESY via GLIB
					--CBC_STUBDATA_FIFO_DIN(i_fe-1) <= cbc_stubdata(i_fe-1,1) & cbc_stubdata(i_fe-1,0);	
					CBC_STUBDATA_FIFO_DIN(i_fe-1) <= cbc_stubdata_tmp(i_fe-1);	
					-->version GBT chip (prompt Stub)
					--CBC_STUBDATA_FIFO_DIN(i_fe-1) 	<= cbc_stubdata_all_varDelay(i_fe-1);
				end if;
		end process;
		--===============================================================================================--


	

	
		--> Storage of StubData:
		------------------------
		--===============================================================================================--	
		ipcore_fifo_StubData_inst : entity work.ipcore_fifo_StubData 
		--===============================================================================================--	
		PORT MAP (	clk 						=> tx_frame_clk,
						--
						rst 						=> '0',
						--write
						din 						=> CBC_STUBDATA_FIFO_DIN(i_fe-1), --2b
						wr_en 					=> CBC_STUBDATA_FIFO_WR_EN(i_fe-1),
						wr_ack     	 			=> CBC_STUBDATA_FIFO_WR_ACK(i_fe-1),
						--read
						rd_en 					=> CBC_STUBDATA_FIFO_RD_EN(i_fe-1),
						dout 						=> CBC_STUBDATA_FIFO_DOUT(i_fe-1),--2b
						full 						=> CBC_STUBDATA_FIFO_FULL(i_fe-1),
						empty 					=> CBC_STUBDATA_FIFO_EMPTY(i_fe-1),
						valid 					=> CBC_STUBDATA_FIFO_VALID(i_fe-1),
						prog_full 				=> CBC_STUBDATA_FIFO_PROG_FULL(i_fe-1),	
						prog_empty 				=> CBC_STUBDATA_FIFO_PROG_EMPTY(i_fe-1)  
					);
		CBC_STUBDATA_FIFO_RD_EN(i_fe-1)		<= RD_EN_FIFO_ALL;
		CBC_STUBDATA_FIFO_WR_EN(i_fe-1) 		<= L1A_VALID_ADJUST_FOR_CBC_STUBDATA(i_fe-1);
		--===============================================================================================--


--		--===============================================================================================--
--		fifo_stubdata_fsm_block : block						
--		--> FOR TDC_COUNTER
--		type FIFO_states is (		idle, 			wait_start,		write_data,		 		
--											write_OOS,		busy
--											);
--		signal FIFO_state : FIFO_states; 
--		--===============================================================================================--
--		begin 
--			--===============================================================================================--		
--			process (tx_frame_clk,PC_config_ok)-- FSM CTRL
--			--===============================================================================================--	
--			--variable wait_busy : integer range 0 to 7:=7;
--				begin	
--					if PC_config_ok = '0' then	
--						FIFO_state 													<= idle;
--						STUBDATA_WR_EN(i_fe-1) 									<= '0';
--						FSM_FIFO_STUBDATA_flag(i_fe-1) 						<= std_logic_vector(to_unsigned(0,8));
--						
--					elsif rising_edge(tx_frame_clk) then
--						--
--						case FIFO_state is
--							--
--							when idle => 
--								STUBDATA_WR_EN(i_fe-1) 							<= '0';
--								FIFO_state 											<= wait_start;
--								FSM_FIFO_STUBDATA_flag(i_fe-1) 				<= std_logic_vector(to_unsigned(1,8));			
--							
--							--when FSM_FIFO2_RAZ_FIFO2 => --dummy reading / test empty
--							
--							--
--							when wait_start =>
--								--
--								if (
--										CMD_START_BY_PC							= '1'
--										and ALL_FIFO_empty_ok 					= "11"
--									)
--								then		
--									FIFO_state 										<= write_data;
--								end if;
--								--
--								FSM_FIFO_STUBDATA_flag(i_fe-1) 				<= std_logic_vector(to_unsigned(2,8));
--							
--							--
--							when write_data =>
--								--condition for OOS
--								if condition_oos = '1' then
--									FIFO_state 										<= write_OOS;	
----								--condition full fifo
----								elsif CBC_STUBDATA_FIFO_FULL(i_fe-1) = '1' then --100%
--								--condition partial full fifo
--								elsif CBC_STUBDATA_FIFO_PROG_FULL(i_fe-1) = '1' then --90%   
--									FIFO_state 										<= busy;						
--								--> storage in continue by def
--								elsif L1A_VALID_ADJUST_FOR_CBC_STUBDATA(i_fe-1) = '1' then 
--									STUBDATA_WR_EN(i_fe-1) 						<= '1';
--								else
--									STUBDATA_WR_EN(i_fe-1) 						<= '0';							
--								end if;
--								--						
--								FSM_FIFO_STUBDATA_flag(i_fe-1) 				<= std_logic_vector(to_unsigned(3,8));
--							
--							--
--							when write_OOS => 
--								--
--								if CBC_STUBDATA_FIFO_FULL(i_fe-1) = '1' then
--									STUBDATA_WR_EN(i_fe-1) 						<= '0';
--								else
--									STUBDATA_WR_EN(i_fe-1) 						<= '1'; --write in continue to fill-in FIFO
--								end if;						
--								--
--								FSM_FIFO_STUBDATA_flag(i_fe-1) 				<= std_logic_vector(to_unsigned(5,8));
--						
--							--
--							when busy => 
--								--condition for OOS
--								if condition_oos = '1' then
--									FIFO_state 										<= write_OOS;	
--								--
--								elsif ( 	ALL_FIFOS_ARE_EMPTY					= '1'
--										)	
--								then										
--									FIFO_state 										<= write_data;
--									STUBDATA_WR_EN(i_fe-1) 						<= L1A_VALID_ADJUST_FOR_CBC_STUBDATA(i_fe-1); --if simultané???
--								--
--		--						elsif L1A_VALID_ADJUST_FOR_CBC_STUBDATA(i_fe-1) = '1' then 
--		--							STUBDATA_WR_EN(i_fe-1) 						<= '1';
--								--
--								else
--									STUBDATA_WR_EN(i_fe-1) 						<= '0';								
--								end if;						
--								--
--								FSM_FIFO_STUBDATA_flag(i_fe-1) 				<= std_logic_vector(to_unsigned(4,8));			
--						--	
--						end case;
--					end if;
--			end process;
--			--===============================================================================================--
--		end block;
--		--===============================================================================================--

	end generate;
	---------------******************************END STUBDATA**********************************----------------




	---------------********************************CTRL_FIFO&SRAM************************************----------------
	--===============================================================================================--			
	process --RD_EN_FIFO Process
	--===============================================================================================--			
	begin
		wait until rising_edge(tx_frame_clk);
			RD_EN_FIFO_ALL <=	RD_EN_FIFO_ALL_tmp(sram1) or RD_EN_FIFO_ALL_tmp(sram2);
	end process;
	
	--===============================================================================================--	
	---------------******************************END CTRL_FIFO&SRAM**********************************----------------





   --============================--
   -- DATA TO SRAM - DATA FORMAT --
   --============================--
	
--	 DATA_TO_SRAM_tmp			 			<= 	 --
--														 std_logic_vector(to_unsigned(0,32-24)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB-1-24*0 	downto  TIME_TRIGGER_FIFO_BITS_NB-1-23-24*0) & 
--														 std_logic_vector(to_unsigned(0,32-24)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB-1-24*1 	downto  TIME_TRIGGER_FIFO_BITS_NB-1-23-24*1) &
--														 std_logic_vector(to_unsigned(0,32-24)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB-1-24*2 	downto  TIME_TRIGGER_FIFO_BITS_NB-1-23-24*2) &
--														 std_logic_vector(to_unsigned(0,32-24)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB-1-24*3 	downto  TIME_TRIGGER_FIFO_BITS_NB-1-23-24*3) &
--														 --
--														 std_logic_vector(to_unsigned(0,32-24)) & CBC_COUNTER_FIFO_DOUT(0,0) &
--														 --
--														 CBC_DATA_FIFO_DOUT(0,0) & --264 : reste 9*32-264=24
--														 std_logic_vector(to_unsigned(0,9*32-264-1)) & 
--														 CBC_STUBDATA_FIFO_DOUT(0)(0) &
--														 --
--														 CBC_DATA_FIFO_DOUT(0,1) & --264 : reste 9*32-264=24
--														 std_logic_vector(to_unsigned(0,9*32-264-1)) & 
--														 CBC_STUBDATA_FIFO_DOUT(0)(1) &
--														 --
--														 CBC_DATA_FIFO_DOUT(1,0) & --264 : reste 9*32-264=24
--														 std_logic_vector(to_unsigned(0,9*32-264-1)) & 
--														 CBC_STUBDATA_FIFO_DOUT(1)(0) &
--														 --
--														 CBC_DATA_FIFO_DOUT(1,1) & --264 : reste 9*32-264=24
--														 std_logic_vector(to_unsigned(0,9*32-264-1)) & 
--														 CBC_STUBDATA_FIFO_DOUT(1)(1) &
--														 --
--														 std_logic_vector(to_unsigned(0,32-TDC_COUNTER_FIFO_BITS_NB)) & TDC_COUNTER_FIFO_DOUT; --4	
	
	
--	 DATA_TO_SRAM_tmp			 			<= 	 --
--														 std_logic_vector(to_unsigned(0,32-TIME_COUNTER_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - TIME_COUNTER_BITS_NB	*0 	downto  TIME_TRIGGER_FIFO_BITS_NB - TIME_COUNTER_BITS_NB	*1) & 
--														 std_logic_vector(to_unsigned(0,32-TIME_COUNTER_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - TIME_COUNTER_BITS_NB	*1 	downto  TIME_TRIGGER_FIFO_BITS_NB - TIME_COUNTER_BITS_NB	*2) &
--														 std_logic_vector(to_unsigned(0,32-TIME_COUNTER_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - TIME_COUNTER_BITS_NB	*2 	downto  TIME_TRIGGER_FIFO_BITS_NB - TIME_COUNTER_BITS_NB	*3) &
--														 --std_logic_vector(to_unsigned(0,32-L1A_COUNTER_BITS_NB))  & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - TIME_COUNTER_BITS_NB	*3 	downto  TIME_TRIGGER_FIFO_BITS_NB - TIME_COUNTER_BITS_NB	*3 - L1A_COUNTER_BITS_NB) &
--														 std_logic_vector(to_unsigned(0,32-TIME_COUNTER_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - TIME_COUNTER_BITS_NB	*3 	downto  TIME_TRIGGER_FIFO_BITS_NB - TIME_COUNTER_BITS_NB	*4) &
--														 --
--														 std_logic_vector(to_unsigned(0,32-CBC_COUNTER_BITS_NB)) & CBC_COUNTER_FIFO_DOUT(0,0) &

	
	DATA_TO_SRAM_ACQ_COUNTERS_CONTENT <= 		  	std_logic_vector(to_unsigned(0,32-ACQ_COUNTERS_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - ACQ_COUNTERS_BITS_NB	*0 	downto  TIME_TRIGGER_FIFO_BITS_NB - ACQ_COUNTERS_BITS_NB	*1)
															& 	std_logic_vector(to_unsigned(0,32-ACQ_COUNTERS_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - ACQ_COUNTERS_BITS_NB	*1 	downto  TIME_TRIGGER_FIFO_BITS_NB - ACQ_COUNTERS_BITS_NB	*2)
															& 	std_logic_vector(to_unsigned(0,32-ACQ_COUNTERS_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - ACQ_COUNTERS_BITS_NB	*2 	downto  TIME_TRIGGER_FIFO_BITS_NB - ACQ_COUNTERS_BITS_NB	*3)
															& 	std_logic_vector(to_unsigned(0,32-ACQ_COUNTERS_BITS_NB)) & TIME_TRIGGER_FIFO_DOUT(TIME_TRIGGER_FIFO_BITS_NB - 1 - ACQ_COUNTERS_BITS_NB	*3 	downto  TIME_TRIGGER_FIFO_BITS_NB - ACQ_COUNTERS_BITS_NB	*4)
															&	std_logic_vector(to_unsigned(0,32-ACQ_COUNTERS_BITS_NB)) & CBC_COUNTER_FIFO_DOUT(0,0);

	DATA_TO_SRAM_TDC_CONTENT			<= 			std_logic_vector(to_unsigned(0,32-TDC_COUNTER_FIFO_BITS_NB)) & TDC_COUNTER_FIFO_DOUT; 





--	process(CBC_DATA_FIFO_DOUT,CBC_STUBDATA_FIFO_DOUT)
--	variable i : integer:=0;
--	begin
--		for i_fe in 0 to FE_NB-1 loop
--			for i_cbc in 0 to CBC_NB-1 loop
--				DATA_TO_SRAM_CBC_CONTENT(DATA_TO_SRAM_CBC_CONTENT'left - (CBC_DATA_AND_STUB_WORDS_NB*32)*i downto DATA_TO_SRAM_CBC_CONTENT'left + 1 - (CBC_DATA_AND_STUB_WORDS_NB*32)*(i+1)  )  <= 		CBC_DATA_FIFO_DOUT(i_fe,i_cbc)  --264 : reste 9*32-264=24
--																																																																& 	std_logic_vector(to_unsigned(0,CBC_DATA_AND_STUB_WORDS_NB*32-CBC_DATA_BITS_NB-CBC_STUBDATA_BITS_NB))  --(0,9*32-264-1)) &  
--																																																																& 	CBC_STUBDATA_FIFO_DOUT(i_fe)(i_cbc);
--				i:=i+1;
--			end loop;
--		end loop; 
--	end process;	
---->Found 1-bit latch for signal <DATA_TO_SRAM_CBC_CONTENT<1140>>. Latches may be generated from incomplete case or if statements. We do not recommend the use of latches in FPGA/CPLD designs, as they may lead to timing problems.

   -- DATA_TO_SRAM_CBC_CONTENT:	
   ----------------------------
	--===============================================================================================--
	DATA_TO_SRAM_CBC_CONTENT_i_fe_GEN : for i_fe in 0 to FE_NB-1 generate
	--===============================================================================================--
		DATA_TO_SRAM_CBC_CONTENT_i_cbc_GEN : for i_cbc in 0 to CBC_NB-1 generate
		--===============================================================================================--
			DATA_TO_SRAM_CBC_CONTENT(				DATA_TO_SRAM_CBC_CONTENT'left 		- 			(CBC_DATA_AND_STUB_WORDS_NB*32)*(i_fe*CBC_NB + i_cbc) 
												downto 	DATA_TO_SRAM_CBC_CONTENT'left + 1 	- 			(CBC_DATA_AND_STUB_WORDS_NB*32)*(i_fe*CBC_NB + i_cbc+1)  
											)
												<= 			CBC_DATA_FIFO_DOUT(i_fe,i_cbc)  --264 : reste 9*32-264=24			
															& 	std_logic_vector(to_unsigned(0,CBC_DATA_AND_STUB_WORDS_NB*32-CBC_DATA_BITS_NB-CBC_STUBDATA_BITS_NB))  --(0,9*32-264-1)) &  
															& 	CBC_STUBDATA_FIFO_DOUT(i_fe)(i_cbc);
		end generate;
		--===============================================================================================--
	end generate; 
	--===============================================================================================--




	DATA_TO_SRAM_tmp 						<= 			DATA_TO_SRAM_ACQ_COUNTERS_CONTENT 
															&  DATA_TO_SRAM_CBC_CONTENT
															& 	DATA_TO_SRAM_TDC_CONTENT;

	

	--test
	process(DATA_TO_SRAM_tmp2)
	begin
		DATA_TO_SRAM_tmp2_loop : for i in 41 downto 0 loop
			DATA_TO_SRAM_tmp2((32*(i+1))-1 downto (32*i))  <= std_logic_vector(to_unsigned((42-i),32));   
		end loop; 
	end process;
	
	

	
	
	
	
	---------------********************************SRAM1_CTRL************************************----------------
	--===============================================================================================--
	SRAM1_CTRL_fsm_block : block						
	--> FOR FIFO_TO_SRAM1
	type FSM_FIFO_TO_SRAM_states is (		FSM_FIFO_TO_SRAM_idle,							FSM_FIFO_TO_SRAM_empty_FIFO, 					FSM_FIFO_TO_SRAM_delay,					
														FSM_FIFO_TO_SRAM_init,							FSM_FIFO_TO_SRAM_test_FIFO_not_empty,		FSM_FIFO_TO_SRAM_latch_data,			
														FSM_FIFO_TO_SRAM_store_data,					FSM_FIFO_TO_SRAM_test_packet_sent,			FSM_FIFO_TO_SRAM_flag_full,			
														FSM_FIFO_TO_SRAM_test_end_readout
												);												
	signal FSM_FIFO_TO_SRAM_state : FSM_FIFO_TO_SRAM_states;
	--===============================================================================================--
	begin 
		--===============================================================================================--				
		process --(SRAM_CLK,PC_config_ok)--,cmd_stop_valid)
		--===============================================================================================--			
		variable FSM_FIFO_TO_SRAM_counter 	: unsigned(user_sram_addr_o(sram1)'range);
		variable counter_delay 					: integer range 0 to 7:=7;
			begin	
			wait until rising_edge(tx_frame_clk);		
				--
				if PC_config_ok = '0' or BREAK_TRIGGER = '1'  then				
					FSM_FIFO_TO_SRAM_state 									<= FSM_FIFO_TO_SRAM_idle;
					RD_EN_FIFO_ALL_tmp(sram1)								<= '1'; --force readout during aclr if clock stable
					SRAM_full(sram1)											<= '0';
					--sram1 
					CBC_user_sram_control(sram1).reset 					<= '1'; --en ----active to '1'
					CBC_user_sram_control(sram1).cs 						<= '0'; --dis	
					CBC_user_sram_control(sram1).writeEnable 			<= '1'; --'1' : wr / '0' : rd
					--
					CBC_user_sram_write_cycle(sram1)						<= '1'; --'0' for SRAM2 initially
					--
					FSM_FIFO_TO_SRAM_flag(sram1) 							<= std_logic_vector(to_unsigned(0,8));
					--
					ALL_FIFO_empty_ok(sram1) 								<= '0'; --flag to wait acq
				--	
				else
				--
					case FSM_FIFO_TO_SRAM_state is
						
						--
						when FSM_FIFO_TO_SRAM_idle => 
							--
							RD_EN_FIFO_ALL_tmp(sram1) 						<= '1'; --force readout during aclr if clock stable
							SRAM_full(sram1)									<= '0';
							--new
							DATA_TO_SRAM(sram1) 								<= DATA_TO_SRAM_tmp;
							--
							fsm_CBC_data_packet_counter(sram1) 			<= 0; --init 0
							--sram1 
							CBC_user_sram_control(sram1).reset 			<= '1'; --en ----active to '1'
							CBC_user_sram_control(sram1).cs 				<= '0'; --dis	
							CBC_user_sram_control(sram1).writeEnable 	<= '1'; --'1' : wr / '0' : rd
							--
							CBC_user_sram_write_cycle(sram1)				<= '1'; --'0' for SRAM2 initially
							--
							SRAM_full_one_cycle(sram1)						<= '0';	
							--
							ALL_FIFO_empty_ok(sram1) 						<= '0'; --flag to wait acq	
							--
							FSM_FIFO_TO_SRAM_state							<= FSM_FIFO_TO_SRAM_empty_FIFO;
							--
							counter_delay										:= 7;
							--
							FSM_FIFO_TO_SRAM_flag(sram1) 					<= std_logic_vector(to_unsigned(1,8));					
						
						--
						when FSM_FIFO_TO_SRAM_empty_FIFO => --reset FIFO
							--
							if ( 		ALL_FIFOS_ARE_EMPTY					= '1'
									)									
							then
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_delay; --FSM_FIFO_TO_SRAM_init;
								RD_EN_FIFO_ALL_tmp(sram1)					<= '0';
								--					
								ALL_FIFO_empty_ok(sram1) 					<= '1'; --flag to wait acq
								--raz
								DATA_TO_SRAM(sram1) 							<= (others=>'0');
							else
								RD_EN_FIFO_ALL_tmp(sram1) 					<= '1'; --force readout during aclr if clock stable
								DATA_TO_SRAM(sram1) 							<= DATA_TO_SRAM_tmp;
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_empty_FIFO;
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram1) 					<= std_logic_vector(to_unsigned(2,8));							
						
						--
						when FSM_FIFO_TO_SRAM_delay =>
							RD_EN_FIFO_ALL_tmp(sram1) 						<= '0'; --RAZ
							--
							if counter_delay = 0 then 
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_init;
							else
								counter_delay := counter_delay - 1;
							end if;
							--
						--
						when FSM_FIFO_TO_SRAM_init => 
							--sram1
							CBC_user_sram_control(sram1).reset 			<= '0'; --dis ----active to '1'
							CBC_user_sram_control(sram1).cs 				<= '1'; --en	
							--
							if CBC_user_sram_write_cycle(sram2) = '0' then	--and cmd_start_valid = '1' resync ??
								CBC_user_sram_write_cycle(sram1)			<= '1'; --						
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_FIFO_not_empty;
								FSM_FIFO_TO_SRAM_counter					:= unsigned(CBC_DATA_PACKET_NUMBER);												
							else
								null; --wait						
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram1)					<= std_logic_vector(to_unsigned(3,8));		
						
						--
						when FSM_FIFO_TO_SRAM_test_FIFO_not_empty =>							
							--
							if 	( 	ALL_FIFOS_ARE_NOT_EMPTY				= '1'
									)									
							then
								RD_EN_FIFO_ALL_tmp(sram1) 					<= '1';							
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_latch_data;							
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram1)					<= std_logic_vector(to_unsigned(4,8));
						
						--	
						when FSM_FIFO_TO_SRAM_latch_data => --reading of data from fifo1
							RD_EN_FIFO_ALL_tmp(sram1) 						<= '0'; --raz / one cycle
							--
							if TIME_TRIGGER_FIFO_VALID = '1' then --just only one FIFO
								--true data
								DATA_TO_SRAM(sram1) 							<= DATA_TO_SRAM_tmp; --DATA_TO_SRAM_tmp / DATA_TO_SRAM_tmp2
								--test
								--DATA_TO_SRAM(sram1) 						<= DATA_TO_SRAM(sram1) + 1;
								--
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_store_data;							
							end if;
							--
							fsm_CBC_data_packet_counter(sram1) 			<= 0; --init 0
							--
							FSM_FIFO_TO_SRAM_flag(sram1)	 				<= std_logic_vector(to_unsigned(5,8));						
						
						--					
						when FSM_FIFO_TO_SRAM_store_data => --storage
							--
							if fsm_CBC_data_packet_counter(sram1) = TOTAL_WORDS_NB + 1 then --43 then --CBC1 : 9 = 10words <=> test 11 / --CBC2 : 13 = 14words <=> test 15 / 41 = 42words <=> test 43
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_test_packet_sent;
								fsm_CBC_data_packet_counter(sram1) 		<= fsm_CBC_data_packet_counter(sram1) + 1; --until 44
								SRAM_full_one_cycle(sram1)					<= '1';
							else
								fsm_CBC_data_packet_counter(sram1) 		<= fsm_CBC_data_packet_counter(sram1) + 1;
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram1)	 				<= std_logic_vector(to_unsigned(6,8));

						--
						when FSM_FIFO_TO_SRAM_test_packet_sent => 
							--
							if FSM_FIFO_TO_SRAM_counter = 0 then
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_flag_full; 	
							else
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_FIFO_not_empty; --loop
								FSM_FIFO_TO_SRAM_counter					:= FSM_FIFO_TO_SRAM_counter - "01";
							end if;
							--
							--fsm_CBC_data_packet_counter(sram1) 				<= 0; --raz
							SRAM_full_one_cycle(sram1)						<= '0';
							FSM_FIFO_TO_SRAM_flag(sram1)					<= std_logic_vector(to_unsigned(7,8));			

						--
						when FSM_FIFO_TO_SRAM_flag_full => --flag full					
							if SRAM_end_readout(sram1) = '0' then --secure
								SRAM_full(sram1)				 				<= '1';	
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_end_readout;
							end if;
							CBC_user_sram_write_cycle(sram1)				<= '0'; --raz / '1' if only sram1
							--sram1 
							CBC_user_sram_control(sram1).reset 			<= '1'; --en ----active to '1'
							CBC_user_sram_control(sram1).cs 				<= '0'; --dis
							FSM_FIFO_TO_SRAM_flag(sram1)					<= std_logic_vector(to_unsigned(8,8));	

						--
						when FSM_FIFO_TO_SRAM_test_end_readout => --raz if read
							--
							--if OOS_state_valid = '1' then
							--	
							if SRAM_end_readout(sram1) = '1' then 
								SRAM_full(sram1)				 				<= '0';
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_init;
							end if;	
							--
							FSM_FIFO_TO_SRAM_flag(sram1)					<= std_logic_vector(to_unsigned(9,8));		
							--
					end case;
				end if;
		end process;
	end block;


	--===============================================================================================--		
	process --ctrl of sram_addr(sram1) + sram_wdata(sram1)
	--===============================================================================================--		
	begin
		wait until rising_edge(tx_frame_clk);
			--
			if PC_config_ok = '0' or cmd_start_valid = '0' or BREAK_TRIGGER = '1'  then	
				CBC_user_sram_addr_tmp1(sram1) 				<= (others => '0'); -->modif NO!!
				CBC_user_sram_wdata_tmp1(sram1) 				<= (others => '0');				
			elsif SRAM_full(sram1) = '1' then
				CBC_user_sram_addr_tmp1(sram1) 				<= (others => '0'); --packet end / raz @ not data -->modif NO!!
			else	
				--true data 
				case fsm_CBC_data_packet_counter(sram1) is 
					--all
					when 0 =>
						CBC_user_sram_wdata_tmp1(sram1)		<= 	x"0" & 
																				DATA_TO_SRAM(sram1)(	DATA_TO_SRAM(sram1)'left - (fsm_CBC_data_packet_counter(sram1) * 32)			downto 		
																											DATA_TO_SRAM(sram1)'left - (fsm_CBC_data_packet_counter(sram1) * 32) - 31
																										  );
					--
					when 1 to TOTAL_WORDS_NB - 1 => --1 to 41
						CBC_user_sram_wdata_tmp1(sram1)		<= 	x"0" & 
																				DATA_TO_SRAM(sram1)(	DATA_TO_SRAM(sram1)'left - (fsm_CBC_data_packet_counter(sram1) * 32)			downto 		
																											DATA_TO_SRAM(sram1)'left - (fsm_CBC_data_packet_counter(sram1) * 32) - 31
																										  );
						CBC_user_sram_addr_tmp1(sram1)   	<= 	std_logic_vector(unsigned(CBC_user_sram_addr_tmp1(sram1)) + "01");	--from 0 to 41	
					--
					when TOTAL_WORDS_NB => --42
						CBC_user_sram_addr_tmp1(sram1)   	<= 	std_logic_vector(unsigned(CBC_user_sram_addr_tmp1(sram1)) + "01");	--from 41 to 42	
					
					--
					when others =>
						null;
				--
				end case;
			--
			end if;
			--
	end process;
	--===============================================================================================--		
	
	---------------******************************END SRAM1_CTRL**********************************----------------




	---------------********************************SRAM2_CTRL************************************----------------
	--===============================================================================================--
	SRAM2_CTRL_fsm_block : block						
	--> FOR FIFO_TO_SRAM2
	type FSM_FIFO_TO_SRAM_states is (		FSM_FIFO_TO_SRAM_idle,							FSM_FIFO_TO_SRAM_empty_FIFO, 					FSM_FIFO_TO_SRAM_delay,					
														FSM_FIFO_TO_SRAM_init,							FSM_FIFO_TO_SRAM_test_FIFO_not_empty,		FSM_FIFO_TO_SRAM_latch_data,			
														FSM_FIFO_TO_SRAM_store_data,					FSM_FIFO_TO_SRAM_test_packet_sent,			FSM_FIFO_TO_SRAM_flag_full,			
														FSM_FIFO_TO_SRAM_test_end_readout
												);
	signal FSM_FIFO_TO_SRAM_state : FSM_FIFO_TO_SRAM_states;
	--===============================================================================================--
	begin 
		--===============================================================================================--				
		process --(SRAM_CLK,PC_config_ok)--,cmd_stop_valid)
		--===============================================================================================--			
		variable FSM_FIFO_TO_SRAM_counter 	: unsigned(user_sram_addr_o(sram2)'range);
		variable counter_delay 					: integer range 0 to 7:=7;
			begin	
			wait until rising_edge(tx_frame_clk);		
				--
				if PC_config_ok = '0' or BREAK_TRIGGER = '1'  then				
					FSM_FIFO_TO_SRAM_state 									<= FSM_FIFO_TO_SRAM_idle;
					RD_EN_FIFO_ALL_tmp(sram2)								<= '1'; --force readout during aclr if clock stable
					SRAM_full(sram2)											<= '0';
					--sram2 
					CBC_user_sram_control(sram2).reset 					<= '1'; --en ----active to '1'
					CBC_user_sram_control(sram2).cs 						<= '0'; --dis	
					CBC_user_sram_control(sram2).writeEnable 			<= '1'; --'1' : wr / '0' : rd
					--
					CBC_user_sram_write_cycle(sram2)						<= '0'; --'0' for SRAM2 initially
					--		
					ALL_FIFO_empty_ok(sram2) 								<= '0'; --flag to wait acq					
					--
					FSM_FIFO_TO_SRAM_flag(sram2) 							<= std_logic_vector(to_unsigned(0,8));
				--	
				else
				--
					case FSM_FIFO_TO_SRAM_state is
						
						--
						when FSM_FIFO_TO_SRAM_idle => 
							--
							RD_EN_FIFO_ALL_tmp(sram2) 						<= '1'; --force readout during aclr if clock stable
							SRAM_full(sram2)									<= '0';
							--new
							DATA_TO_SRAM(sram2) 								<= DATA_TO_SRAM_tmp;
							--
							fsm_CBC_data_packet_counter(sram2) 			<= 0; --init 0
							--sram2 
							CBC_user_sram_control(sram2).reset 			<= '1'; --en ----active to '1'
							CBC_user_sram_control(sram2).cs 				<= '0'; --dis	
							CBC_user_sram_control(sram2).writeEnable 	<= '1'; --'1' : wr / '0' : rd
							--
							CBC_user_sram_write_cycle(sram2)				<= '0'; --'0' for SRAM2 initially
							--
							SRAM_full_one_cycle(sram2)						<= '0';
							--		
							ALL_FIFO_empty_ok(sram2) 						<= '0'; --flag to wait acq	
							--
							FSM_FIFO_TO_SRAM_state							<= FSM_FIFO_TO_SRAM_empty_FIFO;	
							--
							counter_delay										:= 7;							
							--
							FSM_FIFO_TO_SRAM_flag(sram2) 					<= std_logic_vector(to_unsigned(1,8));					
						
						--
						when FSM_FIFO_TO_SRAM_empty_FIFO => --reset fifo
							--
							if ( 	ALL_FIFOS_ARE_EMPTY						= '1'
									)									
							then
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_delay; --FSM_FIFO_TO_SRAM_init;
								RD_EN_FIFO_ALL_tmp(sram2)					<= '0';
								--		
								ALL_FIFO_empty_ok(sram2) 					<= '1'; --flag to wait acq
								--raz
								DATA_TO_SRAM(sram2) 							<= (others=>'0');
							else
								RD_EN_FIFO_ALL_tmp(sram2) 					<= '1'; --force readout during aclr if clock stable
								DATA_TO_SRAM(sram2) 							<= DATA_TO_SRAM_tmp;
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_empty_FIFO;								
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram2) 					<= std_logic_vector(to_unsigned(2,8));	

						--
						when FSM_FIFO_TO_SRAM_delay =>
							RD_EN_FIFO_ALL_tmp(sram2) 						<= '0'; --RAZ
							--
							if counter_delay = 0 then 
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_init;
							else
								counter_delay 									:= counter_delay - 1;
							end if;
							--
							
						--
						when FSM_FIFO_TO_SRAM_init => 
							--sram2
							CBC_user_sram_control(sram2).reset 			<= '0'; --dis ----active to '1'
							CBC_user_sram_control(sram2).cs 				<= '1'; --en	
							--
							if CBC_user_sram_write_cycle(sram1) = '0' then	--and cmd_start_valid = '1' resync ??
								CBC_user_sram_write_cycle(sram2)			<= '1'; --						
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_FIFO_not_empty;
								FSM_FIFO_TO_SRAM_counter					:= unsigned(CBC_DATA_PACKET_NUMBER);												
							else
								null; --wait						
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram2)					<= std_logic_vector(to_unsigned(3,8));		
						
						--
						when FSM_FIFO_TO_SRAM_test_FIFO_not_empty =>							
							--
							if ( 	ALL_FIFOS_ARE_NOT_EMPTY					= '1'
									)							
							then
								RD_EN_FIFO_ALL_tmp(sram2) 					<= '1';
								--TIME_TRIGGER_FIFO_RD_EN_tmp(sram2) 	<= '1';							
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_latch_data;							
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram2)					<= std_logic_vector(to_unsigned(4,8));
						
						--	
						when FSM_FIFO_TO_SRAM_latch_data => --reading of data from fifo1
							RD_EN_FIFO_ALL_tmp(sram2) 						<= '0'; --raz / one cycle
							--
							if TIME_TRIGGER_FIFO_VALID = '1' then --just only one FIFO
								--true data
								DATA_TO_SRAM(sram2) 							<= DATA_TO_SRAM_tmp;
								--test
								--DATA_TO_SRAM(sram2) 						<= DATA_TO_SRAM(sram2) + 1;
								--
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_store_data;							
							end if;
							--
							fsm_CBC_data_packet_counter(sram2) 			<= 0; --init 0							
							--
							FSM_FIFO_TO_SRAM_flag(sram2)	 				<= std_logic_vector(to_unsigned(5,8));						
						
						--					
						when FSM_FIFO_TO_SRAM_store_data => --storage
							--
							if fsm_CBC_data_packet_counter(sram2) = TOTAL_WORDS_NB + 1 then --43 then --CBC1 : 9 = 10words <=> test 11 / --CBC2 : 13 = 14words <=> test 15 / 41 = 42words <=> test 43
								FSM_FIFO_TO_SRAM_state 						<= FSM_FIFO_TO_SRAM_test_packet_sent;
								fsm_CBC_data_packet_counter(sram2) 		<= fsm_CBC_data_packet_counter(sram2) + 1; --until 44
								SRAM_full_one_cycle(sram2)					<= '1';
							else
								fsm_CBC_data_packet_counter(sram2) 		<= fsm_CBC_data_packet_counter(sram2) + 1;
							end if;
							--
							FSM_FIFO_TO_SRAM_flag(sram2)	 				<= std_logic_vector(to_unsigned(6,8));

						--
						when FSM_FIFO_TO_SRAM_test_packet_sent => 
							--
							if FSM_FIFO_TO_SRAM_counter = 0 then
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_flag_full; 	
							else
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_FIFO_not_empty; --loop
								FSM_FIFO_TO_SRAM_counter					:= FSM_FIFO_TO_SRAM_counter - "01";
							end if;
							--
							--fsm_CBC_data_packet_counter(sram2) 				<= 0; --raz
							SRAM_full_one_cycle(sram2)						<= '0';
							FSM_FIFO_TO_SRAM_flag(sram2)					<= std_logic_vector(to_unsigned(7,8));			

						--
						when FSM_FIFO_TO_SRAM_flag_full => --flag full					
							if SRAM_end_readout(sram2) = '0' then --secure
								SRAM_full(sram2)				 				<= '1';	
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_test_end_readout;
							end if;
							CBC_user_sram_write_cycle(sram2)				<= '0'; --raz / '1' if only sram1
							--sram2 
							CBC_user_sram_control(sram2).reset 			<= '1'; --en ----active to '1'
							CBC_user_sram_control(sram2).cs 				<= '0'; --dis
							FSM_FIFO_TO_SRAM_flag(sram2)					<= std_logic_vector(to_unsigned(8,8));	

						--
						when FSM_FIFO_TO_SRAM_test_end_readout => --raz if read
							--
							--if OOS_state_valid = '1' then
							--	
							if SRAM_end_readout(sram2) = '1' then 
								SRAM_full(sram2)				 				<= '0';
								FSM_FIFO_TO_SRAM_state						<= FSM_FIFO_TO_SRAM_init;
							end if;	
							--
							FSM_FIFO_TO_SRAM_flag(sram2)					<= std_logic_vector(to_unsigned(9,8));		
							--
					end case;
				--
				end if;
				--
		end process;
	end block;


	--===============================================================================================--		
	process --ctrl of sram_addr(sram2) + sram_wdata(sram2)
	--===============================================================================================--		
	begin
		wait until rising_edge(tx_frame_clk);
			--
			if PC_config_ok = '0' or cmd_start_valid = '0' or BREAK_TRIGGER = '1'  then			
				CBC_user_sram_addr_tmp1(sram2) 				<= (others => '0'); -->modif NO!!
				CBC_user_sram_wdata_tmp1(sram2) 				<= (others => '0');				
			elsif SRAM_full(sram2) = '1' then
				CBC_user_sram_addr_tmp1(sram2) 				<= (others => '0'); --packet end / raz @ not data -->modif NO!!
			else	
				--true data 
				case fsm_CBC_data_packet_counter(sram2) is 
					--all
					when 0 =>
						CBC_user_sram_wdata_tmp1(sram2)		<= 	x"0" & 
																				DATA_TO_SRAM(sram2)(	DATA_TO_SRAM(sram2)'left - (fsm_CBC_data_packet_counter(sram2) * 32)			downto 		
																											DATA_TO_SRAM(sram2)'left - (fsm_CBC_data_packet_counter(sram2) * 32) - 31
																										  );
					--
					when 1 to TOTAL_WORDS_NB - 1 => --1 to 41
						CBC_user_sram_wdata_tmp1(sram2)		<= 	x"0" & 
																				DATA_TO_SRAM(sram2)(	DATA_TO_SRAM(sram2)'left - (fsm_CBC_data_packet_counter(sram2) * 32)			downto 		
																											DATA_TO_SRAM(sram2)'left - (fsm_CBC_data_packet_counter(sram2) * 32) - 31
																										  );
						CBC_user_sram_addr_tmp1(sram2)   	<= 	std_logic_vector(unsigned(CBC_user_sram_addr_tmp1(sram2)) + "01");	--from 0 to 41	
					--
					when TOTAL_WORDS_NB => --42
						CBC_user_sram_addr_tmp1(sram2)   	<= 	std_logic_vector(unsigned(CBC_user_sram_addr_tmp1(sram2)) + "01");	--from 41 to 42	
					
					--
					when others =>
						--CBC_user_sram_addr_tmp1(sram2)   	<= 	std_logic_vector(unsigned(CBC_user_sram_addr_tmp1(sram2)) + "01");	--next
						null;
				--
				end case;
			--
			end if;			
	end process;
	--===============================================================================================--
	
	
	---------------******************************END SRAM2_CTRL**********************************----------------





	--====================--
   -- SRAM INTERFACE --
   --====================--

   -- Outputting: Def Signals             
   --------------------------	
	user_sram_control_o(sram1).clk 			<= tx_frame_clk; --common clock	
	user_sram_control_o(sram2).clk 			<= tx_frame_clk; --common clock
	user_sram_control_o(sram1).reset 		<= '0'; --DIS
	user_sram_control_o(sram2).reset 		<= '0'; --DIS	

   -- Outputting: Affectation             
   --------------------------	
	user_sram_addr_o 									<= user_sram_addr_tmp;
	user_sram_wdata_o 								<= user_sram_wdata_tmp;	
	user_sram_control_o(sram1).cs					<= user_sram_control_tmp(sram1).cs;
	user_sram_control_o(sram1).writeEnable		<= user_sram_control_tmp(sram1).writeEnable;
	user_sram_control_o(sram2).cs					<= user_sram_control_tmp(sram2).cs;
	user_sram_control_o(sram2).writeEnable		<= user_sram_control_tmp(sram2).writeEnable;



   -- Multiplexing:             
   ----------------
	--===============================================================================================--
	process
	--===============================================================================================--
	begin
		wait until rising_edge(tx_frame_clk);
			
			--sram1
			--from cbc_i2c
			if 	cbc_i2c_user_sram_control(sram1).cs = '1' then
				user_sram_control_tmp(sram1).cs 				<= cbc_i2c_user_sram_control(sram1).cs;
				user_sram_control_tmp(sram1).writeEnable 	<= cbc_i2c_user_sram_control(sram1).writeEnable;
				user_sram_addr_tmp(sram1) 						<= cbc_i2c_user_sram_addr(sram1);							
				user_sram_wdata_tmp(sram1) 					<= cbc_i2c_user_sram_wdata(sram1);
			--from acq
			elsif CBC_user_sram_control(sram1).cs = '1' then
				user_sram_control_tmp(sram1).cs 				<= CBC_user_sram_control(sram1).cs;
				user_sram_control_tmp(sram1).writeEnable 	<= CBC_user_sram_control(sram1).writeEnable;
				user_sram_addr_tmp(sram1) 						<= CBC_user_sram_addr(sram1);							
				user_sram_wdata_tmp(sram1) 					<= CBC_user_sram_wdata(sram1);			
--			--from fe-gbt
--			elsif	gbt_sram_control(sram1).cs = '1' then
--				user_sram_control_tmp(sram1).cs 				<= gbt_sram_control(sram1).cs;
--				user_sram_control_tmp(sram1).writeEnable 	<= gbt_sram_control(sram1).writeEnable;
--				user_sram_addr_tmp(sram1) 						<= gbt_sram_addr(sram1);							
--				user_sram_wdata_tmp(sram1) 					<= gbt_sram_wdata(sram1);
			else
				user_sram_control_tmp(sram1).cs 				<= '0'; --DIS
				user_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
				user_sram_addr_tmp(sram1) 						<= (others=>'0');							
				user_sram_wdata_tmp(sram1) 					<= (others=>'0');
			end if;
			
			--sram2
			--from cbc_i2c
			if 	cbc_i2c_user_sram_control(sram2).cs = '1' then
				user_sram_control_tmp(sram2).cs 				<= cbc_i2c_user_sram_control(sram2).cs;
				user_sram_control_tmp(sram2).writeEnable 	<= cbc_i2c_user_sram_control(sram2).writeEnable;
				user_sram_addr_tmp(sram2) 						<= cbc_i2c_user_sram_addr(sram2);							
				user_sram_wdata_tmp(sram2) 					<= cbc_i2c_user_sram_wdata(sram2);
--			--from fe-gbt
--			if gbt_sram_control(sram2).cs = '1' then
--				user_sram_control_tmp(sram2).cs 				<= gbt_sram_control(sram2).cs;
--				user_sram_control_tmp(sram2).writeEnable 	<= gbt_sram_control(sram2).writeEnable;
--				user_sram_addr_tmp(sram2) 						<= gbt_sram_addr(sram2);							
--				user_sram_wdata_tmp(sram2) 					<= gbt_sram_wdata(sram2);
--			--from acq
			elsif CBC_user_sram_control(sram2).cs = '1' then
				user_sram_control_tmp(sram2).cs 				<= CBC_user_sram_control(sram2).cs;
				user_sram_control_tmp(sram2).writeEnable 	<= CBC_user_sram_control(sram2).writeEnable;
				user_sram_addr_tmp(sram2) 						<= CBC_user_sram_addr(sram2);							
				user_sram_wdata_tmp(sram2) 					<= CBC_user_sram_wdata(sram2);	
			else
				user_sram_control_tmp(sram2).cs 				<= '0'; --DIS
				user_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
				user_sram_addr_tmp(sram2) 						<= (others=>'0');							
				user_sram_wdata_tmp(sram2) 					<= (others=>'0');
			end if;	
	end process;

	--new
	CBC_user_sram_addr  	<= CBC_user_sram_addr_tmp1;
	CBC_user_sram_wdata 	<= CBC_user_sram_wdata_tmp1;







	--===================--
	-- TDC / TLL TRIGGER --
	--===================--





--	-- TDC_COUNTER:
--	---------------
--	
--	process
--	variable var_tdc_counter : unsigned(5 downto 0);
--	begin
--	wait until rising_edge(tdc_counter_clk);
--		if PC_config_ok = '0' then
--			var_tdc_counter := (others=>'0');
--		else
			
			

	--===============================================================================================--	
	ipcore_tdc_counter_inst : entity work.ipcore_tdc_counter --6b--ThreeBitCounter  --FourBitCounter or ThreeBitCounter
	--===============================================================================================--	
	PORT MAP (	clk 					=> tdc_counter_clk,
					--
					ce 					=> tlu_trigger_i, --ce_tdc_counter, --tlu_trigger_i, --tlu_trigger
					--
					sclr 					=> sclr_tdc_counter, --tlu_trigger_del(2), --TDC_COUNTER_FIFO_WR_EN, --L1A_VALID, --L1A_VALID_del1, --'0', 
					--
					q		 				=> TDC_COUNTER --TDC_COUNTER_FAST
				);
	--==============================================================================================--	
	--new
	process
	begin
	wait until rising_edge(tdc_counter_clk);
		if PC_config_ok = '0' then
			sclr_tdc_counter <= '1'; --EN
		else
			--correc1
			--sclr_tdc_counter <= tlu_trigger_del(0) and tlu_trigger_del(2);
			--correc2
			sclr_tdc_counter <= tlu_trigger_del(0) and tlu_trigger_del(1); 
		end if;
	end process;
	
	--new
	SRL16E_tlu_trigger_i_inst : SRL16E
   generic map (
      INIT => X"0000")
   port map (
      Q 			=> tlu_trigger_i_320M_del,       -- SRL data output
      A0 		=> '1',     -- Select[0] input
      A1 		=> '1',     -- Select[1] input
      A2 		=> '0',     -- Select[2] input
      A3 		=> '0',     -- Select[3] input
      CE 		=> '1',     -- Clock enable input
      CLK 		=> tdc_counter_clk,   -- Clock input
      D 			=> tlu_trigger_i        -- SRL data input
   );

 ce_tdc_counter <= tlu_trigger_i or tlu_trigger_i_320M_del;

	--===============================================================================================--
--	process
--	--===============================================================================================--
--	begin
--		wait until rising_edge(tdc_counter_clk);
--			if tlu_trigger_i = '1' then
--				TDC_COUNTER_FAST_latched <= TDC
--
--	--===============================================================================================--

	-- Resync  TDC_COUNTER :
	------------------------

	--===============================================================================================--
	from_gbt_Rx_data_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => TDC_COUNTER_BITS_NB) 
	port map 
	(
		wrclk_i							=> tdc_counter_clk,
		rdclk_i							=> tx_frame_clk, 
		wdata_i							=> TDC_COUNTER,
		rdata_o							=> TDC_COUNTER_resync
	); 
	--===============================================================================================--

							
		
		
	
	-- FIFO_TDC:
	------------

	--===============================================================================================--	
	ipcore_fifo_tdcCounter_inst : entity work.ipcore_fifo_tdcCounter --FIFO_TDC
	--===============================================================================================--	
	PORT MAP (	clk 					=> tx_frame_clk,
					--
					rst 					=> '0',
					--write
					din 					=> TDC_COUNTER_FIFO_DIN, --6b
					wr_en 				=> TDC_COUNTER_FIFO_WR_EN,
					wr_ack     	 		=> TDC_COUNTER_FIFO_WR_ACK,
					--read
					rd_en 				=> TDC_COUNTER_FIFO_RD_EN,
					dout 					=> TDC_COUNTER_FIFO_DOUT,--6b
					--flags
					full 					=> TDC_COUNTER_FIFO_FULL,
					empty 				=> TDC_COUNTER_FIFO_EMPTY,
					valid 				=> TDC_COUNTER_FIFO_VALID,
					prog_full 			=> TDC_COUNTER_FIFO_PROG_FULL,
					prog_empty 			=> TDC_COUNTER_FIFO_PROG_EMPTY
				);

	--TDC_COUNTER_FIFO_DIN 			<= "0000";
	--TDC_COUNTER_FIFO_WR_EN 			<= CBC_DATA_FIFO_WR_EN;
	TDC_COUNTER_FIFO_RD_EN 			<= RD_EN_FIFO_ALL; --common for all FIFOs
	--==============================================================================================--	


	-- FIFO_TDC CTRL:
	-----------------

	TDC_COUNTER_FIFO_DIN 	<= TDC_COUNTER_resync;
	--correc2
	TDC_COUNTER_FIFO_WR_EN	<= L1A_VALID;

--	--===============================================================================================--
--	fifo_tdcCounter_fsm_block : block						
--	--> FOR TDC_COUNTER
--	type FIFO_states is (		idle, 			wait_start,		write_data,		 		
--										write_OOS,		busy
--										);
--	signal FIFO_state : FIFO_states; 
--	--===============================================================================================--
--	begin 
--		--===============================================================================================--		
--		process (tx_frame_clk,PC_config_ok)--,BREAK_TRIGGER)-- FSM CTRL
--		--===============================================================================================--	
--		--variable wait_busy : integer range 0 to 7:=7;
--			begin	
--				--if PC_config_ok = '0' then	
--				if PC_config_ok = '0' then --or BREAK_TRIGGER = '1'  then				
--					FIFO_state 													<= idle;
--					TDC_COUNTER_FIFO_WR_EN 									<= '0';
--					FSM_FIFO_TDC_flag 										<= std_logic_vector(to_unsigned(0,8));
--					
--				elsif rising_edge(tx_frame_clk) then
--				--DATA to store
--				--TDC_COUNTER_FIFO_DIN 										<= TDC_COUNTER_resync; --'0'&TDC_COUNTER_resync ; --"0101"; --TDC_COUNTER_latched
--				--enable
--				--TDC_COUNTER_FIFO_WR_EN												<= L1A_VALID; --FIFO_CTRL_DELAY
--				--				
--					
--					case FIFO_state is
--						
--						when idle => 
--							TDC_COUNTER_FIFO_WR_EN 							<= '0';
--							FIFO_state 											<= wait_start;
--							FSM_FIFO_TDC_flag 								<= std_logic_vector(to_unsigned(1,8));			
--						
--						--when FSM_FIFO2_RAZ_FIFO2 => --dummy reading / test empty
--						
--						--
--						when wait_start =>
--							--
--							if (
--									CMD_START_BY_PC							= '1'
--									and ALL_FIFO_empty_ok 					= "11"
--								)
--							then		
--								FIFO_state 										<= write_data;
--							end if;
--							--
--							FSM_FIFO_TDC_flag 								<= std_logic_vector(to_unsigned(2,8));
--						
--						--
--						when write_data =>
--							--condition for OOS
--							if condition_oos = '1' then
--								FIFO_state 										<= write_OOS;	
----							--condition full fifo
----							elsif TDC_COUNTER_FIFO_FULL = '1' then --100%
--							--condition partial full fifo
--							elsif TDC_COUNTER_FIFO_PROG_FULL = '1' then  --90%
--								FIFO_state 										<= busy;						
--							--> storage in continue by def
--							--elsif L1A_VALID_del1 = '1' then 
--							elsif L1A_VALID = '1' then
--								TDC_COUNTER_FIFO_WR_EN 							<= '1';
--							else
--								TDC_COUNTER_FIFO_WR_EN 							<= '0';							
--							end if;
--							--						
--							FSM_FIFO_TDC_flag 								<= std_logic_vector(to_unsigned(3,8));
--						
--						--
--						when write_OOS => 
--							--
--							if TDC_COUNTER_FIFO_FULL = '1' then
--								TDC_COUNTER_FIFO_WR_EN 							<= '0';
--							else
--								TDC_COUNTER_FIFO_WR_EN 							<= '1'; --write in continue to fill-in FIFO
--							end if;						
--							--
--							FSM_FIFO_TDC_flag 								<= std_logic_vector(to_unsigned(5,8));
--					
--						--
--						when busy => 
--							--condition for OOS
--							if condition_oos = '1' then
--								FIFO_state 										<= write_OOS;	
--							--
--							elsif ( 	ALL_FIFOS_ARE_EMPTY					= '1'
--									)
--							then
--								FIFO_state 										<= write_data;
--								--TDC_COUNTER_FIFO_WR_EN 						<= L1A_VALID_del1; --L1A_VALID; --if simultané???
--								TDC_COUNTER_FIFO_WR_EN 						<= L1A_VALID;
--							--
--	--						elsif L1A_VALID_del1 = '1' then --L1A_VALID = '1' then
--	--							TDC_COUNTER_FIFO_WR_EN 							<= '1';
--							--
--							else
--								TDC_COUNTER_FIFO_WR_EN 							<= '0';								
--							end if;						
--							--
--							FSM_FIFO_TDC_flag 								<= std_logic_vector(to_unsigned(4,8));			
--					--	
--					end case;
--				end if;
--		end process;
--	end block;
--		--===============================================================================================--	
--		---------------******************************END FIFO TDC STORAGE**********************************----------------	

	--===============================================================================================--
	process
	--===============================================================================================--
	begin
	--if PC_config_ok = '0' then	
	wait until rising_edge(tx_frame_clk);
		--
		if (
				TIME_TRIGGER_FIFO_EMPTY	  			= '1'			
				and CBC_COUNTER_FIFO_EMPTY(0,0) 	= '1'	
				--
--				and CBC_DATA_FIFO_EMPTY(0,0)  	= '1'
--				and CBC_DATA_FIFO_EMPTY(0,1)  	= '1'
--				and CBC_DATA_FIFO_EMPTY(1,0)  	= '1'
--				and CBC_DATA_FIFO_EMPTY(1,1)  	= '1'
				and busAND_array_FE_NBxCBC_NBx1bit(CBC_DATA_FIFO_EMPTY, FE_NB, CBC_NB) = '1' 
				--
--				and CBC_STUBDATA_FIFO_EMPTY(0)  	= '1'
--				and CBC_STUBDATA_FIFO_EMPTY(1)	= '1'	
				and busAND_array_FE_NBx1bit(CBC_STUBDATA_FIFO_EMPTY, FE_NB) = '1'				
				--

				and TDC_COUNTER_FIFO_EMPTY			= '1'
			)
		then
			ALL_FIFOS_ARE_EMPTY 						<= '1';
		else
			ALL_FIFOS_ARE_EMPTY 						<= '0';	
		end if;
		--

		--
		if (
				TIME_TRIGGER_FIFO_EMPTY	  			= '0'			
				and CBC_COUNTER_FIFO_EMPTY(0,0) 	= '0'	
				--
--				and CBC_DATA_FIFO_EMPTY(0,0)  	= '0'
--				and CBC_DATA_FIFO_EMPTY(0,1)  	= '0'
--				and CBC_DATA_FIFO_EMPTY(1,0)  	= '0'
--				and CBC_DATA_FIFO_EMPTY(1,1)  	= '0'
				and busAND_array_FE_NBxCBC_NBx1bit(CBC_DATA_FIFO_EMPTY, FE_NB, CBC_NB) = '0' 				
				--
--				and CBC_STUBDATA_FIFO_EMPTY(0)  	= '0'
--				and CBC_STUBDATA_FIFO_EMPTY(1)	= '0'
				and busAND_array_FE_NBx1bit(CBC_STUBDATA_FIFO_EMPTY, FE_NB) = '0'									
				--

				and TDC_COUNTER_FIFO_EMPTY			= '0'
			)
		then
			ALL_FIFOS_ARE_NOT_EMPTY 				<= '1';
		else
			ALL_FIFOS_ARE_NOT_EMPTY 				<= '0';	
		end if;
		--
		
	end process;
	--===============================================================================================--										

			
			
	--new dev 10-06-14


	
--	EXT_TRIG_CARD_TRUE_GEN : if EXT_TRIG_CARD = true generate
--   begin
--		--CMOS
--		fmc_io_pin_dir_p_inv.la(fmc2) <= not fmc_io_pin_dir_p.la(fmc2);	
--		fmc_io_pin_dir_n_inv.la(fmc2) <= not fmc_io_pin_dir_n.la(fmc2);		
--	
--		--CASE 1 : TTC_FMC
--		TTC_FMC_TRUE_GEN : if TTC_FMC = true generate
--			--dir settings
--			fmc_io_pin_dir_p.la(fmc2) <= x"FD210000" & "00"; --from 0 to 33
--			fmc_io_pin_dir_n.la(fmc2) <= x"FD200000" & "00"; --from 0 to 33			
--			--P side
--			FMC2_LA_P_IOBUF_gen : for i in 0 to 33 generate		
--				io_cmos_p : iobuf 	
--				generic map 
--				(
--					capacitance 		=> "dont_care", 
--					drive 				=> 12, 
--					ibuf_delay_value 	=> "0", 
--					ibuf_low_pwr 		=> true, 
--					ifd_delay_value 	=> "auto", 
--					iostandard			=> "lvcmos25", 
--					slew 					=> "slow"
--				)
--				port map 
--				(
--					i 						=> fmc_from_pin_to_fabric_p_array.la(fmc2)(i),     	-- Buffer output
--					t 						=> fmc_io_pin_dir_p_inv_array(fmc2)(i), 		-- 3-state enable input, high=input, low=output
--					o 						=> fmc_from_fabric_to_pin_p_array.la(fmc2)(i), 		-- Buffer input
--					io 					=> fmc2_io_pin.la_p(i)								-- p inout (connect directly to top-level port)
--				);
--			end generate;
--			--N side
--			FMC2_LA_N_IOBUF_gen : for i in 0 to 33 generate		
--				io_cmos_n : iobuf 	
--				generic map 
--				(
--					capacitance 		=> "dont_care", 
--					drive 				=> 12, 
--					ibuf_delay_value 	=> "0", 
--					ibuf_low_pwr 		=> true, 
--					ifd_delay_value 	=> "auto", 
--					iostandard			=> "lvcmos25", 
--					slew 					=> "slow"
--				)
--				port map 
--				(
--					i 						=> fmc_from_pin_to_fabric_n_array.la(fmc2)(i),     	-- Buffer output
--					t 						=> fmc_io_pin_dir_n_inv_array(fmc2)(i), 		-- 3-state enable input, high=input, low=output
--					o 						=> fmc_from_fabric_to_pin_n_array.la(fmc2)(i), 		-- Buffer input
--					io 					=> fmc2_io_pin.la_n(i)								-- n inout (connect directly to top-level port)
--				);
--			end generate;
--		--END CASE 1 : TTC_FMC
--		end generate;
--		--CASE 2 : FMC_DIO
--
--		
--	--END CASE : EXT_TRIG_CARD			
--	end generate;
--	
--
--	EXT_TRIG_CARD_FALSE_GEN : if EXT_TRIG_CARD = false generate
--   begin
--		FMC2_LA_LVDS_gen : for i in 0 to 33 generate
--			IOBUFDS_inst : IOBUFDS
--			generic map (
--							IOSTANDARD => "BLVDS_25"
--							)
--			port map 	(
--							O 			=> fmc_from_fabric_to_pin_lvds_array.la(fmc2)(i),     	-- Buffer output
--							IO 		=> fmc2_io_pin.la_p(i), 							-- Diff_p inout (connect directly to top-level port)
--							IOB 		=> fmc2_io_pin.la_n(i), 							-- Diff_n inout (connect directly to top-level port)
--							I 			=> fmc_from_pin_to_fabric_array.la(fmc2)(i),     	-- Buffer input
--							T 			=> fmc_io_pin_dir_lvds_inv.la(fmc2)(i)      		-- 3-state enable input, high=input, low=output
--							);		
--		end generate;
--	end generate;
--
--	FMC1_LA_LVDS_gen : for i in 0 to 33 generate
--		IOBUFDS_inst : IOBUFDS
--		generic map (
--						IOSTANDARD => "BLVDS_25"
--						)
--		port map 	(
--						O 			=> fmc_from_fabric_to_pin_lvds_array(fmc1).la(i),     	-- Buffer output
--						IO 		=> fmc1_io_pin.la_p(i), 							-- Diff_p inout (connect directly to top-level port)
--						IOB 		=> fmc1_io_pin.la_n(i), 							-- Diff_n inout (connect directly to top-level port)
--						I 			=> fmc_from_pin_to_fabric_array(fmc1).la(i),     	-- Buffer input
--						T 			=> fmc_io_pin_dir_lvds_inv.la(fmc1)(i)      		-- 3-state enable input, high=input, low=output
--						);		
--	end generate;
--
--	
--
--	--NOT OP
--	--> By def fmc_io_pin_dir_lvds = '0' => fmc_io_pin_dir_lvds_inv = '1' (IN MODE)
--	--LVDS
--	fmc_io_pin_dir_lvds_inv.la(fmc1) <= not fmc_io_pin_dir_lvds.la(fmc1);
--	fmc_io_pin_dir_lvds_inv.la(fmc2) <= not fmc_io_pin_dir_lvds.la(fmc2);
----	--CMOS
----	fmc_io_pin_dir_p_inv.la(fmc1) <= not fmc_io_pin_dir_p.la(fmc1);	
----	fmc_io_pin_dir_n_inv.la(fmc1) <= not fmc_io_pin_dir_n.la(fmc1);
----	fmc_io_pin_dir_p_inv.la(fmc2) <= not fmc_io_pin_dir_p.la(fmc2);	
----	fmc_io_pin_dir_n_inv.la(fmc2) <= not fmc_io_pin_dir_n.la(fmc2);
--	
--
--	process (USER_HYBRIDE_TYPE) 
--	begin
--		--0 : IN / 1 : OUT
--		if 	USER_HYBRIDE_TYPE = 1 then 	--2 : Dual CBC2 = 2xCBC2
--			fmc_io_pin_dir_lvds.la(fmc1) <= x"00011CCB" & "10"; --from 0 to 33
--			fmc_io_pin_dir_lvds.la(fmc2) <= x"00011CCB" & "10"; --from 0 to 33	
--		elsif USER_HYBRIDE_TYPE = 2 then 	--8 : 8xCBC2 
--			fmc_io_pin_dir_lvds.la(fmc1) <= x"EFA08104" & "00"; --from 0 to 33
--			fmc_io_pin_dir_lvds.la(fmc2) <= x"EFA08104" & "00"; --from 0 to 33	
--		else --IN by def
--			fmc_io_pin_dir_lvds.la(fmc1) <= x"00000000" & "00"; --from 0 to 33
--			fmc_io_pin_dir_lvds.la(fmc2) <= x"00000000" & "00"; --from 0 to 33				
--		--elsif USER_HYBRIDE_TYPE = 2 --16 : 16xCBC2
--		end if;
--	end process;	
--	
----	process (USER_FE_NB, USER_HYBRIDE_TYPE) -- EXT_TRIG_CARD, TTC_FMC, FMC_DIO)
----	begin
----		if 	USER_FE_NB = 2 then --0 : IN / 1 : OUT
----			if 	USER_HYBRIDE_TYPE = 0 then	--2 : Dual CBC2 or 2xCBC2
----				fmc_io_pin_dir_lvds.la(fmc1) <= x"00011ccb"&"10"; --from 0 to 33
----				fmc_io_pin_dir_lvds.la(fmc2) <= x"00011ccb"&"10"; --from 0 to 33	
----			elsif USER_HYBRIDE_TYPE = 1 then	--8 : 8xCBC2 
----				fmc_io_pin_dir_lvds.la(fmc1) <= x"efa08104"&"00"; --from 0 to 33
----				fmc_io_pin_dir_lvds.la(fmc2) <= x"efa08104"&"00"; --from 0 to 33		
----			--elsif USER_HYBRIDE_TYPE = 2 --16 : 16xCBC2
----			end if;
----		elsif USER_FE_NB = 1 then --0 : IN / 1 : OUT
----			--fmc1 = J2
----			if 	USER_HYBRIDE_TYPE = 0 then	--2 : Dual CBC2 or 2xCBC2
----				fmc_io_pin_dir_lvds.la(fmc1) <= x"00011ccb"&"10"; --from 0 to 33
----			elsif USER_HYBRIDE_TYPE = 1 then	--8 : 8xCBC2 
----				fmc_io_pin_dir_lvds.la(fmc1) <= x"efa08104"&"00"; --from 0 to 33	
----			--elsif USER_HYBRIDE_TYPE = 2 --16 : 16xCBC2
----			end if;	
------			--fmc2
------			if EXT_TRIG_CARD = true then
------				if TTC_FMC = true then
------					--dir settings
------					fmc_io_pin_dir_p.la(fmc2) <= x"FD210000" & "00"; --from 0 to 33
------					fmc_io_pin_dir_n.la(fmc2) <= x"FD200000" & "00"; --from 0 to 33	
------				elsif FMC_DIO = true then
------					fmc_io_pin_dir_p.la(fmc2) <= x"00000000" & "00"; --from 0 to 33
------					fmc_io_pin_dir_n.la(fmc2) <= x"00000000" & "00"; --from 0 to 33
------				end if;
------			end if;
----		end if;
----	end process;
--			
	
	

	--===============================================================================================--
	fmc1_map: entity work.fmc_io_buffers
	--===============================================================================================--
	generic map
	(
		fmc_la_io_settings		=> fmc_la_io_settings_8cbc2_constants, --fmc_la_io_settings_8cbc2_constants, --fmc_la_io_settings_2cbc2_constants, --fmc_la_io_settings_lvds_bidir_constants, fmc_la_io_settings_2cbc2_constants, fmc_la_io_settings_8cbc2_constants
		fmc_ha_io_settings		=> fmc_ha_io_settings_defaults, 	--fmc_ha_io_settings_cbc_constants
		fmc_hb_io_settings		=> fmc_hb_io_settings_defaults 	--fmc_hb_io_settings_cbc_constants
	)
	port map
	(
		fmc_io_pin					=> fmc1_io_pin,
		fmc_from_fabric_to_pin	=> fmc_from_fabric_to_pin_array(fmc1_j2),
		fmc_from_pin_to_fabric	=> fmc_from_pin_to_fabric_array(fmc1_j2)
	);                    	
	--===============================================================================================--

	
	--===============================================================================================--
	fmc2_map: entity work.fmc_io_buffers
	--===============================================================================================--
	generic map
	(
		fmc_la_io_settings		=> fmc_la_io_settings_ttc_constants,
		fmc_ha_io_settings		=> fmc_ha_io_settings_defaults, 	--fmc_ha_io_settings_ttc_constants
		fmc_hb_io_settings		=> fmc_hb_io_settings_defaults 	--fmc_hb_io_settings_ttc_constants
	)
	port map
	(
		fmc_io_pin					=> fmc2_io_pin,
		fmc_from_fabric_to_pin	=> fmc_from_fabric_to_pin_array(fmc2_j1),
		fmc_from_pin_to_fabric	=> fmc_from_pin_to_fabric_array(fmc2_j1)
	);                    	
	--===============================================================================================--

--	fmc_from_pin_to_fabric_array(fmc1_j2).la_lvds()
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds()
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l()
--	fmc_from_pin_to_fabric_array(fmc1_j2).la_cmos_p()
--	fmc_from_pin_to_fabric_array(fmc1_j2).la_cmos_n()
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_cmos_p()
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_cmos_n()	
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_cmos_p_oe_l()
--	fmc_from_fabric_to_pin_array(fmc1_j2).la_cmos_n_oe_l()	
		

--	fmc_from_fabric_to_pin_array.la_lvds_oe_l(fmc1) <= not fmc_io_pin_dir_lvds.la(fmc1);
--	fmc_from_fabric_to_pin_array.la_lvds_oe_l(fmc2) <= not fmc_io_pin_dir_lvds.la(fmc2);	
	--or
	--attribute init of fmc_from_fabric_to_pin_array.la_lvds_oe_l(fmc1): signal is "1"; --IN MODE 
	--attribute init of fmc_from_fabric_to_pin_array.la_lvds_oe_l(fmc2): signal is "1"; --IN MODE 	


	--direct 2xcbc2
	--fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"FFFEE334"&"01"; --from 0 to 33







--
--	--mux
--	process (USER_HYBRIDE_TYPE) 
--	begin
--		--1 : IN / 0 : OUT
--		if 	USER_HYBRIDE_TYPE = 1 then 	--1 : Dual CBC2 = 2xCBC2
--		--if 	to_integer(unsigned(USER_HYBRIDE_TYPE)) = 1 then
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"FFFEE334"&"01"; --from 0 to 33	
--		elsif	USER_HYBRIDE_TYPE = 2 then		--2 : 8xCBC2
--		--elsif	to_integer(unsigned(USER_HYBRIDE_TYPE)) = 2 then	
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"105F7EFB"&"11"; --from 0 to 33
--		else --IN by def
--			fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"FFFFFFFF"&"11"; --from 0 to 33			
--		end if;
--	end process;	


	--decomment if ised bufio_bidir	
	--Dual CBC2 = 2xCBC2
	--fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"FFFEE334"&"01"; --from 0 to 33	
	--Dual CBC2 = 8xCBC2
	fmc_from_fabric_to_pin_array(fmc1_j2).la_lvds_oe_l	<= x"105F7EFB"&"11"; --from 0 to 33		
	
	
	
	
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_p_oe_l(7)	<= '1'; --DIS
	fmc_from_fabric_to_pin_array(fmc2_j1).la_cmos_n_oe_l(7)	<= '1'; --DIS
	--> fmc2_from_fabric_to_pin.la_cmos_p_oe_l(7) & fmc2_from_fabric_to_pin.la_cmos_n_oe_l(7) DIS



	process(USER_HYBRIDE_TYPE)
	begin
		if 	USER_HYBRIDE_TYPE = 1 then
		--if 	to_integer(unsigned(USER_HYBRIDE_TYPE)) = 1 then
			--USER_CBC_NB <= std_logic_vector(to_unsigned(2,8));
			USER_CBC_NB <= 2;
		elsif USER_HYBRIDE_TYPE = 2 then
			USER_CBC_NB <= 8;
		elsif USER_HYBRIDE_TYPE = 3 then
			USER_CBC_NB <= 16;
		else
			USER_CBC_NB <= 2;	
		end if;
	end process;

	USER_FE_NB <= 1 when EXT_TRIG_CARD = TRUE else 2;

	CBC_MASK_TMP(0) <= ttc_fmc_regs_from_wb(20)(CBC_NB-1 downto 0);

	
	--CBC_MASK(1) <=
	--USER_FE_NB <= to_integer(unsigned(param)
	--USER_CBC_NB <= to_integer(unsigned(param)
	--faire jouer USER_X sur resdout final
	
end user_logic_arch;