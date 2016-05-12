--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Julian Mendez (julian.mendez@cern.ch)
--                        (Original design by P. Vichoudis (CERN) & M. Barros Marin)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Arria X - GBT Bank package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Arria X                                                          
-- Tool version:          Quartus II 14.0                                                                
--                                                                                                   
-- Revision:              3.1                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        18/02/2016   3.0       J. Mendez		   - First .vhd package definition           
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

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package vendor_specific_gbt_bank_package is
   
   --=================================== GBT Bank setup ==================================--
   constant ATXPLL								: integer := 0;
   constant FPLL								: integer := 1;
	
   constant XCVR_TX_PLL						    : integer := ATXPLL;
   constant MAX_NUM_GBT_LINK                    : integer :=  6;
   constant WORD_WIDTH                          : integer := 20; 
   constant WORD_ADDR_MSB                       : integer :=  5;
   constant WORD_ADDR_PS_CHECK_MSB              : integer :=  2;
   constant GBTRX_BITSLIP_NBR_MSB               : integer :=  5;
   constant GBTRX_BITSLIP_NBR_MAX               : integer := 19;
   constant GBTRX_BITSLIP_MIN_DLY               : integer := 20;
   constant GBTRX_BITSLIP_MGT_RX_RESET_DELAY    : integer := 25e3;
   constant RXFRAMECLK_STEPS_MSB                : integer :=  2;
   constant RXFRAMECLK_STEPS_NBR_MAX            : integer :=  6;
   
   --=====================================================================================--
   
   --================================ Record Declarations ================================--   
   
   --====================--
   -- User setup package --
   --====================--
      
   type gbt_bank_user_setup_R is 
   record
   
      -- Number of links:
      -------------------
      
      -- Comment:   The number of links per GBT Bank is device dependant (up to THREE links on Stratix V).  
      
      NUM_LINKS                                 : integer;
      
      -- GBT Bank optimization:
      -------------------------

      -- Comment:   (0 -> STANDARD | 1 -> LATENCY_OPTIMIZED)  
      
      TX_OPTIMIZATION                           : integer range 0 to 1; 
      RX_OPTIMIZATION                           : integer range 0 to 1; 
      
      -- GBT encodings:
      -----------------
      
      -- Comment:   (0 -> GBT_FRAME | 1 -> WIDE_BUS | 2 -> GBT_8B10B)
      
      TX_ENCODING                               : integer range 0 to 2;
      RX_ENCODING                               : integer range 0 to 2;
      
   end record;  
   
   --===============--
   -- GX bank (MGT) --
   --===============--
   
   -- Clocks scheme:
   -----------------
   
   type gbtBankMgtClks_i_R is
   record         
      mgtRefClk                                 : std_logic;
      txFrameClk                                : std_logic;
   end record;   
   
   type gbtBankMgtClks_o_R is
   record
      tx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);         
   end record;   
   
   -- Common I/O:
   --------------
   
   type mgtCommon_i_R is
   record
		
		-- Reconfigurator
		reconf_reset										: std_logic;
		reconf_clk											: std_logic;
		reconf_avmm_addr									: std_logic_vector(12 downto 0);
		reconf_avmm_read									: std_logic;
		reconf_avmm_write									: std_logic;
		reconf_avmm_writedata							: std_logic_vector(31 downto 0);
		
   end record;   
   
   type mgtCommon_o_R is
   record
	
		-- Reconfigurator
		reconf_avmm_readdata								: std_logic_vector(31 downto 0);
		reconf_avmm_waitrequest							: std_logic;
		
   end record;   
   
   -- Links I/O:
   -------------
   
   type mgtLink_i_R is
   record
      tx_reset                                  : std_logic; 
      rx_reset                                  : std_logic;      
      ------------------------------------------         
      rxSerialData                              : std_logic; 
      ------------------------------------------
      loopBack                                  : std_logic;
      ------------------------------------------
      tx_polarity                               : std_logic; 
      rx_polarity                               : std_logic; 
      ------------------------------------------         
      rxBitSlip_enable                          : std_logic; 
      rxBitSlip_ctrl                            : std_logic; 
      rxBitSlip_nbr                             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      rxBitSlip_run                             : std_logic; 
      rxBitSlip_oddRstEn                        : std_logic; 
   end record;
   
   type mgtLink_o_R is
   record
      tx_ready                                  : std_logic;
      rx_ready                                  : std_logic;      
      ready                                     : std_logic;
      ------------------------------------------         
      rxBitSlip_oddRstNbr                       : std_logic_vector(7 downto 0);
      ------------------------------------------         
      rxWordClkReady                            : std_logic;
      ------------------------------------------         
      txSerialData                              : std_logic;
      ------------------------------------------         
      rxIsLocked_toRef                          : std_logic;                      
      rxIsLocked_toData                         : std_logic;     
      ------------------------------------------         
      txCal_busy                                : std_logic;                      
      rxCal_busy                                : std_logic;
   end record;
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
   
   --====================--
   -- User setup package --
   --====================--   
   
   type integer_A                               is array (natural range <>) of integer;   
   type gbt_bank_user_setup_R_A                 is array (natural range <>) of gbt_bank_user_setup_R;   
   
   type gbtframe_A                   				is array (natural range <>) of std_logic_vector(83  downto 0);
   type wbframe_A				                     is array (natural range <>) of std_logic_vector(115 downto 0);
   type wbframe_extra_A		                     is array (natural range <>) of std_logic_vector(31  downto 0);
	
   --===============--
   -- GX bank (MGT) --
   --===============--
   
   type mgtLink_i_R_A                           is array (natural range <>) of mgtLink_i_R;                          
   type mgtLink_o_R_A                           is array (natural range <>) of mgtLink_o_R;    
   
   type reconfig_to_xcvr_nx70bit_A              is array (natural range <>) of std_logic_vector(69 downto 0);
   type reconfig_from_xcvr_nx46bit_A            is array (natural range <>) of std_logic_vector(45 downto 0); 
   
   type frmClkPhAlSteps_nx6bit                  is array (natural range <>) of std_logic_vector( 5 downto 0);
   type rxBitSlipNbr_mxnbit_A                   is array (natural range <>) of std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);

   --=====================================================================================--   

   --========================== Finite State Machine (FSM) states ========================--
   
   --===============--
   -- GX bank (MGT) --
   --===============--
   
   -- TX_WORDCLK monitoring:
   -------------------------
   
   type txWordClkMonitoringFsmLatOpt_T          is (s0_idle, s1_txMgtReady, s2_dly, s3_stats, s4_waitRstEn, s5_thresholds, s6_resetMgtTx, s7_phaseOk);
   
   --========--                                                                                       
   -- GBT Rx --               
   --========--

   -- GBT Rx bitslip:
   -----------------

   type rxBitSlipCtrlStateLatOpt_T is (e0_idle, e1_evenOrOdd, e2_gtxRxReset, e3_bitslipOrFinish, e4_doBitslip, e5_waitNcycles);
   
   --=====================================================================================--
   
   --=============================== Constant Declarations ===============================--
  
   --====================--
   -- User setup package --
   --====================--
   -- Common:
	----------
	constant ENABLED										: integer := 1;
	constant DISABLED										: integer := 0;
   
   -- Optimization:
   ----------------
   
   constant STANDARD                            : integer := 0;
   constant LATENCY_OPTIMIZED                   : integer := 1;
   
   -- Encoding:
   ------------
   
   constant GBT_FRAME                           : integer := 0;
   constant WIDE_BUS                            : integer := 1;
   constant GBT_8B10B                           : integer := 2;
   
   --===============--
   -- GX bank (MGT) --
   --===============--

   -- TX_WORDCLK monitoring:
   -------------------------
   
   constant TXWORDCLK_INITIAL_DLY               : integer := (2**16);
   constant STATS_TIMEOUT                       : integer := (2**16)-1024;   -- Note!! Security margin.
   constant MGT_RESET_DLY                       : integer := 9;
   
   --=====================================================================================--   
end vendor_specific_gbt_bank_package;   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--