library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.ipbus.all;
use work.system_package.all;
use work.wb_package.all;
use work.system_flash_sram_package.all;
use work.system_pcie_package.all;
--! user packages
use work.user_package.all;


entity system_core is
port
(
   --================================--
	-- system mgt refclks 
	--================================--
	clk125_2_p            	            : in	  std_logic;										
	clk125_2_n            	            : in	  std_logic;										 
   --================================--  
	-- system fabric clocks   
	--================================--  
	xpoint1_clk1_p         	            : in	  std_logic;										
	xpoint1_clk1_n            	         : in	  std_logic; 									
	--================================--  
	-- amc  
	--================================--  
	sys_eth_amc_p0_tx_p		            : out	  std_logic;
	sys_eth_amc_p0_tx_n		            : out	  std_logic;
	sys_eth_amc_p0_rx_p		            : in	  std_logic;
	sys_eth_amc_p0_rx_n		            : in	  std_logic;
   ------------------------------------
	sys_eth_amc_p1_tx_p		            : out	  std_logic;
	sys_eth_amc_p1_tx_n		            : out	  std_logic;
	sys_eth_amc_p1_rx_p		            : in	  std_logic;
	sys_eth_amc_p1_rx_n		            : in	  std_logic;
   ------------------------------------  
   sys_pcie_amc_tx_p		               : out	  std_logic_vector(0 to 3);	
   sys_pcie_amc_tx_n		               : out	  std_logic_vector(0 to 3);	
   sys_pcie_amc_rx_p		               : in	  std_logic_vector(0 to 3);	
   sys_pcie_amc_rx_n		               : in	  std_logic_vector(0 to 3);	
	--================================--  
	-- gbe  
	--================================--  
	gbe_tx_p						            : out	  std_logic;
	gbe_tx_n						            : out	  std_logic;
	gbe_rx_p						            : in	  std_logic;
	gbe_rx_n						            : in	  std_logic;
	gbe_reset_n					            : out	  std_logic;	
	gbe_int_n					            : in	  std_logic;	
	gbe_scl_mdc 				            : inout std_logic;   -- by default is mdc
	gbe_sda_mdio				            : inout std_logic;   -- by default is mdio   
	--================================--  
	-- fmc2 reserved mgt   
	--================================--  
	fmc2_tx_p					            : out	  std_logic;
	fmc2_tx_n					            : out	  std_logic;
	fmc2_rx_p					            : in	  std_logic;
	fmc2_rx_n					            : in	  std_logic; 
	--================================--  
	-- clk circuitry 
	--================================--  
	xpoint1_s40   		                  : out	  std_logic;
	xpoint1_s41   	                     : out	  std_logic;
	xpoint1_s30   	                     : out	  std_logic;
	xpoint1_s31   	                     : out	  std_logic;
	xpoint1_s20   	                     : out	  std_logic;
	xpoint1_s21   	                     : out	  std_logic;
	xpoint1_s10   	                     : out	  std_logic;
	xpoint1_s11   	                     : out	  std_logic;
	-----------             
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
  	cdce_sec_ref_p			               : out	  std_logic;
   cdce_sec_ref_n			               : out	  std_logic;  
	--================================--  
	-- various 
	--================================--  
	fpga_reset_b	 			            : in	  std_logic;				
	fpga_power_on_reset_b	            : in	  std_logic;						
   ------------------------------------     
	fpga_scl  					            : inout std_logic;				
	fpga_sda						            : inout std_logic;  
   ------------------------------------   
   sfp_mod_abs					            : in	  std_logic_vector(1 to 4);		
	sfp_rxlos					            : in	  std_logic_vector(1 to 4);		
	sfp_txfault					            : in	  std_logic_vector(1 to 4);	
   ------------------------------------      
	sys_v6_led_3                        : out	  std_logic;
   ------------------------------------  
	v6_cpld						            : inout std_logic_vector(0 to 5);
	--================================--  
	-- fmc present   
	--================================--  
	fmc1_present_l				            : in	  std_logic;
	fmc2_present_l				            : in	  std_logic;
	--================================--  
	-- memories (flash & srams)
	--================================--  
	sram1_addr					            : out	  std_logic_vector(20 downto 0);
	sram1_data					            : inout std_logic_vector(35 downto 0);
	sram2_addr					            : out	  std_logic_vector(20 downto 0);
	sram2_data					            : inout std_logic_vector(35 downto 0);
	------------------------------------
   fpga_a22 			                  : out	  std_logic;	
   fpga_a21			                     : out	  std_logic;	
   fpga_rs0	 		  			            : out	  std_logic;				
	fpga_rs1  					            : out	  std_logic;   
   ------------------------------------  
	sram_adv_ld_l				            : out	  std_logic_vector(1 to 2);	
	sram_ce1_l					            : out	  std_logic_vector(1 to 2);				
	sram_cen_l					            : out	  std_logic_vector(1 to 2);		
	sram_clk						            : out	  std_logic_vector(1 to 2);
	sram_mode					            : out	  std_logic_vector(1 to 2);
	sram_oe_l	   			            : out	  std_logic_vector(1 to 2);
	sram_we_l					            : out	  std_logic_vector(1 to 2);
	------------------------------------  
	sram2_ce2					            : out	  std_logic;	
	--================================--  
	-- user interface
	--================================--  
	user_reset_o				            : out	  std_logic;
   ------------------------------------  
   user_clk200_bufg_o						: out	  std_logic;
	user_clk125_2_o                     : out	  std_logic;
   user_clk125_2_bufg_o	               : out	  std_logic;
   --user_pri_clk_o			            : out	  std_logic;
   ---------            
   sec_clk_i              	            : in	  std_logic;		
   sys_pcie_mgt_refclk_i               : in 	  std_logic;
   user_sys_pcie_dma_clk_o             : out	  std_logic;    
   ------------------------------------  
   cdce_out0_gtxe1_i                   : in    std_logic; 
   cdce_out3_gtxe1_i                   : in    std_logic;   
   ------------------------------------
   user_cdce_sel_i			            : in	  std_logic;
	user_cdce_sync_i			            : in	  std_logic;
	user_cdce_sync_done_o	            : out   std_logic;
	------------------------------------  
   user_sram_control_i		            : in 	  usersramcontrolr_array(1 to 2);
	user_sram_addr_i			            : in 	  array_2x21bit;
	user_sram_wdata_i			            : in 	  array_2x36bit;
	user_sram_rdata_o			            : out   array_2x36bit;
	------------------------------------ 		  
	user_mac_addr_i 			            : in    std_logic_vector(47 downto 0);
   user_ip_addr_i				            : in    std_logic_vector(31 downto 0);
   ------------------------------------   
   user_mac_syncacqstatus_o            : out	  std_logic_vector(0 to 3);
	user_mac_serdes_locked_o            : out	  std_logic_vector(0 to 3);
   ------------------------------------  
   user_sys_pcie_slv_i                 : in    r_slv_to_ezdma2;									
   user_sys_pcie_slv_o                 : out   r_slv_from_ezdma2; 	   						
   user_sys_pcie_dma_i                 : in    r_userdma_to_ezdma2_array  (1 to 7);		
   user_sys_pcie_dma_o                 : out   r_userdma_from_ezdma2_array(1 to 7);		
   user_sys_pcie_int_i                 : in    r_int_to_ezdma2;									
   user_sys_pcie_int_o                 : out   r_int_from_ezdma2; 								
	user_sys_pcie_cfg_o                 : out   r_cfg_from_ezdma2; 								
   ------------------------------------  
	user_wb_miso_i				            : in 	  wb_miso_bus_array(0 to number_of_wb_slaves-1);
	user_wb_mosi_o				            : out   wb_mosi_bus_array(0 to number_of_wb_slaves-1);
	------------------------------------  
	user_ipb_clk_o				            : out	  std_logic;
	user_ipb_miso_i			            : in 	  ipb_rbus_array(0 to number_of_ipb_slaves-1);
	user_ipb_mosi_o			            : out   ipb_wbus_array(0 to number_of_ipb_slaves-1)
	------------------------------------
   );                    	
