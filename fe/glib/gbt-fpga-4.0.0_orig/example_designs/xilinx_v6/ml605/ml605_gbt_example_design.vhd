--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           ML605 - GBT Bank example design                                         
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         ML605 (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/10/2013   3.0       M. Barros Marin   First .vhd module definition           
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

entity ml605_gbt_example_design is   
   port (   
      
      --===============--     
      -- General reset --     
      --===============--     

      CPU_RESET                                      : in  std_logic;    
      
      --===============--
      -- Clocks scheme --
      --===============-- 
      
      -- Fabric clock:
      ----------------
      
      SGMIICLK_QO_P                                  : in  std_logic;
      SGMIICLK_QO_N                                  : in  std_logic;   
      
      -- MGT(GTX) reference clock:
      ----------------------------
      
      -- Comment: * The MGT reference clock MUST be povided by an external clock generator.
      --
      --          * The MGT reference clock frequency must be 240MHz for the latency-optimized GBT Bank.      
      
      SMA_REFCLK_P                                   : in  std_logic;
      SMA_REFCLK_N                                   : in  std_logic;          
      
      --==============--
      -- Serial lanes --
      --==============--                 
      
      SFP_TX_P                                       : out std_logic;
      SFP_TX_N                                       : out std_logic;
      SFP_RX_P                                       : in  std_logic;
      SFP_RX_N                                       : in  std_logic;                  
            
      --===============--           
      -- On-board LEDs --           
      --===============--     
      
      GPIO_LED_0                                     : out std_logic;
      GPIO_LED_1                                     : out std_logic;
      GPIO_LED_2                                     : out std_logic;
      GPIO_LED_3                                     : out std_logic;
      GPIO_LED_4                                     : out std_logic;
      GPIO_LED_5                                     : out std_logic;
      GPIO_LED_6                                     : out std_logic;
      GPIO_LED_7                                     : out std_logic;      
            
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: USER_SMA_GPIO_P is connected to a multiplexor that switches between TX_FRAMECLK and TX_WORDCLK.
      
      USER_SMA_GPIO_P                                : out std_logic;        
      USER_SMA_GPIO_N										  : out std_logic;
		
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
end ml605_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of ml605_gbt_example_design is    
   
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
   
   signal fabricClk_from_sgmiiclkQoGtxe1             : std_logic;   
   signal fabricClk_from_sgmiiclkQoBufg              : std_logic;

   -- MGT(GTX) reference clock:     
   ----------------------------     

   signal mgtRefClk_from_smaRefClkIbufdsGtxe1        : std_logic;     
	signal txPllRefClk_from_mgtRefClkBufg			     : std_logic;
	
	-- Frameclk:
	signal txframeclk_to_gbtExmplDsgn					  : std_logic;
	
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   -- Control:
   -----------
   
	signal txPllPhaseShift_to_txpll						  : std_logic;
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
   signal rxWordClkAligned_from_gbtExmplDsgn         : std_logic; 
   signal rxFrameClkAligned_from_gbtExmplDsgn        : std_logic; 
   signal gbtRxReady_from_gbtExmplDsgn               : std_logic;    
   signal rxIsData_from_gbtExmplDsgn                 : std_logic;        
   signal gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic; 
   signal rxDataErrorSeen_from_gbtExmplDsgn          : std_logic; 
   signal rxExtrDataWidebusErSeen_from_gbtExmplDsgn  : std_logic; 
   signal gbtTxPhAligned_from_gbtExmplDsgn			  : std_logic;
	signal gbtTxPhAlignedComputed_from_gbtExmplDsgn   : std_logic;
	
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
   signal sync_from_vio                              : std_logic_vector(12 downto 0);
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
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --===============--     
   -- General reset --     
   --===============--     

   rst: entity work.xlx_v6_reset    
      generic map (     
         CLK_FREQ                                    => 125e6)
      port map (     
         CLK_I                                       => fabricClk_from_sgmiiclkQoBufg,
         RESET1_B_I                                  => not CPU_RESET, 
         RESET2_B_I                                  => not generalReset_from_user,
         RESET_O                                     => reset_from_genRst 
      );  

   --===============--
   -- Clocks scheme -- 
   --===============--   
   
   -- Fabric clock:
   ----------------
   
   -- Comment: SGMIICLK_QO frequency: 125MHz
   
   sgmiiclkQoGtxe1: ibufds_gtxe1
      port map (
         I                                           => SGMIICLK_QO_P,
         IB                                          => SGMIICLK_QO_N,
         O                                           => fabricClk_from_sgmiiclkQoGtxe1,
         CEB                                         => '0'
      );             

   sgmiiclkQoBufg: BUFG    
      port map (     
         O                                           => fabricClk_from_sgmiiclkQoBufg, 
         I                                           => fabricClk_from_sgmiiclkQoGtxe1 
      );
      
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: * The MGT reference clock MUST be provded by an external clock generator.
   --
   --          * The MGT reference clock frequency must be 240MHz for the latency-optimized GBT Bank. 
   
   smaRefClkIbufdsGtxe1: ibufds_gtxe1
      port map (
         I                                           => SMA_REFCLK_P,
         IB                                          => SMA_REFCLK_N,
         O                                           => mgtRefClk_from_smaRefClkIbufdsGtxe1,
         CEB                                         => '0'
      );          

	-- Frame Clock:
	---------------
	
   -- Comment: * TX_FRAMECLK frequency: 40MHz
   --
   --          * Note!! The 40MHz output of the "txPll" is shifter 90deg in order to sample correctly when using the latency-optimized GBT Bank.
   
   -- Comment: In this example design, MGT_REFCLK_I is used to generate the reference clock of the txPll. If available, the TTC CLK could be used instead.    
   
   mgtRefClkBufg: bufg
      port map (
         O                                        => txPllRefClk_from_mgtRefClkBufg, 
         I                                        => mgtRefClk_from_smaRefClkIbufdsGtxe1
      );  
	
	txpll: entity work.gbt_tx_frameclk_phalgnr
		Generic map(
			SHIFT_CNTER				=> 10 --About 178.5 ps per shift
		)
		port map( 
			
			--=======--
			-- Reset --
			--=======--
			RESET_I               => '0',
			
			--===============--
			-- Clocks scheme --
			--===============--
			MGT_REFCLK            => txPllRefClk_from_mgtRefClkBufg,
			TX_FRAMECLK_O         => txframeclk_to_gbtExmplDsgn,
			
			PHASE_SHIFT_I			 => txPllPhaseShift_to_txpll,
			--=========--
			-- Status  --
			--=========--
			PLL_LOCKED_O          => txFrameClkPllLocked_from_gbtExmplDsgn
			
		);	
		
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
   gbtExmplDsgn: entity work.xlx_v6_gbt_example_design
      generic map (
         GBTBANK_RESET_CLK_FREQ                      => 125e6)
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                             => reset_from_genRst,
         --------------------------------------------
         MANUAL_RESET_TX_I                           => manualResetTx_from_user,
         MANUAL_RESET_RX_I                           => manualResetRx_from_user,         
         -- Clocks scheme:                           
         FABRIC_CLK_I                                => fabricClk_from_sgmiiclkQoBufg,
         MGT_REFCLK_I                                => mgtRefClk_from_smaRefClkIbufdsGtxe1,     
			FRAMECLK_40MHz										  => txframeclk_to_gbtExmplDsgn,
			
         -- Serial lanes:                            
         MGT_TX_P                                    => SFP_TX_P,                
         MGT_TX_N                                    => SFP_TX_N,                
         MGT_RX_P                                    => SFP_RX_P,                 
         MGT_RX_N                                    => SFP_RX_N,
         -- General control:                       
         LOOPBACK_I                                  => loopBack_from_user,
         TX_ISDATA_SEL_I                             => txIsDataSel_from_user,                 
         --------------------------------------------                          
         LATOPT_GBTBANK_TX_O                         => latOptGbtBankTx_from_gbtExmplDsgn,             
         LATOPT_GBTBANK_RX_O                         => latOptGbtBankRx_from_gbtExmplDsgn,   
         MGT_READY_O                                 => mgtReady_from_gbtExmplDsgn,             
         RX_BITSLIP_NUMBER_O                         => rxBitSlipNbr_from_gbtExmplDsgn,            
         RX_WORDCLK_READY_O                          => rxWordClkAligned_from_gbtExmplDsgn,           
         RX_FRAMECLK_READY_O                         => rxFrameClkAligned_from_gbtExmplDsgn,            
         GBT_RX_READY_O                              => gbtRxReady_from_gbtExmplDsgn,
         RX_ISDATA_FLAG_O                            => rxIsData_from_gbtExmplDsgn,        
         -- GBT Bank data:                           
         TX_DATA_O                                   => txData_from_gbtExmplDsgn,            
         TX_EXTRA_DATA_WIDEBUS_O                     => txExtraDataWidebus_from_gbtExmplDsgn,
			TX_GEARBOX_ALIGNED								  => gbtTxPhAligned_from_gbtExmplDsgn,
			TX_GEARBOX_ALIGNEMENT_COMPUTED_O				  => gbtTxPhAlignedComputed_from_gbtExmplDsgn,
         --------------------------------------------       
         RX_DATA_O                                   => rxData_from_gbtExmplDsgn,           
         RX_EXTRA_DATA_WIDEBUS_O                     => rxExtraDataWidebus_from_gbtExmplDsgn,
         -- Test control:                    
         TEST_PATTERN_SEL_I                          => testPatterSel_from_user,        
         --------------------------------------------                          
         RESET_GBTRXREADY_LOST_FLAG_I                => resetGbtRxReadyLostFlag_from_user,     
         RESET_DATA_ERRORSEEN_FLAG_I                 => resetDataErrorSeenFlag_from_user,     
         GBTRXREADY_LOST_FLAG_O                      => gbtRxReadyLostFlag_from_gbtExmplDsgn,       
         RXDATA_ERRORSEEN_FLAG_O                     => rxDataErrorSeen_from_gbtExmplDsgn,      
         RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O        => rxExtrDataWidebusErSeen_from_gbtExmplDsgn,
         -- Latency measurement:                     
         TX_FRAMECLK_O                               => txFrameClk_from_gbtExmplDsgn,        
         TX_WORDCLK_O                                => txWordClk_from_gbtExmplDsgn,          
         RX_FRAMECLK_O                               => rxFrameClk_from_gbtExmplDsgn,         
         RX_WORDCLK_O                                => rxWordClk_from_gbtExmplDsgn,          
         --------------------------------------------                      
         TX_MATCHFLAG_O                              => txMatchFlag_from_gbtExmplDsgn,          
         RX_MATCHFLAG_O                              => rxMatchFlag_from_gbtExmplDsgn           
      );                                             
   
   --==============--   
   -- Test control --   
   --==============--
   
   -- Signals mapping:
   -------------------
   
   generalReset_from_user                            <= sync_from_vio( 0);          
   clkMuxSel_from_user                               <= sync_from_vio( 1);
   testPatterSel_from_user                           <= sync_from_vio( 3 downto  2); 
   loopBack_from_user                                <= sync_from_vio( 6 downto  4);
   resetDataErrorSeenFlag_from_user                  <= sync_from_vio( 7);
   resetGbtRxReadyLostFlag_from_user                 <= sync_from_vio( 8);
   txIsDataSel_from_user                             <= sync_from_vio( 9);
   manualResetTx_from_user                           <= sync_from_vio(10);
   manualResetRx_from_user                           <= sync_from_vio(11);
	txPllPhaseShift_to_txpll								  <= sync_from_vio(12);
	
   --------------------------------------------------       
   async_to_vio( 0)                                  <= rxIsData_from_gbtExmplDsgn;
   async_to_vio( 1)                                  <= txFrameClkPllLocked_from_gbtExmplDsgn;
   async_to_vio( 2)                                  <= latOptGbtBankTx_from_gbtExmplDsgn;
   async_to_vio( 3)                                  <= mgtReady_from_gbtExmplDsgn;
   async_to_vio( 4)                                  <= rxWordClkAligned_from_gbtExmplDsgn;    
   async_to_vio(10 downto 5)                         <= '0' & rxBitSlipNbr_from_gbtExmplDsgn; 
   async_to_vio(11)                                  <= rxFrameClkAligned_from_gbtExmplDsgn;   
   async_to_vio(12)                                  <= gbtRxReady_from_gbtExmplDsgn;          
   async_to_vio(13)                                  <= gbtRxReadyLostFlag_from_gbtExmplDsgn;  
   async_to_vio(14)                                  <= rxDataErrorSeen_from_gbtExmplDsgn;   
   async_to_vio(15)                                  <= rxExtrDataWidebusErSeen_from_gbtExmplDsgn;
   async_to_vio(16)                                  <= gbtTxPhAligned_from_gbtExmplDsgn;
   async_to_vio(17)                                  <= latOptGbtBankRx_from_gbtExmplDsgn;
   
   -- Chipscope:
   -------------   
   
   -- Comment: * Chipscope is used to control the example design as well as for transmitted and received data analysis.
   --
   --          * Note!! TX and RX DATA do not share the same ILA module (txIla and rxIla respectively) 
   --            because when receiving RX DATA from another board with a different reference clock, the 
   --            TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the RX_FRAMECLK/RX_WORDCLK domains.        
   --
   --          * After FPGA configuration using Chipscope, open the project "ml605_gbt_example_design.cpj" 
   --            that can be found in:
   --            "..\example_designs\xilix_v6\ml605\chipscope_project\".  
   
   icon: entity work.xlx_v6_chipscope_icon    
      port map (     
         CONTROL0                                    => vioControl_from_icon,
         CONTROL1                                    => txIlaControl_from_icon,
         CONTROL2                                    => rxIlaControl_from_icon
      );    
            
   vio: entity work.xlx_v6_chipscope_vio            
      port map (           
         CONTROL                                     => vioControl_from_icon,
         CLK                                         => txFrameClk_from_gbtExmplDsgn,
         ASYNC_IN                                    => async_to_vio,
         SYNC_OUT                                    => sync_from_vio
      );       
         
   txIla: entity work.xlx_v6_chipscope_ila          
      port map (           
         CONTROL                                     => txIlaControl_from_icon,
         CLK                                         => txFrameClk_from_gbtExmplDsgn,
         TRIG0                                       => txData_from_gbtExmplDsgn,
         TRIG1                                       => txExtraDataWidebus_from_gbtExmplDsgn,
         TRIG2(0)                                    => txIsDataSel_from_user
      );          
               
   rxIla: entity work.xlx_v6_chipscope_ila          
      port map (           
         CONTROL                                     => rxIlaControl_from_icon,
         CLK                                         => rxFrameClk_from_gbtExmplDsgn,
         TRIG0                                       => rxData_from_gbtExmplDsgn,
         TRIG1                                       => rxExtraDataWidebus_from_gbtExmplDsgn,
         TRIG2(0)                                    => rxIsData_from_gbtExmplDsgn
      );       
      
   -- On-board LEDs:                   
   -----------------    
         
   GPIO_LED_0                                        <= latOptGbtBankTx_from_gbtExmplDsgn and latOptGbtBankRx_from_gbtExmplDsgn;   
   GPIO_LED_1                                        <= txFrameClkPllLocked_from_gbtExmplDsgn;
   GPIO_LED_2                                        <= mgtReady_from_gbtExmplDsgn;
   GPIO_LED_3                                        <= gbtRxReady_from_gbtExmplDsgn;
   GPIO_LED_4                                        <= gbtRxReadyLostFlag_from_gbtExmplDsgn;
   GPIO_LED_5                                        <= rxDataErrorSeen_from_gbtExmplDsgn;
   GPIO_LED_6                                        <= rxExtrDataWidebusErSeen_from_gbtExmplDsgn;
   GPIO_LED_7                                        <= gbtTxPhAligned_from_gbtExmplDsgn;
      
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
               
   USER_SMA_GPIO_P                                   <= txWordClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1'
                                                        else rxWordClk_from_gbtExmplDsgn;
	
   USER_SMA_GPIO_N                                   <= txFrameClk_from_gbtExmplDsgn when clkMuxSel_from_user = '1'
                                                        else rxFrameClk_from_gbtExmplDsgn;
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