
`timescale 1ns / 1ps
`define CYCLE 20

module counter_sim();

	reg clk, rst;
	wire counter_out;

	counter #(2) counter_sim_1(
		.clk(clk),
		.rst(rst),
		.counter_out(counter_out)
    );
	 
	 always
	 begin
		#(`CYCLE/2) clk = ~clk;
	 end
	 
	 initial
	 begin
		clk = 1;
		rst = 1;
		#(`CYCLE*4) rst = 0;
	 end

endmodule
