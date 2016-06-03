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
use work.vendor_specific_gbt_link_package.all;


--fmc configuration
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
  
   --=====================================================================================--       
   
   --================================ Signal Declarations ================================--


   --===============--
   -- FMC INTERFACE --
   --===============--

	signal fmc1_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc1_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;
	
	signal fmc2_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc2_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;
	



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
   
   --===========================--
   -- GBT Link reference design --
   --===========================--
   
   -- Control:
   -----------
   
   signal reset_from_user                       : std_logic:='0'; --'1'     
   signal clkMuxSel_from_user                   : std_logic;       
   signal testPatterSel_from_user               : std_logic_vector(1 downto 0):="00"; --"01"
   signal loopback_from_user                    : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user      : std_logic; 
   signal resetGbtRxReadyLostFlag_from_user     : std_logic; 
   signal headerSelector_from_user              : std_logic;   
   signal encodingSelector_from_user            : std_logic_vector(1 downto 0):="00"; 
	
	attribute init: string;
--	--lcharles
--	attribute init of  reset_from_user					: signal is "1";
--	attribute init of  testPatterSel_from_user		: signal is "01";
   
   -- Status:                                   
   ----------                                   
   
   signal latencyOptGbtLink_from_gbtRefDesign   : std_logic;
   signal rxHeaderLocked_from_gbtRefDesign      : std_logic;
   signal rxBitSlipNbr_from_gbtRefDesign        : std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
   signal rxWordClkAligned_from_gbtRefDesign    : std_logic; 
   signal mgtReady_from_gbtRefDesign            : std_logic; 
   signal gbtRxReady_from_gbtRefDesign          : std_logic;    
   signal rxFrameClkAligned_from_gbtRefDesign   : std_logic; 
   signal rxHeaderIsDataFlag_from_gbtRefDesign  : std_logic;        
   signal gbtRxReadyLostFlag_from_gbtRefDesign  : std_logic; 
   signal commDataErrSeen_from_gbtRefDesign     : std_logic; 
   signal widebusDataErrSeen_from_gbtRefDesign  : std_logic; 
   
   -- Data:
   --------
   
   signal txCommonData_from_gbtRefDesign        : std_logic_vector(83 downto 0);
   signal rxCommonData_from_gbtRefDesign        : std_logic_vector(83 downto 0);
   
   signal txWidebusExtraData_from_gbtRefDesign  : std_logic_vector(31 downto 0);
   signal rxWidebusExtraData_from_gbtRefDesign  : std_logic_vector(31 downto 0);
   
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
   
   signal txFrameClk_from_gbtRefDesign          : std_logic;
   signal rxFrameClk_from_gbtRefDesign          : std_logic;
   signal txWordClk_from_gbtRefDesign           : std_logic;
   signal rxWordClk_from_gbtRefDesign           : std_logic;
                                       
   signal txMatchFlag_from_gbtRefDesign         : std_logic;
   signal rxMatchFlag_from_gbtRefDesign         : std_logic;
   
  
 
	--lcharles
	
	--===============--
   -- MGT GBT RESET --
   --================--		
	-- User Indivudual Resets
	signal mgt_TxReset_from_user : std_logic := '0';
	signal gbt_TxReset_from_user : std_logic := '0';	
	signal mgt_RxReset_from_user : std_logic := '0';
	signal gbt_RxReset_from_user : std_logic := '0';	
	

   signal from_gbtRx_data_resync       			: std_logic_vector(83 downto 0);	
	
	signal to_gbtTx_from_user : std_logic_vector(83 downto 0):=x"aaaaaaaaaaaaaaaaaaaaa";	

 
	--RESYNC
	
	signal sec_clk_o_tmp 			: std_logic:='0';	
	signal user_cdce_refsel 		: std_logic:='0';		
	signal user_cdce_sync_o_tmp 	: std_logic:='0';	


	--frame clk 40M
	signal cdce_out4_40M 				: std_logic:='0';	
	signal cdce_out4_mmcm_40M_reset 	: std_logic:='0';
	signal cdce_out4_mmcm_40M_lock 	: std_logic:='0';		
	
	
	signal startup_clk 					: std_logic := '0';
	

	--==============--
   -- tx_frame_clk --
   --===============--		
	signal tx_frame_clk : std_logic := '0';	
	

	--====================--
   -- CDCE CLK SWITCHING --
   --====================--	
	signal xpoint1_clk3_bug				: std_logic:='0';
	signal user_gbt_dec_i_reset		: std_logic:='0';	 
	signal user_gtx_i_rx_reset			: std_logic:='0';		
	signal user_gtx_i_rx_sync_reset	: std_logic:='0';	

	constant STARTUP_state_flag_bitsNb : positive := 4;
	signal STARTUP_state_flag	: std_logic_vector(STARTUP_state_flag_bitsNb-1 downto 0):=(others=>'0');	

	type STARTUP_states is (		idle, 			state1, 		state2, 		state3,
											state4,			state5,		state6,		state7
											);
	signal STARTUP_state : STARTUP_states;			
	


	signal gbt_RxReset_from_user_CtrlSwitch : std_logic := '0';

	
	--
	signal sync_ok_fe2be : std_logic := '0';	

	signal switchWaitTime1    	: std_logic_vector(3 downto 0):=x"a";
	signal switchWaitTime2 		: std_logic_vector(3 downto 0):=x"a";
	attribute init of  switchWaitTime1		: signal is "a";
	attribute init of  switchWaitTime2		: signal is "a";
	
	signal fe_resync_reset_ipbus 	: std_logic := '0';



	--reset by ipbus
	signal mgt_TxReset_from_user_ipbus 	: std_logic:='0';
	signal gbt_TxReset_from_user_ipbus 	: std_logic:='0';
	signal mgt_RxReset_from_user_ipbus 	: std_logic:='0';
	signal gbt_RxReset_from_user_ipbus 	: std_logic:='0';
	 
 
 
	--============--
   -- PARAMETERS --
   --============--	
	
	-- registers mapping:           
	--------------------- 	 
	-- control:           
	-----------	
	signal FPGA_CLKOUT_MUXSEL 			: std_logic:='0'; 

	signal ILA_TRIG1_SEL 				: std_logic:='0'; 

	--===========--
   -- Chipscope --
   --===========--
	constant DATA_ILA_BITS_NBR : positive:= 208;--208;--40; 
	signal CONTROL0 		: std_logic_vector(35 downto 0):=(others=>'0');
	signal DATA_ILA_TEST : std_logic_vector(DATA_ILA_BITS_NBR-1 downto 0):=(others=>'0');
	signal DATA_ILA_TEST_TMP : std_logic_vector(DATA_ILA_BITS_NBR-1 downto 0):=(others=>'0');	
	signal TRIGGER_ILA_TEST : std_logic:='0';
	signal CLK_ILA_TEST : std_logic:='0';
	signal ILA_TRIG0 : std_logic_vector(83 downto 0):=(others=>'0');
	signal ILA_TRIG1 : std_logic_vector(83 downto 0):=(others=>'0');
	signal ILA_TRIG2 : std_logic_vector(86 downto 0):=(others=>'0');
	signal ILA_TRIG3 : std_logic_vector(86 downto 0):=(others=>'0');

	
	signal user_sram_control_tmp : userSramControlR_array(1 to 2);
	signal user_sram_addr_tmp : array_2x21bit;							
	signal user_sram_wdata_tmp : array_2x36bit;

	




	constant CBC_NB 														: positive := 2;
	constant FE_NB 														: positive := 2; --1 or 2


	--arrays declaration
	type array_FE_NBx1bit 												is array(FE_NB-1 downto 0) 										of std_logic;
	--
	type array_FE_NBxCBC_NBx1bit 										is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic;





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
	--> DC-DC
	signal cbc_clk_dcdc						: array_FE_NBx1bit;	--CLK_DCDC_LVDS


 
	--===============--
   -- End Dual CBC2 --
   --===============--



	---------------********************************PARAMETERS************************************----------------	
	----> registers mapping
	signal user_fe_regs_from_wb 			: array_32x32bit; --array_32x32bit see system_package
	signal user_fe_regs_to_wb 				: array_32x32bit;	


	----> CBC
	--
	signal CBC_RESET_SEL 					: std_logic_vector(1 downto 0) 	:= (others=>'0');
	--I2C / SW interface 
	signal cbc_ctrl_i2c_settings			: std_logic_vector(31 downto 0)	:=(others=>'0');	
	signal cbc_ctrl_i2c_command			: std_logic_vector(31 downto 0)	:=(others=>'0');	
	signal cbc_ctrl_i2c_reply				: std_logic_vector(31 downto 0)	:=(others=>'0');	
	signal cbc_ctrl_i2c_done 				: std_logic 							:= '0';
