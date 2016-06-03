--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           AMC40 - GBT Bank example design                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         AMC40 (Altera Stratix V)                                                       
-- Tool version:          Quartus II 13.1                                                                
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        23/03/2013   3.0       M. Barros Marin   First .vhd module definition           
--
-- Additional Comments:   Note!! This example design instantiates two GBt Banks:
--
--                               - GBT Bank 1: One GBT Link (Standard GBT TX and Latency-Optimized GBT RX)
--
--                               - GBT Bank 2: Three GBT Links (Latency-Optimized GBT TX and Standard GBT RX)      
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                              
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library frmclk_pll;
library alt_sv_issp_gbtBank1;
library alt_sv_issp_gbtBank2;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity amc40_gbt_example_design is   
   port (   
      
      --===============--
      -- General reset --
      --===============--      
     
      SYS_RESET_N                                             : in  std_logic; 
    
      --===============--
      -- Clocks scheme --
      --===============--
      
      -- MGT(GX) clock:
      -----------------
      
      MAIN_CLOCK_SEL                                          : out std_logic;  
      --------------------------------------------------------
      REF_CLOCK_L4                                            : in  std_logic;   -- Comment:  (LHC PLL 120MHz)
		REF_CLOCK_L2														  : in  std_logic;   -- Comment:  (LHC PLL 120MHz)
      SYS_CLK_40MHz														  : in  std_logic;
		
      --==============--
      -- Serial lanes --
      --==============--
      
      -- GBT Bank 1:
      --------------
		
      GBTBANK_TX                                           		: out std_logic_vector(0 downto 0);
      GBTBANK_RX                                           		: in  std_logic_vector(0 downto 0);
      
      -- GBT Bank 1:
      --------------
		
      GBTBANK2_TX                                           	: out std_logic_vector(2 downto 0);
      GBTBANK2_RX                                           	: in  std_logic_vector(2 downto 0);
		
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- Pattern match flags:
      -----------------------
      
      -- GBT Bank 1:
      RTM_TX_1_P                                              : out std_logic;
      RTM_TX_1_N                                              : out std_logic;
      
      RTM_TX_2_P                                              : out std_logic;
      RTM_TX_2_N                                              : out std_logic;
      
      -- Clocks forwarding:
      ---------------------
      AMC_CLOCK_OUT                                         : out std_logic;
		
		-- CDCE62005:
		-------------
		i_CDCE62005_Locked													: in std_logic_vector(2 downto 0)
		
   );
