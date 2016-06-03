--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           FC7 - GBT example design                                     
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         FC7 (Xilinx Kintex 7)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               3.1                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        31/07/2014   3.1       M. Barros Marin   - First .vhd module definition           
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

entity fc7_gbt_example_design is
   port (   
      
      
      --=====================================================================================--
      -----------------------------------------------------------------------------------------
      ------------------------------------- System --------------------------------------------
      -----------------------------------------------------------------------------------------
      --=====================================================================================--
      
      
      --===============--
      -- General reset --
      --===============--      
     
      sw3                                            : in    std_logic;
 
      --=============--      
      -- FC7 control --      
      --=============--      
      
      -- Crosspoint Switch U42 & CDCE62005:
      -------------------------------------     
      
      fmc_l8_spare                                   : inout std_logic_vector(0 to 19);
      
      -- User LEDs:
      -------------
   
      sysled1_r                                      : out   std_logic; -- fmc_l12_spare[8]    -- D22
      sysled1_g                                      : out   std_logic; -- fmc_l12_spare[9]
      sysled1_b                                      : out   std_logic; -- fmc_l12_spare[10]   
      sysled2_r                                      : out   std_logic; -- fmc_l12_spare[11]   -- D23
      sysled2_g                                      : out   std_logic; -- fmc_l12_spare[12]
      sysled2_b                                      : out   std_logic; -- fmc_l12_spare[13] 
      
      -- Crosspoint Switches U8 & U7:
      -------------------------------
      
      k7_master_xpoint_ctrl                          : out   std_logic_vector(0 to 9);   
      
      -- FMC power:
      -------------
      
      fmc_l8_pwr_en                                  : out   std_logic;   
      fmc_l12_pwr_en                                 : out   std_logic;   
      
      --=============================--
      -- System fabric clock (40MHz) --
      --=============================--
   
      fabric_clk_p                                   : in    std_logic;
      fabric_clk_n                                   : in    std_logic;
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- Header P4 pins 9 & 10 (schematics page 6 "K7_GEN_IO"):
      ---------------------------------------------------------
      
      -- Comment: * TTC_MGT_XPOINT_C or FABRIC_CLK -> pin  9
      --          * TX_WORDCLK or TX_FRAMECLK      -> pin 10
      
      fmc_l12_spare                                  : inout std_logic_vector(7 downto 6);
      
      
      --=====================================================================================--
      -----------------------------------------------------------------------------------------
      --------------------------------------- User --------------------------------------------
      -----------------------------------------------------------------------------------------
      --=====================================================================================--
      
      
      --===================--
      -- FC7 clocks scheme --
      --===================--

      -- MGT(GTX) reference clock:
      ----------------------------      
      
      ttc_mgt_xpoint_c_p                             : in    std_logic;
      ttc_mgt_xpoint_c_n                             : in    std_logic;
      
      
      fmc_l12_dp_c2m_p                               : out   std_logic_vector(0 to 0);
      fmc_l12_dp_c2m_n                               : out   std_logic_vector(0 to 0);
      fmc_l12_dp_m2c_p                               : in    std_logic_vector(0 to 0);
      fmc_l12_dp_m2c_n                               : in    std_logic_vector(0 to 0);
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- FMC L8:
      ----------
      
      -- Comment: * FMC_L8_LA_P 4 &  6 are used for forwarding TX_FRAMECLK & TX_WORDCLK respectively.
      --         
      --          * FMC_L8_LA_P 8 & 10 are used for forwarding RX_FRAMECLK & RX_WORDCLK respectively.
      --
      --          * FMC_L8_LA_P 0 &  2 are used for forwarding the TX & RX PATTERN MATCH flags respectively.
      
      fmc_l8_la_p                                    : inout std_logic_vector(33 downto 0)
      
   );
