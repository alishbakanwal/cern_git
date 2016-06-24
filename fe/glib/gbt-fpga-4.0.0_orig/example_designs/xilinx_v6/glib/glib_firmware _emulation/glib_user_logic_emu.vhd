--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GLIB - User logic emulation                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         GLIB (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        23/10/2013   3.0       M. Barros Marin   First .vhd module definition_design"  
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

-- IEEE arithmetic library for mathematical operations
use ieee.std_logic_unsigned.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;




-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;
use work.glib_fmc_package_emu.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity glib_user_logic_emu is   
   port (   
      
      --===============--
      -- General reset --
      --===============-- 
      
      RESET_I                                        : in  std_logic;
      
      --==============--      
      -- GLIB control --      
      --==============--
      
      -- CDCE62005:      
      -------------    
      
      USER_CDCE_LOCKED_I                             : in  std_logic;
      
      -- On-board LEDs:    
      -----------------    
   
      USER_V6_LED_O                                  : out std_logic_vector(1 to 2);       
      
      --====================--
      -- GLIB clocks scheme --
      --====================--
      
      -- Fabric clock (40MHz):      
      ------------------------      
    
      XPOINT1_CLK3_P                                 : in  std_logic;
      XPOINT1_CLK3_N                                 : in  std_logic;     

      -- MGT(GTX) reference clock:
      ----------------------------      
      
      CDCE_OUT0_P                                    : in  std_logic;
      CDCE_OUT0_N                                    : in  std_logic;
  
      --=====================--
      -- MGT(GTX) (SFP Quad) --
      --=====================--
      
      -- Comment: Note!! Only SFP1 is used in this example design.
      
      -- MGT(GTX) serial lanes:
      -------------------------
      
      SFP_TX_P                                       : out std_logic_vector(1 to 4);
      SFP_TX_N                                       : out std_logic_vector(1 to 4);
      SFP_RX_P                                       : in  std_logic_vector(1 to 4);
      SFP_RX_N                                       : in  std_logic_vector(1 to 4);
    
      -- SFP control:    
      ---------------    
    
      SFP_MOD_ABS                                    : in  std_logic_vector(1 to 4);      
      SFP_RXLOS                                      : in  std_logic_vector(1 to 4);      
      SFP_TXFAULT                                    : in  std_logic_vector(1 to 4);      
      
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- SMA output:
      --------------
      
      -- Comment: FPGA_CLKOUT_O is connected to a multiplexor that switches between TX_FRAMECLK and TX_WORDCLK.
      
      FPGA_CLKOUT_O                                  : out std_logic;        
      
      -- Pattern match flags:
      -----------------------
      
      -- Comment: AMC_PORT TX_P(14:15) are used for forwarding the pattern match flags.
      
      AMC_PORT_TX_P                                  : out std_logic_vector(1 to 15);        
     
      -- Clock forwarding:
      --------------------  
      
      -- Comment: * FMC1_IO_PIN.la_p(0:1) are used for forwarding TX_FRAMECLK and TX_WORDCLK respectively.
      --      
      --          * FMC1_IO_PIN.la_p(2:3) are used for forwarding RX_FRAMECLK and RX_WORDCLK respectively.
      
      FMC1_IO_PIN                                    : inout fmc_io_pin_type     
   
   );
end glib_user_logic_emu;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of glib_user_logic_emu is
   
   --================================ Signal Declarations ================================--

   --===============--
   -- General reset --
   --===============--
   
   signal generalReset_from_orGate                   : std_logic;         

   --==============--      
   -- GLIB control --      
   --==============--            

   signal userCdceLocked_r                           : std_logic;              

   --====================--                     
   -- GLIB clocks scheme --                     
   --====================--   
   
   -- Fabric clock:
   ----------------
   
   signal fabricClk_from_xpSw1clk3Ibufgds            : std_logic;
   
   -- MGT(GTX) reference clock:     
   ---------------------------- 
   
   signal mgtRefClk_from_cdceOut0IbufdsGtxe1         : std_logic;
	signal txPllRefClk_from_mgtRefClkBufg			     : std_logic;
	
	-- Frameclk:
	signal txframeclk_to_dtcfetop					  : std_logic;
   
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
   signal latOptGbtBankTx_from_dtcfetop          : std_logic;
   signal latOptGbtBankRx_from_dtcfetop          : std_logic;
   signal txFrameClkPllLocked_from_dtcfetop      : std_logic;
   signal mgtReady_from_dtcfetop                 : std_logic; 
   signal rxBitSlipNbr_from_dtcfetop             : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
   signal rxWordClkReady_from_dtcfetop           : std_logic; 
   signal rxFrameClkReady_from_dtcfetop          : std_logic; 
   signal gbtRxReady_from_dtcfetop               : std_logic;    
   signal rxIsData_from_dtcfetop                 : std_logic;        
   signal gbtRxReadyLostFlag_from_dtcfetop       : std_logic; 
   signal rxDataErrorSeen_from_dtcfetop          : std_logic; 
   signal rxExtrDataWidebusErSeen_from_dtcfetop  : std_logic; 
   
   -- Data:
   --------
   
   signal txData_from_dtcfetop                   : std_logic_vector(83 downto 0);
   signal rxData_from_dtcfetop                   : std_logic_vector(83 downto 0);
   --------------------------------------------------       
   signal txExtraDataWidebus_from_dtcfetop       : std_logic_vector(31 downto 0);
   signal rxExtraDataWidebus_from_dtcfetop       : std_logic_vector(31 downto 0); 
   
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
   
   signal txFrameClk_from_dtcfetop               : std_logic;
   signal txWordClk_from_dtcfetop                : std_logic;
   signal rxFrameClk_from_dtcfetop               : std_logic;
   signal rxWordClk_from_dtcfetop                : std_logic;
   --------------------------------------------------                                     
   signal txMatchFlag_from_dtcfetop              : std_logic;
   signal rxMatchFlag_from_dtcfetop              : std_logic;
   
	
	-- Clk divider signals
	----------------------
	signal clk_40                                     : std_logic;
	signal clk_320                                    : std_logic;
	signal clk_40sh                                   : std_logic;
	
	
	-- BRAM signals
	---------------
	signal dina_tx                                    : std_logic_vector(83 downto 0);
	signal dina_tx_0                                  : std_logic_vector(39 downto 0);
	signal dina_tx_1                                  : std_logic_vector(39 downto 0);

	signal doutb_tx_0                                 : std_logic_vector(39 downto 0);
	signal doutb_tx_1                                 : std_logic_vector(39 downto 0);
	
	signal addra_tx                                   : std_logic_vector(2 downto 0);
	signal addrb_tx                                   : std_logic_vector(2 downto 0);
	signal wea_tx                                     : std_logic_vector(0 downto 0);
	
	--
	
	signal dina_rx                                    : std_logic_vector(83 downto 0);
	signal dina_rx_0                                  : std_logic_vector(39 downto 0);
	signal dina_rx_1                                  : std_logic_vector(39 downto 0);
	
	signal doutb_rx_0                                 : std_logic_vector(39 downto 0);
	signal doutb_rx_1                                 : std_logic_vector(39 downto 0);
	
	signal addra_rx                                   : std_logic_vector(2 downto 0);
	signal addrb_rx                                   : std_logic_vector(2 downto 0);
	signal wea_rx                                     : std_logic_vector(0 downto 0);
	
	-- addra_tx equals 7 indicator
	signal flag                                       : std_logic;
	signal flag_1                                     : std_logic;
	signal counter                                    : std_logic_vector(2 downto 0);
	
	-- Counter_64 to indicate start of packet
	-----------------------------------------
	signal pStrt                                      : std_logic;
	
	
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --===============--
   -- General reset -- 
   --===============--
   
   generalReset_from_orGate                          <= RESET_I or generalReset_from_user;   
   
   --===============--
   -- Clocks scheme -- 
   --===============--   

   -- Fabric clock:
   ----------------       
--   
--   xpSw1clk3Ibufgds: IBUFGDS
--      generic map (
--         IBUF_LOW_PWR                                => FALSE,
--         IOSTANDARD                                  => "LVDS_25")
--      port map (                 
--         O                                           => fabricClk_from_xpSw1clk3Ibufgds,   -- Comment: By default this clock is set to 40MHz.
--         I                                           => XPOINT1_CLK3_P,
--         IB                                          => XPOINT1_CLK3_N
--      );
--		
	
	--================--
	-- Removed buffer --
	--================--
	-- Clk assignment
	fabricClk_from_xpSw1clk3Ibufgds                  <= clk_40;
	
	
	
	
      
   -- MGT(GTX) reference clock:
   ----------------------------
   
   -- Comment: Note!! CDCE_OUT0 must be set to 240 MHz for the LATENCY-OPTIMIZED GBT Bank.   
   
   cdceOut0IbufdsGtxe1: ibufds_gtxe1
      port map (
         I                                           => CDCE_OUT0_P,
         IB                                          => CDCE_OUT0_N,
         O                                           => mgtRefClk_from_cdceOut0IbufdsGtxe1,
         ceb                                         => '0'
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
         I                                        => mgtRefClk_from_cdceOut0IbufdsGtxe1
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
			TX_FRAMECLK_O         => txframeclk_to_dtcfetop,
			
			PHASE_SHIFT_I			 => txPllPhaseShift_to_txpll,
			--=========--
			-- Status  --
			--=========--
			PLL_LOCKED_O          => txFrameClkPllLocked_from_dtcfetop
			
		);	
		
   --=========================--
   -- GBT Bank example design --
   --=========================--
   
--   dtcfetop: entity work.xlx_v6_gbt_example_design
--      generic map (
--         GBTBANK_RESET_CLK_FREQ                       => 40e6)
--      port map (
--         -- Resets scheme:      
--         GENERAL_RESET_I                              => generalReset_from_orGate,
--         ---------------------------------------------
--         MANUAL_RESET_TX_I                            => manualResetTx_from_user,
--         MANUAL_RESET_RX_I                            => manualResetRx_from_user,         
--         -- Clocks scheme:                            
--         FABRIC_CLK_I                                 => fabricClk_from_xpSw1clk3Ibufgds,
--         MGT_REFCLK_I                                 => mgtRefClk_from_cdceOut0IbufdsGtxe1,    
--			FRAMECLK_40MHz										  => txframeclk_to_dtcfetop,      
--         -- Serial lanes:                             
--         MGT_TX_P                                     => SFP_TX_P(1),                
--         MGT_TX_N                                     => SFP_TX_N(1),                
--         MGT_RX_P                                     => SFP_RX_P(1),                 
--         MGT_RX_N                                     => SFP_RX_N(1),
--         -- General control:                       
--         LOOPBACK_I                                   => loopBack_from_user,
--         TX_ISDATA_SEL_I                              => txIsDataSel_from_user,                 
--         ---------------------------------------------                          
--         LATOPT_GBTBANK_TX_O                          => latOptGbtBankTx_from_dtcfetop,             
--         LATOPT_GBTBANK_RX_O                          => latOptGbtBankRx_from_dtcfetop, 
--         MGT_READY_O                                  => mgtReady_from_dtcfetop,             
--         RX_BITSLIP_NUMBER_O                          => rxBitSlipNbr_from_dtcfetop,            
--         RX_WORDCLK_READY_O                           => rxWordClkReady_from_dtcfetop,           
--         RX_FRAMECLK_READY_O                          => rxFrameClkReady_from_dtcfetop,            
--         GBT_RX_READY_O                               => gbtRxReady_from_dtcfetop,
--         RX_ISDATA_FLAG_O                             => rxIsData_from_dtcfetop,        
--         -- GBT Bank data:                            
--         TX_DATA_O                                    => txData_from_dtcfetop,            
--         TX_EXTRA_DATA_WIDEBUS_O                      => txExtraDataWidebus_from_dtcfetop,
--         ---------------------------------------------       
--         RX_DATA_O                                    => rxData_from_dtcfetop,           
--         RX_EXTRA_DATA_WIDEBUS_O                      => rxExtraDataWidebus_from_dtcfetop,
--         -- Test control:                    
--         TEST_PATTERN_SEL_I                           => testPatterSel_from_user,        
--         ---------------------------------------------                          
--         RESET_GBTRXREADY_LOST_FLAG_I                 => resetGbtRxReadyLostFlag_from_user,     
--         RESET_DATA_ERRORSEEN_FLAG_I                  => resetDataErrorSeenFlag_from_user,     
--         GBTRXREADY_LOST_FLAG_O                       => gbtRxReadyLostFlag_from_dtcfetop,       
--         RXDATA_ERRORSEEN_FLAG_O                      => rxDataErrorSeen_from_dtcfetop,      
--         RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O         => rxExtrDataWidebusErSeen_from_dtcfetop,
--         -- Latency measurement:                      
--         TX_FRAMECLK_O                                => txFrameClk_from_dtcfetop,        
--         TX_WORDCLK_O                                 => txWordClk_from_dtcfetop,          
--         RX_FRAMECLK_O                                => rxFrameClk_from_dtcfetop,         
--         RX_WORDCLK_O                                 => rxWordClk_from_dtcfetop,          
--         ---------------------------------------------                      
--         TX_MATCHFLAG_O                               => txMatchFlag_from_dtcfetop,          
--         RX_MATCHFLAG_O                               => rxMatchFlag_from_dtcfetop           
--      );                          
      
   --==============--   
   -- Test control --   
   --==============--      
   
   -- Registered CDCE62005 locked input port:
   ------------------------------------------ 

   cdceLockedReg: process(generalReset_from_orGate, fabricClk_from_xpSw1clk3Ibufgds)
   begin
      if generalReset_from_orGate = '1' then
         userCdceLocked_r                            <= '0';
      elsif rising_edge(fabricClk_from_xpSw1clk3Ibufgds) then
         userCdceLocked_r                            <= USER_CDCE_LOCKED_I;
      end if;
   end process;   
   
   -- Signals mapping:
   -------------------
   
   generalReset_from_user                             <= sync_from_vio( 0);          
   clkMuxSel_from_user                                <= sync_from_vio( 1);
   testPatterSel_from_user                            <= sync_from_vio( 3 downto  2); 
   loopBack_from_user                                 <= sync_from_vio( 6 downto  4);
   resetDataErrorSeenFlag_from_user                   <= sync_from_vio( 7);
   resetGbtRxReadyLostFlag_from_user                  <= sync_from_vio( 8);
   txIsDataSel_from_user                              <= sync_from_vio( 9);
   manualResetTx_from_user                            <= sync_from_vio(10);
   manualResetRx_from_user                            <= sync_from_vio(11);
	txPllPhaseShift_to_txpll								   <= sync_from_vio(12);
	
   ---------------------------------------------------       
   async_to_vio( 0)                                   <= rxIsData_from_dtcfetop;
   async_to_vio( 1)                                   <= userCdceLocked_r and txFrameClkPllLocked_from_dtcfetop;
   async_to_vio( 2)                                   <= latOptGbtBankTx_from_dtcfetop;
   async_to_vio( 3)                                   <= mgtReady_from_dtcfetop;
   async_to_vio( 4)                                   <= rxWordClkReady_from_dtcfetop;    
   async_to_vio(10 downto 5)                          <= '0' & rxBitSlipNbr_from_dtcfetop; 
   async_to_vio(11)                                   <= rxFrameClkReady_from_dtcfetop;   
   async_to_vio(12)                                   <= gbtRxReady_from_dtcfetop;          
   async_to_vio(13)                                   <= gbtRxReadyLostFlag_from_dtcfetop;  
   async_to_vio(14)                                   <= rxDataErrorSeen_from_dtcfetop;   
   async_to_vio(15)                                   <= rxExtrDataWidebusErSeen_from_dtcfetop;
   -- async_to_vio(16)                                   <= '0'; --not used anymore
   -- async_to_vio(17)                                   <= latOptGbtBankRx_from_dtcfetop;
	async_to_vio(16)                                   <= txMatchFlag_from_dtcfetop;
	async_to_vio(17)                                   <= rxMatchFlag_from_dtcfetop;
   
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
   
	
       

   -- On-board LEDs:             
   -----------------
   
   -- Comment: * USER_V6_LED_O(1) -> LD5 on GLIB. 
   --          * USER_V6_LED_O(2) -> LD4 on GLIB.       
   
   USER_V6_LED_O(1)                                  <= userCdceLocked_r and txFrameClkPllLocked_from_dtcfetop;          
   USER_V6_LED_O(2)                                  <= mgtReady_from_dtcfetop;
   
   --=====================--
   -- Latency measurement --
   --=====================--
   
   -- Clock forwarding:
   --------------------
   
   -- Clock forwarding:
   --------------------
   
   -- Comment: * The forwarding of the clocks allows to check the phase alignment of the different
   --            clocks using an oscilloscope.
   --
   --          * Note!! If RX DATA comes from another board with a different reference clock, 
   --                   then the TX_FRAMECLK/TX_WORDCLK domains are asynchronous with respect to the
   --                   TX_FRAMECLK/TX_WORDCLK domains. 
   
   FMC1_IO_PIN.la_p(0)                               <= txFrameClk_from_dtcfetop;
   FMC1_IO_PIN.la_p(1)                               <= txWordClk_from_dtcfetop;
   --------------------------------------------------   
   FMC1_IO_PIN.la_p(2)                               <= rxFrameClk_from_dtcfetop;  
   FMC1_IO_PIN.la_p(3)                               <= rxWordClk_from_dtcfetop;     
  
   -- Comment: FPGA_CLKOUT corresponds to SMA1 on GLIB.     
         
   FPGA_CLKOUT_O                                     <= txWordClk_from_dtcfetop when clkMuxSel_from_user = '1'
                                                        else txFrameClk_from_dtcfetop;

   -- Pattern match flags:
   -----------------------
   
   -- Comment: * The latency of the link can be measured using an oscilloscope by comparing 
   --            the TX FLAG with the RX FLAG.
   --
   --          * The COUNTER TEST PATTERN must be used for this test.  
   
	
	
	
   AMC_PORT_TX_P(14)                                 <= txMatchFlag_from_dtcfetop;
   AMC_PORT_TX_P(15)                                 <= rxMatchFlag_from_dtcfetop;
	
	
	
	
	
	--================--
	-- DTC top module -- 
	--================--
	
	-- This module includes the DTC-tester, a clk divider and a GBT
	dtc_top: entity work.dtc_fe_top
      generic map (
         GBTBANK_RESET_CLK_FREQ                       => 40e6)
      port map (
         -- Resets scheme:      
         GENERAL_RESET_I                              => generalReset_from_orGate,
         ---------------------------------------------
         MANUAL_RESET_TX_I                            => manualResetTx_from_user,
         MANUAL_RESET_RX_I                            => manualResetRx_from_user,         
         -- Clocks scheme:                            
         FABRIC_CLK_I                                 => fabricClk_from_xpSw1clk3Ibufgds,
         MGT_REFCLK_I                                 => mgtRefClk_from_cdceOut0IbufdsGtxe1,    
			FRAMECLK_40MHz										  => txframeclk_to_dtcfetop,      
         -- Serial lanes:                             
         MGT_TX_P                                     => SFP_TX_P(1),                
         MGT_TX_N                                     => SFP_TX_N(1),                
         MGT_RX_P                                     => SFP_RX_P(1),                 
         MGT_RX_N                                     => SFP_RX_N(1),
         -- General control:                       
         LOOPBACK_I                                   => loopBack_from_user,
         TX_ISDATA_SEL_I                              => txIsDataSel_from_user,                 
         ---------------------------------------------                          
         LATOPT_GBTBANK_TX_O                          => latOptGbtBankTx_from_dtcfetop,             
         LATOPT_GBTBANK_RX_O                          => latOptGbtBankRx_from_dtcfetop, 
         MGT_READY_O                                  => mgtReady_from_dtcfetop,             
         RX_BITSLIP_NUMBER_O                          => rxBitSlipNbr_from_dtcfetop,            
         RX_WORDCLK_READY_O                           => rxWordClkReady_from_dtcfetop,           
         RX_FRAMECLK_READY_O                          => rxFrameClkReady_from_dtcfetop,            
         GBT_RX_READY_O                               => gbtRxReady_from_dtcfetop,
         RX_ISDATA_FLAG_O                             => rxIsData_from_dtcfetop,        
         -- GBT Bank data:                            
         TX_DATA_O                                    => txData_from_dtcfetop,            
         TX_EXTRA_DATA_WIDEBUS_O                      => txExtraDataWidebus_from_dtcfetop,
         ---------------------------------------------       
         RX_DATA_O                                    => rxData_from_dtcfetop,           
         RX_EXTRA_DATA_WIDEBUS_O                      => rxExtraDataWidebus_from_dtcfetop,
         -- Test control:                    
         TEST_PATTERN_SEL_I                           => testPatterSel_from_user,        
         ---------------------------------------------                          
         RESET_GBTRXREADY_LOST_FLAG_I                 => resetGbtRxReadyLostFlag_from_user,     
         RESET_DATA_ERRORSEEN_FLAG_I                  => resetDataErrorSeenFlag_from_user,     
         GBTRXREADY_LOST_FLAG_O                       => gbtRxReadyLostFlag_from_dtcfetop,       
         RXDATA_ERRORSEEN_FLAG_O                      => rxDataErrorSeen_from_dtcfetop,      
         RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O         => rxExtrDataWidebusErSeen_from_dtcfetop,
         -- Latency measurement:                      
         TX_FRAMECLK_O                                => txFrameClk_from_dtcfetop,        
         TX_WORDCLK_O                                 => txWordClk_from_dtcfetop,          
         RX_FRAMECLK_O                                => rxFrameClk_from_dtcfetop,         
         RX_WORDCLK_O                                 => rxWordClk_from_dtcfetop,          
         ---------------------------------------------                      
         TX_MATCHFLAG_O                               => txMatchFlag_from_dtcfetop,          
         RX_MATCHFLAG_O                               => rxMatchFlag_from_dtcfetop,                            

			-- Clks to come from the GLIB
			-----------------------------
			CLK40_I                                       => clk_40,
			CLK320_I                                      => clk_320,
			CLK40SH_I                                     => clk_40sh,
			
			-- Counter_64 to indicate start of packet
		   -----------------------------------------
		   PCKTSTRT                                      => pStrt
   );
	
	
	
	
	--===================--
	--   CLOCK DIVIDER   --
	--===================--
	
	-- These come from the glib input clk
	clkDiv : entity work.clkDiv
	  port map(
		  -- Clock in ports
		  CLK_IN1_P                                      => XPOINT1_CLK3_P,
		  CLK_IN1_N                                      => XPOINT1_CLK3_N,
	 
	     -- Clock out ports
		  CLK_OUT1                                       => clk_40,
		  CLK_OUT2                                       => clk_320,
		  CLK_OUT3                                       => clk_40sh
		);
		
		

	--==========================================--
	-- Store a batch of Tx'ed and Rx'ed packets --
	--==========================================--
	
	-- Address increment logic + read and write setup
	-------------------------------------------------
	-- Tx
	
	process(txFrameClk_from_dtcfetop)
		begin
			if(rising_edge(txFrameClk_from_dtcfetop)) then
				-- addra_tx                                   <= addra_tx + '1';
				-- dina_tx                                    <= txData_from_dtcfetop(82 downto 0) & txData_from_dtcfetop(83);
				
				-- Write to BRAM @40MHz
				wea_tx                                      <= "1";
				addra_tx                                    <= addra_tx + '1';
				
				if pStrt = '1' then
					-- Read from BRAM when full
					-- Read @320MHz
					-- Stays this way for 25ns
					
					addra_tx                                 <= "000";
				end if;
			end if;		
	end process;
	
	
	-- Rx
	process(rxFrameClk_from_dtcfetop)
		begin
			if(rising_edge(rxFrameClk_from_dtcfetop)) then
				addra_rx                                    <= addra_rx + '1';
				--dina_rx                                    <= rxData_from_dtcfetop;
				
				-- Write to BRAM @40MHz
				wea_rx                                      <= "1";
				
				if addra_rx = "111" then
					-- Read from BRAM when full
					-- Read @320MHz
					-- Stays this way for 25ns
					wea_rx                                    <= "1"; 
				end if;
			end if;		
	end process;
	
	
	-- addrb increment logic: control
	process (txFrameClk_from_dtcfetop)
		begin
			-- flag indicates when addra_tx = 7
			
			if(rising_edge(txFrameClk_from_dtcfetop)) then
			-- addra_tx is going to be 7 for 25 ns
			-- addrb would have incremented 8x during these 25ns
				counter                                     <= counter + '1';
						
				if addra_tx = "111" then
					flag                                     <= '1';
					
					else
						flag                                  <= '0';
				end if;
			end if;
	end process;

	
	
	-- addrb increment logic: increment
	process(clk_320)
		begin
			if(rising_edge(clk_320)) then
				if flag = '1' then
						addrb_tx                              <= addrb_tx + '1';
						addrb_rx                              <= addrb_rx + '1';
						
						else
							addrb_tx                           <= "000";
							addrb_rx                           <= "000";
				end if;				
			end if;
	end process;
	
	
--	process(addrb_rx)
--		begin
--		-- To synchronise according to BRAM diagram obtained from ChipScope
--			if addrb_rx = "000" then
--				addrb_tx                                    <= "011";
--			end if;
--	end process
	
	
	-- BRAM instantiation
	---------------------
	
	-- Tx
	-----
	
	-- CIC 0
	txbram_0 : entity work.Txbram
	  PORT MAP (
		 clka                                            => txFrameClk_from_dtcfetop,  -- 40MHz clk
		 wea                                             => wea_tx,
		 addra                                           => addra_tx,
		 dina                                            => dina_tx_0,
		 -- douta                                        => douta_tx_0,
		 clkb                                            => clk_320,  -- 320MHz clk
		 addrb                                           => addrb_tx,
		 doutb                                           => doutb_tx_0
	  );
	  
	  
	-- CIC 1  
	txbram_1 : entity work.Txbram
	  PORT MAP (
		 clka                                            => txFrameClk_from_dtcfetop,  -- 40MHz clk
		 wea                                             => wea_tx,
		 addra                                           => addra_tx,
		 dina                                            => dina_tx_1,
		 -- douta                                        => douta_tx_1,
		 clkb                                            => clk_320,   -- 320MHz clk
		 addrb                                           => addrb_tx,
		 doutb                                           => doutb_tx_1
	  );
	  
	  
	
	-- Rx
	-----
	
	-- CIC 0
	rxbram_0 : entity work.Rxbram
	  PORT MAP (
		 clka                                            => rxFrameClk_from_dtcfetop,  -- 40MHz clk
		 wea                                             => wea_rx,
		 addra                                           => addra_rx,
		 dina                                            => dina_rx_0,
		 -- douta                                        => douta_rx_0,
		 clkb                                            => clk_320,  -- 320MHz clk
		 addrb                                           => addrb_rx,
		 doutb                                           => doutb_rx_0
	  );
	 
	 
	-- CIC 1 
	rxbram_1 : entity work.Rxbram
	  PORT MAP (
		 clka                                            => rxFrameClk_from_dtcfetop,  -- 40MHz clk
		 wea                                             => wea_rx,
		 addra                                           => addra_rx,
		 dina                                            => dina_rx_1,
		 -- douta                                       => douta_rx_1,
		 clkb                                            => clk_320,  -- 320MHz clk
		 addrb                                           => addrb_rx,
		 doutb                                           => doutb_rx_1
	  );
		
		
	-- BRAM input data assignment
	-----------------------------	
	dina_tx                                             <= txData_from_dtcfetop(82 downto 0) & txData_from_dtcfetop(83);
	dina_rx                                             <= rxData_from_dtcfetop(82 downto 0) & rxData_from_dtcfetop(83);

	dina_tx_0                                           <= dina_tx(39 downto 0);
	dina_tx_1                                           <= dina_tx(79 downto 40);
	
	dina_rx_0                                           <= dina_rx(39 downto 0);
	dina_rx_1                                           <= dina_rx(79 downto 40);
	
	
	--===================---
	-- ChipScope moduless --
	--====================--
	
	-- ICON
	-------
   icon: entity work.xlx_v6_chipscope_icon    
      port map (     
         CONTROL0                                     => vioControl_from_icon,
         CONTROL1                                     => txIlaControl_from_icon,
         CONTROL2                                     => rxIlaControl_from_icon
      );    
            
	
	-- VIO
	------
   vio: entity work.xlx_v6_chipscope_vio            
      port map (           
         CONTROL                                      => vioControl_from_icon,
         CLK                                          => txFrameClk_from_dtcfetop,
         ASYNC_IN                                     => async_to_vio,
         SYNC_OUT                                     => sync_from_vio
      );       
         
	
	-- ILA
	------
	
	-- Changed core structure to show Tx and Rx data in same window
   txrxIla: entity work.dtcfetop_chipscope_ila          
      port map (           
         CONTROL                                     => txIlaControl_from_icon,
         -- CLK                                      => txFrameClk_from_dtcfetop,
			CLK                                         => clk_320,
         TRIG0                                       => txData_from_dtcfetop,
         -- TRIG1                                    => txExtraDataWidebus_from_dtcfetop,
			TRIG1                                       => rxData_from_dtcfetop,
         TRIG2(0)                                    => txIsDataSel_from_user,
			TRIG3                                       => dina_tx_0,
			TRIG4                                       => dina_tx_1,
			TRIG5                                       => dina_rx_0,
			TRIG6                                       => dina_rx_1,
			TRIG7                                       => doutb_tx_0,
			TRIG8                                       => doutb_tx_1,
			TRIG9                                       => doutb_rx_0,
			TRIG10                                      => doutb_rx_1,
			TRIG11                                      => addra_tx & pStrt & addrb_tx & counter
			-- counter was originally addrb_rx
      );          
               
					
   rxIla: entity work.xlx_v6_chipscope_ila          
      port map (           
         CONTROL                                     => rxIlaControl_from_icon,
         CLK                                         => rxFrameClk_from_dtcfetop,
         TRIG0                                       => rxData_from_dtcfetop,
         TRIG1                                       => rxExtraDataWidebus_from_dtcfetop,
         TRIG2(0)                                    => rxIsData_from_dtcfetop
      );
		
		
		
		
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--