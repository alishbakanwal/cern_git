
module gx_reset_tx (
	clock,
	pll_locked,
	pll_select,
	reset,
	tx_analogreset,
	tx_cal_busy,
	tx_digitalreset,
	tx_ready);	

	input		clock;
	input	[0:0]	pll_locked;
	input	[0:0]	pll_select;
	input		reset;
	output	[0:0]	tx_analogreset;
	input	[0:0]	tx_cal_busy;
	output	[0:0]	tx_digitalreset;
	output	[0:0]	tx_ready;
endmodule
