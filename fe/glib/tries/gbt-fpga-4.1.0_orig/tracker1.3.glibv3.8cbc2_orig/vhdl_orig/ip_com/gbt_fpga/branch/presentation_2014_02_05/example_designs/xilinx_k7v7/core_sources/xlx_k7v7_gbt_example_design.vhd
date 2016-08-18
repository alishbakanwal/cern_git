--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - GBT Bank example design                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                               
--                                                                                                   
-- Version:               1.3                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        28/10/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
-- Additional Comments:   Note!! This example design only instantiates one GBT Bank with one link.   
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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity xlx_k7v7_gbt_example_design is   
   generic (
      FABRIC_CLK_FREQ                           : integer := 156e6 
   );
   port (   
      
      --===============--
      -- Resets scheme --
      --===============-- 
      
      GENERAL_RESET_I                           : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--
      
      -- Fabric clock:      
      ----------------
      
      FABRIC_CLK_I                              : in  std_logic; 
      
      -- MGT (GTX) reference clock:
      -----------------------------
      
      MGT_REFCLK_I                              : in  std_logic;
      
      --==============--
      -- Serial links --
      --==============--
      
      MGT_TX_P                                  : out std_logic; 
      MGT_TX_N                                  : out std_logic; 
      MGT_RX_P                                  : in  std_logic;
      MGT_RX_N                                  : in  std_logic;      
      
      --=================--
      -- General control --
      --=================--
      
      LOOPBACK_I                                : in  std_logic_vector(2 downto 0);  
      TX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);  
      RX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);  
      TX_ISDATA_SEL_I                           : in  std_logic;
      ------------------------------------------    
      TX_FRAMECLK_PLL_LOCKED_O                  : out std_logic;
      LATENCY_OPT_GBTBANK_O                     : out std_logic;
      MGT_READY_O                               : out std_logic;
      RX_HEADER_LOCKED_O                        : out std_logic;  
      RX_BITSLIP_NUMBER_O                       : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);      
      RX_WORDCLK_ALIGNED_O                      : out std_logic;
      RX_FRAMECLK_ALIGNED_O                     : out std_logic;
      GBT_RX_READY_O                            : out std_logic;        
      RX_ISDATA_FLAG_O                          : out std_logic;
      
      --===============--
      -- GBT Bank data -- 
      --===============--
      
      -- TX data:
      -----------
      
      TX_DATA_O                                 : out std_logic_vector(83 downto 0); 
      TX_WIDEBUS_EXTRA_DATA_O                   : out std_logic_vector(31 downto 0);     
      TX_ENC8B10B_EXTRA_DATA_O                  : out std_logic_vector( 3 downto 0);
      
      -- RX data:
      -----------
      
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);
      RX_WIDEBUS_EXTRA_DATA_O                   : out std_logic_vector(31 downto 0);
      RX_ENC8B10B_EXTRA_DATA_O                  : out std_logic_vector( 3 downto 0);
      
      --==============--
      -- Test control --
      --==============--
      
      -- Test pattern:
      ----------------
      
      TEST_PATTERN_SEL_I                        : in  std_logic_vector(1 downto 0);      
      
      -- Error detection:
      -------------------      
      
      RESET_DATA_ERROR_SEEN_FLAG_I              : in  std_logic;
      RESET_GBT_RX_READY_LOST_FLAG_I            : in  std_logic;
      ------------------------------------------
      GBT_RX_READY_LOST_FLAG_O                  : out std_logic;
      COMMONDATA_ERROR_SEEN_FLAG_O              : out std_logic;
      WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O        : out std_logic;
      ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O       : out std_logic;
      
      --=====================--
      -- Latency measurement --
      --=====================--
      
      -- Clocks forwarding:
      ---------------------
      
      TX_FRAMECLK_O                             : out std_logic;
      RX_FRAMECLK_O                             : out std_logic;
      TX_WORDCLK_O                              : out std_logic;
      RX_WORDCLK_O                              : out std_logic;
      
      -- Pattern match flags:
      -----------------------
      
      TX_MATCHFLAG_O                            : out std_logic;
      RX_MATCHFLAG_O                            : out std_logic       
     
   );
