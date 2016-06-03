--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Virtex 6 - Multi Gigabit Transceivers latency-optimized
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
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        20/06/2013   3.0       M. Barros Marin   First .vhd module definition
--
--                        29/08/2014   3.2       M. Barros Marin   RX_WORDCLK ready flag high when RX STD
--
-- Additional Comments:
--
-- * Note!! The GTX TX and RX PLLs reference clocks frequency is 240 MHz
--
-- * Note!! The Elastic buffers are bypassed in this latency-optimized GTX (reduces the latency as well
--          as ensures deterministic latency within the GTX)
--
-- * Note!! The phase of the recovered clock is shifted during bitslip. This is done to achieve
--          deterministic phase when crossing from serial clock (2.4Ghz DDR) to RX_RECCLK (240MHz SDR)                                                                               
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

entity mgt_latopt is  
   generic (   
      GBT_BANK_ID                                    : integer := 1;
      NUM_LINKS                                      : integer := 1;
      TX_OPTIMIZATION                                : integer range 0 to 1 := STANDARD;
      RX_OPTIMIZATION                                : integer range 0 to 1 := STANDARD;
      TX_ENCODING                                    : integer range 0 to 1 := GBT_FRAME;
      RX_ENCODING                                    : integer range 0 to 1 := GBT_FRAME
   );   
   port (     
        
      --===============--    
      -- Clocks scheme --    
      --===============--          
           
      MGT_CLKS_I                                     : in  gbtBankMgtClks_i_R;         
      MGT_CLKS_O                                     : out gbtBankMgtClks_o_R;        
     
      --=========--    
      -- MGT I/O --    
      --=========--    
           
      MGT_I                                          : in  mgt_i_R;
      MGT_O                                          : out mgt_o_R;
                 
      --========--
      -- Clocks --
      --========--
      TX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);   
       
      -- Phase monitoring:
      --------------------
    
      PHASE_ALIGNED_I                                    : in  std_logic;
      PHASE_COMPUTING_DONE_I                            : in  std_logic;
		
      --=============--      
      -- GBT Control --      
      --=============--      
     
      GBTTX_MGTTX_RDY_O                              : out std_logic_vector      (1 to NUM_LINKS);
                                                                                 
      GBTRX_MGTRX_RDY_O                              : out std_logic_vector      (1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                        : out std_logic_vector      (1 to NUM_LINKS);      
      -----------------------------------------------                            
      GBTRX_HEADER_LOCKED_I                          : in  std_logic_vector      (1 to NUM_LINKS);
      GBTRX_BITSLIP_NBR_I                            : in  rxBitSlipNbr_mxnbit_A (1 to NUM_LINKS);
        
      --=======--      
      -- Words --      
      --=======--      
           
      GBTTX_WORD_I                                   : in  word_mxnbit_A         (1 to NUM_LINKS);     
      GBTRX_WORD_O                                   : out word_mxnbit_A         (1 to NUM_LINKS)     

   );
