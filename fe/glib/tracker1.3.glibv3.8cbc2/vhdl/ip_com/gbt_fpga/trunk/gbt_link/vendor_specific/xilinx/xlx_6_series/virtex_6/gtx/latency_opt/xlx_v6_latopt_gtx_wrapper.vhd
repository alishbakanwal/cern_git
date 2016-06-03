--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            Xilinx Virtex 6 latency-optimized GTX wrapper                                       
--                                                                                                 
-- Language:               VHDL'93                                                                 
--                                                                                                   
-- Target Device:          Xilinx Virtex 6                                                         
-- Tool version:           ISE 14.5                                                                
--                                                                                                   
-- Revision:               1.0                                                                      
--
-- Description:           
--
-- Versions history:       DATE         VERSION   AUTHOR              DESCRIPTION
--
--                         21/06/2013   1.0       M. BARROS MARIN     - First .vhd module definition           
--
-- Additional Comments:
--
-- - Note!! The GTX TX and RX PLLs reference clocks frequency is 240 MHz
--
-- - Note!! The Elastic buffers are bypassed in this latency-optimized GTX (reduces the latency as well
--          as ensures deterministic latency within the GTX)
--
-- - Note!! * The phase of the recovered clock is shifted during bitslip. This is done to achieve
--            deterministic phase when crossing from serial clock (2.4Ghz DDR) to RXRECCLK (240MHz SDR)
--                                                                          
--                                                                                                   
--=================================================================================================--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--======================================= module body =============================================-- 
--=================================================================================================--
entity xlx_v6_latopt_gtx_wrapper is  
   port (   
   
      --===============--
      -- Clocks scheme --
      --===============--
   
      -- Reference clocks:      
      --------------------
      
      GTX_TX_REFCLK_I                           : in  std_logic;   
      GTX_RX_REFCLK_I                           : in  std_logic;   
         
      -- Fabric clocks: 
      -----------------       
         
      TXOUTCLK_O                                : out std_logic;         
      RXRECCLK_O                                : out std_logic;         
      TXUSRCLK2_I                               : in  std_logic;        
      RXUSRCLK2_I                               : in  std_logic;      
      
      -- GTX internal PLLs status:
      ----------------------------
      
      TX_PLLLKDET_O                             : out std_logic;
      RX_PLLLKDET_O                             : out std_logic;
            
      --===============--  
      -- Resets scheme --         
      --===============--     
         
      -- Control: 
      -----------       
         
      TX_RESET_I                                : in  std_logic; 
      RX_RESET_I                                : in  std_logic;
      TX_PLL_RESET_I                            : in  std_logic; 
      RX_PLL_RESET_I                            : in  std_logic;
      TX_SYNC_RESET_I                           : in  std_logic; 
      RX_SYNC_RESET_I                           : in  std_logic;       
            
      -- Status:          
      ----------  
         
      TX_RESETDONE_O                            : out std_logic;      
      RX_RESETDONE_O                            : out std_logic;
      
      --=======================================--
      -- TX driver & RX receiver configuration --
      --=======================================--            
      
      -- TX driver:
      -------------
      
      TX_DIFFCTRL_I                             : in  std_logic_vector(3 downto 0);
      TX_POSTEMPHASIS_I                         : in  std_logic_vector(4 downto 0);
      TX_PREEMPHASIS_I                          : in  std_logic_vector(3 downto 0);
      TX_POLARITY_I                             : in  std_logic;
         
      -- RX receiver:  
      ---------------  
      
      RX_POLARITY_I                             : in  std_logic;  
      RX_EQMIX_I                                : in  std_logic_vector(2 downto 0);
      
      --====================================--
      -- Dynamic Reconfiguration Port (DRP) --
      --====================================--      
     
      DCLK_I                                    : in  std_logic;   
      DADDR_I                                   : in  std_logic_vector(7 downto 0);   
      DEN_I                                     : in  std_logic;   
      DI_I                                      : in  std_logic_vector(15 downto 0);   
      DRDY_O                                    : out std_logic;  
      DRPDO_O                                   : out std_logic_vector(15 downto 0);  
      DWE_I                                     : in  std_logic;
         
      --==========--
      -- Loopback --
      --==========--     
     
      LOOPBACK_I                                : in  std_logic_vector(2 downto 0);
      
      --===================================--
      -- Pseudo Random Bit Sequence (PRBS) --
      --===================================--      
      
      TX_ENPRBSTST_I                            : in  std_logic_vector(2 downto 0);
      RX_ENPRBSTST_I                            : in  std_logic_vector(2 downto 0);
      TX_PRBSFORCEERR_I                         : in  std_logic;       
      RX_PRBSERR_O                              : out std_logic;      
      PRBSCNTRESET_I                            : in  std_logic;       
      
      --=====================--
      -- GTX synchronization -- 
      --=====================--
      
      GTX_SYNC_DONE_O                           : out std_logic;
      
      --====================--
      -- RX phase alignment --          
      --====================--      
     
      -- Control:
      -----------      
      
      RX_SLIDE_INT_EN_I                         : in  std_logic;      
      RX_SLIDE_INT_CTRL_I                       : in  std_logic;      
      RX_SLIDE_INT_NBR_I                        : in  std_logic_vector(4 downto 0);
      RX_SLIDE_INT_RUN_I                        : in  std_logic;
      ------------------------------------------
      RX_SLIDE_GBTRX_ALIGNED_I                  : in  std_logic;
      RX_SLIDE_GBTRX_NBR_I                      : in  std_logic_vector(4 downto 0);    
      
      -- Status:
      ----------
      
      RXWORDCLK_ALIGNED_O                       : out std_logic;     
      
      --======--
      -- Data --
      --======--
      
      -- Parallel data:      
      -----------------      
      
      TX_DATA_I                                 : in  std_logic_vector(19 downto 0);
      RX_DATA_O                                 : out std_logic_vector(19 downto 0);
            
      -- Serial data:         
      ---------------         
            
      TX_P_O                                    : out std_logic;
      TX_N_O                                    : out std_logic;
      RX_P_I                                    : in  std_logic;
      RX_N_I                                    : in  std_logic      
    
   );
