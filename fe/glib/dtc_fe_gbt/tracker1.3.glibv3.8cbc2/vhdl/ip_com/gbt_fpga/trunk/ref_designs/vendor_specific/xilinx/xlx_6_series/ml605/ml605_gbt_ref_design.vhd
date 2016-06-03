--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           ML605 - GBT Link reference design                                         
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         ML605 (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/10/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
-- Additional Comments:   Note!! Only ONE GBT Link (SFP) can be used in this reference design.      
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
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity ml605_gbt_ref_design is   
   port (   
      
      --===============--
      -- Clocks scheme --
      --===============-- 
      
      -- Fabric clock:
      ----------------
      
      SGMIICLK_QO_P                             : in  std_logic;
      SGMIICLK_QO_N                             : in  std_logic;   
      
      -- MGT(GTX) reference clock:
      ----------------------------
      
      -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
      --
      --          * The MGT reference clock frequency must be 240MHz for the latency-optimized GBT Link.      
      
      SMA_REFCLK_P                              : in  std_logic;
      SMA_REFCLK_N                              : in  std_logic;          
      
      --===============--
      -- General reset --
      --===============-- 
      
      CPU_RESET                                 : in  std_logic;      
      
      --==========--
      -- MGT(GTX) --
      --==========--                   
      
      SFP_TX_P                                  : out std_logic;
      SFP_TX_N                                  : out std_logic;
      SFP_RX_P                                  : in  std_logic;
      SFP_RX_N                                  : in  std_logic;                  
      
      --===============--      
      -- On-board LEDs --      
      --===============--

      GPIO_LED_0                                : out std_logic;
      GPIO_LED_1                                : out std_logic;
      GPIO_LED_2                                : out std_logic;
      GPIO_LED_3                                : out std_logic;
      GPIO_LED_4                                : out std_logic;
      GPIO_LED_5                                : out std_logic;
      GPIO_LED_6                                : out std_logic;
      GPIO_LED_7                                : out std_logic;      
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: USER_SMA_GPIO_P is connected to a multiplexor that switches between SMA_REFCLK and TX_FRAMECLK.
      
      USER_SMA_GPIO_P                           : out std_logic;        
      
      -- Pattern match flags:
      -----------------------
      
      -- Comment: FMC_HPC_LA00_P and FMC_HPC_LA01_P are used for pattern marching flags respectively.     
      
      FMC_HPC_LA00_CC_P                         : out std_logic;       
      FMC_HPC_LA01_CC_P                         : out std_logic;
      
      -- Clock forwarding:
      --------------------  
      
      -- Comment: * FMC_HPC_LA02_P and FMC_HPC_LA03_P are used for forwarding the tx and rx frame clocks respectively.
      --      
      --          * FMC_HPC_LA04_P and FMC_HPC_LA05_P are used for forwarding the tx and rx word clocks respectively.
      
      FMC_HPC_LA02_P                            : out std_logic; 
      FMC_HPC_LA03_P                            : out std_logic; 
      FMC_HPC_LA04_P                            : out std_logic; 
      FMC_HPC_LA05_P                            : out std_logic 
            
   );
end ml605_gbt_ref_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of ml605_gbt_ref_design is   
   
   --==================================== Attributes =====================================--
   
   -- Comment: The "keep" constant is used to avoid that ISE changes the name of 
   --          the signals to be analysed with Chipscope.
   
   attribute keep                               : string;   
  
   --=====================================================================================--       
   
   --================================ Signal Declarations ================================--          

   --==============--
   -- Clock scheme -- 
   --==============--   
   
   -- Fabric clock:
   ----------------
   
   signal sgmiiclkQo_bufg                       : std_logic;
   signal sgmiiclkQo                            : std_logic;   
   
   -- MGT(GTX) reference clock:
   ----------------------------
      
   signal sma_refclk                            : std_logic;
   
   -- TX_WORDCLK BUFG:
   -------------------   
   
   signal txOutClk_from_gbtRefDesign            : std_logic;
   signal txWordClk_from_txWordClkBufg          : std_logic;
   
   -- TX_FRAMECLK PLL:
   ------------------- 
   
   signal locked_from_txPll                     : std_logic;
   signal txFrameClk_from_txPll                 : std_logic;
   
   --===============--
   -- General reset --
   --===============--
   
   signal reset_from_rst                        : std_logic;    

   --===========================--
   -- GBT Link reference design --
   --===========================--
   
   -- Control:
   -----------
   
   signal reset_from_user                       : std_logic;      
   signal clkMuxSel_from_user                   : std_logic;       
   signal testPatterSel_from_user               : std_logic_vector(1 downto 0); 
   signal loopback_from_user                    : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user      : std_logic; 
   signal resetRxGbtReadyLostFlag_from_user     : std_logic; 
   signal txIsDataSel_from_user                 : std_logic;   
   signal encodingSel_from_user                 : std_logic_vector(1 downto 0); 
   
   -- Status:                                   
   ----------                                   
   
   signal latencyOptGbtLink_from_gbtRefDesign   : std_logic;
   signal rxHeaderLocked_from_gbtRefDesign      : std_logic;
   signal rxBitSlipNbr_from_gbtRefDesign        : std_logic_vector(GBTRX_SLIDE_NBR_MSB downto 0);
   signal rxWordClkAligned_from_gbtRefDesign    : std_logic; 
   signal mgtReady_from_gbtRefDesign            : std_logic; 
   signal gbtRxReady_from_gbtRefDesign          : std_logic;    
   signal rxFrameClkAligned_from_gbtRefDesign   : std_logic; 
   signal rxIsData_from_gbtRefDesign            : std_logic;        
   signal rxGbtReadyLostFlag_from_gbtRefDesign  : std_logic; 
   signal commDataErrSeen_from_gbtRefDesign     : std_logic; 
   signal widebusDataErrSeen_from_gbtRefDesign  : std_logic; 
   
   -- Data:
   --------
   
   signal txCommonData_from_gbtRefDesign        : std_logic_vector(83 downto 0);
   signal rxCommonData_from_gbtRefDesign        : std_logic_vector(83 downto 0);
   
   signal txWidebusExtraData_from_gbtRefDesign  : std_logic_vector(31 downto 0);
   signal rxWidebusExtraData_from_gbtRefDesign  : std_logic_vector(31 downto 0);
   
   --===========--
   -- Chipscope --
   --===========--
   
   signal vio_control                           : std_logic_vector(35 downto 0); 
   signal txIla_control                         : std_logic_vector(35 downto 0); 
   signal rxIla_control                         : std_logic_vector(35 downto 0); 
   signal sync_from_vio                         : std_logic_vector(11 downto 0);
   signal async_to_vio                          : std_logic_vector(14 downto 0);
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   signal txFrameClk_from_gbtRefDesign          : std_logic;
   signal rxFrameClk_from_gbtRefDesign          : std_logic;
   signal txWordClk_from_gbtRefDesign           : std_logic;
   signal rxWordClk_from_gbtRefDesign           : std_logic;
                                       
   signal txMatchFlag_from_gbtRefDesign         : std_logic;
   signal rxMatchFlag_from_gbtRefDesign         : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --==============--
   -- Clock scheme -- 
   --==============--   
   
   -- Fabric clock:
   ----------------
   
   -- Comment: SGMIICLK_QO frequency: 125MHz
   
   sgmiiclkQoGtxe1: ibufds_gtxe1
      port map (
         I                                      => SGMIICLK_QO_P,
         IB                                     => SGMIICLK_QO_N,
         O                                      => sgmiiclkQo,
         CEB                                    => '0'
      );        
   
   sgmiiclkQoBufg: BUFG
      port map (
         O                                      => sgmiiclkQo_bufg, 
         I                                      => sgmiiclkQo 
      );
   
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
   --
   --          * The MGT reference clock frequency must be 240MHz for the latency-optimized GBT Link. 
   
   sfpIbufdsGtxe1: ibufds_gtxe1
      port map (
         I                                      => SMA_REFCLK_P,
         IB                                     => SMA_REFCLK_N,
         O                                      => sma_refclk,
         CEB                                    => '0'
      );                
    
   -- TX_WORDCLK BUFG:
   -------------------
   
   txWordClkBufg: BUFG
      port map (
         O                                      => txWordClk_from_txWordClkBufg, 
         I                                      => txOutClk_from_gbtRefDesign 
      );   
   
   -- TX_FRAMECLK PLL:
   -------------------
   
   -- Comment: * The PLL (MMCM) does not have input buffer.
   --      
   --          * TX_FRAMECLK frequency: 40MHz
   
   txPll: entity work.tx_pll_mmcm
      port map (
         -- Clock in ports
         CLK_IN1                                => txWordClk_from_txWordClkBufg,
         -- Clock out ports               
         CLK_OUT1                               => txFrameClk_from_txPll,
         -- Status and control signals
         RESET                                  => '0',
         LOCKED                                 => locked_from_txPll
      );  
  
   --===============--
   -- General reset -- 
   --===============--
   
   rst: entity work.xlx_v6_reset
      generic map (
         CLK_FREQ                               => 125e6)
      port map (
         CLK_I                                  => sgmiiclkQo_bufg,
         RESET1_B_I                             => not CPU_RESET, 
         RESET2_B_I                             => not reset_from_user,
         RESET_O                                => reset_from_rst 
      );  
      
   --===========================--
   -- GBT Link reference design --
   --===========================--
   
   gbtRefDesign: entity work.xlx_v6_gbt_ref_design
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                        => reset_from_rst,                   
         -- Clocks scheme:                      
         FABRIC_CLK_I                           => sgmiiclkQo_bufg,
         MGT_REFCLKS_I                          => (tx => sma_refclk, rx => sma_refclk),              
         TX_OUTCLK_O                            => txOutClk_from_gbtRefDesign,
         TX_WORDCLK_I                           => txWordClk_from_txWordClkBufg,
         TX_FRAMECLK_I                          => txFrameClk_from_txPll,                       
         -- Serial lanes:                       
         MGT_TX_P                               => SFP_TX_P,                
         MGT_TX_N                               => SFP_TX_N,                
         MGT_RX_P                               => SFP_RX_P,                 
         MGT_RX_N                               => SFP_RX_N,
         -- GBT Link control:                   
         LOOPBACK_I                             => loopback_from_user,  
         TX_ENCODING_SEL_I                      => encodingSel_from_user,
         RX_ENCODING_SEL_I                      => encodingSel_from_user,
         TX_ISDATA_SEL_I                        => txIsDataSel_from_user,                 
         -- GBT Link status:                    
         LATENCY_OPT_GBTLINK_O                  => latencyOptGbtLink_from_gbtRefDesign,             
         MGT_READY_O                            => mgtReady_from_gbtRefDesign,             
         RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_gbtRefDesign,
         RX_BITSLIP_NUMBER_O                    => rxBitSlipNbr_from_gbtRefDesign,            
         RX_WORDCLK_ALIGNED_O                   => rxWordClkAligned_from_gbtRefDesign,           
         RX_FRAMECLK_ALIGNED_O                  => rxFrameClkAligned_from_gbtRefDesign,            
         RX_GBT_READY_O                         => gbtRxReady_from_gbtRefDesign,
         RX_ISDATA_FLAG_O                       => rxIsData_from_gbtRefDesign,            
         -- GBT Link data:                      
         TX_DATA_O                              => txCommonData_from_gbtRefDesign,            
         TX_WIDEBUS_EXTRA_DATA_O                => txWidebusExtraData_from_gbtRefDesign,
         ---------------------------------------
         RX_DATA_O                              => rxCommonData_from_gbtRefDesign,           
         RX_WIDEBUS_EXTRA_DATA_O                => rxWidebusExtraData_from_gbtRefDesign,
         -- Test control & status:              
         TEST_PATTERN_SEL_I                     => testPatterSel_from_user,        
         ---------------------------------------                    
         RESET_DATA_ERROR_SEEN_FLAG_I           => resetDataErrorSeenFlag_from_user,     
         RESET_RX_GBT_READY_LOST_FLAG_I         => resetRxGbtReadyLostFlag_from_user,     
         ---------------------------------------                    
         RX_GBT_READY_LOST_FLAG_O               => rxGbtReadyLostFlag_from_gbtRefDesign,       
         COMMONDATA_ERROR_SEEN_FLAG_O           => commDataErrSeen_from_gbtRefDesign,      
         WIDEBUSDATA_ERROR_SEEN_FLAG_O          => widebusDataErrSeen_from_gbtRefDesign,      
         -- Latency measurement:                
         TX_FRAMECLK_O                          => txFrameClk_from_gbtRefDesign,   -- Comment: This clock is "TX_FRAMECLK"          
         RX_FRAMECLK_O                          => rxFrameClk_from_gbtRefDesign,         
         TX_WORDCLK_O                           => txWordClk_from_gbtRefDesign,          
         RX_WORDCLK_O                           => rxWordClk_from_gbtRefDesign,          
         ---------------------------------------                
         TX_MATCHFLAG_O                         => txMatchFlag_from_gbtRefDesign,          
         RX_MATCHFLAG_O                         => rxMatchFlag_from_gbtRefDesign          
      );                                        
   
   --=======================--   
   -- Test control & status --   
   --=======================--
   
   -- Signals mapping:
   -------------------
   
   -- Control:
   reset_from_user                              <= sync_from_vio( 0);          
   clkMuxSel_from_user                          <= sync_from_vio( 1);
   testPatterSel_from_user                      <= sync_from_vio( 3 downto 2); 
   loopback_from_user                           <= sync_from_vio( 6 downto 4);
   resetDataErrorSeenFlag_from_user             <= sync_from_vio( 7);
   resetRxGbtReadyLostFlag_from_user            <= sync_from_vio( 8);
   txIsDataSel_from_user                        <= sync_from_vio( 9);
   encodingSel_from_user                        <= sync_from_vio(11 downto 10);
   
   -- Status:
   async_to_vio( 0)                             <= rxIsData_from_gbtRefDesign;
   async_to_vio( 1)                             <= locked_from_txPll;
   async_to_vio( 2)                             <= latencyOptGbtLink_from_gbtRefDesign;
   async_to_vio( 3)                             <= mgtReady_from_gbtRefDesign;
   async_to_vio( 4)                             <= rxWordClkAligned_from_gbtRefDesign;    
   async_to_vio( 9 downto 5)                    <= rxBitSlipNbr_from_gbtRefDesign;        
   async_to_vio(10)                             <= rxFrameClkAligned_from_gbtRefDesign;   
   async_to_vio(11)                             <= gbtRxReady_from_gbtRefDesign;          
   async_to_vio(12)                             <= commDataErrSeen_from_gbtRefDesign;   
   async_to_vio(13)                             <= rxGbtReadyLostFlag_from_gbtRefDesign;  
   async_to_vio(14)                             <= widebusDataErrSeen_from_gbtRefDesign;
   
   -- Chipscope:
   -------------   
   
   -- Comment: * Chipscope is used to control and check the status of the reference design as well 
   --            as for data analysis ("txCommonData_from_gbtRefDesign" and "rxCommonData_from_gbtRefDesign").
   --
   --          * Note!! The TX data and RX data do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving the RX data from another board with a different reference clock, the TX
   --            frame/word clock domains are asynchronous with respect to to the RX frame/word clock domains.        
   --
   --          * After FPGA configuration using Chipscope, open the project "ml605_gbt_ref_design.cpj" 
   --            that can be found in:
   --            "..\ref_designs\vendor_specific\xilinx\xlx_6_series\ml605\chipscope\".  
   
   icon: entity work.chipscope_icon
      port map (
         CONTROL0                               => vio_control,
         CONTROL1                               => txIla_control,
         CONTROL2                               => rxIla_control
      );     
         
   vio: entity work.chipscope_vio      
      port map (     
         CONTROL                                => vio_control,
         CLK                                    => txFrameClk_from_gbtRefDesign,
         ASYNC_IN                               => async_to_vio,
         SYNC_OUT                               => sync_from_vio
      );  
         
   txIla: entity work.chipscope_ila    
      port map (     
         CONTROL                                => txIla_control,
         CLK                                    => txFrameClk_from_gbtRefDesign,
         TRIG0                                  => txCommonData_from_gbtRefDesign,
         TRIG1                                  => txWidebusExtraData_from_gbtRefDesign,
         TRIG2(0)                               => txIsDataSel_from_user
      );    
         
   rxIla: entity work.chipscope_ila    
      port map (     
         CONTROL                                => rxIla_control,
         CLK                                    => rxFrameClk_from_gbtRefDesign,
         TRIG0                                  => rxCommonData_from_gbtRefDesign,
         TRIG1                                  => rxWidebusExtraData_from_gbtRefDesign,
         TRIG2(0)                               => rxIsData_from_gbtRefDesign
      );   

   -- On-board LEDs:             
   -----------------
   
   GPIO_LED_0                                   <= locked_from_txPll;          
   GPIO_LED_1                                   <= mgtReady_from_gbtRefDesign;
   GPIO_LED_2                                   <= gbtRxReady_from_gbtRefDesign;
   GPIO_LED_3                                   <= latencyOptGbtLink_from_gbtRefDesign;
   GPIO_LED_4                                   <= rxGbtReadyLostFlag_from_gbtRefDesign;
   GPIO_LED_5                                   <= commDataErrSeen_from_gbtRefDesign;
   GPIO_LED_6                                   <= widebusDataErrSeen_from_gbtRefDesign;
   GPIO_LED_7                                   <= '0';  -- 8b10 extra data error check
  
   --=====================--
   -- Latency measurement --
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If the RX data comes from another board with a different reference clock, 
   --                   then the TX frame/word clock domains are asynchronous with respect to the
   --                   RX frame/word clock domains.   
   
   FMC_HPC_LA02_P                               <= txFrameClk_from_gbtRefDesign;
   FMC_HPC_LA03_P                               <= rxFrameClk_from_gbtRefDesign; 
   FMC_HPC_LA04_P                               <= txWordClk_from_gbtRefDesign;  
   FMC_HPC_LA05_P                               <= rxWordClk_from_gbtRefDesign;
         
   USER_SMA_GPIO_P                              <= txFrameClk_from_gbtRefDesign when clkMuxSel_from_user = '1'
                                                   else txWordClk_from_gbtRefDesign;
   
   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test. 
   
   FMC_HPC_LA00_CC_P                            <= txMatchFlag_from_gbtRefDesign;
   FMC_HPC_LA01_CC_P                            <= rxMatchFlag_from_gbtRefDesign;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--