--	---------------******************************END PARAMETERS**********************************----------------	


	

	--GBT DATA INTERFACE
	signal FE_REG_CTRL 	: array_REG_CTRL_WORD_DEPTHx32;
	signal FE_REG_STATUS : array_REG_STATUS_WORD_DEPTHx32;

	--gbt_sram
	--system_flash_sram_package.vhd
	signal gbt_sram_control					: userSramControlR_array(1 to 2);
	signal gbt_sram_addr						: array_2x21bit;									
	signal gbt_sram_wdata					: array_2x36bit;	
	

	--cbc_i2c
	--system_flash_sram_package.vhd
	signal cbc_i2c_user_sram_control		: userSramControlR; 
	signal cbc_i2c_user_sram_addr			: std_logic_vector(20 downto 0); --array_2x21bit							
	signal cbc_i2c_user_sram_rdata		: std_logic_vector(35 downto 0); --array_2x36bit		
	signal cbc_i2c_user_sram_wdata		: std_logic_vector(35 downto 0); --array_2x36bit

	

	--Parameter Word for Test
	signal cbc_i2c_param_word_i		: std_logic_vector(31 downto 0) := (others=>'0');
	signal cbc_i2c_param_word_o		: std_logic_vector(31 downto 0) := (others=>'0');
	signal cbc_i2c_cmd_rq				: std_logic_vector(1 downto 0)  := (others=>'0');	



	--modif / i2c ctrl
	signal to_gbtTx_cbc 							: std_logic_vector(83 downto 0);
	signal to_gbtTx_from_gbtDataInterface 	: std_logic_vector(83 downto 0);
	signal cbc_clk_dcdc_from_be 				: array_FE_NBx1bit;
	
	
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



	---------------********************************FMC_IO************************************----------------
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
	---------------******************************END FMC_IO**********************************----------------


     
   
   --==================================== User Logic =====================================--
   
   --===============--
   -- General reset -- 
   --===============--
   
   --reset_from_or_gate                           <= RESET_I or reset_from_user;   
   --lcharles
   reset_from_or_gate                           <= RESET_I or reset_from_user;--or fe_resync_reset_ipbus; 	
	
	
   --===============--
   -- Clock buffers -- 
   --===============--   

   -- Fabric clock (40MHz):
   ------------------------       
   
   xpSw1clk3_ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                           => FALSE,
         IOSTANDARD                             => "LVDS_25")
      port map (                 
         O                                      => xpoint1_clk3,
         I                                      => XPOINT1_CLK3_P,
         IB                                     => XPOINT1_CLK3_N
      );
      
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
   
   gbtRefDesign: entity work.xlx_v6_gbt_ref_design
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                        => reset_from_or_gate, 
			-- User Indivudual Resets - lcharles
			MGT_TXRESET_FROM_USER_I						=> mgt_TxReset_from_user,
			MGT_RXRESET_FROM_USER_I						=> mgt_RxReset_from_user,
			GBT_TXRESET_FROM_USER_I						=> gbt_TxReset_from_user,
			GBT_RXRESET_FROM_USER_I						=> gbt_RxReset_from_user,			
         -- Clocks scheme:                      
         MGT_REFCLKS_I                          => (tx => cdce_out0, rx => cdce_out0),              
         TX_FRAME_CLK_I                         => tx_frame_clk, --xpoint1_clk3,  -->lcharles        
         -- Serial lanes:                       
         MGT_TX_P                               => SFP_TX_P(1),                
         MGT_TX_N                               => SFP_TX_N(1),                
         MGT_RX_P                               => SFP_RX_P(1),                 
         MGT_RX_N                               => SFP_RX_N(1),
         -- GBT Link control:                   
         LOOPBACK_I                             => loopback_from_user,  
         ENCODING_SELECTOR_I                    => encodingSelector_from_user,
         HEADER_SELECTOR_I                      => headerSelector_from_user,                 
         -- GBT Link status:                    
         LATENCY_OPT_GBTLINK_O                  => latencyOptGbtLink_from_gbtRefDesign,             
         MGT_READY_O                            => mgtReady_from_gbtRefDesign,             
         RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_gbtRefDesign,
         RX_BITSLIP_NUMBER_O                    => rxBitSlipNbr_from_gbtRefDesign,            
         RX_WORD_CLK_ALIGNED_O                  => rxWordClkAligned_from_gbtRefDesign,           
         RX_FRAMECLK_ALIGNED_O                  => rxFrameClkAligned_from_gbtRefDesign,            
         GBT_RX_READY_O                         => gbtRxReady_from_gbtRefDesign,
         RX_HEADER_ISDATAFLAG_O                 => rxHeaderIsDataFlag_from_gbtRefDesign,            
         -- GBT Link data:                      
         TX_DATA_O                              => txCommonData_from_gbtRefDesign,            
         TX_WIDEBUS_EXTRA_DATA_O                => txWidebusExtraData_from_gbtRefDesign,
         ---------------------------------------
         RX_DATA_O                              => rxCommonData_from_gbtRefDesign,           
         RX_WIDEBUS_EXTRA_DATA_O                => rxWidebusExtraData_from_gbtRefDesign,
         -- Test control & status:              
         TEST_PATTERN_SEL_I                     => testPatterSel_from_user,        
         ---------------------------------------                    
         RESET_DATA_ERROR_SEEN_FLAG_I           => resetDataErrorSeenFlag_from_user,     
         RESET_GBT_RX_READY_LOST_FLAG_I         => resetGbtRxReadyLostFlag_from_user,     
         ---------------------------------------                    
         GBT_RX_READY_LOST_FLAG_O               => gbtRxReadyLostFlag_from_gbtRefDesign,       
         COMMONDATA_ERROR_SEEN_FLAG_O           => commDataErrSeen_from_gbtRefDesign,      
         WIDEBUSDATA_ERROR_SEEN_FLAG_O          => widebusDataErrSeen_from_gbtRefDesign,      
         -- Latency measurement:                
         TX_FRAMECLK_O                          => txFrameClk_from_gbtRefDesign,   -- Comment: This clock is "xpoint1_clk3"          
         RX_FRAMECLK_O                          => rxFrameClk_from_gbtRefDesign,         
         TX_WORDCLK_O                           => txWordClk_from_gbtRefDesign,          
         RX_WORDCLK_O                           => rxWordClk_from_gbtRefDesign,          
         ---------------------------------------                
         TX_MATCHFLAG_O                         => txMatchFlag_from_gbtRefDesign,          
         RX_MATCHFLAG_O                         => rxMatchFlag_from_gbtRefDesign,
			---------------------------------------(lcharles)
			to_gbtTx_from_user_i							=> to_gbtTx_from_user,
			be_fe_sync_done_i								=> sync_ok_fe2be  			
      );                                        
   
   --=======================--   
   -- Test control & status --   
   --=======================--      
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 
         
   cdceLockedReg: process(reset_from_or_gate, xpoint1_clk3_bug)
   begin
      if reset_from_or_gate = '1' then
         userCdceLocked_r                       <= '0';
      elsif rising_edge(xpoint1_clk3_bug) then
         userCdceLocked_r                       <= USER_CDCE_LOCKED_I;
      end if;
   end process;   




   -- Signals mapping:
   -------------------
	--===============================================================================================--
	user_fe_wb_regs_inst: entity work.user_fe_wb_regs --registers mapping
	--===============================================================================================--
	port map 
	(
		wb_mosi	=> wb_mosi_i(user_wb_fe),
		wb_miso 	=> wb_miso_o(user_wb_fe),	
		regs_o 	=> user_fe_regs_from_wb, 
		regs_i 	=> user_fe_regs_to_wb
	);
	--===============================================================================================--			


   -- Control:
   reset_from_user							<= user_fe_regs_from_wb(3)(0);
	FPGA_CLKOUT_MUXSEL						<= user_fe_regs_from_wb(3)(1);	
	testPatterSel_from_user					<= user_fe_regs_from_wb(3)(3 downto 2); --by def "10" 
	loopback_from_user						<= user_fe_regs_from_wb(3)(6 downto 4); --by def "000"
	encodingSelector_from_user	 			<= "00"; --GBT Frames by def
	resetDataErrorSeenFlag_from_user		<= user_fe_regs_from_wb(3)(7); --not used
	resetGbtRxReadyLostFlag_from_user	<= user_fe_regs_from_wb(3)(8); --not used
	--
	mgt_TxReset_from_user_ipbus			<= user_fe_regs_from_wb(3)(9);  --by def '0'
	gbt_TxReset_from_user_ipbus			<= user_fe_regs_from_wb(3)(10); --by def '0'	
	mgt_RxReset_from_user_ipbus			<= user_fe_regs_from_wb(3)(11); --by def '0'
	gbt_RxReset_from_user_ipbus			<= user_fe_regs_from_wb(3)(12); --by def '0'	
	--
	switchWaitTime1 							<= user_fe_regs_from_wb(3)(16 downto 13); --by def x"a"
	switchWaitTime2 							<= user_fe_regs_from_wb(3)(20 downto 17); --by def x"a"
	ILA_TRIG1_SEL								<= user_fe_regs_from_wb(3)(21);
	--

   
   -- Status:
   user_fe_regs_to_wb(4)(0)  					<= userCdceLocked_r;
   user_fe_regs_to_wb(4)(1)  					<= latencyOptGbtLink_from_gbtRefDesign;
   user_fe_regs_to_wb(4)(2)  					<= mgtReady_from_gbtRefDesign;
   user_fe_regs_to_wb(4)(3)  					<= rxWordClkAligned_from_gbtRefDesign;
   user_fe_regs_to_wb(4)(4)  					<= rxFrameClkAligned_from_gbtRefDesign;
   user_fe_regs_to_wb(4)(5)  					<= gbtRxReady_from_gbtRefDesign;	
   user_fe_regs_to_wb(4)(6)  					<= gbtRxReadyLostFlag_from_gbtRefDesign; --to put into my block	
   --
	user_fe_regs_to_wb(4)(7)  					<= cdce_out4_mmcm_40M_lock;	   
	user_fe_regs_to_wb(4)(11 downto 8)		<= STARTUP_state_flag;	  
	user_fe_regs_to_wb(4)(12)  				<= sync_ok_fe2be; 


	




 
 
   --===================--
   -- resync gbt_RxData --
   --===================--
	
	--===============================================================================================--
	from_gbt_Rx_data_resync_inst: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 84) 
	port map 
	(
		wrclk_i							=> rxFrameClk_from_gbtRefDesign,
		rdclk_i							=> tx_frame_clk, 
		wdata_i							=> rxCommonData_from_gbtRefDesign,
		rdata_o							=> from_gbtRx_data_resync
	); 
	--===============================================================================================--


   --===================--
   -- Chipscope --
   --===================--
	
	CLK_ILA_TEST <= tx_frame_clk; --common clock (TX/RX)

	--===============================================================================================--
	icon_ctrl: entity work.icon_OneCtrl
	--===============================================================================================--
		port map (	CONTROL0 	=> CONTROL0
					);
	--===============================================================================================--


