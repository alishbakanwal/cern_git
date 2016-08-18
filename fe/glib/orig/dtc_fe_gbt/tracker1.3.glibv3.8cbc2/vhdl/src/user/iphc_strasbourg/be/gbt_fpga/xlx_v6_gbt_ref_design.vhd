--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Virtex 6 - GBT Link reference design                                         
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                         
-- Tool version:          ISE 14.5                                                               
--                                                                                                   
-- Version:               1.3                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/06/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
--                        23/06/2013   1.1       M. Barros Marin   - Cosmetic modifications 
--                                                                 - Updated Pattern Generator (from version 0.3 to 1.0)
--                                                                 - Updated Error Detector (from version 0.2 to 1.0)
--                                                                 - Added TX and RX pattern flag match modules
--                                                                 - Added RX frame clock aligner module
--                                                                 - New RX frame clock scheme
--
--                        07/08/2013   1.2       M. Barros Marin   - Added wide-bus
--
--
--                        23-10-2013   1.3       M. Barros Marin   - Modified clock scheme to suit
--                                                                   ML605 needs  
--
-- Additional Comments:   Note!! This reference design only instantiates one GBT Link.   
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

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;
use work.gbt_link_package.all;
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity xlx_v6_gbt_ref_design is   
   generic (
      FABRIC_CLK_FREQ                           : integer := 125e6 
   );
   port (   
      
      --===============--
      -- Resets scheme --
      --===============-- 
      
      GENERAL_RESET_I                           : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--
      
      FABRIC_CLK_I                              : in  std_logic; 
      MGT_REFCLKS_I                             : in  gbtLinkMgtRefClks_R; 
      TX_OUTCLK_O                               : out std_logic; 
      TX_WORDCLK_I                              : in  std_logic; 
      TX_FRAMECLK_I                             : in  std_logic; 
      
      --==============--
      -- Serial lanes --
      --==============--
      
      MGT_TX_P                                  : out std_logic; 
      MGT_TX_N                                  : out std_logic; 
      MGT_RX_P                                  : in  std_logic;
      MGT_RX_N                                  : in  std_logic;      
      
      --==================--
      -- GBT Link control --
      --==================--
      
      LOOPBACK_I                                : in  std_logic_vector(2 downto 0);  
      TX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);  
      RX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);  
      TX_ISDATA_SEL_I                           : in  std_logic;
      
      --================--
      -- GBT Link status --
      --================--     
      
      LATENCY_OPT_GBTLINK_O                     : out std_logic;
      MGT_READY_O                               : out std_logic;
      RX_HEADER_LOCKED_O                        : out std_logic;  
      RX_BITSLIP_NUMBER_O                       : out std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);      
      RX_WORDCLK_ALIGNED_O                      : out std_logic;
      RX_FRAMECLK_ALIGNED_O                     : out std_logic;
      RX_GBT_READY_O                            : out std_logic;        
      RX_ISDATA_FLAG_O                          : out std_logic;
      
      --===============--
      -- GBT Link data -- 
      --===============--
      
      -- TX data:
      -----------
      TX_DATA_O                                 : out std_logic_vector(83 downto 0); 
      TX_WIDEBUS_EXTRA_DATA_O                   : out std_logic_vector(31 downto 0);     
      
      -- RX data:
      -----------
      
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);
      RX_WIDEBUS_EXTRA_DATA_O                   : out std_logic_vector(31 downto 0);
      
      --=======================--
      -- Test control & status --
      --=======================--
      
      -- Test pattern:
      ----------------
      
      TEST_PATTERN_SEL_I                        : in  std_logic_vector(1 downto 0);      
      
      -- Error detection:
      -------------------      
      
      RESET_DATA_ERROR_SEEN_FLAG_I              : in  std_logic;
      RESET_RX_GBT_READY_LOST_FLAG_I            : in  std_logic;
      
      RX_GBT_READY_LOST_FLAG_O                  : out std_logic;
      COMMONDATA_ERROR_SEEN_FLAG_O              : out std_logic;
      WIDEBUSDATA_ERROR_SEEN_FLAG_O             : out std_logic;
      
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
      RX_MATCHFLAG_O                            : out std_logic;

      --==========--
      -- lcharles --
      --===========--
		-- User Individual Reset (lcharles):
      ------------------------------------		
		MGT_TXRESET_FROM_USER_I							: in  std_logic;
		MGT_RXRESET_FROM_USER_I							: in  std_logic;
		GBT_TXRESET_FROM_USER_I							: in  std_logic;
		GBT_RXRESET_FROM_USER_I							: in  std_logic;	
		-- DATA to send (lcharles):
      ---------------------------		
		to_gbtTx_from_user_i								: in std_logic_vector(83 downto 0); --gbt_din_from_user
		be_fe_sync_done_i									: in std_logic          
     
   );
