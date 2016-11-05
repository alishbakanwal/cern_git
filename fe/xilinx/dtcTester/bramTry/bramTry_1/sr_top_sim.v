
`timescale 1ns / 1ps
`define CYCLE 20 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:50 12/16/2015 
// Design Name: 
// Module Name:    sr_top_sim 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sr_top_sim;

	reg clk_in;
	wire sr_out, clk_4;
	
	sr_top #(4)srTOP(
		.clk_in(clk_in),
		.sr_out(sr_out),
		.clk_4(clk_4)
		);
		
	always
	begin
		#(`CYCLE/2) clk_in = ~clk_in;
	end
	
	initial
	begin
		clk_in = 1;		
	end

endmodule