--	--===============================================================================================--
--   ila_gbt_tx_rx: entity work.ila_TwoTrig84b    
-- 	--===============================================================================================--
--	port map (     
--         CONTROL                                => CONTROL0,
--         CLK                                    => CLK_ILA_TEST,
--         TRIG0                                  => ILA_TRIG0,--txCommonData_from_gbtRefDesign,
--         TRIG1                                  => ILA_TRIG1--from_gbtRx_data_resync
--      );  
--	--===============================================================================================--
--
--
--	--===============================================================================================--
--	process	
--	--===============================================================================================--
--	begin
--	wait until rising_edge(CLK_ILA_TEST);
--		ILA_TRIG0  	<= txCommonData_from_gbtRefDesign;
--		--ILA_TRIG1	<= from_gbtRx_data_resync;
--		if ILA_TRIG1_SEL = '1' then
--			ILA_TRIG1	<= (	std_logic_vector(to_unsigned(0,84-32-21-1))
--									& user_sram_rdata_i(sram1)(31 downto 0) --32	
--									& user_sram_addr_tmp(sram1) --21
--									& user_sram_control_tmp(sram1).cs --1
--								);
--		else --by def
--			ILA_TRIG1	<= from_gbtRx_data_resync;
--		end if;
--	end process;
--	--===============================================================================================--	
	
	

	--===============================================================================================--
   ila_gbt_tx_rx: entity work.ila_TwoTrig84b_TwoTrig87b    
 	--===============================================================================================--
	port map (     
         CONTROL                                => CONTROL0,
         CLK                                    => CLK_ILA_TEST,
         TRIG0                                  => ILA_TRIG0,
         TRIG1                                  => ILA_TRIG1,
         TRIG2                                  => ILA_TRIG2,
         TRIG3                                  => ILA_TRIG3			
      );  
	--===============================================================================================--


	--===============================================================================================--
	process	
	--===============================================================================================--
	begin
	wait until rising_edge(CLK_ILA_TEST);
		--84b
		ILA_TRIG0  	<= txCommonData_from_gbtRefDesign;
		--84b
		ILA_TRIG1	<= from_gbtRx_data_resync;
		--87b
		ILA_TRIG2	<= (	--std_logic_vector(to_unsigned(0,87-32-32-21-1-1))
								user_sram_wdata_tmp(sram1)(31 downto 0)		--32
								& user_sram_rdata_i(sram1)(31 downto 0) 		--32	
								& user_sram_addr_tmp(sram1) 						--21
								& user_sram_control_tmp(sram1).writeEnable 	--1
								& user_sram_control_tmp(sram1).cs 				--1
							);		
		--87b
		ILA_TRIG3	<= (	--std_logic_vector(to_unsigned(0,87-32-32-21-1-1))
								user_sram_wdata_tmp(sram2)(31 downto 0)		--32
								& user_sram_rdata_i(sram2)(31 downto 0) 		--32	
								& user_sram_addr_tmp(sram2) 						--21
								& user_sram_control_tmp(sram2).writeEnable 	--1
								& user_sram_control_tmp(sram2).cs 				--1
							);			
	end process;
	--===============================================================================================--	
	

	


   -- On-board LEDs:             
   -----------------
   
   -- Comment: * USER_V6_LED_O(1) -> LD5 on GLIB. 
   --          * USER_V6_LED_O(2) -> LD4 on GLIB.       
   
   USER_V6_LED_O(1)                             <= userCdceLocked_r;          
   USER_V6_LED_O(2)                             <= mgtReady_from_gbtRefDesign;
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope. 
   -- Comment: FPGA_CLKOUT corresponds to SMA1 on GLIB.  
   -- Comment: test delay between frame clk from both sides (be, fe)	

   FPGA_CLKOUT_O                                <= tx_frame_clk when FPGA_CLKOUT_MUXSEL = '0'
                                                   else rxFrameClk_from_gbtRefDesign;						  


	
	--===============--
   -- FRAME CLK 40M --
   --===============--	
   -- Comment: via cdce_out4	+ MMCM for lock signal

	--===============================================================================================--
	cdce_out4_mmcm_40M_inst: entity work.cdce_out4_mmcm_40M 
	--===============================================================================================--
	PORT MAP(
		CLK_IN1_P 		=> cdce_out4_p,
		CLK_IN1_N 		=> cdce_out4_n,
		CLK_OUT1       => cdce_out4_40M, --with bufg
		RESET 			=> cdce_out4_mmcm_40M_reset,
		LOCKED 			=> cdce_out4_mmcm_40M_lock
	);
	--===============================================================================================--		
	
	tx_frame_clk <= cdce_out4_40M; 


	
	--====================--
   -- CDCE CLK2 TRANSMIT --
   --====================--

	--	sec_clk_o <= rxWordClk_from_gbtRefDesign (240M) / 6;
	--===============================================================================================--   
	BUFR_inst_sec_clk_o : BUFR
	--===============================================================================================--   
	generic map (
      BUFR_DIVIDE 	=> "6", 			-- Values: "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
      SIM_DEVICE 		=> "VIRTEX6"  	-- Must be set to "VIRTEX6" 
   )
   port map (
      O 					=> sec_clk_o_tmp,						-- 1-bit output: Clock buffer output
      CE 				=> '1',   								-- 1-bit input: Active high clock enable input
      CLR 				=> '0', 									-- 1-bit input: Active high reset input
      I 					=> rxWordClk_from_gbtRefDesign   -- 1-bit input: Clock buffer input driven by an IBUFG, MMCM or local interconnect
   );
	sec_clk_o <= sec_clk_o_tmp;	
	--===============================================================================================--	


