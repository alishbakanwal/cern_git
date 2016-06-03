
module gx_reset_rx (
	clock,
	reset,
	rx_analogreset,
	rx_cal_busy,
	rx_digitalreset,
	rx_is_lockedtodata,
	rx_ready);	

	input		clock;
	input		reset;
	output	[0:0]	rx_analogreset;
	input	[0:0]	rx_cal_busy;
	output	[0:0]	rx_digitalreset;
	input	[0:0]	rx_is_lockedtodata;
	output	[0:0]	rx_ready;
endmodule