end system_core;
	
architecture mixed_arch of system_core is                    	


--##########################################--
--########## signal and constant ###########--
--############## declarations ##############--
--##########################################--

attribute keep                         : string;

---------------------------------------
signal reset, rst_mac, rst_gtx			: std_logic;
---------------------------------------   
signal clk125_2_mgt, clk125_2				: std_logic;
signal xpoint1_clk1       					: std_logic;
signal xpoint1_clk1_prebuf					: std_logic;
---------------------------------------   
signal glib_pll_clkfbin						: std_logic;
signal glib_pll_clkfbout					: std_logic;
signal glib_pll_clkout_125					: std_logic;
signal glib_pll_clkout_31_25_a			: std_logic;
signal glib_pll_clkout_31_25_b			: std_logic;
signal glib_pll_clkout_31_25_c			: std_logic;
signal glib_pll_clkout_31_25_d_inv		: std_logic;
signal glib_pll_clkout_200					: std_logic;
signal glib_pll_locked						: std_logic;
---------------------------------------   
signal ipb_clk									: std_logic;
attribute keep of ipb_clk					: signal is "true";
signal ipb_inv_clk							: std_logic;
signal ipb_rst									: std_logic;
signal busy_from_ipb_arb					: std_logic;
signal ipb_from_masters						: ipb_wbus_array(0 to 3);
signal ipb_to_masters						: ipb_rbus_array(0 to 3);
signal ipb_req									: std_logic_vector(0 to 3);
signal ipb_grant								: std_logic_vector(0 to 3);
signal ipb_from_eth							: ipb_wbus;		
signal ipb_to_eth								: ipb_rbus;		
signal ipb_from_pcie	   					: ipb_wbus;		
signal ipb_to_pcie							: ipb_rbus;		
signal ipb_to_fabric							: ipb_wbus;		
signal ipb_from_fabric						: ipb_rbus;
signal ipb_to_slaves							: ipb_wbus_array(0 to number_of_slaves-1);
signal ipb_from_slaves						: ipb_rbus_array(0 to number_of_slaves-1);
---------------------------------------   
signal clk_from_sys_pcie					: std_logic;	
signal busy_from_sys_pcie					: std_logic;	
---------------------------------------   
signal eth_clk       						: std_logic;
signal gbe_mgt_resetdone 					: std_logic;
signal mac_clk									: std_logic_vector(0 to 3);
signal rst_macclk								: std_logic_vector(0 to 3);
signal rst_eth									: std_logic;	
attribute keep of mac_clk					: signal is "true";

signal eth_locked								: std_logic_vector(0 to 3);
signal mac_rx_data							: array_4x8bit;
signal mac_rx_valid							: std_logic_vector(0 to 3);
signal mac_rx_last							: std_logic_vector(0 to 3);
signal mac_rx_error							: std_logic_vector(0 to 3);
signal mac_tx_data							: array_4x8bit;
signal mac_tx_valid							: std_logic_vector(0 to 3);
signal mac_tx_last							: std_logic_vector(0 to 3);
signal mac_tx_error							: std_logic_vector(0 to 3);
signal mac_tx_ready							: std_logic_vector(0 to 3);
---------------------------------------   
signal ipb_clk_sram1							: std_logic;
signal ipb_clk_sram2							: std_logic;
signal sram_w									: wsramr_array(1 to 2);
attribute keep of sram_w					: signal is "true";
signal sram_r									: rsramr_array(1 to 2);
attribute keep of sram_r					: signal is "true";
---------------------------------------
signal flash_w									: wflashr;
attribute keep of flash_w					: signal is "true";
signal flash_r									: rflashr;
attribute keep of flash_r					: signal is "true";  
---------------------------------------   
signal regs_to_ipbus			            : array_32x32bit;			
signal regs_from_ipbus		            : array_32x32bit;			
---------------   
signal reg_ctrl								: std_logic_vector(31 downto 0); --  4
signal reg_ctrl_2								: std_logic_vector(31 downto 0); --  5
signal reg_status								: std_logic_vector(31 downto 0);	--  7
signal reg_status_2							: std_logic_vector(31 downto 0); --  8
signal reg_ctrl_sram							: std_logic_vector(31 downto 0); --  6
signal reg_status_sram						: std_logic_vector(31 downto 0);	--  9
signal reg_spi_command						: std_logic_vector(31 downto 0); -- 10
signal reg_spi_txdata						: std_logic_vector(31 downto 0); -- 11
signal reg_spi_rxdata						: std_logic_vector(31 downto 0); -- 12
signal reg_i2c_settings						: std_logic_vector(31 downto 0);	-- 13
signal reg_i2c_command						: std_logic_vector(31 downto 0); -- 14
signal reg_i2c_reply							: std_logic_vector(31 downto 0); -- 15
---------------------------------------   
signal cdce_sync_done						: std_logic;
signal cdce_sync_busy						: std_logic;
signal cdce_sync_clk							: std_logic;
signal cdce_sync_cmd							: std_logic;
---------------------------------------	
signal gbt_phase_mon_reset 				: std_logic; 
signal sfp_phase_mon_threshold_upper	: std_logic_vector( 7 downto 0);
signal sfp_phase_mon_threshold_lower	: std_logic_vector( 7 downto 0);
signal sfp_phase_mon_stats          	: std_logic_vector(15 downto 0);
signal sfp_phase_mon_done           	: std_logic;
signal sfp_phase_mon_phase_ok          : std_logic;
signal fmc1_phase_mon_threshold_upper  : std_logic_vector( 7 downto 0);
signal fmc1_phase_mon_threshold_lower  : std_logic_vector( 7 downto 0);
signal fmc1_phase_mon_stats            : std_logic_vector(15 downto 0);
signal fmc1_phase_mon_done             : std_logic;
signal fmc1_phase_mon_phase_ok         : std_logic;
---------------------------------------   
signal ip_addr									: std_logic_vector(31 downto 0);
signal mac_addr								: std_logic_vector(47 downto 0);

signal mac_from_eep							: std_logic;
signal mac_from_slv							: std_logic;
signal mac_from_usr							: std_logic;
signal ip_from_eep							: std_logic;
signal ip_from_slv							: std_logic;
signal ip_from_usr							: std_logic;   
			   
signal sda_i_master 							: std_logic;
signal sda_o_master 							: std_logic;
signal scl_i_master 							: std_logic;
signal scl_o_master 							: std_logic;

signal sda_i_eeprom 							: std_logic;
signal sda_o_eeprom 							: std_logic;
signal scl_i_eeprom 							: std_logic;
signal scl_o_eeprom 							: std_logic;
signal regs_eeprom							: array_16x8bit;