--   -- SUPLLEMENTARY LOCK
--   ---------------------
--	process(sec_clk_o_tmp, cdce_out4_mmcm_40M_lock)
--		constant lock_delay: integer:= 1000;--25ns*cste
--		variable timer: integer := lock_delay;
--			begin
--				if cdce_out4_mmcm_40M_lock = '0' then
--					timer		:= lock_delay;
--					sec_clk_o_lock <= '0';
--				elsif rising_edge(sec_clk_o_tmp) then
--					if timer = 0 then
--						sec_clk_o_lock <= '1';
--					else
--						timer := timer - 1;
--					end if;	
--				end if;	
--	end process;		


	--=======================--
   -- STARTUP CLOCK <=> OSC --
   --=======================--	

	--===============================================================================================--
   xpoint1_clk3_i_bufg : BUFG --xpoint1_clk3 (bufgds) see higher
   --===============================================================================================--
   port map (
      O => xpoint1_clk3_bug, 	-- 1-bit output: Clock buffer output
      I => xpoint1_clk3  		-- 1-bit input: Clock buffer input
   );
	--===============================================================================================--	
	startup_clk <= xpoint1_clk3_bug;
	
	
	--================--
   -- RESET CTRL --
   --================--
--	mgt_TxReset_from_user
--	gbt_TxReset_from_user	
--	mgt_RxReset_from_user
--	gbt_RxReset_from_user

	--================--
   -- GBT RESET CTRL --
   --================--
	-- comment: before gbt_dec_i(sfp).reset / user_gbt_dec_i_reset
	gbt_RxReset_from_user		<= gbt_RxReset_from_user_CtrlSwitch or gbt_RxReset_from_user_ipbus ;-- or reg_sfp_link_ctrl(10);	
	--reg_sfp_link_ctrl			<= regs_from_wb(25)	


	mgt_TxReset_from_user <= mgt_TxReset_from_user_ipbus;
	gbt_TxReset_from_user <= gbt_TxReset_from_user_ipbus;
	mgt_RxReset_from_user <= mgt_RxReset_from_user_ipbus;
	


	
	--====================--
   -- CDCE CLK SWITCHING --
   --====================--	

   -- OUT:
   -------
	user_cdce_sel_o 			<= user_cdce_refsel;
	user_cdce_sync_o 			<= user_cdce_sync_o_tmp; --cdce_sync_ipbus_cmd; --user_cdce_sync_o_tmp and cdce_sync_ipbus_cmd;

   -- CTRL FSM:
   ------------
	
