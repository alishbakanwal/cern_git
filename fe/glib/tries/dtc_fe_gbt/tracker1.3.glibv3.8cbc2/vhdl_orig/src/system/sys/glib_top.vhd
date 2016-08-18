library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! Specific packages:
library unisim;
use unisim.vcomponents.all;
--! System packages:
use work.ipbus.all;
use work.system_package.all;
use work.wb_package.all;
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
--! User packages:
use work.user_package.all;

entity glib_top is
port
(
   --================================--
	-- MGT CLOCKS 
	--================================--  
   -- BANK_112(Q0):  
   clk125_1_p	                        : in	  std_logic;
   clk125_1_n	                        : in	  std_logic;
   cdce_out0_p	                        : in	  std_logic;
   cdce_out0_n 	                     : in	  std_logic;
   -- BANK_113(Q1):                 
   fmc2_clk0_m2c_xpoint2_p	            : in	  std_logic;
   fmc2_clk0_m2c_xpoint2_n	            : in	  std_logic;
   cdce_out1_p	                        : in	  std_logic;
   cdce_out1_n 	                     : in	  std_logic;
   -- BANK_114(Q2):                 
   pcie_clk_p	                        : in	  std_logic;
   pcie_clk_n	                        : in	  std_logic;
   cdce_out2_p  	                     : in	  std_logic;
   cdce_out2_n  	                     : in	  std_logic;
   -- BANK_115(Q3):                 
   clk125_2_p					            : in	  std_logic;
   clk125_2_n					            : in	  std_logic;
   fmc1_gbtclk1_m2c_p	               : in	  std_logic;
   fmc1_gbtclk1_m2c_n	               : in	  std_logic;
   -- BANK_116(Q4):                 
   fmc1_gbtclk0_m2c_p	               : in	  std_logic;  
   fmc1_gbtclk0_m2c_n	               : in	  std_logic;  
   cdce_out3_p	                        : in	  std_logic;
   cdce_out3_n	                        : in	  std_logic;  
   --================================--   
	-- FABRIC CLOCKS  
	--================================--      
   xpoint1_clk1_p				            : in	  std_logic;
	xpoint1_clk1_n				            : in	  std_logic;	
	xpoint1_clk3_p				            : in	  std_logic;
	xpoint1_clk3_n				            : in	  std_logic;
	------------------------------------   
   cdce_out4_p					            : in	  std_logic;
	cdce_out4_n					            : in	  std_logic;	
   ------------------------------------   
	amc_tclkb					            : out	  std_logic;
	------------------------------------   
   fmc1_clk0_m2c_xpoint2_p	            : in	  std_logic;
	fmc1_clk0_m2c_xpoint2_n	            : in	  std_logic;	
	fmc1_clk1_m2c_p			            : in	  std_logic;
	fmc1_clk1_m2c_n			            : in	  std_logic;	
	fmc1_clk2_bidir_p			            : in	  std_logic;
	fmc1_clk2_bidir_n			            : in	  std_logic;
	fmc1_clk3_bidir_p			            : in	  std_logic;
	fmc1_clk3_bidir_n			            : in	  std_logic;	
   ------------------------------------   
	fmc2_clk1_m2c_p			            : in	  std_logic;
	fmc2_clk1_m2c_n			            : in	  std_logic;
	--================================--   
	-- GBE PHY  
	--================================--   
	gbe_tx_p						            : out	  std_logic;
	gbe_tx_n						            : out	  std_logic;
	gbe_rx_p						            : in	  std_logic;
	gbe_rx_n						            : in	  std_logic;
	gbe_reset_n					            : out	  std_logic;	
	gbe_int_n					            : in	  std_logic;	
	gbe_scl_mdc					            : inout std_logic;
	gbe_sda_mdio				            : inout std_logic;
   --================================--
	-- FMC2 RESERVED MGT 
	--================================--
	fmc2_tx_p					            : out	  std_logic;
	fmc2_tx_n					            : out	  std_logic;
	fmc2_rx_p					            : in	  std_logic;
	fmc2_rx_n					            : in	  std_logic;   
	--================================--
	-- AMC PORTS
	--================================--
	amc_port_tx_p				            : out	  std_logic_vector(0 to 15);
	amc_port_tx_n				            : out	  std_logic_vector(0 to 15);
	amc_port_rx_p				            : in	  std_logic_vector(0 to 15);
	amc_port_rx_n				            : in	  std_logic_vector(0 to 15);
	------------------------------------
	amc_port_tx_out			            : out	  std_logic_vector(17 to 20);	
	amc_port_tx_in				            : in	  std_logic_vector(17 to 20);		
	amc_port_tx_de				            : out	  std_logic_vector(17 to 20);	
	amc_port_rx_out			            : out	  std_logic_vector(17 to 20);	
	amc_port_rx_in				            : in	  std_logic_vector(17 to 20);	
	amc_port_rx_de				            : out	  std_logic_vector(17 to 20);	
	--================================--
	-- CLK CIRCUITRY
	--================================--
	xpoint1_s40	   		               : out	  std_logic;
	xpoint1_s41	   	                  : out	  std_logic;
	xpoint1_s30	   	                  : out	  std_logic;
	xpoint1_s31	   	                  : out	  std_logic;
	xpoint1_s20	   	                  : out	  std_logic;
	xpoint1_s21	   	                  : out	  std_logic;
	xpoint1_s10	   	                  : out	  std_logic;
	xpoint1_s11	   	                  : out	  std_logic;
	-------           
	xpoint2_s10	 			               : out	  std_logic;
	xpoint2_s11	 			               : out	  std_logic;
	------------------------------------  
	ics874003_fsel	 		               : out	  std_logic;
	ics874003_mr	 			            : out	  std_logic;
	ics874003_oe	 			            : out	  std_logic;
	------------------------------------  
	tclkb_dr_en				               : out	  std_logic;
	------------------------------------  
	cdce_pwr_down				            : out	  std_logic;	
	cdce_ref_sel				            : out	  std_logic;	
	cdce_sync					            : out	  std_logic;	
	cdce_spi_clk				            : out	  std_logic;	
	cdce_spi_le					            : out	  std_logic;	
	cdce_spi_mosi				            : out	  std_logic;	
	cdce_pll_lock				            : in	  std_logic;	
	cdce_spi_miso				            : in	  std_logic;	
   --------------          
   cdce_sec_ref_p				            : out	  std_logic;
   cdce_sec_ref_n				            : out	  std_logic;   
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
	-- FMC MGT, IO & CTRL
	--================================--
	fmc1_tx_p					            : out	  std_logic_vector(1 to 4);
	fmc1_tx_n                           : out	  std_logic_vector(1 to 4);
	fmc1_rx_p                           : in	  std_logic_vector(1 to 4);
	fmc1_rx_n                           : in	  std_logic_vector(1 to 4);
	------------------------------------
	fmc1_la_p					            : inout std_logic_vector(0 to 33);
	fmc1_la_n					            : inout std_logic_vector(0 to 33);
	fmc1_ha_p					            : inout std_logic_vector(0 to 23);
	fmc1_ha_n					            : inout std_logic_vector(0 to 23);
	fmc1_hb_p					            : inout std_logic_vector(0 to 21);
	fmc1_hb_n					            : inout std_logic_vector(0 to 21);
	fmc1_clk_c2m_p				            : out	  std_logic_vector(0 to 1);
	fmc1_clk_c2m_n				            : out	  std_logic_vector(0 to 1);
	fmc1_present_l				            : in	  std_logic;
	------------------------------------
	fmc2_la_p	   			            : inout std_logic_vector(0 to 33);
	fmc2_la_n	  				            : inout std_logic_vector(0 to 33);
	fmc2_ha_p					            : inout std_logic_vector(0 to 23);
	fmc2_ha_n					            : inout std_logic_vector(0 to 23);
	fmc2_hb_p					            : inout std_logic_vector(0 to 21);
	fmc2_hb_n					            : inout std_logic_vector(0 to 21);
	------------------------------------
	fmc2_clk_c2m_p				            : out	  std_logic_vector(0 to 1);
	fmc2_clk_c2m_n				            : out	  std_logic_vector(0 to 1);
	fmc2_present_l				            : in	  std_logic;
	--================================--
	-- MEMORIES (FLASH & SRAMs)
	--================================--
	sram1_addr					            : out	  std_logic_vector(20 downto 0);
	sram1_data					            : inout std_logic_vector(35 downto 0);
	------------------------------------
	sram1_adv_ld_l				            : out	  std_logic;	
	sram1_ce1_l					            : out	  std_logic;				
	sram1_cen_l					            : out	  std_logic;		
	sram1_clk					            : out	  std_logic;
	sram1_mode					            : out	  std_logic;
	sram1_oe_l	   			            : out	  std_logic;
	sram1_we_l					            : out	  std_logic;
	------------------------------------   
   sram1_bwa                           : out	  std_logic;
   sram1_bwb                           : out	  std_logic;
   sram1_bwc                           : out	  std_logic;
   sram1_bwd                           : out	  std_logic;   
   ------------------------------------
	sram2_addr					            : out	  std_logic_vector(20 downto 0);	
	sram2_data					            : inout std_logic_vector(35 downto 0);	
   ------------------------------------
	fpga_a22 			                  : out	  std_logic;	
   fpga_a21			                     : out	  std_logic;	
   fpga_rs0	 		  			            : out	  std_logic;				
	fpga_rs1  					            : out	  std_logic;	
	------------------------------------
	sram2_adv_ld_l				            : out	  std_logic;	
	sram2_ce1_l					            : out	  std_logic;				
	sram2_cen_l					            : out	  std_logic;		
	sram2_clk					            : out	  std_logic;
	sram2_mode					            : out	  std_logic;
	sram2_oe_l	   			            : out	  std_logic;
	sram2_we_l					            : out	  std_logic;
	sram2_ce2					            : out	  std_logic;	
	------------------------------------ 
   sram2_bwa                           : out	  std_logic;
   sram2_bwb                           : out	  std_logic;
   sram2_bwc                           : out	  std_logic;
   sram2_bwd                           : out	  std_logic;   
   --================================--
	-- VARIOUS
	--================================--
	fpga_reset_b	 			            : in	  std_logic;				
	fpga_power_on_reset_b	            : in	  std_logic;
   ------------------------------------
	fpga_scl  					            : inout std_logic;				
	fpga_sda						            : inout std_logic;			
   ------------------------------------
	fpga_clkout	  				            : out	  std_logic;				
	------------------------------------
   sn			                           : in    std_logic_vector(7 downto 0);	
   ------------------------------------   
   v6_led                              : out	  std_logic_vector(1 to 3);
   ------------------------------------
	v6_cpld						            : inout std_logic_vector(0 to 5)
);                    	
end glib_top;
							
