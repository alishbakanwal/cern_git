
module mgt_pll (
	mcgb_rst,
	pll_cal_busy,
	pll_locked,
	pll_powerdown,
	pll_refclk0,
	tx_bonding_clocks,
	tx_serial_clk);	

	input		mcgb_rst;
	output		pll_cal_busy;
	output		pll_locked;
	input		pll_powerdown;
	input		pll_refclk0;
	output	[5:0]	tx_bonding_clocks;
	output		tx_serial_clk;
endmodule
