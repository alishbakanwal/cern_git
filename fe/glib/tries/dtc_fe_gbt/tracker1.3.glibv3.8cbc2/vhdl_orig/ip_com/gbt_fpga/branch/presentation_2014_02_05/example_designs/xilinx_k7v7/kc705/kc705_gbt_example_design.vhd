--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           KC705 - GBT Bank example design                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         KC705 (Xilinx Kintex 7)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        28/10/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
-- Additional Comments:   Note!! Only ONE GBT Bank with ONE link can be used in this example design.     
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
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity kc705_gbt_example_design is   
   port (   
      
      --===============--
      -- Clocks scheme --
      --===============-- 
      
      -- Fabric clock:
      ----------------     

      USER_CLOCK_P                                    : in  std_logic;
      USER_CLOCK_N                                    : in  std_logic;
      
      
      
      -- MGT(GTX) reference clock:
      ----------------------------
      
      -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
      --
      --          * The MGT reference clock frequency must be 120MHz for the latency-optimized GBT Bank.      
      
      SMA_MGT_REFCLK_P                                : in  std_logic;
      SMA_MGT_REFCLK_N                                : in  std_logic;          
                                                      
      --===============--     
      -- General reset --     
      --===============--     
            
      CPU_RESET                                       : in  std_logic;      
      
      --==========--
      -- MGT(GTX) --
      --==========--                   
      
      -- Serial lines:
      ----------------
      
      SFP_TX_P                                        : out std_logic;
      SFP_TX_N                                        : out std_logic;
      SFP_RX_P                                        : in  std_logic;
      SFP_RX_N                                        : in  std_logic;                  
      
      -- SFP control:
      ---------------
      
      SFP_TX_DISABLE                                  : out std_logic;
      
      --===============--      
      -- On-board LEDs --      
      --===============--

      GPIO_LED_0_LS                                   : out std_logic;
      GPIO_LED_1_LS                                   : out std_logic;
      GPIO_LED_2_LS                                   : out std_logic;
      GPIO_LED_3_LS                                   : out std_logic;
      GPIO_LED_4_LS                                   : out std_logic;
      GPIO_LED_5_LS                                   : out std_logic;
      GPIO_LED_6_LS                                   : out std_logic;
      GPIO_LED_7_LS                                   : out std_logic;      
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: USER_SMA_GPIO_P is connected to a multiplexor that switches between SMA_MGT_REFCLK and TX_FRAMECLK.
      
      USER_SMA_GPIO_P                                 : out std_logic;        
      
      -- Pattern match flags:
      -----------------------
      
      -- Comment: FMC_HPC_LA00_P and FMC_HPC_LA01_P are used for pattern marching flags respectively.     
      
      FMC_HPC_LA00_CC_P                               : out std_logic;       
      FMC_HPC_LA01_CC_P                               : out std_logic;
      
      -- Clock forwarding:
      --------------------  
      
      -- Comment: * FMC_HPC_LA02_P and FMC_HPC_LA03_P are used for forwarding the tx and rx frame clocks respectively.
      --      
      --          * FMC_HPC_LA04_P and FMC_HPC_LA05_P are used for forwarding the tx and rx word clocks respectively.
      
      FMC_HPC_LA02_P                                  : out std_logic; 
      FMC_HPC_LA03_P                                  : out std_logic; 
      FMC_HPC_LA04_P                                  : out std_logic; 
      FMC_HPC_LA05_P                                  : out std_logic 
            
   );
