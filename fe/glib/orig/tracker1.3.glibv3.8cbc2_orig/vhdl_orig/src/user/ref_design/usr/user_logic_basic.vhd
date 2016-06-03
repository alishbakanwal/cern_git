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
use work.user_version_package.all;

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
	user_cdce_sync_done_i					: in	  std_logic;
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
	user_clk125_i                  		: in	  std_logic;       
   user_clk200_i                  		: in	  std_logic;       
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


signal ctrl_reg		               : array_32x32bit;
signal stat_reg		               : array_32x32bit;

signal led1									: std_logic;
signal led2									: std_logic;

signal test_word							: std_logic_vector(31 downto 0);


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
   
   ip_addr_o				               <= x"c0a800a"     & amc_slot_i;  -- 192.168.0.[160:175]
   mac_addr_o 				               <= x"080030F100a" & amc_slot_i;  -- 08:00:30:F1:00:0[A0:AF] 
  
  
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@ PLACE YOUR LOGIC BELOW THIS COMMENT @@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--

	
	--===========================================--
	stat_regs_inst: entity work.ipb_user_status_regs
	--===========================================--
	port map
	(
		clk					=> ipb_clk_i,
		reset					=> reset_i,
		ipb_mosi_i			=> ipb_mosi_i(user_ipb_stat_regs),
		ipb_miso_o			=> ipb_miso_o(user_ipb_stat_regs),
		regs_i				=> stat_reg
	);
	--===========================================--


	--===========================================--
	ctrl_regs_inst: entity work.ipb_user_control_regs
	--===========================================--
	port map
	(
		clk					=> ipb_clk_i,
		reset					=> reset_i,
		ipb_mosi_i			=> ipb_mosi_i(user_ipb_ctrl_regs),
		ipb_miso_o			=> ipb_miso_o(user_ipb_ctrl_regs),
		regs_o				=> ctrl_reg
	);
	--===========================================--
		


   --===========================================--
	-- register mapping
	--===========================================--
	led1 			<= ctrl_reg(0)(0);
	led2 			<= ctrl_reg(0)(4);
	test_word 	<= ctrl_reg(1);
	--
	stat_reg(0)	<= x"67_6f_6c_64"; -- 'g' 'o' 'l' 'd'
	stat_reg(1) <= test_word;
	stat_reg(2)	<= std_logic_vector(to_unsigned(usr_ver_major,4)) &
						std_logic_vector(to_unsigned(usr_ver_minor,4)) &
						std_logic_vector(to_unsigned(usr_ver_build,8)) &
						std_logic_vector(to_unsigned(usr_ver_year ,7)) &
						std_logic_vector(to_unsigned(usr_ver_month,4)) &
						std_logic_vector(to_unsigned(usr_ver_day  ,5)) ;
	--===========================================--

	
	
	--===========================================--
	-- I/O mapping
	--===========================================--
	user_v6_led_o(1) <= led1;
   user_v6_led_o(2) <= led2;
	--===========================================--
	

end user_logic_arch;