--	switchWaitTime1 <= x"a";
--	switchWaitTime2 <= x"a";	

	
	--===============================================================================================--
	process (	startup_clk, 
					cdce_out4_mmcm_40M_lock, 
					--fe_resync_reset_ipbus,
					reset_from_or_gate, 
					--rxWordClkAligned_from_gbtRefDesign,
					rxFrameClkAligned_from_gbtRefDesign
					--gbtRxReady_from_gbtRefDesign,
					--mgtReady_from_gbtRefDesign
				) --sec_clk_o_lock) 
	--===============================================================================================--
	variable counter : integer range 0 to 15:=3; 
		begin	
			--
			--if cdce_out4_mmcm_40M_lock = '0' then --sec_clk_o_lock = '0' / clr_be2fe = '1' then	--totally async
			--if cdce_out4_mmcm_40M_lock = '0' or reset_from_user = '1' then
			--if cdce_out4_mmcm_40M_lock = '0' or fe_resync_reset_ipbus = '1'
			if (	cdce_out4_mmcm_40M_lock 						= '0'  
					--or fe_resync_reset_ipbus 						= '1' 
					or reset_from_or_gate 							= '1' 
					--or rxWordClkAligned_from_gbtRefDesign 		= '0' 
					or rxFrameClkAligned_from_gbtRefDesign 	= '0' 
					--or gbtRxReady_from_gbtRefDesign 				= '0' 
					--or mgtReady_from_gbtRefDesign					= '0' 
				) 	
			then
				STARTUP_state 								<= idle;
				--by def
				gbt_RxReset_from_user_CtrlSwitch 	<= '0'; -- DIS
				user_cdce_refsel  						<= '1'; -- CLK1 by default
				user_cdce_sync_o_tmp  					<= '1'; -- DIS
				sync_ok_fe2be 								<= '0';
				STARTUP_state_flag 						<= std_logic_vector(to_unsigned(0,STARTUP_state_flag_bitsNb));
			--	
			elsif rising_edge(startup_clk) then
				--
				case STARTUP_state is
					--
					when idle => 
						--if gbtRxReady_from_gbtRefDesign = '1' then
							STARTUP_state 								<= state1;
						--end if;
						--STARTUP_state 								<= state1;
						--by def
						gbt_RxReset_from_user_CtrlSwitch 	<= '0'; -- DIS
						user_cdce_refsel  						<= '1'; -- CLK1 by default
						user_cdce_sync_o_tmp  					<= '1'; -- DIS
						sync_ok_fe2be 								<= '0';
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(1,STARTUP_state_flag_bitsNb));
					--	
					when state1 =>				
						--if refclk_sent_be2fe_resync = '1' then --and phasealingdone ??
						STARTUP_state 								<= state2;
						counter 										:= to_integer(unsigned(switchWaitTime1)); --3;
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(2,STARTUP_state_flag_bitsNb));
					--
					when state2 =>	--switch & wait1
						user_cdce_refsel 							<= '0'; -- CLK2
						if counter = 0 then
							STARTUP_state 								<= state3;
							counter 										:= to_integer(unsigned(switchWaitTime2)); --3
						else
							counter 										:= counter-1;
						end if;
						STARTUP_state_flag	 					<= std_logic_vector(to_unsigned(3,STARTUP_state_flag_bitsNb));
					--
					when state3 =>	----clr en & wait2...	
						--clr
						gbt_RxReset_from_user_CtrlSwitch		<= '1'; -- EN / how many long	??		
						--user_cdce_sync_o_tmp  <= '0'; -- EN
						if counter = 0 then
							STARTUP_state 								<= state4;
						else
							counter 										:= counter-1;
						end if;
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(4,STARTUP_state_flag_bitsNb));							
					--	
					when state4 =>	--clr dis		
						--clr
						gbt_RxReset_from_user_CtrlSwitch		<= '0'; -- DIS
						--user_cdce_sync_o_tmp  <= '1'; -- DIS
						--user_gtx_i_rx_reset <= '0'; 		
						--user_gtx_i_rx_sync_reset <= '0'; 						
						STARTUP_state 								<= state5;
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(5,STARTUP_state_flag_bitsNb));
					--					
					when state5 =>	--
						--cdce_out4_reset <= '0'; --not need
						if cdce_out4_mmcm_40M_lock = '1' then
							STARTUP_state 								<= state6;
						end if;
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(6,STARTUP_state_flag_bitsNb));						
					--					
					when state6 =>	--Test
						if 	(	rxWordClkAligned_from_gbtRefDesign 		= '1' and
									rxFrameClkAligned_from_gbtRefDesign 	= '1' and
									gbtRxReady_from_gbtRefDesign 				= '1' and
									mgtReady_from_gbtRefDesign					= '1' 
								) 	then --gbt_dec_o(sfp).aligned = '1' oldVersion
							STARTUP_state 								<= state7;
						end if;
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(7,STARTUP_state_flag_bitsNb));							
					--					
					when state7 =>	--
						null;
						sync_ok_fe2be 								<= '1';
						STARTUP_state_flag 						<= std_logic_vector(to_unsigned(8,STARTUP_state_flag_bitsNb));		
				end case;
			end if;
	end process;	
	--===============================================================================================--

	

