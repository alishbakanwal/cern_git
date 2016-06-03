--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Stratix V - Multi Gigabit Transceivers latency-optimized
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Altera Stratix V                                                      
-- Tool version:          Quartus II 14.0                                                              
--                                                                                                   
-- Revision:              3.6                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        27/03/2016   3.0       J. Mendez         First .vhd module definition       
--
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

-- Altera devices library:
library altera; 
library altera_mf;
library lpm;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library gx_latopt_x6;
library gx_latopt_x5;
library gx_latopt_x4;
library gx_latopt_x3;
library gx_latopt_x2;
library gx_latopt_x1;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity mgt_latopt is
   generic (
      GBT_BANK_ID                                  : integer := 1;
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME
   ); 
   port (      

      --===============--  
      -- Clocks scheme --  
      --===============--  

      MGT_CLKS_I                                   : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                   : out gbtBankMgtClks_o_R;        

      --=========--  
      -- MGT I/O --  
      --=========--  

      MGT_I                                        : in  mgt_i_R;
      MGT_O                                        : out mgt_o_R;

      --=============-- 
      -- GBT Control -- 
      --=============-- 
      
		-- Phase monitoring:
		--------------------
		
		PHASE_ALIGNED_I										: in  std_logic;
		PHASE_COMPUTING_DONE_I								: in  std_logic;
		
      GBTTX_MGTTX_RDY_O                            : out std_logic_vector       (1 to NUM_LINKS);
      
      GBTRX_MGTRX_RDY_O                            : out std_logic_vector       (1 to NUM_LINKS);
      GBTRX_RXWORDCLK_READY_O                      : out std_logic_vector       (1 to NUM_LINKS);
      GBTRX_HEADER_LOCKED_I                        : in  std_logic_vector       (1 to NUM_LINKS);
      GBTRX_BITSLIP_NBR_I                          : in  rxBitSlipNbr_mxnbit_A  (1 to NUM_LINKS);      
      
		--========--
		-- Clocks --
		--========--
		TX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);
      RX_WORDCLK_O										: out std_logic_vector      (1 to NUM_LINKS);
            
      --=======-- 
      -- Words -- 
      --=======-- 
 
      GBTTX_WORD_I                                 : in  word_mxnbit_A          (1 to NUM_LINKS);     
      GBTRX_WORD_O                                 : out word_mxnbit_A          (1 to NUM_LINKS) 
   
   );
