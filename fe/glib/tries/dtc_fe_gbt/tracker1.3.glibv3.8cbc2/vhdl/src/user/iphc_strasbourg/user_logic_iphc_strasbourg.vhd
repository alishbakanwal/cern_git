----from Paschalis
--library ieee;
--use ieee.std_logic_1164.all
--use ieee.numeric_std.all;
--or
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;


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

--fmc configuration
use work.user_fmc1_io_conf_package.all;
use work.user_fmc2_io_conf_package.all;


entity user_logic is
generic
(
	--TTC_CLK_USED 		: string := "used"; --used or 
	TTC_CLK_USED 		: boolean := false --true or false 
 
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


   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@ PLACE YOUR DECLARATIONS BELOW THIS COMMENT @@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--



--	signal 	user_ipb_regs_i					: array_32x32bit;
--	signal 	user_ipb_regs_o					: array_32x32bit;
--attribute keep: boolean;
--attribute keep of user_signal			: signal is true;


	---------------********************************FMC_INTERFACES************************************----------------
	signal fmc1_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc1_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;
	
	signal fmc2_from_pin_to_fabric	: fmc_from_pin_to_fabric_type;
	signal fmc2_from_fabric_to_pin	: fmc_from_fabric_to_pin_type;
	---------------******************************END FMC_INTERFACES**********************************----------------	



	---------------********************************TTC_FMC************************************----------------
	signal clk_40 : std_logic:='0';	
	signal cdr_clk : std_logic:='0';		
	--cdr interface
	signal cdr_lol 						: std_logic:='0';
	signal cdr_los 						: std_logic:='0';	
	signal cdr_clk_locked 				: std_logic:='0';	
	signal cdr_data 						: std_logic:='0';
	signal divider_div4 					: std_logic:='0';
	signal divider_rst_b 				: std_logic:='0';	
	--
	signal ttc3_3DE, ttc3_2DE 			: std_logic:='1';	
	signal ttc3_user_led_n 				: std_logic:='0';		
	
	--
	signal ttcclk 							: std_logic:='0';	
	signal l1accept 						: std_logic:='0';
	signal bcntres 						: std_logic:='0';
	signal evcntres 						: std_logic:='0';
	signal sinerrstr 						: std_logic:='0';	
	signal dberrstr 						: std_logic:='0';	
	signal brcststr						: std_logic:='0';	
	signal brcst							: std_logic_vector(7 downto 2):=(others=>'0');	
	signal dummy_out						: std_logic:='0';	
	--i2c
	signal ttc_fmc_reg_i2c_settings	: std_logic_vector(31 downto 0):=(others=>'0');	
	signal ttc_fmc_reg_i2c_command	: std_logic_vector(31 downto 0):=(others=>'0');	
	signal ttc_fmc_reg_i2c_reply		: std_logic_vector(31 downto 0):=(others=>'0');		
	signal fabric_scl_o					: std_logic:='0';	
	signal fabric_scl_oe_l				: std_logic:='0';	
	signal fabric_sda_i					: std_logic:='0';	
	signal fabric_sda_o					: std_logic:='0';	
	signal fabric_sda_oe_l				: std_logic:='0';	
	--parameters
	signal ttc_fmc_reg_ctrl				: std_logic_vector(31 downto 0):=(others=>'0');	
	signal ttc_fmc_reg_status			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal ttc_fmc_xpoint_4x4_s10		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s11		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s20		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s21		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s30		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s31		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s40		: std_logic:='0';	
	signal ttc_fmc_xpoint_4x4_s41		: std_logic:='0';	
	--inspection line
	signal lemo_lm2						: std_logic:='0';
	--resync brcst
	type brcst_array_type 				is array (1 downto 0) of std_logic_vector(brcst'range); --7 downto 2!!!
	signal brcst_sync 					: brcst_array_type;
	signal brcststr_sync 				: std_logic_vector(1 downto 0):=(others=>'0');	
	---------------******************************END TTC_FMC**********************************----------------	


	---------------********************************CLOCKING************************************----------------
	--	--config GLIBv3 <-> TTC_FMC_v2
	--	always plug TTC_FMC_v2 in FMC1 CONNEC
	--	fmc1_clk2_bidir_p/n (VHDL) (CON FMC = K4/K5 - ucf = K24/K23) <=> FMC1_CLK1_M2C (TTC_FMC_v2) ==> 160M (direct link)
	--	fmc1_clk0_m2c_xpoint2_p/n (VHDL) (ucf = K13/K12) <=> FMC1_CLK0_M2C (TTC_FMC_v2) ==> 40M (not direct link / via xpoint2)
	--	comments : hard config for xpoint2_out2 !! not need SW config...
	--	ideas : cdr_40M not used / using of DCM to generate 160M & 40M from cdr_160M
	--	so possible make compliant TTCv2 for both GLIBv2/v3 if 
	--		--> config TTCv2 xpoint_4x4_out4 = 160M instead 40M as now (out3 not needed after that)
	--		--> use only :
	--			--> GLIBv2 : xpoint_2x2_out1 (+ config xpoint_2x2 necessary)
	--			--> GLIBv3 : xpoint1_clk3 or cdce_out4 (+config xpoint2, xpoint1 + cdce)
		
	--if cdr_40M routed from TTC_FMC
	signal fmc1_clk0_m2c_xpoint2_bufgds : std_logic:='0';
	signal fmc1_clk0_m2c_xpoint2_bufg 	: std_logic:='0';
	--if cdr_160M routed from TTC_FMC / direct link
	signal fmc1_clk2_bidir_bufgds 		: std_logic:='0';
	signal fmc1_clk2_bidir_bufg 			: std_logic:='0';
	--Internal OSC clock / if xpoint1 well configured!!! (by def ok but take care) 
	signal xpoint1_clk1_i_bufg 			: std_logic:='0';	
	--ttcrx ouputs
	signal cdr_clk_40M_0 					: std_logic:='0';
	signal cdr_clk_160M_0 					: std_logic:='0';	
	signal cdr_clk_40M_0_180 				: std_logic:='0';
	--clock really used
	signal BC_CLK 								: std_logic:='0';	
	signal SRAM_CLK 							: std_logic:='0';
	---------------******************************END CLOCKING**********************************----------------







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
	constant CBC_RCV_DATA_BITS_NB 		: positive := 138;
	--> aclr
	signal cbc_frame_aclr 					: std_logic:='0';
	--> receiver / deserialiser
	signal cbc_frame_in 						: std_logic:='0';	
	signal cbc_rcv_capture_out 			: std_logic:='0';
	signal cbc_rcv_data_138b_tmp1 		: std_logic_vector(CBC_RCV_DATA_BITS_NB-1 downto 0):=(others=>'0');
	signal cbc_rcv_data_138b_en_tmp1 	: std_logic:='0';		
	--> after selection
	signal cbc_rcv_data_138b				: std_logic_vector(CBC_RCV_DATA_BITS_NB-1 downto 0):=(others=>'0');
	signal cbc_rcv_data_138b_en			: std_logic:='0';	
	--> delay
	signal cbc_rcv_data_138b_en_del1		: std_logic:='0';		
	---------------******************************END CBC_RECEIVER**********************************----------------	


	---------------********************************CBCv1************************************----------------
	-->I2C / circuit interface
	signal cbc_fabric_scl_o					: std_logic:='0';
	signal cbc_fabric_scl_oe_l				: std_logic:='0';	
	signal cbc_fabric_sda_i					: std_logic:='0';	
	signal cbc_fabric_sda_o					: std_logic:='0';	
	signal cbc_fabric_sda_oe_l				: std_logic:='0';	
	-->INTERNAL SIGNALS
	signal cbc_hard_reset 					: std_logic := '0';
	signal cbc_reset101 						: std_logic := '0';
	signal cbc_trigger 						: std_logic := '0';
	signal cbc_data_2v5 						: std_logic := '0';	
	signal cbc_clk_2v5_1MHz 				: std_logic := '0';	
	signal reset101_reg 						: std_logic_vector(7 downto 0):=(others=>'0');
	signal reset101_reg_index 				: integer range 0 to 7 := 0;	
	---------------******************************END CBCv1**********************************----------------
	




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
	signal fsm1_CBC_data_packet_counter : integer range 0 to 15:=0;--9:=0;
	signal fsm2_CBC_data_packet_counter : integer range 0 to 15:=0;--:=0;	
	--Handshaking between SRAM flags & SW
	signal SRAM1_full : std_logic:='0';	
	signal SRAM2_full : std_logic:='0';	
	signal SRAM1_end_readout : std_logic:='0';		
	signal SRAM2_end_readout : std_logic:='0';	
	--
	signal SRAM1_full_one_cycle : std_logic:='0';
	signal SRAM2_full_one_cycle : std_logic:='0';	
	---------------******************************END CTRL**********************************----------------
	
	

	---------------********************************PARAMETERS************************************----------------	
	----> registers mapping
	signal ttc_fmc_regs_from_wb 			: array_32x32bit; --array_32x32bit see system_package
	signal ttc_fmc_regs_to_wb 				: array_32x32bit;	

	----> readout/acq
	signal CBC_DATA_PACKET_NUMBER			: std_logic_vector(20 downto 0):=(others=>'0');	
	signal TRIGGER_SEL 						: std_logic:='0';
	signal ACQ_MODE 							: std_logic:='0';	
	signal CBC_DATA_GENE 					: std_logic:='0';	
	signal SPURIOUS_FRAME 					: std_logic:='0';		
	signal CLK_DEPHASING 					: std_logic:='0';
	signal POLARITY_sTTS 					: std_logic:='0';
	signal POLARITY_CBC 						: std_logic:='0';
	signal CMD_START_BY_PC 					: std_logic:='0';		
	signal PC_config_ok 						: std_logic:='0';
	signal INT_TRIGGER_FREQ_SEL 			: std_logic_vector(3 downto 0):=(others=>'0');

	----> CBC
	--
	signal CBC_RESET_SEL 					: std_logic_vector(1 downto 0) := (others=>'0');
	--I2C / SW interface 
	signal cbc_reg_i2c_settings			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal cbc_reg_i2c_command				: std_logic_vector(31 downto 0):=(others=>'0');	
	signal cbc_reg_i2c_reply				: std_logic_vector(31 downto 0):=(others=>'0');	
	---------------******************************END PARAMETERS**********************************----------------	
	
	
	--resync param
	signal ACQ_MODE_RESYNC 				: std_logic:='0';	
	


	---------------********************************ACQ_COUNTERS************************************----------------
	signal BC_COUNTER_12b 				: std_logic_vector(11 downto 0):=(others=>'0'); --integer range 0 to 3563 		:= 0; --2**12-1=4095 max 
	signal BC_COUNTER_24b 				: std_logic_vector(23 downto 0):=(others=>'0'); --same range than 12b
	signal ORB_COUNTER_18b 				: std_logic_vector(17 downto 0):=(others=>'0'); --integer range 0 to 2**18-1 	:= 0;
	signal ORB_COUNTER_24b 				: std_logic_vector(23 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;
	signal LS_COUNTER_24b 				: std_logic_vector(23 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;
	signal L1A_COUNTER_24b 				: std_logic_vector(23 downto 0):=(others=>'0'); --integer range 0 to 2**24-1 	:= 0;
	signal CBC_DATA_COUNTER_24b 		: std_logic_vector(23 downto 0):=(others=>'0');
	---------------******************************END ACQ_COUNTERS**********************************----------------

	
	--Trigger
	--test l1a
	signal l1accept_sync 				: std_logic_vector(1 downto 0):=(others=>'0');
	signal l1accept_sync_one_cycle 	: std_logic:='0';			
	signal L1A_VALID 						: std_logic:='0';
	signal L1A_VALID_del1				: std_logic:='0';		
	--Internal trigger
	signal int_trigger 					: std_logic:='0';


	---------------********************************FIFO2_INTERFACE************************************----------------
	constant data_bits_number_fifo2 	: natural := 96;
	signal DIN_FIFO2 						: std_logic_vector(data_bits_number_fifo2-1 downto 0):=(others=>'0'); 
	signal DOUT_FIFO2 					: std_logic_vector(DIN_FIFO2'range):=(others=>'0'); 
	signal FULL_FIFO2_100_percent 	: std_logic:='0';
	signal EMPTY_FIFO2_0_percent 		: std_logic:='0';
	signal VALID_FIFO2 					: std_logic:='0';	
	signal FULL_FIFO2_75_percent 		: std_logic:='0';
	signal EMPTY_FIFO2_50_percent 	: std_logic:='0';
	signal CLR_FIFO2 						: std_logic:='0';
	signal WR_EN_FIFO2 					: std_logic:='0';
	signal RD_EN_FIFO2 					: std_logic:='0';
	signal FIFO2_wr_ack 					: std_logic:='0';	
	---------------******************************END FIFO2_INTERFACE**********************************----------------	
	
	---------------********************************FIFO1_INTERFACE************************************----------------
	constant data_bits_number_fifo1 	: natural:= 170;	--162
	signal DIN_FIFO1 						: std_logic_vector(data_bits_number_fifo1-1 downto 0):=(others=>'0'); 
	signal DOUT_FIFO1 					: std_logic_vector(DIN_FIFO1'range):=(others=>'0'); 
	signal FULL_FIFO1_100_percent 	: std_logic:='0';
	signal EMPTY_FIFO1_0_percent 		: std_logic:='0';
	signal VALID_FIFO1 					: std_logic:='0';	
	signal FULL_FIFO1_75_percent 		: std_logic:='0';
	signal EMPTY_FIFO1_50_percent 	: std_logic:='0';
	signal CLR_FIFO1 						: std_logic:='0';
	signal WR_EN_FIFO1 					: std_logic:='0';
	signal RD_EN_FIFO1 					: std_logic:='0';
	signal FIFO1_wr_ack 					: std_logic:='0';	
	---------------******************************END FIFO1_INTERFACE**********************************----------------	



	---------------********************************FSM_FIFO************************************----------------
	--> FOR FIFO1
	type FSM_FIFO1_states is (		FSM_FIFO1_idle, 			FSM_FIFO1_wait_start, 		FSM_FIFO1_write1, 		
											FSM_FIFO1_write_OOS,		FSM_FIFO1_BUSY, 				FSM_FIFO1_BUSY2
										);
	signal FSM_FIFO1_state : FSM_FIFO1_states; 
	
	--> FOR FIFO2
	type FSM_FIFO2_states is (		FSM_FIFO2_idle, 			FSM_FIFO2_wait_start,		FSM_FIFO2_write1,		 		
											FSM_FIFO2_write_OOS,		FSM_FIFO2_BUSY, 				FSM_FIFO2_BUSY2
										);
	signal FSM_FIFO2_state : FSM_FIFO2_states; 
	
	--FSM FIFO flags
	signal FSM_FIFO1_flag 			: std_logic_vector(7 downto 0):=(others=>'0');
	signal FSM_FIFO2_flag 			: std_logic_vector(7 downto 0):=(others=>'0');		
	---------------******************************END FSM_FIFO**********************************----------------	



	---------------********************************FSM_SRAM************************************----------------
	--> FOR FIFO_TO_SRAM1
	type FSM_FIFO_TO_SRAM1_states is (		FSM_FIFO_TO_SRAM1_idle,	FSM_FIFO_TO_SRAM1_empty_FIFO, FSM_FIFO_TO_SRAM1_init,
														FSM_FIFO_TO_SRAM1_test_2FIFO_not_empty,	FSM_FIFO_TO_SRAM1_latch_data, FSM_FIFO_TO_SRAM1_latch_data2,	FSM_FIFO_TO_SRAM1_store_data,
														FSM_FIFO_TO_SRAM1_test_packet_sent,	FSM_FIFO_TO_SRAM1_flag_full,	FSM_FIFO_TO_SRAM1_test_end_readout
												);
	signal FSM_FIFO_TO_SRAM1_state : FSM_FIFO_TO_SRAM1_states;	
	
	--> FOR FIFO_TO_SRAM2
	type FSM_FIFO_TO_SRAM2_states is (		FSM_FIFO_TO_SRAM2_idle,	FSM_FIFO_TO_SRAM2_empty_FIFO, FSM_FIFO_TO_SRAM2_init,
														FSM_FIFO_TO_SRAM2_test_2FIFO_not_empty,	FSM_FIFO_TO_SRAM2_latch_data,	FSM_FIFO_TO_SRAM2_latch_data2, FSM_FIFO_TO_SRAM2_store_data,
														FSM_FIFO_TO_SRAM2_test_packet_sent,	FSM_FIFO_TO_SRAM2_flag_full,	FSM_FIFO_TO_SRAM2_test_end_readout
												);											
	signal FSM_FIFO_TO_SRAM2_state : FSM_FIFO_TO_SRAM2_states;	
	
	--FSM SRAM flags
	signal FSM_FIFO_TO_SRAM1_flag 	: std_logic_vector(7 downto 0):=(others=>'0');
	signal FSM_FIFO_TO_SRAM2_flag 	: std_logic_vector(7 downto 0):=(others=>'0');

	--Data FIFO to SRAM
	type DATA_FROM_FIFO1_type 			is array (1 to 2) of std_logic_vector(DIN_FIFO1'range);
	signal DATA_FROM_FIFO1 				: DATA_FROM_FIFO1_type;
	type DATA_FROM_FIFO2_type 			is array (1 to 2) of std_logic_vector(DIN_FIFO2'range);
	signal DATA_FROM_FIFO2 				: DATA_FROM_FIFO2_type;		

	--rd_en fifo
	signal RD_EN_FIFO1_tmp				: std_logic_vector(2 downto 1):=(others=>'0');		
	signal RD_EN_FIFO2_tmp				: std_logic_vector(2 downto 1):=(others=>'0');	
	---------------******************************END FSM_SRAM**********************************----------------	


	---------------********************************FIFO_SRAM_CTRL_RESYNC************************************----------------
	--
	signal EMPTY_FIFO1_0_percent_resync_125M 	: std_logic:='0';
	signal EMPTY_FIFO2_0_percent_resync_125M 	: std_logic:='0';
	signal EMPTY_FIFO_0_percent 					: std_logic_vector(1 downto 0):=(others=>'0');
	signal EMPTY_FIFO_0_percent_resync_125M 	: std_logic_vector(1 downto 0):=(others=>'0');	
	--
	signal FIFO1_FIFO2_empty_ok					: std_logic_vector(2 downto 1):=(others=>'0');	
	signal FIFO1_FIFO2_empty_ok_resync_BC_CLK	: std_logic_vector(2 downto 1):=(others=>'0');
	--
	signal FIFO1_BUSY_valid : std_logic:='0';
	signal FIFO2_BUSY_valid : std_logic:='0';
	--
	signal FIFO1_BUSY_valid_del1 : std_logic:='0';
	signal FIFO1_BUSY_valid_del2 : std_logic:='0';	
	signal FIFO2_BUSY_valid_del1 : std_logic:='0';
	signal FIFO2_BUSY_valid_del2 : std_logic:='0';	
	signal FIFO1_BUSY_valid_del2_one_cycle : std_logic:='0';
	signal FIFO2_BUSY_valid_del2_one_cycle : std_logic:='0';		
	---------------******************************END FIFO_SRAM_CTRL_RESYNC**********************************----------------


	---------------********************************sTTS_CTRL************************************----------------
	--sTTS CTRL
	--FSM
	type FSM_sTTS_CTRL_states is (	FSM_sTTS_CTRL_idle_busy, FSM_sTTS_CTRL_ready, FSM_sTTS_CTRL_busy, FSM_sTTS_CTRL_OOS); 						
	signal FSM_sTTS_CTRL_state : FSM_sTTS_CTRL_states;		
	--signals
	signal sTTS_code 						: std_logic_vector(3 downto 0):=(others=>'0');
	--Codes
-- from origin tab 
--	constant sTTS_Disconnected 		: std_logic_vector(3 downto 0):="0000"; --or "1111"
--	constant sTTS_WarningOverflow		: std_logic_vector(3 downto 0):="0001";
--	constant sTTS_OOS						: std_logic_vector(3 downto 0):="0010";	
--	constant sTTS_Busy 					: std_logic_vector(3 downto 0):="0100";
--	constant sTTS_Ready 					: std_logic_vector(3 downto 0):="1000";
--	constant sTTS_Error 					: std_logic_vector(3 downto 0):="1100";
	--from direct measurement / no need polarity
	constant sTTS_Disconnected 		: std_logic_vector(3 downto 0):="1100"; 
	constant sTTS_WarningOverflow		: std_logic_vector(3 downto 0):="0001";
	constant sTTS_OOS						: std_logic_vector(3 downto 0):="0010";	
	constant sTTS_Busy 					: std_logic_vector(3 downto 0):="1000";
	constant sTTS_Ready 					: std_logic_vector(3 downto 0):="0111";
	constant sTTS_Error 					: std_logic_vector(3 downto 0):="1111";
	---------------******************************END sTTS_CTRL**********************************----------------


	---------------********************************FLAGS_RESYNC************************************----------------

	--flags linked with the SW 
	signal flags_vhdl_to_pc_32b 					: std_logic_vector(31 downto 0):=(others=>'0');
	signal flags_vhdl_to_pc_resync_32b 			: std_logic_vector(31 downto 0):=(others=>'0');	
	signal sTTS_flags_vhdl_to_pc_14b 			: std_logic_vector(13 downto 0):=(others=>'0');
	signal sTTS_flags_vhdl_to_pc_14b_resync 	: std_logic_vector(13 downto 0):=(others=>'0');		
	--
	signal flags_pc_to_vhdl_2b 					: std_logic_vector(1 downto 0):=(others=>'0'); 
	signal flags_pc_to_vhdl_resync_2b 			: std_logic_vector(1 downto 0):=(others=>'0');
	--
	signal cdr_flags_for_sTTS_resync 			: std_logic_vector(2 downto 0):=(others=>'0');
	signal FIFO_flags_for_sTTS 					: std_logic_vector(1 downto 0):=(others=>'0');
	signal FIFO_flags_for_sTTS_resync 			: std_logic_vector(1 downto 0):=(others=>'0');	
	--OOS CTRL
	signal sTTS_CTRL_all_failures 				: std_logic_vector(5 downto 0):=(others=>'0');	
	signal FSM_sTTS_CTRL_flag 						: std_logic_vector(7 downto 0):=(others=>'0');
	--Spurious
	signal spurious_flag 							: std_logic:='0';
	signal spurious_flag_vect 						: std_logic_vector(0 downto 0):=(others=>'0');	
	signal spurious_flag_vect_resync 			: std_logic_vector(0 downto 0):=(others=>'0');
	signal spurious_flag_resync 					: std_logic:='0';
	--stop acq when OOS
	--signal OOS_state_valid : std_logic:='0';
	--storage in fifo1 of oos_flags / data flow	
	signal spurious_flag_to_store 				: std_logic:='0';
	signal cdr_lol_to_store 						: std_logic:='0';
	signal cdr_los_to_store 						: std_logic:='0';
	signal cdr_clk_locked_to_store 				: std_logic:='0';
	signal sTTS_code_to_store 						: std_logic_vector(sTTS_code'range):=(others=>'0');
	signal spurious_flag_to_store_resync_BC_CLKC 	: std_logic:='0';
	signal cdr_lol_to_store_resync_BC_CLKC 			: std_logic:='0';
	signal cdr_los_to_store_resync_BC_CLKC 			: std_logic:='0';
	signal cdr_clk_locked_to_store_resync_BC_CLKC 	: std_logic:='0';
	signal sTTS_code_to_store_resync_BC_CLKC 	: std_logic_vector(sTTS_code'range):=(others=>'0');
	signal oos_flags_to_store 						: std_logic_vector(7 downto 0):=(others=>'0');
	signal oos_flags_to_store_resync_BC_CLKC 	: std_logic_vector(7 downto 0):=(others=>'0');
	---------------******************************END FLAGS_RESYNC**********************************----------------
	


	
	--TEST
	signal DIN_FIFO2_del					: std_logic_vector(DIN_FIFO2'range):=(others=>'0'); 

	---------------********************************CHIPSCOPE************************************----------------
	signal CONTROL0 						: std_logic_vector(35 downto 0);
	signal data_ila_ttc_fmc_14b 		: std_logic_vector(13 downto 0):=(others=>'0');
	signal data_ila_ttc_fmc_150b 		: std_logic_vector(149 downto 0):=(others=>'0');
	signal trigger_ila_ttc_fmc 		: std_logic:='0'; 
	---------------******************************END CHIPSCOPE**********************************----------------
	



	
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
   
   ip_addr_o				               <= x"c0a8006f";      -- 192.168.0.111
   mac_addr_o 				               <= x"080030F10000";  -- 08:00:30:F1:00:00 
  
  
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
	


	---------------********************************CHIPSCOPE************************************----------------
	--===============================================================================================--
	--===============================================================================================--
	Inst_icon_ttc_fmc: entity work.icon_ttc_fmc
	--===============================================================================================--
		port map (	CONTROL0 	=> CONTROL0
					);
	--===============================================================================================--

	--cbc frame in 150b
	
	--===============================================================================================--
	Inst_ila_ttc_fmc: entity work.ila_ttc_fmc
	--===============================================================================================--					
		port map (	CONTROL 		=> CONTROL0,
						CLK 			=> BC_CLK,--cdr_clk,
						DATA 			=> data_ila_ttc_fmc_150b, --150bits
						TRIG0(0) 	=> trigger_ila_ttc_fmc --cdr_clk_locked --1bit
					);	
	--===============================================================================================--					
		
	--===============================================================================================--							
	process
	--===============================================================================================--					
	begin
		wait until rising_edge(BC_CLK);--(cdr_clk);
			data_ila_ttc_fmc_150b 	<=  "0000000" & cbc_rcv_capture_out & cbc_rcv_data_138b_tmp1 & cbc_rcv_data_138b_en & cbc_rcv_data_138b_en_tmp1 & L1A_valid & cbc_frame_in;
			trigger_ila_ttc_fmc 		<= cbc_rcv_capture_out; 
	end process;	
	--===============================================================================================--						
	---------------******************************END CHIPSCOPE**********************************----------------
				


	---------------********************************CLOCKING************************************----------------				
	--> TTC FMC on FMC1
	--===============================================================================================--
	--CDR 160M 	--cf user_clk.ucf : sur CON FMC = K4/K5 - ucf = D11/D12
	--===============================================================================================--
	--===============================================================================================--
	inst_fmc1_clk2_bidir_bufgds: ibufgds --cdr 160M
	--===============================================================================================--
	generic map(	DIFF_TERM 	=> TRUE,
						IOSTANDARD 	=> "LVDS_25") 
	port map(		i 				=> fmc1_clk2_bidir_p, 
						ib 			=> fmc1_clk2_bidir_n, 
						o 				=> fmc1_clk2_bidir_bufgds
				);
	--===============================================================================================--	--===============================================================================================--

	--===============================================================================================--	
	inst_ffmc1_clk2_bidir_bufg: bufg --cdr 160M
	--===============================================================================================--
	port map(		i => fmc1_clk2_bidir_bufgds,--xpoint1_clk1_i, --fmc1_clk2_bidir_bufgds, -bufgmux!!
						o => fmc1_clk2_bidir_bufg
				);
	--===============================================================================================--

	cdr_clk 	<= fmc1_clk2_bidir_bufg; --input of ttcrx

	--> INTERNAL OSC
	--OSC / pri_clk : take care on xpoint1 config!!!
	--===============================================================================================--
	inst_xpoint1_clk1_i_bufg: bufg --provided by system_core but no bufg
	--===============================================================================================--
	port map(		i => xpoint1_clk1_i, 
						o => xpoint1_clk1_i_bufg 
				);
	--===============================================================================================--


--	--OSC + see generic map higher et set false
--	BC_CLK 		<= xpoint1_clk1_i_bufg;
--	SRAM_CLK 	<= xpoint1_clk1_i_bufg;	
	--TTC_FMC + see generic map higher and set true + comment just previous code
--	BC_CLK 		<= cdr_clk_40M_0_180;
--	SRAM_CLK 	<= cdr_clk_40M_0_180;		

	clock_select_1 : if TTC_CLK_USED = true generate
   begin
		--clock from ttcrx
		BC_CLK 		<= cdr_clk_40M_0_180;
		SRAM_CLK 	<= cdr_clk_40M_0_180;
	end generate;

	clock_select_2 : if TTC_CLK_USED = false generate
   begin
		--clock from internal OSC of GLIBv3
		BC_CLK 		<= xpoint1_clk1_i_bufg;
		SRAM_CLK 	<= xpoint1_clk1_i_bufg;
	end generate;	
	
	
	---------------******************************END CLOCKING**********************************----------------






	---------------********************************TTC_FMC************************************----------------
	--TTC_FMC_v3 on FMC1 !!!
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
		CLK_OUT_MUX_SEL 	=> CLK_DEPHASING,
		--
		cdrclk_locked		=> cdr_clk_locked,
		cdrclk_out			=> open,--cdr_clk_160M_0, 
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
	i2c: entity work.i2c_master_no_iobuf --TTC_FMC / I2C Interface
	--===============================================================================================--
	port map
	(
		reset						=> wb_mosi_i(0).wb_rst,
		clk						=> wb_mosi_i(0).wb_clk,
		------------------------------
		settings					=> ttc_fmc_reg_i2c_settings(12 downto 0),
		command					=> ttc_fmc_reg_i2c_command, 			-- ttc_fmc_reg_i2c_command[31:28] clears automatically
		reply						=> ttc_fmc_reg_i2c_reply,
		busy						=> open,
		------------------------------
		scl_i(0)					=> 'Z',						scl_i(1)			=> 'Z',
		scl_o(0)					=> fabric_scl_o,			scl_o(1)			=> open,
		scl_oe_l(0)				=> fabric_scl_oe_l,		scl_oe_l(1)		=> open,
		sda_i(0)					=> fabric_sda_i,			sda_i(1)			=> 'Z',
		sda_o(0)					=> fabric_sda_o,			sda_o(1)			=> open,
		sda_oe_l(0)				=> fabric_sda_oe_l,		sda_oe_l(1)		=> open
	); 			
	--===============================================================================================--



	--===============================================================================================--
	-- Register mapping
	--===============================================================================================--
	ttc_fmc_xpoint_4x4_s10		<= ttc_fmc_reg_ctrl(16); 	-- default S10=0, S11=1: in2 -> out1 (clk_40 -> tp R13)
	ttc_fmc_xpoint_4x4_s11		<= ttc_fmc_reg_ctrl(17); 
	ttc_fmc_xpoint_4x4_s20		<= ttc_fmc_reg_ctrl(18); 	-- default S20=0, S21=1: in2 -> out2 (clk_40 -> cdce_pri_clk)
	ttc_fmc_xpoint_4x4_s21		<= ttc_fmc_reg_ctrl(19);
	ttc_fmc_xpoint_4x4_s30		<= ttc_fmc_reg_ctrl(20); 	-- default S30=1, S31=1: in4 -> out3 (clk160 -> fmc_clk1_m2c)
	ttc_fmc_xpoint_4x4_s31		<= ttc_fmc_reg_ctrl(21); 
	ttc_fmc_xpoint_4x4_s40		<= ttc_fmc_reg_ctrl(22); 	-- default S40=0, S41=1: in2 -> out4 (clk_40 -> fmc_clk0_m2c)
	ttc_fmc_xpoint_4x4_s41		<= ttc_fmc_reg_ctrl(23);

	ttc_fmc_reg_status(29)		<= cdr_lol;
	ttc_fmc_reg_status(30)		<= cdr_los;
	ttc_fmc_reg_status(31)		<= cdr_clk_locked;
	--===============================================================================================--
	
	
	--===============================================================================================--
	-- TTC_FMC IO mapping / FMC1 !!!
	--===============================================================================================--
	cdr_data 										<= 	fmc1_from_pin_to_fabric.la_lvds(9)		;
	lemo_lm2											<= 	fmc1_from_pin_to_fabric.la_lvds(6)		;
	fabric_sda_i									<= 	fmc1_from_pin_to_fabric.la_cmos_n(7)	;	-- I/O
	cdr_lol 											<= 	fmc1_from_pin_to_fabric.la_cmos_p(8)	;
	cdr_los 											<= 	fmc1_from_pin_to_fabric.la_cmos_n(8)	;
	
	fmc1_from_fabric_to_pin.la_cmos_p(0)	<= ttc_fmc_xpoint_4x4_s10; 	fmc1_from_fabric_to_pin.la_cmos_p_oe_l(0) <= '0';
	--fmc1_from_fabric_to_pin.la_cmos_n(0)	<= ttc_fmc_xpoint_4x4_s41; 	fmc1_from_fabric_to_pin.la_cmos_n_oe_l(0) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_p(2)	<= ttc_fmc_xpoint_4x4_s11; 	fmc1_from_fabric_to_pin.la_cmos_p_oe_l(2) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_n(2)	<= ttc_fmc_xpoint_4x4_s20; 	fmc1_from_fabric_to_pin.la_cmos_n_oe_l(2) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_p(3)	<= ttc_fmc_xpoint_4x4_s21; 	fmc1_from_fabric_to_pin.la_cmos_p_oe_l(3) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_n(3)	<= ttc_fmc_xpoint_4x4_s40; 	fmc1_from_fabric_to_pin.la_cmos_n_oe_l(3) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_p(4)	<= ttc_fmc_xpoint_4x4_s30; 	fmc1_from_fabric_to_pin.la_cmos_p_oe_l(4) <= '0';
	fmc1_from_fabric_to_pin.la_cmos_n(4)	<= ttc_fmc_xpoint_4x4_s31; 	fmc1_from_fabric_to_pin.la_cmos_n_oe_l(4) <= '0';
	--s41 modified

	fmc1_from_fabric_to_pin.la_cmos_p(7)	<= fabric_scl_o;					fmc1_from_fabric_to_pin.la_cmos_p_oe_l(7)	<= fabric_scl_oe_l; 
	fmc1_from_fabric_to_pin.la_cmos_n(7)	<= fabric_sda_o;					fmc1_from_fabric_to_pin.la_cmos_n_oe_l(7)	<= fabric_sda_oe_l; --I/O 
	fmc1_from_fabric_to_pin.la_cmos_p(10)	<= divider_rst_b;					fmc1_from_fabric_to_pin.la_cmos_p_oe_l(10)<= '0';
	fmc1_from_fabric_to_pin.la_cmos_n(10)	<= divider_div4 ;					fmc1_from_fabric_to_pin.la_cmos_n_oe_l(10)<= '0';
	
	--new : 3DE & 2DE
	ttc3_3DE <= ttc_fmc_regs_from_wb(19)(4); --'1'; --param
	ttc3_2DE <= ttc_fmc_regs_from_wb(19)(5); --'1'; --param; 
	fmc1_from_fabric_to_pin.la_cmos_n(0)	<= ttc3_3DE;						fmc1_from_fabric_to_pin.la_cmos_n_oe_l(0)	<= '0'; 	
	fmc1_from_fabric_to_pin.la_cmos_p(1)	<= ttc3_2DE;						fmc1_from_fabric_to_pin.la_cmos_p_oe_l(1)	<= '0'; 	

	--new : user_led ctrl
	ttc3_user_led_n <= ttc_fmc_regs_from_wb(19)(6); --'1'; --param '0'; --en if '0'
	fmc1_from_fabric_to_pin.la_cmos_n(5)	<= ttc3_user_led_n;				fmc1_from_fabric_to_pin.la_cmos_n_oe_l(5)	<= '0'; 	
	--===============================================================================================--	
	---------------******************************END TTC_FMC**********************************----------------


				


	---------------********************************BRCST_RESYNC************************************----------------
	--useful if TTC_FMC used
	--===============================================================================================--	
	process
	--===============================================================================================--	
	begin
		wait until rising_edge(BC_CLK);
			--
			brcststr_sync(0) <= brcststr;
			brcststr_sync(1) <= brcststr_sync(0);
			--
			brcst_sync(0) <= brcst;
			brcst_sync(1) <= brcst_sync(0);			
--			if brcststr_sync(1) = '1' then
--				brcst_sync(1) <= brcst_sync(0);	
--			end if;
	end process;	
	--===============================================================================================--		
	---------------******************************END BRCST_RESYNC**********************************----------------	
	
	
	---------------********************************TRIGGER************************************----------------
	--===============================================================================================--
	process --internal trigger
	--===============================================================================================--	
	variable int_trigger_counter : integer range 0 to 40e6:=0; 
	begin
		wait until rising_edge(BC_CLK); --40M
			--if PC_config_ok = '0' or cmd_stop_valid = '1' or int_trigger = '1' then
			if PC_config_ok = '0' or int_trigger = '1' then
				int_trigger_counter := 0;
				int_trigger 	<= '0';
			else
				int_trigger_counter := int_trigger_counter + 1;
					if 	INT_TRIGGER_FREQ_SEL = 0 	and int_trigger_counter = 40e6  		then 	int_trigger <= '1'; --1Hz
					elsif INT_TRIGGER_FREQ_SEL = 1 	and int_trigger_counter = 20e6  		then 	int_trigger <= '1'; --2Hz 
					elsif INT_TRIGGER_FREQ_SEL = 2 	and int_trigger_counter = 10e6  		then 	int_trigger <= '1'; --4Hz
					elsif INT_TRIGGER_FREQ_SEL = 3 	and int_trigger_counter = 5e6  		then 	int_trigger <= '1'; --8Hz
					elsif INT_TRIGGER_FREQ_SEL = 4 	and int_trigger_counter = 2500000  	then 	int_trigger <= '1'; --16Hz
					elsif INT_TRIGGER_FREQ_SEL = 5 	and int_trigger_counter = 1250000 	then 	int_trigger <= '1'; --32Hz
					elsif INT_TRIGGER_FREQ_SEL = 6 	and int_trigger_counter = 625000		then 	int_trigger <= '1'; --64Hz
					elsif INT_TRIGGER_FREQ_SEL = 7 	and int_trigger_counter = 312500		then 	int_trigger <= '1'; --128Hz
					elsif INT_TRIGGER_FREQ_SEL = 8 	and int_trigger_counter = 156250		then 	int_trigger <= '1'; --256Hz
					elsif INT_TRIGGER_FREQ_SEL = 9 	and int_trigger_counter = 78125		then 	int_trigger <= '1'; --512Hz
					elsif INT_TRIGGER_FREQ_SEL = 10 	and int_trigger_counter = 39062  	then 	int_trigger <= '1'; --1024Hz
					elsif INT_TRIGGER_FREQ_SEL = 11 	and int_trigger_counter = 19531  	then 	int_trigger <= '1'; --2048Hz
					elsif INT_TRIGGER_FREQ_SEL = 12 	and int_trigger_counter = 9766  		then 	int_trigger <= '1'; --4096Hz	
					elsif INT_TRIGGER_FREQ_SEL = 13 	and int_trigger_counter = 4883  		then 	int_trigger <= '1'; --8192Hz
					elsif INT_TRIGGER_FREQ_SEL = 14 	and int_trigger_counter = 2441  		then 	int_trigger <= '1'; --16384Hz
					elsif INT_TRIGGER_FREQ_SEL = 15 	and int_trigger_counter = 1221  		then 	int_trigger <= '1'; --32768Hz					
					else 																								int_trigger <= '0';
					end if; 
			end if;
	end process;			
	--===============================================================================================--				


	--===============================================================================================--				
	process --choice between int_trigger or L1A
	--===============================================================================================--				
	begin
		wait until rising_edge(BC_CLK); --l1accept is sync by 160M clock but active high = active low from generator !!!
			--if PC_config_ok = '0' or cmd_stop_valid = '1' then --not needed in fact
			if PC_config_ok = '0' then 
				l1accept_sync(0) <= '0';
				l1accept_sync(1) <= '0';				
			else
				if TRIGGER_SEL = '0' then
					l1accept_sync(0) <= int_trigger; --l1accept;
				else
					l1accept_sync(0) <= l1accept; --TTC 
				end if;

				l1accept_sync(1) <= l1accept_sync(0);
--				--à tester
--				l1accept_sync_one_cycle <= l1accept_sync(0); 
			end if;
	end process;
	--===============================================================================================--				
	

	--===============================================================================================--				
	block_trigger_anti_rebond : block						
	--===============================================================================================--				
		type states is (s0,s1);
		signal state : states;
	begin
		process
		variable counter : integer range 0 to 7:=7; --for 3 cycles mini
			begin			
				wait until rising_edge(BC_CLK);
					if PC_config_ok = '0' then
						state <= s0;
						l1accept_sync_one_cycle <= '0';
					else
						case state is
							when s0 => 									
								if l1accept_sync(1) = '1' then
									l1accept_sync_one_cycle <= '1';
									state <= s1;
								end if;
								counter := 2;--7
							when s1 =>
								if counter = 0 then
									state <= s0;
								else
									counter := counter - 1;
								end if;
								l1accept_sync_one_cycle <= '0'; --one cycle duration
							when others =>
								null;
						end case;
					end if;
		end process;
	end block;
	--===============================================================================================--				

	--===============================================================================================--				
	process --Final Trigger
	--===============================================================================================--					
	begin
		wait until rising_edge(BC_CLK);
			L1A_VALID <= cmd_start_valid and l1accept_sync_one_cycle;
	end process;
	--===============================================================================================--				
	---------------******************************END TRIGGER**********************************----------------
	

	
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
	CBC_DATA_GENE 						<= ttc_fmc_regs_from_wb(16)(30); --/BC_CLK
	SPURIOUS_FRAME						<= ttc_fmc_regs_from_wb(16)(31); --/BC_CLK 				
	CLK_DEPHASING 						<= ttc_fmc_regs_from_wb(19)(0);
	POLARITY_sTTS						<= ttc_fmc_regs_from_wb(19)(1);
	POLARITY_CBC						<= ttc_fmc_regs_from_wb(19)(2);
	CMD_START_BY_PC					<= ttc_fmc_regs_from_wb(19)(3);	
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
		rdclk_i							=> SRAM_CLK, 
		wdata_i							=> flags_pc_to_vhdl_2b,
		rdata_o							=> flags_pc_to_vhdl_resync_2b
	); 

	SRAM1_end_readout    			<= flags_pc_to_vhdl_resync_2b(0);
	SRAM2_end_readout    			<= flags_pc_to_vhdl_resync_2b(1);	
	--===============================================================================================--

	-->VHDL to SW
	ttc_fmc_regs_to_wb(18)(14) 			<= cmd_start_valid;
	--flags
	ttc_fmc_regs_to_wb(17) 					<= flags_vhdl_to_pc_resync_32b;	
	ttc_fmc_regs_to_wb(18)(13 downto 0) <= sTTS_flags_vhdl_to_pc_14b_resync; 	

	--===============================================================================================--
	-- TTC_FMC registers mapping
	--===============================================================================================--
	ttc_fmc_reg_ctrl					<= ttc_fmc_regs_from_wb(4);	
	ttc_fmc_regs_to_wb(6)			<=	ttc_fmc_reg_status;
   ttc_fmc_reg_i2c_settings		<= ttc_fmc_regs_from_wb(13);
	ttc_fmc_reg_i2c_command			<= ttc_fmc_regs_from_wb(14); -- [31:28] auto-clear
	ttc_fmc_regs_to_wb(15)			<=	ttc_fmc_reg_i2c_reply	;
	--===============================================================================================--
	
	--===============================================================================================--
	-- CBC registers mapping
	--===============================================================================================--
   --I2c
	cbc_reg_i2c_settings			<= ttc_fmc_regs_from_wb(24)								;
	cbc_reg_i2c_command			<= ttc_fmc_regs_from_wb(25)								; -- [31:28] auto-clear
	ttc_fmc_regs_to_wb(26)		<=	cbc_reg_i2c_reply	;
	--cmd
	CBC_RESET_SEL	 				<= ttc_fmc_regs_from_wb(27)(1 downto 0); 	--"01" : cbc_hard_reset 		/ "10" : cbc_reset101
	--===============================================================================================--
	---------------******************************END PARAMETERS**********************************----------------





--	---------------********************************CMD_STOP_VALID************************************----------------
--	--===============================================================================================--
--	process 
--	--===============================================================================================--
--	variable cmd_stop_counter : integer range 0 to 15:=15;
--	--===============================================================================================--
--	begin
--		wait until rising_edge(BC_CLK);
--			if PC_config_ok = '0' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_STOP) then
--				cmd_stop_valid <= '1';
--				cmd_stop_counter := 15;
--			elsif cmd_stop_counter = 0 then
--				cmd_stop_valid <= '0';
--			else
--				cmd_stop_valid <= '1';
--				cmd_stop_counter := cmd_stop_counter-1;
--			end if;
--	end process;
--	--===============================================================================================--
--	---------------******************************END CMD_STOP_VALID**********************************----------------
	





	---------------********************************CBC_CTRL************************************----------------
	--=====================--
	--CBCv1 on FMC2 !!
	--=====================--


	--===============================================================================================--
	cbc_i2c: entity work.i2c_master_no_iobuf --I2C interface
	--===============================================================================================--
	port map
	(
		reset						=> wb_mosi_i(0).wb_rst,
		clk						=> wb_mosi_i(0).wb_clk, --wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk, 62.5M
		------------------------------
		settings					=> cbc_reg_i2c_settings(12 downto 0),
		command					=> cbc_reg_i2c_command, 			-- cbc_reg_i2c_command[31:28] clears automatically
		reply						=> cbc_reg_i2c_reply,
		busy						=> open,
		------------------------------
		scl_i(0)					=> 'Z',							scl_i(1)		=> 'Z',
		scl_o(0)					=> cbc_fabric_scl_o,			scl_o(1)		=> open,
		scl_oe_l(0)				=> cbc_fabric_scl_oe_l,		scl_oe_l(1)	=> open,
		sda_i(0)					=> cbc_fabric_sda_i,			sda_i(1)		=> 'Z',
		sda_o(0)					=> cbc_fabric_sda_o,			sda_o(1)		=> open,
		sda_oe_l(0)				=> cbc_fabric_sda_oe_l,		sda_oe_l(1)	=> open
	); 
	--===============================================================================================--

	--===============================================================================================--
	-- FMC2 I/O mapping
	--===============================================================================================--
	---***i2c interface***--
	--IN
	-->SDA_IN
	cbc_fabric_sda_i										<= fmc2_from_pin_to_fabric.la_cmos_p(17)	;	
	--OUT
	-->SCL_OUT
	fmc2_from_fabric_to_pin.la_cmos_p(19)			<= cbc_fabric_scl_o		;	
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(19)	<= cbc_fabric_scl_oe_l	; 
	-->SDA_OUT
	fmc2_from_fabric_to_pin.la_cmos_p(18)			<= cbc_fabric_sda_o		;	
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(18)	<= cbc_fabric_sda_oe_l	;
	---***others***--
	--IN
	-->DATA_2V5
	cbc_data_2v5											<= fmc2_from_pin_to_fabric.la_cmos_p(1)	;	
	--OUT
	-->DATA_CLK_2V5 
	fmc2_from_fabric_to_pin.la_cmos_p(3)			<= BC_CLK		;	
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(3)		<= '0'				;
	-->TRIG_2V5 
	fmc2_from_fabric_to_pin.la_cmos_p(2)			<= not cbc_trigger		; --TRG_2V5	
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(2)		<= '0'				;	
	-->CLK_2V5
	fmc2_from_fabric_to_pin.la_cmos_p(0)			<= cbc_clk_2v5_1MHz		;	--towards DC-DC converter
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(0)		<= '0'				;
	-->RESET_2V5
	fmc2_from_fabric_to_pin.la_cmos_p(16)			<= cbc_hard_reset		;	
	fmc2_from_fabric_to_pin.la_cmos_p_oe_l(16)	<= '0'				;			
	--===============================================================================================--

	--hard reset 
	cbc_hard_reset 			<= CBC_RESET_SEL(0); --direct		

	--===============================================================================================--
	-- cbc_reset101 generation
	--===============================================================================================--
	reset101_reg <= "00010100";
	process
	--variable  counter : integer range 0 to 7:=7;
		begin	
		wait until falling_edge(BC_CLK);		--falling edge !!!!
			--
			if PC_config_ok  = '0' or CBC_RESET_SEL(0) = '1' then --cbc_hard_reset
				cbc_trigger <= '0';
				reset101_reg_index <= 0;
			elsif CBC_RESET_SEL(1) = '1' then 	--cbc_reset101 en
				if reset101_reg_index = 7 then
					cbc_trigger <= l1accept_sync_one_cycle; --or 0 ???
				else
					cbc_trigger <= reset101_reg(reset101_reg_index);
					reset101_reg_index <= reset101_reg_index + 1;
				end if;
			else --cbc_reset101 dis
				cbc_trigger <= l1accept_sync_one_cycle;
				reset101_reg_index <= 0;
			end if;
	end process;	
	--===============================================================================================--

--	--===============================================================================================--
--	-- new cbc_reset101 generation
--	--===============================================================================================--
--	process
--	variable  counter : integer range 0 to 7:=0;
--		begin	
--		wait until falling_edge(BC_CLK);		--front descendant !!!
--			--
--			if PC_config_ok  = '0' or CBC_RESET_SEL(0) = '1' then --cbc_hard_reset
--				cbc_trigger <= '0';
--				counter := 0;
--			elsif CBC_RESET_SEL(1) = '1' then 	--cbc_reset101
--				if counter /= 5 then	--enabled
--					if counter = 1 or counter = 3 then
--						cbc_trigger <= '1';
--					else
--						cbc_trigger <= '0';
--					end if;
--					counter := counter + 1;
--				else
--					cbc_trigger <= l1accept_sync_one_cycle; --or 0 ???
--				end if;
--			else
--				cbc_trigger <= l1accept_sync_one_cycle;
--			end if;
--	end process;	
--	--===============================================================================================--


	--===============================================================================================--
	-- 1MHz generation for DC-DC on CBC
	--===============================================================================================--
	process
	constant div_counter : natural := 40; --62.5
	variable  counter : integer range 0 to div_counter/2-1:=div_counter/2-1; --0 to 62.5e6/2-1:=62.5e6/2-1;
	variable clock_1MHz : std_logic := '0';
	begin
		wait until rising_edge(BC_CLK); --(wb_mosi_i(0).wb_clk); --wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk, 62.5M
--			if PC_config_ok  = '0' or CBC_RESET_SEL(0) = '1' then --cbc_hard_reset
--				counter := 62.5e6/2-1;
--				cbc_clk_2v5_1MHz <= '0';
--			elsif 
			if counter = 0 then
				clock_1MHz := not clock_1MHz;
				counter := div_counter/2-1;
			else
				counter := counter - 1;
			end if;
			cbc_clk_2v5_1MHz <= clock_1MHz;
	end process;
	--===============================================================================================--				
	---------------******************************END CBC_CTRL**********************************----------------




	---------------********************************CBC_RECEIVER************************************----------------
	--===============================================================================================--	
	process --Polarity select
	--===============================================================================================--
	begin
		wait until rising_edge(BC_CLK);
			if POLARITY_CBC = '0' then --positive
				cbc_frame_in <= cbc_data_2v5; 
			else
				cbc_frame_in <= not cbc_data_2v5; 
			end if;
	end process;
	--===============================================================================================--	
	
	cbc_frame_aclr <= not PC_config_ok;-- or cmd_start_valid;	
	
	--===============================================================================================--
	Inst_cbc_frame_detect: entity work.cbc_frame_detect  --deserialiser (serie to //)
	--===============================================================================================--
	PORT MAP(	clk 				=> BC_CLK,
					async_reset 	=> cbc_frame_aclr, --active high
					data_in 			=> cbc_frame_in,
					data_out 		=> cbc_rcv_data_138b_tmp1, 
					write_en 		=> cbc_rcv_data_138b_en_tmp1,--active high / one cycle
					capture_out		=> cbc_rcv_capture_out
				);							
	--===============================================================================================--
	


	--===============================================================================================--
	process --cbc data select
	--===============================================================================================--
	begin
		wait until rising_edge(BC_CLK);
			if PC_config_ok = '0' or cmd_start_valid = '0' then
				cbc_rcv_data_138b_en <= '0';
				cbc_rcv_data_138b <= "10"&x"aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa"; --tested data
			--
			elsif CBC_DATA_GENE = '0' then --internal data / debug
				cbc_rcv_data_138b_en <= L1A_VALID;-- or SPURIOUS_FRAME;
				if WR_EN_FIFO1 = '1' then --once write made in fifo1, word is reversed
					cbc_rcv_data_138b <= not cbc_rcv_data_138b; 
				end if;
			--
			else --from cbc_receiver / true data 
				cbc_rcv_data_138b_en <= cbc_rcv_data_138b_en_tmp1;	--from cbc_frame_detect	
				cbc_rcv_data_138b <= cbc_rcv_data_138b_tmp1;								
			end if;
	end process;
	--===============================================================================================--
	---------------******************************END CBC_RECEIVER**********************************----------------	
	


	
	
	

	
	---------------********************************ACQ_COUNTERS************************************----------------
	--===============================================================================================--
	process(PC_config_ok,BC_CLK) --Bunch Crossing Counter / not full counter !!!
	--===============================================================================================--
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			BC_COUNTER_12b <= (others=>'0');
		elsif rising_edge(BC_CLK) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) or BC_COUNTER_12b = 3563 then 
			if cmd_start_valid = '0' or BC_COUNTER_12b = 3563 then
				BC_COUNTER_12b <= (others=>'0');
			else
				BC_COUNTER_12b <= BC_COUNTER_12b + 1;
			end if;
		end if;
	end process;

	--BC_COUNTER_24 : extension of bits
	BC_COUNTER_24b <= x"000" & BC_COUNTER_12b;
	--===============================================================================================--	


	--===============================================================================================--
	process(PC_config_ok,BC_CLK) --Orbit Counter / full counter
	--===============================================================================================--
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			ORB_COUNTER_18b <= (others=>'0');
		elsif rising_edge(BC_CLK) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) then
			if cmd_start_valid = '0' then
				ORB_COUNTER_18b <= (others=>'0');
			elsif BC_COUNTER_12b = 3563 then
				ORB_COUNTER_18b <= ORB_COUNTER_18b + 1;
			else
				null;
			end if;
		end if;
	end process;
	
	--ORB_COUNTER_24b : extension of bits
	ORB_COUNTER_24b <= "000000" & ORB_COUNTER_18b;
	--===============================================================================================--	



	--===============================================================================================--	
	process(PC_config_ok,BC_CLK) --Lumi-Section Counter / full counter
	--===============================================================================================--	
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			LS_COUNTER_24b <= (others=>'0');
		elsif rising_edge(BC_CLK) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) then
			if cmd_start_valid = '0' then
				LS_COUNTER_24b <= (others=>'0');
			elsif ORB_COUNTER_18b = 2**18-1 then
				LS_COUNTER_24b <= LS_COUNTER_24b + 1;
			else
				null;
			end if;
		end if;
	end process;
	--===============================================================================================--	


	--===============================================================================================--	
	process(PC_config_ok,BC_CLK) --Trigger Counter
	--===============================================================================================--	
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			L1A_COUNTER_24b <= std_logic_vector(conv_unsigned(0,24));
		elsif rising_edge(BC_CLK) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) then
			if cmd_start_valid = '0' then
				L1A_COUNTER_24b <= std_logic_vector(conv_unsigned(0,24));
			elsif L1A_VALID = '1' then --cmd_start_valid = '1' and l1accept_sync_one_cycle = '1' then
				L1A_COUNTER_24b <= L1A_COUNTER_24b + 1;
			else
				null;
			end if;
		end if;
	end process;
	--===============================================================================================--	
	

	--===============================================================================================--	
	process(PC_config_ok,BC_CLK) --CBC_DATA_COUNTER
	--===============================================================================================--	
	begin
		if PC_config_ok = '0' then --async/TTC_FMC
			CBC_DATA_COUNTER_24b <= std_logic_vector(conv_unsigned(0,24)); --0 : DIN_FIFO latch into process / 1 : DIN_FIFO no process
		elsif rising_edge(BC_CLK) then
			--if cmd_stop_valid = '1' or (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) then
			if cmd_start_valid = '0' then
				CBC_DATA_COUNTER_24b <= std_logic_vector(conv_unsigned(0,24));
			elsif cbc_rcv_data_138b_en = '1' or SPURIOUS_FRAME = '1' then
			--elsif L1A_VALID = '1' or SPURIOUS_FRAME = '1' then 
				CBC_DATA_COUNTER_24b <= CBC_DATA_COUNTER_24b + 1;
			else
				null;
			end if;
		end if;
	end process;
	--===============================================================================================--	
	---------------******************************END ACQ_COUNTERS**********************************----------------	



	---------------********************************SPURIUOS_FRAME_DETECT************************************----------------	
	--===============================================================================================--		
	process(PC_config_ok,BC_CLK,cmd_start_valid) --if CBC_DATA_COUNTER_24b > L1A_COUNTER_24b
	--===============================================================================================--		
	begin
		if PC_config_ok = '0' or cmd_start_valid = '0' then --or cmd_stop_valid = '1' then --async/TTC_FMC
			spurious_flag <= '0';
		elsif rising_edge(BC_CLK) then
			if CBC_DATA_COUNTER_24b > L1A_COUNTER_24b then --if OVR ????
				spurious_flag <= '1';
			end if;
		end if;
	end process;		
	--===============================================================================================--		
	---------------******************************END SPURIUOS_FRAME_DETECT**********************************----------------	


		
		
	---------------********************************FIFO_CTRL_DELAY************************************----------------
	--del1 / counter / for wr in fifo
	process
	begin
		wait until rising_edge(BC_CLK);
			--wr_en for fifo1
			cbc_rcv_data_138b_en_del1 <= cbc_rcv_data_138b_en; --L1A_VALID_del1 for test
			--wr_en for fifo2
			L1A_VALID_del1 <= L1A_VALID;
	end process;
	--TEST
	DIN_FIFO2_del	<= DIN_FIFO2;	
--	process --for test
--	begin
--		wait until rising_edge(BC_CLK);
--			if L1A_valid = '1' then
--				DIN_FIFO2_del <= BC_COUNTER_24b & ORB_COUNTER_24b & LS_COUNTER_24b & L1A_COUNTER_24b;
--			end if;
--	end process;	
	---------------******************************END FIFO_CTRL_DELAY**********************************----------------
		

	---------------********************************FIFO2_STORAGE************************************----------------
	--> Storage of Time & Trigger Counters

	CLR_FIFO2 <= '0';

	--===============================================================================================--	
	inst_FIFO2_TIME_TRIGGER : entity work.FIFO2_TIME_TRIGGER 
	--===============================================================================================--	
	PORT MAP (	clk 			=> BC_CLK,
					--wr_clk		=> BC_CLK,
					--rd_clk		=> SRAM_CLK,
					--
					rst 			=> CLR_FIFO2,
					--write
					din 			=> DIN_FIFO2, --96b
					wr_en 		=> WR_EN_FIFO2,
					wr_ack      => FIFO2_wr_ack,
					--read
					rd_en 		=> RD_EN_FIFO2,
					dout 			=> DOUT_FIFO2,--96b
					--flags
					full 			=> FULL_FIFO2_100_percent,
					empty 		=> EMPTY_FIFO2_0_percent,
					valid 		=> VALID_FIFO2,
					prog_full 	=> FULL_FIFO2_75_percent	--not used now
					--prog_empty 	=> EMPTY_FIFO2_50_percent  --not used now
				);
	--===============================================================================================--	


	--===============================================================================================--		
	process (BC_CLK,PC_config_ok)--FIFO2 - FSM CTRL
	--===============================================================================================--	
	variable counter : integer range 0 to 15:=0; --100e6 : 10second!!! too long
	variable wait_busy : integer range 0 to 7:=7;
		begin	
			--if PC_config_ok = '0' or cmd_stop_valid = '1' then --(brcststr_sync(1) = '1' and brcst_sync(1) = CMD_STOP) then --totally async
			if PC_config_ok = '0' then	
				FSM_FIFO2_state <= FSM_FIFO2_idle;
				WR_EN_FIFO2 <= '0';
				cmd_start_valid <= '0';
				FIFO2_BUSY_valid <= '0'; --to signal the OOS_CTRL / PC
				sTTS_code <= sTTS_Busy; --by default
				FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(0,8));
				
			elsif rising_edge(BC_CLK) then
			--DATA to store
			DIN_FIFO2 <= BC_COUNTER_24b & ORB_COUNTER_24b & LS_COUNTER_24b & L1A_COUNTER_24b;

--			--condition for OOS
--			if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
--				FSM_FIFO2_state <= FSM_FIFO2_write_OOS;
--			else
				
				case FSM_FIFO2_state is
					
					when FSM_FIFO2_idle => 
						counter := 15;
						WR_EN_FIFO2 <= '0';
						FSM_FIFO2_state <= FSM_FIFO2_wait_start;
						cmd_start_valid <= '0';
						FIFO2_BUSY_valid <= '0'; --to signal the OOS_CTRL / PC
						wait_busy := 7;--init
						sTTS_code <= sTTS_Busy; --by default
						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(0,8));			
					
					--when FSM_FIFO2_RAZ_FIFO2 => --dummy reading / test empty
					
					when FSM_FIFO2_wait_start =>
						--if (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) and FIFO1_FIFO2_empty_ok_resync_BC_CLK = "11" then --FIFO1_FIFO2_empty_ok_resync_BC_CLK(sram1) = '1'
						if ( (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) or CMD_START_BY_PC ='1') and FIFO1_FIFO2_empty_ok_resync_BC_CLK = "11" then							
							cmd_start_valid <= '1';		
							FSM_FIFO2_state <= FSM_FIFO2_write1;
							sTTS_code <= sTTS_Ready;
						end if;
						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(1,8));
							
					when FSM_FIFO2_write1 =>
						sTTS_code <= sTTS_Ready;
						FIFO2_BUSY_valid <= '0';
						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
							FSM_FIFO2_state <= FSM_FIFO2_write_OOS;	
						elsif ACQ_MODE_RESYNC = '0' then
							if L1A_VALID_del1 = '1' then --L1A_VALID = '1' then--trigger-controlled
								WR_EN_FIFO2 <= '1';
								FSM_FIFO2_state <= FSM_FIFO2_BUSY;
							else
								WR_EN_FIFO2 <= '0';
							end if;				
						else		--if ACQ_MODE_RESYNC = '1' then--storage in continue
							if FULL_FIFO2_75_percent = '1' then
								FSM_FIFO2_state <= FSM_FIFO2_BUSY2;
								WR_EN_FIFO2 <= L1A_VALID_del1; --L1A_VALID; --if simultané, raz in busy2!!!--'0';
							elsif L1A_VALID_del1 = '1' then --L1A_VALID = '1' then
								WR_EN_FIFO2 <= '1';
							else
								WR_EN_FIFO2 <= '0';							
							end if;
						end if;
												
						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(2,8));
					
					when FSM_FIFO2_write_OOS => 
						sTTS_code <= sTTS_OOS;
						if FULL_FIFO2_100_percent = '1' then
							WR_EN_FIFO2 <= '0';
						else
							WR_EN_FIFO2 <= '1'; --write in continue to fill-in FIFO
						end if;						
						
						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(5,8));
				

					when FSM_FIFO2_BUSY2 => 
						sTTS_code <= sTTS_Busy;
						FIFO2_BUSY_valid <= '1';

						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
							FSM_FIFO2_state <= FSM_FIFO2_write_OOS;	
						elsif EMPTY_FIFO1_0_percent = '1' and EMPTY_FIFO2_0_percent = '1' then
							FSM_FIFO2_state <= FSM_FIFO2_write1;
							WR_EN_FIFO2 <= L1A_VALID_del1; --L1A_VALID; --if simultané???
						elsif L1A_VALID_del1 = '1' then --L1A_VALID = '1' then
							WR_EN_FIFO2 <= '1';
						else
							WR_EN_FIFO2 <= '0';								
						end if;						

						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(3,8));
					
					when FSM_FIFO2_BUSY => 
						sTTS_code <= sTTS_Busy;
						WR_EN_FIFO2 <= '0';
						FIFO2_BUSY_valid <= '1'; --to signal the OOS_CTRL / PC						

						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
							FSM_FIFO2_state <= FSM_FIFO2_write_OOS;	
						elsif SRAM1_full_one_cycle = '1' or SRAM2_full_one_cycle = '1' then		
							FIFO2_BUSY_valid <= '0';
							FSM_FIFO2_state <= FSM_FIFO2_write1; --return
							wait_busy := 7;--re-init
						else
							wait_busy := wait_busy - 1;
						end if;	
						FSM_FIFO2_flag <= std_logic_vector(conv_unsigned(4,8));						
				end case;
			--end if;
			end if;
	end process;						
	--===============================================================================================--	
	---------------******************************END FIFO2_STORAGE**********************************----------------	
	
	


	---------------********************************FIFO1_STORAGE************************************----------------
	--> Storage of CBC DATA
	
	CLR_FIFO1 <= '0';
	--WR_EN_FIFO1 <= cbc_rcv_data_138b_en;
	--===============================================================================================--	
	inst_FIFO1_CBC : entity work.FIFO1_CBC 
	--===============================================================================================--	
	PORT MAP (	clk 			=> BC_CLK,
					--wr_clk		=> BC_CLK,
					--rd_clk		=> SRAM_CLK,
					--
					rst 			=> CLR_FIFO1,
					--write
					din 			=> DIN_FIFO1, --170b
					wr_en 		=> WR_EN_FIFO1,
					wr_ack      => FIFO1_wr_ack,
					--read
					rd_en 		=> RD_EN_FIFO1,
					dout 			=> DOUT_FIFO1,--170b
					--flags
					full 			=> FULL_FIFO1_100_percent,
					empty 		=> EMPTY_FIFO1_0_percent,
					valid 		=> VALID_FIFO1,
					prog_full 	=> FULL_FIFO1_75_percent
					--prog_empty 	=> EMPTY_FIFO1_50_percent
				);
	--===============================================================================================--	
	
	

	--===============================================================================================--		
	process (BC_CLK,PC_config_ok)--,cmd_stop_valid)  --FIFO1 - FSM CTRL
	--===============================================================================================--	 	
	variable counter : integer range 0 to 15:=0; --100e6 : 10second!!! too long
	variable wait_busy : integer range 0 to 7:=7;
		begin	
			--if PC_config_ok = '0' or cmd_stop_valid = '1' then --(brcststr_sync(1) = '1' and brcst_sync(1) = CMD_STOP) then --totally async
			if PC_config_ok = '0' then	
				FSM_FIFO1_state <= FSM_FIFO1_idle;
				WR_EN_FIFO1 <= '0';
				FIFO1_BUSY_valid <= '0'; --to signal the OOS_CTRL / PC
				FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(0,8));
				
			elsif rising_edge(BC_CLK) then
			
			--true
			DIN_FIFO1 <= CBC_DATA_COUNTER_24b & cbc_rcv_data_138b & oos_flags_to_store_resync_BC_CLKC;
			--test
			--DIN_FIFO1 <= DIN_FIFO2_del(95 downto 72) & x"00" & DIN_FIFO2_del(71 downto 48) & x"00" & DIN_FIFO2_del(47 downto 24) & x"00" & DIN_FIFO2_del(23 downto 0) & x"00_00_00_00_00_00" & "00" ;