end xlx_v6_gbt_ref_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of xlx_v6_gbt_ref_design is  
   
   --================================ Signal Declarations ================================--
   
   --===============--
   -- Resets scheme --
   --===============--
   
   signal mgt_txReset_from_gbtLinkRst           : std_logic; 
   signal mgt_rxReset_from_gbtLinkRst           : std_logic; 
   signal gbt_txReset_from_gbtLinkRst           : std_logic;
   signal gbt_rxReset_from_gbtLinkRst           : std_logic;   
         
   --===============--
   -- Clocks scheme --    
   --===============--    
         
   signal rxFrameClk_from_rxFrameClkPhaAl       : std_logic; 
   signal phaseAlignDone_from_rxPll             : std_logic;   
   
   --=========--
   -- TX data --
   --=========--   
         
   signal commonData_from_pattGen               : std_logic_vector(83 downto 0);   
   signal widebusExtraData_from_pattGen         : std_logic_vector(31 downto 0);   
   
   --=====================--
   -- GBT Link (SFP quad) --    
   --=====================--    
         
   signal clks_to_gbtLink                       : gbtLinkClks_i_R;                          
   signal clks_from_gbtLink                     : gbtLinkClks_o_R;
   ---------------------------------------------         
   signal to_gbtTx                              : gbtTx_i_R_A(1 to NUM_GBT_LINK); 
   ---------------------------------------------         
   signal to_mgt                                : mgt_i_R_A  (1 to NUM_GBT_LINK);
   signal from_mgt                              : mgt_o_R_A  (1 to NUM_GBT_LINK); 
   ---------------------------------------------         
   signal to_gbtRx                              : gbtRx_i_R_A(1 to NUM_GBT_LINK); 
   signal from_gbtRx                            : gbtRx_o_R_A(1 to NUM_GBT_LINK);    
  
   --===============--
   -- GBT RX status --
   --===============--  
      
   signal rxGbtReady_from_gbtRxStatus           : std_logic;
   
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
         CLK_I                                  => TX_FRAMECLK_I,
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
   
   --==========--
   -- GBT Link --
   --==========--      
   
   -- GBT Link clocks assignments:
   -------------------------------
   
   clks_to_gbtLink.mgt_refClks                  <= MGT_REFCLKS_I;
   TX_OUTCLK_O                                  <= from_mgt(1).usrBuf_txOutClk;
   to_mgt(1).usrBuf_txUsrClk2                   <= TX_WORDCLK_I;           
   clks_to_gbtLink.tx_frameClk                  <= TX_FRAMECLK_I;
   clks_to_gbtLink.rx_frameClk                  <= rxFrameClk_from_rxFrameClkPhaAl;
 
   -- GBT Link reset:
   ------------------ 
   
   -- Comment: The GBT Link needs to be reset sequentially.
   --          (see the timing diagram as a comment in the "gbtLink_rst" module)  
   
   gbtLink_rst: entity work.gbt_link_reset    
      generic map (
         RX_INIT_FIRST                          => false,
         INITIAL_DELAY                          => 1 * FABRIC_CLK_FREQ,  -- Comment: * 1s  
         TIME_N                                 => 1 * FABRIC_CLK_FREQ,  --          * 1s
         GAP_DELAY                              => 1 * FABRIC_CLK_FREQ)  --          * 1s
      port map (     
         CLK_I                                  => FABRIC_CLK_I,                                               
         RESET_I                                => GENERAL_RESET_I,                                                                 
         ---------------------------------------     
         MGT_TXRESET_O                          => mgt_txReset_from_gbtLinkRst,                              
         MGT_RXRESET_O                          => mgt_rxReset_from_gbtLinkRst,                             
         GBT_TXRESET_O                          => gbt_txReset_from_gbtLinkRst,                                      
         GBT_RXRESET_O                          => gbt_rxReset_from_gbtLinkRst,                              
         ---------------------------------------      
         BUSY_O                                 => open,                                                                         
         DONE_O                                 => open                                                                          
      );          
         
   to_mgt(1).tx_reset                           <= mgt_txReset_from_gbtLinkRst;
   to_mgt(1).rx_reset                           <= mgt_rxReset_from_gbtLinkRst;
   to_gbtTx(1).reset                            <= gbt_txReset_from_gbtLinkRst;
   to_gbtRx(1).reset                            <= gbt_rxReset_from_gbtLinkRst;
   
   -- Unit Under Test - GBT Link:
   ------------------------------
   
   uut: entity work.gbt_link                        
      port map (                     
         CLKS_I                                 => clks_to_gbtLink,                                  
         CLKS_O                                 => clks_from_gbtLink,               
         ---------------------------------------       
         GBT_TX_I                               => to_gbtTx,             
         ---------------------------------------       
         MGT_I                                  => to_mgt,              
         MGT_O                                  => from_mgt,              
         ---------------------------------------       
         GBT_RX_I                               => to_gbtRx,              
         GBT_RX_O                               => from_gbtRx         
      );       
   
   -- Signal assignments:
   ----------------------
   
   -- Comment: Note!! Only one GBT Link is used in this reference design.
   
   to_mgt(1).rx_p                               <= MGT_RX_P;   
   to_mgt(1).rx_n                               <= MGT_RX_N;
   MGT_TX_P                                     <= from_mgt(1).tx_p;
   MGT_TX_N                                     <= from_mgt(1).tx_n;     
     
   --to_gbtTx(1).data                             <= commonData_from_pattGen;   
	--lcharles
	process
	begin
		wait until rising_edge(TX_FRAMECLK_I); 
			if be_fe_sync_done_i = '1' then
				to_gbtTx(1).data   <= to_gbtTx_from_user_i;
			else
				to_gbtTx(1).data   <= commonData_from_pattGen;
			end if;
	end process;
	--

   to_gbtTx(1).widebusExtraData                 <= widebusExtraData_from_pattGen;
   
   to_gbtTx(1).encodingSel                      <= TX_ENCODING_SEL_I;
   to_gbtRx(1).encodingSel                      <= RX_ENCODING_SEL_I;
   to_gbtTx(1).isDataSel                        <= TX_ISDATA_SEL_I;  
   RX_ISDATA_FLAG_O                             <= from_gbtRx(1).isDataFlag;    
   
   to_mgt(1).loopBack                           <= LOOPBACK_I;
   to_mgt(1).tx_syncReset                       <= '0';
   to_mgt(1).rx_syncReset                       <= '0';
   to_mgt(1).conf_diff                          <= "1000";    -- Comment: 810 mVppd
   to_mgt(1).conf_pstEmph                       <= "00000";   -- Comment: 0.18 dB (default)
   to_mgt(1).conf_preEmph                       <= "0000";    -- Comment: 0.15 dB (default)
   to_mgt(1).conf_eqMix                         <= "000";     -- Comment: 12 dB (default)
   to_mgt(1).conf_txPol                         <= '0';       -- Comment: Not inverted
   to_mgt(1).conf_rxPol                         <= '0';       -- Comment: Not inverted        
         
   LATENCY_OPT_GBTLINK_O                        <= from_mgt(1).latOptGbtLink;
   MGT_READY_O                                  <= from_mgt(1).ready;
   RX_WORDCLK_ALIGNED_O                         <= from_mgt(1).rx_wordClk_aligned;   
   RX_HEADER_LOCKED_O                           <= from_gbtRx(1).header_lockedFlag;
   RX_BITSLIP_NUMBER_O                          <= from_gbtRx(1).bitSlip_nbr;
   
   -- Comment: The fabric clock scheme of the RX MGT(GTX) (RX_USRCLK2) is generated within the 
   --          GBT Link.   
   
   to_mgt(1).usrBuf_rxUsrClk2                   <= '0';   
   
   -- Comment: * The manual phase alignment control of the MGT(GTX) transceivers is not used in this reference
   --            design (auto phase alignment is used instead).
   --
   --          * Note!! The manual phase alignment control of the MGT(GTX) MUST be synchronous with "rx_word_clk"
   --                   (this clock is forwarded out from the GBT Link through the record port "CLKS_O").
   
   to_mgt(1).rx_slide_enable                    <= '1'; 
   to_mgt(1).rx_slide_ctrl                      <= '0'; 
   to_mgt(1).rx_slide_nbr                       <= "00000";
   to_mgt(1).rx_slide_run                       <= '0';
   
   -- Comment: * The DRP port of the MGT(GTX) transceiver is not used in this reference design.   
   
   to_mgt(1).drp_dClk                           <= '0';
   to_mgt(1).drp_dAddr                          <= x"00";
   to_mgt(1).drp_dEn                            <= '0';
   to_mgt(1).drp_dI                             <= x"0000";
   to_mgt(1).drp_dWe                            <= '0';

   -- Comment: The built-in PRBS generator/checker of the MGT(GTX) transceiver is not used in this reference design.

   to_mgt(1).prbs_txEn                          <= "000";
   to_mgt(1).prbs_rxEn                          <= "000";
   to_mgt(1).prbs_forcErr                       <= '0';
   to_mgt(1).prbs_errCntRst                     <= '0';            
   
   --==============================--
   -- RX frame clock phase aligner --
   --==============================--
   
   -- Comment: * This phase aligner uses the header of the gbt frame as a reference point for matching the rising
   --            edge of the recovered rx frame clock with the rising edge of the tx frame clock of the TRANSMITTER
   --            BOARD when using the latency-optimized MGT(GTX).  
   -- 
   --          * Note!! The phase alignment is only triggered when LATENCY-OPTIMIZED GBT Link.
   
   rxFrameClkPhaAl: entity work.xlx_v6_rxframeclk_ph_alig
      port map (
         RESET_I                                => gbt_rxReset_from_gbtLinkRst,
         ---------------------------------------      
         RX_WORDCLK_I                           => clks_from_gbtLink.rx_wordClk(1),
         RX_FRAMECLK_O                          => rxFrameClk_from_rxFrameClkPhaAl,         
         ---------------------------------------      
         SYNC_I                                 => from_gbtRx(1).header_flag and from_mgt(1).latOptGbtLink,
         ---------------------------------------
         DONE_O                                 => phaseAlignDone_from_rxPll
      );          
            
   RX_FRAMECLK_ALIGNED_O                        <= phaseAlignDone_from_rxPll;
            
   --===============--     
   -- GBT RX status --     
   --===============--        
            
   gbtRxStatus: entity work.gbt_rx_status    
      port map (     
         RESET_I                                => gbt_rxReset_from_gbtLinkRst,
         CLK_I                                  => clks_to_gbtLink.rx_frameClk,
         ---------------------------------------
         GBT_LINK_OPTIMIZATION_I                => from_mgt(1).latOptGbtLink,
         DESCR_RDY_I                            => from_gbtRx(1).descrRdy,
         ---------------------------------------
         RX_WORDCLK_ALIGNED_I                   => from_mgt(1).rx_wordClk_aligned,
         RX_FRAMECLK_ALIGNED_I                  => phaseAlignDone_from_rxPll,
         ---------------------------------------
         RX_GBT_READY_O                         => rxGbtReady_from_gbtRxStatus
      );       
         
   RX_GBT_READY_O                               <= rxGbtReady_from_gbtRxStatus;
         
   --=========--
   -- RX data --
   --=========--  
   
   -- Comment: * This error detector checks whether there are errors in the data received as well as the ready 
   --            flag of the GBT RX does not go low after asserted for the first time during data transmission.
   --
   --          * The PATTERN_SEL_I port of the pattern generator as well as the error detector are controlled by the
   --            TEST_PATTERN_SEL_I port.
   --
   --          * If the GBT RX ready flag goes low at some point, RX_GBT_READY_LOST_FLAG_O is also asserted until reset.
   --
   --          * If RX GBT ready flag equals '1', asserts "COMMONDATA_ERROR_SEEN_FLAG_O" when an error is seen in the "COMMON_DATA_I".          
   --          * If RX GBT ready flag equals '1', asserts "WIDEBUSDATA_ERROR_SEEN_FLAG_O" when an error is seen in the "WIDEBUS_EXTRA_DATA_I".
   --
   --          * These error flags remain asserted until reset. 
   --
   --          * Note!! "COMMONDATA_ERROR_SEEN_FLAG_O" must be reset after selecting a new pattern.
   --          * Note!! "WIDEBUSDATA_ERROR_SEEN_FLAG_O" must be reset after selecting a new pattern.   
   
   errDet: entity work.error_detector
      port map (
         RESET_I                                => gbt_rxReset_from_gbtLinkRst,         
         CLK_I                                  => clks_to_gbtLink.rx_frameClk, 
         ---------------------------------------      
         RX_GBT_READY                           => rxGbtReady_from_gbtRxStatus,
         ---------------------------------------      
         COMMON_DATA_I                          => from_gbtRx(1).data,        
         WIDEBUS_EXTRA_DATA_I                   => from_gbtRx(1).widebusExtraData,
         ---------------------------------------      
         RX_ENCODING_SEL_I                      => RX_ENCODING_SEL_I,
         PATTERN_SEL_I                          => TEST_PATTERN_SEL_I,        
         COMMON_STATIC_PATTERN_I                => x"0000BABEAC1DACDCFFFFF",        
         WIDEBUS_STATIC_PATTERN_I               => x"BEEFCAFE",  
         RESET_DATA_ERROR_SEEN_FLAG_I           => RESET_DATA_ERROR_SEEN_FLAG_I,  
         RESET_RX_GBT_READY_LOST_FLAG_I         => RESET_RX_GBT_READY_LOST_FLAG_I,               
         ---------------------------------------      
         RX_GBT_READY_LOST_FLAG_O               => RX_GBT_READY_LOST_FLAG_O, 
         COMMONDATA_ERROR_SEEN_FLAG_O           => COMMONDATA_ERROR_SEEN_FLAG_O,
         WIDEBUSDATA_ERROR_SEEN_FLAG_O          => WIDEBUSDATA_ERROR_SEEN_FLAG_O
      );    
      
   RX_DATA_O                                    <= from_gbtRx(1).data;
   RX_WIDEBUS_EXTRA_DATA_O                      <= from_gbtRx(1).widebusExtraData;
   
   --=====================--
   -- Latency measurement --
   --=====================--   

   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If the RX data comes from another board with a different reference clock, 
   --                   then the TX frame/word clock domains are asynchronous with respect to the
   --                   RX frame/word clock domains.
   
   TX_FRAMECLK_O                                <= clks_to_gbtLink.tx_frameClk;
   RX_FRAMECLK_O                                <= clks_to_gbtLink.rx_frameClk; 
   TX_WORDCLK_O                                 <= clks_from_gbtLink.tx_wordClk(1); 
   RX_WORDCLK_O                                 <= clks_from_gbtLink.rx_wordClk(1);    
   
   -- Pattern match flags:
   -----------------------      
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test.
   
   txFlag: entity work.pattern_match_flag
      PORT MAP (
         RESET_I                                => gbt_txReset_from_gbtLinkRst,
         CLK_I                                  => TX_FRAMECLK_I,
         DATA_I                                 => commonData_from_pattGen,
         MATCHFLAG_O                            => TX_MATCHFLAG_O
      );
   
   rxFlag: entity work.pattern_match_flag
      PORT MAP (
         RESET_I                                => gbt_rxReset_from_gbtLinkRst,
         CLK_I                                  => clks_to_gbtLink.rx_frameClk,
         DATA_I                                 => from_gbtRx(1).data,
         MATCHFLAG_O                            => RX_MATCHFLAG_O
      );
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--