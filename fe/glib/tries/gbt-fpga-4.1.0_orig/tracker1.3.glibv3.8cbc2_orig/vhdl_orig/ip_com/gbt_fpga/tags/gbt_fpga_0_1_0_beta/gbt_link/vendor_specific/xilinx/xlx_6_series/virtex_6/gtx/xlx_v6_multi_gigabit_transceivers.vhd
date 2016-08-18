--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Virtex 6 - Multi Gigabit Transceivers (GTX quad)                                       
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
--                        20/06/2013   1.0       M. Barros Marin     - First .vhd module definition           
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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;
use work.gbt_link_package.all;
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity multi_gigabit_transceivers is  
   port (
   
      --===============--
      -- Clocks scheme --
      --===============--
   
      -- Reference clocks:      
      --------------------
      
      MGT_REFCLKS_I                             : in gbtLinkMgtRefClks_R;   
         
      -- Fabric clocks: 
      -----------------       
         
      MGT_WORDCLKS_O                            : out gbtLinkClks_o_R;        
        
      --=========--
      -- MGT I/O --
      --=========--
      
      MGT_I                                     : in  mgt_i_R_A           (1 to NUM_GBT_LINK);
      MGT_O                                     : out mgt_o_R_A           (1 to NUM_GBT_LINK);
      
      --==================--
      -- Control & status --
      --==================--   
     
      -- Control:
      -----------
      
      GBT_RX_HEADER_LOCKED_I                    : in  std_logic_vector    (1 to NUM_GBT_LINK);
      GBT_RX_BITSLIP_NBR_I                      : in  gbtRxSlideNbr_nbit_A(1 to NUM_GBT_LINK);
     
      -- Status:
      ----------      
      
      GBT_RX_MGT_RDY_O                          : out std_logic_vector    (1 to NUM_GBT_LINK);
     
      -- Words:
      ---------
      
      GBT_TX_WORD_I                             : in  word_nbit_A         (1 to NUM_GBT_LINK);     
      GBT_RX_WORD_O                             : out word_nbit_A         (1 to NUM_GBT_LINK)     

   );
