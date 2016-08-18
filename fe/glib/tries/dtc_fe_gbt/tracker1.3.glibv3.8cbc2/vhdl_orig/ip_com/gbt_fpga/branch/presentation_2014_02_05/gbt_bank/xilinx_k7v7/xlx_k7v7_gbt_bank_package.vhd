--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. VICHOUDIS & M. BARROS MARIN)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Kintex 7 & Virtex 7 - GBT Bank package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/10/2013   1.0       M. Barros Marin   - First .vhd package definition           
--
-- Additional Comments:                                                                                  
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Bank that !!
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
   
   constant MAX_NUM_GBT_LINK                    : integer :=  4;
   constant WORD_WIDTH                          : integer := 40; 
   constant WORD_ADDR_MSB                       : integer :=  4;
   constant WORD_ADDR_PS_CHECK_MSB              : integer :=  1;
   constant GBTRX_BITSLIP_NBR_MSB               : integer :=  5;
   constant GBTRX_BITSLIP_NBR_MAX               : integer := 39;
   constant GBTRX_BITSLIP_MIN_DLY               : integer := 40;   -- Comment: GBTRX_BITSLIP_MIN_DLY >= 32 RXUSRCLK2 cycles
   
   --=====================================================================================--
   
   --================================ Record Declarations ================================--   
   
   --====================--
   -- User setup package --
   --====================-- 
   
   --================================ Record Declarations ================================--
      
   type gbt_bank_user_setup_R is 
   record
   
      -- Number of links:
      -------------------
      
      -- Comment:   The number of links per GBT Bank is device dependant (up to FOUR links on Kintex 7 & Virtex 7).  
      
      NUM_LINKS                                 : integer;
      
      -- GBT Bank optimization:
      -------------------------

      -- Comment:   * "STD" -> Standard optimization 
      -- 
      --            * "LAT" -> Latency optimization
      
      OPTIMIZATION                              : string(1 to 3); 
      
      -- GBT encodings:
      -----------------
      
      -- Comment:   * These types are used for selecting whether the logic implied
      --              in the different encodings is implemented or not.
      --           
      --            * The encoding used by the GBT Bank is selected independently for TX 
      --              and RX at run time using the ports "encodingSel" of the GBT Bank
      --              module (these ports are listed in the records "gbtTx_i_R" and "gbtRx_i_R" 
      --              of the file: "..\gbt_bank\core_sources\gbt_bank_package.vhd").            
      
      TX_GBT_FRAME                              : boolean; 
      RX_GBT_FRAME                              : boolean;
      ------------------------------------------
      TX_WIDE_BUS                               : boolean; 
      RX_WIDE_BUS                               : boolean; 
      ------------------------------------------
      TX_8B10B                                  : boolean;       
      RX_8B10B                                  : boolean; 
      
      -- GTX reference clock:
      -----------------------
      
      -- Comment:   * Allowed STANDARD GTX frequencies: 96MHz, 120MHz, 150MHz, 160MHz, 192MHz, 200MHz, 240MHz,
      --                                                300MHz, 320MHz, 400MHz, 480MHz and 600MHz   
      --  
      --            * Note!! The reference clock frequency of the LATENCY-OPTIMIZED MGT can not be set by 
      --              the user. For the Kintex 7 & Virtex 7 GTX, it is fixed to 120MHz.   
      
      STD_MGT_REFCLK_FREQ                       : integer; 
      
      -- GTX buffer bypass alignment mode: 
      ------------------------------------
      
      RX_GTX_BUFFBYPASS_MANUAL                  : boolean;
      
      -- Simulation:        
      -------------- 
      
      SIMULATION                                : boolean;
   	SIM_GTRESET_SPEEDUP                       : boolean;        

   end record;  
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   -- Clocks scheme:
   -----------------
   
   type gbtBankMgtClks_i_R is
   record         
      mgtRefClk                                 : std_logic;
      ------------------------------------------
      sysClk                                    : std_logic;
      cpllLockDetClk                            : std_logic;   
      drpClk                                    : std_logic;
      ------------------------------------------
      tx_wordClk                                : std_logic;
      rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
   end record;   
   
   type gbtBankMgtClks_o_R is
   record
      tx_wordClk_noBuff                         : std_logic;
      rx_wordClk_noBuff                         : std_logic_vector(1 to MAX_NUM_GBT_LINK);         
   end record;   
   
   -- I/O:
   -------
   
   type mgt_i_R is
   record
      rx_p                                      : std_logic;                                 
      rx_n                                      : std_logic;         
      ------------------------------------------     
      loopBack                                  : std_logic_vector( 2 downto 0);              
      ------------------------------------------
      tx_reset                                  : std_logic; 
      rx_reset                                  : std_logic;             
      ------------------------------------------
      rx_slide_enable                           : std_logic; 
      rx_slide_ctrl                             : std_logic; 
      rx_slide_nbr                              : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      rx_slide_run                              : std_logic;
      ------------------------------------------               
      tx_diffCtrl                               : std_logic_vector( 3 downto 0);
      tx_postCursor                             : std_logic_vector( 4 downto 0);
      tx_preCursor                              : std_logic_vector( 4 downto 0);
      ------------------------------------------
      tx_polarity                               : std_logic;
      rx_polarity                               : std_logic;
      ------------------------------------------      
      drp_addr                                  : std_logic_vector( 8 downto 0);  
      drp_en                                    : std_logic;   
      drp_di                                    : std_logic_vector(15 downto 0); 
      drp_we                                    : std_logic;      
      ------------------------------------------      
      prbs_txSel                                : std_logic_vector( 2 downto 0);
      prbs_rxSel                                : std_logic_vector( 2 downto 0);
      prbs_txForceErr                           : std_logic;
      prbs_rxCntReset                           : std_logic;       
   end record;

   type mgt_o_R is
   record
      tx_p                                      : std_logic;
      tx_n                                      : std_logic;
      ------------------------------------------
      word                                      : std_logic_vector(WORD_WIDTH-1 downto 0); 
      ------------------------------------------                  
      cpll_lock                                 : std_logic;
      ------------------------------------------                  
      tx_resetDone                              : std_logic;      
      rx_resetDone                              : std_logic;      
      tx_fsmResetDoneOut                        : std_logic; 
      rx_fsmResetDoneOut                        : std_logic; 
      ------------------------------------------
      rx_cdrLock                                : std_logic; 
      ------------------------------------------
      rx_phMonitor                              : std_logic_vector(4 downto 0);
      rx_phSlipMonitor                          : std_logic_vector(4 downto 0);  
      ------------------------------------------            
      ready                                     : std_logic;
      rx_wordClk_aligned                        : std_logic;      
      ------------------------------------------
      eyeScanDataError                          : std_logic;
      ------------------------------------------                  
      drp_rdy                                   : std_logic;  
      drp_do                                    : std_logic_vector(15 downto 0);      
      ------------------------------------------                  
      prbs_rxErr                                : std_logic;
      ------------------------------------------     
      latOptGbtBank                             : std_logic;
   end record;   
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
   
   --====================--
   -- User setup package --
   --====================--   
   
   type gbt_bank_user_setup_R_A                 is array (natural range <>) of gbt_bank_user_setup_R;   
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   type mgt_i_R_A                               is array (natural range <>) of mgt_i_R;                          
   type mgt_o_R_A                               is array (natural range <>) of mgt_o_R;    
   
   type gtxTxDiffCtrl_4bit_A                    is array (natural range <>) of std_logic_vector( 3 downto 0); 
   type gtxTxCursor_5bit_A                      is array (natural range <>) of std_logic_vector( 4 downto 0); 
   ---------------------------------------------
   type gtxDrpAddr_8bit_A                       is array (natural range <>) of std_logic_vector( 7 downto 0); 
   type gtxDrpData_16bit_A                      is array (natural range <>) of std_logic_vector(15 downto 0); 
   ---------------------------------------------         
   type gtxLoopBack_3bit_A                      is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------         
   type gtxPrbsSel_3bit_A                       is array (natural range <>) of std_logic_vector( 2 downto 0); 
   
   type gbtRxSlideNbr_nbit_A                    is array (natural range <>) of std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   
   type mgtRefClkConf_bitVector_A               is array (0 to 7) of bit_vector(7 downto 0);
   type mgtRefClkConf_integer_A                 is array (0 to 7) of integer;     
         
   --=====================================================================================--   
   
   --=============================== Constant Declarations ===============================--
  
   --================--
   -- GTX quad (MGT) --
   --================-- 
  
   -- Allowed GTX reference clock frequencies:
   -------------------------------------------
   
   constant FREQ_96MHz                          : integer :=  0;
   constant FREQ_120MHz                         : integer :=  1;
   constant FREQ_150MHz                         : integer :=  2;
   constant FREQ_160MHz                         : integer :=  3;
   constant FREQ_192MHz                         : integer :=  4;
   constant FREQ_200MHz                         : integer :=  5;
   constant FREQ_240MHz                         : integer :=  6;
   constant FREQ_300MHz                         : integer :=  7;
   constant FREQ_320MHz                         : integer :=  8;
   constant FREQ_400MHz                         : integer :=  9;
   constant FREQ_480MHz                         : integer := 10;
   constant FREQ_600MHz                         : integer := 11;   
   
   -- -- GTX PLLs setup:
   -- ------------------     
   
   -- -- Comment: Multipliers and dividers of the GTX TX and RX PLLs.
   
   -- constant PLL_CP_CFG        : mgtRefClkConf_bitVector_A := (x"07", x"0D", x"0D", x"07", x"0D", x"0D", x"0D", x"0D");
   -- constant PLL_DIVSEL_FB     : mgtRefClkConf_integer_A   := (    5,     4,     4,     5,     2,    2,      2,     2);
   -- constant PLL_DIVSEL_REF    : mgtRefClkConf_integer_A   := (    1,     1,     1,     2,     1,    1,      2,     2);
   -- constant TXPLL_DIVSEL45_FB : mgtRefClkConf_integer_A   := (    5,     5,     4,     5,     5,    4,      5,     4);
   -- constant CLK25_DIVIDER     : mgtRefClkConf_integer_A   := (    4,     5,     6,     8,    10,   12,     20,    24);
   
   -- -- PCIe and SATA setup:
   -- -----------------------
   
   -- -- Comment: This attributes of the GTX although not used by the GBT Bank are set 
   -- --          to match the GTX transceiver generated by the Core generator wizard.
   
   -- constant SATA_MAX_BURST    : mgtRefClkConf_integer_A   := (   14,     9,     7,     9,     9,     7,    10,    12);
   -- constant SATA_MAX_INIT     : mgtRefClkConf_integer_A   := (   41,    26,    22,    28,    26,    22,    30,    37);
   -- constant SATA_MAX_WAKE     : mgtRefClkConf_integer_A   := (   14,     9,     7,     9,     9,     7,    10,    12);
   -- constant SATA_MIN_BURST    : mgtRefClkConf_integer_A   := (    7,     5,     4,     5,     5,     4,     5,     7);
   -- constant SATA_MIN_INIT     : mgtRefClkConf_integer_A   := (   23,    14,    12,    15,    14,    12,    16,    21);
   -- constant SATA_MIN_WAKE     : mgtRefClkConf_integer_A   := (    7,     5,     4,     5,     5,     4,     5,     7);
   
   --=====================================================================================--   
end vendor_specific_gbt_bank_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--