signal sda_i_slave 							: std_logic;
signal sda_o_slave 							: std_logic;
signal scl_i_slave 							: std_logic;
signal regs_slave								: array_16x8bit;

signal sda_i_slave_ro						: std_logic;
signal sda_o_slave_ro						: std_logic;
signal scl_i_slave_ro						: std_logic;   

signal rarp_select							: std_logic;
--
constant sys_eth_p0_enable       		: boolean  := true;   
constant sys_eth_phy_enable      		: boolean  := true;   
   

   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--   
--@@@@@@@@@@@@@@@@@@@@@@--
begin-- architecture
--@@@@@@@@@@@@@@@@@@@@@@--                              
--@@@@@@@@@@@@@@@@@@@@@@--
--@@@@@@@@@@@@@@@@@@@@@@--


--===================================--
--###################################--
--###################################--
--##### clocks/resets ###############--
--###################################--
--###################################--
--===================================--


	dsbuf_xp1_clk1	: ibufgds	generic map ( capacitance => "dont_care", diff_term => true, ibuf_delay_value => "0", ibuf_low_pwr => true, iostandard => "lvds_25")	
											port map ( i => xpoint1_clk1_p, ib => xpoint1_clk1_n, 		o => xpoint1_clk1_prebuf);	
	clkbuf_xp1_clk1: bufg 			port map ( i => xpoint1_clk1_prebuf, 								o => xpoint1_clk1);
	mgtbuf_clk125_2: ibufds_gtxe1 port map ( i => clk125_2_p, ib => clk125_2_n, ceb => '0', 	o => clk125_2_mgt);
	clkbuf_clk125_2: bufg 			port map ( i => clk125_2_mgt, 										o => clk125_2);

	eth_clk <= clk125_2_mgt;
 




--===================================--
pll: entity work.glib_pll
--===================================--
port map
(
   reset 		    			            => '0',
   clk_in1         			            => clk125_2, 		  				    	-- (no buf)
   --
	clk_out_125     			            => open, --glib_pll_clkout_125		-- (no buf)
   clk_out_31_25_a        			  		=> glib_pll_clkout_31_25_a, 	 		-- (no buf)	
   clk_out_31_25_b         			  	=> glib_pll_clkout_31_25_b,	    	-- (no buf)
   clk_out_31_25_c         			  	=> glib_pll_clkout_31_25_c,	    	-- (no buf)
   clk_out_31_25_d_inv      				=> glib_pll_clkout_31_25_d_inv,   	-- (no buf)      
   clk_out_200      				         => glib_pll_clkout_200,   				-- (no buf)
   --
	clkfb_in										=> glib_pll_clkfbin,
	clkfb_out									=> glib_pll_clkfbout,
	--
	locked          			            => glib_pll_locked  		
);

	clkbuf_pllout2: bufg port map ( i => glib_pll_clkout_31_25_a, 		o => ipb_clk		);
							  ipb_clk_sram1 <= glib_pll_clkout_31_25_b; 									-- bufgmux used inside the sram_if
							  ipb_clk_sram2 <= glib_pll_clkout_31_25_c;									-- bufgmux used inside the sram_if
	clkbuf_pllout5: bufg port map ( i => glib_pll_clkout_31_25_d_inv, o => ipb_inv_clk);   

	clkbuf_pllout6: bufg port map ( i => glib_pll_clkout_200, o => user_clk200_bufg_o);   

	glib_pll_clkfbin <= glib_pll_clkfbout; -- internal feedback, no clock deskew

--===================================--



--===================================--
rst: entity work.rst_ctrl
--===================================--
generic map (nb_eth_blocks => 4)
port map
(
	nuke				=> not fpga_power_on_reset_b,
	clk125_fr_i		=> clk125_2,
	clk_ipb_i		=> ipb_clk,
	pll_locked_i	=> glib_pll_locked,
	clk125_eth_i	=> mac_clk,
	eth_locked_i	=> eth_locked,
	rst_125_o		=> rst_macclk,
	rst_eth_o		=> rst_eth,
	rst_fabric_o	=> reset,
	rst_ipb_o		=> ipb_rst
);
--===================================--

	gbe_reset_n 	<= not reset;


--===================================--
hb: entity work.sys_heartbeat
--===================================--
port map 
(
	reset_i                             => reset,
	clk_i                               => ipb_clk,
	heartbeat_o                         => sys_v6_led_3
);
--===================================--



--===================================--
--###################################--
--###################################--
--##### bus masters #################--
--###################################--
--###################################--
--===================================--



--===================================--
ip_mac: entity work.ip_mac_select
--===================================--
port map 
(
	clk_i 										=> ipb_clk,
	reset_i										=> reset,
	user_mac_addr_i							=> user_mac_addr_i,
	user_ip_addr_i								=> user_ip_addr_i,
	regs_eeprom_i								=> regs_eeprom,
	regs_slave_i								=> regs_slave,
	regs_enable									=> '1',
	--						
	ip_addr_o									=> ip_addr,
	mac_addr_o									=> mac_addr,
	--						
	ext_postfix									=> x"00",
	ext_postfix_enable						=> '0',
	ext_rarp_select							=> '0',
	rarp_select									=> rarp_select,
	--						
	mac_from_eep_o								=> mac_from_eep,
	mac_from_slv_o	   						=> mac_from_slv,
	mac_from_usr_o	   						=> mac_from_usr,
	ip_from_eep_o								=> ip_from_eep,	
	ip_from_slv_o								=> ip_from_slv,	
	ip_from_usr_o								=> ip_from_usr	
);
--===================================--




amc_p0_en: if sys_eth_p0_enable = true generate

	--================================--
	amc_p0_eth: entity work.eth_v6_basex 
	--================================--
	port map
	(
		gt_clk 				        			=> eth_clk, 			
		gt_txp 				        			=> sys_eth_amc_p0_tx_p,				
		gt_txn 				        			=> sys_eth_amc_p0_tx_n,				
		gt_rxp 				        			=> sys_eth_amc_p0_rx_p,				
		gt_rxn 				        			=> sys_eth_amc_p0_rx_n,				
		---         	
		clk125_o									=> mac_clk  	(amc_p0),
		rst										=> rst_eth				  ,
		locked 					     			=> eth_locked	(amc_p0),			
		--         	
		rx_data 									=> mac_rx_data	(amc_p0),
		rx_valid 								=> mac_rx_valid(amc_p0),
		rx_last 									=> mac_rx_last	(amc_p0),
		rx_error 								=> mac_rx_error(amc_p0),
		tx_data 									=> mac_tx_data	(amc_p0),
		tx_valid 								=> mac_tx_valid(amc_p0),
		tx_last 									=> mac_tx_last	(amc_p0),
		tx_error 								=> mac_tx_error(amc_p0),
		tx_ready 								=> mac_tx_ready(amc_p0)
	);
	--================================--


	
	--================================--
	amc_p0_ipb_ctrl: entity work.ipbus_ctrl
	--================================--
	port map
	(
		mac_clk 									=> mac_clk		(amc_p0),
		rst_macclk 								=> rst_macclk	(amc_p0), 
		ipb_clk 									=> ipb_clk,
		rst_ipb 									=> ipb_rst,
		--
		mac_rx_data 							=> mac_rx_data	(amc_p0),
		mac_rx_valid 							=> mac_rx_valid(amc_p0),
		mac_rx_last 							=> mac_rx_last	(amc_p0),
		mac_rx_error 							=> mac_rx_error(amc_p0),
		mac_tx_data 							=> mac_tx_data	(amc_p0),
		mac_tx_valid 							=> mac_tx_valid(amc_p0),
		mac_tx_last 							=> mac_tx_last	(amc_p0),
		mac_tx_error 							=> mac_tx_error(amc_p0),
		mac_tx_ready 							=> mac_tx_ready(amc_p0),
		--
		mac_addr 								=> mac_addr, --x"080030" & mac_addr(23 downto 0),
		ip_addr 									=> ip_addr,
		rarp_select								=> rarp_select,
		--
		ipb_req									=> ipb_req				(amc_p0),
		ipb_grant								=> ipb_grant			(amc_p0),
		ipb_out 									=> ipb_from_masters	(amc_p0),
		ipb_in 									=> ipb_to_masters		(amc_p0)

	);
	--================================--