architecture glib_top_arch of glib_top is                    	


--##########################################--
--##############    SIGNAL    ##############--
--############## DECLARATIONS ##############--                              
--##########################################--


signal user_reset                      : std_logic;
---------------------------------------
signal user_clk125_2  		            : std_logic;
signal user_clk125_2_bufg              : std_logic;
signal user_clk200_bufg						: std_logic;
signal user_pri_clk					      : std_logic;
---------------------------------------
signal sec_clk                         : std_logic;
signal user_ipb_clk					      : std_logic;
signal sys_pcie_mgt_refclk             : std_logic;
signal user_sys_pcie_dma_clk           : std_logic;
---------------------------------------
signal cdce_out0_gtxe1                 : std_logic; 
signal cdce_out3_gtxe1                 : std_logic;   
---------------------------------------
signal user_cdce_sel					      : std_logic;
signal user_cdce_sync				      : std_logic;
---------------------------------------
signal user_mac_addr 			         : std_logic_vector(47 downto 0);
signal user_ip_addr	   		         : std_logic_vector(31 downto 0);
---------------------------------------
signal user_mac_syncacqstatus		      : std_logic_vector(0 to 3);
signal user_mac_serdes_locked		      : std_logic_vector(0 to 3);
---------------------------------------
signal sys_eth_amc_p1_tx_p	            : std_logic;
signal sys_eth_amc_p1_tx_n		         : std_logic;
signal sys_eth_amc_p1_rx_p             : std_logic;
signal sys_eth_amc_p1_rx_n		         : std_logic;
---------------------------------------
signal user_slv_to_sys_pcie		      : R_slv_to_ezdma2;									
signal user_slv_from_sys_pcie          : R_slv_from_ezdma2;         						
signal user_dma_to_sys_pcie		      : R_userDma_to_ezdma2_array   (1 to 7); 		
signal user_dma_from_sys_pcie          : R_userDma_from_ezdma2_array (1 to 7); 		
signal user_int_to_sys_pcie     	      : R_int_to_ezdma2;									
signal user_int_from_sys_pcie	         : R_int_from_ezdma2;         																					 						
signal user_cfg_from_sys_pcie          : R_cfg_from_ezdma2;									
---------------------------------------
signal sys_pcie_amc_tx_p               : std_logic_vector(0 to 3);
signal sys_pcie_amc_tx_n               : std_logic_vector(0 to 3);
signal sys_pcie_amc_rx_p               : std_logic_vector(0 to 3);
signal sys_pcie_amc_rx_n               : std_logic_vector(0 to 3);
---------------------------------------
signal user_sram_control			      : userSramControlR_array(1 to 2);
signal user_sram_addr				      : array_2x21bit;
signal user_sram_wdata				      : array_2x36bit;
signal user_sram_rdata				      : array_2x36bit;
---------------------------------------
signal user_wb_miso					      : wb_miso_bus_array(0 to number_of_wb_slaves-1);
signal user_wb_mosi					      : wb_mosi_bus_array(0 to number_of_wb_slaves-1);
---------------------------------------
signal user_ipb_miso					      : ipb_rbus_array	(0 to number_of_ipb_slaves-1);
signal user_ipb_mosi					      : ipb_wbus_array	(0 to number_of_ipb_slaves-1);
	
