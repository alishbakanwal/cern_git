`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:34 11/20/2015 
// Design Name: 
// Module Name:    counter_icon_test 
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
module counter_icon_test (input clk);
	// These wires are hooked up to vio below
	wire incr, rst;
	wire [15:0] count;
	counter #(16) countone(.clk(clk), .incr(incr), .rst(rst),
	.count(count));
	
	//------------------------------------------------------------
	// ICON core wire declarations
	//------------------------------------------------------------
	wire [35:0] control0;
	wire [35:0] control1;

	//------------------------------------------------------------
	// VIO Core wire declarations
	//------------------------------------------------------------
	

	wire [31:0] sync_in;
	wire [31:0] sync_out;
	
	// Next 3 lines are explained in next section
	
	assign rst = sync_out[0];
	assign incr = sync_out[1];
	assign sync_in = {16'b0, count};
	
	//------------------------------------------------------------
	// ILA Core wire declarations
	//------------------------------------------------------------
	
	wire [31:0] trig0;
	
	// Next line is explained in next section
	
	assign trig0 = {14'b0, count, incr, rst};
	
	//------------------------------------------------------------
	// ICON core instance (from icon_xst_example.v)
	//------------------------------------------------------------
	
	icon i_icon (.CONTROL0(control0), .CONTROL1(control1));
	
	//------------------------------------------------------------
	// VIO core instance (from vio_xst_example.v)
	//------------------------------------------------------------
	
	vio i_vio (.CONTROL(control0), .CLK(clk), .SYNC_IN(sync_in),
	.SYNC_OUT(sync_out));
	
	//------------------------------------------------------------
	// ILA core instance (from ila_xst_example.v)
	//------------------------------------------------------------
	
	ila i_ila (.CONTROL(control1), .CLK(clk), .TRIG0(trig0));

endmodule
