--=================================================================================================--
--==================================== module information =========================================--
--=================================================================================================--
--																																  	--
-- company:  					cern (ph-ese-be)																			--
-- engineer: 					manoel barros marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- create date:		    	12/01/2012		 																			--
-- project name:				gtx_top																						--
-- module name:   		 	gtxwrapper							 														--
-- 																																--
-- language:					vhdl'93									                                       --
--																																	--
-- target devices: 			GLIB (Virtex 6)																			--
-- tool versions: 			ISE 13.2																						--
--																																	--
-- revision:		 			2.0 																							--
--																																	--
-- additional comments: 																									--
--																																	--
--=================================================================================================--
--=================================================================================================--
-- ieee vhdl standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- xilinx devices library:
library unisim;
use unisim.vcomponents.all;
--=================================================================================================--
--======================================= module body =============================================-- 
--=================================================================================================--
entity gtxwrapper is	
	port (	
		-- gtx ref clock input port:		
		gtx_tx_refclk_i								: in 	std_logic;	
		gtx_rx_refclk_i								: in 	std_logic;
 		-- gtx clocks ports:
      gtx_txoutclk_o								   : out std_logic;	      
      gtx_txusrclk2_i								: in  std_logic;	     
		gtx_rxusrclk2_o								: out std_logic;
		-- reset input ports:			
		gtx_tx_reset_i									: in 	std_logic; 
		gtx_rx_reset_i									: in 	std_logic;
		gtx_tx_sync_reset_i							: in 	std_logic;
      gtx_rx_sync_reset_i							: in 	std_logic; 		
		-- gtx reset done output port: 		
		gtx_resetdone_o								: out std_logic;		
		-- phase alignment done ouput port:		
		gtx_phasealigndone_o							: out std_logic;		
		-- bitslip input port:
      gtx_rx_slide_i									: in 	std_logic;
		-- bitslip control
		gtx_rx_slide_nbr_i							: in 	std_logic_vector(4 downto 0);
		gtx_rx_slide_run_i							: in 	std_logic;
		gtx_rx_slide_o									: out std_logic;
		-- loopback & powerdown input ports:
      gtx_loopback_i									: in 	std_logic_vector(2 downto 0);
		gtx_tx_powerdown_i							: in 	std_logic_vector(1 downto 0);
		gtx_rx_powerdown_i							: in 	std_logic_vector(1 downto 0);
		-- parallel data ports:		
		gtx_tx_data_i									: in 	std_logic_vector(19 downto 0);
		gtx_rx_data_o									: out std_logic_vector(19 downto 0);
		-- serial data ports:
		gtx_txp_o										: out std_logic;
		gtx_txn_o										: out std_logic;
		gtx_rxp_i										: in 	std_logic;
		gtx_rxn_i    									: in 	std_logic;
		-- configuration ports:	
		gtx_txdiffctrl_i				         	: in 	std_logic_vector(3 downto 0);
		gtx_txpostemphasis_i			           	: in 	std_logic_vector(4 downto 0);
		gtx_txpreemphasis_i					      : in 	std_logic_vector(3 downto 0);
		gtx_rxeqmix_i				               : in 	std_logic_vector(2 downto 0);
		gtx_rxpolarity_i								: in 	std_logic;
		gtx_txpolarity_i								: in 	std_logic;
		-- drp ports:		
		gtx_daddr_i                      		: in   std_logic_vector(7 downto 0);   
		gtx_dclk_i                       		: in   std_logic;   
		gtx_den_i                        		: in   std_logic;   
		gtx_di_i                         		: in   std_logic_vector(15 downto 0);   
      gtx_drdy_o                       		: out  std_logic;  
      gtx_drpdo_o                      		: out  std_logic_vector(15 downto 0);  
      gtx_dwe_i                        		: in   std_logic;
      -- prbs ports:
      gtx_txenprbstst_i                      : in   std_logic_vector(2 downto 0);
      gtx_rxenprbstst_i                      : in   std_logic_vector(2 downto 0);
      gtx_txprbsforceerr_i                   : in   std_logic;       
      gtx_rxprbserr_o                        : out  std_logic;      
      gtx_prbscntreset_i                     : in   std_logic 		
	);
