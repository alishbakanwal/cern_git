// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  alt_a10_lpm_shiftreg_lpm_shiftreg_151_m6wkfty  (
	clock,
	shiftin,
	shiftout);

	input	  clock;
	input	  shiftin;
	output	shiftout;

	wire sub_wire0;
	wire shiftout = sub_wire0;

	lpm_shiftreg  LPM_SHIFTREG_component (
				.clock (clock),
				.shiftin (shiftin),
				.shiftout (sub_wire0)
				// synopsys translate_off
				,
				.aclr (),
				.aset (),
				.data (),
				.enable (),
				.load (),
				.q (),
				.sclr (),
				.sset ()
				// synopsys translate_on
				);
	defparam
		LPM_SHIFTREG_component.lpm_direction  = "LEFT",
		LPM_SHIFTREG_component.lpm_type  = "LPM_SHIFTREG",
		LPM_SHIFTREG_component.lpm_width  = 16;


endmodule