end generate;

amc_p0_dis: if sys_eth_p0_enable = false generate
	ipb_req         (amc_p0) <= '0';
	ipb_from_masters(amc_p0).ipb_strobe <= '0';
end generate;

amc_p1_en: if sys_eth_p1_enable = true generate

	--================================--
	amc_p1_eth: entity work.eth_v6_basex 
	--================================--
	port map
	(
		gt_clk 				         		=> eth_clk, 			
		gt_txp 				         		=> sys_eth_amc_p1_tx_p,				
		gt_txn 				        	 		=> sys_eth_amc_p1_tx_n,				
		gt_rxp 				         		=> sys_eth_amc_p1_rx_p,				
		gt_rxn 				         		=> sys_eth_amc_p1_rx_n,				
		--
		locked 					         	=> eth_locked	(amc_p1),			
		clk125_o									=> mac_clk  	(amc_p1),
		rst 										=> rst_eth,
		--         
		rx_data 									=> mac_rx_data	(amc_p1),
		rx_valid 								=> mac_rx_valid(amc_p1),
		rx_last 									=> mac_rx_last	(amc_p1),
		rx_error 								=> mac_rx_error(amc_p1),
		tx_data 									=> mac_tx_data	(amc_p1),
		tx_valid 								=> mac_tx_valid(amc_p1),
		tx_last 									=> mac_tx_last	(amc_p1),
		tx_error 								=> mac_tx_error(amc_p1),
		tx_ready 								=> mac_tx_ready(amc_p1)
	);
	--================================--




	--================================--
	amc_p1_ipb_ctrl: entity work.ipbus_ctrl 
	--================================--
	port map
	(
		mac_clk 									=> mac_clk		(amc_p1),
		rst_macclk 								=> rst_macclk	(amc_p1), 
		ipb_clk 									=> ipb_clk,
		rst_ipb 									=> ipb_rst,
		--
		mac_rx_data 							=> mac_rx_data	(amc_p1),
		mac_rx_valid 							=> mac_rx_valid(amc_p1),
		mac_rx_last 							=> mac_rx_last	(amc_p1),
		mac_rx_error 							=> mac_rx_error(amc_p1),
		mac_tx_data 							=> mac_tx_data	(amc_p1),
		mac_tx_valid 							=> mac_tx_valid(amc_p1),
		mac_tx_last 							=> mac_tx_last	(amc_p1),
		mac_tx_error 							=> mac_tx_error(amc_p1),
		mac_tx_ready 							=> mac_tx_ready(amc_p1),
		--
		mac_addr 								=> mac_addr, --x"080030" & mac_addr(23 downto 0),
		ip_addr 									=> ip_addr,
		rarp_select								=> rarp_select,
		--
		ipb_req									=> ipb_req				(amc_p1),
		ipb_grant								=> ipb_grant			(amc_p1),
		ipb_out 									=> ipb_from_masters	(amc_p1),
		ipb_in 									=> ipb_to_masters		(amc_p1)
	);
	--================================--
   
end generate;

amc_p1_dis: if sys_eth_p1_enable = false generate
	ipb_req         (amc_p1) <= '0';
	ipb_from_masters(amc_p1).ipb_strobe <= '0';
end generate;
   

phy_en: if sys_eth_phy_enable = true generate

	--================================--
	phy_eth: entity work.eth_v6_sgmii 
	--================================--
	port map
	(
		sgmii_clk 				            => eth_clk, 		
		sgmii_txp 				            => gbe_tx_p,					
		sgmii_txn 				            => gbe_tx_n,					
		sgmii_rxp 				            => gbe_rx_p,					
		sgmii_rxn 				            => gbe_rx_n,					
		--            
		locked 					         	=> eth_locked	(phy),			
		clk125_o									=> mac_clk  	(phy),
		rst 										=> rst_eth,
		--            
		rx_data 									=> mac_rx_data	(phy),
		rx_valid 								=> mac_rx_valid(phy),
		rx_last 									=> mac_rx_last	(phy),
		rx_error 								=> mac_rx_error(phy),
		tx_data 									=> mac_tx_data	(phy),
		tx_valid 								=> mac_tx_valid(phy),
		tx_last 									=> mac_tx_last	(phy),
		tx_error 								=> mac_tx_error(phy),
		tx_ready 								=> mac_tx_ready(phy)
	);
	--================================--




	--================================--
	phy_ipb_ctrl: entity work.ipbus_ctrl 
	--================================--
	port map
	(
		mac_clk 									=> mac_clk		(phy),
		rst_macclk 								=> rst_macclk	(phy), 
		ipb_clk 									=> ipb_clk,
		rst_ipb 									=> ipb_rst,
		--
		mac_rx_data 							=> mac_rx_data	(phy),
		mac_rx_valid 							=> mac_rx_valid(phy),
		mac_rx_last 							=> mac_rx_last	(phy),
		mac_rx_error 							=> mac_rx_error(phy),
		mac_tx_data 							=> mac_tx_data	(phy),
		mac_tx_valid 							=> mac_tx_valid(phy),
		mac_tx_last 							=> mac_tx_last	(phy),
		mac_tx_error 							=> mac_tx_error(phy),
		mac_tx_ready 							=> mac_tx_ready(phy),
		--
		mac_addr 								=> mac_addr, --x"080030" & mac_addr(23 downto 0),
		ip_addr 									=> ip_addr,
		--
		ipb_req									=> ipb_req				(phy),
		ipb_grant								=> ipb_grant			(phy),
		ipb_out 									=> ipb_from_masters	(phy),
		ipb_in 									=> ipb_to_masters		(phy)
	);
	--================================--

end generate;

phy_dis: if sys_eth_phy_enable = false generate
	ipb_req         (phy) <= '0';
	ipb_from_masters(phy).ipb_strobe <= '0';
end generate;

--===================================--
-- fmc2 ipbus not used
--===================================--
	ipb_req         (fmc2) <= '0';
	ipb_from_masters(fmc2).ipb_strobe <= '0';
--===================================--



--===================================--
ipb_arb: entity work.ipbus_master_arb				
--===================================--
	port map
	(
	clk					=> ipb_clk,			
	rst					=> ipb_rst,
  	--
	ipb_m_out			=> ipb_from_masters,
  	ipb_m_in				=> ipb_to_masters,
	ipb_req				=> ipb_req,
	ipb_grant			=> ipb_grant,
  	--
	ipb_out				=> ipb_from_eth,	
	ipb_in				=> ipb_to_eth	
	);
--===================================--


--===================================--
-- bypass arbitration
--===================================--
--ipb_from_eth   <= ipb_from_masters(amc_p0);
--ipb_to_masters(amc_p0) <= ipb_to_eth;
--===================================--