end xlx_v6_latopt_gtx_wrapper;
architecture structural of xlx_v6_latopt_gtx_wrapper is   

   --============================= Attributes ===============================--   
   
   attribute max_fanout                         : string; 
   
   --========================================================================--
   
   --========================= Signal Declarations ==========================--   
   
   --===============--
   -- Resets scheme --      
   --===============--       
  
   signal txResetDone_from_gtx                  : std_logic;
   signal rxResetDone_from_gtx                  : std_logic; 
   
   -- TX reset done synchronization registers:
   -------------------------------------------
   
   signal txResetDone_r                         : std_logic;
   signal txResetDone_r2_from_gtxTxRstDoneSync  : std_logic;
   
   -- RX reset done synchronization registers:
   -------------------------------------------      

   signal rxResetDone_r                         : std_logic;
   signal rxResetDone_r2                        : std_logic;
   signal rxResetDone_r3                        : std_logic;
   signal rxResetDone_r4_from_gtxRxRstDoneSync2 : std_logic;
   attribute max_fanout of rxResetDone_r : signal is "1";      
   
   --=====================--
   -- GTX synchronization -- 
   --=====================--

   -- TX synchronizer:
   -------------------
   
   signal gtx_tx_EnPmaPhaseAlign                : std_logic;
   signal gtx_tx_PmaSetPhase                    : std_logic;
   signal gtx_tx_dlyAlignDisable                : std_logic;
   signal gtx_tx_dlyAlignReset                  : std_logic;
   signal gtx_tx_syncDone                       : std_logic;
   ---------------------------------------------
   signal gtx_tx_reset_to_txSync                : std_logic;

   -- RX synchronizer:
   -------------------  
   
   signal gtx_rx_EnPmaPhaseAlign                : std_logic;   
   signal gtx_rx_PmaSetPhase                    : std_logic;
   signal gtx_rx_dlyAlignDisable                : std_logic;
   signal gtx_rx_dlyAlignOverride               : std_logic;
   signal gtx_rx_dlyAlignReset                  : std_logic;
   signal gtx_rx_syncDone                       : std_logic;
   ---------------------------------------------
   signal gtx_rx_reset_to_rxSync                : std_logic;
   
   --========================--
   -- RX phase alignment --
   --========================--
      
   signal bitSlipNbr_to_bitSlipControl          : std_logic_vector(4 downto 0);
   signal bitSlipRun_to_bitSlipControl          : std_logic;
   signal bitSlip_from_bitSlipControl           : std_logic;  
   
   signal bitSlip_to_gtx                        : std_logic;
   
   --========================================================================--      

