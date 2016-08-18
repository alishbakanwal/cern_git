--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - Multi Gigabit Transceivers standard
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                         
-- Tool version:          ISE 14.5                                                               
--                                                                                                   
-- Revision:              3.5                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/11/2013   3.0       M. Barros Marin   First .vhd module definition   
--
--                        04/11/2013   3.2       M. Barros Marin   Fixed reset issue
--
--                        11/09/2014   3.5       M. Barros Marin   Removed "eyeScanDataError" 
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

entity mgt_std is
   generic (
       GBT_BANK_ID                                 : integer := 1;
       NUM_LINKS                                   : integer := 1;
       TX_OPTIMIZATION                             : integer range 0 to 1 := STANDARD;
       RX_OPTIMIZATION                             : integer range 0 to 1 := STANDARD;
       TX_ENCODING                                 : integer range 0 to 1 := GBT_FRAME;
       RX_ENCODING                                 : integer range 0 to 1 := GBT_FRAME
   ); 
   port (      

      --===============--  
      -- Clocks scheme --  
      --===============--  

      MGT_CLKS_I                                  : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                  : out gbtBankMgtClks_o_R;   
           
      --========--
      -- Clocks --
      --========--
      TX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O                                        : out std_logic_vector      (1 to NUM_LINKS);     

      --=========--  
      -- MGT I/O --  
      --=========--  

      MGT_I                                       : in  mgt_i_R;
      MGT_O                                       : out mgt_o_R;

      --=============-- 
      -- GBT Control -- 
      --=============-- 

      GBTTX_MGTTX_RDY_O                           : out std_logic_vector(1 to NUM_LINKS);
      
      GBTRX_MGTRX_RDY_O                           : out std_logic_vector(1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                     : out std_logic_vector(1 to NUM_LINKS);
      
      --=======-- 
      -- Words -- 
      --=======-- 
 
      GBTTX_WORD_I                                : in  word_mxnbit_A   (1 to NUM_LINKS);     
      GBTRX_WORD_O                                : out word_mxnbit_A   (1 to NUM_LINKS) 
   
   );
end mgt_std;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_std is

    signal rx_wordclk_sig                         : std_logic_vector(1 to NUM_LINKS);
    signal tx_wordclk_sig                         : std_logic_vector(1 to NUM_LINKS);
    
    signal rxoutclk_sig                           : std_logic_vector(1 to NUM_LINKS);
    signal txoutclk_sig                           : std_logic_vector(1 to NUM_LINKS);
    
    signal rx_reset_done                          : std_logic_vector(1 to NUM_LINKS);
    signal tx_reset_done                          : std_logic_vector(1 to NUM_LINKS);
        
    signal rxfsm_reset_done                       : std_logic_vector(1 to NUM_LINKS);
    signal txfsm_reset_done                       : std_logic_vector(1 to NUM_LINKS);
    
    signal txuserclkRdy                           : std_logic_vector(1 to NUM_LINKS);
    signal rxuserclkRdy                           : std_logic_vector(1 to NUM_LINKS);
    
    signal gtwiz_buffbypass_tx_reset_in_s         : std_logic_vector(1 to NUM_LINKS);
    signal gtwiz_buffbypass_rx_reset_in_s         : std_logic_vector(1 to NUM_LINKS);
    
    signal rxpmaresetdone                         : std_logic_vector(1 to NUM_LINKS);
    signal txpmaresetdone                         : std_logic_vector(1 to NUM_LINKS);
    
    COMPONENT xlx_ku_mgt_ip
      PORT (
        gtwiz_userclk_tx_active_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_userclk_rx_active_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        
        rxusrclk_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        rxusrclk2_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        rxoutclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        txusrclk_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        txusrclk2_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        txoutclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        
        cplllock_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            
        gtwiz_buffbypass_tx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_tx_start_user_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_tx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_tx_error_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_rx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_rx_start_user_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_rx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_buffbypass_rx_error_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_clk_freerun_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_all_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_tx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_tx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_rx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_rx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_rx_cdr_stable_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_tx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_reset_rx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtwiz_userdata_tx_in : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
        gtwiz_userdata_rx_out : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
        --cplllockdetclk_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        --cpllreset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        drpaddr_in : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        drpclk_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        drpdi_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        drpen_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        drpwe_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gthrxn_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gthrxp_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        gtrefclk0_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        --gtrefclk1_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        loopback_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rxpolarity_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        rxslide_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        txdiffctrl_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        txpolarity_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        txpostcursor_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        txprecursor_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        --cpllfbclklost_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        drpdo_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        drprdy_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gthtxn_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        gthtxp_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        rxpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        txpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   gtxStd_gen: for i in 1 to NUM_LINKS generate
          
       RX_WORDCLK_O(i)                  <= rx_wordclk_sig(i);
       TX_WORDCLK_O(i)                  <= tx_wordclk_sig(i);
       
       MGT_CLKS_O.tx_wordClk(i)         <= tx_wordclk_sig(i);     
       MGT_CLKS_O.rx_wordClk(i)         <= rx_wordclk_sig(i);
       
       GBTRX_RXWORDCLK_READY_O(i)       <= rx_reset_done(i);
       GBTRX_MGTRX_RDY_O(i)             <= rx_reset_done(i) and rxfsm_reset_done(i);
       MGT_O.mgtLink(i).rx_resetDone    <= rx_reset_done(i);
       MGT_O.mgtLink(i).rx_fsmResetDone <= rxfsm_reset_done(i);
       MGT_O.mgtLink(i).rxWordClkReady  <= rx_reset_done(i); 
             
       GBTTX_MGTTX_RDY_O(i)             <= tx_reset_done(i) and txfsm_reset_done(i);
       MGT_O.mgtLink(i).tx_resetDone    <= tx_reset_done(i);
       MGT_O.mgtLink(i).tx_fsmResetDone <= txfsm_reset_done(i);
              
       MGT_O.mgtLink(i).ready           <= txfsm_reset_done(i) and rxfsm_reset_done(i) and rx_reset_done(i) and tx_reset_done(i);
             
       resetSynch_rx: entity work.xlx_ku_mgt_ip_reset_synchronizer
          PORT MAP(
            clk_in                                   => rx_wordClk_sig(i),
            rst_in                                   => not(rxpmaresetdone(i)),
            rst_out                                  => gtwiz_buffbypass_rx_reset_in_s(i)
          );
          
       resetSynch_tx: entity work.xlx_ku_mgt_ip_reset_synchronizer
          PORT MAP(
            clk_in                                   => tx_wordclk_sig(i),
            rst_in                                   => not(txpmaresetdone(i)),
            rst_out                                  => gtwiz_buffbypass_tx_reset_in_s(i)
          );
          
       -- COMMENT RX SLIDE MODE !!!!!!!!!!!!!!
       xlx_ku_mgt_std_i: xlx_ku_mgt_ip
          PORT MAP (
          
             gtwiz_userclk_tx_active_in(0)            => txpmaresetdone(i),
             gtwiz_userclk_rx_active_in(0)            => rxpmaresetdone(i),
             
             rxusrclk_in(0)                           => rx_wordclk_sig(i),
             rxusrclk2_in(0)                          => rx_wordclk_sig(i),
             rxoutclk_out(0)                          => rxoutclk_sig(i),
             
             txusrclk_in(0)                           => tx_wordclk_sig(i),
             txusrclk2_in(0)                          => tx_wordclk_sig(i),
             txoutclk_out(0)                          => txoutclk_sig(i),
                          
             gtwiz_buffbypass_tx_reset_in(0)          => gtwiz_buffbypass_tx_reset_in_s(i),
             gtwiz_buffbypass_tx_start_user_in(0)     => '0',
             gtwiz_buffbypass_tx_done_out(0)          => txfsm_reset_done(i),
             gtwiz_buffbypass_tx_error_out(0)         => open,
             gtwiz_buffbypass_rx_reset_in(0)          => gtwiz_buffbypass_rx_reset_in_s(i),
             gtwiz_buffbypass_rx_start_user_in(0)     => '0',
             gtwiz_buffbypass_rx_done_out(0)          => rxfsm_reset_done(i),
             gtwiz_buffbypass_rx_error_out(0)         => open,
             
             gtwiz_reset_clk_freerun_in(0)            => MGT_CLKS_I.mgtRstCtrlRefClk,
                                    
             gtwiz_reset_all_in(0)                    => '0',
             
             gtwiz_reset_tx_pll_and_datapath_in(0)    => '0',
             gtwiz_reset_tx_datapath_in(0)            => MGT_I.mgtLink(i).tx_reset,
             
             gtwiz_reset_rx_pll_and_datapath_in(0)    => '0',
             gtwiz_reset_rx_datapath_in(0)            => MGT_I.mgtLink(i).rx_reset,
             gtwiz_reset_rx_cdr_stable_out(0)         => open,
             
             gtwiz_reset_tx_done_out(0)               => tx_reset_done(i),
             gtwiz_reset_rx_done_out(0)               => rx_reset_done(i),
             
             gtwiz_userdata_tx_in                     => GBTTX_WORD_I(i),
             gtwiz_userdata_rx_out                    => GBTRX_WORD_O(i),
             
             drpaddr_in                               => MGT_I.mgtLink(i).drp_addr,
             drpclk_in(0)                             => MGT_CLKS_I.drpClk,
             drpdi_in                                 => MGT_I.mgtLink(i).drp_di,
             drpen_in(0)                              => MGT_I.mgtLink(i).drp_en,
             drpwe_in(0)                              => MGT_I.mgtLink(i).drp_we,
             drpdo_out                                => MGT_O.mgtLink(i).drp_do,
             drprdy_out(0)                            => MGT_O.mgtLink(i).drp_rdy,
                            
             gthrxn_in(0)                             => MGT_I.mgtLink(i).rx_n,
             gthrxp_in(0)                             => MGT_I.mgtLink(i).rx_p,
             gthtxn_out(0)                            => MGT_O.mgtLink(i).tx_n,
             gthtxp_out(0)                            => MGT_O.mgtLink(i).tx_p,
             
             gtrefclk0_in(0)                          => MGT_CLKS_I.mgtRefClk,
             --gtrefclk1_in(0)                          => '0',
             
             loopback_in                              => MGT_I.mgtLink(i).loopBack,
             rxpolarity_in(0)                         => MGT_I.mgtLink(i).conf_rxPol,
             txpolarity_in(0)                         => MGT_I.mgtLink(i).conf_txPol,
             
             rxslide_in(0)                            => '0',
                          
             txdiffctrl_in                            => MGT_I.mgtLink(i).conf_diffCtrl,
             txpostcursor_in                          => MGT_I.mgtLink(i).conf_postCursor,
             txprecursor_in                           => MGT_I.mgtLink(i).conf_preCursor,
             --cplllockdetclk_in(0)                     => MGT_CLKS_I.cpllLockDetClk,
             --cpllreset_in(0)                          => '0',
             rxpmaresetdone_out(0)                    => rxpmaresetdone(i),               
             txpmaresetdone_out(0)                    => txpmaresetdone(i)
          );
           
          rxWordClkBuf_inst: bufg_gt
            port map (
               O                                        => rx_wordclk_sig(i), 
               I                                        => rxoutclk_sig(i),
               CE                                       => '1',
               DIV                                      => "000",
               CLR                                      => '0',
               CLRMASK                                  => '0',
               CEMASK                                   => '0'
            ); 
                          
          txWordClkBuf_inst: bufg_gt
            port map (
               O                                        => tx_wordclk_sig(i), 
               I                                        => txoutclk_sig(i),
               CE                                       => '1',
               DIV                                      => "000",
               CLR                                      => '0',
               CLRMASK                                  => '0',
               CEMASK                                   => '0'
            ); 
            
   end generate;
   
   --=====================================================================================--
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--