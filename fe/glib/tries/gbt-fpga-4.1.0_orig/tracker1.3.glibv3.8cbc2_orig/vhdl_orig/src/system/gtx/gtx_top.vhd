library ieee;
use ieee.std_logic_1164.all;
use work.gtx_package.all;
entity gtx_top is
port
(
	ext_tx_reset	: in 		std_logic;
	ext_rx_reset	: in 		std_logic;
	gtx_i				: in		gtx_in	;
	gtx_o				: out		gtx_out
);                    	
end gtx_top;

architecture gtx_top_arch of gtx_top is

begin -- architecture


		--====--
			gtx: entity work.gtxWrapper
		--====--
		port map 
		(
			gtx_loopback_i			=> gtx_i.loopback			,
			gtx_tx_powerdown_i	=> gtx_i.tx_powerdown	,
			gtx_rx_powerdown_i	=> gtx_i.rx_powerdown	,
			gtx_resetdone_o 		=> gtx_o.resetdone 		,
			gtx_phasealingdone_o	=> gtx_o.phasealingdone	,
			--                           
			gtx_rxp_i 				=> gtx_i.rxp 				,
			gtx_rxn_i 				=> gtx_i.rxn 				,
			gtx_tx_refclk_i		=> gtx_i.tx_refclk		, 		
			gtx_rx_refclk_i		=> gtx_i.rx_refclk		,		
			gtx_tx_reset_i 		=>(gtx_i.tx_reset 		or ext_tx_reset),
			gtx_rx_reset_i 		=>(gtx_i.rx_reset 		or ext_rx_reset),
			gtx_tx_sync_reset_i 	=> gtx_i.tx_sync_reset 	,
			gtx_rx_sync_reset_i	=> gtx_i.rx_sync_reset	,
			gtx_tx_data_i 			=> gtx_i.tx_data 			,
			--                           
			gtx_rx_slide_i			=> gtx_i.rx_slide			,
			gtx_rx_slide_run_i	=> gtx_i.rx_slide_run	,
			gtx_rx_slide_nbr_i	=> gtx_i.rx_slide_nbr	,
			gtx_rx_slide_o			=> gtx_o.rx_slide			,
			--                           
			gtx_txp_o 				=> gtx_o.txp 				,
			gtx_txn_o 				=> gtx_o.txn 				,
			gtx_tx_wordclk_o 		=> gtx_o.tx_wordclk 		,
			gtx_rx_wordclk_o 		=> gtx_o.rx_wordclk 		,
			gtx_rx_data_o 			=> gtx_o.rx_data 	      ,	

			gtx_txdiffctrl_i		=> gtx_i.conf_diff		,
         gtx_txpostemphasis_i	=> gtx_i.conf_pstemph	,
         gtx_txpreemphasis_i	=> gtx_i.conf_preemph	,	
         gtx_rxeqmix_i			=> gtx_i.conf_eqmix  	,
         gtx_rxpolarity_i		=> gtx_i.conf_rxpol	   ,
         gtx_txpolarity_i		=>	gtx_i.conf_txpol     ,
        	
         gtx_daddr_i          => gtx_i.drp_daddr  	   , 
         gtx_dclk_i           => gtx_i.drp_dclk   	   ,
         gtx_den_i            => gtx_i.drp_den      	,
         gtx_di_i             => gtx_i.drp_di       	,
         gtx_drdy_o           => gtx_o.drp_drdy       ,
         gtx_drpdo_o          => gtx_o.drp_drpdo      ,
			gtx_dwe_i            => gtx_i.drp_dwe        ,

         gtx_txenprbstst_i    => gtx_i.prbs_txen      , 
         gtx_rxenprbstst_i    => gtx_i.prbs_rxen      ,
         gtx_txprbsforceerr_i => gtx_i.prbs_forcerr   ,
         gtx_rxprbserr_o      => gtx_o.prbs_rxerr     ,
         gtx_prbscntreset_i   => gtx_i.prbs_errcntrst
          
		);
end gtx_top_arch;