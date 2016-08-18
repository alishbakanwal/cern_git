
module gx_std_x6 (
	reconfig_write,
	reconfig_read,
	reconfig_address,
	reconfig_writedata,
	reconfig_readdata,
	reconfig_waitrequest,
	reconfig_clk,
	reconfig_reset,
	rx_analogreset,
	rx_cal_busy,
	rx_cdr_refclk0,
	rx_clkout,
	rx_coreclkin,
	rx_digitalreset,
	rx_is_lockedtodata,
	rx_is_lockedtoref,
	rx_parallel_data,
	rx_polinv,
	rx_serial_data,
	rx_seriallpbken,
	tx_analogreset,
	tx_bonding_clocks,
	tx_cal_busy,
	tx_clkout,
	tx_coreclkin,
	tx_digitalreset,
	tx_parallel_data,
	tx_polinv,
	tx_serial_data,
	unused_rx_parallel_data,
	unused_tx_parallel_data);	

	input	[0:0]	reconfig_write;
	input	[0:0]	reconfig_read;
	input	[12:0]	reconfig_address;
	input	[31:0]	reconfig_writedata;
	output	[31:0]	reconfig_readdata;
	output	[0:0]	reconfig_waitrequest;
	input	[0:0]	reconfig_clk;
	input	[0:0]	reconfig_reset;
	input	[5:0]	rx_analogreset;
	output	[5:0]	rx_cal_busy;
	input		rx_cdr_refclk0;
	output	[5:0]	rx_clkout;
	input	[5:0]	rx_coreclkin;
	input	[5:0]	rx_digitalreset;
	output	[5:0]	rx_is_lockedtodata;
	output	[5:0]	rx_is_lockedtoref;
	output	[119:0]	rx_parallel_data;
	input	[5:0]	rx_polinv;
	input	[5:0]	rx_serial_data;
	input	[5:0]	rx_seriallpbken;
	input	[5:0]	tx_analogreset;
	input	[35:0]	tx_bonding_clocks;
	output	[5:0]	tx_cal_busy;
	output	[5:0]	tx_clkout;
	input	[5:0]	tx_coreclkin;
	input	[5:0]	tx_digitalreset;
	input	[119:0]	tx_parallel_data;
	input	[5:0]	tx_polinv;
	output	[5:0]	tx_serial_data;
	output	[647:0]	unused_rx_parallel_data;
	input	[647:0]	unused_tx_parallel_data;
endmodule
