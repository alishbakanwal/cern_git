--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. Vichoudis (CERN) & M. Barros Marin)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Virtex 6 - GBT Bank package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              3.2                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                        21/06/2013   3.0       M. Barros Marin   First .vhd package definition           
--
--                        03/08/2014   3.2       M. Barros Marin   - Added constant "RXFRAMECLK_STEPS_NBR_MAX"
--                                                                 - Moved drp_dclk from "mgtLink_i_R" to "gbtBankMgtClks_i_R"
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
   
   constant MAX_NUM_GBT_LINK                    : integer :=  4;
   constant WORD_WIDTH                          : integer := 20; 
   constant WORD_ADDR_MSB                       : integer :=  5;
   constant WORD_ADDR_PS_CHECK_MSB              : integer :=  2;
   constant GBTRX_BITSLIP_NBR_MSB               : integer :=  4;
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
      
      -- Comment:   The number of links per GBT Bank is device dependant (up to FOUR links on Virtex 6)  
      
      NUM_LINKS                                 : integer;
      
      -- GBT Bank optimization:
      -------------------------

      -- Comment:   (0 -> STANDARD | 1 -> LATENCY)  
      
      TX_OPTIMIZATION                           : integer range 0 to 1; 
      RX_OPTIMIZATION                           : integer range 0 to 1; 
      
      -- GBT encodings:
      -----------------
      
      -- Comment:   (0 -> GBT_FRAME | 1 -> WIDE_BUS | 2 -> GBT_8B10B)
      
      TX_ENCODING                               : integer range 0 to 2;
      RX_ENCODING                               : integer range 0 to 2;
      
      -- GTX reference clock:
      -----------------------
      
      -- Comment:   * Allowed STANDARD GTX frequencies: 96MHz, 120MHz, 150MHz, 192MHz, 240MHz, 300MHz, 480MHz and 600MHz   
      --  
      --            * Note!! The reference clock frequency of the LATENCY-OPTIMIZED MGT can not be set by 
      --              the user. For Virtex 6 GTX, it is fixed to 240MHz.   
      
      STD_MGT_REFCLK_FREQ                       : integer; 
      
      -- Simulation:        
      -------------- 

      SPEEDUP_FOR_SIMULATION                    : boolean;

   end record;  
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   -- Clocks scheme:
   -----------------
   
   type gbtBankMgtClks_i_R is
   record   
      tx_refClk                                 : std_logic;
      rx_refClk                                 : std_logic;
      ------------------------------------------
      drp_dClk                                  : std_logic;
      ------------------------------------------
      --tx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      --rx_wordClk                                : std_logic_vector(1 to MAX_NUM_GBT_LINK);
   end record;   
   
   type gbtBankMgtClks_o_R is
   record
      tx_wordClk                         : std_logic_vector(1 to MAX_NUM_GBT_LINK);
      rx_wordClk                         : std_logic_vector(1 to MAX_NUM_GBT_LINK); 
   end record;   
   
   -- Common I/O:
   --------------
   
   -- Comment: GTX in Virtex 6 do not share any control port.
   
   type mgtCommon_i_R is
   record
      dummy_i                                   : std_logic;                                         
   end record;   
   
   type mgtCommon_o_R is
   record
      dummy_o                                   : std_logic;                                         
   end record;      
   
   -- Links I/O:
   -------------
   
   type mgtLink_i_R is
   record
      rx_p                                      : std_logic;                                 
      rx_n                                      : std_logic;         
      ------------------------------------------            
      loopBack                                  : std_logic_vector( 2 downto 0);              
      ------------------------------------------
      tx_reset                                  : std_logic; 
      rx_reset                                  : std_logic;
      tx_syncReset                              : std_logic;
      rx_syncReset                              : std_logic;       
      ------------------------------------------   
      rxBitSlip_enable                          : std_logic; 
      rxBitSlip_ctrl                            : std_logic; 
      rxBitSlip_nbr                             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      rxBitSlip_run                             : std_logic;
      rxBitSlip_oddRstEn                        : std_logic;
      ------------------------------------------             
      conf_diff                                 : std_logic_vector( 3 downto 0);
      conf_pstEmph                              : std_logic_vector( 4 downto 0);
      conf_preEmph                              : std_logic_vector( 3 downto 0);
      conf_eqMix                                : std_logic_vector( 2 downto 0);
      conf_txPol                                : std_logic;
      conf_rxPol                                : std_logic;
      ------------------------------------------      
      drp_dAddr                                 : std_logic_vector( 7 downto 0);  
      drp_dEn                                   : std_logic;   
      drp_dI                                    : std_logic_vector(15 downto 0); 
      drp_dWe                                   : std_logic;      
      ------------------------------------------      
      prbs_txEn                                 : std_logic_vector( 2 downto 0);
      prbs_rxEn                                 : std_logic_vector( 2 downto 0);
      prbs_forcErr                              : std_logic;
      prbs_errCntRst                            : std_logic; 
   end record;

   type mgtLink_o_R is
   record
      tx_p                                      : std_logic;
      tx_n                                      : std_logic;
      ------------------------------------------
      tx_pllLkDet                               : std_logic;
      rx_pllLkDet                               : std_logic;
      ------------------------------------------                  
      tx_resetDone                              : std_logic;      
      rx_resetDone                              : std_logic;      
      ------------------------------------------            
      ready                                     : std_logic;
      ------------------------------------------                  
      rxBitSlip_oddRstNbr                       : std_logic_vector(7 downto 0);
      ------------------------------------------                  
      rxWordClkReady                            : std_logic;
      ------------------------------------------                  
      drp_dRdy                                  : std_logic;  
      drp_dRpDo                                 : std_logic_vector(15 downto 0);      
      ------------------------------------------                  
      prbs_rxErr                                : std_logic;
   end record;   
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
   
   --====================--
   -- Rx Frameclk array  --
   --====================--
    type integer_A                              is array (natural range <>) of integer;  
   
   --====================--
   -- User setup package --
   --====================--   
   
   type gbt_bank_user_setup_R_A                 is array (natural range <>) of gbt_bank_user_setup_R;   
   
   --================--
   -- GTX quad (MGT) --
   --================--
   
   type mgtLink_i_R_A                           is array (natural range <>) of mgtLink_i_R;                          
   type mgtLink_o_R_A                           is array (natural range <>) of mgtLink_o_R;   
   
   type gtxTxDiffCtrl_nx4bit_A                  is array (natural range <>) of std_logic_vector( 3 downto 0); 
   type gtxTxPostEmphasis_nx5bit_A              is array (natural range <>) of std_logic_vector( 4 downto 0); 
   type gtxTxPreEmphasis_nx4bit_A               is array (natural range <>) of std_logic_vector( 3 downto 0); 
   --------------------------------------------- 
   type gtxRxEqMix_nx3bit_A                     is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------
   type gtxDrpDaddr_nx8bit_A                    is array (natural range <>) of std_logic_vector( 7 downto 0); 
   type gtxDrpData_nx16bit_A                    is array (natural range <>) of std_logic_vector(15 downto 0); 
   ---------------------------------------------       
   type gtxLoopBack_nx3bit_A                    is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------       
   type gtxEnPrbsTst_nx3bit_A                   is array (natural range <>) of std_logic_vector( 2 downto 0);    
   ---------------------------------------------
   type rxBitSlipNbr_mxnbit_A                   is array (natural range <>) of std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   
   type mgtRefClkConf_bitVector_8x8bit_A        is array (0 to 7) of bit_vector(7 downto 0);
   type mgtRefClkConf_integer_8x32bit_A         is array (0 to 7) of integer;     

   --=====================================================================================--   
   
   --========================== Finite State Machine (FSM) states ========================--
   
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
   
   -- Optimization:
   ----------------
   
   constant STANDARD                            : integer := 0;
   constant LATENCY_OPTIMIZED                   : integer := 1;
   
   -- Encoding:
   ------------
   
   constant GBT_FRAME                           : integer := 0;
   constant WIDE_BUS                            : integer := 1;
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
  
   -- Allowed GTX reference clock frequencies:
   -------------------------------------------
   
   constant FREQ_96MHz                          : integer := 0;
   constant FREQ_120MHz                         : integer := 1;
   constant FREQ_150MHz                         : integer := 2;
   constant FREQ_192MHz                         : integer := 3;
   constant FREQ_240MHz                         : integer := 4;
   constant FREQ_300MHz                         : integer := 5;
   constant FREQ_480MHz                         : integer := 6;
   constant FREQ_600MHz                         : integer := 7;   
   
   -- GTX PLLs setup:
   ------------------     
   
   -- Comment: Multipliers and dividers of the GTX TX and RX PLLs.
   
   constant PLL_CP_CFG                          : mgtRefClkConf_bitVector_8x8bit_A := (x"07", x"0D", x"0D", x"07", x"0D", x"0D", x"0D", x"0D");
   constant PLL_DIVSEL_FB                       : mgtRefClkConf_integer_8x32bit_A  := (    5,     4,     4,     5,     2,    2,      2,     2);
   constant PLL_DIVSEL_REF                      : mgtRefClkConf_integer_8x32bit_A  := (    1,     1,     1,     2,     1,    1,      2,     2);
   constant TXPLL_DIVSEL45_FB                   : mgtRefClkConf_integer_8x32bit_A  := (    5,     5,     4,     5,     5,    4,      5,     4);
   constant CLK25_DIVIDER                       : mgtRefClkConf_integer_8x32bit_A  := (    4,     5,     6,     8,    10,   12,     20,    24);
   
   -- PCIe and SATA setup:
   -----------------------
   
   -- Comment: This attributes of the GTX although not used by the GBT Bank are set 
   --          to match the GTX transceiver generated by the Core generator wizard.
             
   constant SATA_MAX_BURST                      : mgtRefClkConf_integer_8x32bit_A := (   14,     9,     7,     9,     9,     7,    10,    12);
   constant SATA_MAX_INIT                       : mgtRefClkConf_integer_8x32bit_A := (   41,    26,    22,    28,    26,    22,    30,    37);
   constant SATA_MAX_WAKE                       : mgtRefClkConf_integer_8x32bit_A := (   14,     9,     7,     9,     9,     7,    10,    12);
   constant SATA_MIN_BURST                      : mgtRefClkConf_integer_8x32bit_A := (    7,     5,     4,     5,     5,     4,     5,     7);
   constant SATA_MIN_INIT                       : mgtRefClkConf_integer_8x32bit_A := (   23,    14,    12,    15,    14,    12,    16,    21);
   constant SATA_MIN_WAKE                       : mgtRefClkConf_integer_8x32bit_A := (    7,     5,     4,     5,     5,     4,     5,     7);
   
   --=====================================================================================--   
   
   --======================== Function and Procedure Declarations ========================--
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
   
   -- Common:
   ----------

   function speedUp(constant simGtesetSpeedup   : in boolean) return integer;
   
   --=====================================================================================--   
end vendor_specific_gbt_bank_package;

--=================================================================================================--
--#####################################   Package Body   ##########################################--
--=================================================================================================--

package body vendor_specific_gbt_bank_package is

   --=========================== Function and Procedure Bodies ===========================--
   
   --================--
   -- GTX quad (MGT) --
   --================-- 
   
   -- Common:
   ----------
   
   function speedUp(constant simSpeedup : in boolean) return integer is 
      variable temp                             : integer range 0 to 1;  
   begin                                          
      if simSpeedup = true then             
         temp                                   := 1;
      elsif simSpeedup = false then         
         temp                                   := 0;
      end if;                                     
      return temp;                             
   end function;
   
  --=====================================================================================--   
end vendor_specific_gbt_bank_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--