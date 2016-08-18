--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Cyclone V - Multi Gigabit Transceivers standard
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Altera Cyclone V                                                      
-- Tool version:          Quartus II 14.0                                                              
--                                                                                                   
-- Revision:              3.5                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        06/04/2014   3.0       M. Barros Marin   First .vhd module definition           
--
--                        05/10/2014   3.5       M. Barros Marin   - Added port "GBTRX_MGTTX_RDY_O"
--                                                                 - Minor modifications       
--
-- Additional Comments:                                                                               
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

-- Altera devices library:
library altera; 
library altera_mf;
library lpm;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library alt_cv_gt_std_x1;
library alt_cv_gt_std_x2;
library alt_cv_gt_std_x3;

library alt_cv_gt_reset_rx;
library alt_cv_gt_reset_tx;

library alt_cv_gt_reconfctrl_x1;
library alt_cv_gt_reconfctrl_x2;
library alt_cv_gt_reconfctrl_x3;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity mgt_std is
   generic (
      GBT_BANK_ID                               : integer := 1;  
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME
   ); 
   port (      

      --===============--  
      -- Clocks scheme --  
      --===============--  

      MGT_CLKS_I                                : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                : out gbtBankMgtClks_o_R;   

		--========--
		-- Clocks --
		--========--
		TX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);     

      --=========--  
      -- MGT I/O --  
      --=========--  

      MGT_I                                     : in  mgt_i_R;
      MGT_O                                     : out mgt_o_R;

      --=============-- 
      -- GBT Control -- 
      --=============-- 
      
      GBTTX_MGTTX_RDY_O                         : out std_logic_vector (1 to NUM_LINKS);
      
      GBTRX_MGTRX_RDY_O                         : out std_logic_vector (1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                   : out std_logic_vector (1 to NUM_LINKS);
      
      --=======-- 
      -- Words -- 
      --=======-- 
 
      GBTTX_WORD_I                              : in  word_mxnbit_A    (1 to NUM_LINKS);     
      GBTRX_WORD_O                              : out word_mxnbit_A    (1 to NUM_LINKS) 
   
   );