end xlx_k7v7_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of xlx_k7v7_gbt_example_design is  
   
   --================================ Signal Declarations ================================--   
  
   --=========--
   -- TX data --
   --=========--   
 
   signal commonData_from_pattGen               : std_logic_vector(83 downto 0);   
   signal widebusExtraData_from_pattGen         : std_logic_vector(31 downto 0);   
   
   --==========--
   -- GBT Bank --    
   --==========--   
   
   -- GBT Bank clock scheme: 
   -------------------------   
   
   signal txFrameClk_from_txPll                 : std_logic;   
   ---------------------------------------------  
   signal phaseAlignDone_from_rxFrmClkPhAlgnr   : std_logic;   
   signal rxFrameClk_from_rxFrmClkPhAlgnr       : std_logic;   
   
   -- GBT Bank reset scheme:
   -------------------------
   
   signal mgtTxReset_from_gbtBankRst            : std_logic; 
   signal mgtRxReset_from_gbtBankRst            : std_logic; 
   signal gbtTxReset_from_gbtBankRst            : std_logic;
   signal gbtRxReset_from_gbtBankRst            : std_logic; 
   
   -- Unit Under Test - GBT Bank:
   ------------------------------   
   
   -- Comment: Only one GBT Bank with one link is generated in this example design.
   
   -- GBT bank 1:
   signal to_gbtBank_1_clks                     : gbtBankClks_i_R;                          
   signal from_gbtBank_1_clks                   : gbtBankClks_o_R;
   ---------------------------------------------        
   signal to_gbtBank_1_gbtTx                    : gbtTx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   ---------------------------------------------        
   signal to_gbtBank_1_mgt                      : mgt_i_R_A  (1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
   signal from_gbtBank_1_mgt                    : mgt_o_R_A  (1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   ---------------------------------------------        
   signal to_gbtBank_1_gbtRx                    : gbtRx_i_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS); 
   signal from_gbtBank_1_gbtRx                  : gbtRx_o_R_A(1 to GBT_BANKS_USER_SETUP(1).NUM_LINKS);
   
   -- GBT bank 2:
-- signal to_gbtBank_2_clks                     : gbtBankClks_i_R;                          
-- signal from_gbtBank_2_clks                   : gbtBankClks_o_R;
-- ---------------------------------------------        
-- signal to_gbtBank_2_gbtTx                    : gbtTx_i_R_A(1 to GBT_BANKS_USER_SETUP(2).NUM_LINKS); 
-- ---------------------------------------------        
-- signal to_gbtBank_2_mgt                      : mgt_i_R_A  (1 to GBT_BANKS_USER_SETUP(2).NUM_LINKS);
-- signal from_gbtBank_2_mgt                    : mgt_o_R_A  (1 to GBT_BANKS_USER_SETUP(2).NUM_LINKS); 
-- ---------------------------------------------         
-- signal to_gbtBank_2_gbtRx                    : gbtRx_i_R_A(1 to GBT_BANKS_USER_SETUP(2).NUM_LINKS); 
-- signal from_gbtBank_2_gbtRx                  : gbtRx_o_R_A(1 to GBT_BANKS_USER_SETUP(2).NUM_LINKS);    
  
   -- GBT RX status:
   -----------------  
      
   signal gbtRxReady_from_gbtRxStatus           : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
  
   --=========--
   -- TX data --
   --=========--
   
   -- Pattern generator:
   ---------------------
   
   -- Comment: The pattern generated can be either:
   --          - Counter pattern
   --          - Static pattern          
   
   pattGen: entity work.pattern_generator
      port map (                                                        
         RESET_I                                => GENERAL_RESET_I,   
         CLK_I                                  => txFrameClk_from_txPll,
         ---------------------------------------     
         ENCODING_SEL_I                         => TX_ENCODING_SEL_I,
         PATTERN_SEL_I                          => TEST_PATTERN_SEL_I,
         COMMON_STATIC_PATTERN_I                => x"0000BABEAC1DACDCFFFFF",
         WIDEBUS_STATIC_PATTERN_I               => x"BEEFCAFE",
         ---------------------------------------
         COMMON_DATA_O                          => commonData_from_pattGen,
         WIDEBUS_EXTRA_DATA_O                   => widebusExtraData_from_pattGen
--       ENC8B10B_EXTRA_DATA_O                  =>
      );       
         
   TX_DATA_O                                    <= commonData_from_pattGen;
   TX_WIDEBUS_EXTRA_DATA_O                      <= widebusExtraData_from_pattGen;
   TX_ENC8B10B_EXTRA_DATA_O                     <= "0000";
   
   --==========--
   -- GBT Bank --
   --==========-- 
   
   -- GBT Bank clock scheme: 
   -------------------------
      
   to_gbtBank_1_clks.mgt_clks.mgtRefClk         <= MGT_REFCLK_I;
   
   ---------------------------------------------
   
   to_gbtBank_1_clks.mgt_clks.sysClk            <= FABRIC_CLK_I;
   to_gbtBank_1_clks.mgt_clks.cpllLockDetClk    <= FABRIC_CLK_I;
   to_gbtBank_1_clks.mgt_clks.drpClk            <= FABRIC_CLK_I;
   
   ---------------------------------------------
     
   txWordClkBufg: bufg
      port map (
         O                                      => to_gbtBank_1_clks.mgt_clks.tx_wordClk, 
         I                                      => from_gbtBank_1_clks.mgt_clks.tx_wordClk_noBuff
      ); 
   
   -- Comment: * The txPll (MMCM) does not have input buffer.
   --      
   --          * TX_FRAMECLK frequency: 40MHz
   
   txPll: entity work.xlx_k7v7_tx_pll
      port map (
         -- Clock in ports:
         CLK_IN1                                => to_gbtBank_1_clks.mgt_clks.tx_wordClk,
         -- Clock out ports:               
         CLK_OUT1                               => txFrameClk_from_txPll,
         -- Status and control signals:
         RESET                                  => '0',
         LOCKED                                 => TX_FRAMECLK_PLL_LOCKED_O
      );    
   
   to_gbtBank_1_clks.tx_frameClk                <= txFrameClk_from_txPll;     
   
   ---------------------------------------------
   
   rxWordClkBufg: bufg
      port map (
         O                                      => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1), 
         I                                      => from_gbtBank_1_clks.mgt_clks.rx_wordClk_noBuff(1) 
      );   
     
   -- Comment: * This phase aligner uses the header of the gbt frame as a reference point for matching the rising
   --            edge of the recovered rx frame clock with the rising edge of the tx frame clock of the TRANSMITTER
   --            BOARD when using the latency-optimized MGT(GTX).  
   -- 
   --          * Note!! The phase alignment is only triggered when LATENCY-OPTIMIZED GBT Bank is used.  
   --
   --          * The PLL (MMCM) does not have input buffer.
   --      
   --          * RX_FRAMECLK frequency: 40MHz
   
   rxFrmClkPhAlgnr: entity work.xlx_k7v7_rx_frameclk_phalgnr
      port map (
         RESET_I                                => gbtRxReset_from_gbtBankRst,
         ---------------------------------------      
         RX_WORDCLK_I                           => to_gbtBank_1_clks.mgt_clks.rx_wordClk(1),
         RX_FRAMECLK_O                          => rxFrameClk_from_rxFrmClkPhAlgnr,         
         ---------------------------------------      
         SYNC_I                                 => (from_gbtBank_1_gbtRx(1).header_flag) and (from_gbtBank_1_mgt(1).latOptGbtBank),
         ---------------------------------------
         DONE_O                                 => phaseAlignDone_from_rxFrmClkPhAlgnr
      );                      
   
   RX_FRAMECLK_ALIGNED_O                        <= phaseAlignDone_from_rxFrmClkPhAlgnr;     
   
   to_gbtBank_1_clks.rx_frameClk(1)             <= rxFrameClk_from_rxFrmClkPhAlgnr;      
  
   -- GBT Bank reset scheme:
   ------------------------- 
   
   -- Comment: The GBT Bank needs to be reset sequentially.
   --          (see the timing diagram as a comment in the "gbtBank_rst" module)  
   
   gbtBankRst: entity work.gbt_bank_reset    
      generic map (
         RX_INIT_FIRST                          => false,
         INITIAL_DELAY                          => 1 * FABRIC_CLK_FREQ,  -- Comment: * 1s  
         TIME_N                                 => 1 * FABRIC_CLK_FREQ,  --          * 1s
         GAP_DELAY                              => 1 * FABRIC_CLK_FREQ)  --          * 1s
      port map (     
         CLK_I                                  => FABRIC_CLK_I,                                               
         RESET_I                                => GENERAL_RESET_I,                                                                 
         ---------------------------------------     
         MGT_TXRESET_O                          => mgtTxReset_from_gbtBankRst,                              
         MGT_RXRESET_O                          => mgtRxReset_from_gbtBankRst,                             
         GBT_TXRESET_O                          => gbtTxReset_from_gbtBankRst,                                      
         GBT_RXRESET_O                          => gbtRxReset_from_gbtBankRst,                              
         ---------------------------------------      
         BUSY_O                                 => open,                                                                         
         DONE_O                                 => open                                                                          
      );          
         
   to_gbtBank_1_gbtTx(1).reset                  <= gbtTxReset_from_gbtBankRst;   
   to_gbtBank_1_mgt(1).tx_reset                 <= mgtTxReset_from_gbtBankRst;
   to_gbtBank_1_mgt(1).rx_reset                 <= mgtRxReset_from_gbtBankRst;
   
   to_gbtBank_1_gbtRx(1).reset                  <= gbtRxReset_from_gbtBankRst;
   
   -- Unit Under Test - GBT Bank:
   ------------------------------
   
   -- Comment: Only one GBT Bank with one link is generated in this example design.   
   
   gbtBank_1: entity work.gbt_bank
      generic map (
         GBT_BANK_ID                            => 1)
      port map (                       
         CLKS_I                                 => to_gbtBank_1_clks,                                  
         CLKS_O                                 => from_gbtBank_1_clks,               
         ---------------------------------------          
         GBT_TX_I                               => to_gbtBank_1_gbtTx,             
         ---------------------------------------          
         MGT_I                                  => to_gbtBank_1_mgt,              
         MGT_O                                  => from_gbtBank_1_mgt,              
         ---------------------------------------          
         GBT_RX_I                               => to_gbtBank_1_gbtRx,              
         GBT_RX_O                               => from_gbtBank_1_gbtRx         
      ); 