end gtxwrapper;
architecture structural of gtxwrapper is		
	--======================== signal declarations ========================--
	attribute max_fanout : string; 
	-- register reclarations:
   signal  gtx0_txresetdone_r              	: std_logic;
   signal  gtx0_txresetdone_r2             	: std_logic;
   signal  gtx0_rxresetdone_i_r            	: std_logic;
   signal  gtx0_rxresetdone_r              	: std_logic;
   signal  gtx0_rxresetdone_r2             	: std_logic;
   signal  gtx0_rxresetdone_r3             	: std_logic;
   attribute max_fanout of gtx0_rxresetdone_i_r : signal is "1";	
	-- receive ports - rx data path interface:
	signal  gtx0_rxdata_i                   	: std_logic_vector(19 downto 0);
	signal  gtx0_rxrecclk_i                 	: std_logic;
	-- receive ports - rx elastic buffer and phase alignment ports:
	signal  gtx0_rxdlyaligndisable_i        	: std_logic;
	signal  gtx0_rxdlyalignmonenb_i         	: std_logic;
	signal  gtx0_rxdlyalignmonitor_i        	: std_logic_vector(7 downto 0);
	signal  gtx0_rxdlyalignoverride_i       	: std_logic;
	signal  gtx0_rxdlyalignreset_i          	: std_logic;
	signal  gtx0_rxenpmaphasealign_i        	: std_logic;
	signal  gtx0_rxpmasetphase_i            	: std_logic;
	-- receive ports - rx pll ports:
	signal  gtx0_gtxrxreset_i               	: std_logic;
	signal  gtx0_pllrxreset_i               	: std_logic;
	signal  gtx0_rxplllkdet_i               	: std_logic;
	signal  gtx0_rxresetdone_i              	: std_logic;
	-- transmit ports - tx data path interface:
	signal  gtx0_txdata_i                  	: std_logic_vector(19 downto 0);
	-- transmit ports - tx elastic buffer and phase alignment ports:
	signal  gtx0_txdlyaligndisable_i       	: std_logic;
	signal  gtx0_txdlyalignmonenb_i        	: std_logic;
	signal  gtx0_txdlyalignmonitor_i       	: std_logic_vector(7 downto 0);
	signal  gtx0_txdlyalignreset_i         	: std_logic;
	signal  gtx0_txenpmaphasealign_i       	: std_logic;
	signal  gtx0_txpmasetphase_i           	: std_logic;
	-- transmit ports - tx pll ports:			
	signal  gtx0_gtxtxreset_i              	: std_logic;
	signal  gtx0_plltxreset_i              	: std_logic;
	signal  gtx0_txplllkdet_i              	: std_logic;
	signal  gtx0_txresetdone_i             	: std_logic;		
	-- user clocks:			
	signal  gtx0_rxusrclk2_i               	: std_logic;
	-- reference clocks:  			
	signal  q4_clk0_refclk_i             		: std_logic;	
	-- sync module signals:				
   signal  gtx0_rx_sync_done_i          		: std_logic;
   signal  gtx0_reset_rxsync_c          		: std_logic;
   signal  gtx0_tx_sync_done_i          		: std_logic;
   signal  gtx0_reset_txsync_c          		: std_logic;
	--=====================================================================--		
	--========================================================================--