end fc7_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of fc7_gbt_example_design is

   --================================ Signal Declarations ================================--

   
   --=====================================================================================--
   -----------------------------------------------------------------------------------------
   ---------------------------------------- System -----------------------------------------
   -----------------------------------------------------------------------------------------
   --=====================================================================================--
   
   
   --===================--                     
   -- FC7 clocks scheme --                     
   --===================--
  signal txFrameClk_from_txPll                      : std_logic;
   --===============--
   -- General reset --
   --===============--
   
   signal reset_powerup_b                            : std_logic;    
   signal reset_powerup                              : std_logic;    
   
   --=============================--
   -- System fabric clock (40MHz) --
   --=============================--
 
   signal fabric_clk_pre_buf                         : std_logic;
   signal fabric_clk                                 : std_logic;
   
   --================--
   -- User interface --
   --================--
   
   signal ipb_rst_i                                  : std_logic;
   
   signal fabric_clk_bufg_i                          : std_logic;
   
   signal user_cdce_locked_i                         : std_logic;
   
   signal usrled1_r                                  : std_logic;
   signal usrled1_g                                  : std_logic;
   signal usrled1_b                                  : std_logic;
   
   signal usrled2_r                                  : std_logic;
   signal usrled2_g                                  : std_logic;
   signal usrled2_b                                  : std_logic;
   
   signal header                                     : std_logic_vector(9 to 10);
   
   
   --=====================================================================================--
   -----------------------------------------------------------------------------------------
   ------------------------------------------ User -----------------------------------------
   -----------------------------------------------------------------------------------------
   --=====================================================================================--
 
 
   --===============--
   -- General reset --
   --===============--
   
   signal generalReset_from_generaReset              : std_logic;         
   
   --===================--                     
   -- FC7 clocks scheme --                     
   --===================-- 
   
   -- MGT(GTX) reference clock:     
   ---------------------------- 
   
   signal ttcMgtXpoint_from_ibufdsGtxe1              : std_logic;
   signal ttcMgtXpoint_from_bufg                     : std_logic;
   
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   -- Control:
   -----------
   
   signal generalReset_from_user                     : std_logic;      
   signal manualResetTx_from_user                    : std_logic; 
   signal manualResetRx_from_user                    : std_logic; 
   signal clkMuxSel_from_user                        : std_logic;       
   signal testPatterSel_from_user                    : std_logic_vector(1 downto 0); 
   signal loopBack_from_user                         : std_logic_vector(2 downto 0); 
   signal resetDataErrorSeenFlag_from_user           : std_logic; 
   signal resetGbtRxReadyLostFlag_from_user          : std_logic; 
   signal txIsDataSel_from_user                      : std_logic;   
   --------------------------------------------------       
   signal latOptGbtBankTx_from_gbtExmplDsgn          : std_logic;
   signal latOptGbtBankRx_from_gbtExmplDsgn          : std_logic;
   signal txFrameClkPllLocked_from_gbtExmplDsgn      : std_logic;
   signal mgtReady_from_gbtExmplDsgn                 : std_logic; 
   signal rxBitSlipNbr_from_gbtExmplDsgn             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal rxWordClkReady_from_gbtExmplDsgn           : std_logic; 
   signal rxFrameClkReady_from_gbtExmplDsgn          : std_logic; 
   signal gbtRxReady_from_gbtExmplDsgn               : std_logic;    
   signal rxIsData_from_gbtExmplDsgn                 : std_logic;        
   signal gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic; 
   signal rxDataErrorSeen_from_gbtExmplDsgn          : std_logic; 
   signal rxExtrDataWidebusErSeen_from_gbtExmplDsgn  : std_logic; 
   
   -- Data:
   --------
   
   signal txData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
   signal rxData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
   --------------------------------------------------       
   signal txExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(31 downto 0);
   signal rxExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(31 downto 0);
   -------------------------------------------------- 
   
   --===========--
   -- Chipscope --
   --===========--
   
   signal vioControl_from_icon                       : std_logic_vector(35 downto 0); 
   signal txIlaControl_from_icon                     : std_logic_vector(35 downto 0); 
   signal rxIlaControl_from_icon                     : std_logic_vector(35 downto 0); 
   -------------------------------------------------- 
   signal sync_from_vio                              : std_logic_vector(11 downto 0);
   signal async_to_vio                               : std_logic_vector(17 downto 0);
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   signal txFrameClk_from_gbtExmplDsgn               : std_logic;
   signal txWordClk_from_gbtExmplDsgn                : std_logic;
   signal rxFrameClk_from_gbtExmplDsgn               : std_logic;
   signal rxWordClk_from_gbtExmplDsgn                : std_logic;
   --------------------------------------------------                                     
   signal txMatchFlag_from_gbtExmplDsgn              : std_logic;
   signal rxMatchFlag_from_gbtExmplDsgn              : std_logic;
 
      
             signal sysclk:                    std_logic;
          
             -- ILA component  --
             --================--
             -- Vivado synthesis tool does not support mixed-language
             -- Solution: http://www.xilinx.com/support/answers/47454.html
             COMPONENT xlx_k7v7_vivado_debug PORT(
                CLK: in std_logic;
                PROBE0: in std_logic_vector(83 downto 0);
                PROBE1: in std_logic_vector(31 downto 0);
                PROBE2: in std_logic_vector(3 downto 0);
                PROBE3: in std_logic_vector(0 downto 0)
             );
             END COMPONENT;
             
             COMPONENT xlx_k7v7_vio
               PORT (
                 clk : IN STD_LOGIC;
                 probe_in0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in5 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
                 probe_in6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in8 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in9 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in10 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in11 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_in12 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                 probe_out3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                 probe_out4 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out5 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out6 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out7 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                 probe_out8 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
               );
             END COMPONENT;
         
             attribute mark_debug : string;
             
             attribute mark_debug of rxIsData_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of txFrameClkPllLocked_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of latOptGbtBankTx_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of mgtReady_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of rxWordClkReady_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of rxBitSlipNbr_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of rxFrameClkReady_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of gbtRxReady_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of gbtRxReadyLostFlag_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of rxDataErrorSeen_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of rxExtrDataWidebusErSeen_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of latOptGbtBankRx_from_gbtExmplDsgn: signal is "TRUE";
             attribute mark_debug of generalReset_from_user: signal is "TRUE";
             attribute mark_debug of clkMuxSel_from_user: signal is "TRUE";
             attribute mark_debug of testPatterSel_from_user: signal is "TRUE";
             attribute mark_debug of loopBack_from_user: signal is "TRUE";
             attribute mark_debug of resetDataErrorSeenFlag_from_user: signal is "TRUE";
             attribute mark_debug of resetGbtRxReadyLostFlag_from_user: signal is "TRUE";
             attribute mark_debug of txIsDataSel_from_user: signal is "TRUE";
             attribute mark_debug of manualResetTx_from_user: signal is "TRUE";
             attribute mark_debug of manualResetRx_from_user: signal is "TRUE";
   --=====================================================================================--
   
      --================--
      -- Clock component--
      --================--
      -- Vivado synthesis tool does not support mixed-language
      -- Solution: http://www.xilinx.com/support/answers/47454.html
      COMPONENT xlx_k7v7_tx_pll PORT(
         clk_in1: in std_logic;
         RESET: in std_logic;
         CLK_OUT1: out std_logic;
         LOCKED: out std_logic
      );
      END COMPONENT;
      
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
   
   
   --=====================================================================================--
   -----------------------------------------------------------------------------------------
   ---------------------------------------- System -----------------------------------------
   -----------------------------------------------------------------------------------------
   --=====================================================================================--
   
   
   --===============--
   -- General reset -- 
   --===============-- 
   
   reset_gen:srl16 port map (clk=>fabric_clk, q=>reset_powerup_b, a0=>'1',a1=>'1',a2 =>'1',a3 => '1',d=>'1');
   reset_powerup                                     <= (not reset_powerup_b) or (not sw3);
   
   ipb_rst_i                                         <= reset_powerup;
   
   --===============--
   -- Clocks scheme -- 
   --===============--   

   -- Fabric clock (40MHz):
   ------------------------       
   
   fabric_clk_ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                                => FALSE,
         IOSTANDARD                                  => "LVDS_25")
      port map (                 
         O                                           => fabric_clk_pre_buf,
         I                                           => fabric_clk_p,
         IB                                          => fabric_clk_n
      );
      
   fclk_bufg: BUFG 
      port map (
         I                                           => fabric_clk_pre_buf,
         O                                           => fabric_clk
      );
               
    debugclk_bufg: BUFG 
       port map (
          I                                           => fabric_clk_pre_buf,
          O                                           => sysclk
       );
      
   fabric_clk_bufg_i                                 <=  fabric_clk;  

   --=============--
   -- FC7 control --
   --=============--
   
   -- Crosspoint Switch U42:
   -------------------------
   
   -- Comment: * The clock signal from the output U0 of the clock synthesizer CDCE62005 (U38) is forwarded
   --            to the FPGA through the output TTC_MGT_XPOINT_C of the Crosspoint Switch U42 to be used as
   --            reference clock by the MGT of the GBT Bank.
   --
   --          * Note!! The output U0 of the clock synthesizer CDCE62005 (U38) MUST be set to 120MHz.
   
   fmc_l8_spare(8)                                   <= '0';
   
   -- Crosspoint Switches U8 & U7:
   -------------------------------
   
   -- Comment: The clock signal from the 40MHz crystal oscillator Y5 is forwarded to the FPGA through
   --          the output 1 of the Crosspoint Switch U8 (CKX) and the output 3 of the Crosspoint Switch U7
   --          (FABRIC_CLK) to be used as fabric clock by the "fc7_gbt_example_design". 
   
   k7_master_xpoint_ctrl(8)                          <= '1'; -- Comment: Crosspoint Switch U8 output 1 (CKX) is driven by 
   k7_master_xpoint_ctrl(9)                          <= '1'; --          input 4 (OSC).  
   
   k7_master_xpoint_ctrl(4)                          <= '1'; -- Comment: Crosspoint Switch U7 output 3 (FABRIC_CLK) is 
   k7_master_xpoint_ctrl(5)                          <= '1'; --          driven by input 4 (CKX).   
  
   -- CDCE62005:
   -------------

   -- Comment: The clock synthesizer CDCE62005 is reset and synchronized with "fabric_clk" after power up.
   
   cdceSync: entity work.cdce_synchronizer
      generic map (  
         PWRDOWN_DELAY                               => 1000,
         SYNC_DELAY                                  => 1000000)
      port map (
         RESET_I                                     => reset_powerup, 
         --------------------------------------------                     
         IPBUS_CTRL_I                                => '0',              -- Comment: * Control by USER
         IPBUS_SEL_I                                 => '1',              --          * CDCE62005 PRI_REF *NOT USED*
         IPBUS_PWRDOWN_I                             => '1',              --          * Active low        *NOT USED*
         IPBUS_SYNC_I                                => '1',              --          * Active low        *NOT USED*
         --------------------------------------------                     --       
         USER_SEL_I                                  => '0',              --          * CDCE62005 SEC_REF         
         USER_PWRDOWN_I                              => '1',              --          * Active low    
         USER_SYNC_I                                 => '1',              --          * Active low    
         --------------------------------------------                     --          
         PRI_CLK_I                                   => '0',              --          * *NOT USED*
         SEC_CLK_I                                   => fabric_clk,       --          * 40MHz         
         PWRDOWN_O                                   => fmc_l8_spare(5),
         SYNC_O                                      => fmc_l8_spare(4),
         REF_SEL_O                                   => fmc_l8_spare(0),         
         --------------------------------------------               
         SYNC_CMD_O                                  => open,
         SYNC_CLK_O                                  => open,
         SYNC_BUSY_O                                 => open,         
         SYNC_DONE_O                                 => open
      );
      
   fmc_l8_spare(1)                                   <= '1';   -- Comment: - "cdce_spi_le"
   fmc_l8_spare(2)                                   <= '0';   --          - "cdce_spi_clk"
   fmc_l8_spare(3)                                   <= '0';   --          - "cdce_spi_mosi"
   
   --===========--
   -- FMC power --
   --===========--
   
   fmc_l8_pwr_en                                     <= '1';
   fmc_l12_pwr_en                                    <= '1'; 
   
   --================--
   -- User interface --
   --================--
   
   user_cdce_locked_i                                <= fmc_l8_spare(10);
   
   sysled1_r                                         <= usrled1_r;
   sysled1_g                                         <= usrled1_g; 
   sysled1_b                                         <= usrled1_b;
   
   sysled2_r                                         <= usrled2_r;
   sysled2_g                                         <= usrled2_g; 
   sysled2_b                                         <= usrled2_b;
   
   fmc_l12_spare(6)                                  <= header( 9); 
   fmc_l12_spare(7)                                  <= header(10);
   
   
   --=====================================================================================--
   -----------------------------------------------------------------------------------------
   ------------------------------------------ User -----------------------------------------
   -----------------------------------------------------------------------------------------
   --=====================================================================================--

  
   --===============--
   -- General reset -- 
   --===============--
   
   generalReset: entity work.xlx_k7v7_reset
      port map (
         CLK_I                                       => fabric_clk_bufg_i,
         RESET1_B_I                                  => not ipb_rst_i,
         RESET2_B_I                                  => not generalReset_from_user,
         RESET_O                                     => generalReset_from_generaReset
      );
      
   --===============--
   -- Clocks scheme -- 
   --===============--   
   
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: * The clock signal from the output U0 of the clock synthesizer CDCE62005 (U38) is forwarded
   --            to the FPGA through the output TTC_MGT_XPOINT_C of the Crosspoint Switch U42 to be used as
   --            reference clock by the MGT of the GBT Bank.
   --
   --          * Note!! The output U0 of the clock synthesizer CDCE62005 (U38) MUST be set to 120MHz.   
   
   cdceOut0IbufdsGtxe2: ibufds_gte2
      port map (
         O                                           => ttcMgtXpoint_from_ibufdsGtxe1,
         ODIV2                                       => open,
         CEB                                         => '0',
         I                                           => ttc_mgt_xpoint_c_p,
         IB                                          => ttc_mgt_xpoint_c_n
      );
   
   cdceOut0Bufg: bufg
      port map (
         O                                           => ttcMgtXpoint_from_bufg, 
         I                                           => ttcMgtXpoint_from_ibufdsGtxe1
      );
         
             -- Frame clock
             txPll: xlx_k7v7_tx_pll
               port map (
                  clk_in1                                  => ttcMgtXpoint_from_ibufdsGtxe1,
                  CLK_OUT1                                 => txFrameClk_from_txPll,
                  -----------------------------------------  
                  RESET                                    => '0',
                  LOCKED                                   => txFrameClkPllLocked_from_gbtExmplDsgn
               );
      
             
         --=========================--
         -- GBT Bank example design --
         --=========================--    
         gbtExmplDsgn_inst: entity work.xlx_k7v7_gbt_example_design
             generic map(
                 GBT_BANK_ID                                            => 1,
                 NUM_LINKS                                              => GBT_BANKS_USER_SETUP(1).NUM_LINKS,
                 TX_OPTIMIZATION                                        => GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION,
                 RX_OPTIMIZATION                                        => GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION,
                 TX_ENCODING                                            => GBT_BANKS_USER_SETUP(1).TX_ENCODING,
                 RX_ENCODING                                            => GBT_BANKS_USER_SETUP(1).RX_ENCODING
             )
           port map (
      
             --==============--
             -- Clocks       --
             --==============--
             FRAMECLK_40MHZ                                             => txFrameClk_from_txPll,
             XCVRCLK                                                    => ttcMgtXpoint_from_ibufdsGtxe1,
             
             TX_FRAMECLK_O(1)                                           => txFrameClk_from_gbtExmplDsgn,        
             TX_WORDCLK_O(1)                                            => txWordClk_from_gbtExmplDsgn,          
             RX_FRAMECLK_O(1)                                           => rxFrameClk_from_gbtExmplDsgn,         
             RX_WORDCLK_O(1)                                            => rxWordClk_from_gbtExmplDsgn,      
             
             --==============--
             -- Reset        --
             --==============--
             GBTBANK_GENERAL_RESET_I                                    => generalReset_from_generaReset,
             GBTBANK_MANUAL_RESET_TX_I                                  => manualResetTx_from_user,
             GBTBANK_MANUAL_RESET_RX_I                                  => manualResetRx_from_user,
             
             --==============--
             -- Serial lanes --
             --==============--
             GBTBANK_MGT_RX_P(1)                                        => fmc_l12_dp_m2c_p(0),
             GBTBANK_MGT_RX_N(1)                                        => fmc_l12_dp_m2c_n(0),
             GBTBANK_MGT_TX_P(1)                                        => fmc_l12_dp_c2m_p(0),
             GBTBANK_MGT_TX_N(1)                                        => fmc_l12_dp_c2m_n(0),
             
             --==============--
             -- Data             --
             --==============--        
             GBTBANK_GBT_DATA_I(1)                                      => (others => '0'),
             GBTBANK_WB_DATA_I(1)                                       => (others => '0'),
             
             TX_DATA_O(1)                                               => txData_from_gbtExmplDsgn,            
             WB_DATA_O(1)                                               => open, --txExtraDataWidebus_from_gbtExmplDsgn,
             
             GBTBANK_GBT_DATA_O(1)                                      => rxData_from_gbtExmplDsgn,
             GBTBANK_WB_DATA_O(1)                                       => open, --rxExtraDataWidebus_from_gbtExmplDsgn,
             
             --==============--
             -- Reconf.         --
             --==============--
             GBTBANK_MGT_DRP_RST                                        => '0',
             GBTBANK_MGT_DRP_CLK                                        => fabric_clk, --
             
             --==============--
             -- TX ctrl        --
             --==============--
             GBTBANK_TX_ISDATA_SEL_I(1)                                => txIsDataSel_from_user, --
             GBTBANK_TEST_PATTERN_SEL_I                                => testPatterSel_from_user, --
             
             --==============--
             -- RX ctrl      --
             --==============--
             GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(1)                   => resetGbtRxReadyLostFlag_from_user, --
             GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(1)                    => resetDataErrorSeenFlag_from_user, --
             
             --==============--
             -- TX Status    --
             --==============--
             GBTBANK_LINK_READY_O(1)                                   => mgtReady_from_gbtExmplDsgn, --
             GBTBANK_TX_MATCHFLAG_O                                    => txMatchFlag_from_gbtExmplDsgn,--
             
             --==============--
             -- RX Status    --
             --==============--
             GBTBANK_GBTRX_READY_O(1)                                  => gbtRxReady_from_gbtExmplDsgn, --
             GBTBANK_LINK1_BITSLIP_O                                   => rxBitSlipNbr_from_gbtExmplDsgn, --
             GBTBANK_GBTRXREADY_LOST_FLAG_O(1)                         => gbtRxReadyLostFlag_from_gbtExmplDsgn, --
             GBTBANK_RXDATA_ERRORSEEN_FLAG_O(1)                        => rxDataErrorSeen_from_gbtExmplDsgn, --
             GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O(1)           => rxExtrDataWidebusErSeen_from_gbtExmplDsgn, --
             GBTBANK_RX_MATCHFLAG_O(1)                                 => rxMatchFlag_from_gbtExmplDsgn, --
             GBTBANK_RX_ISDATA_SEL_O(1)                                => rxIsData_from_gbtExmplDsgn, --
             
             --==============--
             -- XCVR ctrl    --
             --==============--
             GBTBANK_LOOPBACK_I                                        => loopBack_from_user, --
             
             GBTBANK_TX_POL(1)                                         => '0', --
             GBTBANK_RX_POL(1)                                         => '0' --
        ); 
        
   --==============--   
   -- Test control --   
   --==============--      
   
   -- ChipScope:
   -------------   
   
   -- Comment: * ChipScope is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * Note!! TX and RX DATA do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving RX DATA from another board with a different reference clock, the 
   --            TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the RX_FRAMECLK/RX_WORDCLK domains.        
   --
   --          * After FPGA configuration using ChipScope, open the project "fc7_gbt_example_design.cpj" 
   --            that can be found in:
   --            "..\example_designs\xilix_k7v7\fc7\chipscope_project\".  
   
   
       latOptGbtBankTx_from_gbtExmplDsgn                       <= '1' when GBT_BANKS_USER_SETUP(1).TX_OPTIMIZATION = LATENCY_OPTIMIZED else
                                                                              '0';
       latOptGbtBankRx_from_gbtExmplDsgn                       <= '1' when GBT_BANKS_USER_SETUP(1).RX_OPTIMIZATION = LATENCY_OPTIMIZED else
                                                                              '0';
                                                                              
   vio : xlx_k7v7_vio
         PORT MAP (
           clk => sysclk,
           probe_in0(0) => rxIsData_from_gbtExmplDsgn,
           probe_in1(0) => txFrameClkPllLocked_from_gbtExmplDsgn,
           probe_in2(0) => latOptGbtBankTx_from_gbtExmplDsgn,
           probe_in3(0) => mgtReady_from_gbtExmplDsgn,
           probe_in4(0) => rxWordClkReady_from_gbtExmplDsgn,
           probe_in5    => rxBitSlipNbr_from_gbtExmplDsgn,
           probe_in6(0) => rxFrameClkReady_from_gbtExmplDsgn,
           probe_in7(0) => gbtRxReady_from_gbtExmplDsgn,
           probe_in8(0) => gbtRxReadyLostFlag_from_gbtExmplDsgn,
           probe_in9(0) => rxDataErrorSeen_from_gbtExmplDsgn,
           probe_in10(0) => rxExtrDataWidebusErSeen_from_gbtExmplDsgn,
           probe_in11(0) => '0', --8b10b support removed  
           probe_in12(0) => latOptGbtBankRx_from_gbtExmplDsgn,
           probe_out0(0) => generalReset_from_user,
           probe_out1(0) => clkMuxSel_from_user,
           probe_out2 => testPatterSel_from_user,
           probe_out3 => loopBack_from_user,
           probe_out4(0) => resetDataErrorSeenFlag_from_user,
           probe_out5(0) => resetGbtRxReadyLostFlag_from_user,
           probe_out6(0) => txIsDataSel_from_user,
           probe_out7(0) => manualResetTx_from_user,
           probe_out8(0) => manualResetRx_from_user
         );
           
   txILa: xlx_k7v7_vivado_debug
       port map (
          CLK => sysclk,
          PROBE0 => txData_from_gbtExmplDsgn,
          PROBE1 => txExtraDataWidebus_from_gbtExmplDsgn,
          PROBE2 => (others => '0'), -- 8b10b support removed
          PROBE3(0) => txIsDataSel_from_user);  
 
   rxIla: xlx_k7v7_vivado_debug
       port map (
          CLK => sysclk,
          PROBE0 => rxData_from_gbtExmplDsgn,
          PROBE1 => rxExtraDataWidebus_from_gbtExmplDsgn,
          PROBE2 => (others => '0'), --Removed 8b10b support
          PROBE3(0) => rxIsData_from_gbtExmplDsgn);   

   -- On-board LEDs:             
   -----------------
   
   usrled1_r                                         <= '1';
   usrled1_g                                         <= '1';                                    
   usrled1_b                                         <= not (user_cdce_locked_i and txFrameClkPllLocked_from_gbtExmplDsgn);
   
   usrled2_r                                         <= '1';
   usrled2_g                                         <= '1';  
   usrled2_b                                         <= not mgtReady_from_gbtExmplDsgn;
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: Header P4 pins 9 & 10 (schematics page 6 "K7_GEN_IO").
   
   header( 9)                                        <= ttcMgtXpoint_from_bufg      when clkMuxSel_from_user = '1' else 
                                                        fabric_clk_bufg_i;          

   header(10)                                        <= txWordClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1' else 
                                                        txFrameClk_from_gbtExmplDsgn;

   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If RX DATA comes from another board with a different reference clock, 
   --                   then the TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the
   --                   TX_FRAMECLK/TX_WORDCLK domains. 
   
   fmc_l8_la_p( 0)                                   <= txFrameClk_from_gbtExmplDsgn;
   fmc_l8_la_p( 2)                                   <= txWordClk_from_gbtExmplDsgn;
   --------------------------------------------------   
   fmc_l8_la_p( 4)                                   <= rxFrameClk_from_gbtExmplDsgn;  
   fmc_l8_la_p( 6)                                   <= rxWordClk_from_gbtExmplDsgn;  

   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX FLAG with the RX FLAG.
   --
   --          * The COUNTER TEST PATTERN must be used for this test.  
   
   fmc_l8_la_p( 8)                                   <= txMatchFlag_from_gbtExmplDsgn;
   fmc_l8_la_p(10)                                   <= rxMatchFlag_from_gbtExmplDsgn;
  
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--