signal amc_slot								: std_logic_vector(3 downto 0);	

signal user_cdce_sync_done					: std_logic;
	
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin-- ARCHITECTURE
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--


--===================================================--
system: entity work.system_core
--===================================================--
port map
(
   --================================--
	-- SYSTEM MGT REFCLKs 
	--================================--  
	-- BANK_114(Q2): 
   clk125_2_p            	            => clk125_2_p             ,										
	clk125_2_n            	            => clk125_2_n             ,					
   --================================--            
	-- SYSTEM FABRIC CLOCKS             
	--================================-- 					           
	xpoint1_clk1_p         	            => xpoint1_clk1_p   	 	  ,										
	xpoint1_clk1_n            	         => xpoint1_clk1_n	    	  ,	
	--================================--               
	-- AMC                                 
	--================================--               
	sys_eth_amc_p0_tx_p		            => amc_port_tx_p(0)       ,
	sys_eth_amc_p0_tx_n		            => amc_port_tx_n(0)	     ,
	sys_eth_amc_p0_rx_p		            => amc_port_rx_p(0)	     ,
	sys_eth_amc_p0_rx_n		            => amc_port_rx_n(0)	     ,
   ------------------------------------	         
	sys_eth_amc_p1_tx_p		            => sys_eth_amc_p1_tx_p    ,  -- (from user_logic)
	sys_eth_amc_p1_tx_n		            => sys_eth_amc_p1_tx_n    ,  -- (from user_logic)
	sys_eth_amc_p1_rx_p		            => sys_eth_amc_p1_rx_p    ,  -- (from user_logic)
	sys_eth_amc_p1_rx_n		            => sys_eth_amc_p1_rx_n    ,  -- (from user_logic)
   ------------------------------------	         
   sys_pcie_amc_tx_p		               => sys_pcie_amc_tx_p	     ,  -- (from user_logic)
   sys_pcie_amc_tx_n		               => sys_pcie_amc_tx_n	     ,  -- (from user_logic)
   sys_pcie_amc_rx_p		               => sys_pcie_amc_rx_p	     ,  -- (from user_logic)
   sys_pcie_amc_rx_n		               => sys_pcie_amc_rx_n	     ,  -- (from user_logic)   
   --================================--         
	-- GBE PHY        
	--================================--         
	gbe_tx_p						            => gbe_tx_p					  ,
	gbe_tx_n						            => gbe_tx_n					  ,
	gbe_rx_p						            => gbe_rx_p					  ,
	gbe_rx_n						            => gbe_rx_n					  ,
	gbe_reset_n					            => gbe_reset_n				  ,	
	gbe_int_n					            => gbe_int_n				  ,	
	gbe_scl_mdc					            => gbe_scl_mdc				  ,
	gbe_sda_mdio				            => gbe_sda_mdio			  ,
	--================================--         
	-- FMC2 RESERVED MGT          
	--================================--         
	fmc2_tx_p					            => fmc2_tx_p				  ,
	fmc2_tx_n					            => fmc2_tx_n				  ,
	fmc2_rx_p					            => fmc2_rx_p				  ,
	fmc2_rx_n					            => fmc2_rx_n				  ,
	--================================--               
	-- CLK CIRCUITRY              
	--================================--               
	xpoint1_s40	   		               => xpoint1_s40	   		  ,
	xpoint1_s41	   	                  => xpoint1_s41	   	     ,
	xpoint1_s30	   	                  => xpoint1_s30	   	     ,
	xpoint1_s31	   	                  => xpoint1_s31	   	     ,
	xpoint1_s20	   	                  => xpoint1_s20	   	     ,
	xpoint1_s21	   	                  => xpoint1_s21	   	     ,
	xpoint1_s10	   	                  => xpoint1_s10	   	     ,
	xpoint1_s11	   	                  => xpoint1_s11	   	     ,
	-----------                         
	xpoint2_s10	 			               => xpoint2_s10	 			  ,
	xpoint2_s11	 			               => xpoint2_s11	 			  ,
	------------------------------------               
	ics874003_fsel	 		               => ics874003_fsel	 		  ,
	ics874003_mr	 			            => ics874003_mr	 		  ,
	ics874003_oe	 			            => ics874003_oe	 		  ,
	------------------------------------               
	tclkb_dr_en				               => tclkb_dr_en				  ,
	------------------------------------         
   cdce_pwr_down				            => cdce_pwr_down			  ,	
	cdce_ref_sel				            => cdce_ref_sel			  ,	
	cdce_sync					            => cdce_sync				  ,	
	cdce_spi_clk				            => cdce_spi_clk			  ,	
	cdce_spi_le					            => cdce_spi_le				  ,	
	cdce_spi_mosi				            => cdce_spi_mosi			  ,	
	cdce_pll_lock				            => cdce_pll_lock			  ,	
	cdce_spi_miso				            => cdce_spi_miso			  ,	
   --------------                   
	cdce_sec_ref_p			               => cdce_sec_ref_p		     ,
   cdce_sec_ref_n			               => cdce_sec_ref_n		     ,   
	--================================--         
	-- VARIOUS        
	--================================--         	
	fpga_scl  					            => fpga_scl  				  ,
	fpga_sda						            => fpga_sda					  , 
   ------------------------------------            
	fpga_reset_b	 			            => fpga_reset_b	 		  ,
	fpga_power_on_reset_b	            => fpga_power_on_reset_b  ,
	------------------------------------         
	sys_v6_led_3                        => v6_led(3)              ,
   ------------------------------------   
   v6_cpld						            => v6_cpld					  ,
	------------------------------------         
   sfp_mod_abs					            => sfp_mod_abs				  ,
	sfp_rxlos					            => sfp_rxlos				  ,
	sfp_txfault					            => sfp_txfault				  ,
	--================================--         
	-- FMC PRESENT       
	--================================--         
	fmc1_present_l				            => fmc1_present_l			  ,
	fmc2_present_l				            => fmc2_present_l			  ,
	--================================--         
	-- MEMORIES (FLASH & SRAMs)                         
	--================================--         
	sram1_addr					            => sram1_addr				  ,
	sram1_data					            => sram1_data				  ,
	sram2_addr					            => sram2_addr				  ,
	sram2_data					            => sram2_data				  ,
	------------------------------------
   fpga_a22 			                  => fpga_a22					  ,
   fpga_a21				                  => fpga_a21					  ,
   fpga_rs0				                  => fpga_rs0 				  ,	
   fpga_rs1 			                  => fpga_rs1 				  ,
  	------------------------------------         
	sram_adv_ld_l(1)			            => sram1_adv_ld_l			  ,
	sram_adv_ld_l(2)			            => sram2_adv_ld_l			  ,
	sram_ce1_l(1)				            => sram1_ce1_l				  ,			
	sram_ce1_l(2)				            => sram2_ce1_l				  ,			
	sram_cen_l(1)				            => sram1_cen_l				  ,	
	sram_cen_l(2)				            => sram2_cen_l				  ,	
	sram_clk(1)		   		            => sram1_clk				  ,
	sram_clk(2)		   		            => sram2_clk				  ,
	sram_mode(1)				            => sram1_mode				  ,
	sram_mode(2)				            => sram2_mode				  ,
	sram_oe_l(1)				            => sram1_oe_l				  , 
	sram_oe_l(2)				            => sram2_oe_l				  , 
	sram_we_l(1)				            => sram1_we_l				  ,
	sram_we_l(2)				            => sram2_we_l				  ,
   ------------------------------------			         
	sram2_ce2					            =>	sram2_ce2				  ,	
	--================================--         
	-- USER INTERFACE       
	--================================--         
   user_reset_o				            => user_reset				  ,
	------------------------------------         
	user_clk125_2_o                     => user_clk125_2          ,
   user_clk125_2_bufg_o                => user_clk125_2_bufg     ,
	user_clk200_bufg_o						=> user_clk200_bufg       ,
	---------               
   sec_clk_i              	            => sec_clk                ,  -- (from user_logic)
   sys_pcie_mgt_refclk_i	            => sys_pcie_mgt_refclk    ,  -- (from user_logic) 
   user_sys_pcie_dma_clk_o             => user_sys_pcie_dma_clk  ,     
   ------------------------------------         
	user_sram_control_i		            => user_sram_control		  ,	
	user_sram_addr_i			            => user_sram_addr			  , 
	user_sram_wdata_i			            => user_sram_wdata		  , 
	user_sram_rdata_o			            => user_sram_rdata		  ,
	------------------------------------         
	cdce_out0_gtxe1_i		               => cdce_out0_gtxe1        ,
   cdce_out3_gtxe1_i		               => cdce_out3_gtxe1        ,
   ------------------------------------   
   user_cdce_sel_i			            => user_cdce_sel			  ,
	user_cdce_sync_i			            => user_cdce_sync			  , 
	------------------------------------ 
   user_mac_addr_i 			            => user_mac_addr 		     ,         
   user_ip_addr_i				            => user_ip_addr			  ,           
   ------------------------------------         
	user_mac_syncacqstatus_o            => user_mac_syncacqstatus ,
	user_mac_serdes_locked_o            => user_mac_serdes_locked ,
	------------------------------------   
   user_sys_pcie_slv_i	               => user_slv_to_sys_pcie	  ,  
	user_sys_pcie_slv_o	               => user_slv_from_sys_pcie ,  
	user_sys_pcie_dma_i	               => user_dma_to_sys_pcie	  ,  
	user_sys_pcie_dma_o                 => user_dma_from_sys_pcie ,  
	user_sys_pcie_int_i                 => user_int_to_sys_pcie   ,  
	user_sys_pcie_int_o                 => user_int_from_sys_pcie ,	
	user_sys_pcie_cfg_o 		            => user_cfg_from_sys_pcie ,  	
	------------------------------------   
	user_wb_miso_i				            => user_wb_miso			  ,
	user_wb_mosi_o				            => user_wb_mosi			  ,
	------------------------------------         
	user_ipb_clk_o				            => user_ipb_clk			  ,
	user_ipb_miso_i			            => user_ipb_miso			  ,
	user_ipb_mosi_o			            => user_ipb_mosi			
);                    	
--===================================================--