sys_pcie_en: if sys_pcie_enable = true generate 

   --================================--						
   sys_pcie: entity work.pcie_glib_wrapper             	
   --================================--
   port map (													
      reset_i 					            => reset,																
      ---------------------------------            											
      pcie_mgt_refclk_i		            => sys_pcie_mgt_refclk_i,    	                         
      ---------------------------------                                           
      pcie_tx_p_o 			            => sys_pcie_amc_tx_p,	
      pcie_tx_n_o 			            => sys_pcie_amc_tx_n,	
      pcie_rx_p_i				            => sys_pcie_amc_rx_p,	
      pcie_rx_n_i				            => sys_pcie_amc_rx_n,	
      ---------------------------------                                       				
      ipbus_clk_i				            => ipb_clk,					
      ipbus_i 					            => ipb_to_pcie,      	
      ipbus_o 					            => ipb_from_pcie,	   	
      ---------------------------------                                       		
      pcie_clk_o				            => clk_from_sys_pcie,	     	
      pcie_slv_i				            => user_sys_pcie_slv_i,	
      pcie_slv_o				            => user_sys_pcie_slv_o,
      pcie_dma_i				            => user_sys_pcie_dma_i,
      pcie_dma_o  			            => user_sys_pcie_dma_o,
      pcie_interrupt_i		            => user_sys_pcie_int_i,
      pcie_interrupt_o		            => user_sys_pcie_int_o,
      ---------------------------------            									         
      pcie_cfg_o 				            => user_sys_pcie_cfg_o, 		
      retraining_cnt_o		            => open,      				
      link_rdy_o				            => open,						
      ipbus_busy_o			            => busy_from_sys_pcie,		
      test_mode_i				            => (others => '0')
   );   
   --================================--                  
   
   user_sys_pcie_dma_clk_o             <= clk_from_sys_pcie;
   
   --================================--                  
   pcie_eth_arb: entity work.pcie_or_eth_to_ipbus_arb 
   --================================--                  
   port map                                           
   (                                                  
      reset_i 					            => reset,					
      ---------------------------------                                          
      pcie_clk_i 				            => clk_from_sys_pcie,       
      pcie_busy_i 			            => busy_from_sys_pcie,      
      pcie_from_ipbus_o 	            => ipb_to_pcie,			
      pcie_to_ipbus_i 		            => ipb_from_pcie,       
      ---------------------------------                                          
      eth_busy_i 				            => busy_from_ipb_arb,   
      eth_from_ipbus_o 		            => ipb_to_eth,				
      eth_to_ipbus_i 		            => ipb_from_eth,        
      ---------------------------------                                          
      arb_from_fabric_i 	            => ipb_from_fabric,     
      arb_to_fabric_o 		            => ipb_to_fabric   		
   );                                            		
   --================================--  						   

end generate;

sys_pcie_dis: if sys_pcie_enable = false generate  
  
   user_sys_pcie_dma_clk_o             <= '0';    
   ------------------------------------            
   ipb_to_eth                          <= ipb_from_fabric;  
   ipb_to_fabric                       <= ipb_from_eth; 	 

end generate;


--===================================--
ipb_fabric: entity work.ipbus_sys_fabric
--===================================--
generic map (nslv => number_of_slaves) 
port map
(
	ipb_clk					               => ipb_clk,
	rst						               => ipb_rst,
	------------------------------------               
	ipb_in					               => ipb_to_fabric,
	ipb_out					               => ipb_from_fabric,
	------------------------------------               
	ipb_to_slaves			               => ipb_to_slaves,
	ipb_from_slaves		               => ipb_from_slaves
);
--================================--


--===================================--
ipb_usr_fabric: entity work.ipbus_user_fabric
--===================================--
generic map (nslv => number_of_ipb_slaves)
port map
(
	ipb_clk					               => ipb_clk,
	rst						               => ipb_rst,
	------------------------------------               
	ipb_in					               => ipb_to_slaves(user_ipb),
	ipb_out					               => ipb_from_slaves(user_ipb),
	------------------------------------               
	ipb_to_slaves			               => user_ipb_mosi_o,
	ipb_from_slaves		               => user_ipb_miso_i
);	
--===================================--


--===================================--
wb_bridge: entity work.ipbus_to_wb_bridge
--===================================--
port map
(
	ipb_clk					               => ipb_clk,
	rst						               => ipb_rst,
	ipb_in					               => ipb_to_slaves(user_wb),
	ipb_out					               => ipb_from_slaves(user_wb),
	------------------------------------
	wb_to_slaves			               => user_wb_mosi_o,
	wb_from_slaves			               => user_wb_miso_i
);
--===================================--


--===================================--
--###################################--
--###################################--
--##### bus slaves ##################--
--###################################--
--###################################--
--===================================--


--===================================--
ipb_sys_regs: entity work.system_regs
--===================================--
port map
(
	clk						               => ipb_clk,
	reset						               => ipb_rst,
	------------------------------------
	ipbus_in					               => ipb_to_slaves(sys_regs),
	ipbus_out				               => ipb_from_slaves(sys_regs),
	------------------------------------
	regs_o					               => regs_from_ipbus,
	regs_i					               => regs_to_ipbus				
);
--===================================--


--===================================--
sram1_if: entity work.glib_sram_interface_wrapper
--===================================--
generic map
(		
	-- built int self test(bist):
	bist_maxaddresswrite	               => 2*(2**20)-1,                 -- = 2m memory locations
	bist_initialdelay		               => 200
)					               
port map             
(			               
	reset_i 					               => reset,	
	user_select_i 			               => reg_ctrl_sram(0),            -- 0: ipbus, 1: user
	------------------------------------               
	ipbus_clk_i 			               => ipb_clk_sram1,			
	ipbus_i 					               => ipb_to_slaves(sram1),
	ipbus_o					               => ipb_from_slaves(sram1),	
	ipbus_bist_i 			               => (reg_ctrl_sram(1), '0'),
	------------------------------------               	
	user_control_i			               => user_sram_control_i(sram1),	
	user_addr_i 			               => user_sram_addr_i(sram1),
	user_data_i 			               => user_sram_wdata_i(sram1),
	user_data_o 			               => user_sram_rdata_o(sram1),
	user_bist_i 			               => ('0', '0'),	                 -- bist start from user	
	------------------------------------	
	bist_seed_i 				            => seed_constants(1),
	bist_test_o.starterrinj             => open,
	bist_test_o.testdone 	            => reg_status_sram(0),
	bist_test_o.testresult 	            => reg_status_sram(1),
	bist_test_o.errcounter( 7 downto 0)	=> reg_status_sram(11 downto 4),
	bist_test_o.errcounter(20 downto 8)	=> open,		
	------------------------------------	
	sram_i					               => sram_r(sram1), 
	sram_o 					               => sram_w(sram1)							
);
--===================================--	