end mgt_std;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_std is 

   --================================ Signal Declarations ================================--
   
   --===================--
   -- Reset controllers --
   --===================--  
   
   signal txAnalogReset_from_gtRstCtrl          : std_logic_vector     (1 to NUM_LINKS);
   signal txDigitalReset_from_gtRstCtrl         : std_logic_vector     (1 to NUM_LINKS);
   signal txReady_from_gtRstCtrl                : std_logic_vector     (1 to NUM_LINKS);
   ---------------------------------------------
   signal rxAnalogreset_from_gtRstCtrl          : std_logic_vector     (1 to NUM_LINKS);
   signal rxDigitalreset_from_gtRstCtrl         : std_logic_vector     (1 to NUM_LINKS);
   signal rxReady_from_gtRstCtrl                : std_logic_vector     (1 to NUM_LINKS);

   --=========--
   -- ATX PLL --
   --=========-- 
	signal reconfToATXPLL									: std_logic_vector			  (69 downto 0);
	signal ATXPLLToReconf									: std_logic_vector			  (45 downto 0);
	signal ATXPLL_clkout										: std_logic;
	signal ATXPLLLocked										: std_logic;
	
   --=======================================--
   -- Multi-Gigabit Transceivers (standard) --
   --=======================================--      

   signal rxIsLockedToData_from_gtStd           : std_logic_vector     (1 to NUM_LINKS);   
   signal txCalBusy_from_gtStd                  : std_logic_vector     (1 to NUM_LINKS);
   signal rxCalBusy_from_gtStd                  : std_logic_vector     (1 to NUM_LINKS); 
   
	signal reconfToXCVR									: std_logic_vector	  ((NUM_LINKS*70)-1 downto 0);
	signal XCVRToReconf									: std_logic_vector	  ((NUM_LINKS*46)-1 downto 0);
   
	signal tx_usrclk										: std_logic_vector	  ((NUM_LINKS-1) downto 0);
	signal rx_usrclk										: std_logic_vector	  ((NUM_LINKS-1) downto 0);
   
   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================-- 
   
   --=============--
   -- Assignments --
   --=============--
   
   commonAssign_gen: for i in 1 to NUM_LINKS generate

      MGT_O.mgtLink(i).rxWordClkReady           <= rxReady_from_gtRstCtrl(i);
      GBTRX_RXWORDCLK_READY_O(i)                <= rxReady_from_gtRstCtrl(i);      
      MGT_O.mgtLink(i).txCal_busy               <= txCalBusy_from_gtStd(i);
      MGT_O.mgtLink(i).rxCal_busy               <= rxCalBusy_from_gtStd(i);
      MGT_O.mgtLink(i).ready                    <= txReady_from_gtRstCtrl(i) and rxReady_from_gtRstCtrl(i);
      MGT_O.mgtLink(i).tx_ready                 <= txReady_from_gtRstCtrl(i);
      MGT_O.mgtLink(i).rx_ready                 <= rxReady_from_gtRstCtrl(i);
      GBTTX_MGTTX_RDY_O(i)                      <= txReady_from_gtRstCtrl(i);         
      GBTRX_MGTRX_RDY_O(i)                      <= rxReady_from_gtRstCtrl(i);         
      MGT_O.mgtLink(i).rxIsLocked_toData        <= rxIsLockedToData_from_gtStd(i);
      
   end generate;
   
   --=====================--
   -- GT reset controllers --
   --=====================--      
   
   gtRstCtrl_gen: for i in 1 to NUM_LINKS generate
   
      gtRstCtrl: entity work.alt_cv_mgt_resetctrl       
         port map (
            CLK_I                               => MGT_CLKS_I.mgtRefClk,                            
            ------------------------------------         
            TX_RESET_I                          => MGT_I.mgtLink(i).tx_reset,    
            RX_RESET_I                          => MGT_I.mgtLink(i).rx_reset,    
            ------------------------------------          
            TX_ANALOGRESET_O                    => txAnalogReset_from_gtRstCtrl(i),
            TX_DIGITALRESET_O                   => txDigitalReset_from_gtRstCtrl(i),                  
            TX_READY_O                          => txReady_from_gtRstCtrl(i),                         
            PLL_LOCKED_I                        => ATXPLLLocked,                       
            TX_CAL_BUSY_I                       => txCalBusy_from_gtStd(i),                          
            ------------------------------------          
            RX_ANALOGRESET_O                    => rxAnalogreset_from_gtRstCtrl(i),
            RX_DIGITALRESET_O                   => rxDigitalreset_from_gtRstCtrl(i),                          
            RX_READY_O                          => rxReady_from_gtRstCtrl(i),                         
            RX_IS_LOCKEDTODATA_I                => rxIsLockedToData_from_gtStd(i),                     
            RX_CAL_BUSY_I                       => rxCalBusy_from_gtStd(i)                                 
         );
   
   end generate;
   	
	--================================================--
	-- ATX PLL													  --
	--================================================-- 
	atx_pll: entity work.alt_cv_mgt_txpll
		port map (      
			RESET_I             => MGT_I.mgtLink(1).tx_reset,
			
			MGT_REFCLK_I        => MGT_CLKS_I.mgtRefClk,
			FEEDBACK_CLK_I      => '0',
			
			EXTGTTXPLL_CLK_O    => ATXPLL_clkout,
			
			LOCKED_O            => ATXPLLLocked,
							
			RECONFIG_I          => reconfToATXPLL,
			RECONFIG_O          => ATXPLLToReconf
		);
		
   --=======================================--
   -- Multi-Gigabit Transceivers (standard) --
   --=======================================--
   
   -- MGT standard x1:
   -------------------
   
   gtStd_x1_gen: if NUM_LINKS = 1 generate
      
		reconfGxStd_x1: entity alt_cv_gt_reconfctrl_x1.alt_cv_gt_reconfctrl_x1
			port map (
				RECONFIG_BUSY                                     => open,     
			 
				MGMT_RST_RESET                                    => MGT_I.mgtCommon.reconf_reset,      
				MGMT_CLK_CLK                                      => MGT_I.mgtCommon.reconf_clk, 
				
				RECONFIG_MGMT_ADDRESS                             => MGT_I.mgtCommon.reconf_avmm_addr,    
				RECONFIG_MGMT_READ                                => MGT_I.mgtCommon.reconf_avmm_read,       
				RECONFIG_MGMT_READDATA                            => MGT_O.mgtCommon.reconf_avmm_readdata,      -- Comment: Note!! Left floating.   
				RECONFIG_MGMT_WAITREQUEST                         => MGT_O.mgtCommon.reconf_avmm_waitrequest,   -- Comment: Note!! Left floating.
				RECONFIG_MGMT_WRITE                               => MGT_I.mgtCommon.reconf_avmm_write,      
				RECONFIG_MGMT_WRITEDATA                           => MGT_I.mgtCommon.reconf_avmm_writedata,  
				
				CH0_0_TO_XCVR                                     => reconfToXCVR,  
				CH0_0_FROM_XCVR                                   => XCVRToReconf,
				
				CH1_1_TO_XCVR                                     => reconfToATXPLL,
				CH1_1_FROM_XCVR                                   => ATXPLLToReconf 
			);
			
      gtStd_x1: entity alt_cv_gt_std_x1.alt_cv_gt_std_x1
         port map (
            PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,   
				
            TX_ANALOGRESET(0)                   => txAnalogReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(0)                  => txDigitalReset_from_gtRstCtrl(1), 
				RX_ANALOGRESET(0)                   => rxAnalogReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(0)                  => rxDigitalReset_from_gtRstCtrl(1),
				
            EXT_PLL_CLK(0)                      => ATXPLL_clkout,                 
            RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,   
				
            TX_STD_CORECLKIN                    => tx_usrclk,      
            RX_STD_CORECLKIN                    => rx_usrclk,      
            TX_STD_CLKOUT                       => tx_usrclk,         
            RX_STD_CLKOUT                       => rx_usrclk,      
				
            RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,    
            RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gtStd(1),
            TX_CAL_BUSY(0)                      => txCalBusy_from_gtStd(1),         
            RX_CAL_BUSY(0)                      => rxCalBusy_from_gtStd(1), 
				
            RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack, 
            TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,      
            RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,      
            
				RECONFIG_TO_XCVR                    => reconfToXCVR,  
            RECONFIG_FROM_XCVR                  => XCVRToReconf,
            
				TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData, 
            RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,  
				        
            TX_PARALLEL_DATA                    => GBTTX_WORD_I(1),
            RX_PARALLEL_DATA                    => GBTRX_WORD_O(1)    
         );
      
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
   end generate;
   
   -- MGT standard x2:
   -------------------   
   gtStd_x2_gen: if NUM_LINKS = 2 generate
      
		reconfGxStd_x2: entity alt_cv_gt_reconfctrl_x2.alt_cv_gt_reconfctrl_x2
			port map (
				RECONFIG_BUSY                                     => open,     
			 
				MGMT_RST_RESET                                    => MGT_I.mgtCommon.reconf_reset,      
				MGMT_CLK_CLK                                      => MGT_I.mgtCommon.reconf_clk, 
				
				RECONFIG_MGMT_ADDRESS                             => MGT_I.mgtCommon.reconf_avmm_addr,    
				RECONFIG_MGMT_READ                                => MGT_I.mgtCommon.reconf_avmm_read,       
				RECONFIG_MGMT_READDATA                            => MGT_O.mgtCommon.reconf_avmm_readdata,      -- Comment: Note!! Left floating.   
				RECONFIG_MGMT_WAITREQUEST                         => MGT_O.mgtCommon.reconf_avmm_waitrequest,   -- Comment: Note!! Left floating.
				RECONFIG_MGMT_WRITE                               => MGT_I.mgtCommon.reconf_avmm_write,      
				RECONFIG_MGMT_WRITEDATA                           => MGT_I.mgtCommon.reconf_avmm_writedata,  
				
				CH0_1_TO_XCVR                                     => reconfToXCVR,  
				CH0_1_FROM_XCVR                                   => XCVRToReconf,
				
				CH2_2_TO_XCVR                                     => reconfToATXPLL,
				CH2_2_FROM_XCVR                                   => ATXPLLToReconf 
			);
			
      gtStd_x2: entity alt_cv_gt_std_x2.alt_cv_gt_std_x2
         port map (
            PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,   
				
            TX_ANALOGRESET(0)                   => txAnalogReset_from_gtRstCtrl(1), 
            TX_ANALOGRESET(1)                   => txAnalogReset_from_gtRstCtrl(2),
				
            TX_DIGITALRESET(0)                  => txDigitalReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(1)                  => txDigitalReset_from_gtRstCtrl(2), 
				
				RX_ANALOGRESET(0)                   => rxAnalogReset_from_gtRstCtrl(1),
				RX_ANALOGRESET(1)                   => rxAnalogReset_from_gtRstCtrl(2),
				
            RX_DIGITALRESET(0)                  => rxDigitalReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(1)                  => rxDigitalReset_from_gtRstCtrl(2),
				
            EXT_PLL_CLK(0)                      => ATXPLL_clkout,
            EXT_PLL_CLK(1)                      => ATXPLL_clkout,        
				
            RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,   
				
            TX_STD_CORECLKIN                    => tx_usrclk,      
            RX_STD_CORECLKIN                    => rx_usrclk,      
            TX_STD_CLKOUT                       => tx_usrclk,         
            RX_STD_CLKOUT                       => rx_usrclk,      
				
            RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef, 
            RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,  
				
            RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gtStd(1),
            RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gtStd(2),
				
            TX_CAL_BUSY(0)                      => txCalBusy_from_gtStd(1),  
            TX_CAL_BUSY(1)                      => txCalBusy_from_gtStd(2), 
				
            RX_CAL_BUSY(0)                      => rxCalBusy_from_gtStd(1), 
            RX_CAL_BUSY(1)                      => rxCalBusy_from_gtStd(2), 
				
            RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack, 
            RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack, 
				
            TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,  
            TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity, 
				
            RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity, 
            RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,      
            
				RECONFIG_TO_XCVR                    => reconfToXCVR,  
            RECONFIG_FROM_XCVR                  => XCVRToReconf,
            
				TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData, 
				TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData, 
            RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,  
            RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,  
				        
            TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
            TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
				
            RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
            RX_PARALLEL_DATA( 79 downto 40)     => GBTRX_WORD_O(2)     
         );
     
               
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);	
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);	
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);	
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
   end generate;
   
   -- MGT standard x3:
   -------------------   
   gtStd_x3_gen: if NUM_LINKS = 3 generate
      
		reconfGxStd_x3: entity alt_cv_gt_reconfctrl_x3.alt_cv_gt_reconfctrl_x3
			port map (
				RECONFIG_BUSY                                     => open,     
			 
				MGMT_RST_RESET                                    => MGT_I.mgtCommon.reconf_reset,      
				MGMT_CLK_CLK                                      => MGT_I.mgtCommon.reconf_clk, 
				
				RECONFIG_MGMT_ADDRESS                             => MGT_I.mgtCommon.reconf_avmm_addr,    
				RECONFIG_MGMT_READ                                => MGT_I.mgtCommon.reconf_avmm_read,       
				RECONFIG_MGMT_READDATA                            => MGT_O.mgtCommon.reconf_avmm_readdata,      -- Comment: Note!! Left floating.   
				RECONFIG_MGMT_WAITREQUEST                         => MGT_O.mgtCommon.reconf_avmm_waitrequest,   -- Comment: Note!! Left floating.
				RECONFIG_MGMT_WRITE                               => MGT_I.mgtCommon.reconf_avmm_write,      
				RECONFIG_MGMT_WRITEDATA                           => MGT_I.mgtCommon.reconf_avmm_writedata,  
				
				CH0_2_TO_XCVR                                     => reconfToXCVR,  
				CH0_2_FROM_XCVR                                   => XCVRToReconf,
				
				CH3_3_TO_XCVR                                     => reconfToATXPLL,
				CH3_3_FROM_XCVR                                   => ATXPLLToReconf 
			);
			
      gtStd_x3: entity alt_cv_gt_std_x3.alt_cv_gt_std_x3
         port map (
            PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,   
				
            TX_ANALOGRESET(0)                   => txAnalogReset_from_gtRstCtrl(1), 
            TX_ANALOGRESET(1)                   => txAnalogReset_from_gtRstCtrl(2),
            TX_ANALOGRESET(2)                   => txAnalogReset_from_gtRstCtrl(3),
				
            TX_DIGITALRESET(0)                  => txDigitalReset_from_gtRstCtrl(1), 
            TX_DIGITALRESET(1)                  => txDigitalReset_from_gtRstCtrl(2),  
            TX_DIGITALRESET(2)                  => txDigitalReset_from_gtRstCtrl(3),
				
				RX_ANALOGRESET(0)                   => rxAnalogReset_from_gtRstCtrl(1),
				RX_ANALOGRESET(1)                   => rxAnalogReset_from_gtRstCtrl(2),
				RX_ANALOGRESET(2)                   => rxAnalogReset_from_gtRstCtrl(3),
				
            RX_DIGITALRESET(0)                  => rxDigitalReset_from_gtRstCtrl(1),
            RX_DIGITALRESET(1)                  => rxDigitalReset_from_gtRstCtrl(2),
            RX_DIGITALRESET(2)                  => rxDigitalReset_from_gtRstCtrl(3),
				
            EXT_PLL_CLK(0)                      => ATXPLL_clkout,
            EXT_PLL_CLK(1)                      => ATXPLL_clkout, 
            EXT_PLL_CLK(2)                      => ATXPLL_clkout,         
				
            RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,   
				
            TX_STD_CORECLKIN                    => tx_usrclk,      
            RX_STD_CORECLKIN                    => rx_usrclk,      
            TX_STD_CLKOUT                       => tx_usrclk,         
            RX_STD_CLKOUT                       => rx_usrclk,      
				
            RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef, 
            RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
            RX_IS_LOCKEDTOREF(2)                => MGT_O.mgtLink(3).rxIsLocked_toRef,    
				
            RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gtStd(1),
            RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gtStd(2),
            RX_IS_LOCKEDTODATA (2)              => rxIsLockedToData_from_gtStd(3),
				
            TX_CAL_BUSY(0)                      => txCalBusy_from_gtStd(1),  
            TX_CAL_BUSY(1)                      => txCalBusy_from_gtStd(2),   
            TX_CAL_BUSY(2)                      => txCalBusy_from_gtStd(3), 
				
            RX_CAL_BUSY(0)                      => rxCalBusy_from_gtStd(1), 
            RX_CAL_BUSY(1)                      => rxCalBusy_from_gtStd(2), 
            RX_CAL_BUSY(2)                      => rxCalBusy_from_gtStd(3),  
				
            RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack, 
            RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,  
            RX_SERIALLPBKEN(2)                  => MGT_I.mgtLink(3).loopBack, 
				
            TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,  
            TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,   
            TX_STD_POLINV(2)                    => MGT_I.mgtLink(3).tx_polarity,
				
            RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity, 
            RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,   
            RX_STD_POLINV(2)                    => MGT_I.mgtLink(3).rx_polarity,     
            
				RECONFIG_TO_XCVR                    => reconfToXCVR,  
            RECONFIG_FROM_XCVR                  => XCVRToReconf,
            
				TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData, 
				TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData, 
				TX_SERIAL_DATA(2)                   => MGT_O.mgtLink(3).txSerialData, 
            RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,  
            RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,  
            RX_SERIAL_DATA(2)                   => MGT_I.mgtLink(3).rxSerialData,   
				        
            TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
            TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
            TX_PARALLEL_DATA(119 downto 80)     => GBTTX_WORD_I(3),
				
            RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
            RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(2),
            RX_PARALLEL_DATA(119 downto 80)     => GBTRX_WORD_O(3)     
         );
               
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);	
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);		
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);	
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);		
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
   end generate;
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--