end multi_gigabit_transceivers;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of multi_gigabit_transceivers is    
   
   --================================ Signal Declarations ================================--
   
   --================--
   --  Clocks scheme --
   --================--  
   
   signal gtxTxOutClk_array_from_gtx              : std_logic_vector      (1 to NUM_GBT_LINK);
   signal userBufTxOutClk_array_from_gtxFabClkSch : std_logic_vector      (1 to NUM_GBT_LINK);           
   signal gtxTxUsrClk2_array_from_gtxFabClkSch    : std_logic_vector      (1 to NUM_GBT_LINK);
   signal userBufTxUsrClk2_array_to_gtxFabClkSch  : std_logic_vector      (1 to NUM_GBT_LINK);   
   signal gtxRxRecClk_array_from_gtx              : std_logic_vector      (1 to NUM_GBT_LINK);   
   signal userBufRxRecClk_array_from_gtxFabClkSch : std_logic_vector      (1 to NUM_GBT_LINK);   
   signal gtxRxUsrClk2_array_from_gtxFabClkSch    : std_logic_vector      (1 to NUM_GBT_LINK);   
   signal userBufRxUsrClk2_array_to_gtxFabClkSch  : std_logic_vector      (1 to NUM_GBT_LINK);
   
   --=================--
   -- GTX transceiver --
   --=================--
   
   signal rxData_from_gtx                         : word_nbit_A           (1 to NUM_GBT_LINK); 
   signal tx_resetDone_from_stdGtx                : std_logic_vector      (1 to NUM_GBT_LINK); 
   signal rx_resetDone_from_stdGtx                : std_logic_vector      (1 to NUM_GBT_LINK);    
   signal syncDone_from_latOptGtx                 : std_logic_vector      (1 to NUM_GBT_LINK); 
 
   --=====================================================================================--      

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--
    
   --===============--
   -- Clocks scheme --
   --===============--      
   
   -- Comment: * Default setup: BUFG
   --   
   --          * When using BUFG, TXOUTCLK from GTX1 is used to generate TXUSRCLK2 for all GTXs of the quad.
   --
   --          * When bypassing the buffers, TXOUTCLK/TXUSRCLK2 and RXRECCLK/RXUSRCLK2 of all GTX are forwarded out from the 
   --            GBT Link so the user can connect the buffers as desired.
   
   gtxFabClkSch: entity work.xlx_v6_gtx_fabric_clk_scheme      
      port map (  
         -- GTX TX:  
         GTX_TXOUTCLK_I                         => gtxTxOutClk_array_from_gtx,      
         USER_TXOUTCLK_O                        => userBufTxOutClk_array_from_gtxFabClkSch,
         ---------------------------------------
         GTX_TXUSRCLK2_O                        => gtxTxUsrClk2_array_from_gtxFabClkSch,
         USER_TXUSRCLK2_I                       => userBufTxUsrClk2_array_to_gtxFabClkSch,          
         -- GTX RX:              
         GTX_RXRECCLK_I                         => gtxRxRecClk_array_from_gtx,
         USER_RXRECCLK_O                        => userBufRxRecClk_array_from_gtxFabClkSch,  
         ---------------------------------------
         GTX_RXUSRCLK2_O                        => gtxRxUsrClk2_array_from_gtxFabClkSch,
         USER_RXUSRCLK2_I                       => userBufRxUsrClk2_array_to_gtxFabClkSch 
      ); 
      
   usrBufclks_gen: for i in 1 to NUM_GBT_LINK generate
   
      MGT_O(i).usrBuf_txOutClk                  <= userBufTxOutClk_array_from_gtxFabClkSch(i);
      MGT_O(i).usrBuf_rxRecClk                  <= userBufRxRecClk_array_from_gtxFabClkSch(i);
      ------------------------------------------   
      userBufTxUsrClk2_array_to_gtxFabClkSch(i) <= MGT_I(i).usrBuf_txUsrClk2;              
      userBufRxUsrClk2_array_to_gtxFabClkSch(i) <= MGT_I(i).usrBuf_rxUsrClk2;
         
   end generate;      
      
   MGT_WORDCLKS_O.tx_wordClk                    <= gtxTxUsrClk2_array_from_gtxFabClkSch;
   MGT_WORDCLKS_O.rx_wordClk                    <= gtxRxUsrClk2_array_from_gtxFabClkSch;     
   
   --=================--
   -- GTX transceiver --
   --=================--
   
   -- Standard optimization:
   -------------------------
   
   gtx_gen: for i in 1 to NUM_GBT_LINK generate
   
      stdGtx_gen: if OPTIMIZATION /= "LATENCY" generate  
      
         gtx: entity work.xlx_v6_standard_gtx
            port map (  
               -- Loopback and Powerdown:                                                             
               LOOPBACK_IN                      => MGT_I(i).loopBack,
               -- PRBS Detection:                                                               
               PRBSCNTRESET_IN                  => MGT_I(i).prbs_errCntRst,                              
               RXENPRBSTST_IN                   => MGT_I(i).prbs_rxEn,                              
               RXPRBSERR_OUT                    => MGT_O(i).prbs_rxErr,                                
               -- RX Data Path interface                                                        
               RXDATA_OUT                       => rxData_from_gtx(i),                                   
               RXRECCLK_OUT                     => gtxRxRecClk_array_from_gtx(i),                                  
               RXUSRCLK2_IN                     => gtxRxUsrClk2_array_from_gtxFabClkSch(i),                                 
               -- RX Driver,OOB signalling,Coupling and Eq.,CDR:                                      
               RXEQMIX_IN                       => MGT_I(i).conf_eqMix,                                  
               RXN_IN                           => MGT_I(i).rx_n,                                      
               RXP_IN                           => MGT_I(i).rx_p,                                      
               -- RX PLL Ports:                                                                
               GTXRXRESET_IN                    => MGT_I(i).rx_reset,                                  
               MGTREFCLKRX_IN                   => ('0' & MGT_REFCLKS_I.rx),                     
               PLLRXRESET_IN                    => '0',                              
               RXPLLLKDET_OUT                   => MGT_O(i).rx_pllLkDet,                               
               RXRESETDONE_OUT                  => rx_resetDone_from_stdGtx(i),                              
               -- RX Polarity Control Ports:                                                   
               RXPOLARITY_IN                    => MGT_I(i).conf_rxPol,                               
               -- Dynamic Reconfiguration Port (DRP):                                                 
               DADDR_IN                         => MGT_I(i).drp_dAddr,                                     
               DCLK_IN                          => MGT_I(i).drp_dClk,                                    
               DEN_IN                           => MGT_I(i).drp_dEn,                                       
               DI_IN                            => MGT_I(i).drp_dI,                                        
               DRDY_OUT                         => MGT_O(i).drp_dRdy,                                      
               DRPDO_OUT                        => MGT_O(i).drp_dRpDo,                                     
               DWE_IN                           => MGT_I(i).drp_dWe,                                       
               -- TX Data Path interface:                                                       
               TXDATA_IN                        => GBT_TX_WORD_I(i),                                  
               TXOUTCLK_OUT                     => gtxTxOutClk_array_from_gtx(i),                                 
               TXUSRCLK2_IN                     => gtxTxUsrClk2_array_from_gtxFabClkSch(i),                                 
               -- TX Driver and OOB signalling:                                                 
               TXDIFFCTRL_IN                    => MGT_I(i).conf_diff,                               
               TXN_OUT                          => MGT_O(i).tx_n,                                      
               TXP_OUT                          => MGT_O(i).tx_P,                                      
               TXPOSTEMPHASIS_IN                => MGT_I(i).conf_pstEmph,                           
               -- TX Driver and OOB signalling:                                                 
               TXPREEMPHASIS_IN                 => MGT_I(i).conf_preEmph,                            
               -- TX PLL Ports:                                                                 
               GTXTXRESET_IN                    => MGT_I(i).tx_reset,                                  
               MGTREFCLKTX_IN                   => ('0' & MGT_REFCLKS_I.tx),                     
               PLLTXRESET_IN                    => '0',                              
               TXPLLLKDET_OUT                   => MGT_O(i).tx_pllLkDet,                               
               TXRESETDONE_OUT                  => tx_resetDone_from_stdGtx(i),                              
               -- TX PRBS Generator:                                                            
               TXENPRBSTST_IN                   => MGT_I(i).prbs_txEn,                              
               TXPRBSFORCEERR_IN                => MGT_I(i).prbs_forcErr,                           
               -- TX Polarity Control:                                                          
               TXPOLARITY_IN                    => MGT_I(i).conf_txPol     
            ); 
         
         -- Comment: Note!! The standard version of the GTX does not align the phase of the  
         --                  RXRECCLKO (RXWORDCLK) with respect to the TXOURCLK (TXWORDCLK).
         
         MGT_O(i).latOptGbtLink                 <= '0';
         MGT_O(i).rx_wordClk_aligned            <= '0';  
         MGT_O(i).tx_resetDone                  <= tx_resetDone_from_stdGtx(i);
         MGT_O(i).rx_resetDone                  <= rx_resetDone_from_stdGtx(i);
         MGT_O(i).ready                         <= tx_resetDone_from_stdGtx(i) and rx_resetDone_from_stdGtx(i);
         MGT_O(i).word                          <= rxData_from_gtx(i);         
         GBT_RX_MGT_RDY_O(i)                    <= tx_resetDone_from_stdGtx(i) and rx_resetDone_from_stdGtx(i);         
         GBT_RX_WORD_O(i)                       <= rxData_from_gtx(i);
        
      end generate;   
      
      -- Latency optimization:
      ------------------------
      
      latOptGtx_gen: if OPTIMIZATION = "LATENCY" generate     
         
         gtx: entity work.xlx_v6_latopt_gtx_wrapper            
            port map (              
               -- Clocks scheme:       
               GTX_TX_REFCLK_I                  => MGT_REFCLKS_I.tx,                                         
               GTX_RX_REFCLK_I                  => MGT_REFCLKS_I.rx,   
               ---------------------------------                          
               TXOUTCLK_O                       => gtxTxOutClk_array_from_gtx(i),                              
               RXRECCLK_O                       => gtxRxRecClk_array_from_gtx(i),                              
               TXUSRCLK2_I                      => gtxTxUsrClk2_array_from_gtxFabClkSch(i),                           
               RXUSRCLK2_I                      => gtxRxUsrClk2_array_from_gtxFabClkSch(i),   
               ---------------------------------           
               TX_PLLLKDET_O                    => MGT_O(i).tx_pllLkDet,                           
               RX_PLLLKDET_O                    => MGT_O(i).rx_pllLkDet,   
               -- Resets scheme:                   
               TX_RESET_I                       => MGT_I(i).tx_reset,                              
               RX_RESET_I                       => MGT_I(i).rx_reset,                              
               TX_PLL_RESET_I                   => '0',
               RX_PLL_RESET_I                   => '0',
               TX_SYNC_RESET_I                  => MGT_I(i).tx_syncReset,                       
               RX_SYNC_RESET_I                  => MGT_I(i).rx_syncReset,   
               ---------------------------------                                
               TX_RESETDONE_O                   => MGT_O(i).tx_resetDone,                        
               RX_RESETDONE_O                   => MGT_O(i).rx_resetDone,
               -- TX driver & RX receiver configuration:   
               TX_DIFFCTRL_I                    => MGT_I(i).conf_diff,                           
               TX_POSTEMPHASIS_I                => MGT_I(i).conf_pstEmph,                     
               TX_PREEMPHASIS_I                 => MGT_I(i).conf_preEmph,                        
               ---------------------------------        
               TX_POLARITY_I                    => MGT_I(i).conf_txPol,   
               RX_POLARITY_I                    => MGT_I(i).conf_rxPol,                           
               ---------------------------------         
               RX_EQMIX_I                       => MGT_I(i).conf_eqMix,                                
               -- Dynamic Reconfiguration Port (DRP):       
               DCLK_I                           => MGT_I(i).drp_dClk,                                
               DADDR_I                          => MGT_I(i).drp_dAddr,
               DEN_I                            => MGT_I(i).drp_dEn,                                 
               DI_I                             => MGT_I(i).drp_dI,                                  
               DRDY_O                           => MGT_O(i).drp_dRdy,                                
               DRPDO_O                          => MGT_O(i).drp_dRpDo,                               
               DWE_I                            => MGT_I(i).drp_dWe,   
               -- Loopback:                                   
               LOOPBACK_I                       => MGT_I(i).loopBack,
               -- Pseudo Random Bit Sequence (PRBS):      
               TX_ENPRBSTST_I                   => MGT_I(i).prbs_txEn,                        
               RX_ENPRBSTST_I                   => MGT_I(i).prbs_rxEn,                        
               TX_PRBSFORCEERR_I                => MGT_I(i).prbs_forcErr,                     
               RX_PRBSERR_O                     => MGT_O(i).prbs_rxErr,                          
               PRBSCNTRESET_I                   => MGT_I(i).prbs_errCntRst,                   
               -- GTX synchronization:                                    
               GTX_SYNC_DONE_O                  => syncDone_from_latOptGtx(i),               
               -- RX phase alignment:                         
               RX_SLIDE_INT_EN_I                => MGT_I(i).rx_slide_enable,                     
               RX_SLIDE_INT_CTRL_I              => MGT_I(i).rx_slide_ctrl,                    
               RX_SLIDE_INT_NBR_I               => MGT_I(i).rx_slide_nbr,                    
               RX_SLIDE_INT_RUN_I               => MGT_I(i).rx_slide_run,                    
               ---------------------------------   
               RX_SLIDE_GBTRX_ALIGNED_I         => GBT_RX_HEADER_LOCKED_I(i),
               RX_SLIDE_GBTRX_NBR_I             => GBT_RX_BITSLIP_NBR_I(i),                       
               ---------------------------------   
               RXWORDCLK_ALIGNED_O              => MGT_O(i).rx_wordClk_aligned,
               -- Data:                          
               TX_DATA_I                        => GBT_TX_WORD_I(i),                              
               RX_DATA_O                        => rxData_from_gtx(i),   
               ---------------------------------                        
               TX_P_O                           => MGT_O(i).tx_p,                                 
               TX_N_O                           => MGT_O(i).tx_n,                                 
               RX_P_I                           => MGT_I(i).rx_p,                                 
               RX_N_I                           => MGT_I(i).rx_n               
            );          
            
         MGT_O(i).latOptGbtLink                 <= '1';
         MGT_O(i).ready                         <= syncDone_from_latOptGtx(i);              
         MGT_O(i).word                          <= rxData_from_gtx(i); 
         GBT_RX_MGT_RDY_O(i)                    <= syncDone_from_latOptGtx(i);
         GBT_RX_WORD_O(i)                       <= rxData_from_gtx(i);
         
      end generate;
      
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--