--===================================================--
usr: entity work.user_logic
--===================================================--
port map
(	  
   --================================--
	-- USER MGT REFCLKs 
	--================================--  
   -- BANK_112(Q0):  
   clk125_1_p	      		            => clk125_1_p             ,	            
   clk125_1_n	      		            => clk125_1_n             ,      
   cdce_out0_p	   		               => cdce_out0_p            ,      
   cdce_out0_n	   		               => cdce_out0_n            ,     
   -- BANK_113(Q1):                       
   fmc2_clk0_m2c_xpoint2_p	            => fmc2_clk0_m2c_xpoint2_p, 
   fmc2_clk0_m2c_xpoint2_n	            => fmc2_clk0_m2c_xpoint2_n,
   cdce_out1_p	                        => cdce_out1_p            ,	        
   cdce_out1_n	                        => cdce_out1_n            ,	        
   -- BANK_114(Q2):                       
   pcie_clk_p	     			            => pcie_clk_p             ,	         
   pcie_clk_n	     			            => pcie_clk_n             ,	        
   cdce_out2_p  	  			            => cdce_out2_p            ,        
   cdce_out2_n  	  			            => cdce_out2_n            ,        
   -- BANK_115(Q3):                       
   clk125_2_i          		            => user_clk125_2          ,           
   fmc1_gbtclk1_m2c_p	               => fmc1_gbtclk1_m2c_p     , 	   
   fmc1_gbtclk1_m2c_n	               => fmc1_gbtclk1_m2c_n     , 	   
   -- BANK_116(Q4):                       
   fmc1_gbtclk0_m2c_p		            => fmc1_gbtclk0_m2c_p     ,	     
   fmc1_gbtclk0_m2c_n		            => fmc1_gbtclk0_m2c_n     ,	     
   cdce_out3_p	      		            => cdce_out3_p            ,	         
   cdce_out3_n	      		            => cdce_out3_n            ,	           
   --================================--      
	-- USER FABRIC CLOCKS      
	--================================--      
	xpoint1_clk3_p			               => xpoint1_clk3_p         ,			
	xpoint1_clk3_n			               => xpoint1_clk3_n         ,			  
   ------------------------------------         
   cdce_out4_p                         => cdce_out4_p            ,   
   cdce_out4_n                         => cdce_out4_n            ,   
   ------------------------------------      
	amc_tclkb_o 				            => amc_tclkb              ,
   ------------------------------------   
   fmc1_clk0_m2c_xpoint2_p	            => fmc1_clk0_m2c_xpoint2_p,	
	fmc1_clk0_m2c_xpoint2_n	            => fmc1_clk0_m2c_xpoint2_n,	
	fmc1_clk1_m2c_p			            => fmc1_clk1_m2c_p        ,			
	fmc1_clk1_m2c_n			            => fmc1_clk1_m2c_n        ,			
	fmc1_clk2_bidir_p			            => fmc1_clk2_bidir_p      ,			
	fmc1_clk2_bidir_n			            => fmc1_clk2_bidir_n      ,			
	fmc1_clk3_bidir_p			            => fmc1_clk3_bidir_p      ,			
	fmc1_clk3_bidir_n			            => fmc1_clk3_bidir_n      ,			
   ------------------------------------      
	fmc2_clk1_m2c_p			            => fmc2_clk1_m2c_p        ,			
	fmc2_clk1_m2c_n			            => fmc2_clk1_m2c_n        ,	   
	--================================--
	-- GBT PHASE MONITORING MGT REFCLK
	--================================--
   cdce_out0_gtxe1_o    	            => cdce_out0_gtxe1        ,     
   cdce_out3_gtxe1_o    	            => cdce_out3_gtxe1        ,  
	--================================--      
	-- AMC PORTS                       
	--================================--    
   amc_port_tx_p		                  => amc_port_tx_p(1 to 15) ,
	amc_port_tx_n		                  => amc_port_tx_n(1 to 15) ,
	amc_port_rx_p		                  => amc_port_rx_p(1 to 15) ,
	amc_port_rx_n		                  => amc_port_rx_n(1 to 15) ,
	------------------------------------	      
	amc_port_tx_out			            => amc_port_tx_out		  ,
	amc_port_tx_in			               => amc_port_tx_in			  ,
	amc_port_tx_de			               => amc_port_tx_de			  ,
	amc_port_rx_out			            => amc_port_rx_out		  ,
	amc_port_rx_in			               => amc_port_rx_in			  ,
	amc_port_rx_de			               => amc_port_rx_de			  ,
	--================================--      
	-- SFP QUAD                   
	--================================--      
	sfp_tx_p						            => sfp_tx_p					  ,
	sfp_tx_n						            => sfp_tx_n					  ,
	sfp_rx_p						            => sfp_rx_p					  ,
	sfp_rx_n						            => sfp_rx_n					  ,
	sfp_mod_abs					            => sfp_mod_abs				  , 
	sfp_rxlos					            => sfp_rxlos				  ,
	sfp_txfault					            => sfp_txfault				  ,
	--================================--         
	-- FMC1     
	--================================--         
	fmc1_tx_p					            => fmc1_tx_p				  ,
	fmc1_tx_n                           => fmc1_tx_n              ,
	fmc1_rx_p                           => fmc1_rx_p              ,
	fmc1_rx_n                           => fmc1_rx_n              ,
	------------------------------------         
	fmc1_io_pin.la_p			            => fmc1_la_p				  ,
	fmc1_io_pin.la_n			            => fmc1_la_n				  ,
	fmc1_io_pin.ha_p			            => fmc1_ha_p				  ,
	fmc1_io_pin.ha_n			            => fmc1_ha_n				  ,
	fmc1_io_pin.hb_p			            => fmc1_hb_p				  ,
	fmc1_io_pin.hb_n			            => fmc1_hb_n				  ,
	------------------------------------         
	fmc1_clk_c2m_p				            => fmc1_clk_c2m_p			  ,
	fmc1_clk_c2m_n				            => fmc1_clk_c2m_n			  ,
	fmc1_present_l				            => fmc1_present_l			  ,
	--================================--      
	-- FMC2     
	--================================--      
	fmc2_io_pin.la_p			            => fmc2_la_p				  ,
	fmc2_io_pin.la_n			            => fmc2_la_n				  ,
	fmc2_io_pin.ha_p			            => fmc2_ha_p				  ,
	fmc2_io_pin.ha_n			            => fmc2_ha_n				  ,
	fmc2_io_pin.hb_p			            => fmc2_hb_p				  ,
	fmc2_io_pin.hb_n			            => fmc2_hb_n				  ,
	------------------------------------         
	fmc2_clk_c2m_p				            => fmc2_clk_c2m_p			  ,
	fmc2_clk_c2m_n				            => fmc2_clk_c2m_n			  ,
	fmc2_present_l				            => fmc2_present_l			  ,
   --================================--         
	-- SYSTEM GBE           
	--================================--      
   sys_eth_amc_p1_tx_p		            => sys_eth_amc_p1_tx_p    ,
   sys_eth_amc_p1_tx_n		            => sys_eth_amc_p1_tx_n    ,
   sys_eth_amc_p1_rx_p		            => sys_eth_amc_p1_rx_p    ,
   sys_eth_amc_p1_rx_n		            => sys_eth_amc_p1_rx_n    ,
   ------------------------------------      
	user_mac_syncacqstatus_i            => user_mac_syncacqstatus ,
	user_mac_serdes_locked_i            => user_mac_serdes_locked ,
	--================================--									    	
	-- SYSTEM PCIe													      		
	--================================--         
   sys_pcie_mgt_refclk_o	            => sys_pcie_mgt_refclk    ,
   user_sys_pcie_dma_clk_i             => user_sys_pcie_dma_clk  ,
   ------------------------------------      
	sys_pcie_amc_tx_p		               => sys_pcie_amc_tx_p      ,
   sys_pcie_amc_tx_n		               => sys_pcie_amc_tx_n      ,
   sys_pcie_amc_rx_p		               => sys_pcie_amc_rx_p      ,
   sys_pcie_amc_rx_n		               => sys_pcie_amc_rx_n      ,
   ------------------------------------      
	user_sys_pcie_slv_o	               => user_slv_to_sys_pcie	  ,              	
	user_sys_pcie_slv_i	               => user_slv_from_sys_pcie ,               
	user_sys_pcie_dma_o   	            => user_dma_to_sys_pcie	  ,  		      					
	user_sys_pcie_dma_i    	            => user_dma_from_sys_pcie ,              	
	user_sys_pcie_int_o 	               => user_int_to_sys_pcie   ,              	
	user_sys_pcie_int_i 	               => user_int_from_sys_pcie ,	             
	user_sys_pcie_cfg_i 		            => user_cfg_from_sys_pcie ,              	
	--================================--     
	-- SRAMs   
	--================================--     
	user_sram_control_o		            => user_sram_control		  ,
	user_sram_addr_o			            => user_sram_addr			  , 
	user_sram_wdata_o			            => user_sram_wdata		  , 
	user_sram_rdata_i			            => user_sram_rdata		  ,
   ------------------------------------			         
	sram1_bwa				               => sram1_bwa		        ,
   sram1_bwb				               => sram1_bwb		        ,
   sram1_bwc				               => sram1_bwc		        ,
   sram1_bwd				               => sram1_bwd		        ,
   sram2_bwa				               => sram2_bwa		        ,
   sram2_bwb				               => sram2_bwb		        ,
   sram2_bwc				               => sram2_bwc		        ,
   sram2_bwd				               => sram2_bwd              ,   
   --================================--               
	-- CLK CIRCUITRY              
	--================================--      
	fpga_clkout_o	  			            => fpga_clkout	  			  ,
   ------------------------------------      
   sec_clk_o		                     => sec_clk                ,	  
   ------------------------------------                  
   user_cdce_locked_i                  => cdce_pll_lock          , -- directly taken from a pin            
   user_cdce_sync_done_i               => user_cdce_sync_done    ,            
   user_cdce_sel_o			            => user_cdce_sel			  ,
	user_cdce_sync_o			            => user_cdce_sync			  ,
	--================================--  
	-- USER BUS  
	--================================--   
	wb_miso_o				               => user_wb_miso	        ,
	wb_mosi_i				               => user_wb_mosi	        ,
	------------------------------------           
	ipb_clk_i				               => user_ipb_clk	        ,
	ipb_miso_o			                  => user_ipb_miso	        ,
	ipb_mosi_i			                  => user_ipb_mosi          ,
   --================================--  
	-- VARIOUS 
	--================================--  
   reset_i						            => user_reset				  ,
   user_clk125_i                     	=> user_clk125_2_bufg     ,
   user_clk200_i                     	=> user_clk200_bufg  	  ,
   ------------------------------------
   amc_slot_i									=> amc_slot					  ,
	mac_addr_o                          => user_mac_addr          ,					            
   ip_addr_o	                        => user_ip_addr			  ,	            
   ------------------------------------   
   sn			                           => sn                     ,
   ------------------------------------
   user_v6_led_o                       => v6_led(1 to 2)         
);   
--===================================================--

amc_slot(3) <= v6_cpld(3);
amc_slot(2) <= v6_cpld(2);
amc_slot(1) <= v6_cpld(1);
amc_slot(0) <= v6_cpld(0);


  	
end glib_top_arch;