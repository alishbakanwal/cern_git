--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GLIB - GLIB user logic emulation                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         GLIB (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               1.1                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/08/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
--                        23/10/2013   1.1       M. Barros Marin   - Modified for hosting the new 
--                                                                   version of "xlx_v6_gbt_ref_design"  
--
-- Additional Comments:   Note!! Only ONE GBT Link (SFP1) can be used in this reference design.      
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
use work.glib_fmc_package_emu.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity glib_user_logic_emu is   
   port (   
      
      --===============--
      -- General reset --
      --===============-- 
      
      RESET_I                                   : in  std_logic;
      
      --=======================--      
      -- GLIB control & status --      
      --=======================--
      
      -- CDCE62005 status:      
      --------------------    
      
      USER_CDCE_LOCKED_I                        : in  std_logic;
      
      -- On-board LEDs:    
      -----------------    
            
      USER_V6_LED_O                             : out std_logic_vector(1 to 2);       
      
      --====================--
      -- GLIB clocks scheme --
      --====================--
      
      -- MGT(GTX) reference clock:
      ----------------------------      
      
      CDCE_OUT0_P                               : in  std_logic;
      CDCE_OUT0_N                               : in  std_logic;
            
      -- Fabric clock (40MHz):      
      ------------------------      
            
      XPOINT1_CLK3_P                            : in  std_logic;
      XPOINT1_CLK3_N                            : in  std_logic;     
         
      --=====================--
      -- MGT(GTX) (SFP Quad) --
      --=====================--
      
      -- Comment: Note!! Only SFP1 is used in this reference design.
      
      -- MGT(GTX) serial lanes:
      -------------------------
      
      SFP_TX_P                                  : out std_logic_vector(1 to 4);
      SFP_TX_N                                  : out std_logic_vector(1 to 4);
      SFP_RX_P                                  : in  std_logic_vector(1 to 4);
      SFP_RX_N                                  : in  std_logic_vector(1 to 4);
            
      -- SFP status:    
      --------------    
            
      SFP_MOD_ABS                               : in  std_logic_vector(1 to 4);      
      SFP_RXLOS                                 : in  std_logic_vector(1 to 4);      
      SFP_TXFAULT                               : in  std_logic_vector(1 to 4);      
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: FPGA_CLKOUT_O is connected to a multiplexor that switches between CDCE_OUT0 and XPOINT1_CLK3.
      
      FPGA_CLKOUT_O                             : out std_logic;        
      
      -- Pattern match flags:
      -----------------------
      
      -- Comment: * AMC_PORT TX_P(14:15) are used for pattern marching flags.     
      
      AMC_PORT_TX_P                             : out std_logic_vector(1 to 15);        
     
      -- Clock forwarding:
      --------------------  
      
      -- Comment: * FMC1_IO_PIN.la_p(0:1) are used for forwarding the tx and rx frame clocks respectively.
      --      
      --          * FMC1_IO_PIN.la_p(2:3) are used for forwarding the tx and rx word clocks respectively.
      
      FMC1_IO_PIN                               : inout fmc_io_pin_type     
            
   );
end glib_user_logic_emu;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of glib_user_logic_emu is   
   
   --==================================== Attributes =====================================--
   
   -- Comment: The "keep" constant is used to avoid that ISE changes the name of 
   --          the signals to be analysed with Chipscope.
   
   attribute keep                               : string;   
  
   --=====================================================================================--       
   
   --================================ Signal Declarations ================================--

   --===============--
   -- General reset --
   --===============--
   
   signal reset_from_or_gate                    : std_logic;         
         
   --=============--      
   -- GLIB status --      
   --=============--            
    
   signal userCdceLocked_r                      : std_logic;              
         
   --====================--                     
   -- GLIB clocks scheme --                     
   --====================--   
         
   signal cdce_out0                             : std_logic;
   signal cdce_out0_bufg                        : std_logic;
   signal xpoint1_clk3                          : std_logic;
   
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
   signal rxGbtReady_from_gbtRefDesign          : std_logic;    
   signal rxFrameClkAligned_from_gbtRefDesign   : std_logic; 
   signal rxIsDataFlag_from_gbtRefDesign        : std_logic;        
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
   
   --===============--
   -- General reset -- 
   --===============--
   
   reset_from_or_gate                           <= RESET_I or reset_from_user;   
   
   --===============--
   -- Clock buffers -- 
   --===============--   

   -- Fabric clock & TX_FRAMECLK (40MHz):
   --------------------------------------       
   
   xpSw1clk3_ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                           => FALSE,
         IOSTANDARD                             => "LVDS_25")
      port map (                 
         O                                      => xpoint1_clk3,
         I                                      => XPOINT1_CLK3_P,
         IB                                     => XPOINT1_CLK3_N
      );
      
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: Note!! CDCE_OUT0 must be set to 240 MHz for the LATENCY-OPTIMIZED GBT Link.   
   
   sfp_ibufds_gtxe1: ibufds_gtxe1
      port map (
         I                                      => CDCE_OUT0_P,
         IB                                     => CDCE_OUT0_N,
         O                                      => cdce_out0,
         ceb                                    => '0'
      );                
         
   sfp_ibufds_bufg: bufg               
      port map (              
         O                                      => cdce_out0_bufg,
         I                                      => cdce_out0 
      );     
  
   --===========================--
   -- GBT Link reference design --
   --===========================--
   
   gbtRefDesign: entity work.xlx_v6_gbt_ref_design
      generic map (
         FABRIC_CLK_FREQ                        => 40e6)      
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                        => reset_from_or_gate,                   
         -- Clocks scheme:                      
         FABRIC_CLK_I                           => xpoint1_clk3,
         MGT_REFCLKS_I                          => (tx => cdce_out0, rx => cdce_out0),              
         TX_OUTCLK_O                            => open,                                 -- Comment: TX_WORDCLK is generated internally  
         TX_WORDCLK_I                           => '0',                                  --          by GBT Link  
         TX_FRAMECLK_I                          => xpoint1_clk3,                      
         -- Serial lanes:                       
         MGT_TX_P                               => SFP_TX_P(1),                
         MGT_TX_N                               => SFP_TX_N(1),                
         MGT_RX_P                               => SFP_RX_P(1),                 
         MGT_RX_N                               => SFP_RX_N(1),
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
         RX_GBT_READY_O                         => rxGbtReady_from_gbtRefDesign,
         RX_ISDATA_FLAG_O                       => rxIsDataFlag_from_gbtRefDesign,            
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
         TX_FRAMECLK_O                          => txFrameClk_from_gbtRefDesign,   -- Comment: This clock is "xpoint1_clk3"          
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
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 
         
   cdceLockedReg: process(reset_from_or_gate, xpoint1_clk3)
   begin
      if reset_from_or_gate = '1' then
         userCdceLocked_r                       <= '0';
      elsif rising_edge(xpoint1_clk3) then
         userCdceLocked_r                       <= USER_CDCE_LOCKED_I;
      end if;
   end process;   
   
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
   async_to_vio( 0)                             <= rxIsDataFlag_from_gbtRefDesign;
   async_to_vio( 1)                             <= userCdceLocked_r;
   async_to_vio( 2)                             <= latencyOptGbtLink_from_gbtRefDesign;
   async_to_vio( 3)                             <= mgtReady_from_gbtRefDesign;
   async_to_vio( 4)                             <= rxWordClkAligned_from_gbtRefDesign;    
   async_to_vio( 9 downto 5)                    <= rxBitSlipNbr_from_gbtRefDesign;        
   async_to_vio(10)                             <= rxFrameClkAligned_from_gbtRefDesign;   
   async_to_vio(11)                             <= rxGbtReady_from_gbtRefDesign;          
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
   --          * After FPGA configuration using Chipscope, open the project "glib_gbt_ref_design.cpj" 
   --            that can be found in:
   --            "..\ref_designs\vendor_specific\xilinx\xlx_6_series\glib\chipscope\".  
   
   icon: entity work.chipscope_icon
      port map (
         CONTROL0                               => vio_control,
         CONTROL1                               => txIla_control,
         CONTROL2                               => rxIla_control
      );     
         
   vio: entity work.chipscope_vio      
      port map (     
         CONTROL                                => vio_control,
         CLK                                    => xpoint1_clk3,
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
         TRIG2(0)                               => rxIsDataFlag_from_gbtRefDesign
      );   

   -- On-board LEDs:             
   -----------------
   
   -- Comment: * USER_V6_LED_O(1) -> LD5 on GLIB. 
   --          * USER_V6_LED_O(2) -> LD4 on GLIB.       
   
   USER_V6_LED_O(1)                             <= userCdceLocked_r;          
   USER_V6_LED_O(2)                             <= mgtReady_from_gbtRefDesign;
   
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
   
   FMC1_IO_PIN.la_p(0)                          <= txFrameClk_from_gbtRefDesign;
   FMC1_IO_PIN.la_p(1)                          <= rxFrameClk_from_gbtRefDesign; 
   FMC1_IO_PIN.la_p(2)                          <= txWordClk_from_gbtRefDesign;  
   FMC1_IO_PIN.la_p(3)                          <= rxWordClk_from_gbtRefDesign;     
  
   -- Comment: FPGA_CLKOUT corresponds to SMA1 on GLIB.     
         
   FPGA_CLKOUT_O                                <= xpoint1_clk3 when clkMuxSel_from_user = '1'
                                                   else cdce_out0_bufg;
   
   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX flag with the RX flag.
   --
   --          * The counter pattern must be used for this test. 
   
   AMC_PORT_TX_P(14)                            <= txMatchFlag_from_gbtRefDesign;
   AMC_PORT_TX_P(15)                            <= rxMatchFlag_from_gbtRefDesign;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--