config latoptimized_measurements_cfg;
		design latoptimized_measurements;
		instance latoptimized_measurements.latmeas use latoptimized_measurements_altera_avalon_pio_151.latoptimized_measurements_altera_avalon_pio_151_ncho5eq;
		instance latoptimized_measurements.master_0 use latoptimized_measurements_altera_jtag_avalon_master_151.latoptimized_measurements_altera_jtag_avalon_master_151_nxrcxoa;
		instance latoptimized_measurements.resetctrl use latoptimized_measurements_altera_avalon_pio_151.latoptimized_measurements_altera_avalon_pio_151_ivk373a;
		instance latoptimized_measurements.mm_interconnect_0 use latoptimized_measurements_altera_mm_interconnect_151.latoptimized_measurements_altera_mm_interconnect_151_imtdqaa;
		instance latoptimized_measurements.rst_controller use latoptimized_measurements_altera_reset_controller_151.altera_reset_controller;
endconfig
