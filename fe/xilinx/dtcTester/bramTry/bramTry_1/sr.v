
// this module is for a generic n-bit parallel-to-serial converter
// also referred to as 'shifter'

`timescale 1ns / 1ps

module sr #(parameter n = 4) (
	input [n-1:0] sr_in,
	input clk, rst,  // this reset is to load new data into the shift register
	output reg sr_out
    );
	
	reg [n-1:0] sr_temp;
	//
	reg [2:0] i;
	
	always@(posedge clk or posedge rst)
	begin
		if(rst)
			// sr_temp <= {sr_in[0], sr_in[n-1:1]};  // put in shifted value to avoid wasted clock cycle
			// don't shift @rst, read out first value
		
			sr_temp <= sr_in;  // load new data
			
		else
			sr_temp <= {sr_temp[0], sr_temp[n-1:1]};  // shift loaded data N times
	end
	
	always@(posedge clk)
	begin
		// sr_out <= sr_temp[n-1];
		sr_out <= sr_temp[0];
	end
	
endmodule