--===================================--
sram2_if: entity work.glib_sram_interface_wrapper
--===================================--
generic map
(		
	-- built int self test(bist):
	bist_maxaddresswrite	=> 2*(2**20)-1,                                -- = 2m memory locations
	bist_initialdelay		=> 200
)					
port map
(			
	reset_i 					               => reset,	
	user_select_i 			               => reg_ctrl_sram(16),           -- 0: ipbus, 1: user
	------------------------------------
	ipbus_clk_i 			               => ipb_clk_sram2,			
	ipbus_i 					               => ipb_to_slaves(sram2),
	ipbus_o					               => ipb_from_slaves(sram2),	
	ipbus_bist_i 			               => (reg_ctrl_sram(17), '0'),
	------------------------------------
	user_control_i			               => user_sram_control_i(sram2),			
	user_addr_i 			               => user_sram_addr_i(sram2),
	user_data_i 			               => user_sram_wdata_i(sram2),
	user_data_o 			               => user_sram_rdata_o(sram2),	
	user_bist_i 			               => ('0', '0'),	                 -- bist start from user	
	------------------------------------	
	bist_seed_i 				            => seed_constants(2),
	bist_test_o.starterrinj             => open,
	bist_test_o.testdone 	            => reg_status_sram(16),
	bist_test_o.testresult 	            => reg_status_sram(17),
	bist_test_o.errcounter( 7 downto 0)	=> reg_status_sram(27 downto 20),
	bist_test_o.errcounter(20 downto 8)	=> open ,		
	------------------------------------	
	sram_i					               => sram_r(sram2), 
	sram_o 					               => sram_w(sram2)							
);
--===================================--	


--===================================--
flash_if: entity work.flash_interface_wrapper 
--===================================--
port map
(
	reset_i 					               => reset,
	------------------------------------
	ipbus_clk_i 			               => ipb_clk,
	ipbus_i 					               => ipb_to_slaves(flash),
	ipbus_o 					               => ipb_from_slaves(flash),
	------------------------------------
	flash_i 					               => flash_r,
	flash_o 					               => flash_w
);
--===================================--


--===================================--
buffers: entity work.sram_flash_buffers
--===================================--
port map 
(
	reset_i 					               => reset,
	flash_select_i			               => reg_ctrl_sram(20),	        -- 0: sram2, 1: flash
	------------------------------------               
	sram1_i 					               => sram_w(sram1),
	sram1_o 					               => sram_r(sram1),
	------------------------------------               
	sram2_i 					               => sram_w(sram2),
	sram2_o 					               => sram_r(sram2),
	------------------------------------               
	flash_i 					               => flash_w,
	flash_o 					               => flash_r,	
	------------------------------------               
	sram1_addr_o 			               => sram1_addr,
	sram1_data_io			               => sram1_data,
	sram2_addr_o 			               => sram2_addr,
	sram2_data_io			               => sram2_data,	
	------------------------------------
   fpga_a(22)                          => fpga_a22,
   fpga_a(21)                          => fpga_a21,
   fpga_rs(0)                          => fpga_rs0,
   fpga_rs(1)                          => fpga_rs1,
   ------------------------------------
   sram_clk_o 				               => sram_clk,
	sram_ce1_b_o			               => sram_ce1_l,
	sram_cen_b_o 			               => sram_cen_l,
	sram_oe_b_o 			               => sram_oe_l,
	sram_we_b_o 			               => sram_we_l,
	sram_mode_o 			               => sram_mode,
	sram_adv_ld_o 			               => sram_adv_ld_l,	
	sram2_ce2_o 			               => sram2_ce2	
);	
--===================================--


--===================================--
icap_if: entity work.icap_interface_wrapper 
--===================================--
port map
(
	reset_i					               => reset,				
	conf_trigg_i			               => reg_ctrl_2(4),                      			 				
	fsm_conf_page_i		               => reg_ctrl_2(1 downto 0),                      			 				
	------------------------------------               
	ipbus_clk_i				               => ipb_clk,			
	ipbus_inv_clk_i		               => ipb_inv_clk,
	ipbus_i					               => ipb_to_slaves(icap),				
	ipbus_o	   			               => ipb_from_slaves(icap)
);
--===================================--


--===================================--
mst: if (i2c_master_enable = true) generate
--===================================--
	i2c_m: entity work.i2c_master_core
	--===================================--
	port map
	(
		clk				=> ipb_clk		 								,
		reset				=> reset 										,
		settings			=> reg_i2c_settings(12 downto 0)			,
		command			=> reg_i2c_command							,
		reply				=> reg_i2c_reply								,
		------------
		scl_i(0)			=> scl_i_master	, scl_i(1)		=> 'Z',					
		scl_o(0)			=> scl_o_master	, scl_o(1)		=> open,
		sda_i(0)			=> sda_i_master	, sda_i(1)		=> 'Z',
		sda_o(0)			=> sda_o_master	, sda_o(1)		=> open
	); 			
	end generate;

	no_mst: if (i2c_master_enable = false) generate
		scl_o_master <= '1';
		sda_o_master <= '1';			
end generate;
--===================================--



--===================================--
eep: if (auto_eeprom_read_enable = true) generate
--===================================--
	i2c_eep: entity work.i2c_eeprom_read
	--===================================--
	generic map ( prescaler => 62) -- scl = clk/presc/5=100khz
	port map
	(
		clk				=> ipb_clk		 	,
		reset				=> reset				,
		slv_addr       => "1010110"		,
		base_reg_addr  => x"00"				,
		regs_o			=> regs_eeprom		,
		scl_wr			=> scl_o_eeprom	,
		sda_wr			=> sda_o_eeprom	,
		sda_rd			=> sda_i_eeprom	
	); 	
end generate;

no_eep: if (auto_eeprom_read_enable = false) generate
	scl_o_eeprom <= '1';
	sda_o_eeprom <= '1';			
end generate;
--===================================--



--===================================--
i2c_s: entity work. i2c_slave_core
--===================================--
port map
(
	clk				=> ipb_clk			 	,
	reset				=> reset 				,
	slv_addr			=> "1111010"			,
	regs_i(0)		=> x"7A"					,
	regs_i(1)		=> user_mac_addr_i(47 downto 40)	,			
	regs_i(2)		=> user_mac_addr_i(39 downto 32)	,			
	regs_i(3)		=> user_mac_addr_i(31 downto 24)	,				
	regs_i(4)		=> user_mac_addr_i(23 downto 16)	,			
	regs_i(5)		=> user_mac_addr_i(15 downto  8)	,			
	regs_i(6)		=> user_mac_addr_i( 7 downto  0)	,			
	regs_i(7)		=> user_ip_addr_i (31 downto 24)	,			
	regs_i(8)		=> user_ip_addr_i (23 downto 16)	,			
	regs_i(9)		=> user_ip_addr_i (15 downto  8)	,			
	regs_i(10)		=> user_ip_addr_i ( 7 downto  0)	,			
	regs_i(11)		=> x"00"					,
	regs_i(12)		=> x"00"					,
	regs_i(13)		=> x"00"					,
	regs_i(14)		=> x"00"					,
	regs_i(15)		=> x"00"					,
	regs_o			=> regs_slave			,
	scl_rd			=> scl_i_slave			,
	sda_rd			=> sda_i_slave			,
	sda_wr			=> sda_o_slave	
); 			
--===================================--



