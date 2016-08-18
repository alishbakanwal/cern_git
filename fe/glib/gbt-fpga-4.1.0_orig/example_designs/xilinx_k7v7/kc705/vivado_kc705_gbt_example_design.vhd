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
-- Tool version:          ISE 14.5, Vivado 2014.4                                                                
--                                                                                                   
-- Version:               3.1                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        28/10/2013   3.0       M. Barros Marin   First .vhd module definition   
--                        28/10/2013   3.1       J. Mendez         Vivado support           
--
-- Additional Comments:   Note!! Only ONE GBT Bank with ONE link can be used in this example design.     
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

entity kc705_gbt_example_design is
    port (  
      --===============--     
      -- General reset --     
      --===============--     

      CPU_RESET                                      : in  std_logic;     
      
      --===============--
      -- Clocks scheme --
      --===============-- 
      
      -- System clock:
      ----------------
      SYSCLK_P                                     : in  std_logic;
      SYSCLK_N                                     : in  std_logic;   
            
      -- Fabric clock:
      ----------------     

      USER_CLOCK_P                                   : in  std_logic;
      USER_CLOCK_N                                   : in  std_logic;      
      
      -- MGT(GTX) reference clock:
      ----------------------------
      
      -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
      --
      --          * The MGT reference clock frequency must be 120MHz for the latency-optimized GBT Bank.      
      
      SMA_MGT_REFCLK_P                               : in  std_logic;
      SMA_MGT_REFCLK_N                               : in  std_logic; 
      
      --==========--
      -- MGT(GTX) --
      --==========--                   
      
      -- Serial lanes:
      ----------------
      
      SFP_TX_P                                       : out std_logic;
      SFP_TX_N                                       : out std_logic;
      SFP_RX_P                                       : in  std_logic;
      SFP_RX_N                                       : in  std_logic;    
      
      -- SFP control:
      ---------------
      
      SFP_TX_DISABLE                                 : out std_logic;
      
      --===============--      
      -- On-board LEDs --      
      --===============--

      GPIO_LED_0_LS                                  : out std_logic;
      GPIO_LED_1_LS                                  : out std_logic;
      GPIO_LED_2_LS                                  : out std_logic;
      GPIO_LED_3_LS                                  : out std_logic;
      GPIO_LED_4_LS                                  : out std_logic;
      GPIO_LED_5_LS                                  : out std_logic;
      GPIO_LED_6_LS                                  : out std_logic;
      GPIO_LED_7_LS                                  : out std_logic;      
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: USER_SMA_GPIO_P is connected to a multiplexor that switches between TX_FRAMECLK and TX_WORDCLK.
      USER_SMA_GPIO_P                                : out std_logic;    
      USER_SMA_GPIO_N                                : out std_logic;          
      
      -- Pattern match flags:
      -----------------------
      
      FMC_HPC_LA00_CC_P                              : out std_logic;       
      FMC_HPC_LA01_CC_P                              : out std_logic;
      
      -- Clocks forwarding:
      ---------------------  
      
      -- Comment: * FMC_HPC_LA02_P and FMC_HPC_LA03_P are used for forwarding TX_FRAMECLK and TX_WORDCLK respectively.
      --      
      --          * FMC_HPC_LA04_P and FMC_HPC_LA05_P are used for forwarding RX_FRAMECLK and RX_WORDCLK respectively.
      
      FMC_HPC_LA02_P                                 : out std_logic; 
      FMC_HPC_LA03_P                                 : out std_logic; 
      -----------------------------------------------
      FMC_HPC_LA04_P                                 : out std_logic; 
      FMC_HPC_LA05_P                                 : out std_logic 

   );
