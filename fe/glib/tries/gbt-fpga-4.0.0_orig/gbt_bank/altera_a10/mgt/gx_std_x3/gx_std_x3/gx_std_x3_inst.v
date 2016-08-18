	gx_std_x3 u0 (
		.reconfig_write          (<connected-to-reconfig_write>),          //           reconfig_avmm.write
		.reconfig_read           (<connected-to-reconfig_read>),           //                        .read
		.reconfig_address        (<connected-to-reconfig_address>),        //                        .address
		.reconfig_writedata      (<connected-to-reconfig_writedata>),      //                        .writedata
		.reconfig_readdata       (<connected-to-reconfig_readdata>),       //                        .readdata
		.reconfig_waitrequest    (<connected-to-reconfig_waitrequest>),    //                        .waitrequest
		.reconfig_clk            (<connected-to-reconfig_clk>),            //            reconfig_clk.clk
		.reconfig_reset          (<connected-to-reconfig_reset>),          //          reconfig_reset.reset
		.rx_analogreset          (<connected-to-rx_analogreset>),          //          rx_analogreset.rx_analogreset
		.rx_cal_busy             (<connected-to-rx_cal_busy>),             //             rx_cal_busy.rx_cal_busy
		.rx_cdr_refclk0          (<connected-to-rx_cdr_refclk0>),          //          rx_cdr_refclk0.clk
		.rx_clkout               (<connected-to-rx_clkout>),               //               rx_clkout.clk
		.rx_coreclkin            (<connected-to-rx_coreclkin>),            //            rx_coreclkin.clk
		.rx_digitalreset         (<connected-to-rx_digitalreset>),         //         rx_digitalreset.rx_digitalreset
		.rx_is_lockedtodata      (<connected-to-rx_is_lockedtodata>),      //      rx_is_lockedtodata.rx_is_lockedtodata
		.rx_is_lockedtoref       (<connected-to-rx_is_lockedtoref>),       //       rx_is_lockedtoref.rx_is_lockedtoref
		.rx_parallel_data        (<connected-to-rx_parallel_data>),        //        rx_parallel_data.rx_parallel_data
		.rx_polinv               (<connected-to-rx_polinv>),               //               rx_polinv.rx_polinv
		.rx_serial_data          (<connected-to-rx_serial_data>),          //          rx_serial_data.rx_serial_data
		.rx_seriallpbken         (<connected-to-rx_seriallpbken>),         //         rx_seriallpbken.rx_seriallpbken
		.tx_analogreset          (<connected-to-tx_analogreset>),          //          tx_analogreset.tx_analogreset
		.tx_bonding_clocks       (<connected-to-tx_bonding_clocks>),       //       tx_bonding_clocks.clk
		.tx_cal_busy             (<connected-to-tx_cal_busy>),             //             tx_cal_busy.tx_cal_busy
		.tx_clkout               (<connected-to-tx_clkout>),               //               tx_clkout.clk
		.tx_coreclkin            (<connected-to-tx_coreclkin>),            //            tx_coreclkin.clk
		.tx_digitalreset         (<connected-to-tx_digitalreset>),         //         tx_digitalreset.tx_digitalreset
		.tx_parallel_data        (<connected-to-tx_parallel_data>),        //        tx_parallel_data.tx_parallel_data
		.tx_polinv               (<connected-to-tx_polinv>),               //               tx_polinv.tx_polinv
		.tx_serial_data          (<connected-to-tx_serial_data>),          //          tx_serial_data.tx_serial_data
		.unused_rx_parallel_data (<connected-to-unused_rx_parallel_data>), // unused_rx_parallel_data.unused_rx_parallel_data
		.unused_tx_parallel_data (<connected-to-unused_tx_parallel_data>)  // unused_tx_parallel_data.unused_tx_parallel_data
	);