--===================================--
i2c_ro: entity work. i2c_slave_core_ro
--===================================--
port map
(
	clk				=> ipb_clk			 			,
	reset				=> reset							,
	slv_addr			=> "1111110"					,
	regs_i(0)		=> x"7e"							,
	regs_i(1)		=> mac_addr(47 downto 40)	,			
	regs_i(2)		=> mac_addr(39 downto 32)	,			
	regs_i(3)		=> mac_addr(31 downto 24)	,				
	regs_i(4)		=> mac_addr(23 downto 16)	,			
	regs_i(5)		=> mac_addr(15 downto  8)	,			
	regs_i(6)		=> mac_addr( 7 downto  0)	,			
	regs_i(7)		=> ip_addr (31 downto 24)	,			
	regs_i(8)		=> ip_addr (23 downto 16)	,			
	regs_i(9)		=> ip_addr (15 downto  8)	,			
	regs_i(10)		=> ip_addr ( 7 downto  0)	,			
	regs_i(11)		=> x"00"							,
	regs_i(12)		=> x"00"							,
	regs_i(13)		=> "000000"	& ip_from_eep & mac_from_eep , 
	regs_i(14)		=> "000000"	& ip_from_slv & mac_from_slv ,
	regs_i(15)		=> "000000"	& ip_from_usr & mac_from_usr ,
	scl_rd			=> scl_i_slave_ro				,
	sda_rd			=> sda_i_slave_ro				,
	sda_wr			=> sda_o_slave_ro	
); 			
--===================================--



--===================================--
-- i2c buffers
--===================================--
scl_i_master	<= '0' when fpga_scl     = '0' 	else
						'0' when scl_o_eeprom = '0'	else
						'1';

scl_i_eeprom	<= '0' when fpga_scl     = '0' 	else
						'0' when scl_o_master = '0'	else
						'1';

scl_i_slave		<= '0' when fpga_scl     	= '0' else
						'0' when scl_o_master 	= '0'	else
						'0' when scl_o_eeprom 	= '0'	else
						'1';
				
scl_i_slave_ro	<= '0' when fpga_scl     	= '0' else
						'0' when scl_o_master 	= '0'	else
						'0' when scl_o_eeprom 	= '0'	else
						'1';

sda_i_master	<= '0' when fpga_sda     	= '0' else
						'0' when sda_o_eeprom 	= '0'	else
						'0' when sda_o_slave  	= '0'	else
						'0' when sda_o_slave_ro = '0'	else
						'1';

sda_i_eeprom	<= '0' when fpga_sda     	= '0' else
						'0' when sda_o_master 	= '0'	else
						'0' when sda_o_slave  	= '0'	else
						'0' when sda_o_slave_ro = '0'	else
						'1';

sda_i_slave		<= '0' when fpga_sda     	= '0' else
						'0' when sda_o_master 	= '0'	else
						'0' when sda_o_eeprom 	= '0'	else
						'0' when sda_o_slave_ro = '0'	else
						'1';

sda_i_slave_ro	<= '0' when fpga_sda     	= '0' else
						'0' when sda_o_master 	= '0'	else
						'0' when sda_o_eeprom 	= '0'	else
						'0' when sda_o_slave  	= '0'	else
						'1';

--

fpga_scl			<= '0' when scl_o_master 	= '0'	else				
						'0' when scl_o_eeprom 	= '0'	else				
						'Z';
				
fpga_sda			<= '0' when sda_o_master 	= '0'	else				
						'0' when sda_o_eeprom 	= '0'	else				
						'0' when sda_o_slave  	= '0'	else				
						'0' when sda_o_slave_ro = '0'	else				
						'Z';
--===================================--

--===================================--
spi: entity work.spi_master
--===================================--
port map
(
	reset_i					               => reset,  
	clk_i						               => ipb_clk,
	------------------------------------
	data_i					               => reg_spi_txdata,
	enable_i					               => reg_spi_command(31),	
	ssdelay_i				               => reg_spi_command(27 downto 18),
	hold_i					               => reg_spi_command(17 downto 15),
	msbfirst_i				               => reg_spi_command(14),
	cpha_i					               => reg_spi_command(13),
	cpol_i					               => reg_spi_command(12),
	prescaler_i				               => reg_spi_command(11 downto 0),
	data_o					               => reg_spi_rxdata,
	------------------------------------
	ss_b_o					               => cdce_spi_le,
	sck_o						               => cdce_spi_clk,
	mosi_o 					               => cdce_spi_mosi,
	miso_i 					               => cdce_spi_miso
);
--===================================--


--===================================--
cdce_synch: entity work.cdce_synchronizer
--===================================--
generic map
(	
	pwrdown_delay 			               => 1000,
	sync_delay 				               => 1000000	
)
port map
(	
	reset_i					               => reset,
	------------------------------------               
	ipbus_ctrl_i			               => (not reg_ctrl(7)), 	-- reg[5][7]: 0 -> ipbus, 1-> user
	ipbus_sel_i				               => reg_ctrl(5),
	ipbus_pwrdown_i		               => reg_ctrl(4),
	ipbus_sync_i			               => reg_ctrl(6), 	      -- rising edge needed
	------------------------------------               										            						
	user_sel_i				               => user_cdce_sel_i,                 
	user_pwrdown_i			               => '1',                 
	user_sync_i				               => user_cdce_sync_i,
	------------------------------------               
	pri_clk_i				               => xpoint1_clk1,
	sec_clk_i				               => sec_clk_i,
	pwrdown_o				               => cdce_pwr_down,
	sync_o					               => cdce_sync,
	ref_sel_o				               => cdce_ref_sel,	
	------------------------------------               
	sync_cmd_o				               => cdce_sync_cmd,	
	sync_clk_o				               => cdce_sync_clk,	
	sync_busy_o				               => cdce_sync_busy,	
	sync_done_o				               => cdce_sync_done	
);
--===================================--


--===================================--
gbt_phase_monitoring: entity work.cdce_phase_mon_v2_wrapper
--===================================--
port map
(	
   reset_i              		         => reset or gbt_phase_mon_reset,       
   ------------------------------------ 
   ipbus_clk_i             		      => ipb_clk,       
   ttclk_i	               		      => xpoint1_clk1,  
   unrelated_clk_i       		         => clk125_2,    
   ------------------------------------  
   sfp_ttclk_x6_cdce_i     		      => cdce_out0_gtxe1_i,
   sfp_threshold_upper_i   		      => sfp_phase_mon_threshold_upper,
   sfp_threshold_lower_i   		      => sfp_phase_mon_threshold_lower,
   sfp_monitoring_stats_o  		      => sfp_phase_mon_stats,
   sfp_done_o             		         => sfp_phase_mon_done,
   sfp_phase_ok_o         		         => sfp_phase_mon_phase_ok,
   ------------------------------------    
   fmc1_ttclk_x6_cdce_i     		      => cdce_out3_gtxe1_i,
   fmc1_threshold_upper_i   		      => fmc1_phase_mon_threshold_upper,
   fmc1_threshold_lower_i   		      => fmc1_phase_mon_threshold_lower,
   fmc1_monitoring_stats_o  		      => fmc1_phase_mon_stats,
   fmc1_done_o           		         => fmc1_phase_mon_done,  
   fmc1_phase_ok_o       		         => fmc1_phase_mon_phase_ok 
);


