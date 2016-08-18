--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Cyclone V GT FPGA Development Board - GBT Bank example design                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Cyclone V GT FPGA Development Board (Altera Cyclone V GT)                                                       
-- Tool version:          Quartus II 14.0                                                                
--                                                                                                   
-- Version:               3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        20/08/2013   3.0       M. Barros Marin   First .vhd module definition           
--
--                        29/08/2013   3.2       M. Barros Marin   Updated to Quartus II 14.0           
--
-- Additional Comments:   Note!! Only ONE GBT Bank with ONE link can be used in this example design.     
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
use work.vendor_specific_gbt_bank_package.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library gbt_tx_frameclk_stdpll;
library alt_cv_issp;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity cvGtFpgaDevkit_gbt_example_design is   
   port (   
      
      --===============--
      -- General reset --
      --===============--      
     
      USER_PB0                                       : in  std_logic; 
    
      --===============--
      -- Clocks scheme --
      --===============--
      
      -- MGT(GT) clock:
      -----------------
      
      REFCLK_QL3                                     : in  std_logic;
		
		-- Fabric clock:
		----------------
      
      CLKIN_50                                       : in  std_logic; 
		
      --==============--
      -- Serial lanes --
      --==============--
      
      HSMB_TX_2                                      : out std_logic;
      HSMB_RX_2                                      : in  std_logic;
      
      --====================--
      -- On-board user LEDs --    
      --====================--    

      USER_LED                                       : out std_logic_vector(7 downto 0);

      --====================--
      -- Signals forwarding --
      --====================--      

      -- SMA output:
      --------------
      
      -- Comment: SMA_CLKOUT is connected to a multiplexor that switches between TX_FRAMECLK and TX_WORDCLK.

      SMA_CLKOUT                                     : out std_logic;

      -- Pattern match flags:
      -----------------------
      
      HSMA_TX_D_P0                                   : out std_logic;       
      HSMA_TX_D_P1                                   : out std_logic;
      
      -- Clocks forwarding:
      ---------------------  
      
      -- Comment: * HSMA_TX_D_P2 and HSMA_TX_D_P3 are used for forwarding TX_FRAMECLK and TX_WORDCLK respectively.
      --      
      --          * HSMA_TX_D_P4 and HSMA_TX_D_P5 are used for forwarding RX_FRAMECLK and RX_WORDCLK respectively.
      
      HSMA_TX_D_P2                                   : out std_logic; 
      HSMA_TX_D_P3                                   : out std_logic; 
      -----------------------------------------------
      HSMA_TX_D_P4                                   : out std_logic; 
      HSMA_TX_D_P5                                   : out std_logic
      
   );