--			--condition for OOS
--			if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
--				FSM_FIFO1_state <= FSM_FIFO1_write_OOS;
--			else
			
				case FSM_FIFO1_state is
					
					when FSM_FIFO1_idle => 
						counter := 15;
						WR_EN_FIFO1 <= '0';
						FSM_FIFO1_state <= FSM_FIFO1_wait_start;
						FIFO1_BUSY_valid <= '0'; --to signal the OOS_CTRL / PC
						wait_busy := 7;--init
						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(0,8));			
					
					--when FSM_FIFO1_RAZ_FIFO1 => --dummy reading / test empty
					
					when FSM_FIFO1_wait_start =>
						--if (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) and FIFO1_FIFO2_empty_ok_resync_BC_CLK = "11" then --FIFO1_FIFO2_empty_ok_resync_BC_CLK(sram1) = '1'
						if ( (brcststr_sync(1) = '1' and brcst_sync(1) = CMD_START) or CMD_START_BY_PC ='1') and FIFO1_FIFO2_empty_ok_resync_BC_CLK = "11" then									
							FSM_FIFO1_state <= FSM_FIFO1_write1;
						end if;
						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(1,8));
							
					when FSM_FIFO1_write1 =>
						FIFO1_BUSY_valid <= '0';
						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true)  or spurious_flag_resync = '1' then
							FSM_FIFO1_state <= FSM_FIFO1_write_OOS;							
						elsif ACQ_MODE_RESYNC = '0' then
							if cbc_rcv_data_138b_en_del1 = '1' then --cbc_rcv_data_138b_en = '1' then--trigger-controlled
								WR_EN_FIFO1 <= '1';
								FSM_FIFO1_state <= FSM_FIFO1_BUSY;
							else
								WR_EN_FIFO1 <= '0';
							end if;				
						else		--if ACQ_MODE_RESYNC = '1' then--storage in continue
							if FULL_FIFO1_75_percent = '1' then
								FSM_FIFO1_state <= FSM_FIFO1_BUSY2;
								WR_EN_FIFO1 <= cbc_rcv_data_138b_en_del1; --cbc_rcv_data_138b_en; --if simultané raz in busy2!!!!
							elsif cbc_rcv_data_138b_en_del1 = '1' then --cbc_rcv_data_138b_en = '1' then
								WR_EN_FIFO1 <= '1';
							else
								WR_EN_FIFO1 <= '0';							
							end if;
						end if;
												
						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(2,8));
					
					when FSM_FIFO1_write_OOS => 
						if FULL_FIFO1_100_percent = '1' then
							WR_EN_FIFO1 <= '0';
						else
							WR_EN_FIFO1 <= '1'; --write in continue to fill-in FIFO
						end if;						
						
						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(5,8));
					--not need before
					

					when FSM_FIFO1_BUSY2 => 
						FIFO1_BUSY_valid <= '1';

						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
							FSM_FIFO1_state <= FSM_FIFO1_write_OOS;	
						elsif EMPTY_FIFO1_0_percent = '1' and EMPTY_FIFO1_0_percent = '1' then
							FSM_FIFO1_state <= FSM_FIFO1_write1;
							WR_EN_FIFO1 <= cbc_rcv_data_138b_en_del1; --cbc_rcv_data_138b_en;--if simultané raz;
						elsif cbc_rcv_data_138b_en_del1 = '1' then --cbc_rcv_data_138b_en = '1' then
							WR_EN_FIFO1 <= '1';
						else
							WR_EN_FIFO1 <= '0';								
						end if;						

						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(3,8));
					
					when FSM_FIFO1_BUSY => --just for
						WR_EN_FIFO1 <= '0';
						FIFO1_BUSY_valid <= '1'; --to signal the OOS_CTRL / PC						
						--condition for OOS
						if ((cdr_flags_for_sTTS_resync(2) = '1' or cdr_flags_for_sTTS_resync(1) = '1' or cdr_flags_for_sTTS_resync(0) = '0') and TTC_CLK_USED = true) or spurious_flag_resync = '1' then
							FSM_FIFO1_state <= FSM_FIFO1_write_OOS;	
						elsif SRAM1_full_one_cycle = '1' or SRAM2_full_one_cycle = '1' then		
							FIFO1_BUSY_valid <= '0';
							FSM_FIFO1_state <= FSM_FIFO1_write1; --return
							wait_busy := 7;--re-init
						else
							wait_busy := wait_busy - 1;
						end if;	
						FSM_FIFO1_flag <= std_logic_vector(conv_unsigned(4,8));						
				end case;
			--end if;
			end if;
	end process;
	--===============================================================================================--			
	---------------********************************FIFO1_STORAGE************************************----------------





	---------------********************************CTRL_FIFO&SRAM************************************----------------

	--===============================================================================================--			
	process
	--===============================================================================================--			
	begin
		wait until rising_edge(BC_CLK);
			FIFO1_BUSY_valid_del1 <= FIFO1_BUSY_valid;
			FIFO1_BUSY_valid_del2 <= FIFO1_BUSY_valid_del1;
			FIFO1_BUSY_valid_del2_one_cycle <= FIFO1_BUSY_valid and not FIFO1_BUSY_valid_del1;		
			--
			FIFO2_BUSY_valid_del1 <= FIFO2_BUSY_valid;
			FIFO2_BUSY_valid_del2 <= FIFO2_BUSY_valid_del1;
			FIFO2_BUSY_valid_del2_one_cycle <= FIFO2_BUSY_valid and not FIFO2_BUSY_valid_del1;		
	end process;		
	--===============================================================================================--					


	
	EMPTY_FIFO_0_percent <= EMPTY_FIFO1_0_percent & EMPTY_FIFO2_0_percent;
	--===============================================================================================--			
	inst_EMPTY_FIFO1_0_percent_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--			
	generic map (n => 2)
	port map
	(
		wrclk_i							=> BC_CLK,
		rdclk_i							=> SRAM_CLK, 
		wdata_i							=> EMPTY_FIFO_0_percent,
		rdata_o							=> EMPTY_FIFO_0_percent_resync_125M
	); 
	--===============================================================================================--				
	EMPTY_FIFO1_0_percent_resync_125M <= EMPTY_FIFO_0_percent_resync_125M(1);
	EMPTY_FIFO2_0_percent_resync_125M <= EMPTY_FIFO_0_percent_resync_125M(0);


	--===============================================================================================--			
	inst_FIFO1_FIFO2_empty_ok_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--			
	generic map (n => 2) --2
	port map 
	(
		wrclk_i							=> SRAM_CLK,
		rdclk_i							=> BC_CLK, 
		wdata_i							=> FIFO1_FIFO2_empty_ok,
		rdata_o							=> FIFO1_FIFO2_empty_ok_resync_BC_CLK
	); 
	--===============================================================================================--			

	--===============================================================================================--			
	process --RD_EN_FIFO Process
	--===============================================================================================--			
	begin
		wait until rising_edge(SRAM_CLK);
			RD_EN_FIFO1 <=	RD_EN_FIFO1_tmp(sram1) or RD_EN_FIFO1_tmp(sram2);
			RD_EN_FIFO2 <=	RD_EN_FIFO2_tmp(sram1) or RD_EN_FIFO2_tmp(sram2);
	end process;
	--===============================================================================================--	
	
	---------------******************************END CTRL_FIFO&SRAM**********************************----------------




	---------------********************************SRAM1_CTRL************************************----------------

	--===============================================================================================--				
	process --(SRAM_CLK,PC_config_ok)--,cmd_stop_valid)
	--===============================================================================================--			
	variable FSM_FIFO_TO_SRAM1_counter 	: std_logic_vector(user_sram_addr_o(sram1)'range);
	variable wait_counter : integer range 0 to 7:=7;
		begin	

		wait until rising_edge(SRAM_CLK);		

			if PC_config_ok = '0' then--or cmd_start_valid = '0' then --pas de cmd_start_valid
				FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_idle;
				RD_EN_FIFO1_tmp(sram1) <= '1'; --force readout during aclr if clock stable
				RD_EN_FIFO2_tmp(sram1) <= '1'; --force readout during aclr if clock stable
				FIFO1_FIFO2_empty_ok(sram1) <= '0'; --flag to wait acq
				SRAM1_full	<= '0';
				
				--fsm1_CBC_data_packet_counter <= 0; --init 0
				--sram1 
				CBC_user_sram_control(sram1).reset 			<= '1'; --en ----active to '1'
				CBC_user_sram_control(sram1).cs 				<= '0'; --dis	
				CBC_user_sram_control(sram1).writeEnable 	<= '1'; --'1' : wr / '0' : rd
				
				CBC_user_sram_write_cycle(sram1)				<= '1'; --'0' for SRAM2 initially
				
				wait_counter := 7; --init
				
				FSM_FIFO_TO_SRAM1_flag <= std_logic_vector(conv_unsigned(0,8));
				
			else
		
				case FSM_FIFO_TO_SRAM1_state is
					
					when FSM_FIFO_TO_SRAM1_idle => 
						
						RD_EN_FIFO1_tmp(sram1) <= '1'; --force readout during aclr if clock stable
						RD_EN_FIFO2_tmp(sram1) <= '1'; --force readout during aclr if clock stable
						FIFO1_FIFO2_empty_ok(sram1) <= '0'; --flag to wait acq
						SRAM1_full	<= '0';
						DATA_FROM_FIFO1(sram1) <= DOUT_FIFO1; --false readout
						DATA_FROM_FIFO2(sram1) <= DOUT_FIFO2;
						fsm1_CBC_data_packet_counter <= 0; --init 0
						FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_empty_FIFO;
						
						--sram1 
						CBC_user_sram_control(sram1).reset 			<= '1'; --en ----active to '1'
						CBC_user_sram_control(sram1).cs 				<= '0'; --dis	
						CBC_user_sram_control(sram1).writeEnable 	<= '1'; --'1' : wr / '0' : rd
						
						CBC_user_sram_write_cycle(sram1)				<= '1'; --'0' for SRAM2 initially

						--raz
						wait_counter := 7; --init
						SRAM1_full_one_cycle	<= '0';						
						
						FSM_FIFO_TO_SRAM1_flag <= std_logic_vector(conv_unsigned(0,8));					

					when FSM_FIFO_TO_SRAM1_empty_FIFO =>
						--reset fifo
						if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') then
							RD_EN_FIFO1_tmp(sram1) <= '1';
							RD_EN_FIFO2_tmp(sram1) <= '1';
							DATA_FROM_FIFO1(sram1) <= DOUT_FIFO1; --false readout
							DATA_FROM_FIFO2(sram1) <= DOUT_FIFO2;
							FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_empty_FIFO;
						else
							FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_init;
							RD_EN_FIFO1_tmp(sram1) <= '0';
							RD_EN_FIFO2_tmp(sram1) <= '0';
							FIFO1_FIFO2_empty_ok(sram1) <= '1'; --flag to begin acq
							--raz
							DATA_FROM_FIFO1(sram1) <= (others=>'0');
							DATA_FROM_FIFO2(sram1) <= (others=>'0');
						end if;
						
						FSM_FIFO_TO_SRAM1_flag <= std_logic_vector(conv_unsigned(1,8));	

					when FSM_FIFO_TO_SRAM1_init => 
					
						CBC_user_sram_control(sram1).reset 			<= '0'; --dis ----active to '1'
						CBC_user_sram_control(sram1).cs 				<= '1'; --en	
					
						if CBC_user_sram_write_cycle(sram2) = '0' then	--and cmd_start_valid = '1' resync ??
							CBC_user_sram_write_cycle(sram1)		<= '1'; --						
							FSM_FIFO_TO_SRAM1_state					<= FSM_FIFO_TO_SRAM1_test_2FIFO_not_empty;
							FSM_FIFO_TO_SRAM1_counter				:= std_logic_vector(conv_unsigned(unsigned(CBC_DATA_PACKET_NUMBER),21));--FSM_FIFO_TO_SRAM1'left+1));												
						else
							null; --wait						
						end if;
						

						
						FSM_FIFO_TO_SRAM1_flag		<= std_logic_vector(conv_unsigned(2,8));		
					
					
					
					when FSM_FIFO_TO_SRAM1_test_2FIFO_not_empty =>		
						--if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') then
						if ACQ_MODE_RESYNC = '0' then
							if (FIFO1_BUSY_valid_del2 = '1' and FIFO2_BUSY_valid_del2 = '1') and wait_counter = 0 then
								RD_EN_FIFO1_tmp(sram1) <= '1';
								--RD_EN_FIFO2_tmp(sram1) <= '1';							
								FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_latch_data;
								wait_counter := 7; --re-init
							else
								wait_counter := wait_counter - 1;
							end if;
						else
							if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') and wait_counter = 0 then
								RD_EN_FIFO1_tmp(sram1) <= '1';
								--RD_EN_FIFO2_tmp(sram1) <= '1';							
								FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_latch_data;
								wait_counter := 7; --re-init
							else
								wait_counter := wait_counter - 1;
							end if;
						end if;
							
						
						FSM_FIFO_TO_SRAM1_flag		<= std_logic_vector(conv_unsigned(3,8));
						
					when FSM_FIFO_TO_SRAM1_latch_data => --reading of data from fifo1
						RD_EN_FIFO1_tmp(sram1) <= '0'; --raz / one cycle
						if VALID_FIFO1 = '1'  then
							--true data
							DATA_FROM_FIFO1(sram1) <= DOUT_FIFO1;
							--test
							--DATA_FROM_FIFO1(sram1) <= DATA_FROM_FIFO1(sram1) + 1;
							--
							FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_latch_data2;
							RD_EN_FIFO2_tmp(sram1) <= '1';
						end if;
					
						FSM_FIFO_TO_SRAM1_flag	 	<= std_logic_vector(conv_unsigned(4,8));						
						
					when FSM_FIFO_TO_SRAM1_latch_data2 => --reading of data from fifo2
						RD_EN_FIFO2_tmp(sram1) <= '0'; --raz / one cycle
						if VALID_FIFO2 = '1'  then
							DATA_FROM_FIFO2(sram1) <= DOUT_FIFO2;
							--test
							--DATA_FROM_FIFO2(sram1) <= DATA_FROM_FIFO2(sram1) + 1;
							--							
							FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_store_data;
							fsm1_CBC_data_packet_counter <= 0;--raz here
						end if;	
							
						FSM_FIFO_TO_SRAM1_flag	 	<= std_logic_vector(conv_unsigned(5,8));
					
					when FSM_FIFO_TO_SRAM1_store_data => --storage
						if fsm1_CBC_data_packet_counter = 11 then --9 :10words / test when 11
							FSM_FIFO_TO_SRAM1_state <= FSM_FIFO_TO_SRAM1_test_packet_sent;
							fsm1_CBC_data_packet_counter <= fsm1_CBC_data_packet_counter + 1; --until 12
							SRAM1_full_one_cycle	<= '1';
						else
							fsm1_CBC_data_packet_counter <= fsm1_CBC_data_packet_counter + 1;
						end if;
						
						FSM_FIFO_TO_SRAM1_flag	 	<= std_logic_vector(conv_unsigned(6,8));

					when FSM_FIFO_TO_SRAM1_test_packet_sent => 
						if FSM_FIFO_TO_SRAM1_counter = 0 then
--							user_sram_control(sram1).reset 		<= '1'; --en ----active to '1'
--							user_sram_control(sram1).cs 			<= '0'; --dis	
--							user_sram_addr(sram1) 					<= (others=>'0');	
							FSM_FIFO_TO_SRAM1_state					<= FSM_FIFO_TO_SRAM1_flag_full; 	
						else
							FSM_FIFO_TO_SRAM1_state					<= FSM_FIFO_TO_SRAM1_test_2FIFO_not_empty; --loop
							FSM_FIFO_TO_SRAM1_counter				:= FSM_FIFO_TO_SRAM1_counter - 1;
						end if;
						--fsm1_CBC_data_packet_counter 				<= 0; --raz
						
						SRAM1_full_one_cycle	<= '0';
						
						FSM_FIFO_TO_SRAM1_flag						<= std_logic_vector(conv_unsigned(7,8));			


					when FSM_FIFO_TO_SRAM1_flag_full => --flag full					
						if SRAM1_end_readout = '0' then --secure
							SRAM1_full				 					<= '1';	
							FSM_FIFO_TO_SRAM1_state					<= FSM_FIFO_TO_SRAM1_test_end_readout;
						end if;
						CBC_user_sram_write_cycle(sram1)			<= '0'; --raz / '1' if only sram1
						--sram1 
						CBC_user_sram_control(sram1).reset 			<= '1'; --en ----active to '1'
						CBC_user_sram_control(sram1).cs 				<= '0'; --dis
						FSM_FIFO_TO_SRAM1_flag						<= std_logic_vector(conv_unsigned(8,8));	

					when FSM_FIFO_TO_SRAM1_test_end_readout => --raz if read
						--if OOS_state_valid = '1' then
							
						if SRAM1_end_readout = '1' then 
							SRAM1_full				 					<= '0';
							FSM_FIFO_TO_SRAM1_state					<= FSM_FIFO_TO_SRAM1_init;
						end if;	
						FSM_FIFO_TO_SRAM1_flag						<= std_logic_vector(conv_unsigned(9,8));		
			
				end case;
			end if;
	end process;
	
	--===============================================================================================--		
	process --ctrl of sram_addr(sram1) + sram_wdata(sram1)
	--===============================================================================================--		
	begin
		wait until rising_edge(SRAM_CLK);
			if  PC_config_ok = '0' or cmd_start_valid = '0' then
				CBC_user_sram_addr_tmp1(sram1) <= (others=>'0');
				CBC_user_sram_wdata_tmp1(sram1) <= (others=>'0');				
			elsif SRAM1_full = '1' then
				CBC_user_sram_addr_tmp1(sram1) <= (others=>'0'); --packet end / raz @ not data
			else		
--					--counter test ok
--					case fsm1_CBC_data_packet_counter is 
--						when 0 => 	null;--CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;
--										--CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --0 to 1
--						when 1 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --1 to 2
--						when 2 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --2 to 3
--						when 3 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --3 to 4
--						when 4 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --4 to 5	
--						when 5 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --5 to 6
--						when 6 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --6 to 7							
--						when 7 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --7 to 8
--						when 8 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --8 to 9
--						when 9 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;	
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --9 to 10
--						when 10 => 	CBC_user_sram_wdata_tmp1(sram1)		<= CBC_user_sram_wdata_tmp1(sram1)+1;
--										CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --9 to 10						
--						when others => null;
--					end case;

				--true data 170b fifo1
				case fsm1_CBC_data_packet_counter is 
					--fifo2 : time&trigger
					when 0 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram1)(95 downto 72); 	--BC
									--addr no
					when 1 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram1)(71 downto 48);	--ORB 	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --0 to 1
					when 2 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram1)(47 downto 24);	--LS	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --1 to 2
					when 3 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram1)(23 downto 0);		--L1A	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --2 to 3
					--fifo1 : cbc_data
					when 4 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00" & DATA_FROM_FIFO1(sram1)(169 downto 146);	--CBC_DATA_COUNTER
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --3 to 4	
					when 5 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & DATA_FROM_FIFO1(sram1)(145 downto 114);	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --4 to 5
					when 6 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & DATA_FROM_FIFO1(sram1)(113 downto 82);	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --5 to 6							
					when 7 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & DATA_FROM_FIFO1(sram1)(81 downto 50);	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --6 to 7
					when 8 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & DATA_FROM_FIFO1(sram1)(49 downto 18);	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --7 to 8
					when 9 => 	CBC_user_sram_wdata_tmp1(sram1)		<= x"0" & x"00_0" & "00" & DATA_FROM_FIFO1(sram1)(7 downto 0) & DATA_FROM_FIFO1(sram1)(17 downto 8);	
									CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --8 to 9	
					when 10 => 	CBC_user_sram_addr_tmp1(sram1)   	<= CBC_user_sram_addr_tmp1(sram1) + 1; --9 to 10											
					when others => null;
				end case;

			end if;
	end process;
	--===============================================================================================--		
	
	---------------******************************END SRAM1_CTRL**********************************----------------


	

			

		

	---------------********************************SRAM2_CTRL************************************----------------
	--===============================================================================================--		
	process --(SRAM_CLK,PC_config_ok)--,cmd_stop_valid)
	--===============================================================================================--		
	variable FSM_FIFO_TO_SRAM2_counter 	: std_logic_vector(user_sram_addr_o(sram2)'range);
	variable wait_counter : integer range 0 to 7 := 7;
		begin	

		wait until rising_edge(SRAM_CLK);		

			if PC_config_ok = '0' then --or cmd_start_valid = '0' then
				FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_idle;
				RD_EN_FIFO1_tmp(sram2) <= '1'; --force readout during aclr if clock stable
				RD_EN_FIFO2_tmp(sram2) <= '1'; --force readout during aclr if clock stable
				FIFO1_FIFO2_empty_ok(sram2) <= '0'; --flag to wait acq
				SRAM2_full	<= '0';
				
				--fsm2_CBC_data_packet_counter <= 0; --init 0
				--sram1 
				CBC_user_sram_control(sram2).reset 			<= '1'; --en ----active to '1'
				CBC_user_sram_control(sram2).cs 				<= '0'; --dis	
				CBC_user_sram_control(sram2).writeEnable 	<= '1'; --'1' : wr / '0' : rd
				
				CBC_user_sram_write_cycle(sram2)				<= '0'; --'0' for SRAM2 initially
				
				wait_counter := 7; --init
				
				FSM_FIFO_TO_SRAM2_flag <= std_logic_vector(conv_unsigned(0,8));
				
			else

				case FSM_FIFO_TO_SRAM2_state is
					
					when FSM_FIFO_TO_SRAM2_idle => 
						RD_EN_FIFO1_tmp(sram2) <= '1'; --force readout during aclr if clock stable
						RD_EN_FIFO2_tmp(sram2) <= '1'; --force readout during aclr if clock stable
						FIFO1_FIFO2_empty_ok(sram2) <= '0'; --flag to wait acq
						SRAM2_full	<= '0';
						DATA_FROM_FIFO1(sram2) <= DOUT_FIFO1; --false readout
						DATA_FROM_FIFO2(sram2) <= DOUT_FIFO2;
						fsm2_CBC_data_packet_counter <= 0; --init 0
						FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_empty_FIFO;
						
						--sram1 
						CBC_user_sram_control(sram2).reset 			<= '1'; --en ----active to '1'
						CBC_user_sram_control(sram2).cs 				<= '0'; --dis	
						CBC_user_sram_control(sram2).writeEnable 	<= '1'; --'1' : wr / '0' : rd
						
						CBC_user_sram_write_cycle(sram2)				<= '0'; --'0' for SRAM2 initially

						--raz
						wait_counter := 7; --init	
						SRAM2_full_one_cycle	<= '0';						
						
						FSM_FIFO_TO_SRAM2_flag <= std_logic_vector(conv_unsigned(0,8));					

					when FSM_FIFO_TO_SRAM2_empty_FIFO =>
						
						--FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_init;
						
						--reset fifo
						if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') then
							RD_EN_FIFO1_tmp(sram2) <= '1';
							RD_EN_FIFO2_tmp(sram2) <= '1';
							DATA_FROM_FIFO1(sram2) <= DOUT_FIFO1; --false readout
							DATA_FROM_FIFO2(sram2) <= DOUT_FIFO2;
							FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_empty_FIFO;
						else
							FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_init;
							RD_EN_FIFO1_tmp(sram2) <= '0';
							RD_EN_FIFO2_tmp(sram2) <= '0';
							--raz
							DATA_FROM_FIFO1(sram2) <= (others=>'0');
							DATA_FROM_FIFO2(sram2) <= (others=>'0');							
							FIFO1_FIFO2_empty_ok(sram2) <= '1'; --flag to begin acq
						end if;						
						
						FSM_FIFO_TO_SRAM2_flag <= std_logic_vector(conv_unsigned(1,8));	

					when FSM_FIFO_TO_SRAM2_init => 
					
						CBC_user_sram_control(sram2).reset 			<= '0'; --dis ----active to '1'
						CBC_user_sram_control(sram2).cs 				<= '1'; --en	
						
						if CBC_user_sram_write_cycle(sram1) = '0' then	
							CBC_user_sram_write_cycle(sram2)		<= '1'; --						
							FSM_FIFO_TO_SRAM2_state					<= FSM_FIFO_TO_SRAM2_test_2FIFO_not_empty;
							FSM_FIFO_TO_SRAM2_counter				:= std_logic_vector(conv_unsigned(unsigned(CBC_DATA_PACKET_NUMBER),21));--FSM_FIFO_TO_SRAM2'left+1));												
						else
							null; --wait						
						end if;
				
						FSM_FIFO_TO_SRAM2_flag		<= std_logic_vector(conv_unsigned(2,8));		
					
					
					
					when FSM_FIFO_TO_SRAM2_test_2FIFO_not_empty =>		
						--if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') then
						
						if ACQ_MODE_RESYNC = '0' then
							if (FIFO1_BUSY_valid_del2 = '1' and FIFO2_BUSY_valid_del2 = '1') and wait_counter = 0 then
								RD_EN_FIFO1_tmp(sram2) <= '1';
								--RD_EN_FIFO2_tmp(sram2) <= '1';							
								FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_latch_data;
								wait_counter := 7; --re-init
							else
								wait_counter := wait_counter - 1;
							end if;
						else
							if (EMPTY_FIFO1_0_percent_resync_125M = '0' and EMPTY_FIFO2_0_percent_resync_125M = '0') and wait_counter = 0 then
								RD_EN_FIFO1_tmp(sram2) <= '1';
								--RD_EN_FIFO2_tmp(sram1) <= '1';							
								FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_latch_data;
								wait_counter := 7; --re-init
							else
								wait_counter := wait_counter - 1;
							end if;
						end if;													
					FSM_FIFO_TO_SRAM2_flag		<= std_logic_vector(conv_unsigned(3,8));
										
					when FSM_FIFO_TO_SRAM2_latch_data =>  --reading of data from fifo1
						RD_EN_FIFO1_tmp(sram2) <= '0'; --raz / one cycle
						if VALID_FIFO1 = '1'  then
							--true data
							DATA_FROM_FIFO1(sram2) <= DOUT_FIFO1;
							--test
							--DATA_FROM_FIFO1(sram2) <= DATA_FROM_FIFO1(sram2) + 1;
							--
							FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_latch_data2;
							RD_EN_FIFO2_tmp(sram2) <= '1';
						end if;
					
						FSM_FIFO_TO_SRAM2_flag	 	<= std_logic_vector(conv_unsigned(4,8));

					when FSM_FIFO_TO_SRAM2_latch_data2 =>  --reading of data from fifo2					
						RD_EN_FIFO2_tmp(sram2) <= '0'; --raz / one cycle
						if VALID_FIFO2 = '1'  then
							--true data
							DATA_FROM_FIFO2(sram2) <= DOUT_FIFO2;
							--test
							--DATA_FROM_FIFO2(sram2) <= DATA_FROM_FIFO2(sram2) + 1;
							--
							FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_store_data;
							fsm2_CBC_data_packet_counter <= 0;--raz here
						end if;					
					
					FSM_FIFO_TO_SRAM2_flag		<= std_logic_vector(conv_unsigned(5,8));
					
					when FSM_FIFO_TO_SRAM2_store_data => --storage
						if fsm2_CBC_data_packet_counter = 11 then --9 :10words / test 11
							FSM_FIFO_TO_SRAM2_state <= FSM_FIFO_TO_SRAM2_test_packet_sent;
							fsm2_CBC_data_packet_counter <= fsm2_CBC_data_packet_counter + 1; 
							SRAM2_full_one_cycle <= '1';
						else
							fsm2_CBC_data_packet_counter <= fsm2_CBC_data_packet_counter + 1;
						end if;						
						
						FSM_FIFO_TO_SRAM2_flag	 	<= std_logic_vector(conv_unsigned(6,8));

					when FSM_FIFO_TO_SRAM2_test_packet_sent => 
						if FSM_FIFO_TO_SRAM2_counter = 0 then
--							user_sram_control(sram2).reset 		<= '1'; --en ----active to '1'
--							user_sram_control(sram2).cs 			<= '0'; --dis	
--							user_sram_addr(sram2) 					<= (others=>'0');	
							FSM_FIFO_TO_SRAM2_state					<= FSM_FIFO_TO_SRAM2_flag_full; 	
						else
							FSM_FIFO_TO_SRAM2_state					<= FSM_FIFO_TO_SRAM2_test_2FIFO_not_empty; --loop
							FSM_FIFO_TO_SRAM2_counter				:= FSM_FIFO_TO_SRAM2_counter - 1;
						end if;
						--fsm2_CBC_data_packet_counter 				<= 0; --raz
						
						SRAM2_full_one_cycle				 			<= '0';
						
						FSM_FIFO_TO_SRAM2_flag						<= std_logic_vector(conv_unsigned(7,8));			


					when FSM_FIFO_TO_SRAM2_flag_full => --flag full					
						if SRAM2_end_readout = '0' then --secure
							SRAM2_full				 					<= '1';
							FSM_FIFO_TO_SRAM2_state					<= FSM_FIFO_TO_SRAM2_test_end_readout;
						end if;
						CBC_user_sram_write_cycle(sram2)			<= '0'; --raz
						--sram2 
						CBC_user_sram_control(sram2).reset 			<= '1'; --en ----active to '1'
						CBC_user_sram_control(sram2).cs 				<= '0'; --dis
						FSM_FIFO_TO_SRAM2_flag						<= std_logic_vector(conv_unsigned(8,8));	

					when FSM_FIFO_TO_SRAM2_test_end_readout => --raz if read
						if SRAM2_end_readout = '1' then 
							SRAM2_full				 					<= '0';
							FSM_FIFO_TO_SRAM2_state					<= FSM_FIFO_TO_SRAM2_init;
						end if;						
						FSM_FIFO_TO_SRAM2_flag						<= std_logic_vector(conv_unsigned(9,8));		
			
				end case;
			end if;
	end process;
	--===============================================================================================--			

	--===============================================================================================--		
	process --ctrl of sram_addr(sram2) + sram_wdata(sram2)
	--===============================================================================================--		
	begin
		wait until rising_edge(SRAM_CLK);
			if  PC_config_ok = '0' or cmd_start_valid = '0' then
				CBC_user_sram_addr_tmp1(sram2) <= (others=>'0'); --raz @
				CBC_user_sram_wdata_tmp1(sram2) <= (others=>'0');--raz data				
			elsif SRAM2_full = '1' then
				CBC_user_sram_addr_tmp1(sram2) <= (others=>'0');--packet end / raz @ not data
			else		
--					--counter test ok
--					case fsm2_CBC_data_packet_counter is 
--						when 0 => 	null;--CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;
--										--CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --0 to 1
--						when 1 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --1 to 2
--						when 2 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --2 to 3
--						when 3 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --3 to 4
--						when 4 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --4 to 5	
--						when 5 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --5 to 6
--						when 6 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --6 to 7							
--						when 7 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --7 to 8
--						when 8 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --8 to 9
--						when 9 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;	
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --9 to 10
--						when 10 => 	CBC_user_sram_wdata_tmp1(sram2)		<= CBC_user_sram_wdata_tmp1(sram2)+1;
--										CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --9 to 10										
--						when others => null;
--					end case;

				--true data 170b fifo1
				case fsm2_CBC_data_packet_counter is 
					--fifo2 : time&trigger
					when 0 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram2)(95 downto 72); 	--BC
									--addr no
					when 1 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram2)(71 downto 48);	--ORB 	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --0 to 1
					when 2 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram2)(47 downto 24);	--LS	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --1 to 2
					when 3 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00" & DATA_FROM_FIFO2(sram2)(23 downto 0);		--L1A	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --2 to 3
					--fifo1 : cbc_data
					when 4 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00" & DATA_FROM_FIFO1(sram2)(169 downto 146);	--CBC_DATA_COUNTER
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --3 to 4	
					when 5 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & DATA_FROM_FIFO1(sram2)(145 downto 114);	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --4 to 5
					when 6 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & DATA_FROM_FIFO1(sram2)(113 downto 82);	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --5 to 6							
					when 7 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & DATA_FROM_FIFO1(sram2)(81 downto 50);	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --6 to 7
					when 8 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & DATA_FROM_FIFO1(sram2)(49 downto 18);	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --7 to 8
					when 9 => 	CBC_user_sram_wdata_tmp1(sram2)		<= x"0" & x"00_0" & "00" & DATA_FROM_FIFO1(sram2)(7 downto 0) & DATA_FROM_FIFO1(sram2)(17 downto 8);	
									CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --8 to 9	
					when 10 => 	CBC_user_sram_addr_tmp1(sram2)   	<= CBC_user_sram_addr_tmp1(sram2) + 1; --9 to 10											
					when others => null;
				end case;

			end if;
	end process;		
	--===============================================================================================--
	---------------******************************END SRAM2_CTRL**********************************----------------





	---------------********************************SRAM_INTERFACE************************************----------------
	--clk
	user_sram_control_o(sram1).clk  			<= SRAM_CLK;
	user_sram_control_o(sram2).clk  			<= SRAM_CLK;	
	--===============================================================================================--
	process
	--===============================================================================================--
	begin
		wait until rising_edge(SRAM_CLK); 	
			--wdata for sram1
			user_sram_wdata_o  (sram1) 				<= CBC_user_sram_wdata_tmp1(sram1);
			--wdata for sram2
			user_sram_wdata_o  (sram2)					<= CBC_user_sram_wdata_tmp1(sram2);	
			--@ & ctrl for sram1
			user_sram_addr_o   (sram1) 				<= CBC_user_sram_addr_tmp1(sram1);
			user_sram_control_o(sram1).reset 		<= CBC_user_sram_control(sram1).reset;
			user_sram_control_o(sram1).cs 			<= CBC_user_sram_control(sram1).cs;
			user_sram_control_o(sram1).writeEnable <= CBC_user_sram_control(sram1).writeEnable;		
			--@ & ctrl for sram2
			user_sram_addr_o   (sram2) 				<= CBC_user_sram_addr_tmp1(sram2);
			user_sram_control_o(sram2).reset 		<= CBC_user_sram_control(sram2).reset;
			user_sram_control_o(sram2).cs 			<= CBC_user_sram_control(sram2).cs;
			user_sram_control_o(sram2).writeEnable <= CBC_user_sram_control(sram2).writeEnable;		
	end process;	
	--===============================================================================================--	
	---------------******************************END SRAM_INTERFACE**********************************----------------
	






	---------------********************************FLAGS_RESYNC************************************----------------

	--===============================================================================================--
	process --cdr flags 
	--===============================================================================================--	
	variable cdr_flags_for_sTTS_tmp : std_logic_vector(2 downto 0):=(others=>'0');
	begin
		wait until rising_edge(SRAM_CLK);
			cdr_flags_for_sTTS_tmp := cdr_lol & cdr_los & cdr_clk_locked; --they are completely async
			cdr_flags_for_sTTS_resync <= cdr_flags_for_sTTS_tmp;
	end process;
	--===============================================================================================--	


	
	FIFO_flags_for_sTTS <= FIFO2_BUSY_valid & FIFO1_BUSY_valid;
	--===============================================================================================--	
	inst_FIFO_flags_for_sTTS_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--	
	generic map (n => 2) --2
	port map 
	(
		wrclk_i							=> BC_CLK,
		rdclk_i							=> SRAM_CLK, 
		wdata_i							=> FIFO_flags_for_sTTS,
		rdata_o							=> FIFO_flags_for_sTTS_resync
	); 	
	--===============================================================================================--	


	--SPURIOUS FLAG stored in Register
	spurious_flag_vect(0) <= spurious_flag; 
	--===============================================================================================--
	inst_spurious_flags_for_sTTS_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 1) --2
	port map 
	(
		wrclk_i							=> BC_CLK,
		rdclk_i							=> SRAM_CLK, 
		wdata_i							=> spurious_flag_vect,
		rdata_o							=> spurious_flag_vect_resync
	);
	--===============================================================================================--	
	spurious_flag_resync <= spurious_flag_vect_resync(0);


	sTTS_CTRL_all_failures <= spurious_flag_resync & cdr_flags_for_sTTS_resync & FIFO_flags_for_sTTS_resync(1) & FIFO_flags_for_sTTS_resync(0);--SPURIOUS_FRAME spurious_flag_resync; --FIFO_flags_for_sTTS_resync


	--===============================================================================================--
	--FLAGS to store into registers mapping
	--===============================================================================================--
	flags_vhdl_to_pc_32b <= "000000" & FSM_FIFO2_flag(3 downto 0) & FSM_FIFO1_flag(3 downto 0) & FSM_FIFO_TO_SRAM2_flag & SRAM2_full & FSM_FIFO_TO_SRAM1_flag & SRAM1_full;
	--===============================================================================================--
	inst_flags_to_pc_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 32) 
	port map 
	(
		wrclk_i							=> SRAM_CLK,
		rdclk_i							=> wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk, 
		wdata_i							=> flags_vhdl_to_pc_32b,
		rdata_o							=> flags_vhdl_to_pc_resync_32b 
	); 
	--===============================================================================================--


	--===============================================================================================--
	--FLAGS to store into registers mapping
	--===============================================================================================--
	sTTS_flags_vhdl_to_pc_14b <= sTTS_CTRL_all_failures(5) & FSM_sTTS_CTRL_flag(3 downto 0) & sTTS_CTRL_all_failures(4 downto 0) & sTTS_code; 
	--===============================================================================================--
	inst_sTTS_flags_vhdl_to_pc_14b_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 14) 
	port map 
	(
		wrclk_i							=> SRAM_CLK,
		rdclk_i							=> wb_mosi_i(user_wb_ttc_fmc_regs).wb_clk, 
		wdata_i							=> sTTS_flags_vhdl_to_pc_14b,
		rdata_o							=> sTTS_flags_vhdl_to_pc_14b_resync
	); 
	--===============================================================================================--



	--===============================================================================================--
	--FLAGS stored in the data flow (readout memory)
	--===============================================================================================--
	--===============================================================================================--	
	process
	--===============================================================================================--
	begin
		wait until rising_edge(SRAM_CLK);
			sTTS_code_to_store 			<= sTTS_code;
			spurious_flag_to_store 		<= spurious_flag_resync;
			cdr_lol_to_store 				<= cdr_flags_for_sTTS_resync(2);
			cdr_los_to_store 				<= cdr_flags_for_sTTS_resync(1);
			cdr_clk_locked_to_store 	<= cdr_flags_for_sTTS_resync(0);
	end process;
	--===============================================================================================--			
	oos_flags_to_store <= cdr_lol_to_store & cdr_los_to_store & cdr_clk_locked_to_store & spurious_flag_to_store & sTTS_code_to_store;
	--===============================================================================================--
	inst_oos_flags_to_store_resync: entity work.clk_domain_bridge --between 1 to 127-bits
	--===============================================================================================--
	generic map (n => 8) --
	port map 
	(
		wrclk_i							=> SRAM_CLK,
		rdclk_i							=> BC_CLK, 
		wdata_i							=> oos_flags_to_store,
		rdata_o							=> oos_flags_to_store_resync_BC_CLKC
	);
	--===============================================================================================--

	---------------******************************END FLAGS_RESYNC**********************************----------------
	
	













 

end user_logic_arch;