--===================================--
-- io/reg mapping
--===================================--

	user_reset_o				            <= reset;
   user_clk125_2_o                     <= clk125_2_mgt;
	user_clk125_2_bufg_o                <= clk125_2;   
	user_ipb_clk_o			               <= ipb_clk;
   user_mac_serdes_locked_o            <= eth_locked;
	user_cdce_sync_done_o					<= cdce_sync_done;
	------------------------------------

                                          reg_ctrl          <= regs_from_ipbus(4);
                                          reg_ctrl_2			<= regs_from_ipbus(5);
	regs_to_ipbus(6)                    <=	reg_status;
	regs_to_ipbus(7)                    <=	reg_status_2;
                                          reg_ctrl_sram		<= regs_from_ipbus(8);
	regs_to_ipbus(9)                    <=	reg_status_sram;
                                          reg_spi_txdata		<= regs_from_ipbus(10);
                                          reg_spi_command	<= regs_from_ipbus(11);
	regs_to_ipbus(12)                   <=	reg_spi_rxdata;
                                          reg_i2c_settings	<= regs_from_ipbus(13);
                                          reg_i2c_command	<= regs_from_ipbus(14);
	regs_to_ipbus(15)                   <=	reg_i2c_reply;	
	   
   -- gbt_phase_moninoring
   
   
   --                                  (default: xxxx|xxxx|xxxx|xxxx|0110|1111|0100|1111)
                                       sfp_phase_mon_threshold_lower <= regs_from_ipbus(16)( 7 downto 0);  
                                       sfp_phase_mon_threshold_upper <= regs_from_ipbus(16)(15 downto 8); 
   regs_to_ipbus(17)(15 downto  0)  <= sfp_phase_mon_stats; 
   regs_to_ipbus(17)(31 downto 16)  <= (others => '0');  
   
   --                                  (default: xxxx|xxxx|xxxx|xxxx|0000|0000|0000|0000)
                                       fmc1_phase_mon_threshold_lower <= regs_from_ipbus(18)( 7 downto 0);  
                                       fmc1_phase_mon_threshold_upper <= regs_from_ipbus(18)(15 downto 8); 
   regs_to_ipbus(19)(15 downto  0)  <= fmc1_phase_mon_stats; 
   regs_to_ipbus(19)(31 downto 16)  <= (others => '0');  


   regs_to_ipbus(28)  				<= "0000" 	& "00" & ip_from_eep & mac_from_eep
																& "00" & ip_from_slv & mac_from_slv
																& "00" & ip_from_usr & mac_from_usr
																&	mac_addr(47 downto 32);  
	regs_to_ipbus(29)  					<= 				mac_addr(31 downto  0);
	regs_to_ipbus(30)  					<= ip_addr;
	regs_to_ipbus(31)  					<= (others => '0');  
      
	-- reg_ctrl                         (default: xxxx|x0xx|1010|1010|xx11|xx0x|0111|x001)

	ics874003_fsel				            <= reg_ctrl( 0); 		-- default: 1 (fclka jitter cleaner output frequency 125mhz)
	ics874003_mr				            <= reg_ctrl( 1); 		-- default: 0 (fclka jitter cleaner normal mode)
	ics874003_oe				            <= reg_ctrl( 2); 		-- default: 0 (fclka jitter cleaner output disabled)
--									            	reg_ctrl( 3); 		--          x
--	(cdce)ipbus_pwrdown_i			      => reg_ctrl( 4),		-- default: 1 (powered up)
--	(cdce)ipbus_sel_i					      => reg_ctrl( 5), 		-- default: 1 (select primary clock)
--	(cdce)ipbus_sync_i				      => reg_ctrl( 6),		-- default: 1 (disable sync mode), rising edge needed
-- (cdce)ipbus_ctrl_i				      => reg_ctrl( 7))		-- default: 0 (ipbus controlled)
--	                                    <= reg_ctrl( 8); 		--          x
	tclkb_dr_en					            <= reg_ctrl( 9); 		-- default: 0 (disable tclkb -> mlvds)
--									            	reg_ctrl(10); 		--          x 
--									            	reg_ctrl(11); 		--          x 
	xpoint2_s10					            <= reg_ctrl(12);		-- default: 1 (out_1 driven by in_4)
	xpoint2_s11					            <= reg_ctrl(13);		-- default: 1 (out_1 driven by in_4)
--									            	reg_ctrl(14); 		--          x 
--									            	reg_ctrl(15); 		--          x 
	xpoint1_s10					            <= reg_ctrl(16); 	   -- default: 0 (xpoint_4x4 out_1 driven by in_2)
	xpoint1_s11					            <= reg_ctrl(17); 	   -- default: 1  		 
	xpoint1_s20					            <= reg_ctrl(18); 	   -- default: 0 (xpoint_4x4 out_2 driven by in_2)
	xpoint1_s21					            <= reg_ctrl(19); 	   -- default: 1  	 
	xpoint1_s30					            <= reg_ctrl(20); 	   -- default: 0 (xpoint_4x4 out_3 driven by in_2)
	xpoint1_s31					            <= reg_ctrl(21); 	   -- default: 1  	
	xpoint1_s40					            <= reg_ctrl(22); 	   -- default: 0 (xpoint_4x4 out_4 driven by in_2)
	xpoint1_s41					            <= reg_ctrl(23);	   -- default: 1
--									            	reg_ctrl(24); 		--          x 
--									            	reg_ctrl(25); 		--          x 
   gbt_phase_mon_reset                 <= reg_ctrl(26);	   -- default: 0 
--									            	reg_ctrl(27); 		--          x  
   v6_cpld(5)								   <=	reg_ctrl(28);	   -- default: 1 (fpga_program_b control)  
--									            	reg_ctrl(29); 		--          x  
--									            	reg_ctrl(30); 		--          x  
--									            	reg_ctrl(31); 		--          x  
   
	-- reg_status
	
	reg_status( 0)				            <= sfp_mod_abs(1);
	reg_status( 1)				            <= sfp_rxlos  (1);
	reg_status( 2)				            <= sfp_txfault(1);
	reg_status( 3)				            <= '0';
	reg_status( 4)				            <= sfp_mod_abs(2);
	reg_status( 5)				            <= sfp_rxlos  (2);
	reg_status( 6)				            <= sfp_txfault(2);
	reg_status( 7)				            <= '0';
	reg_status( 8)				            <= sfp_mod_abs(3);
	reg_status( 9)				            <= sfp_rxlos  (3);
	reg_status(10)				            <= sfp_txfault(3);
	reg_status(11)				            <= '0';
	reg_status(12)				            <= sfp_mod_abs(4);
	reg_status(13)				            <= sfp_rxlos  (4);
	reg_status(14)				            <= sfp_txfault(4);
	reg_status(15)				            <= '0';
	reg_status(16) 			            <= not gbe_int_n;
	reg_status(17)				            <= not fmc1_present_l;			
	reg_status(18) 			            <= not fmc2_present_l;				
	reg_status(19) 			            <= not fpga_reset_b;				
   reg_status(20)                      <=	v6_cpld(0);	
   reg_status(21)                      <=	v6_cpld(1);	
   reg_status(22)                      <=	v6_cpld(2);	
   reg_status(23)                      <=	v6_cpld(3);	
   reg_status(24)                      <=	v6_cpld(4);	
   reg_status(25)                      <=	'0';--v6_cpld(5);
	reg_status(26) 			            <= '0';	
	reg_status(27)				            <= cdce_pll_lock;
	reg_status(28)				            <= sfp_phase_mon_done;
	reg_status(29)				            <= sfp_phase_mon_phase_ok;
	reg_status(30)				            <= fmc1_phase_mon_done;
	reg_status(31)				            <= fmc1_phase_mon_phase_ok;
   
	dsbuf_secref: obufds generic map (iostandard => "lvds_25") port map (o => cdce_sec_ref_p, ob => cdce_sec_ref_n, i => sec_clk_i);
	
	
	
	
	
--===================================--

end mixed_arch;