--	--====================--
--   -- GBT DATA INTERFACE --
--   --====================--
--
--	--===============================================================================================--
--	gbt_data_interface_inst: entity work.gbt_data_interface 
--	--===============================================================================================--
--	PORT MAP(	common_frame_clk_i 		=> tx_frame_clk,
--					reset_from_user_i			=> reset_from_or_gate,
--					from_gbtRx_data_i 		=> from_gbtRx_data_resync,
--					to_gbtTx_data_o 			=> to_gbtTx_from_gbtDataInterface, --to_gbtTx_from_user,
--					gbt_sram_control_o 		=> gbt_sram_control,
--					gbt_sram_addr_o 			=> gbt_sram_addr,
--					gbt_sram_rdata_i 			=> user_sram_rdata_i,
--					gbt_sram_wdata_o 			=> gbt_sram_wdata,
--					--
--					REG_CTRL_o					=> FE_REG_CTRL, 	--array_REG_CTRL_WORD_DEPTHx32; --! user_package
--					REG_STATUS_i				=> FE_REG_STATUS 	--array_REG_STATUS_WORD_DEPTHx32					
--			);
--	--===============================================================================================--




	--====================--
   -- SRAM INTERFACE --
   --====================--

--	--out : if only gbt_data_interface
--	user_sram_control_o 		<= gbt_sram_control; 
--	user_sram_addr_o 			<= gbt_sram_addr;							
--	user_sram_wdata_o			<= gbt_sram_wdata;	


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
--			if 	cbc_i2c_user_sram_control.cs = '1' then
--				user_sram_control_tmp(sram1).cs 				<= cbc_i2c_user_sram_control.cs;
--				user_sram_control_tmp(sram1).writeEnable 	<= cbc_i2c_user_sram_control.writeEnable;
--				user_sram_addr_tmp(sram1) 						<= cbc_i2c_user_sram_addr;							
--				user_sram_wdata_tmp(sram1) 					<= cbc_i2c_user_sram_wdata;
			--
			if	gbt_sram_control(sram1).cs = '1' then
				user_sram_control_tmp(sram1).cs 				<= gbt_sram_control(sram1).cs;
				user_sram_control_tmp(sram1).writeEnable 	<= gbt_sram_control(sram1).writeEnable;
				user_sram_addr_tmp(sram1) 						<= gbt_sram_addr(sram1);							
				user_sram_wdata_tmp(sram1) 					<= gbt_sram_wdata(sram1);
			else
				user_sram_control_tmp(sram1).cs 				<= '0'; --DIS
				user_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
				user_sram_addr_tmp(sram1) 						<= (others=>'0');							
				user_sram_wdata_tmp(sram1) 					<= (others=>'0');
			end if;
			
			--sram2
			if gbt_sram_control(sram2).cs = '1' then
				user_sram_control_tmp(sram2).cs 				<= gbt_sram_control(sram2).cs;
				user_sram_control_tmp(sram2).writeEnable 	<= gbt_sram_control(sram2).writeEnable;
				user_sram_addr_tmp(sram2) 						<= gbt_sram_addr(sram2);							
				user_sram_wdata_tmp(sram2) 					<= gbt_sram_wdata(sram2);
			else
				user_sram_control_tmp(sram2).cs 				<= '0'; --DIS
				user_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
				user_sram_addr_tmp(sram2) 						<= (others=>'0');							
				user_sram_wdata_tmp(sram2) 					<= (others=>'0');
			end if;	
	end process;
	--===============================================================================================--




