// alt_a10_lpm_shiftreg.v

// Generated using ACDS version 15.1 185

`timescale 1 ps / 1 ps
module alt_a10_lpm_shiftreg (
		input  wire  clock,    //  lpm_shiftreg_input.clock
		input  wire  shiftin,  //                    .shiftin
		output wire  shiftout  // lpm_shiftreg_output.shiftout
	);

	alt_a10_lpm_shiftreg_lpm_shiftreg_151_m6wkfty lpm_shiftreg_0 (
		.clock    (clock),    //  lpm_shiftreg_input.clock
		.shiftin  (shiftin),  //                    .shiftin
		.shiftout (shiftout)  // lpm_shiftreg_output.shiftout
	);

endmodule