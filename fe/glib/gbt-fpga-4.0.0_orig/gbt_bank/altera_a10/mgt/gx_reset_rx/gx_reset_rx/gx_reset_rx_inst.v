	gx_reset_rx u0 (
		.clock              (<connected-to-clock>),              //              clock.clk
		.reset              (<connected-to-reset>),              //              reset.reset
		.rx_analogreset     (<connected-to-rx_analogreset>),     //     rx_analogreset.rx_analogreset
		.rx_cal_busy        (<connected-to-rx_cal_busy>),        //        rx_cal_busy.rx_cal_busy
		.rx_digitalreset    (<connected-to-rx_digitalreset>),    //    rx_digitalreset.rx_digitalreset
		.rx_is_lockedtodata (<connected-to-rx_is_lockedtodata>), // rx_is_lockedtodata.rx_is_lockedtodata
		.rx_ready           (<connected-to-rx_ready>)            //           rx_ready.rx_ready
	);

