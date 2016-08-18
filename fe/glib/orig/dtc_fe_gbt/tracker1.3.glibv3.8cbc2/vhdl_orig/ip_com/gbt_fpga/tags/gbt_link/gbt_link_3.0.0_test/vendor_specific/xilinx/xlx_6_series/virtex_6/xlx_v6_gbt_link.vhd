--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	08/02/2013     																			--
-- Project Name:				glib_gbt_link                   														--
-- Module Name:   		 	glib_gbt_link 							 													--
-- 																																--
-- Language:					VHDL'93                                      									--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)   																		--
-- Tool versions: 			13.2                 																	--
--																																	--
-- Revision:		 			1.0 																							--
--																																	--
-- Additional Comments: 																									--
--																																	--
--=================================================================================================--
--=================================================================================================--
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
-- Custom libraries and packages:
use work.gbt_link_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity gbt_link is
	generic (
      NUM_LINKS                     : integer range 1 to 4 := 1;
      OPTIMIZATION                  : string(1 to 8)       := "LATENCY_"  -- "LATENCY_" or "STANDARD"  
	);	
	port (	
      -- Clocks:
      CLKS_I                        : in  gbt_link_clks_in;                                        
      CLKS_O                        : out gbt_link_clks_out;
      -- GBT encoder:
      GBT_TX_I                      : in  gbt_tx_in_array (1 to NUM_LINKS); 
      GBT_TX_O                      : out gbt_tx_out_array(1 to NUM_LINKS);
      -- GTX transceiver:
      GTX_I                         : in  gtx_in_array    (1 to NUM_LINKS);
      GTX_O                         : out gtx_out_array   (1 to NUM_LINKS); 
      -- GBT decoder:
      GBT_RX_I                      : in  gbt_rx_in_array (1 to NUM_LINKS); 
      GBT_RX_O                      : out gbt_rx_out_array(1 to NUM_LINKS)      
	);
end gbt_link;
architecture structural of gbt_link is	
	--====================== Signal Declarations =====================--

   signal gtx_txoutclk  	            : std_logic_vector  (1 to NUM_LINKS);
   signal tx_wordclk    	            : std_logic;               
   signal rx_wordclk	                  : std_logic_vector  (1 to NUM_LINKS);
          
   signal frame_from_gbt_tx            : frame_120b_array  (1 to NUM_LINKS);
   signal word_from_gbt_tx             : word_array        (1 to NUM_LINKS);
          
   signal aligned_from_gtx             : std_logic_vector  (1 to NUM_LINKS);
   signal word_from_gtx                : word_array        (1 to NUM_LINKS);
          
   signal aligned_from_gbt_rx          : std_logic_vector  (1 to NUM_LINKS);          
      
   signal bit_slip_nbr_from_gbt_rx  : rx_slide_nbr_array(1 to NUM_LINKS);
    
   signal rx_slide_to_gtx           : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_from_gtx         : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_run_to_gtx       : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_nbr_to_gtx       : rx_slide_nbr_array(1 to NUM_LINKS);   
   ---------------------------------   
   signal rx_slide_enable_from_int  : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_ctrl_from_int	   : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_run_from_int	   : std_logic_vector  (1 to NUM_LINKS);
   signal rx_slide_nbr_from_int	   : rx_slide_nbr_array(1 to NUM_LINKS);       
   
   --=====================================================================--		
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--

	--============================ User Logic =============================--
   
   numLinks_gen: for i in 1 to NUM_LINKS generate
   
      --==============--
      -- Clock scheme --
      --==============--
      
      -- Note!! This clock buffer is generated only once and "tx_wordclk" 
      --        is shared for all the links of the quad.    
      
      txWordclk_bufg: bufg
         port map (
            O 								=> tx_wordclk, 
            I 								=> gtx_txoutclk(1)  
         );	      
         
      CLKS_O.tx_word_clk            <= tx_wordclk;   
      CLKS_O.rx_word_clk(i)         <= rx_wordclk(i);       
   
      --=================--
      -- GBT transmitter --
      --=================--
      
      gbtTx: entity work.gbt_tx
        generic map(
            OPTIMIZATION 			   => OPTIMIZATION)	
        port map( 
            TX_RESET_I 			      => GBT_TX_I(i).reset,
            TX_WORD_CLK_I 		      => tx_wordclk,
            TX_FRAME_CLK_I 	      => CLKS_I.tx_frame_clk,
            TX_DATA_I 			      => GBT_TX_I(i).data,
            ------------------------	                            
            TX_FRAME_O 			      => GBT_TX_O(i).frame,
            TX_WORD_O 			      => word_from_gbt_tx(i), 
            TX_HEADER_O 		      => GBT_TX_O(i).header
         );
      
      GBT_TX_O(i).word              <= word_from_gbt_tx(i); 
     
      --=================--  
      -- GTX transceiver --
      --=================--
      
		gtx: entity work.gtxWrapper