end kc705_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of kc705_gbt_example_design is
   
   --================================ Signal Declarations ================================--          
   
   --===============--     
   -- General reset --     
   --===============--     

   signal reset_from_genRst                          : std_logic;    
   
   --===============--
   -- Clocks scheme -- 
   --===============--   
   
   -- Fabric clock:
   ----------------
   
   signal fabricClk_from_userClockIbufgds            : std_logic;     

   -- MGT(GTX) reference clock:     
   ----------------------------     
  
   signal mgtRefClk_from_smaMgtRefClkIbufdsGtxe2     : std_logic;   

    -- Frame clock:
    ---------------
    signal txFrameClk_from_txPll                     : std_logic;
    
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
   
   signal errCnter                                   : std_logic_vector(63 downto 0);
   signal wordCnter                                  : std_logic_vector(63 downto 0);
      
   --================--
   
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
      
   --=====================================================================================--  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --=============--
   -- SFP control -- 
   --=============-- 
   
   SFP_TX_DISABLE                                    <= '0';   
   
   --===============--
   -- General reset -- 
   --===============--
   
   genRst: entity work.xlx_k7v7_reset
      generic map (
         CLK_FREQ                                    => 156e6)
      port map (     
         CLK_I                                       => fabricClk_from_userClockIbufgds,
         RESET1_B_I                                  => not CPU_RESET, 
         RESET2_B_I                                  => not generalReset_from_user,
         RESET_O                                     => reset_from_genRst 
      ); 

   --===============--
   -- Clocks scheme -- 
   --===============--   
   
   -- Fabric clock:
   ----------------
   
   -- Comment: USER_CLOCK frequency: 156MHz 
   
   userClockIbufgds: ibufgds
      generic map (
         IBUF_LOW_PWR                                => FALSE,      
         IOSTANDARD                                  => "LVDS_25")
      port map (     
         O                                           => fabricClk_from_userClockIbufgds,   
         I                                           => USER_CLOCK_P,  
         IB                                          => USER_CLOCK_N 
      );
   
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: * The MGT reference clock MUST be provided by an external clock generator.
   --
   --          * The MGT reference clock frequency must be 120MHz for the latency-optimized GBT Bank. 
   
   smaMgtRefClkIbufdsGtxe2: ibufds_gte2
      port map (
         O                                           => mgtRefClk_from_smaMgtRefClkIbufdsGtxe2,
         ODIV2                                       => open,
         CEB                                         => '0',
         I                                           => SMA_MGT_REFCLK_P,
         IB                                          => SMA_MGT_REFCLK_N
      );

    -- Frame clock
    txPll: xlx_k7v7_tx_pll
      port map (
         clk_in1                                  => mgtRefClk_from_smaMgtRefClkIbufdsGtxe2,
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
       XCVRCLK                                                    => mgtRefClk_from_smaMgtRefClkIbufdsGtxe2,
       
       TX_FRAMECLK_O(1)                                              => txFrameClk_from_gbtExmplDsgn,        
       TX_WORDCLK_O(1)                                               => txWordClk_from_gbtExmplDsgn,          
       RX_FRAMECLK_O(1)                                              => rxFrameClk_from_gbtExmplDsgn,         
       RX_WORDCLK_O(1)                                               => rxWordClk_from_gbtExmplDsgn,      
       
       RX_WORDCLK_RDY_O(1)                                           => rxWordClkReady_from_gbtExmplDsgn,
       RX_FRAMECLK_RDY_O(1)                                          => rxFrameClkReady_from_gbtExmplDsgn,
       
       --==============--
       -- Reset        --
       --==============--
       GBTBANK_GENERAL_RESET_I                                    => reset_from_genRst,
       GBTBANK_MANUAL_RESET_TX_I                                  => manualResetTx_from_user,
       GBTBANK_MANUAL_RESET_RX_I                                  => manualResetRx_from_user,
       
       --==============--
       -- Serial lanes --
       --==============--
       GBTBANK_MGT_RX_P(1)                                        => SFP_RX_P,
       GBTBANK_MGT_RX_N(1)                                        => SFP_RX_N,
       GBTBANK_MGT_TX_P(1)                                        => SFP_TX_P,
       GBTBANK_MGT_TX_N(1)                                        => SFP_TX_N,
       
       --==============--
       -- Data             --
       --==============--        
       GBTBANK_GBT_DATA_I(1)                                      => (others => '0'),
       GBTBANK_WB_DATA_I(1)                                       => (others => '0'),
       
       TX_DATA_O(1)                                               => txData_from_gbtExmplDsgn,            
       WB_DATA_O(1)                                               => txExtraDataWidebus_from_gbtExmplDsgn,
       
       GBTBANK_GBT_DATA_O(1)                                      => rxData_from_gbtExmplDsgn,
       GBTBANK_WB_DATA_O(1)                                       => rxExtraDataWidebus_from_gbtExmplDsgn,
       
       --==============--
       -- Reconf.         --
       --==============--
       GBTBANK_MGT_DRP_RST                                        => '0',
       GBTBANK_MGT_DRP_CLK                                        => fabricClk_from_userClockIbufgds,
       
       --==============--
       -- TX ctrl        --
       --==============--
       GBTBANK_TX_ISDATA_SEL_I(1)                                => txIsDataSel_from_user,
       GBTBANK_TEST_PATTERN_SEL_I                                => testPatterSel_from_user, 
       
       --==============--
       -- RX ctrl      --
       --==============--
       GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I(1)                   => resetGbtRxReadyLostFlag_from_user,
       GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I(1)                    => resetDataErrorSeenFlag_from_user,
       
       --==============--
       -- TX Status    --
       --==============--
       GBTBANK_LINK_READY_O(1)                                   => mgtReady_from_gbtExmplDsgn,
       GBTBANK_TX_MATCHFLAG_O                                    => txMatchFlag_from_gbtExmplDsgn,
       
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
       RXDATA_WORD_CNT                                           => wordCnter, 
       RXDATA_ERROR_CNT                                          => errCnter,
       
       --==============--
       -- XCVR ctrl    --
       --==============--
       GBTBANK_LOOPBACK_I                                        => loopBack_from_user, --
       
       GBTBANK_TX_POL(1)                                        => '0',
       GBTBANK_RX_POL(1)                                        => '0'
  ); 
      
   --==============--   
   -- Test control --   
   --==============--
     sysclk_inst: ibufds
         port map (
            I                                           => SYSCLK_P,
            IB                                          => SYSCLK_N,
            O                                           => sysclk
         ); 
    
    
             
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
                probe_in11(0) => '0',
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
               PROBE2 => (others => '0'), --8b10b support removed
               PROBE3(0) => txIsDataSel_from_user);  
      
        rxIla: xlx_k7v7_vivado_debug
            port map (
               CLK => sysclk,
               PROBE0 => rxData_from_gbtExmplDsgn,
               PROBE1 => rxExtraDataWidebus_from_gbtExmplDsgn,
               PROBE2 => (others => '0'), --8b10b support removed
               PROBE3(0) => rxIsData_from_gbtExmplDsgn);   
                        
   
   -- On-board LEDs:                   
   -----------------    
    
   GPIO_LED_0_LS                                     <= latOptGbtBankTx_from_gbtExmplDsgn and latOptGbtBankRx_from_gbtExmplDsgn;          
   GPIO_LED_1_LS                                     <= txFrameClkPllLocked_from_gbtExmplDsgn;
   GPIO_LED_2_LS                                     <= mgtReady_from_gbtExmplDsgn;
   GPIO_LED_3_LS                                     <= gbtRxReady_from_gbtExmplDsgn;
   GPIO_LED_4_LS                                     <= gbtRxReadyLostFlag_from_gbtExmplDsgn;
   GPIO_LED_5_LS                                     <= rxDataErrorSeen_from_gbtExmplDsgn;
   GPIO_LED_6_LS                                     <= rxExtrDataWidebusErSeen_from_gbtExmplDsgn;
   GPIO_LED_7_LS                                     <= '0';
      
   --=====================--     
   -- Latency measurement --     
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If RX DATA comes from another board with a different reference clock, 
   --                   then the TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the
   --                   TX_FRAMECLK/TX_WORDCLK domains.
   
   FMC_HPC_LA02_P                                    <= txFrameClk_from_gbtExmplDsgn;
   FMC_HPC_LA03_P                                    <= txWordClk_from_gbtExmplDsgn;
   --------------------------------------------------   
   FMC_HPC_LA04_P                                    <= rxFrameClk_from_gbtExmplDsgn;  
   FMC_HPC_LA05_P                                    <= rxWordClk_from_gbtExmplDsgn;
    
   --USER_SMA_GPIO_P                                   <= txMatchFlag_from_gbtExmplDsgn;
                                                              
   --USER_SMA_GPIO_N                                   <= rxMatchFlag_from_gbtExmplDsgn;
                                                           
   USER_SMA_GPIO_P                                   <= txFrameClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1' else
                                                        txWordClk_from_gbtExmplDsgn;
                                                           
   USER_SMA_GPIO_N                                   <= rxFrameClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1' else
                                                        rxWordClk_from_gbtExmplDsgn;
       

   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX FLAG with the RX FLAG.
   --
   --          * The COUNTER TEST PATTERN must be used for this test. 
   
   FMC_HPC_LA00_CC_P                                 <= txMatchFlag_from_gbtExmplDsgn;
   FMC_HPC_LA01_CC_P                                 <= rxMatchFlag_from_gbtExmplDsgn;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--