--	to_gbtTx_from_user <= to_gbtTx_cbc(83 downto 75) & to_gbtTx_from_gbtDataInterface(74 downto 0);
	to_gbtTx_from_user <= to_gbtTx_cbc(83 downto 0);


									
	


   --1) INPUTS             
   -----------
	-->FE1
	-->SDA_IN : SDA_FROM_CBC	
	to_gbtTx_cbc(83)										<= cbc_fabric_sda_i(0);	
	--IN
	-->TRIGDATA (LVDS)
	--A
	to_gbtTx_cbc(82)										<= cbc_trigdata(0,0);		
	--B
	to_gbtTx_cbc(81)										<= cbc_trigdata(0,1);
	-->STUBDATA (LVDS)
	--A
	to_gbtTx_cbc(80)										<= cbc_stubdata(0,0);		
	--B
	to_gbtTx_cbc(79)										<= cbc_stubdata(0,1);

	--FE2
	-->SDA_IN : SDA_FROM_CBC	
	to_gbtTx_cbc(78)										<= cbc_fabric_sda_i(1);	
	--IN
	-->TRIGDATA (LVDS)
	--A
	to_gbtTx_cbc(77)										<= cbc_trigdata(1,0);		
	--B
	to_gbtTx_cbc(76)										<= cbc_trigdata(1,1);
	-->STUBDATA (LVDS)
	--A
	to_gbtTx_cbc(75)										<= cbc_stubdata(1,0);		
	--B
	to_gbtTx_cbc(74)										<= cbc_stubdata(1,1);



	
	--OUT
	-->FE1
	-->SCL_OUT : SCLK_2V5
	cbc_fabric_scl_o(0)  								<= from_gbtRx_data_resync(83); 										
	-->SDA_OUT : SDA_TO_CBC
	cbc_fabric_sda_o(0)  								<= from_gbtRx_data_resync(82);		
	-->CLKIN_40_LVDS 
	--															<= from_gbtRx_data_resync(81);
	-->T1_TRIGGER (LVDS) 
	cbc_t1_trigger(0)  									<= from_gbtRx_data_resync(80);	 			
	-->CLK_DCDC_LVDS
	cbc_clk_dcdc_from_be(0)								<= from_gbtRx_data_resync(79); --from be 
	-->RESET_2V5
	cbc_hard_reset(0)  									<= from_gbtRx_data_resync(78); 		
	-->cbc_i2c_refresh (LVDS) 
	cbc_i2c_refresh(0)  									<= from_gbtRx_data_resync(77); 		
	-->cbc_test_pulse (LVDS)
	cbc_test_pulse(0)  									<= from_gbtRx_data_resync(76);		
	-->cbc_fast_reset (LVDS)
	cbc_fast_reset(0)  									<= from_gbtRx_data_resync(75);	


	-->FE2
	-->SCL_OUT : SCLK_2V5
	cbc_fabric_scl_o(1)  								<= from_gbtRx_data_resync(74); 										
	-->SDA_OUT : SDA_TO_CBC
	cbc_fabric_sda_o(1)  								<= from_gbtRx_data_resync(73);		
	-->CLKIN_40_LVDS 
	--															<= from_gbtRx_data_resync(72);
	-->T1_TRIGGER (LVDS) 
	cbc_t1_trigger(1)  									<= from_gbtRx_data_resync(71);	 			
	-->CLK_DCDC_LVDS
	cbc_clk_dcdc_from_be(1)								<= from_gbtRx_data_resync(70); --from be 
	-->RESET_2V5
	cbc_hard_reset(1)  									<= from_gbtRx_data_resync(69); 		
	-->cbc_i2c_refresh (LVDS) 
	cbc_i2c_refresh(1)  									<= from_gbtRx_data_resync(68); 		
	-->cbc_test_pulse (LVDS)
	cbc_test_pulse(1)  									<= from_gbtRx_data_resync(67);		
	-->cbc_fast_reset (LVDS)
	cbc_fast_reset(1)  									<= from_gbtRx_data_resync(66);	






   -- FMC2 I/O mapping:             
   --------------------
	
	-->FE1
	
	--Comment: polarity inverting done here
   --1) I2C I/O:             
   -------------

	--IN
	-->SDA_IN : SDA_FROM_CBC	
	--cbc_fabric_sda_i 									<= not fmc2_from_pin_to_fabric.la_lvds(29) when POLARITY_SDA_FROM_CBC = '1' else fmc2_from_pin_to_fabric.la_lvds(29);
	cbc_fabric_sda_i(0)									<= not fmc2_from_pin_to_fabric.la_lvds(29);
	--OUT
	-->SCL_OUT : SCLK_2V5
	--fmc2_from_fabric_to_pin.la_lvds(31) 			<= not cbc_fabric_scl_o when POLARITY_SCL = '1' else cbc_fabric_scl_o;
	fmc2_from_fabric_to_pin.la_lvds(31) 			<= not cbc_fabric_scl_o(0);	
	-->SDA_OUT : SDA_TO_CBC
	--fmc2_from_fabric_to_pin.la_lvds(28) 			<= not cbc_fabric_sda_o when POLARITY_SDA_TO_CBC = '1' else cbc_fabric_sda_o;
	fmc2_from_fabric_to_pin.la_lvds(28) 			<= not cbc_fabric_sda_o(0);

   --1) OTHERS I/O:             
   ----------------	
	
	--IN
	-->TRIGDATA (LVDS)
	--A
	cbc_trigdata(0,0)									<= not fmc2_from_pin_to_fabric.la_lvds(7);	
	--B
	cbc_trigdata(0,1)									<= not fmc2_from_pin_to_fabric.la_lvds(0);

	-->STUBDATA (LVDS)
--	--A
--	cbc_stubdata(0,0)									<= not fmc2_from_pin_to_fabric.la_lvds(11);	
--	--B
--	cbc_stubdata(0,1)									<= not fmc2_from_pin_to_fabric.la_lvds(2);
	--correc 27Nov2013