--         generic map(
--            OPTIMIZATION 			   => OPTIMIZATION)	      
         port map(
            GTX_LOOPBACK_I			   => GTX_I(i).loopback,
            GTX_TX_POWERDOWN_I	   => GTX_I(i).tx_powerdown,
            GTX_RX_POWERDOWN_I	   => GTX_I(i).rx_powerdown,
            GTX_RESETDONE_O 		   => GTX_O(i).resetdone,
            GTX_PHASEALIGNDONE_O	   => aligned_from_gtx(i),
            ------------------------                              
            GTX_RXP_I 				   => GTX_I(i).rxp,
            GTX_RXN_I 				   => GTX_I(i).rxn,
            GTX_TX_REFCLK_I		   => CLKS_I.gtx_tx_refclk, 		
            GTX_RX_REFCLK_I		   => CLKS_I.gtx_rx_refclk,		
            GTX_TX_RESET_I 		   => GTX_I(i).tx_reset,
            GTX_RX_RESET_I 		   => GTX_I(i).rx_reset,
            GTX_TX_SYNC_RESET_I 	   => GTX_I(i).tx_sync_reset,
            GTX_RX_SYNC_RESET_I	   => GTX_I(i).rx_sync_reset,
            GTX_TX_DATA_I 			   => word_from_gbt_tx(i),
            ------------------------                              
            GTX_RX_SLIDE_I			   => rx_slide_to_gtx(i),		
            GTX_RX_SLIDE_RUN_I	   => rx_slide_run_to_gtx(i),
            GTX_RX_SLIDE_NBR_I	   => rx_slide_nbr_to_gtx(i),
            GTX_RX_SLIDE_O			   => rx_slide_from_gtx(i),		
            ------------------------                              
            GTX_TXP_O 				   => GTX_O(i).txp,
            GTX_TXN_O 				   => GTX_O(i).txn,
            GTX_TXOUTCLK_O			   => gtx_txoutclk(i),
            GTX_TXUSRCLK2_I		   => tx_wordclk,    
            GTX_RXUSRCLK2_O		   => rx_wordclk(i),    
            GTX_RX_DATA_O 			   => word_from_gtx(i),	
            ------------------------    
            GTX_TXDIFFCTRL_I		   => GTX_I(i).conf_diff,
            GTX_TXPOSTEMPHASIS_I	   => GTX_I(i).conf_pstemph,
            GTX_TXPREEMPHASIS_I	   => GTX_I(i).conf_preemph,	
            GTX_RXEQMIX_I			   => GTX_I(i).conf_eqmix,
            GTX_RXPOLARITY_I		   => GTX_I(i).conf_rxpol,
            GTX_TXPOLARITY_I		   =>	GTX_I(i).conf_txpol,
            ------------------------          	   
            GTX_DADDR_I             => GTX_I(i).drp_daddr, 
            GTX_DCLK_I              => CLKS_I.drp_dclk,
            GTX_DEN_I               => GTX_I(i).drp_den,
            GTX_DI_I                => GTX_I(i).drp_di,
            GTX_DRDY_O              => GTX_O(i).drp_drdy,
            GTX_DRPDO_O             => GTX_O(i).drp_drpdo,
            GTX_DWE_I               => GTX_I(i).drp_dwe,
            ------------------------    
            GTX_TXENPRBSTST_I       => GTX_I(i).prbs_txen, 
            GTX_RXENPRBSTST_I       => GTX_I(i).prbs_rxen,
            GTX_TXPRBSFORCEERR_I    => GTX_I(i).prbs_forcerr,
            GTX_RXPRBSERR_O         => GTX_O(i).prbs_rxerr,
            GTX_PRBSCNTRESET_I      => GTX_I(i).prbs_errcntrst          
         );              	
      
      GTX_O(i).phasealigndone       <= aligned_from_gtx(i);
      GTX_O(i).rx_data              <= word_from_gtx(i);      
      
      gtxLatOpt_gen: if OPTIMIZATION = "LATENCY_" generate        
         
         -- RX slide select:	      
         rx_slide_to_gtx(i)      <= rx_slide_from_gtx(i)             when rx_slide_enable_from_int(i)='1'
                                    else '0'; 
                                    
         rx_slide_run_to_gtx(i)	<= rx_slide_run_from_int(i)         when
                                    (rx_slide_enable_from_int(i)='1' and rx_slide_ctrl_from_int(i)='1')
                                    else aligned_from_gbt_rx(i)	   when
                                    (rx_slide_enable_from_int(i)='1' and rx_slide_ctrl_from_int(i)='0')
                                    else '0';
         
         rx_slide_nbr_to_gtx(i)	<= rx_slide_nbr_from_int(i)         when
                                    (rx_slide_enable_from_int(i)='1' and rx_slide_ctrl_from_int(i)='1')
                                    else bit_slip_nbr_from_gbt_rx(i)when
                                    (rx_slide_enable_from_int(i)='1' and rx_slide_ctrl_from_int(i)='0')
                                    else "00000";			
        
      end generate;   
      
      --==============--
      -- GBT receiver --
      --==============--
      
      gbtRx: entity work.gbt_rx
         generic map(
            OPTIMIZATION 			   => OPTIMIZATION)		
         port map(   
            RX_RESET_I 				   => GBT_RX_I(i).reset,
            RX_WORD_CLK_I 			   => rx_wordclk(i),
            RX_FRAME_CLK_I 		   => CLKS_I.rx_frame_clk,                  
            RX_WORD_I 				   => word_from_gtx(i),                  
            RX_GTX_ALIGNED_I 		   => aligned_from_gtx(i),        
            ------------------------	                                                         
            RX_DATA_O 				   => GBT_RX_O(i).data,                  
            RX_DATA_DV_O 			   => GBT_RX_O(i).data_dv,               
            RX_BIT_SLIP_CMD_O 	   => GBT_RX_O(i).bit_slip_cmd,          
            RX_BIT_SLIP_NBR_O 	   => bit_slip_nbr_from_gbt_rx(i),            
            RX_ALIGNED_O 			   => aligned_from_gbt_rx(i),                 
            RX_WRITE_ADDRESS_O 	   => GBT_RX_O(i).write_address,         
            RX_FRAME_O 				   => GBT_RX_O(i).frame,                 
            RX_FRAME_DV_O 			   => GBT_RX_O(i).frame_dv,
            RX_HEADER_FLAG_O 		   => GBT_RX_O(i).header_flag,
            RX_SHIFTEDWORD_O 		   => GBT_RX_O(i).shiftedword 	
         );
      
      --===============================================--
      -- Control & status Clock Domain Crossing bridge --
      --===============================================--
      
      -- Note!! There is not CDC bridge in STANDARD optimization.         
      
      cdcBridge_gen: if OPTIMIZATION = "LATENCY_" generate   
         
         cdcBridge: entity work.cntrl_and_stat_cdc_bridge                   
            port map (         
               RX_WORDCLK_I               => rx_wordclk(i),
               INTERFACE_CLK_I            => CLKS_I.interface_clk,
               
               INT_GTX_RX_SLIDE_ENABLE_I  => GTX_I(i).rx_slide_enable,	
               INT_GTX_RX_SLIDE_CTRL_I	   => GTX_I(i).rx_slide_ctrl,		
               INT_GTX_RX_SLIDE_RUN_I     => GTX_I(i).rx_slide_run,
               INT_GTX_RX_SLIDE_NBR_I     => GTX_I(i).rx_slide_nbr,      
               ------------------------------------------
               GTX_RX_SLIDE_ENABLE_O      => rx_slide_enable_from_int(i),
               GTX_RX_SLIDE_CTRL_O        => rx_slide_ctrl_from_int(i),	
               GTX_RX_SLIDE_RUN_O         => rx_slide_run_from_int(i),
               GTX_RX_SLIDE_NBR_O         => rx_slide_nbr_from_int(i),	
               
               GBT_RX_ALIGNED_I           => aligned_from_gbt_rx(i),
               GBT_RX_BIT_SLIP_NBR_I      => bit_slip_nbr_from_gbt_rx(i),
               ------------------------------------------
               INT_GBT_RX_ALIGNED_O       => GBT_RX_O(i).aligned,
               INT_GBT_RX_BIT_SLIP_NBR_O  => GBT_RX_O(i).bit_slip_nbr            
            );                 
            
      end generate;
      cdcBridge_not_gen: if OPTIMIZATION = "STANDARD" generate  
         
         cdc_not_gen_assign: for i in 1 to NUM_LINKS generate
            GBT_RX_O(i).aligned           <= aligned_from_gbt_rx(i);
            GBT_RX_O(i).bit_slip_nbr      <= (others => '0'); 
         end generate;         
         
      end generate;         
         
   end generate;  
   
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--