end mgt_latopt;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_latopt is    
   
   --================================ Signal Declarations ================================--
   
   --===============--
   -- Resets scheme --      
   --===============--       
  
   signal txResetDone_from_gtx                       : std_logic_vector          (1 to NUM_LINKS);
   signal rxResetDone_from_gtx                       : std_logic_vector          (1 to NUM_LINKS);
                                                                                 
   -- TX reset done synchronization registers:                                   
   -------------------------------------------                                   
                                                                                 
   signal txResetDone_r                              : std_logic_vector          (1 to NUM_LINKS);
   signal txResetDone_r2_from_gtxTxRstDoneSync       : std_logic_vector          (1 to NUM_LINKS);
                                                                                 
   -- RX reset done synchronization registers:                                   
   -------------------------------------------                                   
                                                                                 
   signal rxResetDone_r_from_gtxRxRstDoneSync1       : std_logic_vector          (1 to NUM_LINKS);
   signal rxResetDone_r2                             : std_logic_vector          (1 to NUM_LINKS);
   --------------------------------------------------                            
   signal rxResetDone_r3                             : std_logic_vector          (1 to NUM_LINKS);
   signal rxResetDone_r4_from_gtxRxRstDoneSync2      : std_logic_vector          (1 to NUM_LINKS);
                                                                                 
   --==============================--                                            
   -- MGT internal phase alignment --                                            
   --==============================--                                            
                                                                                 
   -- TX synchronizer:                                                           
   -------------------                                                           
                                                                                 
   signal txEnPmaPhaseAlign_from_txSync              : std_logic_vector          (1 to NUM_LINKS);
   signal txPmaSetPhase_from_txSync                  : std_logic_vector          (1 to NUM_LINKS);
   signal txDlyAlignDisable_from_txSync              : std_logic_vector          (1 to NUM_LINKS);
   signal txDlyAlignReset_from_txSync                : std_logic_vector          (1 to NUM_LINKS);
   signal txSyncDone_from_txSync                     : std_logic_vector          (1 to NUM_LINKS);
   --------------------------------------------------                            
   signal reset_to_txSync                            : std_logic_vector          (1 to NUM_LINKS);
                                                                                 
   -- RX synchronizer:                                                           
   -------------------                                                           
                                                                                 
   signal rxEnPmaPhaseAlign_from_rxSync              : std_logic_vector          (1 to NUM_LINKS); 
   signal rxPmaSetPhase_from_rxSync                  : std_logic_vector          (1 to NUM_LINKS);
   signal rxDlyAlignDisable_from_rxSync              : std_logic_vector          (1 to NUM_LINKS);
   signal rxDlyAlignOverride_from_rxSync             : std_logic_vector          (1 to NUM_LINKS);
   signal rxDlyAlignReset_from_rxSync                : std_logic_vector          (1 to NUM_LINKS);
   signal rxSyncDone_from_rxSync                     : std_logic_vector          (1 to NUM_LINKS);
   --------------------------------------------------                            
   signal reset_to_rxSync                            : std_logic_vector          (1 to NUM_LINKS);
                                                                                 
   --========================--                                                  
   -- RX phase alignment --                                                      
   --========================--                                                  
                                                                                 
   signal nbr_to_rxBitSlipControl                    : rxBitSlipNbr_mxnbit_A     (1 to NUM_LINKS);
   signal run_to_rxBitSlipControl                    : std_logic_vector          (1 to NUM_LINKS);
   signal rxBitSlip_from_rxBitSlipControl            : std_logic_vector          (1 to NUM_LINKS);
   signal rxBitSlip_to_gtx                           : std_logic_vector          (1 to NUM_LINKS);
   signal resetGtxRx_from_rxBitSlipControl           : std_logic_vector          (1 to NUM_LINKS);
   signal done_from_rxBitSlipControl                 : std_logic_vector          (1 to NUM_LINKS);
   
   --============--
   -- Clocks     --
   --============--
   signal tx_wordclk_sig                         : std_logic_vector(1 to NUM_LINKS);
   signal tx_wordclk_nobuff_sig                   : std_logic_vector(1 to NUM_LINKS);
   signal rx_wordclk_sig                         : std_logic_vector(1 to NUM_LINKS);
   signal rx_wordclk_nobuff_sig                   : std_logic_vector(1 to NUM_LINKS);
 
   --=====================================================================================--      

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--

   gtxLatOpt_gen: for i in 1 to NUM_LINKS generate   
   
      --=============--
      -- Assignments --
      --=============--
   
      MGT_O.mgtLink(i).tx_resetDone                  <= txResetDone_r2_from_gtxTxRstDoneSync(i);
      MGT_O.mgtLink(i).rx_resetDone                  <= rxResetDone_r4_from_gtxRxRstDoneSync2(i);   
      MGT_O.mgtLink(i).ready                         <= txSyncDone_from_txSync(i) and rxSyncDone_from_rxSync(i);      
      GBTTX_MGTTX_RDY_O(i)                           <= txSyncDone_from_txSync(i); 
      GBTRX_MGTRX_RDY_O(i)                           <= rxSyncDone_from_rxSync(i); 
      
      --====================--
      -- RX phase alignment --
      --====================--

      -- Comment: Note!! The standard version of the GTX does not align the phase of the  
      --                  RX_RECCLK (RX_WORDCLK) with respect to the TX_OUTCLK (TX_WORDCLK).

      rxPhaseAlign_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
      
         -- Bitslip control module:
         --------------------------
         
         rxBitSlipControl: entity work.mgt_latopt_bitslipctrl 
            port map (
               RX_RESET_I                             => MGT_I.mgtLink(i).rx_reset,
               RX_WORDCLK_I                           => rx_wordclk_sig(i), --MGT_CLKS_I.rx_wordClk(i),
               NUMBITSLIPS_I                          => nbr_to_rxBitSlipControl(i),
               ENABLE_I                               => run_to_rxBitSlipControl(i),
               MGT_RX_ODD_RESET_EN_I                  => MGT_I.mgtLink(i).rxBitSlip_oddRstEn,
               BITSLIP_O                              => rxBitSlip_from_rxBitSlipControl(i),
               RESET_MGT_RX_O                         => resetGtxRx_from_rxBitSlipControl(i),
               RESET_MGT_RX_ITERATIONS_O              => MGT_O.mgtLink(i).rxBitSlip_oddRstNbr,
               DONE_O                                 => done_from_rxBitSlipControl(i)
            );
         
         MGT_O.mgtLink(i).rxWordClkReady             <= done_from_rxBitSlipControl(i);
         GBTRX_RXWORDCLK_READY_O(i)                  <= done_from_rxBitSlipControl(i);
         
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
      
         -- Comment: * MGT_I(i).rxBitSlip_enable must be '1' to enable the GT RX phase alignment.
         --
         --          * Manual control: MGT_I(i).rxBitSlip_ctrl = '1'
         --            Auto control  : MGT_I(i).rxBitSlip_ctrl = '0'
         --
         --          * In manual control, the user provides the number of bitslips (rxBitSlip_nbr)
         --            as well as triggers the GT RX phase alignment (rxBitSlip_run).
      
         rxBitSlip_to_gtx(i)        <= rxBitSlip_from_rxBitSlipControl(i) when    MGT_I.mgtLink(i).rxBitSlip_enable   = '1'
                                       ------------------------------------------------------------------------------
                                       else '0'; 
                                      
         run_to_rxBitSlipControl(i) <= MGT_I.mgtLink(i).rxBitSlip_run     when     MGT_I.mgtLink(i).rxBitSlip_enable   = '1' 
                                                                               and MGT_I.mgtLink(i).rxBitSlip_ctrl     = '1'
                                       -------------------------------------------------------------------------------
                                       else GBTRX_HEADER_LOCKED_I(i)      when     MGT_I.mgtLink(i).rxBitSlip_enable   = '1'
                                                                               and MGT_I.mgtLink(i).rxBitSlip_ctrl     = '0'
                                       -------------------------------------------------------------------------------
                                       else '0';
                                      
         nbr_to_rxBitSlipControl(i) <= MGT_I.mgtLink(i).rxBitSlip_nbr     when     MGT_I.mgtLink(i).rxBitSlip_enable   = '1'
                                                                               and MGT_I.mgtLink(i).rxBitSlip_ctrl     = '1'
                                       -------------------------------------------------------------------------------                                  
                                       else GBTRX_BITSLIP_NBR_I(i)        when     MGT_I.mgtLink(i).rxBitSlip_enable   = '1'
                                                                               and MGT_I.mgtLink(i).rxBitSlip_ctrl     = '0'
                                       -------------------------------------------------------------------------------                                  
                                       else "00000"; 
 
      end generate;
      
      rxPhaseAlign_no_gen: if RX_OPTIMIZATION = STANDARD generate
      
         -- Bitslip control module:
         --------------------------
         
         MGT_O.mgtLink(i).rxWordClkReady             <= rxResetDone_from_gtx(i);
         
         GBTRX_RXWORDCLK_READY_O(i)                  <= rxResetDone_from_gtx(i);
         
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
      
         rxBitSlip_to_gtx(i)                         <= '0';
      
      end generate; 
      
      --================================================--
      -- Multi-Gigabit Transceivers (latency-optimized) --
      --================================================--  

      gtxLatOpt: entity work.xlx_v6_gtx_latopt
         generic map (
            GTX_SIM_GTXRESET_SPEEDUP                 => speedUp(GBT_BANKS_USER_SETUP(GBT_BANK_ID).SPEEDUP_FOR_SIMULATION))   
         port map (        
            -----------------------------------------
            LOOPBACK_IN                              => MGT_I.mgtLink(i).loopBack,
            -----------------------------------------
            RXSLIDE_IN                               => rxBitSlip_to_gtx(i),
            -----------------------------------------
            PRBSCNTRESET_IN                          => MGT_I.mgtLink(i).prbs_errCntRst, 
            RXENPRBSTST_IN                           => MGT_I.mgtLink(i).prbs_rxEn,  
            RXPRBSERR_OUT                            => MGT_O.mgtLink(i).prbs_rxErr,     
            -----------------------------------------
            RXDATA_OUT                               => GBTRX_WORD_O(i),
            RXRECCLK_OUT                             => rx_wordclk_nobuff_sig(i), --MGT_CLKS_O.rx_wordClk_noBuff(i),
            RXUSRCLK2_IN                             => rx_wordclk_sig(i), --MGT_CLKS_I.rx_wordClk(i),
            -----------------------------------------
            RXEQMIX_IN                               => MGT_I.mgtLink(i).conf_eqMix,
            RXN_IN                                   => MGT_I.mgtLink(i).rx_n,
            RXP_IN                                   => MGT_I.mgtLink(i).rx_p,
            -----------------------------------------
            RXDLYALIGNDISABLE_IN                     => rxDlyAlignDisable_from_rxSync(i),          
            RXDLYALIGNMONENB_IN                      => '0',                              
            RXDLYALIGNMONITOR_OUT                    => open,                             
            RXDLYALIGNOVERRIDE_IN                    => rxDlyAlignOverride_from_rxSync(i),      
            RXDLYALIGNRESET_IN                       => rxDlyAlignReset_from_rxSync(i),            
            RXENPMAPHASEALIGN_IN                     => rxEnPmaPhaseAlign_from_rxSync(i),    
            RXPMASETPHASE_IN                         => rxPmaSetPhase_from_rxSync(i),
            -----------------------------------------
            GTXRXRESET_IN                            => MGT_I.mgtLink(i).rx_reset or resetGtxRx_from_rxBitSlipControl(i),
            MGTREFCLKRX_IN                           => ('0' & MGT_CLKS_I.rx_refClk),
            PLLRXRESET_IN                            => '0',
            RXPLLLKDET_OUT                           => MGT_O.mgtLink(i).rx_pllLkDet,
            RXRESETDONE_OUT                          => rxResetDone_from_gtx(i),
            -----------------------------------------
            RXPOLARITY_IN                            => MGT_I.mgtLink(i).conf_rxPol,
            -----------------------------------------
            DADDR_IN                                 => MGT_I.mgtLink(i).drp_dAddr,   
            DCLK_IN                                  => MGT_CLKS_I.drp_dClk,
            DEN_IN                                   => MGT_I.mgtLink(i).drp_dEn,    
            DI_IN                                    => MGT_I.mgtLink(i).drp_dI,     
            DRDY_OUT                                 => MGT_O.mgtLink(i).drp_dRdy,   
            DRPDO_OUT                                => MGT_O.mgtLink(i).drp_dRpDo,  
            DWE_IN                                   => MGT_I.mgtLink(i).drp_dWe,   
            -----------------------------------------
            TXDATA_IN                                => GBTTX_WORD_I(i),
            TXOUTCLK_OUT                             => tx_wordclk_nobuff_sig(i), --MGT_CLKS_O.tx_wordClk_noBuff(i),
            TXUSRCLK2_IN                             => tx_wordclk_sig(i), --MGT_CLKS_I.tx_wordClk(i),
            -----------------------------------------
            TXDIFFCTRL_IN                            => MGT_I.mgtLink(i).conf_diff,
            TXN_OUT                                  => MGT_O.mgtLink(i).tx_n,
            TXP_OUT                                  => MGT_O.mgtLink(i).tx_p,
            TXPOSTEMPHASIS_IN                        => MGT_I.mgtLink(i).conf_pstEmph,
            -----------------------------------------
            TXPREEMPHASIS_IN                         => MGT_I.mgtLink(i).conf_preEmph,
            -----------------------------------------
            TXDLYALIGNDISABLE_IN                     => txDlyAlignDisable_from_txSync(i),          
            TXDLYALIGNMONENB_IN                      => '0',                                
            TXDLYALIGNMONITOR_OUT                    => open,                                
            TXDLYALIGNRESET_IN                       => txDlyAlignReset_from_txSync(i),            
            TXENPMAPHASEALIGN_IN                     => txEnPmaPhaseAlign_from_txSync(i),          
            TXPMASETPHASE_IN                         => txPmaSetPhase_from_txSync(i),
            -----------------------------------------
            GTXTXRESET_IN                            => MGT_I.mgtLink(i).tx_reset,
            MGTREFCLKTX_IN                           => ('0' & MGT_CLKS_I.tx_refClk),
            PLLTXRESET_IN                            => '0',
            TXPLLLKDET_OUT                           => MGT_O.mgtLink(i).tx_pllLkDet,
            TXRESETDONE_OUT                          => txResetDone_from_gtx(i),
            -----------------------------------------
            TXENPRBSTST_IN                           => MGT_I.mgtLink(i).prbs_txEn,         
            TXPRBSFORCEERR_IN                        => MGT_I.mgtLink(i).prbs_forcErr,  
            -----------------------------------------
            TXPOLARITY_IN                            => MGT_I.mgtLink(i).conf_txPol     
         );

        rxWordClkBufg: bufg
            port map (
                  O                                        => rx_wordclk_sig(i), 
                  I                                        => rx_wordclk_nobuff_sig(i)
            );                              
   
        txWordClkBufg: bufg
               port map (
                  O                                        => tx_wordclk_sig(i), 
                  I                                        => tx_wordclk_nobuff_sig(i)
               );
                   
         TX_WORDCLK_O(i) <= tx_wordclk_sig(i);
         RX_WORDCLK_O(i) <= rx_wordclk_sig(i);
         MGT_CLKS_O.tx_wordClk(i) <= tx_wordclk_sig(i);     
         MGT_CLKS_O.rx_wordClk(i) <= rx_wordclk_sig(i); 
			
      --==============--
      -- Reset scheme --      
      --==============--    
      
      -- TX reset done synchronization registers:
      -------------------------------------------
      
      gtxTxRstDoneSync: process(txResetDone_from_gtx(i), tx_wordclk_sig(i))
      begin
         if txResetDone_from_gtx(i) = '0' then       
            txResetDone_r2_from_gtxTxRstDoneSync(i)  <= '0';         
            txResetDone_r(i)                         <= '0';
         elsif rising_edge(tx_wordclk_sig(i)) then   
            txResetDone_r2_from_gtxTxRstDoneSync(i)  <= txResetDone_r(i);
            txResetDone_r(i)                         <= txResetDone_from_gtx(i);         
         end if;
      end process;
      
      -- RX reset done synchronization registers:
      -------------------------------------------  
      
      gtxRxRstDoneSync1: process(rx_wordclk_sig(i))
      begin
         if rising_edge(rx_wordclk_sig(i)) then        
            rxResetDone_r_from_gtxRxRstDoneSync1(i)  <= rxResetDone_from_gtx(i);  
         end if; 
      end process;
      
      gtxRxRstDoneSync2: process(rxResetDone_r_from_gtxRxRstDoneSync1(i), rx_wordclk_sig(i))
      begin
         if rxResetDone_r_from_gtxRxRstDoneSync1(i) = '0' then      
            rxResetDone_r4_from_gtxRxRstDoneSync2(i) <= '0';
            rxResetDone_r3(i)                        <= '0';
            rxResetDone_r2(i)                        <= '0';
         elsif rising_edge(rx_wordclk_sig(i)) then       
            rxResetDone_r4_from_gtxRxRstDoneSync2(i) <= rxResetDone_r3(i);
            rxResetDone_r3(i)                        <= rxResetDone_r2(i);
            rxResetDone_r2(i)                        <= rxResetDone_r_from_gtxRxRstDoneSync1(i); 
         end if; 
      end process;
      
      --==============================--
      -- MGT internal phase alignment --
      --==============================--
      
      -- Comment: The internal clock domains of the GTX must be synchronized due to the elastic buffer bypassing. 
      
      -- TX synchronizer:
      -------------------
      
      reset_to_txSync(i)                             <= (not txResetDone_r2_from_gtxTxRstDoneSync(i)) or MGT_I.mgtLink(i).tx_syncReset;
      
      txSync: entity work.xlx_v6_gtx_latopt_tx_sync
         generic map (
            SIM_TXPMASETPHASE_SPEEDUP                => speedUp(GBT_BANKS_USER_SETUP(GBT_BANK_ID).SPEEDUP_FOR_SIMULATION))
         port map (         
            TXENPMAPHASEALIGN                        => txEnPmaPhaseAlign_from_txSync(i),
            TXPMASETPHASE                            => txPmaSetPhase_from_txSync(i),
            TXDLYALIGNDISABLE                        => txDlyAlignDisable_from_txSync(i),
            TXDLYALIGNRESET                          => txDlyAlignReset_from_txSync(i),
            SYNC_DONE                                => txSyncDone_from_txSync(i),
            USER_CLK                                 => tx_wordclk_sig(i),
            RESET                                    => reset_to_txSync(i)
         );

      -- RX synchronizer:
      -------------------
      
      reset_to_rxSync(i)                             <= (not rxResetDone_r4_from_gtxRxRstDoneSync2(i)) or MGT_I.mgtLink(i).rx_syncReset; 
      
      rxSync: entity work.xlx_v6_gtx_latopt_rx_sync
         port map (                                                                            
            RXENPMAPHASEALIGN                        => rxEnPmaPhaseAlign_from_rxSync(i),                        
            RXPMASETPHASE                            => rxPmaSetPhase_from_rxSync(i),                            
            RXDLYALIGNDISABLE                        => rxDlyAlignDisable_from_rxSync(i),                        
            RXDLYALIGNOVERRIDE                       => rxDlyAlignOverride_from_rxSync(i),                       
            RXDLYALIGNRESET                          => rxDlyAlignReset_from_rxSync(i),                          
            SYNC_DONE                                => rxSyncDone_from_rxSync(i),                               
            USER_CLK                                 => rx_wordclk_sig(i),
            RESET                                    => reset_to_rxSync(i)
         );         

   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--