-- gbtBank_2: entity work.gbt_bank
--    generic map (
--      GBT_BANK_ID                             => 2)
--    port map (                       
--       CLKS_I                                 => to_gbtBank_2_clks,                                  
--       CLKS_O                                 => from_gbtBank_2_clks,               
--       ---------------------------------------          
--       GBT_TX_I                               => to_gbtBank_2_gbtTx,             
--       ---------------------------------------          
--       MGT_I                                  => to_gbtBank_2_mgt,              
--       MGT_O                                  => from_gbtBank_2_mgt,              
--       ---------------------------------------          
--       GBT_RX_I                               => to_gbtBank_2_gbtRx,              
--       GBT_RX_O                               => from_gbtBank_2_gbtRx         
--    ); 
      
   -- GBT Bank signal assignments:
   -------------------------------   
   
   to_gbtBank_1_mgt(1).rx_p                     <= MGT_RX_P;   
   to_gbtBank_1_mgt(1).rx_n                     <= MGT_RX_N;
   MGT_TX_P                                     <= from_gbtBank_1_mgt(1).tx_p;
   MGT_TX_N                                     <= from_gbtBank_1_mgt(1).tx_n;     
   
   to_gbtBank_1_gbtTx(1).data                   <= commonData_from_pattGen;   
   to_gbtBank_1_gbtTx(1).widebusExtraData       <= widebusExtraData_from_pattGen;
   to_gbtBank_1_gbtTx(1).enc8b10bExtraData      <= "00";
   
   to_gbtBank_1_gbtTx(1).encodingSel            <= TX_ENCODING_SEL_I;
   to_gbtBank_1_gbtRx(1).encodingSel            <= RX_ENCODING_SEL_I;
   to_gbtBank_1_gbtTx(1).isDataSel              <= TX_ISDATA_SEL_I;  
   RX_ISDATA_FLAG_O                             <= from_gbtBank_1_gbtRx(1).isDataFlag;  
   
   to_gbtBank_1_mgt(1).loopBack                 <= LOOPBACK_I;
   
   to_gbtBank_1_mgt(1).tx_diffCtrl              <= "1000";    -- Comment: 807 mVppd
   to_gbtBank_1_mgt(1).tx_postCursor            <= "00000";   -- Comment: 0.00 dB (default)
   to_gbtBank_1_mgt(1).tx_preCursor             <= "00000";   -- Comment: 0.00 dB (default)
   to_gbtBank_1_mgt(1).tx_polarity              <= '0';       -- Comment: Not inverted
   to_gbtBank_1_mgt(1).rx_polarity              <= '0';       -- Comment: Not inverted        
         
   LATENCY_OPT_GBTBANK_O                        <= from_gbtBank_1_mgt(1).latOptGbtBank;
   MGT_READY_O                                  <= from_gbtBank_1_mgt(1).ready;
   RX_WORDCLK_ALIGNED_O                         <= from_gbtBank_1_mgt(1).rx_wordClk_aligned;   
   RX_HEADER_LOCKED_O                           <= from_gbtBank_1_gbtRx(1).header_lockedFlag;
   RX_BITSLIP_NUMBER_O                          <= from_gbtBank_1_gbtRx(1).bitSlip_nbr;
   
   -- Comment: * The manual phase alignment control of the MGT(GTX) transceivers is not used in this reference
   --            design (auto phase alignment is used instead).
   --
   --          * Note!! The manual phase alignment control of the MGT(GTX) MUST be synchronous with "rx_word_clk"
   --                   (this clock is forwarded out from the GBT Bank through the record port "CLKS_O").
   
   to_gbtBank_1_mgt(1).rx_slide_enable          <= '1'; 
   to_gbtBank_1_mgt(1).rx_slide_ctrl            <= '0'; 
   to_gbtBank_1_mgt(1).rx_slide_nbr             <= "000000";
   to_gbtBank_1_mgt(1).rx_slide_run             <= '0';
   
   -- Comment: * The DRP port of the MGT(GTX) transceiver is not used in this example design.   
   
   to_gbtBank_1_mgt(1).drp_addr                 <= "000000000";
   to_gbtBank_1_mgt(1).drp_en                   <= '0';
   to_gbtBank_1_mgt(1).drp_di                   <= x"0000";
   to_gbtBank_1_mgt(1).drp_we                   <= '0';

   -- Comment: The built-in PRBS generator/checker of the MGT(GTX) transceiver is not used in this example design.

   to_gbtBank_1_mgt(1).prbs_txSel               <= "000";
   to_gbtBank_1_mgt(1).prbs_rxSel               <= "000";
   to_gbtBank_1_mgt(1).prbs_txForceErr          <= '0';
   to_gbtBank_1_mgt(1).prbs_rxCntReset          <= '0';          
  
   -- GBT RX status:     
   -----------------        
   
   gbtRxStatus: entity work.gbt_rx_status    
      port map (     
         RESET_I                                => gbtRxReset_from_gbtBankRst,
         CLK_I                                  => rxFrameClk_from_rxFrmClkPhAlgnr,
         ---------------------------------------
         GBT_LINK_OPTIMIZATION_I                => from_gbtBank_1_mgt(1).latOptGbtBank,
         DESCR_RDY_I                            => from_gbtBank_1_gbtRx(1).descrRdy,
         ---------------------------------------
         RX_WORDCLK_ALIGNED_I                   => from_gbtBank_1_mgt(1).rx_wordClk_aligned,
         RX_FRAMECLK_ALIGNED_I                  => phaseAlignDone_from_rxFrmClkPhAlgnr,
         ---------------------------------------
         GBT_RX_READY_O                         => gbtRxReady_from_gbtRxStatus
      );       
         
   GBT_RX_READY_O                               <= gbtRxReady_from_gbtRxStatus;
     
   --=========--
   -- RX data --
   --=========--  
   
   -- Comment: * This error detector checks whether there are errors in the data received as well as the ready 
   --            flag of the GBT RX does not go low after asserted for the first time during data transmission.
   --
   --          * The PATTERN_SEL_I port of the pattern generator as well as the error detector are controlled by the
   --            TEST_PATTERN_SEL_I port.
   --
   --          * If the GBT RX ready flag goes low at some point, GBT_RX_READY_LOST_FLAG_O is also asserted until reset.
   --
   --          * If GBT RX ready flag equals '1', asserts "COMMONDATA_ERROR_SEEN_FLAG_O" when an error is seen in "COMMON_DATA_I".          
   --          * If GBT RX ready flag equals '1', asserts "WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O an error is seen in "WIDEBUS_EXTRA_DATA_I".
   --          * If GBT RX ready flag equals '1', asserts "ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O error is seen in "ENC8B10B_EXTRA_DATA_I".
   --
   --          * These error flags remain asserted until reset. 
   --
   --          * Note!! "COMMONDATA_ERROR_SEEN_FLAG_O" must be reset after selecting a new pattern.
   --          * Note!! "WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O" must be reset after selecting a new pattern.   
   --          * Note!! "ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O" must be reset after selecting a new pattern.   

   errDet: entity work.error_detector
      port map (
         RESET_I                                => gbtRxReset_from_gbtBankRst,         
         CLK_I                                  => rxFrameClk_from_rxFrmClkPhAlgnr, 
         ---------------------------------------      
         GBT_RX_READY                           => gbtRxReady_from_gbtRxStatus,
         ---------------------------------------      
         COMMON_DATA_I                          => from_gbtBank_1_gbtRx(1).data,        
         WIDEBUS_EXTRA_DATA_I                   => from_gbtBank_1_gbtRx(1).widebusExtraData,
--       ENC8B10B_EXTRA_DATA_I                  =>
         ---------------------------------------      
         RX_ENCODING_SEL_I                      => RX_ENCODING_SEL_I,
         PATTERN_SEL_I                          => TEST_PATTERN_SEL_I,        
         COMMON_STATIC_PATTERN_I                => x"0000BABEAC1DACDCFFFFF",        
         WIDEBUS_STATIC_PATTERN_I               => x"BEEFCAFE",  
         RESET_DATA_ERROR_SEEN_FLAG_I           => RESET_DATA_ERROR_SEEN_FLAG_I,  
         RESET_GBT_RX_READY_LOST_FLAG_I         => RESET_GBT_RX_READY_LOST_FLAG_I,               
         ---------------------------------------      
         GBT_RX_READY_LOST_FLAG_O               => GBT_RX_READY_LOST_FLAG_O, 
         COMMONDATA_ERROR_SEEN_FLAG_O           => COMMONDATA_ERROR_SEEN_FLAG_O,
         WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O     => WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O--,
--       ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O    => ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O
      ); 

   ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O          <= '0';      
      
   RX_DATA_O                                    <= from_gbtBank_1_gbtRx(1).data;
   RX_WIDEBUS_EXTRA_DATA_O                      <= from_gbtBank_1_gbtRx(1).widebusExtraData;
   RX_ENC8B10B_EXTRA_DATA_O                     <= "0000";
   
   --=====================--
   -- Latency measurement --
   --=====================--   

   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If RX data comes from another board with a different reference clock, 
   --                   then the TX frame/word clock domains are asynchronous with respect to the
   --                   RX frame/word clock domains.
   
   TX_FRAMECLK_O                                <= txFrameClk_from_txPll;
   RX_FRAMECLK_O                                <= rxFrameClk_from_rxFrmClkPhAlgnr; 
   TX_WORDCLK_O                                 <= to_gbtBank_1_clks.mgt_clks.tx_wordClk; 
   RX_WORDCLK_O                                 <= to_gbtBank_1_clks.mgt_clks.rx_wordClk(1);    
   
   -- Pattern match flags:
   -----------------------      
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test.
   
   txFlag: entity work.pattern_match_flag
      PORT MAP (
         RESET_I                                => gbtTxReset_from_gbtBankRst,
         CLK_I                                  => txFrameClk_from_txPll,
         DATA_I                                 => commonData_from_pattGen,
         MATCHFLAG_O                            => TX_MATCHFLAG_O
      );
   
   rxFlag: entity work.pattern_match_flag
      PORT MAP (
         RESET_I                                => gbtRxReset_from_gbtBankRst,
         CLK_I                                  => rxFrameClk_from_rxFrmClkPhAlgnr,
         DATA_I                                 => from_gbtBank_1_gbtRx(1).data,
         MATCHFLAG_O                            => RX_MATCHFLAG_O
      );
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--