--===========================================================================--
-----          --===================================================--
begin        --================== Architecture Body ==================-- 
-----          --===================================================--
--===========================================================================--
  
   --============================= User Logic ===============================--
   
   --==============--
   -- Reset scheme --      
   --==============--    
   
   -- TX reset done synchronization registers:
   -------------------------------------------
   
   gtxTxRstDoneSync: process(txResetDone_from_gtx, TXUSRCLK2_I)
   begin
      if txResetDone_from_gtx = '0' then         
         txResetDone_r2_from_gtxTxRstDoneSync   <= '0';         
         txResetDone_r                          <= '0';
      elsif rising_edge(TXUSRCLK2_I) then   
         txResetDone_r2_from_gtxTxRstDoneSync   <= txResetDone_r;
         txResetDone_r                          <= txResetDone_from_gtx;         
      end if;
   end process;
   
   -- RX reset done synchronization registers:
   -------------------------------------------  
   
   gtxRxRstDoneSync1: process(RXUSRCLK2_I)
   begin
      if rising_edge(RXUSRCLK2_I) then        
         rxResetDone_r                          <= rxResetDone_from_gtx;  
      end if; 
   end process;
   
   gtxRxRstDoneSync2: process(rxResetDone_r, RXUSRCLK2_I)
   begin
      if rxResetDone_r = '0' then      
         rxResetDone_r4_from_gtxRxRstDoneSync2  <= '0';
         rxResetDone_r3                         <= '0';
         rxResetDone_r2                         <= '0';
      elsif rising_edge(RXUSRCLK2_I) then        
         rxResetDone_r4_from_gtxRxRstDoneSync2  <= rxResetDone_r3;
         rxResetDone_r3                         <= rxResetDone_r2;
         rxResetDone_r2                         <= rxResetDone_r; 
      end if; 
   end process;   
   
   --=====================--
   -- GTX synchronization -- 
   --=====================--
   
   -- Comment: The internal clock domains of the GTX must be synchronized due to the elastic buffer bypassing. 
   
   -- TX synchronizer:
   -------------------
   
   txSync: entity work.xlx_v6_latopt_gtx_tx_sync
      generic map (
         SIM_TXPMASETPHASE_SPEEDUP              => SPEEDUP_FOR_SIMULATION)
      port map (         
         TXENPMAPHASEALIGN                      => gtx_tx_EnPmaPhaseAlign,
         TXPMASETPHASE                          => gtx_tx_PmaSetPhase,
         TXDLYALIGNDISABLE                      => gtx_tx_dlyAlignDisable,
         TXDLYALIGNRESET                        => gtx_tx_dlyAlignReset,
         SYNC_DONE                              => gtx_tx_syncDone,
         USER_CLK                               => TXUSRCLK2_I,
         RESET                                  => gtx_tx_reset_to_txSync
      );
      
   gtx_tx_reset_to_txSync                       <=  (not txResetDone_r2_from_gtxTxRstDoneSync) or TX_SYNC_RESET_I;

   -- RX synchronizer:
   -------------------
   
   rxSync: entity work.xlx_v6_latopt_gtx_rx_sync
      port map (                                                                             
         RXENPMAPHASEALIGN                      => gtx_rx_EnPmaPhaseAlign,                        
         RXPMASETPHASE                          => gtx_rx_PmaSetPhase,                            
         RXDLYALIGNDISABLE                      => gtx_rx_dlyAlignDisable,                        
         RXDLYALIGNOVERRIDE                     => gtx_rx_dlyAlignOverride,                       
         RXDLYALIGNRESET                        => gtx_rx_dlyAlignReset,                          
         SYNC_DONE                              => gtx_rx_syncDone,                               
         USER_CLK                               => RXUSRCLK2_I,
         RESET                                  => gtx_rx_reset_to_rxSync
      );         
         
   gtx_rx_reset_to_rxSync                       <= (not rxResetDone_r4_from_gtxRxRstDoneSync2) or RX_SYNC_RESET_I;      
   
   -- GTX synchronization done AND gate:
   -------------------------------------
      
   GTX_SYNC_DONE_O                              <= gtx_tx_syncDone and gtx_rx_syncDone;   
   
   --====================--
   -- RX phase alignment --
   --====================--
   
   -- Bitslip control module:
   --------------------------
   
   bitSlipControl: entity work.xlx_v6_gtx_bitslip_control 
      port map (
         RESET_I                                => RX_RESET_I,
         RXWORDCLK_I                            => RXUSRCLK2_I,
         NUMBITSLIPS_I                          => bitSlipNbr_to_bitSlipControl,
         ENABLE_I                               => bitSlipRun_to_bitSlipControl,
         BITSLIP_O                              => bitSlip_from_bitSlipControl,
         DONE_O                                 => RXWORDCLK_ALIGNED_O
      );       
        
   -- Manual or auto bitslip control selection logic:
   --------------------------------------------------
   
   -- Comment: * The "INTERFACE" (INT) ports allow the manual control of the GTX RX phase alignment.
   --
   --          * GTX_RX_SLIDE_INT_EN_I must be '1' to enable the GTX RX phase alignment.
   --
   --          * Manual control: GTX_RX_SLIDE_INT_CTRL_I = '1'
   --            Auto control  : GTX_RX_SLIDE_INT_CTRL_I = '0'
   --
   --          * In manual control, the user provides the number of bitslips (GTX_RX_SLIDE_INT_NBR_I)
   --            as well as triggers the GTX RX phase alignment (GTX_RX_SLIDE_INT_RUN_I).
   
   bitSlip_to_gtx                               <= bitSlip_from_bitSlipControl   when     RX_SLIDE_INT_EN_I   = '1'
                                                   ----------------------------------------------------------------
                                                   else '0'; 
                                                
   bitSlipRun_to_bitSlipControl                 <= RX_SLIDE_INT_RUN_I            when     RX_SLIDE_INT_EN_I   = '1' 
                                                                                      and RX_SLIDE_INT_CTRL_I = '1'
                                                   ----------------------------------------------------------------
                                                   else RX_SLIDE_GBTRX_ALIGNED_I when     RX_SLIDE_INT_EN_I   = '1'
                                                                                      and RX_SLIDE_INT_CTRL_I = '0'
                                                   ----------------------------------------------------------------
                                                   else '0';
                     
   bitSlipNbr_to_bitSlipControl                 <= RX_SLIDE_INT_NBR_I            when     RX_SLIDE_INT_EN_I   = '1'
                                                                                      and RX_SLIDE_INT_CTRL_I = '1'
                                                   ----------------------------------------------------------------                                  
                                                   else RX_SLIDE_GBTRX_NBR_I     when     RX_SLIDE_INT_EN_I   = '1'
                                                                                      and RX_SLIDE_INT_CTRL_I = '0'
                                                   ----------------------------------------------------------------                                  
                                                   else "00000";   

   --=================--
   -- GTX transceiver --
   --=================--   
   
   gtx: entity work.xlx_v6_latopt_gtx     
      port map (        
         -- Loopback:       
         LOOPBACK_IN                            => LOOPBACK_I,
         -- Comma Detection and Alignment:
         RXSLIDE_IN                             => bitSlip_to_gtx,
         -- PRBS Detection:         
         PRBSCNTRESET_IN                        => PRBSCNTRESET_I,
         RXENPRBSTST_IN                         => RX_ENPRBSTST_I,
         RXPRBSERR_OUT                          => RX_PRBSERR_O,
         -- RX Data Path interface        
         RXDATA_OUT                             => RX_DATA_O,
         RXRECCLK_OUT                           => RXRECCLK_O,
         RXUSRCLK2_IN                           => RXUSRCLK2_I,
         -- RX Driver,OOB signalling,Coupling and Eq.,CDR:
         RXEQMIX_IN                             => RX_EQMIX_I,
         RXN_IN                                 => RX_N_I,
         RXP_IN                                 => RX_P_I,
         -- RX Elastic Buffer and Phase Alignment Ports:
         RXDLYALIGNDISABLE_IN                   => gtx_rx_dlyAlignDisable,          
         RXDLYALIGNMONENB_IN                    => '0',                              
         RXDLYALIGNMONITOR_OUT                  => open,                             
         RXDLYALIGNOVERRIDE_IN                  => gtx_rx_dlyAlignOverride,      
         RXDLYALIGNRESET_IN                     => gtx_rx_dlyAlignReset,            
         RXENPMAPHASEALIGN_IN                   => gtx_rx_EnPmaPhaseAlign,    
         RXPMASETPHASE_IN                       => gtx_rx_PmaSetPhase,
         -- RX PLL Ports:        
         GTXRXRESET_IN                          => RX_RESET_I,
         MGTREFCLKRX_IN                         => ('0' & GTX_RX_REFCLK_I),
         PLLRXRESET_IN                          => RX_PLL_RESET_I,
         RXPLLLKDET_OUT                         => RX_PLLLKDET_O,
         RXRESETDONE_OUT                        => rxResetDone_from_gtx,
         -- RX Polarity Control Ports:       
         RXPOLARITY_IN                          => RX_POLARITY_I,
         -- Dynamic Reconfiguration Port (DRP):
         DADDR_IN                               => DADDR_I,
         DCLK_IN                                => DCLK_I,
         DEN_IN                                 => DEN_I,
         DI_IN                                  => DI_I,
         DRDY_OUT                               => DRDY_O,
         DRPDO_OUT                              => DRPDO_O,
         DWE_IN                                 => DWE_I,
         -- TX Data Path interface:       
         TXDATA_IN                              => TX_DATA_I,
         TXOUTCLK_OUT                           => TXOUTCLK_O,
         TXUSRCLK2_IN                           => TXUSRCLK2_I,
         -- TX Driver and OOB signalling:
         TXDIFFCTRL_IN                          => TX_DIFFCTRL_I,
         TXN_OUT                                => TX_N_O,
         TXP_OUT                                => TX_P_O,
         TXPOSTEMPHASIS_IN                      => TX_POSTEMPHASIS_I,
         -- TX Driver and OOB signalling:
         TXPREEMPHASIS_IN                       => TX_PREEMPHASIS_I,
         -- TX Elastic Buffer and Phase Alignment Ports:
         TXDLYALIGNDISABLE_IN                   => gtx_tx_dlyAlignDisable,          
         TXDLYALIGNMONENB_IN                    => '0',                                
         TXDLYALIGNMONITOR_OUT                  => open,                                
         TXDLYALIGNRESET_IN                     => gtx_tx_dlyAlignReset,            
         TXENPMAPHASEALIGN_IN                   => gtx_tx_EnPmaPhaseAlign,          
         TXPMASETPHASE_IN                       => gtx_tx_PmaSetPhase,
         -- TX PLL Ports:        
         GTXTXRESET_IN                          => TX_RESET_I,
         MGTREFCLKTX_IN                         => ('0' & GTX_TX_REFCLK_I),
         PLLTXRESET_IN                          => TX_PLL_RESET_I,
         TXPLLLKDET_OUT                         => TX_PLLLKDET_O,
         TXRESETDONE_OUT                        => txResetDone_from_gtx,
         -- TX PRBS Generator:         
         TXENPRBSTST_IN                         => TX_ENPRBSTST_I,           
         TXPRBSFORCEERR_IN                      => TX_PRBSFORCEERR_I,
         -- TX Polarity Control:       
         TXPOLARITY_IN                          => TX_POLARITY_I     
      );       
               
   TX_RESETDONE_O                               <= txResetDone_from_gtx;
   RX_RESETDONE_O                               <= rxResetDone_from_gtx;      
      
   --=====================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--