
module frameclk_pll (
	cntsel,
	locked,
	num_phase_shifts,
	outclk_0,
	phase_done,
	phase_en,
	refclk,
	rst,
	scanclk,
	updn);	

	input	[4:0]	cntsel;
	output		locked;
	input	[2:0]	num_phase_shifts;
	output		outclk_0;
	output		phase_done;
	input		phase_en;
	input		refclk;
	input		rst;
	input		scanclk;
	input		updn;
endmodule