end amc40_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of amc40_gbt_example_design is
   
   --================================ Signal Declarations ================================--
   	
   --=========--
   -- Control --
   --=========--
   
   -- GBT Bank 1:
   --------------
   
   signal generalReset_from_gbtBank1_user                     : std_logic;   
   signal manualResetTx_from_gbtBank1_user                    : std_logic; 
   signal manualResetRx_from_gbtBank1_user                    : std_logic; 
   signal testPatterSel_from_gbtBank1_user                    : std_logic_vector(1 downto 0); 
   signal loopBack_from_gbtBank1_user                         : std_logic; 
   signal resetDataErrorSeenFlag_from_gbtBank1_user           : std_logic; 
   signal resetGbtRxReadyLostFlag_from_gbtBank1_user          : std_logic; 
   signal txIsDataSel_from_gbtBank1_user                      : std_logic; 
	
   --------------------------------------------------      
   signal gbtBank1_mgtTxReady_from_gbtExmplDsgn     			  : std_logic;
   signal gbtBank1_mgtRxReady_from_gbtExmplDsgn     			  : std_logic;
   signal gbtBank1_mgtReady_from_gbtExmplDsgn                 : std_logic;	
   signal gbtBank1_gbtRxReady_from_gbtExmplDsgn               : std_logic;   
   signal gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic; 
   signal gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn          : std_logic;
	signal gbtBank1_TxLatencyOptimized								  : std_logic;
	signal gbtBank1_RxLatencyOptimized								  : std_logic;
	signal gbtBank1_txMatchFlag_from_gbtExmplDsgn				  : std_logic;
	signal gbtBank1_rxMatchFlag_from_gbtExmplDsgn				  : std_logic;
   
   -- GBT Bank 2:
   --------------
   
   signal generalReset_from_gbtBank2_user                     : std_logic;   
   signal manualResetTx_from_gbtBank2_user                    : std_logic; 
   signal manualResetRx_from_gbtBank2_user                    : std_logic; 
   signal testPatterSel_from_gbtBank2_user                    : std_logic_vector(1 downto 0); 
   signal loopBack_from_gbtBank2_user                         : std_logic; 
   signal resetDataErrorSeenFlag_from_gbtBank2_user           : std_logic; 
   signal resetGbtRxReadyLostFlag_from_gbtBank2_user          : std_logic; 
   signal txIsDataSel_from_gbtBank2_user                      : std_logic; 
	
   --------------------------------------------------      
   signal gbtBank2_mgtTxReady_from_gbtExmplDsgn     			  : std_logic_vector(1 to 3);
   signal gbtBank2_mgtRxReady_from_gbtExmplDsgn     			  : std_logic_vector(1 to 3);
   signal gbtBank2_mgtReady_from_gbtExmplDsgn                 : std_logic_vector(1 to 3);
   signal gbtBank2_gbtRxReady_from_gbtExmplDsgn               : std_logic_vector(1 to 3);   
   signal gbtBank2_gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic_vector(1 to 3); 
   signal gbtBank2_rxDataErrorSeen_from_gbtExmplDsgn          : std_logic_vector(1 to 3);
	signal gbtBank2_TxLatencyOptimized								  : std_logic;
	signal gbtBank2_RxLatencyOptimized								  : std_logic;
	signal gbtBank2_txMatchFlag_from_gbtExmplDsgn				  : std_logic;
	signal gbtBank2_rxMatchFlag_from_gbtExmplDsgn				  : std_logic_vector(1 to 3);
	
	
   --============================--
   -- Latency measurements       --
   --============================--
	signal rx_frameclk														: std_logic;
	signal tx_frameclk														: std_logic;
	signal tx_wordclk															: std_logic;
	signal rx_wordclk															: std_logic;
	
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--


       --#############################################################################--
     --#################################################################################--
   --#############################                           #############################--
   --#############################  GBT Bank example design  #############################--
   --#############################                           #############################--
     --#################################################################################--
       --#############################################################################--
   
	--=====================--
	-- Clock configuration --
	--=====================--
	MAIN_CLOCK_SEL <= '0';
	
   --=======================================--
   -- Stratix V - GBT Bank 1 example design --
   --=======================================--   	
   gbtExmplDsgn: entity work.alt_sv_gbt_example_design
		generic map(
			GBT_BANK_ID							  					=> 1,
			TX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
			RX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
			TX_ENCODING												=> GBT_BANKS_USER_SETUP(1).TX_ENCODING,
			RX_ENCODING												=> GBT_BANKS_USER_SETUP(1).RX_ENCODING,
			NUM_LINKS												=> GBT_BANKS_USER_SETUP(1).NUM_LINKS
		)
      port map (

			--==============--
			-- Clocks       --
			--==============--
			FRAMECLK_40MHZ												=> SYS_CLK_40MHz,
			XCVRCLK_120MHZ												=> REF_CLOCK_L2,
			
			TX_FRAMECLK_O(1)											=> tx_frameclk,
			RX_FRAMECLK_O(1)											=> rx_frameclk,
			TX_WORDCLK_O(1)											=> tx_wordclk,
			RX_WORDCLK_O(1)											=> rx_wordclk,
			
			--==============--
			-- Reset        --
			--==============--
			GBTBANK_GENERAL_RESET_I									=> generalReset_from_gbtBank1_user,
			GBTBANK_MANUAL_RESET_TX_I								=> manualResetTx_from_gbtBank1_user,
			GBTBANK_MANUAL_RESET_RX_I								=> manualResetRx_from_gbtBank1_user,
			
			--==============--
			-- Serial lanes --
			--==============--
			GBTBANK_MGT_RX(1)											=> GBTBANK_RX(0),							
			GBTBANK_MGT_TX(1)											=> GBTBANK_TX(0),
			
			--==============--
			-- Data			 --
			--==============--		
			GBTBANK_GBT_DATA_I(1)									=> (others => '0'),		
			GBTBANK_WB_DATA_I(1)										=> (others => '0'),
			
			GBTBANK_GBT_DATA_O										=> open,
			GBTBANK_WB_DATA_O											=> open,
			
			--==============--
			-- Reconf.		 --
			--==============--
			GBTBANK_RECONF_AVMM_RST									=> '0',
			GBTBANK_RECONF_AVMM_CLK									=> SYS_CLK_40MHz,
			GBTBANK_RECONF_AVMM_ADDR								=> (others => '0'),
			GBTBANK_RECONF_AVMM_READ								=> '0',
			GBTBANK_RECONF_AVMM_WRITE								=> '0',
			GBTBANK_RECONF_AVMM_WRITEDATA							=> (others => '0'),
			GBTBANK_RECONF_AVMM_READDATA							=> open,
			GBTBANK_RECONF_AVMM_WAITREQUEST						=> open,
			
			--==============--					
			-- TX ctrl	    --					
			--==============--					
			GBTBANK_TX_ISDATA_SEL_I(1)								=> txIsDataSel_from_gbtBank1_user,
							
			GBTBANK_TEST_PATTERN_SEL_I								=> testPatterSel_from_gbtBank1_user,
				
			--==============--	
			-- RX ctrl      --	
			--==============--	
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(1)     		=> resetGbtRxReadyLostFlag_from_gbtBank1_user,  
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(1)      		=> resetDataErrorSeenFlag_from_gbtBank1_user,
			
			--==============--
			-- TX Status    --
			--==============--
			GBTBANK_GBTRX_READY_O(1)    							=> gbtBank1_gbtRxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_TX_READY_O(1)								=> gbtBank1_mgtTxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_RX_READY_O(1)								=> gbtBank1_mgtRxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_READY_O(1)									=> gbtBank1_mgtReady_from_gbtExmplDsgn,
			GBTBANK_TX_MATCHFLAG_O									=> gbtBank1_txMatchFlag_from_gbtExmplDsgn,
			
			--==============--
			-- RX Status    --
			--==============--
			GBTBANK_GBTRXREADY_LOST_FLAG_O(1)               => gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn,
			GBTBANK_RXDATA_ERRORSEEN_FLAG_O(1)              => gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn,
			GBTBANK_RX_MATCHFLAG_O(1)								=> gbtBank1_rxMatchFlag_from_gbtExmplDsgn,
			
			--==============--
			-- XCVR ctrl    --
			--==============--
			GBTBANK_LOOPBACK_I(1)									=> loopBack_from_gbtBank1_user,
							
			GBTBANK_TX_POL												=> (others => '0'),
			GBTBANK_RX_POL												=> (others => '0'),
			GBTBANK_TXWORDCLKMON_EN									=>	'1'	
		);
	
   --=======================================--
   -- Stratix V - GBT Bank 2 example design --
   --=======================================--   	
   gbtExmplDsgn_gbtBank2: entity work.alt_sv_gbt_example_design
		generic map(
			GBT_BANK_ID							  					=> 2,
			TX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(2).TX_OPTIMIZATION,
			RX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(2).RX_OPTIMIZATION,
			TX_ENCODING												=> GBT_BANKS_USER_SETUP(2).TX_ENCODING,
			RX_ENCODING												=> GBT_BANKS_USER_SETUP(2).RX_ENCODING,
			NUM_LINKS												=> GBT_BANKS_USER_SETUP(2).NUM_LINKS
		)
      port map (

			--==============--
			-- Clocks       --
			--==============--
			FRAMECLK_40MHZ												=> SYS_CLK_40MHz,
			XCVRCLK_120MHZ												=> REF_CLOCK_L4,
			
			--==============--
			-- Reset        --
			--==============--
			GBTBANK_GENERAL_RESET_I									=> generalReset_from_gbtBank2_user,
			GBTBANK_MANUAL_RESET_TX_I								=> manualResetTx_from_gbtBank2_user,
			GBTBANK_MANUAL_RESET_RX_I								=> manualResetRx_from_gbtBank2_user,
			
			--==============--
			-- Serial lanes --
			--==============--
			GBTBANK_MGT_RX(1)											=> GBTBANK2_RX(0),
			GBTBANK_MGT_RX(2)											=> GBTBANK2_RX(1),
			GBTBANK_MGT_RX(3)											=> GBTBANK2_RX(2),
			
			GBTBANK_MGT_TX(1)											=> GBTBANK2_TX(0),
			GBTBANK_MGT_TX(2)											=> GBTBANK2_TX(1),
			GBTBANK_MGT_TX(3)											=> GBTBANK2_TX(2),
			
			--==============--
			-- Data			 --
			--==============--		
			GBTBANK_GBT_DATA_I(1)									=> (others => '0'),		
			GBTBANK_WB_DATA_I(1)										=> (others => '0'),
			
			GBTBANK_GBT_DATA_O										=> open,
			GBTBANK_WB_DATA_O											=> open,
			
			--==============--
			-- Reconf.		 --
			--==============--
			GBTBANK_RECONF_AVMM_RST									=> '0',
			GBTBANK_RECONF_AVMM_CLK									=> SYS_CLK_40MHz,
			GBTBANK_RECONF_AVMM_ADDR								=> (others => '0'),
			GBTBANK_RECONF_AVMM_READ								=> '0',
			GBTBANK_RECONF_AVMM_WRITE								=> '0',
			GBTBANK_RECONF_AVMM_WRITEDATA							=> (others => '0'),
			GBTBANK_RECONF_AVMM_READDATA							=> open,
			GBTBANK_RECONF_AVMM_WAITREQUEST						=> open,
			
			--==============--					
			-- TX ctrl	    --					
			--==============--					
			GBTBANK_TX_ISDATA_SEL_I(1)								=> txIsDataSel_from_gbtBank2_user,
			GBTBANK_TX_ISDATA_SEL_I(2)								=> txIsDataSel_from_gbtBank2_user,
			GBTBANK_TX_ISDATA_SEL_I(3)								=> txIsDataSel_from_gbtBank2_user,
							
			GBTBANK_TEST_PATTERN_SEL_I								=> testPatterSel_from_gbtBank2_user,
				
			--==============--	
			-- RX ctrl      --	
			--==============--	
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(1)     		=> resetGbtRxReadyLostFlag_from_gbtBank2_user,  
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(2)     		=> resetGbtRxReadyLostFlag_from_gbtBank2_user,  
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(3)     		=> resetGbtRxReadyLostFlag_from_gbtBank2_user,  
			
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(1)      		=> resetDataErrorSeenFlag_from_gbtBank2_user,
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(2)      		=> resetDataErrorSeenFlag_from_gbtBank2_user,
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(3)      		=> resetDataErrorSeenFlag_from_gbtBank2_user,
			
			--==============--
			-- TX Status    --
			--==============--
			GBTBANK_GBTRX_READY_O      							=> gbtBank2_gbtRxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_TX_READY_O									=> gbtBank2_mgtTxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_RX_READY_O									=> gbtBank2_mgtRxReady_from_gbtExmplDsgn,
			GBTBANK_LINK_READY_O										=> gbtBank2_mgtReady_from_gbtExmplDsgn,
			GBTBANK_TX_MATCHFLAG_O									=> gbtBank2_txMatchFlag_from_gbtExmplDsgn,
			
			--==============--
			-- RX Status    --
			--==============--
			GBTBANK_GBTRXREADY_LOST_FLAG_O	               => gbtBank2_gbtRxReadyLostFlag_from_gbtExmplDsgn,
			GBTBANK_RXDATA_ERRORSEEN_FLAG_O	               => gbtBank2_rxDataErrorSeen_from_gbtExmplDsgn,
			GBTBANK_RX_MATCHFLAG_O									=> gbtBank2_rxMatchFlag_from_gbtExmplDsgn,
			
			--==============--
			-- XCVR ctrl    --
			--==============--
			GBTBANK_LOOPBACK_I(1)									=> loopBack_from_gbtBank2_user,
			GBTBANK_LOOPBACK_I(2)									=> loopBack_from_gbtBank2_user,
			GBTBANK_LOOPBACK_I(3)									=> loopBack_from_gbtBank2_user,
							
			GBTBANK_TX_POL												=> (others => '0'),
			GBTBANK_RX_POL												=> (others => '0'),
			GBTBANK_TXWORDCLKMON_EN									=>	'1'	
		);
	  
       --##############################################################################--
     --##################################################################################--
   --##########################                              #############################--
   --##########################  GBT Bank 1 (related logic)  #############################--
   --##########################                              #############################--
     --##################################################################################--
       --##############################################################################--

   
   --==================--   
   -- GBT Bank 1 debug --   
   --==================--
	
   gbtBank1_TxLatencyOptimized                       <= '1' when GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION = LATENCY_OPTIMIZED else
																		  '0';
   gbtBank1_RxLatencyOptimized                       <= '1' when GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION = LATENCY_OPTIMIZED else
																		  '0';
   
	
   -- In-system sources & probes:
   ------------------------------

   -- Comment: * In-System Sources and Probes is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * After FPGA configuration using, open the project "amc40_gbt_example_design.spf" 
   --            that can be found in:
   --            "..\example_designs\altera_sv\amc40\issp_project\".  
   
   gbtBank1_inSysSrcAndPrb: entity alt_sv_issp_gbtBank1.alt_sv_issp_gbtBank1
      port map (
         PROBE(0)                                             => gbtBank1_TxLatencyOptimized,
         PROBE(1)                                             => gbtBank1_RxLatencyOptimized,
         PROBE(2)                                             => gbtBank1_mgtTxReady_from_gbtExmplDsgn,
         PROBE(3)                                             => gbtBank1_mgtRxReady_from_gbtExmplDsgn,
         PROBE(4)                                             => gbtBank1_mgtReady_from_gbtExmplDsgn,
         PROBE(5)                                             => gbtBank1_gbtRxReady_from_gbtExmplDsgn,
         PROBE(6)                                             => '1',
         PROBE(7)                                             => gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn,
         PROBE(8)                                             => gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn,
			
         SOURCE_CLK                                           => SYS_CLK_40MHz,
         SOURCE_ENA                                           => '1',
			
         SOURCE(0)                                            => loopBack_from_gbtBank1_user,
         SOURCE(1)                                            => generalReset_from_gbtBank1_user,
         SOURCE(2)                                            => open, --reserved for future use
         SOURCE(3)                                            => manualResetTx_from_gbtBank1_user,
         SOURCE(4)                                            => manualResetRx_from_gbtBank1_user,
         SOURCE(6 downto 5)                                   => testPatterSel_from_gbtBank1_user,
         SOURCE(7)                                            => txIsDataSel_from_gbtBank1_user,
         SOURCE(8)                                            => resetDataErrorSeenFlag_from_gbtBank1_user,
         SOURCE(9)                                            => resetGbtRxReadyLostFlag_from_gbtBank1_user
      );
       	
	  
       --##############################################################################--
     --##################################################################################--
   --##########################                              #############################--
   --##########################  GBT Bank 2 (related logic)  #############################--
   --##########################                              #############################--
     --##################################################################################--
       --##############################################################################--

   
   --==================--   
   -- GBT Bank 1 debug --   
   --==================--
	
   gbtBank2_TxLatencyOptimized                       <= '1' when GBT_BANKS_USER_SETUP(2).TX_OPTIMIZATION = LATENCY_OPTIMIZED else
																		  '0';
   gbtBank2_RxLatencyOptimized                       <= '1' when GBT_BANKS_USER_SETUP(2).RX_OPTIMIZATION = LATENCY_OPTIMIZED else
																		  '0';
   
	
   -- In-system sources & probes:
   ------------------------------

   -- Comment: * In-System Sources and Probes is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * After FPGA configuration using, open the project "amc40_gbt_example_design.spf" 
   --            that can be found in:
   --            "..\example_designs\altera_sv\amc40\issp_project\".  
   
   gbtBank2_inSysSrcAndPrb: entity alt_sv_issp_gbtBank2.alt_sv_issp_gbtBank2
      port map (
         PROBE(0)                                             => gbtBank2_TxLatencyOptimized,
         PROBE(1)                                             => gbtBank2_RxLatencyOptimized,
         PROBE(2)                                             => gbtBank2_mgtTxReady_from_gbtExmplDsgn(1),
         PROBE(3)                                             => gbtBank2_mgtTxReady_from_gbtExmplDsgn(2),
         PROBE(4)                                             => gbtBank2_mgtTxReady_from_gbtExmplDsgn(3),
         PROBE(5)                                             => gbtBank2_mgtRxReady_from_gbtExmplDsgn(1),
         PROBE(6)                                             => gbtBank2_mgtRxReady_from_gbtExmplDsgn(2),
         PROBE(7)                                             => gbtBank2_mgtRxReady_from_gbtExmplDsgn(3),
         PROBE(8)                                             => gbtBank2_mgtReady_from_gbtExmplDsgn(1),
         PROBE(9)                                             => gbtBank2_mgtReady_from_gbtExmplDsgn(2),
         PROBE(10)                                            => gbtBank2_mgtReady_from_gbtExmplDsgn(3),
         PROBE(11)                                            => gbtBank2_gbtRxReady_from_gbtExmplDsgn(1),
         PROBE(12)                                            => gbtBank2_gbtRxReady_from_gbtExmplDsgn(2),
         PROBE(13)                                            => gbtBank2_gbtRxReady_from_gbtExmplDsgn(3),
         PROBE(14)                                            => gbtBank2_rxDataErrorSeen_from_gbtExmplDsgn(1),
         PROBE(15)                                            => gbtBank2_rxDataErrorSeen_from_gbtExmplDsgn(2),
         PROBE(16)                                            => gbtBank2_rxDataErrorSeen_from_gbtExmplDsgn(3),
         PROBE(17)                                            => gbtBank2_gbtRxReadyLostFlag_from_gbtExmplDsgn(1),
         PROBE(18)                                            => gbtBank2_gbtRxReadyLostFlag_from_gbtExmplDsgn(2),
         PROBE(19)                                            => gbtBank2_gbtRxReadyLostFlag_from_gbtExmplDsgn(3),
			
         SOURCE_CLK                                           => SYS_CLK_40MHz,
         SOURCE_ENA                                           => '1',
			
         SOURCE(0)                                            => loopBack_from_gbtBank2_user,
         SOURCE(1)                                            => generalReset_from_gbtBank2_user,
         SOURCE(2)                                            => manualResetTx_from_gbtBank2_user,
         SOURCE(3)                                            => manualResetRx_from_gbtBank2_user,
         SOURCE(5 downto 4)                                   => testPatterSel_from_gbtBank2_user,
         SOURCE(6)                                            => txIsDataSel_from_gbtBank2_user,
         SOURCE(7)                                            => resetDataErrorSeenFlag_from_gbtBank2_user,
         SOURCE(8)                                            => resetGbtRxReadyLostFlag_from_gbtBank2_user
      );
		 
       --#############################################################################--
     --#################################################################################--
   --#############################                       ################################--
   --#############################  Latency measurement  ################################--
   --#############################                       ################################--
     --#################################################################################--
       --#############################################################################--


   --===================--
   -- Clocks forwarding --
   --===================--
   
	AMC_CLOCK_OUT <= gbtBank1_txMatchFlag_from_gbtExmplDsgn or gbtBank1_rxMatchFlag_from_gbtExmplDsgn;
	
   RTM_TX_1_P	<= tx_frameclk;	-- TX Frameclk from GBT BANK 1
	RTM_TX_1_N	<= tx_wordclk;		-- TX Wordclk from GBT BANK 1
	
	RTM_TX_2_P	<= rx_frameclk;	-- RX Frameclk from GBT BANK 1
	RTM_TX_2_N	<=	rx_wordclk;		-- RX Wordclk from GBT BANK 1
                                                                 
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--