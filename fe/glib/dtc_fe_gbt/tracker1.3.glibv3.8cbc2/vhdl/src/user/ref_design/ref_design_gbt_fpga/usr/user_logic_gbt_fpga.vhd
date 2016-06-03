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
  
   --=====================================================================================--       
   
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
   
   signal latencyOptGbtLink_from_gbtRefDesign   : std_logic;
   signal rxHeaderLocked_from_gbtRefDesign      : std_logic;
   signal rxBitSlipNbr_from_gbtRefDesign        : std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
   signal rxWordClkAligned_from_gbtRefDesign    : std_logic; 
   signal mgtReady_from_gbtRefDesign            : std_logic; 
   signal rxGbtReady_from_gbtRefDesign          : std_logic;    
   signal rxFrameClkAligned_from_gbtRefDesign   : std_logic; 
   signal rxIsDataFlag_from_gbtRefDesign        : std_logic;        
   signal rxGbtReadyLostFlag_from_gbtRefDesign  : std_logic; 
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
   
   --=====================================================================================--   


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
     
   
   --==================================== User Logic =====================================--
   
   --===============--
   -- General reset -- 
   --===============--
   
   reset_from_or_gate                           <= RESET_I or reset_from_user;   
   
   --===============--
   -- Clock buffers -- 
   --===============--   

   -- Fabric clock & TX_FRAMECLK (40MHz):
   --------------------------------------       
   
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
      generic map (
         FABRIC_CLK_FREQ                        => 40e6)      
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                        => reset_from_or_gate,                   
         -- Clocks scheme:                      
         FABRIC_CLK_I                           => xpoint1_clk3,
         MGT_REFCLKS_I                          => (tx => cdce_out0, rx => cdce_out0),              
         TX_OUTCLK_O                            => open,                                 -- Comment: TX_WORDCLK is generated internally  
         TX_WORDCLK_I                           => '0',                                  --          by GBT Link  
         TX_FRAMECLK_I                          => xpoint1_clk3,                      
         -- Serial lanes:                       
         MGT_TX_P                               => SFP_TX_P(1),                
         MGT_TX_N                               => SFP_TX_N(1),                
         MGT_RX_P                               => SFP_RX_P(1),                 
         MGT_RX_N                               => SFP_RX_N(1),
         -- GBT Link control:                   
         LOOPBACK_I                             => loopback_from_user,  
         TX_ENCODING_SEL_I                      => encodingSel_from_user,
         RX_ENCODING_SEL_I                      => encodingSel_from_user,
         TX_ISDATA_SEL_I                        => txIsDataSel_from_user,                 
         -- GBT Link status:                    
         LATENCY_OPT_GBTLINK_O                  => latencyOptGbtLink_from_gbtRefDesign,             
         MGT_READY_O                            => mgtReady_from_gbtRefDesign,             
         RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_gbtRefDesign,
         RX_BITSLIP_NUMBER_O                    => rxBitSlipNbr_from_gbtRefDesign,            
         RX_WORDCLK_ALIGNED_O                   => rxWordClkAligned_from_gbtRefDesign,           
         RX_FRAMECLK_ALIGNED_O                  => rxFrameClkAligned_from_gbtRefDesign,            
         RX_GBT_READY_O                         => rxGbtReady_from_gbtRefDesign,
         RX_ISDATA_FLAG_O                       => rxIsDataFlag_from_gbtRefDesign,            
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
         RESET_RX_GBT_READY_LOST_FLAG_I         => resetRxGbtReadyLostFlag_from_user,     
         ---------------------------------------                    
         RX_GBT_READY_LOST_FLAG_O               => rxGbtReadyLostFlag_from_gbtRefDesign,       
         COMMONDATA_ERROR_SEEN_FLAG_O           => commDataErrSeen_from_gbtRefDesign,      
         WIDEBUSDATA_ERROR_SEEN_FLAG_O          => widebusDataErrSeen_from_gbtRefDesign,      
         -- Latency measurement:                
         TX_FRAMECLK_O                          => txFrameClk_from_gbtRefDesign,   -- Comment: This clock is "xpoint1_clk3"          
         RX_FRAMECLK_O                          => rxFrameClk_from_gbtRefDesign,         
         TX_WORDCLK_O                           => txWordClk_from_gbtRefDesign,          
         RX_WORDCLK_O                           => rxWordClk_from_gbtRefDesign,          
         ---------------------------------------                
         TX_MATCHFLAG_O                         => txMatchFlag_from_gbtRefDesign,          
         RX_MATCHFLAG_O                         => rxMatchFlag_from_gbtRefDesign          
      );                                        
   
   --=======================--   
   -- Test control & status --   
   --=======================--      
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 
         
   cdceLockedReg: process(reset_from_or_gate, xpoint1_clk3)
   begin
      if reset_from_or_gate = '1' then
         userCdceLocked_r                       <= '0';
      elsif rising_edge(xpoint1_clk3) then
         userCdceLocked_r                       <= USER_CDCE_LOCKED_I;
      end if;
   end process;   
   
   -- Signals mapping:
   -------------------
   
   -- Control:
   reset_from_user                              <= sync_from_vio( 0);          
   clkMuxSel_from_user                          <= sync_from_vio( 1);
   testPatterSel_from_user                      <= sync_from_vio( 3 downto 2); 
   loopback_from_user                           <= sync_from_vio( 6 downto 4);
   resetDataErrorSeenFlag_from_user             <= sync_from_vio( 7);
   resetRxGbtReadyLostFlag_from_user            <= sync_from_vio( 8);
   txIsDataSel_from_user                        <= sync_from_vio( 9);
   encodingSel_from_user                        <= sync_from_vio(11 downto 10);
   
   -- Status:
   async_to_vio( 0)                             <= rxIsDataFlag_from_gbtRefDesign;
   async_to_vio( 1)                             <= userCdceLocked_r;
   async_to_vio( 2)                             <= latencyOptGbtLink_from_gbtRefDesign;
   async_to_vio( 3)                             <= mgtReady_from_gbtRefDesign;
   async_to_vio( 4)                             <= rxWordClkAligned_from_gbtRefDesign;    
   async_to_vio( 9 downto 5)                    <= rxBitSlipNbr_from_gbtRefDesign;        
   async_to_vio(10)                             <= rxFrameClkAligned_from_gbtRefDesign;   
   async_to_vio(11)                             <= rxGbtReady_from_gbtRefDesign;          
   async_to_vio(12)                             <= commDataErrSeen_from_gbtRefDesign;   
   async_to_vio(13)                             <= rxGbtReadyLostFlag_from_gbtRefDesign;  
   async_to_vio(14)                             <= widebusDataErrSeen_from_gbtRefDesign;
   
   -- Chipscope:
   -------------   
   
   -- Comment: * Chipscope is used to control and check the status of the reference design as well 
   --            as for data analysis ("txCommonData_from_gbtRefDesign" and "rxCommonData_from_gbtRefDesign").
   --
   --          * Note!! The TX data and RX data do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving the RX data from another board with a different reference clock, the TX
   --            frame/word clock domains are asynchronous with respect to to the RX frame/word clock domains.        
   --
   --          * After FPGA configuration using Chipscope, open the project "glib_gbt_ref_design.cpj" 
   --            that can be found in:
   --            "..\gbt_fpga\tags\ref_designs\ref_designs_x_x_x\vendor_specific\xilinx\xlx_6_series\glib\chipscope\".  
   
   icon: entity work.chipscope_icon
      port map (
         CONTROL0                               => vio_control,
         CONTROL1                               => txIla_control,
         CONTROL2                               => rxIla_control
      );     
         
   vio: entity work.chipscope_vio      
      port map (     
         CONTROL                                => vio_control,
         CLK                                    => xpoint1_clk3,
         ASYNC_IN                               => async_to_vio,
         SYNC_OUT                               => sync_from_vio
      );  
         
   txIla: entity work.chipscope_ila    
      port map (     
         CONTROL                                => txIla_control,
         CLK                                    => txFrameClk_from_gbtRefDesign,
         TRIG0                                  => txCommonData_from_gbtRefDesign,
         TRIG1                                  => txWidebusExtraData_from_gbtRefDesign,
         TRIG2(0)                               => txIsDataSel_from_user
      );    
         
   rxIla: entity work.chipscope_ila    
      port map (     
         CONTROL                                => rxIla_control,
         CLK                                    => rxFrameClk_from_gbtRefDesign,
         TRIG0                                  => rxCommonData_from_gbtRefDesign,
         TRIG1                                  => rxWidebusExtraData_from_gbtRefDesign,
         TRIG2(0)                               => rxIsDataFlag_from_gbtRefDesign
      );   

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
   --
   --          * Note!! If the RX data comes from another board with a different reference clock, 
   --                   then the TX frame/word clock domains are asynchronous with respect to the
   --                   RX frame/word clock domains.   
   
   FMC1_IO_PIN.la_p(0)                          <= txFrameClk_from_gbtRefDesign;
   FMC1_IO_PIN.la_p(1)                          <= rxFrameClk_from_gbtRefDesign; 
   FMC1_IO_PIN.la_p(2)                          <= txWordClk_from_gbtRefDesign;  
   FMC1_IO_PIN.la_p(3)                          <= rxWordClk_from_gbtRefDesign;     
  
   -- Comment: FPGA_CLKOUT corresponds to SMA1 on GLIB.     
         
   FPGA_CLKOUT_O                                <= xpoint1_clk3 when clkMuxSel_from_user = '1'
                                                   else cdce_out0_bufg;
   
   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test. 
   
   AMC_PORT_TX_P(14)                            <= txMatchFlag_from_gbtRefDesign;
   AMC_PORT_TX_P(15)                            <= rxMatchFlag_from_gbtRefDesign;
   
   --=====================================================================================--   

end user_logic_arch;