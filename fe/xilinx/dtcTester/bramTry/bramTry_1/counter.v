
// this counter is to generate a rst signal for the shift register after every 4 clock cycles
// this module gets reset from an external rst signal modelled as a vio


`timescale 1ns / 1ps

module counter #(parameter n = 2)(
	input clk, rst,  // model rst as a vio signal
	output reg counter_out
    );

	reg [n:0] counter_temp; // flag
	
	// counter_out[n-1] is used as a reset for the shift register
	
	always@(posedge clk)
	begin
		if(rst)
		begin
			counter_temp <= 0;
			counter_out <= 0;
		end		
			
		else
		begin
			counter_temp <= counter_temp + 1;
			
			if(counter_temp[n] & counter_temp[0])
			begin
				counter_out <= 1;  // to reset the shift register
				counter_temp[n] <= 0;
			end

			else
				counter_out <= 0;
		end
	end
endmodule
