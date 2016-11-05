`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:50:19 11/20/2015 
// Design Name: 
// Module Name:    counter 
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

module counter(clk, incr, rst, count);

	parameter n = 5;
	input clk, incr, rst;
	output [n-1:0] count;
	
	wire [n-1:0] count;
	wire [n-1:0] next_count = incr ? count + 1 : count;
	
	assign count = rst? 0: (incr? count + 1 : count);
	
endmodule