-----		  --===================================================--
begin		--================== architecture body ==================-- 
-----		  --===================================================--
--========================================================================--
	--======================== signal assignments =========================--	
   gtx_rxusrclk2_o                           <= gtx0_rxusrclk2_i;        
	gtx_resetdone_o									<= (gtx0_rxresetdone_r3 and gtx0_txresetdone_r2); 
   gtx_phasealigndone_o 							<= (gtx0_tx_sync_done_i and gtx0_rx_sync_done_i); 
  	--=====================================================================--		
	--============================ user logic =============================--
	-- bitslip control:
	bitslipcontrol: entity work.bitslip_control 
		port map (
			reset_i 										=> gtx_rx_reset_i,
			rxwordclk_i									=> gtx0_rxusrclk2_i,
			numbitslips_i 								=> gtx_rx_slide_nbr_i,
			enable_i 									=> gtx_rx_slide_run_i,
			bitslip_o 									=> gtx_rx_slide_o
		);	
	-- synchronizers (for asynchronous inputs):	
	process(gtx0_rxusrclk2_i)
   begin
      if(gtx0_rxusrclk2_i'event and gtx0_rxusrclk2_i = '1') then
         gtx0_rxresetdone_i_r  					<= gtx0_rxresetdone_i;
      end if; 
   end process; 
	
   process(gtx0_rxusrclk2_i,gtx0_rxresetdone_i_r)
   begin
      if(gtx0_rxresetdone_i_r = '0') then
         gtx0_rxresetdone_r    					<= '0';
         gtx0_rxresetdone_r2   					<= '0';
      elsif(gtx0_rxusrclk2_i'event and gtx0_rxusrclk2_i = '1') then
         gtx0_rxresetdone_r    					<= gtx0_rxresetdone_i_r;
         gtx0_rxresetdone_r2   					<= gtx0_rxresetdone_r;
      end if;
   end process;

   process(gtx0_rxusrclk2_i)
   begin
      if(gtx0_rxusrclk2_i'event and gtx0_rxusrclk2_i = '1') then
         gtx0_rxresetdone_r3  					<= gtx0_rxresetdone_r2;
      end if; 
   end process; 

   process(gtx_txusrclk2_i,gtx0_txresetdone_i)
   begin
      if(gtx0_txresetdone_i = '0') then
         gtx0_txresetdone_r  						<= '0';
         gtx0_txresetdone_r2 						<= '0';
      elsif(gtx_txusrclk2_i'event and gtx_txusrclk2_i = '1') then
         gtx0_txresetdone_r  						<= gtx0_txresetdone_i;
         gtx0_txresetdone_r2 						<= gtx0_txresetdone_r;
      end if;
   end process;	
	--=====================================================================--		
	--===================== component instantiations ======================--
	-- RX Clock buffer:
	rxusrclk_bufg : bufg
		port map(
			o 												=> gtx0_rxusrclk2_i, 
			i 												=> gtx0_rxrecclk_i  
		);
	-- gtx synchronization modules:
		-- tx sync:
		txsync: entity work.buffbypassgtx_tx_sync
			generic map(
				sim_txpmasetphase_speedup       	=> 0)
			port map(	
				txenpmaphasealign               	=> gtx0_txenpmaphasealign_i,
				txpmasetphase                   	=> gtx0_txpmasetphase_i,
				txdlyaligndisable               	=> gtx0_txdlyaligndisable_i,
				txdlyalignreset                 	=> gtx0_txdlyalignreset_i,
				sync_done                       	=> gtx0_tx_sync_done_i,
				user_clk                        	=> gtx_txusrclk2_i,
				reset                           	=> gtx0_reset_txsync_c
			);
			gtx0_reset_txsync_c 	 					<=  (not gtx0_txresetdone_r2) or gtx_tx_sync_reset_i;
		-- rx sync:
		rxsync: entity work.buffbypassgtx_rx_sync
			port map(
				rxenpmaphasealign               	=> gtx0_rxenpmaphasealign_i,
				rxpmasetphase                   	=> gtx0_rxpmasetphase_i,
				rxdlyaligndisable               	=> gtx0_rxdlyaligndisable_i,
				rxdlyalignoverride              	=> gtx0_rxdlyalignoverride_i,
				rxdlyalignreset                 	=> gtx0_rxdlyalignreset_i,
				sync_done                       	=> gtx0_rx_sync_done_i,
				user_clk                        	=> gtx0_rxusrclk2_i,
				reset                           	=> gtx0_reset_rxsync_c
			);	 
			gtx0_reset_rxsync_c    					<= (not gtx0_rxresetdone_r3) or gtx_rx_sync_reset_i;	
	-- gtx(mgt):	
	gtx: entity work.buffbypassgtx
		generic map (
			WRAPPER_SIM_GTXRESET_SPEEDUP    	=>  0)
		port map (
			------------------------ Loopback and Powerdown Ports ----------------------
			GTX0_LOOPBACK_IN                		=> gtx_loopback_i,
			GTX0_RXPOWERDOWN_IN             		=> gtx_tx_powerdown_i,
			GTX0_TXPOWERDOWN_IN             		=> gtx_rx_powerdown_i,
			--------------- Receive Ports - Comma Detection and Alignment --------------
			GTX0_RXSLIDE_IN                		=> gtx_rx_slide_i,
         ----------------------- Receive Ports - PRBS Detection ---------------------
         GTX0_PRBSCNTRESET_IN           	   => GTX_PRBSCNTRESET_I,
         GTX0_RXENPRBSTST_IN            	   => GTX_RXENPRBSTST_I,
         GTX0_RXPRBSERR_OUT              	   => GTX_RXPRBSERR_O,
			------------------- Receive Ports - RX Data Path interface -----------------
			GTX0_RXDATA_OUT                 		=> gtx_rx_data_o,
			GTX0_RXRECCLK_OUT               		=> gtx0_rxrecclk_i,
			GTX0_RXUSRCLK2_IN               		=> gtx0_rxusrclk2_i,
			------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
			GTX0_RXEQMIX_IN                 		=> gtx_rxeqmix_i,
			GTX0_RXN_IN                     		=> gtx_rxn_i,
			GTX0_RXP_IN                     		=> gtx_rxp_i,
			-------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
			GTX0_RXDLYALIGNDISABLE_IN       		=> gtx0_rxdlyaligndisable_i,
			GTX0_RXDLYALIGNMONENB_IN        		=> gtx0_rxdlyalignmonenb_i,
			GTX0_RXDLYALIGNMONITOR_OUT      		=> gtx0_rxdlyalignmonitor_i,
			GTX0_RXDLYALIGNOVERRIDE_IN      		=> gtx0_rxdlyalignoverride_i,
			GTX0_RXDLYALIGNRESET_IN         		=> gtx0_rxdlyalignreset_i,
			GTX0_RXENPMAPHASEALIGN_IN       		=> gtx0_rxenpmaphasealign_i,
			GTX0_RXPMASETPHASE_IN           		=> gtx0_rxpmasetphase_i,
			------------------------ Receive Ports - RX PLL Ports ----------------------
			GTX0_GTXRXRESET_IN              		=> gtx_rx_reset_i,
			GTX0_MGTREFCLKRX_IN             		=> gtx_rx_refclk_i,
			GTX0_PLLRXRESET_IN              		=> gtx0_pllrxreset_i,
			GTX0_RXPLLLKDET_OUT             		=> gtx0_rxplllkdet_i,
			GTX0_RXRESETDONE_OUT            		=> gtx0_rxresetdone_i,
			----------------- Receive Ports - RX Polarity Control Ports ----------------
			GTX0_RXPOLARITY_IN              		=> gtx_rxpolarity_i,
			------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
			GTX0_DADDR_IN                   		=> gtx_daddr_i,
			GTX0_DCLK_IN                    		=> gtx_dclk_i,
			GTX0_DEN_IN                     		=> gtx_den_i,
			GTX0_DI_IN                      		=> gtx_di_i,
			GTX0_DRDY_OUT                   		=> gtx_drdy_o,
			GTX0_DRPDO_OUT                  		=> gtx_drpdo_o,
			GTX0_DWE_IN                     		=> gtx_dwe_i,
			------------------ Transmit Ports - TX Data Path interface -----------------
			GTX0_TXDATA_IN                  		=> gtx_tx_data_i,
			GTX0_TXOUTCLK_OUT               		=> gtx_txoutclk_o,
			GTX0_TXUSRCLK2_IN               		=> gtx_txusrclk2_i,
			---------------- Transmit Ports - TX Driver and OOB signaling --------------
			GTX0_TXDIFFCTRL_IN              		=> gtx_txdiffctrl_i,
			GTX0_TXN_OUT                    		=> gtx_txn_o,
			GTX0_TXP_OUT                    		=> gtx_txp_o,
			GTX0_TXPOSTEMPHASIS_IN          		=> gtx_txpostemphasis_i,
			--------------- Transmit Ports - TX Driver and OOB signalling --------------
			GTX0_TXPREEMPHASIS_IN           		=> gtx_txpreemphasis_i,
			-------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
			GTX0_TXDLYALIGNDISABLE_IN       		=> gtx0_txdlyaligndisable_i,
			GTX0_TXDLYALIGNMONENB_IN        		=> gtx0_txdlyalignmonenb_i,
			GTX0_TXDLYALIGNMONITOR_OUT      		=> gtx0_txdlyalignmonitor_i,
			GTX0_TXDLYALIGNRESET_IN         		=> gtx0_txdlyalignreset_i,
			GTX0_TXENPMAPHASEALIGN_IN       		=> gtx0_txenpmaphasealign_i,
			GTX0_TXPMASETPHASE_IN           		=> gtx0_txpmasetphase_i,
			----------------------- Transmit Ports - TX PLL Ports ----------------------
			GTX0_GTXTXRESET_IN              		=> gtx_tx_reset_i,
			GTX0_MGTREFCLKTX_IN             		=> gtx_tx_refclk_i,
			GTX0_PLLTXRESET_IN              		=> gtx0_plltxreset_i,
			GTX0_TXPLLLKDET_OUT             		=> gtx0_txplllkdet_i,
			GTX0_TXRESETDONE_OUT            		=> gtx0_txresetdone_i,
         --------------------- Transmit Ports - TX PRBS Generator -------------------
         GTX0_TXENPRBSTST_IN               	=> gtx_txenprbstst_i,           
         GTX0_TXPRBSFORCEERR_IN            	=> gtx_txprbsforceerr_i,
			-------------------- Transmit Ports - TX Polarity Control ------------------
			GTX0_TXPOLARITY_IN              		=> gtx_txpolarity_i     
		);	
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--