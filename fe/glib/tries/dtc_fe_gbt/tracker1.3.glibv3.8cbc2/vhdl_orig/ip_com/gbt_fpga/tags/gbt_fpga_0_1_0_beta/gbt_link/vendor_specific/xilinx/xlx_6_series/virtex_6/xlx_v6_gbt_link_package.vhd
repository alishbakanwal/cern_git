--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. VICHOUDIS & M. BARROS MARIN)                                                                                                    
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Virtex 6 - GBT Link package                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                        21/06/2013   1.0       M. Barros Marin   - First .vhd package definition           
--
-- Additional Comments:                                                                                  
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Link are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Link module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Link that !!
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

package vendor_specific_gbt_link_package is
   
   --=============================== GBT Link package setup ==============================--
   
   constant WORD_WIDTH                          : integer := 20;   
   constant GBTRX_SLIDE_NBR_MSB                 : integer :=  4;
   constant WRITE_ADDR_MSB                      : integer :=  5;  
   
   --=====================================================================================--
   
   --================================ Record Declarations ================================--
      
   --================--
   -- GTX quad (MGT) --
   --================--
   
   -- Reference clocks:
   --------------------
   
   type gbtLinkMgtRefClks_R is
   record
      tx                                        : std_logic;
      rx                                        : std_logic;
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
      tx_syncReset                              : std_logic;
      rx_syncReset                              : std_logic;       
      ------------------------------------------   
      rx_slide_enable                           : std_logic; 
      rx_slide_ctrl                             : std_logic; 
      rx_slide_nbr                              : std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
      rx_slide_run                              : std_logic;
      ------------------------------------------               
      conf_diff                                 : std_logic_vector( 3 downto 0);
      conf_pstEmph                              : std_logic_vector( 4 downto 0);
      conf_preEmph                              : std_logic_vector( 3 downto 0);
      conf_eqMix                                : std_logic_vector( 2 downto 0);
      conf_txPol                                : std_logic;
      conf_rxPol                                : std_logic;
       ------------------------------------------      
      drp_dClk                                  : std_logic;
      drp_dAddr                                 : std_logic_vector( 7 downto 0);  
      drp_dEn                                   : std_logic;   
      drp_dI                                    : std_logic_vector(15 downto 0); 
      drp_dWe                                   : std_logic;      
      ------------------------------------------      
      prbs_txEn                                 : std_logic_vector( 2 downto 0);
      prbs_rxEn                                 : std_logic_vector( 2 downto 0);
      prbs_forcErr                              : std_logic;
      prbs_errCntRst                            : std_logic; 
      ------------------------------------------         
      usrBuf_txUsrClk2                          : std_logic;     
      usrBuf_rxUsrClk2                          : std_logic;      
   end record;

   type mgt_o_R is
   record
      tx_p                                      : std_logic;
      tx_n                                      : std_logic;
      ------------------------------------------
      word                                      : std_logic_vector(WORD_WIDTH-1 downto 0); 
      ------------------------------------------                  
      tx_pllLkDet                               : std_logic;
      rx_pllLkDet                               : std_logic;
      ------------------------------------------                  
      tx_resetDone                              : std_logic;      
      rx_resetDone                              : std_logic;      
      ------------------------------------------            
      ready                                     : std_logic;
      rx_wordClk_aligned                        : std_logic;
      ------------------------------------------                  
      drp_dRdy                                  : std_logic;  
      drp_dRpDo                                 : std_logic_vector(15 downto 0);      
      ------------------------------------------                  
      prbs_rxErr                                : std_logic;
      ------------------------------------------
      usrBuf_txOutClk                           : std_logic; 
      usrBuf_rxRecClk                           : std_logic;
      ------------------------------------------         
      latOptGbtLink                             : std_logic;
   end record;   
   
   --=====================================================================================-- 
   
   --================================= Array Declarations ================================--
               
   --================--
   -- GTX quad (MGT) --
   --================--                   
            
   type mgt_i_R_A                               is array (natural range <>) of mgt_i_R;                          
   type mgt_o_R_A                               is array (natural range <>) of mgt_o_R;                          
         
   type gtxTxDiffCtrl_4bit_A                    is array (natural range <>) of std_logic_vector( 3 downto 0); 
   type gtxTxPostEmphasis_5bit_A                is array (natural range <>) of std_logic_vector( 4 downto 0); 
   type gtxTxPreEmphasis_4bit_A                 is array (natural range <>) of std_logic_vector( 3 downto 0); 
   ---------------------------------------------   
   type gtxRxEqMix_3bit_A                       is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------
   type gtxDrpDaddr_8bit_A                      is array (natural range <>) of std_logic_vector( 7 downto 0); 
   type gtxDrpData_16bit_A                      is array (natural range <>) of std_logic_vector(15 downto 0); 
   ---------------------------------------------         
   type gtxLoopBack_3bit_A                      is array (natural range <>) of std_logic_vector( 2 downto 0); 
   ---------------------------------------------         
   type gtxEnPrbsTst_3bit_A                     is array (natural range <>) of std_logic_vector( 2 downto 0);    
            
   type gbtRxSlideNbr_nbit_A                    is array (natural range <>) of std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
            
   type mgtRefClkConf_bitVector_A               is array (0 to 7) of bit_vector(7 downto 0);
   type mgtRefClkConf_integer_A                 is array (0 to 7) of integer;     
         
   --=====================================================================================--   
   
   --=============================== Constant Declarations ===============================--
  
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
   
   constant PLL_CP_CFG        : mgtRefClkConf_bitVector_A := (x"07", x"0D", x"0D", x"07", x"0D", x"0D", x"0D", x"0D");
   constant PLL_DIVSEL_FB     : mgtRefClkConf_integer_A   := (    5,     4,     4,     5,     2,    2,      2,     2);
   constant PLL_DIVSEL_REF    : mgtRefClkConf_integer_A   := (    1,     1,     1,     2,     1,    1,      2,     2);
   constant TXPLL_DIVSEL45_FB : mgtRefClkConf_integer_A   := (    5,     5,     4,     5,     5,    4,      5,     4);
   constant CLK25_DIVIDER     : mgtRefClkConf_integer_A   := (    4,     5,     6,     8,    10,   12,     20,    24);
   
   -- PCIe and SATA setup:
   -----------------------
   
   -- Comment: This attributes of the GTX although not used by the GBT Link are set 
   --          to match the GTX transceiver generated by the Core generator wizard.
   
   constant SATA_MAX_BURST    : mgtRefClkConf_integer_A   := (   14,     9,     7,     9,     9,     7,    10,    12);
   constant SATA_MAX_INIT     : mgtRefClkConf_integer_A   := (   41,    26,    22,    28,    26,    22,    30,    37);
   constant SATA_MAX_WAKE     : mgtRefClkConf_integer_A   := (   14,     9,     7,     9,     9,     7,    10,    12);
   constant SATA_MIN_BURST    : mgtRefClkConf_integer_A   := (    7,     5,     4,     5,     5,     4,     5,     7);
   constant SATA_MIN_INIT     : mgtRefClkConf_integer_A   := (   23,    14,    12,    15,    14,    12,    16,    21);
   constant SATA_MIN_WAKE     : mgtRefClkConf_integer_A   := (    7,     5,     4,     5,     5,     4,     5,     7);
   
   --=====================================================================================--   
end vendor_specific_gbt_link_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--