end mgt_latopt;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of mgt_latopt is 

   --================================ Signal Declarations ================================--
   
   --======================--
   -- GX reset controllers --
   --======================--  
   
   signal txAnalogReset_from_gxRstCtrl             : std_logic_vector           (1 to NUM_LINKS);
   signal txDigitalReset_from_gxRstCtrl            : std_logic_vector           (1 to NUM_LINKS);
   signal txCalBusy_to_gxRstCtrl							: std_logic_vector           (1 to NUM_LINKS);
	signal txReady_from_gxRstCtrl                   : std_logic_vector           (1 to NUM_LINKS);
   ------------------------------------------------   
   signal rxAnalogreset_from_gxRstCtrl             : std_logic_vector           (1 to NUM_LINKS);
   signal rxDigitalreset_from_gxRstCtrl            : std_logic_vector           (1 to NUM_LINKS);
   signal rxCalBusy_to_gxRstCtrl							: std_logic_vector           (1 to NUM_LINKS);
	signal rxReady_from_gxRstCtrl                   : std_logic_vector           (1 to NUM_LINKS);

   --=======================--
   -- TX_WORDCLK monitoring --
   --=======================--   
	signal reset_mgt_tx										: std_logic_vector           (1 to NUM_LINKS);
	
   --====================--
   -- RX phase alignment --
   --====================--
   
   signal nbr_to_rxBitSlipControl                  : rxBitSlipNbr_mxnbit_A      (1 to NUM_LINKS);
   signal run_to_rxBitSlipControl                  : std_logic_vector           (1 to NUM_LINKS);
   signal rxBitSlip_from_rxBitSlipControl          : std_logic_vector           (1 to NUM_LINKS);
   signal rxBitSlip_to_gxLatOpt                    : std_logic_vector           (1 to NUM_LINKS);   
   signal resetGxRx_from_rxBitSlipControl          : std_logic_vector           (1 to NUM_LINKS);   
   signal done_from_rxBitSlipControl               : std_logic_vector           (1 to NUM_LINKS);  
   
   --=========--
   -- ATX PLL --
   --=========-- 
	signal tx_bonding_clocks								: std_logic_vector			  (5 downto 0);
	signal ATXPLLLocked										: std_logic;
	
   --================================================--
   -- Multi-Gigabit Transceivers (latency-optimized) --
   --================================================--      

   signal rxIsLockedToData_from_gxLatOpt           : std_logic_vector           (1 to NUM_LINKS);   
   signal txCalBusy_from_gxLatOpt                  : std_logic_vector           (1 to NUM_LINKS);
   signal rxCalBusy_from_gxLatOpt                  : std_logic_vector           (1 to NUM_LINKS); 
   
	signal reconfToXCVR										: std_logic_vector			  ((NUM_LINKS*70)-1 downto 0);
	signal XCVRToReconf										: std_logic_vector			  ((NUM_LINKS*46)-1 downto 0);
   
	signal tx_usrclk											: std_logic_vector			  ((NUM_LINKS-1) downto 0);
	signal rx_usrclk											: std_logic_vector			  ((NUM_LINKS-1) downto 0);
	--=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================-- 
   
   --=============--
   -- Assignments --
   --=============--
   
   commonAssign_gen: for i in 1 to NUM_LINKS generate
   
      MGT_O.mgtLink(i).txCal_busy                  <= txCalBusy_from_gxLatOpt(i);
      MGT_O.mgtLink(i).rxCal_busy                  <= rxCalBusy_from_gxLatOpt(i);
		
      MGT_O.mgtLink(i).tx_ready                    <= txReady_from_gxRstCtrl(i);
																		
      MGT_O.mgtLink(i).rx_ready                    <= rxReady_from_gxRstCtrl(i);
		
      GBTTX_MGTTX_RDY_O(i)                         <= txReady_from_gxRstCtrl(i);         
      GBTRX_MGTRX_RDY_O(i)                         <= rxReady_from_gxRstCtrl(i);
		
      MGT_O.mgtLink(i).rxIsLocked_toData           <= rxIsLockedToData_from_gxLatOpt(i);		
		
      MGT_O.mgtLink(i).ready                       <= txReady_from_gxRstCtrl(i) and rxReady_from_gxRstCtrl(i);
   
   end generate;
   
   --======================--
   -- GX reset controllers --
   --======================--
   
   gxRstCtrl_gen: for i in 1 to NUM_LINKS generate
   
      gxRstCtrl: entity work.alt_sv_mgt_resetctrl       
         port map (
            CLK_I                                  => MGT_CLKS_I.mgtRefClk, 
            ---------------------------------------            
            TX_RESET_I                             => MGT_I.mgtLink(i).tx_reset,    
            RX_RESET_I                             => MGT_I.mgtLink(i).rx_reset or resetGxRx_from_rxBitSlipControl(i),    
            ---------------------------------------             
            TX_ANALOGRESET_O                       => txAnalogReset_from_gxRstCtrl(i),
            TX_DIGITALRESET_O                      => txDigitalReset_from_gxRstCtrl(i),                  
            TX_READY_O                             => txReady_from_gxRstCtrl(i),                         
            PLL_LOCKED_I                           => ATXPLLLocked,                       
            TX_CAL_BUSY_I                          => txCalBusy_from_gxLatOpt(i),                          
            ---------------------------------------             
            RX_ANALOGRESET_O                       => rxAnalogreset_from_gxRstCtrl(i),
            RX_DIGITALRESET_O                      => rxDigitalreset_from_gxRstCtrl(i),                          
            RX_READY_O                             => rxReady_from_gxRstCtrl(i),                         
            RX_IS_LOCKEDTODATA_I                   => rxIsLockedToData_from_gxLatOpt(i),                     
            RX_CAL_BUSY_I                          => rxCalBusy_from_gxLatOpt(i)                                 
         );
   
   end generate;
      
   --====================--
   -- RX phase alignment --
   --====================--
   
   -- Comment: Note!! The standard version of the GX does not align the phase of the  
   --                 RX_RECCLK (RX_WORDCLK) with respect to the TX_OUTCLK (TX_WORDCLK).
   
   rxPhaseAlign_numLinks_gen: for i in 1 to NUM_LINKS generate

      rxPhaseAlign_gen: if RX_OPTIMIZATION = LATENCY_OPTIMIZED generate
      
         -- Bitslip control module:
         --------------------------
         
         rxBitSlipControl: entity work.mgt_latopt_bitslipctrl 
            port map (
               RX_RESET_I                          => MGT_I.mgtLink(i).rx_reset,
               RX_WORDCLK_I                        => rx_usrclk(i-1),
               NUMBITSLIPS_I                       => nbr_to_rxBitSlipControl(i),
               ENABLE_I                            => run_to_rxBitSlipControl(i),
               MGT_RX_ODD_RESET_EN_I               => MGT_I.mgtLink(i).rxBitSlip_oddRstEn,
               BITSLIP_O                           => rxBitSlip_from_rxBitSlipControl(i),
               RESET_MGT_RX_O                      => resetGxRx_from_rxBitSlipControl(i),
               RESET_MGT_RX_ITERATIONS_O           => MGT_O.mgtLink(i).rxBitSlip_oddRstNbr,
               DONE_O                              => done_from_rxBitSlipControl(i)
            );
         
         MGT_O.mgtLink(i).rxWordClkReady           <= done_from_rxBitSlipControl(i);
         GBTRX_RXWORDCLK_READY_O(i)                <= done_from_rxBitSlipControl(i);
            
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
         
         -- Comment: * MGT_I(i).rxBitSlip_enable must be '1' to enable the GX RX phase alignment.
         --
         --          * Manual control: MGT_I(i).rxBitSlip_ctrl = '1'
         --            Auto control  : MGT_I(i).rxBitSlip_ctrl = '0'
         --
         --          * In manual control, the user provides the number of bitslips (rxBitSlip_nbr)
         --            as well as triggers the GX RX phase alignment (rxBitSlip_run).
         
         rxBitSlip_to_gxLatOpt(i)     <= rxBitSlip_from_rxBitSlipControl(i) when     MGT_I.mgtLink(i).rxBitSlip_enable = '1'
                                       -----------------------------------------------------------------------------
                                       else '0'; 
                                      
         run_to_rxBitSlipControl(i) <= MGT_I.mgtLink(i).rxBitSlip_run       when     MGT_I.mgtLink(i).rxBitSlip_enable = '1' 
                                                                                 and MGT_I.mgtLink(i).rxBitSlip_ctrl   = '1'
                                       -----------------------------------------------------------------------------
                                       else GBTRX_HEADER_LOCKED_I(i)        when     MGT_I.mgtLink(i).rxBitSlip_enable = '1'
                                                                                 and MGT_I.mgtLink(i).rxBitSlip_ctrl   = '0'
                                       -----------------------------------------------------------------------------
                                       else '0';
                           
         nbr_to_rxBitSlipControl(i) <= MGT_I.mgtLink(i).rxBitSlip_nbr       when     MGT_I.mgtLink(i).rxBitSlip_enable = '1'
                                                                                 and MGT_I.mgtLink(i).rxBitSlip_ctrl   = '1'
                                        -----------------------------------------------------------------------------                                
                                        else GBTRX_BITSLIP_NBR_I(i)         when     MGT_I.mgtLink(i).rxBitSlip_enable = '1'
                                                                                 and MGT_I.mgtLink(i).rxBitSlip_ctrl   = '0'
                                        -----------------------------------------------------------------------------                                
                                        else (others => '0');   
      
      end generate;
      
      rxPhaseAlign_no_gen: if RX_OPTIMIZATION = STANDARD generate
      
         -- Bitslip control module:
         --------------------------        
         MGT_O.mgtLink(i).rxWordClkReady           <= rxReady_from_gxRstCtrl(i);
         GBTRX_RXWORDCLK_READY_O(i)                <= rxReady_from_gxRstCtrl(i);
         resetGxRx_from_rxBitSlipControl				<= (others => '0');
			
         -- Manual or auto bitslip control selection logic:
         --------------------------------------------------
      
         rxBitSlip_to_gxLatOpt(i)                  <= '0';
      
      end generate;
      
   end generate;
   
   --================================================--
   -- ATX PLL													  --
   --================================================-- 
	atx_pll: entity work.alt_ax_mgt_txpll
		port map (      
			RESET_I             => MGT_I.mgtLink(1).tx_reset,
			
			MGT_REFCLK_I        => MGT_CLKS_I.mgtRefClk,
			TX_BONDING_CLK_O	  => tx_bonding_clocks,
			
			LOCKED_O            => ATXPLLLocked
		);
	
   --================================================--
   -- Multi-Gigabit Transceivers (latency-optimized) --
   --================================================-- 
      
   -- MGT latency-optimized x1:
   ----------------------------
   
   gxLatOpt_x1_gen: if NUM_LINKS = 1 generate
	
      gxLatOpt_x5: entity gx_latopt_x1.gx_latopt_x1
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr(9 downto 0), 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv								
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
									
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);						
			TX_WORDCLK_O(1) <= tx_usrclk(0);			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			
   end generate;
      
   -- MGT latency-optimized x2:
   ----------------------------
   
   gxLatOpt_x2_gen: if NUM_LINKS = 2 generate
	
      gxLatOpt_x2: entity gx_latopt_x2.gx_latopt_x2
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr(10 downto 0), 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_analogreset(1)         				=> rxAnalogReset_from_gxRstCtrl(2),				--          rx_analogreset.rx_analogreset
				
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         rx_digitalreset.rx_digitalreset
				
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(1)              			=> rxCalBusy_from_gxLatOpt(2),					--             rx_cal_busy.rx_cal_busy
				
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(1)     				=> rxIsLockedToData_from_gxLatOpt(2), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_analogreset(1)         				=> txAnalogReset_from_gxRstCtrl(2),				--          tx_analogreset.tx_analogreset
				
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         tx_digitalreset.tx_digitalreset
				
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(1)								=> txCalBusy_from_gxLatOpt(2),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(39  downto 20)    => GBTRX_WORD_O(2),            					--        rx_parallel_data.rx_parallel_data
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(39  downto 20)    => GBTTX_WORD_I(2),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(1)         		  => MGT_I.mgtLink(2).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
									
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(1)               		  => MGT_I.mgtLink(2).rx_polarity,					--               tx_polinv.tx_polinv
										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(1)               		  => MGT_I.mgtLink(2).tx_polarity,					--               tx_polinv.tx_polinv	
				
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(1)          		  => rxBitSlip_to_gxLatOpt(2), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(11 downto 6)     => tx_bonding_clocks, 								--       tx_bonding_clocks.clk
								
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(1)          		  => MGT_O.mgtLink(2).txSerialData,             --          tx_serial_data.tx_serial_data
											
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(1)         			  => MGT_I.mgtLink(2).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);
						
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			
   end generate;
      
   -- MGT latency-optimized x3:
   ----------------------------
   
   gxLatOpt_x3_gen: if NUM_LINKS = 3 generate
	
      gxLatOpt_x3: entity gx_latopt_x3.gx_latopt_x3
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr(11 downto 0), 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_analogreset(1)         				=> rxAnalogReset_from_gxRstCtrl(2),				--          rx_analogreset.rx_analogreset
				rx_analogreset(2)         				=> rxAnalogReset_from_gxRstCtrl(3),				--          rx_analogreset.rx_analogreset
				
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         rx_digitalreset.rx_digitalreset
				
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(1)              			=> rxCalBusy_from_gxLatOpt(2),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(2)              			=> rxCalBusy_from_gxLatOpt(3),					--             rx_cal_busy.rx_cal_busy
				
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(1)     				=> rxIsLockedToData_from_gxLatOpt(2), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(2)     				=> rxIsLockedToData_from_gxLatOpt(3), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_analogreset(1)         				=> txAnalogReset_from_gxRstCtrl(2),				--          tx_analogreset.tx_analogreset
				tx_analogreset(2)         				=> txAnalogReset_from_gxRstCtrl(3),				--          tx_analogreset.tx_analogreset
				
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         tx_digitalreset.tx_digitalreset
				
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(1)								=> txCalBusy_from_gxLatOpt(2),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(2)								=> txCalBusy_from_gxLatOpt(3),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(39  downto 20)    => GBTRX_WORD_O(2),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(59 downto 40)    => GBTRX_WORD_O(3),            					--        rx_parallel_data.rx_parallel_data	
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(39  downto 20)    => GBTTX_WORD_I(2),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(59 downto 40)    => GBTTX_WORD_I(3),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(1)         		  => MGT_I.mgtLink(2).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(2)         		  => MGT_I.mgtLink(3).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
									
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(1)               		  => MGT_I.mgtLink(2).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(2)              			  => MGT_I.mgtLink(3).rx_polarity,					--               tx_polinv.tx_polinv
										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(1)               		  => MGT_I.mgtLink(2).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(2)              			  => MGT_I.mgtLink(3).tx_polarity,					--               tx_polinv.tx_polinv	
				
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(1)          		  => rxBitSlip_to_gxLatOpt(2), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(2)          		  => rxBitSlip_to_gxLatOpt(3), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(11 downto 6)     => tx_bonding_clocks, 								--       tx_bonding_clocks.clk
				tx_bonding_clocks(17 downto 12)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
									
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(1)          		  => MGT_O.mgtLink(2).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(2)          		  => MGT_O.mgtLink(3).txSerialData,             --          tx_serial_data.tx_serial_data
											
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(1)         			  => MGT_I.mgtLink(2).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(2)         			  => MGT_I.mgtLink(3).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);
						
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			
   end generate;
      
   -- MGT latency-optimized x4:
   ----------------------------
   
   gxLatOpt_x4_gen: if NUM_LINKS = 4 generate
	
      gxLatOpt_x4: entity gx_latopt_x4.gx_latopt_x4
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr(11 downto 0), 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_analogreset(1)         				=> rxAnalogReset_from_gxRstCtrl(2),				--          rx_analogreset.rx_analogreset
				rx_analogreset(2)         				=> rxAnalogReset_from_gxRstCtrl(3),				--          rx_analogreset.rx_analogreset
				rx_analogreset(3)         				=> rxAnalogReset_from_gxRstCtrl(4),				--          rx_analogreset.rx_analogreset
				
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         rx_digitalreset.rx_digitalreset
				
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(1)              			=> rxCalBusy_from_gxLatOpt(2),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(2)              			=> rxCalBusy_from_gxLatOpt(3),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(3)              			=> rxCalBusy_from_gxLatOpt(4),					--             rx_cal_busy.rx_cal_busy
				
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(1)     				=> rxIsLockedToData_from_gxLatOpt(2), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(2)     				=> rxIsLockedToData_from_gxLatOpt(3), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(3)     				=> rxIsLockedToData_from_gxLatOpt(4), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_analogreset(1)         				=> txAnalogReset_from_gxRstCtrl(2),				--          tx_analogreset.tx_analogreset
				tx_analogreset(2)         				=> txAnalogReset_from_gxRstCtrl(3),				--          tx_analogreset.tx_analogreset
				tx_analogreset(3)         				=> txAnalogReset_from_gxRstCtrl(4),				--          tx_analogreset.tx_analogreset
				
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         tx_digitalreset.tx_digitalreset
				
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(1)								=> txCalBusy_from_gxLatOpt(2),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(2)								=> txCalBusy_from_gxLatOpt(3),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(3)								=> txCalBusy_from_gxLatOpt(4),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(39  downto 20)    => GBTRX_WORD_O(2),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(59 downto 40)    => GBTRX_WORD_O(3),            					--        rx_parallel_data.rx_parallel_data				
				rx_parallel_data(79  downto 60)  => GBTRX_WORD_O(4),            					--        rx_parallel_data.rx_parallel_data
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(39  downto 20)    => GBTTX_WORD_I(2),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(59 downto 40)    => GBTTX_WORD_I(3),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(79 downto 60)   => GBTTX_WORD_I(4),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(1)         		  => MGT_I.mgtLink(2).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(2)         		  => MGT_I.mgtLink(3).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(3)         		  => MGT_I.mgtLink(4).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
									
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(1)               		  => MGT_I.mgtLink(2).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(2)              			  => MGT_I.mgtLink(3).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(3)               		  => MGT_I.mgtLink(4).rx_polarity,					--               tx_polinv.tx_polinv
										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(1)               		  => MGT_I.mgtLink(2).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(2)              			  => MGT_I.mgtLink(3).tx_polarity,					--               tx_polinv.tx_polinv					
				tx_polinv(3)               		  => MGT_I.mgtLink(4).tx_polarity,					--               tx_polinv.tx_polinv
				
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(1)          		  => rxBitSlip_to_gxLatOpt(2), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(2)          		  => rxBitSlip_to_gxLatOpt(3), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(3)          		  => rxBitSlip_to_gxLatOpt(4), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(11 downto 6)     => tx_bonding_clocks, 								--       tx_bonding_clocks.clk
				tx_bonding_clocks(17 downto 12)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(23 downto 18)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
									
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(1)          		  => MGT_O.mgtLink(2).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(2)          		  => MGT_O.mgtLink(3).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(3)          		  => MGT_O.mgtLink(4).txSerialData,             --          tx_serial_data.tx_serial_data
											
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(1)         			  => MGT_I.mgtLink(2).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(2)         			  => MGT_I.mgtLink(3).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(3)         			  => MGT_I.mgtLink(4).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);
						
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);
			
   end generate;
      
   -- MGT latency-optimized x5:
   ----------------------------
   
   gxLatOpt_x5_gen: if NUM_LINKS = 5 generate
	
      gxLatOpt_x5: entity gx_latopt_x5.gx_latopt_x5
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr, 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_analogreset(1)         				=> rxAnalogReset_from_gxRstCtrl(2),				--          rx_analogreset.rx_analogreset
				rx_analogreset(2)         				=> rxAnalogReset_from_gxRstCtrl(3),				--          rx_analogreset.rx_analogreset
				rx_analogreset(3)         				=> rxAnalogReset_from_gxRstCtrl(4),				--          rx_analogreset.rx_analogreset
				rx_analogreset(4)         				=> rxAnalogReset_from_gxRstCtrl(5),				--          rx_analogreset.rx_analogreset
				
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(4)        				=> txDigitalReset_from_gxRstCtrl(5),			--         rx_digitalreset.rx_digitalreset
				
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(1)              			=> rxCalBusy_from_gxLatOpt(2),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(2)              			=> rxCalBusy_from_gxLatOpt(3),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(3)              			=> rxCalBusy_from_gxLatOpt(4),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(4)              			=> rxCalBusy_from_gxLatOpt(5),					--             rx_cal_busy.rx_cal_busy
				
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(1)     				=> rxIsLockedToData_from_gxLatOpt(2), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(2)     				=> rxIsLockedToData_from_gxLatOpt(3), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(3)     				=> rxIsLockedToData_from_gxLatOpt(4), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(4)     				=> rxIsLockedToData_from_gxLatOpt(5), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_analogreset(1)         				=> txAnalogReset_from_gxRstCtrl(2),				--          tx_analogreset.tx_analogreset
				tx_analogreset(2)         				=> txAnalogReset_from_gxRstCtrl(3),				--          tx_analogreset.tx_analogreset
				tx_analogreset(3)         				=> txAnalogReset_from_gxRstCtrl(4),				--          tx_analogreset.tx_analogreset
				tx_analogreset(4)         				=> txAnalogReset_from_gxRstCtrl(5),				--          tx_analogreset.tx_analogreset
				
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(4)        				=> txDigitalReset_from_gxRstCtrl(5),			--         tx_digitalreset.tx_digitalreset
				
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(1)								=> txCalBusy_from_gxLatOpt(2),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(2)								=> txCalBusy_from_gxLatOpt(3),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(3)								=> txCalBusy_from_gxLatOpt(4),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(4)								=> txCalBusy_from_gxLatOpt(5),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(39  downto 20)    => GBTRX_WORD_O(2),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(59 downto 40)    => GBTRX_WORD_O(3),            					--        rx_parallel_data.rx_parallel_data				
				rx_parallel_data(79  downto 60)  => GBTRX_WORD_O(4),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(99  downto 80)  => GBTRX_WORD_O(5),            					--        rx_parallel_data.rx_parallel_data
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(39  downto 20)    => GBTTX_WORD_I(2),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(59 downto 40)    => GBTTX_WORD_I(3),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(79 downto 60)   => GBTTX_WORD_I(4),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(99 downto 80)   => GBTTX_WORD_I(5),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(1)         		  => MGT_I.mgtLink(2).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(2)         		  => MGT_I.mgtLink(3).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(3)         		  => MGT_I.mgtLink(4).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(4)         		  => MGT_I.mgtLink(5).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
									
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(1)               		  => MGT_I.mgtLink(2).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(2)              			  => MGT_I.mgtLink(3).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(3)               		  => MGT_I.mgtLink(4).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(4)               		  => MGT_I.mgtLink(5).rx_polarity,					--               tx_polinv.tx_polinv
										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(1)               		  => MGT_I.mgtLink(2).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(2)              			  => MGT_I.mgtLink(3).tx_polarity,					--               tx_polinv.tx_polinv					
				tx_polinv(3)               		  => MGT_I.mgtLink(4).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(4)               		  => MGT_I.mgtLink(5).tx_polarity,					--               tx_polinv.tx_polinv
								
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(1)          		  => rxBitSlip_to_gxLatOpt(2), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(2)          		  => rxBitSlip_to_gxLatOpt(3), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(3)          		  => rxBitSlip_to_gxLatOpt(4), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(4)          		  => rxBitSlip_to_gxLatOpt(5), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(11 downto 6)     => tx_bonding_clocks, 								--       tx_bonding_clocks.clk
				tx_bonding_clocks(17 downto 12)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(23 downto 18)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(29 downto 24)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
									
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(1)          		  => MGT_O.mgtLink(2).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(2)          		  => MGT_O.mgtLink(3).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(3)          		  => MGT_O.mgtLink(4).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(4)          		  => MGT_O.mgtLink(5).txSerialData,             --          tx_serial_data.tx_serial_data
											
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(1)         			  => MGT_I.mgtLink(2).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(2)         			  => MGT_I.mgtLink(3).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(3)         			  => MGT_I.mgtLink(4).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(4)         			  => MGT_I.mgtLink(5).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);
			MGT_CLKS_O.tx_wordClk(5) <= tx_usrclk(4);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);
			MGT_CLKS_O.rx_wordClk(5) <= rx_usrclk(4);
						
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			TX_WORDCLK_O(5) <= tx_usrclk(4);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);
			RX_WORDCLK_O(5) <= rx_usrclk(4);
			
   end generate;
      
   -- MGT latency-optimized x6:
   ----------------------------
   
   gxLatOpt_x6_gen: if NUM_LINKS = 6 generate
	
      gxLatOpt_x6: entity gx_latopt_x6.gx_latopt_x6
			port map(
			
				-- Reconfigurator avalon MM bus
				reconfig_write(0)         				=> MGT_I.mgtCommon.reconf_avmm_write, 			--           reconfig_avmm.write
				reconfig_read(0)          				=> MGT_I.mgtCommon.reconf_avmm_read, 			--                        .read
				reconfig_address        				=> MGT_I.mgtCommon.reconf_avmm_addr, 			--                        .address
				reconfig_writedata      				=> MGT_I.mgtCommon.reconf_avmm_writedata,		--                        .writedata
				reconfig_readdata       				=> MGT_O.mgtCommon.reconf_avmm_readdata, 		--                        .readdata
				reconfig_waitrequest(0)   				=> MGT_O.mgtCommon.reconf_avmm_waitrequest, 	--                        .waitrequest
				reconfig_clk(0)           				=> MGT_I.mgtCommon.reconf_clk, 					--            reconfig_clk.clk
				reconfig_reset(0)         				=> MGT_I.mgtCommon.reconf_reset, 				--          reconfig_reset.reset
				
				-- Reset
				rx_analogreset(0)         				=> rxAnalogReset_from_gxRstCtrl(1),				--          rx_analogreset.rx_analogreset
				rx_analogreset(1)         				=> rxAnalogReset_from_gxRstCtrl(2),				--          rx_analogreset.rx_analogreset
				rx_analogreset(2)         				=> rxAnalogReset_from_gxRstCtrl(3),				--          rx_analogreset.rx_analogreset
				rx_analogreset(3)         				=> rxAnalogReset_from_gxRstCtrl(4),				--          rx_analogreset.rx_analogreset
				rx_analogreset(4)         				=> rxAnalogReset_from_gxRstCtrl(5),				--          rx_analogreset.rx_analogreset
				rx_analogreset(5)         				=> rxAnalogReset_from_gxRstCtrl(6),				--          rx_analogreset.rx_analogreset
				
				rx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(4)        				=> txDigitalReset_from_gxRstCtrl(5),			--         rx_digitalreset.rx_digitalreset
				rx_digitalreset(5)        				=> txDigitalReset_from_gxRstCtrl(6),			--         rx_digitalreset.rx_digitalreset
				
				rx_cal_busy(0)              			=> rxCalBusy_from_gxLatOpt(1),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(1)              			=> rxCalBusy_from_gxLatOpt(2),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(2)              			=> rxCalBusy_from_gxLatOpt(3),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(3)              			=> rxCalBusy_from_gxLatOpt(4),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(4)              			=> rxCalBusy_from_gxLatOpt(5),					--             rx_cal_busy.rx_cal_busy
				rx_cal_busy(5)              			=> rxCalBusy_from_gxLatOpt(6),					--             rx_cal_busy.rx_cal_busy
				
				rx_is_lockedtodata(0)     				=> rxIsLockedToData_from_gxLatOpt(1), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(1)     				=> rxIsLockedToData_from_gxLatOpt(2), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(2)     				=> rxIsLockedToData_from_gxLatOpt(3), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(3)     				=> rxIsLockedToData_from_gxLatOpt(4), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(4)     				=> rxIsLockedToData_from_gxLatOpt(5), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				rx_is_lockedtodata(5)     				=> rxIsLockedToData_from_gxLatOpt(6), 			--      rx_is_lockedtodata.rx_is_lockedtodata
				
				tx_analogreset(0)         				=> txAnalogReset_from_gxRstCtrl(1),				--          tx_analogreset.tx_analogreset
				tx_analogreset(1)         				=> txAnalogReset_from_gxRstCtrl(2),				--          tx_analogreset.tx_analogreset
				tx_analogreset(2)         				=> txAnalogReset_from_gxRstCtrl(3),				--          tx_analogreset.tx_analogreset
				tx_analogreset(3)         				=> txAnalogReset_from_gxRstCtrl(4),				--          tx_analogreset.tx_analogreset
				tx_analogreset(4)         				=> txAnalogReset_from_gxRstCtrl(5),				--          tx_analogreset.tx_analogreset
				tx_analogreset(5)         				=> txAnalogReset_from_gxRstCtrl(6),				--          tx_analogreset.tx_analogreset
				
				tx_digitalreset(0)        				=> txDigitalReset_from_gxRstCtrl(1),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(1)        				=> txDigitalReset_from_gxRstCtrl(2),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(2)        				=> txDigitalReset_from_gxRstCtrl(3),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(3)        				=> txDigitalReset_from_gxRstCtrl(4),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(4)        				=> txDigitalReset_from_gxRstCtrl(5),			--         tx_digitalreset.tx_digitalreset
				tx_digitalreset(5)        				=> txDigitalReset_from_gxRstCtrl(6),			--         tx_digitalreset.tx_digitalreset
				
				tx_cal_busy(0)								=> txCalBusy_from_gxLatOpt(1),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(1)								=> txCalBusy_from_gxLatOpt(2),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(2)								=> txCalBusy_from_gxLatOpt(3),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(3)								=> txCalBusy_from_gxLatOpt(4),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(4)								=> txCalBusy_from_gxLatOpt(5),					--             tx_cal_busy.tx_cal_busy
				tx_cal_busy(5)								=> txCalBusy_from_gxLatOpt(6),					--             tx_cal_busy.tx_cal_busy
				
				-- RX parallel data
				rx_parallel_data(19  downto 0)     => GBTRX_WORD_O(1),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(39  downto 20)    => GBTRX_WORD_O(2),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(59 downto 40)    => GBTRX_WORD_O(3),            					--        rx_parallel_data.rx_parallel_data				
				rx_parallel_data(79  downto 60)  => GBTRX_WORD_O(4),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(99  downto 80)  => GBTRX_WORD_O(5),            					--        rx_parallel_data.rx_parallel_data
				rx_parallel_data(119 downto 100)   => GBTRX_WORD_O(6),            					--        rx_parallel_data.rx_parallel_data
												
				-- TX parallel data					
				tx_parallel_data(19  downto 0)     => GBTTX_WORD_I(1),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(39  downto 20)    => GBTTX_WORD_I(2),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(59 downto 40)    => GBTTX_WORD_I(3),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(79 downto 60)   => GBTTX_WORD_I(4),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(99 downto 80)   => GBTTX_WORD_I(5),            					--        tx_parallel_data.tx_parallel_data
				tx_parallel_data(119 downto 100)   => GBTTX_WORD_I(6),            					--        tx_parallel_data.tx_parallel_data
									
				-- Configuration					
				rx_seriallpbken(0)         		  => MGT_I.mgtLink(1).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(1)         		  => MGT_I.mgtLink(2).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(2)         		  => MGT_I.mgtLink(3).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(3)         		  => MGT_I.mgtLink(4).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(4)         		  => MGT_I.mgtLink(5).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
				rx_seriallpbken(5)         		  => MGT_I.mgtLink(6).loopBack, 						--         rx_seriallpbken.rx_seriallpbken
									
				rx_polinv(0)               		  => MGT_I.mgtLink(1).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(1)               		  => MGT_I.mgtLink(2).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(2)              			  => MGT_I.mgtLink(3).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(3)               		  => MGT_I.mgtLink(4).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(4)               		  => MGT_I.mgtLink(5).rx_polarity,					--               tx_polinv.tx_polinv
				rx_polinv(5)              			  => MGT_I.mgtLink(6).rx_polarity,					--               tx_polinv.tx_polinv
										
				tx_polinv(0)               		  => MGT_I.mgtLink(1).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(1)               		  => MGT_I.mgtLink(2).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(2)              			  => MGT_I.mgtLink(3).tx_polarity,					--               tx_polinv.tx_polinv					
				tx_polinv(3)               		  => MGT_I.mgtLink(4).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(4)               		  => MGT_I.mgtLink(5).tx_polarity,					--               tx_polinv.tx_polinv
				tx_polinv(5)              			  => MGT_I.mgtLink(6).tx_polarity,					--               tx_polinv.tx_polinv
								
				rx_pma_clkslip(0)          		  => rxBitSlip_to_gxLatOpt(1), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(1)          		  => rxBitSlip_to_gxLatOpt(2), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(2)          		  => rxBitSlip_to_gxLatOpt(3), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(3)          		  => rxBitSlip_to_gxLatOpt(4), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(4)          		  => rxBitSlip_to_gxLatOpt(5), 						--          rx_pma_clkslip.rx_pma_clkslip
				rx_pma_clkslip(5)          		  => rxBitSlip_to_gxLatOpt(6), 						--          rx_pma_clkslip.rx_pma_clkslip
												
				-- Clocks					
				rx_cdr_refclk0         				  => MGT_CLKS_I.mgtRefClk,             			--          rx_cdr_refclk0.clk
				
				rx_clkout               		  	  => rx_usrclk,           								--               rx_clkout.clk
				rx_coreclkin            		  	  => rx_usrclk,											--            rx_coreclkin.clk
													
				tx_clkout	             			  => tx_usrclk,           								--               tx_clkout.clk
				tx_coreclkin            		  	  => tx_usrclk, 											--            tx_coreclkin.clk
									
				tx_bonding_clocks(5 downto 0)      => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(11 downto 6)     => tx_bonding_clocks, 								--       tx_bonding_clocks.clk
				tx_bonding_clocks(17 downto 12)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(23 downto 18)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(29 downto 24)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
				tx_bonding_clocks(35 downto 30)    => tx_bonding_clocks,									--       tx_bonding_clocks.clk
									
				-- Serial link					
				tx_serial_data(0)          		  => MGT_O.mgtLink(1).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(1)          		  => MGT_O.mgtLink(2).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(2)          		  => MGT_O.mgtLink(3).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(3)          		  => MGT_O.mgtLink(4).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(4)          		  => MGT_O.mgtLink(5).txSerialData,             --          tx_serial_data.tx_serial_data
				tx_serial_data(5)          		  => MGT_O.mgtLink(6).txSerialData,             --          tx_serial_data.tx_serial_data
											
				rx_serial_data(0)         			  => MGT_I.mgtLink(1).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(1)         			  => MGT_I.mgtLink(2).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(2)         			  => MGT_I.mgtLink(3).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(3)         			  => MGT_I.mgtLink(4).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(4)         			  => MGT_I.mgtLink(5).rxSerialData,					--          rx_serial_data.rx_serial_data
				rx_serial_data(5)         			  => MGT_I.mgtLink(6).rxSerialData,					--          rx_serial_data.rx_serial_data
				
				-- Unused
				unused_rx_parallel_data 			  => open,                    -- unused_rx_parallel_data.unused_rx_parallel_data
				unused_tx_parallel_data 			  => open  							-- unused_tx_parallel_data.unused_tx_parallel_data
				--rx_is_lockedtoref       : out std_logic_vector(2 downto 0);                      --       rx_is_lockedtoref.rx_is_lockedtoref
			);
			
			MGT_CLKS_O.tx_wordClk(1) <= tx_usrclk(0);
			MGT_CLKS_O.tx_wordClk(2) <= tx_usrclk(1);
			MGT_CLKS_O.tx_wordClk(3) <= tx_usrclk(2);
			MGT_CLKS_O.tx_wordClk(4) <= tx_usrclk(3);
			MGT_CLKS_O.tx_wordClk(5) <= tx_usrclk(4);
			MGT_CLKS_O.tx_wordClk(6) <= tx_usrclk(5);
			
			MGT_CLKS_O.rx_wordClk(1) <= rx_usrclk(0);
			MGT_CLKS_O.rx_wordClk(2) <= rx_usrclk(1);
			MGT_CLKS_O.rx_wordClk(3) <= rx_usrclk(2);
			MGT_CLKS_O.rx_wordClk(4) <= rx_usrclk(3);
			MGT_CLKS_O.rx_wordClk(5) <= rx_usrclk(4);
			MGT_CLKS_O.rx_wordClk(6) <= rx_usrclk(5);
						
			TX_WORDCLK_O(1) <= tx_usrclk(0);
			TX_WORDCLK_O(2) <= tx_usrclk(1);
			TX_WORDCLK_O(3) <= tx_usrclk(2);
			TX_WORDCLK_O(4) <= tx_usrclk(3);
			TX_WORDCLK_O(5) <= tx_usrclk(4);
			TX_WORDCLK_O(6) <= tx_usrclk(5);
			
			RX_WORDCLK_O(1) <= rx_usrclk(0);
			RX_WORDCLK_O(2) <= rx_usrclk(1);
			RX_WORDCLK_O(3) <= rx_usrclk(2);
			RX_WORDCLK_O(4) <= rx_usrclk(3);
			RX_WORDCLK_O(5) <= rx_usrclk(4);
			RX_WORDCLK_O(6) <= rx_usrclk(5);
			
   end generate;
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--