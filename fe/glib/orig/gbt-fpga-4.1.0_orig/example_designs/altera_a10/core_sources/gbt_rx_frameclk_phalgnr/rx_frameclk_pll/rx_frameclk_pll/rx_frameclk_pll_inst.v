	rx_frameclk_pll u0 (
		.cntsel           (<connected-to-cntsel>),           //           cntsel.cntsel
		.locked           (<connected-to-locked>),           //           locked.export
		.num_phase_shifts (<connected-to-num_phase_shifts>), // num_phase_shifts.num_phase_shifts
		.outclk_0         (<connected-to-outclk_0>),         //          outclk0.clk
		.phase_done       (<connected-to-phase_done>),       //       phase_done.phase_done
		.phase_en         (<connected-to-phase_en>),         //         phase_en.phase_en
		.refclk           (<connected-to-refclk>),           //           refclk.clk
		.rst              (<connected-to-rst>),              //            reset.reset
		.scanclk          (<connected-to-scanclk>),          //          scanclk.scanclk
		.updn             (<connected-to-updn>)              //             updn.updn
	);