--		"lvds", "in__", "in__",		--FMC2_LA16		-- TRIGGER_CBC2_A_LVDS
--		"lvds", "in__", "in__",		--FMC2_LA04		-- TRIGGER_CBC2_B_LVDS	
	--A
	cbc_stubdata(0,0)									<= not fmc2_from_pin_to_fabric.la_lvds(16);	
	--B
	cbc_stubdata(0,1)									<= not fmc2_from_pin_to_fabric.la_lvds(4);
	



 
	
	--OUT
	
	-->CLKIN_40_LVDS 
	fmc2_from_fabric_to_pin.la_lvds(24)				<= tx_frame_clk;	
	-->T1_TRIGGER (LVDS) 
	fmc2_from_fabric_to_pin.la_lvds(15)				<= not cbc_t1_trigger(0); 			
	-->CLK_DCDC_LVDS
	fmc2_from_fabric_to_pin.la_lvds(25)				<= '0'; --cbc_clk_dcdc;	--towards DC-DC converter
	-->RESET_2V5
	fmc2_from_fabric_to_pin.la_lvds(30)				<= not cbc_hard_reset(0);		
	-->cbc_i2c_refresh (LVDS) 
	fmc2_from_fabric_to_pin.la_lvds(21)				<= not cbc_i2c_refresh(0);		
	-->cbc_test_pulse (LVDS)
	fmc2_from_fabric_to_pin.la_lvds(19)				<= not cbc_test_pulse(0);	
	-->cbc_fast_reset (LVDS)
	fmc2_from_fabric_to_pin.la_lvds(20)				<= not cbc_fast_reset(0); --used to be the rst_101 in CBC1			





	-->FE2
	
	--Comment: polarity inverting done here
   --1) I2C I/O:             
   -------------

	--IN
	-->SDA_IN : SDA_FROM_CBC	
	--cbc_fabric_sda_i 									<= not fmc1_from_pin_to_fabric.la_lvds(29) when POLARITY_SDA_FROM_CBC = '1' else fmc1_from_pin_to_fabric.la_lvds(29);
	cbc_fabric_sda_i(1)									<= not fmc1_from_pin_to_fabric.la_lvds(29);
	--OUT
	-->SCL_OUT : SCLK_2V5
	--fmc1_from_fabric_to_pin.la_lvds(31) 			<= not cbc_fabric_scl_o when POLARITY_SCL = '1' else cbc_fabric_scl_o;
	fmc1_from_fabric_to_pin.la_lvds(31) 			<= not cbc_fabric_scl_o(1);	
	-->SDA_OUT : SDA_TO_CBC
	--fmc1_from_fabric_to_pin.la_lvds(28) 			<= not cbc_fabric_sda_o when POLARITY_SDA_TO_CBC = '1' else cbc_fabric_sda_o;
	fmc1_from_fabric_to_pin.la_lvds(28) 			<= not cbc_fabric_sda_o(1);

   --1) OTHERS I/O:             
   ----------------	
	
	--IN
	-->TRIGDATA (LVDS)
	--A
	cbc_trigdata(1,0)									<= not fmc1_from_pin_to_fabric.la_lvds(7);	
	--B
	cbc_trigdata(1,1)									<= not fmc1_from_pin_to_fabric.la_lvds(0);

	-->STUBDATA (LVDS)
--	--A
--	cbc_stubdata(1,0)									<= not fmc1_from_pin_to_fabric.la_lvds(11);	
--	--B
--	cbc_stubdata(1,1)									<= not fmc1_from_pin_to_fabric.la_lvds(2);
	--correc 27Nov2013
--		"lvds", "in__", "in__",		--FMC2_LA16		-- TRIGGER_CBC2_A_LVDS
--		"lvds", "in__", "in__",		--FMC2_LA04		-- TRIGGER_CBC2_B_LVDS	
	--A
	cbc_stubdata(1,0)									<= not fmc1_from_pin_to_fabric.la_lvds(16);	
	--B
	cbc_stubdata(1,1)									<= not fmc1_from_pin_to_fabric.la_lvds(4);
	
	--OUT
	
	-->CLKIN_40_LVDS 
	fmc1_from_fabric_to_pin.la_lvds(24)				<= tx_frame_clk;	
	-->T1_TRIGGER (LVDS) 
	fmc1_from_fabric_to_pin.la_lvds(15)				<= not cbc_t1_trigger(1); 			
	-->CLK_DCDC_LVDS
	fmc1_from_fabric_to_pin.la_lvds(25)				<= '0'; --cbc_clk_dcdc;	--towards DC-DC converter
	-->RESET_2V5
	fmc1_from_fabric_to_pin.la_lvds(30)				<= not cbc_hard_reset(1);		
	-->cbc_i2c_refresh (LVDS) 
	fmc1_from_fabric_to_pin.la_lvds(21)				<= not cbc_i2c_refresh(1);		
	-->cbc_test_pulse (LVDS)
	fmc1_from_fabric_to_pin.la_lvds(19)				<= not cbc_test_pulse(1);	
	-->cbc_fast_reset (LVDS)
	fmc1_from_fabric_to_pin.la_lvds(20)				<= not cbc_fast_reset(1); --used to be the rst_101 in CBC1




	--===============--
   -- CBC DC-DC GENE--
   --===============--
   --comment: 1MHz from 40MHz             
	
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
				cbc_clk_dcdc(1) <= clock_1MHz;
	end process;
	--===============================================================================================--







--	--============--
--   -- PARAMETERS --
--   --============--
--
--
--   --From GBT_DATA_INTERFACE:             
--   --------------------------	
--	
--   --1) CTRL:             
--   ----------
--	
--	--cmd dual cbc2 
--	cbc_hard_reset 			<= FE_REG_CTRL(1)(0);		
--	cbc_i2c_refresh 			<= FE_REG_CTRL(1)(1); --'0'
--	cbc_test_pulse 			<= FE_REG_CTRL(1)(2); --'0'
--	cbc_fast_reset 			<= FE_REG_CTRL(1)(3); --'0'	--used to be the rst_101 in CBC1	
--	cbc_t1_trigger				<= FE_REG_CTRL(1)(4); --just one pulse from BE
--	--rq							
--	cbc_i2c_cmd_rq				<= FE_REG_CTRL(1)(6 downto 5);
--
--	--param
--	cbc_i2c_param_word_i		<= FE_REG_CTRL(2);
--
--   --1) STATUS:             
--   ------------
--	FE_REG_STATUS(0) 			<= cbc_i2c_param_word_o;
--
--
--
--		
----	POLARITY_TRIGGER_TO_CBC
----	POLARITY_SDA_FROM_CBC
----	POLARITY_SDA_TO_CBC
----	POLARITY_SCL





				
	---------------******************************END CBC_CTRL**********************************----------------


	
	













			



end user_logic_arch;