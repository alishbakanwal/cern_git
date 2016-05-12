
module gx_latopt_x2 (
	tx_analogreset,
	tx_digitalreset,
	rx_analogreset,
	rx_digitalreset,
	tx_cal_busy,
	rx_cal_busy,
	rx_cdr_refclk0,
	tx_serial_data,
	rx_serial_data,
	rx_is_lockedtoref,
	rx_is_lockedtodata,
	tx_coreclkin,
	rx_coreclkin,
	tx_clkout,
	rx_clkout,
	tx_parallel_data,
	rx_parallel_data,
	unused_tx_parallel_data,
	unused_rx_parallel_data,
	tx_bonding_clocks,
	rx_seriallpbken,
	rx_pma_clkslip,
	rx_polinv,
	tx_polinv,
	reconfig_clk,
	reconfig_reset,
	reconfig_write,
	reconfig_read,
	reconfig_address,
	reconfig_writedata,
	reconfig_readdata,
	reconfig_waitrequest);	

	input	[1:0]	tx_analogreset;
	input	[1:0]	tx_digitalreset;
	input	[1:0]	rx_analogreset;
	input	[1:0]	rx_digitalreset;
	output	[1:0]	tx_cal_busy;
	output	[1:0]	rx_cal_busy;
	input		rx_cdr_refclk0;
	output	[1:0]	tx_serial_data;
	input	[1:0]	rx_serial_data;
	output	[1:0]	rx_is_lockedtoref;
	output	[1:0]	rx_is_lockedtodata;
	input	[1:0]	tx_coreclkin;
	input	[1:0]	rx_coreclkin;
	output	[1:0]	tx_clkout;
	output	[1:0]	rx_clkout;
	input	[39:0]	tx_parallel_data;
	output	[39:0]	rx_parallel_data;
	input	[215:0]	unused_tx_parallel_data;
	output	[215:0]	unused_rx_parallel_data;
	input	[11:0]	tx_bonding_clocks;
	input	[1:0]	rx_seriallpbken;
	input	[1:0]	rx_pma_clkslip;
	input	[1:0]	rx_polinv;
	input	[1:0]	tx_polinv;
	input	[0:0]	reconfig_clk;
	input	[0:0]	reconfig_reset;
	input	[0:0]	reconfig_write;
	input	[0:0]	reconfig_read;
	input	[10:0]	reconfig_address;
	input	[31:0]	reconfig_writedata;
	output	[31:0]	reconfig_readdata;
	output	[0:0]	reconfig_waitrequest;
endmodule
