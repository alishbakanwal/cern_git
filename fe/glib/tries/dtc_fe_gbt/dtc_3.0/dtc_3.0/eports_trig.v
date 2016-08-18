`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:10 04/29/2016 
// Design Name: 
// Module Name:    e-ports 
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
module eports_trig(
	input clk,
	input [3:0] eport_in,
	output reg [31:0] eport_out,  // register bank
	output reg [2:0] counter8
    );
	 
	
	// register bank to store CIC data coming @320MHz
	// register back is sampled @40MHz
	
	
	//
	// counter8
	//
	
	// reg [2:0] counter8;
	reg count8;
	
	always@(posedge clk)
	begin
		counter8 <= counter8 + 1;
		count8 <= 0;
		
		if(counter8 == 7)
		begin
			counter8 <= 0;
			count8 <= 1;
		end
	end

	//
   // CIC logic
	//
	
	always@(posedge clk)  // register loaded @320MHz
	begin							  // register will be sampled @40MHz
		// CIC line0
		
		case(counter8)  // indicates 8 clk cycles of clk320
			0: begin
			
					eport_out[0] <= eport_in[0];
					eport_out[1] <= eport_in[1];
					eport_out[2] <= eport_in[2];
					eport_out[3] <= eport_in[3];
					
					//eport_out[3:0] <= eport_in[3:0];
				end
				
			1: begin
					eport_out[4] <= eport_in[0];
					eport_out[5] <= eport_in[1];
					eport_out[6] <= eport_in[2];
					eport_out[7] <= eport_in[3];
				end
				
			2: begin
					eport_out[8] <= eport_in[0];
					eport_out[9] <= eport_in[1];
					eport_out[10] <= eport_in[2];
					eport_out[11] <= eport_in[3];
				end
				
			3: begin
					eport_out[12] <= eport_in[0];
					eport_out[13] <= eport_in[1];
					eport_out[14] <= eport_in[2];
					eport_out[15] <= eport_in[3];
				end
					
			4: begin
					eport_out[16] <= eport_in[0];
					eport_out[17] <= eport_in[1];
					eport_out[18] <= eport_in[2];
					eport_out[19] <= eport_in[3];
				end
				
			5: begin
					eport_out[20] <= eport_in[0];
					eport_out[21] <= eport_in[1];
					eport_out[22] <= eport_in[2];
					eport_out[23] <= eport_in[3];
				end
			
			6: begin
					eport_out[24] <= eport_in[0];
					eport_out[25] <= eport_in[1];
					eport_out[26] <= eport_in[2];
					eport_out[27] <= eport_in[3];
				end
				
			7: begin
					eport_out[28] <= eport_in[0];
					eport_out[29] <= eport_in[1];
					eport_out[30] <= eport_in[2];
					eport_out[31] <= eport_in[3];
				end

		endcase

	end
	

endmodule
