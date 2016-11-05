
`timescale 1ns / 1ps

module counter_updated #(parameter n = 2)(
	input clk, rst,  // model rst as a vio signal
	output reg counter_out
    );
	 
	 reg [2:0]flag;  // since has to count to 4
	
	always@(posedge clk)
	begin
		if(rst)
		begin
			counter_out <= 0;
			flag <= 0;
		end
			
		else
		begin
			flag <= flag + 1;
			
			if(flag > 4)
				counter_out <= 1;
				
			else
			begin
				counter_out <= 0;
				flag <= 0;
			end
		end
	end

endmodule
