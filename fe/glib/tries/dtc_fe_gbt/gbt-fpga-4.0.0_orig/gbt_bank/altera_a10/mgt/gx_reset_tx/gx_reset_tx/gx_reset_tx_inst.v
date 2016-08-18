	gx_reset_tx u0 (
		.clock           (<connected-to-clock>),           //           clock.clk
		.pll_locked      (<connected-to-pll_locked>),      //      pll_locked.pll_locked
		.pll_select      (<connected-to-pll_select>),      //      pll_select.pll_select
		.reset           (<connected-to-reset>),           //           reset.reset
		.tx_analogreset  (<connected-to-tx_analogreset>),  //  tx_analogreset.tx_analogreset
		.tx_cal_busy     (<connected-to-tx_cal_busy>),     //     tx_cal_busy.tx_cal_busy
		.tx_digitalreset (<connected-to-tx_digitalreset>), // tx_digitalreset.tx_digitalreset
		.tx_ready        (<connected-to-tx_ready>)         //        tx_ready.tx_ready
	);