end cvGtFpgaDevkit_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of cvGtFpgaDevkit_gbt_example_design is
   
   --================================ Signal Declarations ================================--
   --=========--
	-- Clocks  --
	--=========--
	signal sysclk_40MHz													  : std_logic;
	
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
   signal gbtBank1_mgtTxReady_from_gbtExmplDsgn     			  : std_logic_vector(1 to 1);
   signal gbtBank1_mgtRxReady_from_gbtExmplDsgn     			  : std_logic_vector(1 to 1);
   signal gbtBank1_mgtReady_from_gbtExmplDsgn                 : std_logic_vector(1 to 1);	
   signal gbtBank1_gbtRxReady_from_gbtExmplDsgn               : std_logic_vector(1 to 1);   
   signal gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic_vector(1 to 1); 
   signal gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn          : std_logic_vector(1 to 1);
	signal gbtBank1_rxExtrDataWidebusErSeen_from_gbtExmplDsgn  : std_logic_vector(1 to 1);
	
   --============================--
   -- Latency measurements       --
   --============================--
	signal rx_frameclk														: std_logic_vector(1 to 1);
	signal tx_frameclk														: std_logic_vector(1 to 1);
	signal tx_wordclk															: std_logic_vector(1 to 1);
	signal rx_wordclk															: std_logic_vector(1 to 1);
 
	signal gbtBank1_txMatchFlag_from_gbtExmplDsgn					: std_logic;
	signal gbtBank1_rxMatchFlag_from_gbtExmplDsgn					: std_logic;
   signal locked_from_txframeclk_pll									: std_logic;    

   --============================--
   -- In-System Probes & Sources --
   --============================--   
   signal source_from_inSysSrcAndPrb                 : std_logic_vector(35 downto 0);  
   signal probe_to_inSysSrcAndPrb                    : std_logic_vector(29 downto 0);
	
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
         
   --=========================--
   -- GBT Bank example design --
   --=========================--
     
   -- Comment: * The "txframeclk_pll" is used in order to provide a 40Mhz clock to the GBT.
   --
   --				* The txframeclk_pll uses the REFCLK_Q3 as reference to be synchronous with the transceiver ref. clock (mandatory)
   
   txframeclk_pll: entity gbt_tx_frameclk_stdpll.gbt_tx_frameclk_stdpll
      port map (
         REFCLK                                      => REFCLK_QL3,          
         RST                                         => '0',          
         OUTCLK_0                                    => sysclk_40MHz,
         LOCKED                                      => locked_from_txframeclk_pll
      );
   
	
   gbtExmplDsgn: entity work.alt_cv_gbt_example_design
		generic map(
			GBT_BANK_ID							  					=> 1,
			TX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
			RX_OPTIMIZATION										=> GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
			TX_ENCODING												=> GBT_BANKS_USER_SETUP(1).TX_ENCODING,
			RX_ENCODING												=> GBT_BANKS_USER_SETUP(1).RX_ENCODING,
			NUM_LINKS												=> GBT_BANKS_USER_SETUP(1).NUM_LINKS,
			
			-- Extended configuration --
			DATA_GENERATOR_ENABLE								=> ENABLED,
			DATA_CHECKER_ENABLE									=> ENABLED,
			MATCH_FLAG_ENABLE										=> ENABLED
		)
      port map (

		--==============--
		-- Clocks       --
		--==============--
		FRAMECLK_40MHZ												=> sysclk_40MHz,
		XCVRCLK_120MHZ												=> REFCLK_QL3,
		
		TX_FRAMECLK_O												=> tx_frameclk(1 to 1),
		RX_FRAMECLK_O												=> rx_frameclk(1 to 1),
		TX_WORDCLK_O												=> tx_wordclk(1 to 1),
		RX_WORDCLK_O												=> rx_wordclk(1 to 1),
		
		--==============--
		-- Reset        --
		--==============--
		GBTBANK_GENERAL_RESET_I									=> (not locked_from_txframeclk_pll) or (not USER_PB0) or generalReset_from_gbtBank1_user,
		GBTBANK_MANUAL_RESET_TX_I								=> manualResetTx_from_gbtBank1_user,
		GBTBANK_MANUAL_RESET_RX_I								=> manualResetRx_from_gbtBank1_user,
		
		--==============--
		-- Serial lanes --
		--==============--
		GBTBANK_MGT_RX(1)											=> HSMB_RX_2,							
		GBTBANK_MGT_TX(1)											=> HSMB_TX_2,
		
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
		GBTBANK_RECONF_AVMM_CLK									=> sysclk_40MHz,
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
		GBTBANK_GBTRX_READY_O	    							=> gbtBank1_gbtRxReady_from_gbtExmplDsgn,
		GBTBANK_LINK_TX_READY_O									=> gbtBank1_mgtTxReady_from_gbtExmplDsgn,
		GBTBANK_LINK_RX_READY_O									=> gbtBank1_mgtRxReady_from_gbtExmplDsgn,
		GBTBANK_LINK_READY_O 									=> gbtBank1_mgtReady_from_gbtExmplDsgn,
		GBTBANK_TX_MATCHFLAG_O									=> gbtBank1_txMatchFlag_from_gbtExmplDsgn,
		
		--==============--
		-- RX Status    --
		--==============--
		GBTBANK_GBTRXREADY_LOST_FLAG_O                  => gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn,
		GBTBANK_RXDATA_ERRORSEEN_FLAG_O                 => gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn,
		GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O    => gbtBank1_rxExtrDataWidebusErSeen_from_gbtExmplDsgn,
		GBTBANK_RX_MATCHFLAG_O(1)								=> gbtBank1_rxMatchFlag_from_gbtExmplDsgn,
		
		--==============--
		-- XCVR ctrl    --
		--==============--
		GBTBANK_LOOPBACK_I(1)									=> loopBack_from_gbtBank1_user,
						
		GBTBANK_TX_POL												=> (others => '0'),
		GBTBANK_RX_POL												=> (others => '0'),
		GBTBANK_TXWORDCLKMON_EN									=>	'1'	
   );
      
   --==============--   
   -- Test control --   
   --==============--
   
   -- Signals mapping:
   -------------------
   
   loopBack_from_gbtBank1_user                       <= source_from_inSysSrcAndPrb( 0);
   generalReset_from_gbtBank1_user                   <= source_from_inSysSrcAndPrb( 1);          
   --Reserved                    						  <= source_from_inSysSrcAndPrb( 2);    
   manualResetTx_from_gbtBank1_user                  <= source_from_inSysSrcAndPrb( 3);
   manualResetRx_from_gbtBank1_user                  <= source_from_inSysSrcAndPrb( 4);
   testPatterSel_from_gbtBank1_user                  <= source_from_inSysSrcAndPrb( 6 downto  5); 
   txIsDataSel_from_gbtBank1_user                    <= source_from_inSysSrcAndPrb( 7);
   resetDataErrorSeenFlag_from_gbtBank1_user         <= source_from_inSysSrcAndPrb( 8);
   resetGbtRxReadyLostFlag_from_gbtBank1_user        <= source_from_inSysSrcAndPrb( 9);
   
	-- Not used
	-----------
	--txFrmClkPhAlManualReset_from_user                 <= source_from_inSysSrcAndPrb(10);
   --txFrmClkPhAlStepsNbr_from_user                    <= source_from_inSysSrcAndPrb(16 downto 11);     
   --txFrmClkPhAlStepsEnable_from_user                 <= source_from_inSysSrcAndPrb(17);   
   --txFrmClkPhAlStepsTrigger_from_user                <= source_from_inSysSrcAndPrb(18);
   --txWrdClkMonThresholdUp_from_user                  <= source_from_inSysSrcAndPrb(26 downto 19);
   --txWrdClkMonThresholdLow_from_user                 <= source_from_inSysSrcAndPrb(34 downto 27);   
   --txWrdClkMonMgtResetEn_from_user                   <= source_from_inSysSrcAndPrb(35);
	
   --------------------------------------------------
	
   probe_to_inSysSrcAndPrb( 0)                       <= '0'; -- Latency optimized not supported
																		  
   probe_to_inSysSrcAndPrb( 1)                       <= '0'; -- Latency optimized not supported
																		  
   probe_to_inSysSrcAndPrb( 2)                       <= gbtBank1_mgtTxReady_from_gbtExmplDsgn(1);
   probe_to_inSysSrcAndPrb( 3)                       <= gbtBank1_mgtRxReady_from_gbtExmplDsgn(1);       
   probe_to_inSysSrcAndPrb( 4)                       <= gbtBank1_mgtReady_from_gbtExmplDsgn(1);
   probe_to_inSysSrcAndPrb( 5)                       <= gbtBank1_gbtRxReady_from_gbtExmplDsgn(1);    
   probe_to_inSysSrcAndPrb( 6)                       <= gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn(1); 
   probe_to_inSysSrcAndPrb( 7)                       <= gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn(1);
   probe_to_inSysSrcAndPrb( 8)                       <= locked_from_txframeclk_pll;   

	-- Not used:
	-------------
   --probe_to_inSysSrcAndPrb( 9)                       <= rxFrameClkReady_from_gbtExmplDsgn;    
   --probe_to_inSysSrcAndPrb(10)                       <= gbtRxReady_from_gbtExmplDsgn;   
   --probe_to_inSysSrcAndPrb(11)                       <= rxBitSlipNbr_from_gbtExmplDsgn;       
   --probe_to_inSysSrcAndPrb(24)                       <= rxIsData_from_gbtExmplDsgn;
   --probe_to_inSysSrcAndPrb(25)                       <= gbtRxReadyLostFlag_from_gbtExmplDsgn;  
   --probe_to_inSysSrcAndPrb(26)                       <= rxDataErrorSeen_from_gbtExmplDsgn;   
   --probe_to_inSysSrcAndPrb(27)                       <= rxExtrDataWidebusErSeen_from_gbtExmplDsgn;
   --probe_to_inSysSrcAndPrb(28)                       <= ;
   --probe_to_inSysSrcAndPrb(29)                       <= locked_from_isspPll;
   
   -- In-system sources & probes:
   ------------------------------
 
   -- Comment: * In-System Sources and Probes is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * After FPGA configuration, open the project "cvGtFpgaDevkit_gbt_example_design.spf" 
   --            that can be found in:
   --            "..\example_designs\altera_cv\cv_gt_fpga_devkit\issp_project\".  
   
   inSysSrcAndPrb: entity alt_cv_issp.alt_cv_issp
      port map (
         PROBE                                       => probe_to_inSysSrcAndPrb,
         SOURCE_CLK                                  => sysclk_40MHz,
         SOURCE_ENA                                  => '1',
         SOURCE                                      => source_from_inSysSrcAndPrb
      );  
   
   -- On-board user LEDs:    
   ----------------------
   
   USER_LED(0)                                       <= not ((not USER_PB0) or generalReset_from_gbtBank1_user);
   USER_LED(1)                                       <= not manualResetTx_from_gbtBank1_user;  
   USER_LED(2)                                       <= not manualResetRx_from_gbtBank1_user; 
   USER_LED(3)                                       <= not locked_from_txframeclk_pll; 
   USER_LED(4)                                       <= not gbtBank1_mgtReady_from_gbtExmplDsgn(1);
   USER_LED(5)                                       <= not gbtBank1_rxDataErrorSeen_from_gbtExmplDsgn(1);   
   USER_LED(6)                                       <= not gbtBank1_gbtRxReadyLostFlag_from_gbtExmplDsgn(1); 
   USER_LED(7)                                       <= not locked_from_txframeclk_pll;
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If RX DATA comes from another board with a different reference clock, 
   --                   then the TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the
   --                   TX_FRAMECLK/TX_WORDCLK domains.

   SMA_CLKOUT                                        <= REFCLK_QL3;
   
   HSMA_TX_D_P2                                      <= tx_frameclk(1);
   HSMA_TX_D_P3                                      <= tx_wordclk(1);
   --------------------------------------------------   
   HSMA_TX_D_P4                                      <= rx_frameclk(1);
   HSMA_TX_D_P5                                      <= rx_wordclk(1);

   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX FLAG with the RX FLAG.
   --
   --          * The COUNTER TEST PATTERN must be used for this test. 
   
   HSMA_TX_D_P0                                      <= gbtBank1_txMatchFlag_from_gbtExmplDsgn;
   HSMA_TX_D_P1                                      <= gbtBank1_rxMatchFlag_from_gbtExmplDsgn;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--