end kc705_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of kc705_gbt_example_design is   
   
   --==================================== Attributes =====================================--
   
   -- Comment: The "keep" constant is used to avoid that ISE changes the name of 
   --          the signals to be analysed with Chipscope.
   
   attribute keep                                     : string;
  
   --=====================================================================================--       
   
   --================================ Signal Declarations ================================--          

   --==============--
   -- Clock scheme -- 
   --==============--   
   
   -- Fabric clock:
   ----------------
   
   signal userClock_ibufgds                           : std_logic;     
         
   -- MGT(GTX) reference clock:     
   ----------------------------     
            
   signal sma_mgt_refclk                              : std_logic;
         
   --===============--     
   -- General reset --     
   --===============--     
         
   signal reset_from_rst                              : std_logic;    
      
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   -- Control:
   -----------
   
   signal reset_from_user                             : std_logic;      
   signal clkMuxSel_from_user                         : std_logic;       
   signal testPatterSel_from_user                     : std_logic_vector(1 downto 0); 
   signal loopBack_from_user                          : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user            : std_logic; 
   signal resetGbtRxReadyLostFlag_from_user           : std_logic; 
   signal txIsDataSel_from_user                       : std_logic;   
   signal encodingSel_from_user                       : std_logic_vector(1 downto 0); 
   ---------------------------------------------------      
   signal txFrameClkPllLocked_from_gbtExmplDsgn       : std_logic;
   signal latencyOptGbtBank_from_gbtExmplDsgn         : std_logic;
   signal rxHeaderLocked_from_gbtExmplDsgn            : std_logic;
   signal rxBitSlipNbr_from_gbtExmplDsgn              : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal rxWordClkAligned_from_gbtExmplDsgn          : std_logic; 
   signal mgtReady_from_gbtExmplDsgn                  : std_logic; 
   signal gbtRxReady_from_gbtExmplDsgn                : std_logic;    
   signal rxFrameClkAligned_from_gbtExmplDsgn         : std_logic; 
   signal rxIsData_from_gbtExmplDsgn                  : std_logic;        
   signal gbtRxReadyLostFlag_from_gbtExmplDsgn        : std_logic; 
   signal commDataErrSeen_from_gbtExmplDsgn           : std_logic; 
   signal widebusExtraDataErrSeen_from_gbtExmplDsgn   : std_logic; 
   signal enc8b10bExtraDataErrSeen_from_gbtExmplDsgn  : std_logic;
   
   -- Data:
   --------
   
   signal txCommonData_from_gbtExmplDsgn              : std_logic_vector(83 downto 0);
   signal rxCommonData_from_gbtExmplDsgn              : std_logic_vector(83 downto 0);
   ---------------------------------------------------      
   signal txWidebusExtraData_from_gbtExmplDsgn        : std_logic_vector(31 downto 0);
   signal rxWidebusExtraData_from_gbtExmplDsgn        : std_logic_vector(31 downto 0);
   ---------------------------------------------------
   signal txEnc8b10bExtraData_from_gbtExmplDsgn       : std_logic_vector( 3 downto 0);
   signal rxEnc8b10bExtraData_from_gbtExmplDsgn       : std_logic_vector( 3 downto 0);  
   
   --===========--
   -- Chipscope --
   --===========--
   
   signal vio_control                                 : std_logic_vector(35 downto 0); 
   signal txIla_control                               : std_logic_vector(35 downto 0); 
   signal rxIla_control                               : std_logic_vector(35 downto 0); 
   ---------------------------------------------------
   signal sync_from_vio                               : std_logic_vector(11 downto 0);
   signal async_to_vio                                : std_logic_vector(16 downto 0);
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   signal txFrameClk_from_gbtExmplDsgn                : std_logic;
   signal rxFrameClk_from_gbtExmplDsgn                : std_logic;
   signal txWordClk_from_gbtExmplDsgn                 : std_logic;
   signal rxWordClk_from_gbtExmplDsgn                 : std_logic;
   ---------------------------------------------------                                    
   signal txMatchFlag_from_gbtExmplDsgn               : std_logic;
   signal rxMatchFlag_from_gbtExmplDsgn               : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --=============--
   -- SFP control -- 
   --=============-- 
   
   SFP_TX_DISABLE                                     <= '0';   
   
   --==============--
   -- Clock scheme -- 
   --==============--   
   
   -- Fabric clock:
   ----------------
   
   -- Comment: USER_CLOCK frequency: 156MHz 
   
   userClockIbufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                                 => FALSE,      
         IOSTANDARD                                   => "LVDS_25")
      port map (     
         O                                            => userClock_ibufgds,   
         I                                            => USER_CLOCK_P,  
         IB                                           => USER_CLOCK_N 
      );
   
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
   --
   --          * The MGT reference clock frequency must be 120MHz for the latency-optimized GBT Bank. 
   
   sfpIbufdsGtxe1: ibufds_gte2
      port map (
         O                                            => sma_mgt_refclk,
         ODIV2                                        => open,
         CEB                                          => '0',
         I                                            => SMA_MGT_REFCLK_P,
         IB                                           => SMA_MGT_REFCLK_N
      );
  
   --===============--
   -- General reset -- 
   --===============--
   
   rst: entity work.xlx_k7v7_reset
      generic map (
         CLK_FREQ                                     => 156e6)
      port map (     
         CLK_I                                        => userClock_ibufgds,
         RESET1_B_I                                   => not CPU_RESET, 
         RESET2_B_I                                   => not reset_from_user,
         RESET_O                                      => reset_from_rst 
      ); 
      
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   gbtExmplDsgn: entity work.xlx_k7v7_gbt_example_design
      generic map (
         FABRIC_CLK_FREQ                              => 156e6)      
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                              => reset_from_rst,                   
         -- Clocks scheme:                            
         FABRIC_CLK_I                                 => userClock_ibufgds,
         MGT_REFCLK_I                                 => sma_mgt_refclk,             
         -- Serial links:                             
         MGT_TX_P                                     => SFP_TX_P,                
         MGT_TX_N                                     => SFP_TX_N,                
         MGT_RX_P                                     => SFP_RX_P,                 
         MGT_RX_N                                     => SFP_RX_N,
         -- General control:                       
         LOOPBACK_I                                   => loopBack_from_user,  
         TX_ENCODING_SEL_I                            => encodingSel_from_user,
         RX_ENCODING_SEL_I                            => encodingSel_from_user,
         TX_ISDATA_SEL_I                              => txIsDataSel_from_user,                 
         ---------------------------------------------      
         TX_FRAMECLK_PLL_LOCKED_O                     => txFrameClkPllLocked_from_gbtExmplDsgn,
         LATENCY_OPT_GBTBANK_O                        => latencyOptGbtBank_from_gbtExmplDsgn,             
         MGT_READY_O                                  => mgtReady_from_gbtExmplDsgn,             
         RX_HEADER_LOCKED_O                           => rxHeaderLocked_from_gbtExmplDsgn,
         RX_BITSLIP_NUMBER_O                          => rxBitSlipNbr_from_gbtExmplDsgn,            
         RX_WORDCLK_ALIGNED_O                         => rxWordClkAligned_from_gbtExmplDsgn,           
         RX_FRAMECLK_ALIGNED_O                        => rxFrameClkAligned_from_gbtExmplDsgn,            
         GBT_RX_READY_O                               => gbtRxReady_from_gbtExmplDsgn,
         RX_ISDATA_FLAG_O                             => rxIsData_from_gbtExmplDsgn,            
         -- GBT Bank data:                            
         TX_DATA_O                                    => txCommonData_from_gbtExmplDsgn,            
         TX_WIDEBUS_EXTRA_DATA_O                      => txWidebusExtraData_from_gbtExmplDsgn,
         TX_ENC8B10B_EXTRA_DATA_O                     => txEnc8b10bExtraData_from_gbtExmplDsgn,
         ---------------------------------------------      
         RX_DATA_O                                    => rxCommonData_from_gbtExmplDsgn,           
         RX_WIDEBUS_EXTRA_DATA_O                      => rxWidebusExtraData_from_gbtExmplDsgn,
         RX_ENC8B10B_EXTRA_DATA_O                     => rxEnc8b10bExtraData_from_gbtExmplDsgn,
         -- Test control:                    
         TEST_PATTERN_SEL_I                           => testPatterSel_from_user,        
         ---------------------------------------------                          
         RESET_GBT_RX_READY_LOST_FLAG_I               => resetGbtRxReadyLostFlag_from_user,     
         GBT_RX_READY_LOST_FLAG_O                     => gbtRxReadyLostFlag_from_gbtExmplDsgn,       
         RESET_DATA_ERROR_SEEN_FLAG_I                 => resetDataErrorSeenFlag_from_user,     
         COMMONDATA_ERROR_SEEN_FLAG_O                 => commDataErrSeen_from_gbtExmplDsgn,      
         WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O           => widebusExtraDataErrSeen_from_gbtExmplDsgn,
         ENC8B10BEXTRADATA_ERROR_SEEN_FLAG_O          => enc8b10bExtraDataErrSeen_from_gbtExmplDsgn,
         -- Latency measurement:                      
         TX_FRAMECLK_O                                => txFrameClk_from_gbtExmplDsgn,        
         RX_FRAMECLK_O                                => rxFrameClk_from_gbtExmplDsgn,         
         TX_WORDCLK_O                                 => txWordClk_from_gbtExmplDsgn,          
         RX_WORDCLK_O                                 => rxWordClk_from_gbtExmplDsgn,          
         ---------------------------------------------                     
         TX_MATCHFLAG_O                               => txMatchFlag_from_gbtExmplDsgn,          
         RX_MATCHFLAG_O                               => rxMatchFlag_from_gbtExmplDsgn          
      );                                        
   
   --==============--   
   -- Test control --   
   --==============--
   
   -- Signals mapping:
   -------------------
   
   reset_from_user                                    <= sync_from_vio( 0);          
   clkMuxSel_from_user                                <= sync_from_vio( 1);
   testPatterSel_from_user                            <= sync_from_vio( 3 downto 2); 
   loopBack_from_user                                 <= sync_from_vio( 6 downto 4);
   resetDataErrorSeenFlag_from_user                   <= sync_from_vio( 7);
   resetGbtRxReadyLostFlag_from_user                  <= sync_from_vio( 8);
   txIsDataSel_from_user                              <= sync_from_vio( 9);
   encodingSel_from_user                              <= sync_from_vio(11 downto 10);
   ---------------------------------------------------      
   async_to_vio( 0)                                   <= rxIsData_from_gbtExmplDsgn;
   async_to_vio( 1)                                   <= txFrameClkPllLocked_from_gbtExmplDsgn;
   async_to_vio( 2)                                   <= latencyOptGbtBank_from_gbtExmplDsgn;
   async_to_vio( 3)                                   <= mgtReady_from_gbtExmplDsgn;
   async_to_vio( 4)                                   <= rxWordClkAligned_from_gbtExmplDsgn;    
   async_to_vio(10 downto 5)                          <= rxBitSlipNbr_from_gbtExmplDsgn; 
   async_to_vio(11)                                   <= rxFrameClkAligned_from_gbtExmplDsgn;   
   async_to_vio(12)                                   <= gbtRxReady_from_gbtExmplDsgn;          
   async_to_vio(13)                                   <= gbtRxReadyLostFlag_from_gbtExmplDsgn;  
   async_to_vio(14)                                   <= commDataErrSeen_from_gbtExmplDsgn;   
   async_to_vio(15)                                   <= widebusExtraDataErrSeen_from_gbtExmplDsgn;
   async_to_vio(16)                                   <= enc8b10bExtraDataErrSeen_from_gbtExmplDsgn;
   
   -- Chipscope:
   -------------   
   
   -- Comment: * Chipscope is used to control and check the status of the example design as well 
   --            as for transmitted and received data analysis.
   --
   --          * Note!! The TX data and RX data do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving the RX data from another board with a different reference clock, the TX
   --            frame/word clock domains are asynchronous with respect to to the RX frame/word clock domains.        
   --
   --          * After FPGA configuration using Chipscope, open the project "kc705_gbt_example_design.cpj" 
   --            that can be found in:
   --            "..\example_designs\xilix_k7v7\kc705\chipscope\".  
   
   icon: entity work.kc705_chipscope_icon
      port map (
         CONTROL0                               => vio_control,
         CONTROL1                               => txIla_control,
         CONTROL2                               => rxIla_control
      );
      
   vio: entity work.kc705_chipscope_vio      
      port map (     
         CONTROL                                => vio_control,
         CLK                                    => txFrameClk_from_gbtExmplDsgn,
         ASYNC_IN                               => async_to_vio,
         SYNC_OUT                               => sync_from_vio
      );  
   
   txIla: entity work.kc705_chipscope_ila    
      port map (     
         CONTROL                                => txIla_control,
         CLK                                    => txFrameClk_from_gbtExmplDsgn,
         TRIG0                                  => txCommonData_from_gbtExmplDsgn,
         TRIG1                                  => txWidebusExtraData_from_gbtExmplDsgn,
         TRIG2                                  => txEnc8b10bExtraData_from_gbtExmplDsgn,
         TRIG3(0)                               => txIsDataSel_from_user
      );    
         
   rxIla: entity work.kc705_chipscope_ila    
      port map (     
         CONTROL                                => rxIla_control,
         CLK                                    => rxFrameClk_from_gbtExmplDsgn,
         TRIG0                                  => rxCommonData_from_gbtExmplDsgn,
         TRIG1                                  => rxWidebusExtraData_from_gbtExmplDsgn,
         TRIG2                                  => rxEnc8b10bExtraData_from_gbtExmplDsgn,
         TRIG3(0)                               => rxIsData_from_gbtExmplDsgn
      );   

   -- On-board LEDs:             
   -----------------
   
   GPIO_LED_0_LS                                <= txFrameClkPllLocked_from_gbtExmplDsgn;          
   GPIO_LED_1_LS                                <= mgtReady_from_gbtExmplDsgn;
   GPIO_LED_2_LS                                <= gbtRxReady_from_gbtExmplDsgn;
   GPIO_LED_3_LS                                <= latencyOptGbtBank_from_gbtExmplDsgn;
   GPIO_LED_4_LS                                <= gbtRxReadyLostFlag_from_gbtExmplDsgn;
   GPIO_LED_5_LS                                <= commDataErrSeen_from_gbtExmplDsgn;
   GPIO_LED_6_LS                                <= widebusExtraDataErrSeen_from_gbtExmplDsgn;
   GPIO_LED_7_LS                                <= enc8b10bExtraDataErrSeen_from_gbtExmplDsgn;
  
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
   
   FMC_HPC_LA02_P                               <= txFrameClk_from_gbtExmplDsgn;
   FMC_HPC_LA03_P                               <= rxFrameClk_from_gbtExmplDsgn; 
   FMC_HPC_LA04_P                               <= txWordClk_from_gbtExmplDsgn;  
   FMC_HPC_LA05_P                               <= rxWordClk_from_gbtExmplDsgn;
         
   USER_SMA_GPIO_P                              <= txWordClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1'
                                                   else txFrameClk_from_gbtExmplDsgn;
   
   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test. 
   
   FMC_HPC_LA00_CC_P                            <= txMatchFlag_from_gbtExmplDsgn;
   FMC_HPC_LA01_CC_P                            <= rxMatchFlag_from_gbtExmplDsgn;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--