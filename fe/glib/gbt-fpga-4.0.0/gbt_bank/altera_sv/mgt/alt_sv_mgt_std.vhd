--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Stratix V - Multi Gigabit Transceivers standard
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Altera Stratix V                                                      
-- Tool version:          Quartus II 14.0                                                              
--                                                                                                   
-- Revision:              3.3                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        18/03/2014   3.0       M. Barros Marin   First .vhd module definition           
--
--                        05/10/2014   3.2       M. Barros Marin   - Added port "GBTRX_MGTTX_RDY_O"
--                                                                 - Minor modifications          
--
--                        09/02/2015   3.3       M. Barros Marin   - Minor modifications          
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
library alt_sv_gx_std_x1;
library alt_sv_gx_std_x2;
library alt_sv_gx_std_x3;
library gx_std_x4;
library gx_std_x5;
library gx_std_x6;

library alt_sv_gx_reconfctrl_x1;
library alt_sv_gx_reconfctrl_x2;
library alt_sv_gx_reconfctrl_x3;
library mgt_reconfctrl_x4;
library mgt_reconfctrl_x5;
library mgt_reconfctrl_x6;

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
   
   signal txAnalogReset_from_gxRstCtrl          : std_logic_vector     (1 to NUM_LINKS);
   signal txDigitalReset_from_gxRstCtrl         : std_logic_vector     (1 to NUM_LINKS);
   signal txReady_from_gxRstCtrl                : std_logic_vector     (1 to NUM_LINKS);
   ---------------------------------------------
   signal rxAnalogreset_from_gxRstCtrl          : std_logic_vector     (1 to NUM_LINKS);
   signal rxDigitalreset_from_gxRstCtrl         : std_logic_vector     (1 to NUM_LINKS);
   signal rxReady_from_gxRstCtrl                : std_logic_vector     (1 to NUM_LINKS);

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

   signal rxIsLockedToData_from_gxStd           : std_logic_vector     (1 to NUM_LINKS);   
   signal txCalBusy_from_gxStd                  : std_logic_vector     (1 to NUM_LINKS);
   signal rxCalBusy_from_gxStd                  : std_logic_vector     (1 to NUM_LINKS); 
   
	signal reconfToXCVR										: std_logic_vector			  ((NUM_LINKS*70)-1 downto 0);
	signal XCVRToReconf										: std_logic_vector			  ((NUM_LINKS*46)-1 downto 0);
   
	signal tx_usrclk											: std_logic_vector			  ((NUM_LINKS-1) downto 0);
	signal rx_usrclk											: std_logic_vector			  ((NUM_LINKS-1) downto 0);
   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
	--==================================== User Logic =====================================-- 
  
	--=============--
	-- Assignments --
	--=============--
  
	commonAssign_gen: for i in 1 to NUM_LINKS generate

     MGT_O.mgtLink(i).rxWordClkReady           <= rxReady_from_gxRstCtrl(i);
     GBTRX_RXWORDCLK_READY_O(i)                <= rxReady_from_gxRstCtrl(i);      
     MGT_O.mgtLink(i).txCal_busy               <= txCalBusy_from_gxStd(i);
     MGT_O.mgtLink(i).rxCal_busy               <= rxCalBusy_from_gxStd(i);
     MGT_O.mgtLink(i).ready                    <= txReady_from_gxRstCtrl(i) and rxReady_from_gxRstCtrl(i);
     MGT_O.mgtLink(i).tx_ready                 <= txReady_from_gxRstCtrl(i);
     MGT_O.mgtLink(i).rx_ready                 <= rxReady_from_gxRstCtrl(i);
     GBTTX_MGTTX_RDY_O(i)                      <= txReady_from_gxRstCtrl(i);         
     GBTRX_MGTRX_RDY_O(i)                      <= rxReady_from_gxRstCtrl(i);           
     MGT_O.mgtLink(i).rxIsLocked_toData        <= rxIsLockedToData_from_gxStd(i);
     
	end generate;
	
	--======================--
	-- GX reset controllers --
	--======================--      
	gxRstCtrl_gen: for i in 1 to NUM_LINKS generate
  
     gxRstCtrl: entity work.alt_sv_mgt_resetctrl       
        port map (
           CLK_I                               => MGT_CLKS_I.mgtRefClk,                          
           ------------------------------------         
           TX_RESET_I                          => MGT_I.mgtLink(i).tx_reset,    
           RX_RESET_I                          => MGT_I.mgtLink(i).rx_reset,    
           ------------------------------------          
           TX_ANALOGRESET_O                    => txAnalogReset_from_gxRstCtrl(i),
           TX_DIGITALRESET_O                   => txDigitalReset_from_gxRstCtrl(i),                  
           TX_READY_O                          => txReady_from_gxRstCtrl(i),                         
           PLL_LOCKED_I                        => ATXPLLLocked,                       
           TX_CAL_BUSY_I                       => txCalBusy_from_gxStd(i),                          
           ------------------------------------          
           RX_ANALOGRESET_O                    => rxAnalogreset_from_gxRstCtrl(i),
           RX_DIGITALRESET_O                   => rxDigitalreset_from_gxRstCtrl(i),                          
           RX_READY_O                          => rxReady_from_gxRstCtrl(i),                         
           RX_IS_LOCKEDTODATA_I                => rxIsLockedToData_from_gxStd(i),                     
           RX_CAL_BUSY_I                       => rxCalBusy_from_gxStd(i)                                 
        );
  
	end generate;
	
	--================================================--
	-- ATX PLL													  --
	--================================================-- 
	atx_pll: entity work.alt_sv_mgt_txpll
		port map (      
			RESET_I             => MGT_I.mgtLink(1).tx_reset,
			
			MGT_REFCLK_I        => MGT_CLKS_I.mgtRefClk,
			FEEDBACK_CLK_I      => '0',
			
			EXTGXTXPLL_CLK_O    => ATXPLL_clkout,
			
			LOCKED_O            => ATXPLLLocked,
							
			RECONFIG_I          => reconfToATXPLL,
			RECONFIG_O          => ATXPLLToReconf
		);
	
	--=======================================--
	-- Multi-Gigabit Transceivers (standard) --
	--=======================================--
  
  -- MGT standard x1:
  -------------------
	
	gxStd_x1_gen: if NUM_LINKS = 1 generate
     	  
     reconfGxStd_x1: entity alt_sv_gx_reconfctrl_x1.alt_sv_gx_reconfctrl_x1
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
		
     gxStd_x1: entity alt_sv_gx_std_x1.alt_sv_gx_std_x1
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),       
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,          
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
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
	
	gxStd_x2_gen: if NUM_LINKS = 2 generate
     	  
     reconfGxStd_x2: entity alt_sv_gx_reconfctrl_x2.alt_sv_gx_reconfctrl_x2
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
		
     gxStd_x2: entity alt_sv_gx_std_x2.alt_sv_gx_std_x2
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_ANALOGRESET(1)                   => txAnalogReset_from_gxRstCtrl(2),
			  
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),  
           TX_DIGITALRESET(1)                  => txDigitalReset_from_gxRstCtrl(2),    
			  
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_ANALOGRESET(1)                   => rxAnalogReset_from_gxRstCtrl(2),
			  
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
           RX_DIGITALRESET(1)                  => rxDigitalReset_from_gxRstCtrl(2),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,  
           EXT_PLL_CLK(1)                      => ATXPLL_clkout,   
			  
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
			  
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gxStd(2),
			  
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           TX_CAL_BUSY(1)                      => txCalBusy_from_gxStd(2),
			  
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
           RX_CAL_BUSY(1)                      => rxCalBusy_from_gxStd(2),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,
			  
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,
			  
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
           RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
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
	
	gxStd_x3_gen: if NUM_LINKS = 3 generate
     	  
     reconfGxStd_x3: entity alt_sv_gx_reconfctrl_x3.alt_sv_gx_reconfctrl_x3
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
		
     gxStd_x3: entity alt_sv_gx_std_x3.alt_sv_gx_std_x3
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_ANALOGRESET(1)                   => txAnalogReset_from_gxRstCtrl(2),
           TX_ANALOGRESET(2)                   => txAnalogReset_from_gxRstCtrl(3),
			  
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),  
           TX_DIGITALRESET(1)                  => txDigitalReset_from_gxRstCtrl(2),  
           TX_DIGITALRESET(2)                  => txDigitalReset_from_gxRstCtrl(3),    
			  
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_ANALOGRESET(1)                   => rxAnalogReset_from_gxRstCtrl(2), 
           RX_ANALOGRESET(2)                   => rxAnalogReset_from_gxRstCtrl(3),
			  
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
           RX_DIGITALRESET(1)                  => rxDigitalReset_from_gxRstCtrl(2),
           RX_DIGITALRESET(2)                  => rxDigitalReset_from_gxRstCtrl(3),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,  
           EXT_PLL_CLK(1)                      => ATXPLL_clkout,
           EXT_PLL_CLK(2)                      => ATXPLL_clkout,     
			  
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(2)                => MGT_O.mgtLink(3).rxIsLocked_toRef,
			  
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gxStd(2),
           RX_IS_LOCKEDTODATA (2)              => rxIsLockedToData_from_gxStd(3),
			  
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           TX_CAL_BUSY(1)                      => txCalBusy_from_gxStd(2),
           TX_CAL_BUSY(2)                      => txCalBusy_from_gxStd(3),
			  
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
           RX_CAL_BUSY(1)                      => rxCalBusy_from_gxStd(2),
           RX_CAL_BUSY(2)                      => rxCalBusy_from_gxStd(3),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,
           RX_SERIALLPBKEN(2)                  => MGT_I.mgtLink(3).loopBack,
			  
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,
           TX_STD_POLINV(2)                    => MGT_I.mgtLink(3).tx_polarity,
			  
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
           RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,
           RX_STD_POLINV(2)                    => MGT_I.mgtLink(3).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
           TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData,
           TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData,
           TX_SERIAL_DATA(2)                   => MGT_O.mgtLink(3).txSerialData,  
			  
           RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,
           RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,
           RX_SERIAL_DATA(2)                   => MGT_I.mgtLink(3).rxSerialData,  
			  
			  TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
           TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
           TX_PARALLEL_DATA( 119 downto 80)    => GBTTX_WORD_I(3),
				
           RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
           RX_PARALLEL_DATA( 79 downto 40)     => GBTRX_WORD_O(2),
           RX_PARALLEL_DATA( 119 downto 80)    => GBTRX_WORD_O(3) 
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
	
  -- MGT standard x4:
  -------------------
	
	gxStd_x4_gen: if NUM_LINKS = 4 generate
     	  
     reconfGxStd_x4: entity mgt_reconfctrl_x4.mgt_reconfctrl_x4
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
				
				CH0_3_TO_XCVR                                     => reconfToXCVR,  
				CH0_3_FROM_XCVR                                   => XCVRToReconf,
				
				CH4_4_TO_XCVR                                     => reconfToATXPLL,
				CH4_4_FROM_XCVR                                   => ATXPLLToReconf 
			);
		
     gxStd_x4: entity gx_std_x4.gx_std_x4
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_ANALOGRESET(1)                   => txAnalogReset_from_gxRstCtrl(2),
           TX_ANALOGRESET(2)                   => txAnalogReset_from_gxRstCtrl(3),
           TX_ANALOGRESET(3)                   => txAnalogReset_from_gxRstCtrl(4),
			  
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),  
           TX_DIGITALRESET(1)                  => txDigitalReset_from_gxRstCtrl(2),  
           TX_DIGITALRESET(2)                  => txDigitalReset_from_gxRstCtrl(3),   
           TX_DIGITALRESET(3)                  => txDigitalReset_from_gxRstCtrl(4),    
			  
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_ANALOGRESET(1)                   => rxAnalogReset_from_gxRstCtrl(2), 
           RX_ANALOGRESET(2)                   => rxAnalogReset_from_gxRstCtrl(3), 
           RX_ANALOGRESET(3)                   => rxAnalogReset_from_gxRstCtrl(4),
			  
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
           RX_DIGITALRESET(1)                  => rxDigitalReset_from_gxRstCtrl(2),
           RX_DIGITALRESET(2)                  => rxDigitalReset_from_gxRstCtrl(3),
           RX_DIGITALRESET(3)                  => rxDigitalReset_from_gxRstCtrl(4),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,  
           EXT_PLL_CLK(1)                      => ATXPLL_clkout,
           EXT_PLL_CLK(2)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(3)                      => ATXPLL_clkout,    
			  
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(2)                => MGT_O.mgtLink(3).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(3)                => MGT_O.mgtLink(4).rxIsLocked_toRef,
			  
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gxStd(2),
           RX_IS_LOCKEDTODATA (2)              => rxIsLockedToData_from_gxStd(3),
           RX_IS_LOCKEDTODATA (3)              => rxIsLockedToData_from_gxStd(4),
			  
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           TX_CAL_BUSY(1)                      => txCalBusy_from_gxStd(2),
           TX_CAL_BUSY(2)                      => txCalBusy_from_gxStd(3),
           TX_CAL_BUSY(3)                      => txCalBusy_from_gxStd(4),
			  
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
           RX_CAL_BUSY(1)                      => rxCalBusy_from_gxStd(2),
           RX_CAL_BUSY(2)                      => rxCalBusy_from_gxStd(3),
           RX_CAL_BUSY(3)                      => rxCalBusy_from_gxStd(4),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,
           RX_SERIALLPBKEN(2)                  => MGT_I.mgtLink(3).loopBack,
           RX_SERIALLPBKEN(3)                  => MGT_I.mgtLink(4).loopBack,
			  
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,
           TX_STD_POLINV(2)                    => MGT_I.mgtLink(3).tx_polarity,
           TX_STD_POLINV(3)                    => MGT_I.mgtLink(4).tx_polarity,
			  
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
           RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,
           RX_STD_POLINV(2)                    => MGT_I.mgtLink(3).rx_polarity,
           RX_STD_POLINV(3)                    => MGT_I.mgtLink(4).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
           TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData,
           TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData,
           TX_SERIAL_DATA(2)                   => MGT_O.mgtLink(3).txSerialData,
           TX_SERIAL_DATA(3)                   => MGT_O.mgtLink(4).txSerialData,  
			  
           RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,
           RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,
           RX_SERIAL_DATA(2)                   => MGT_I.mgtLink(3).rxSerialData,
           RX_SERIAL_DATA(3)                   => MGT_I.mgtLink(4).rxSerialData,  
			  
			  TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
           TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
           TX_PARALLEL_DATA( 119 downto 80)    => GBTTX_WORD_I(3),
           TX_PARALLEL_DATA( 159 downto 120)   => GBTTX_WORD_I(4),
				
           RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
           RX_PARALLEL_DATA( 79 downto 40)     => GBTRX_WORD_O(2),
           RX_PARALLEL_DATA( 119 downto 80)    => GBTRX_WORD_O(3),
           RX_PARALLEL_DATA( 159 downto 120)   => GBTRX_WORD_O(4)  
        );
     
               
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);	
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);		
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);		
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);		
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);		
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);			
			
	end generate;
	
  -- MGT standard x5:
  -------------------
	
	gxStd_x5_gen: if NUM_LINKS = 5 generate
     	  
     reconfGxStd_x5: entity mgt_reconfctrl_x5.mgt_reconfctrl_x5
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
				
				CH0_4_TO_XCVR                                     => reconfToXCVR,  
				CH0_4_FROM_XCVR                                   => XCVRToReconf,
				
				CH5_5_TO_XCVR                                     => reconfToATXPLL,
				CH5_5_FROM_XCVR                                   => ATXPLLToReconf 
			);
		
     gxStd_x5: entity gx_std_x5.gx_std_x5
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_ANALOGRESET(1)                   => txAnalogReset_from_gxRstCtrl(2),
           TX_ANALOGRESET(2)                   => txAnalogReset_from_gxRstCtrl(3),
           TX_ANALOGRESET(3)                   => txAnalogReset_from_gxRstCtrl(4),
           TX_ANALOGRESET(4)                   => txAnalogReset_from_gxRstCtrl(5),
			  
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),  
           TX_DIGITALRESET(1)                  => txDigitalReset_from_gxRstCtrl(2),  
           TX_DIGITALRESET(2)                  => txDigitalReset_from_gxRstCtrl(3),   
           TX_DIGITALRESET(3)                  => txDigitalReset_from_gxRstCtrl(4),  
           TX_DIGITALRESET(4)                  => txDigitalReset_from_gxRstCtrl(5),     
			  
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_ANALOGRESET(1)                   => rxAnalogReset_from_gxRstCtrl(2), 
           RX_ANALOGRESET(2)                   => rxAnalogReset_from_gxRstCtrl(3), 
           RX_ANALOGRESET(3)                   => rxAnalogReset_from_gxRstCtrl(4), 
           RX_ANALOGRESET(4)                   => rxAnalogReset_from_gxRstCtrl(5),
			  
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
           RX_DIGITALRESET(1)                  => rxDigitalReset_from_gxRstCtrl(2),
           RX_DIGITALRESET(2)                  => rxDigitalReset_from_gxRstCtrl(3),
           RX_DIGITALRESET(3)                  => rxDigitalReset_from_gxRstCtrl(4),
           RX_DIGITALRESET(4)                  => rxDigitalReset_from_gxRstCtrl(5),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,  
           EXT_PLL_CLK(1)                      => ATXPLL_clkout,
           EXT_PLL_CLK(2)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(3)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(4)                      => ATXPLL_clkout,    
			  
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(2)                => MGT_O.mgtLink(3).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(3)                => MGT_O.mgtLink(4).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(4)                => MGT_O.mgtLink(5).rxIsLocked_toRef,
			  
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gxStd(2),
           RX_IS_LOCKEDTODATA (2)              => rxIsLockedToData_from_gxStd(3),
           RX_IS_LOCKEDTODATA (3)              => rxIsLockedToData_from_gxStd(4),
           RX_IS_LOCKEDTODATA (4)              => rxIsLockedToData_from_gxStd(5),
			  
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           TX_CAL_BUSY(1)                      => txCalBusy_from_gxStd(2),
           TX_CAL_BUSY(2)                      => txCalBusy_from_gxStd(3),
           TX_CAL_BUSY(3)                      => txCalBusy_from_gxStd(4),
           TX_CAL_BUSY(4)                      => txCalBusy_from_gxStd(5),
			  
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
           RX_CAL_BUSY(1)                      => rxCalBusy_from_gxStd(2),
           RX_CAL_BUSY(2)                      => rxCalBusy_from_gxStd(3),
           RX_CAL_BUSY(3)                      => rxCalBusy_from_gxStd(4),
           RX_CAL_BUSY(4)                      => rxCalBusy_from_gxStd(5),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,
           RX_SERIALLPBKEN(2)                  => MGT_I.mgtLink(3).loopBack,
           RX_SERIALLPBKEN(3)                  => MGT_I.mgtLink(4).loopBack,
           RX_SERIALLPBKEN(4)                  => MGT_I.mgtLink(5).loopBack,
			  
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,
           TX_STD_POLINV(2)                    => MGT_I.mgtLink(3).tx_polarity,
           TX_STD_POLINV(3)                    => MGT_I.mgtLink(4).tx_polarity,
           TX_STD_POLINV(4)                    => MGT_I.mgtLink(5).tx_polarity,
			  
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
           RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,
           RX_STD_POLINV(2)                    => MGT_I.mgtLink(3).rx_polarity,
           RX_STD_POLINV(3)                    => MGT_I.mgtLink(4).rx_polarity,
           RX_STD_POLINV(4)                    => MGT_I.mgtLink(5).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
           TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData,
           TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData,
           TX_SERIAL_DATA(2)                   => MGT_O.mgtLink(3).txSerialData,
           TX_SERIAL_DATA(3)                   => MGT_O.mgtLink(4).txSerialData,
           TX_SERIAL_DATA(4)                   => MGT_O.mgtLink(5).txSerialData,  
			  
           RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,
           RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,
           RX_SERIAL_DATA(2)                   => MGT_I.mgtLink(3).rxSerialData,
           RX_SERIAL_DATA(3)                   => MGT_I.mgtLink(4).rxSerialData,
           RX_SERIAL_DATA(4)                   => MGT_I.mgtLink(5).rxSerialData,  
			  
			  TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
           TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
           TX_PARALLEL_DATA( 119 downto 80)    => GBTTX_WORD_I(3),
           TX_PARALLEL_DATA( 159 downto 120)   => GBTTX_WORD_I(4),
           TX_PARALLEL_DATA( 199 downto 160)   => GBTTX_WORD_I(5),
				
           RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
           RX_PARALLEL_DATA( 79 downto 40)     => GBTRX_WORD_O(2),
           RX_PARALLEL_DATA( 119 downto 80)    => GBTRX_WORD_O(3),
           RX_PARALLEL_DATA( 159 downto 120)   => GBTRX_WORD_O(4),
           RX_PARALLEL_DATA( 199 downto 160)   => GBTRX_WORD_O(5)   
        );
     
               
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);	
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);		
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);		
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);		
			MGT_CLKS_O.tx_wordClk(5) <= tx_usrclk(4);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);		
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);		
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);	
			MGT_CLKS_O.rx_wordClk(5) <= rx_usrclk(4);
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			TX_WORDCLK_O(5) <= tx_usrclk(4);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);
			RX_WORDCLK_O(5) <= rx_usrclk(4);				
			
	end generate;
	
  -- MGT standard x6:
  -------------------
	
	gxStd_x6_gen: if NUM_LINKS = 6 generate
     	  
     reconfGxStd_x6: entity mgt_reconfctrl_x6.mgt_reconfctrl_x6
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
				
				CH0_5_TO_XCVR                                     => reconfToXCVR,  
				CH0_5_FROM_XCVR                                   => XCVRToReconf,
				
				CH6_6_TO_XCVR                                     => reconfToATXPLL,
				CH6_6_FROM_XCVR                                   => ATXPLLToReconf 
			);
		
     gxStd_x6: entity gx_std_x6.gx_std_x6
        port map (
			  -- Reset 
           PLL_POWERDOWN(0)                    => MGT_I.mgtLink(1).tx_reset,    
			  
           TX_ANALOGRESET(0)                   => txAnalogReset_from_gxRstCtrl(1),
           TX_ANALOGRESET(1)                   => txAnalogReset_from_gxRstCtrl(2),
           TX_ANALOGRESET(2)                   => txAnalogReset_from_gxRstCtrl(3),
           TX_ANALOGRESET(3)                   => txAnalogReset_from_gxRstCtrl(4),
           TX_ANALOGRESET(4)                   => txAnalogReset_from_gxRstCtrl(5),
           TX_ANALOGRESET(5)                   => txAnalogReset_from_gxRstCtrl(6),
			  
           TX_DIGITALRESET(0)                  => txDigitalReset_from_gxRstCtrl(1),  
           TX_DIGITALRESET(1)                  => txDigitalReset_from_gxRstCtrl(2),  
           TX_DIGITALRESET(2)                  => txDigitalReset_from_gxRstCtrl(3),   
           TX_DIGITALRESET(3)                  => txDigitalReset_from_gxRstCtrl(4),  
           TX_DIGITALRESET(4)                  => txDigitalReset_from_gxRstCtrl(5),   
           TX_DIGITALRESET(5)                  => txDigitalReset_from_gxRstCtrl(6),    
			  
           RX_ANALOGRESET(0)                   => rxAnalogReset_from_gxRstCtrl(1), 
           RX_ANALOGRESET(1)                   => rxAnalogReset_from_gxRstCtrl(2), 
           RX_ANALOGRESET(2)                   => rxAnalogReset_from_gxRstCtrl(3), 
           RX_ANALOGRESET(3)                   => rxAnalogReset_from_gxRstCtrl(4), 
           RX_ANALOGRESET(4)                   => rxAnalogReset_from_gxRstCtrl(5), 
           RX_ANALOGRESET(5)                   => rxAnalogReset_from_gxRstCtrl(6),
			  
           RX_DIGITALRESET(0)                  => rxDigitalReset_from_gxRstCtrl(1),
           RX_DIGITALRESET(1)                  => rxDigitalReset_from_gxRstCtrl(2),
           RX_DIGITALRESET(2)                  => rxDigitalReset_from_gxRstCtrl(3),
           RX_DIGITALRESET(3)                  => rxDigitalReset_from_gxRstCtrl(4),
           RX_DIGITALRESET(4)                  => rxDigitalReset_from_gxRstCtrl(5),
           RX_DIGITALRESET(5)                  => rxDigitalReset_from_gxRstCtrl(6),
			         
			  -- Clocks
           EXT_PLL_CLK(0)                      => ATXPLL_clkout,  
           EXT_PLL_CLK(1)                      => ATXPLL_clkout,
           EXT_PLL_CLK(2)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(3)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(4)                      => ATXPLL_clkout, 
           EXT_PLL_CLK(5)                      => ATXPLL_clkout,    
			  
           RX_CDR_REFCLK(0)                    => MGT_CLKS_I.mgtRefClk,              
           
           TX_STD_CORECLKIN                	  => tx_usrclk,      
           RX_STD_CORECLKIN                	  => rx_usrclk, 
			      
           TX_STD_CLKOUT                    	  => tx_usrclk,         
           RX_STD_CLKOUT                       => rx_usrclk,  
			  
			  -- Status
			  RX_IS_LOCKEDTOREF(0)                => MGT_O.mgtLink(1).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(1)                => MGT_O.mgtLink(2).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(2)                => MGT_O.mgtLink(3).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(3)                => MGT_O.mgtLink(4).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(4)                => MGT_O.mgtLink(5).rxIsLocked_toRef,
			  RX_IS_LOCKEDTOREF(5)                => MGT_O.mgtLink(6).rxIsLocked_toRef,
			  
           RX_IS_LOCKEDTODATA (0)              => rxIsLockedToData_from_gxStd(1),
           RX_IS_LOCKEDTODATA (1)              => rxIsLockedToData_from_gxStd(2),
           RX_IS_LOCKEDTODATA (2)              => rxIsLockedToData_from_gxStd(3),
           RX_IS_LOCKEDTODATA (3)              => rxIsLockedToData_from_gxStd(4),
           RX_IS_LOCKEDTODATA (4)              => rxIsLockedToData_from_gxStd(5),
           RX_IS_LOCKEDTODATA (5)              => rxIsLockedToData_from_gxStd(6),
			  
           TX_CAL_BUSY(0)                      => txCalBusy_from_gxStd(1),
           TX_CAL_BUSY(1)                      => txCalBusy_from_gxStd(2),
           TX_CAL_BUSY(2)                      => txCalBusy_from_gxStd(3),
           TX_CAL_BUSY(3)                      => txCalBusy_from_gxStd(4),
           TX_CAL_BUSY(4)                      => txCalBusy_from_gxStd(5),
           TX_CAL_BUSY(5)                      => txCalBusy_from_gxStd(6),
			  
           RX_CAL_BUSY(0)                      => rxCalBusy_from_gxStd(1),
           RX_CAL_BUSY(1)                      => rxCalBusy_from_gxStd(2),
           RX_CAL_BUSY(2)                      => rxCalBusy_from_gxStd(3),
           RX_CAL_BUSY(3)                      => rxCalBusy_from_gxStd(4),
           RX_CAL_BUSY(4)                      => rxCalBusy_from_gxStd(5),
           RX_CAL_BUSY(5)                      => rxCalBusy_from_gxStd(6),
			  
			  -- Control
           RX_SERIALLPBKEN(0)                  => MGT_I.mgtLink(1).loopBack,
           RX_SERIALLPBKEN(1)                  => MGT_I.mgtLink(2).loopBack,
           RX_SERIALLPBKEN(2)                  => MGT_I.mgtLink(3).loopBack,
           RX_SERIALLPBKEN(3)                  => MGT_I.mgtLink(4).loopBack,
           RX_SERIALLPBKEN(4)                  => MGT_I.mgtLink(5).loopBack,
           RX_SERIALLPBKEN(5)                  => MGT_I.mgtLink(6).loopBack,
			  
           TX_STD_POLINV(0)                    => MGT_I.mgtLink(1).tx_polarity,
           TX_STD_POLINV(1)                    => MGT_I.mgtLink(2).tx_polarity,
           TX_STD_POLINV(2)                    => MGT_I.mgtLink(3).tx_polarity,
           TX_STD_POLINV(3)                    => MGT_I.mgtLink(4).tx_polarity,
           TX_STD_POLINV(4)                    => MGT_I.mgtLink(5).tx_polarity,
           TX_STD_POLINV(5)                    => MGT_I.mgtLink(6).tx_polarity,
			  
           RX_STD_POLINV(0)                    => MGT_I.mgtLink(1).rx_polarity,
           RX_STD_POLINV(1)                    => MGT_I.mgtLink(2).rx_polarity,
           RX_STD_POLINV(2)                    => MGT_I.mgtLink(3).rx_polarity,
           RX_STD_POLINV(3)                    => MGT_I.mgtLink(4).rx_polarity,
           RX_STD_POLINV(4)                    => MGT_I.mgtLink(5).rx_polarity,
           RX_STD_POLINV(5)                    => MGT_I.mgtLink(6).rx_polarity,
			  
			  -- Reconfig
           RECONFIG_TO_XCVR                    => reconfToXCVR,  
           RECONFIG_FROM_XCVR                  => XCVRToReconf,
			  
			  -- Data
           TX_SERIAL_DATA(0)                   => MGT_O.mgtLink(1).txSerialData,
           TX_SERIAL_DATA(1)                   => MGT_O.mgtLink(2).txSerialData,
           TX_SERIAL_DATA(2)                   => MGT_O.mgtLink(3).txSerialData,
           TX_SERIAL_DATA(3)                   => MGT_O.mgtLink(4).txSerialData,
           TX_SERIAL_DATA(4)                   => MGT_O.mgtLink(5).txSerialData,
           TX_SERIAL_DATA(5)                   => MGT_O.mgtLink(6).txSerialData,  
			  
           RX_SERIAL_DATA(0)                   => MGT_I.mgtLink(1).rxSerialData,
           RX_SERIAL_DATA(1)                   => MGT_I.mgtLink(2).rxSerialData,
           RX_SERIAL_DATA(2)                   => MGT_I.mgtLink(3).rxSerialData,
           RX_SERIAL_DATA(3)                   => MGT_I.mgtLink(4).rxSerialData,
           RX_SERIAL_DATA(4)                   => MGT_I.mgtLink(5).rxSerialData,
           RX_SERIAL_DATA(5)                   => MGT_I.mgtLink(6).rxSerialData,  
			  
			  TX_PARALLEL_DATA( 39 downto  0)     => GBTTX_WORD_I(1),
           TX_PARALLEL_DATA( 79 downto 40)     => GBTTX_WORD_I(2),
           TX_PARALLEL_DATA( 119 downto 80)    => GBTTX_WORD_I(3),
           TX_PARALLEL_DATA( 159 downto 120)   => GBTTX_WORD_I(4),
           TX_PARALLEL_DATA( 199 downto 160)   => GBTTX_WORD_I(5),
           TX_PARALLEL_DATA( 239 downto 200)   => GBTTX_WORD_I(6),
				
           RX_PARALLEL_DATA( 39 downto  0)     => GBTRX_WORD_O(1),
           RX_PARALLEL_DATA( 79 downto 40)     => GBTRX_WORD_O(2),
           RX_PARALLEL_DATA( 119 downto 80)    => GBTRX_WORD_O(3),
           RX_PARALLEL_DATA( 159 downto 120)   => GBTRX_WORD_O(4),
           RX_PARALLEL_DATA( 199 downto 160)   => GBTRX_WORD_O(5),
           RX_PARALLEL_DATA( 239 downto 200)   => GBTRX_WORD_O(6)   
        );
     
               
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);	
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);		
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);		
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);		
			MGT_CLKS_O.tx_wordClk(5) <= tx_usrclk(4);		
			MGT_CLKS_O.tx_wordClk(6) <= tx_usrclk(5);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);	
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);		
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);		
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);	
			MGT_CLKS_O.rx_wordClk(5) <= rx_usrclk(4);
			MGT_CLKS_O.rx_wordClk(6) <= rx_usrclk(5);
			
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			TX_WORDCLK_O(5) <= tx_usrclk(4);
			TX_WORDCLK_O(6) <= tx_usrclk(5);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);
			RX_WORDCLK_O(5) <= rx_usrclk(4);
			RX_WORDCLK_O(6) <= rx_usrclk(5);					
			
	end generate;
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--