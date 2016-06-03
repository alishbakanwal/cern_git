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
	output [31:0] eport_out
    );
	 
	
	// register bank to store CIC data coming @320MHz
	// register back is sampled @40MHz
	reg [31:0] cicreg_0;
	
	
	//
	// counter8
	//
	
	always@(posedge clk_320)
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
	
	always@(posedge clk_320)
	begin
		// CIC line0
		case(counter8)
			0: begin
					cicreg_0[0] <= eport_in[0];
					cicreg_0[1] <= eport_in[1];
					cicreg_0[2] <= eport_in[2];
					cicreg_0[3] <= eport_in[3];
				end
				
			1: begin
					cicreg_0[4] <= eport_in[0];
					cicreg_0[5] <= eport_in[1];
					cicreg_0[6] <= eport_in[2];
					cicreg_0[7] <= eport_in[3];
				end
				
			2: begin
					cicreg_1[8] <= eport_in[0];
					cicreg_1[9] <= eport_in[1];
					cicreg_1[10] <= eport_in[2];
					cicreg_1[11] <= eport_in[3];
				end
				
			3: begin
					cicreg_1[12] <= eport_in[0];
					cicreg_1[13] <= eport_in[1];
					cicreg_1[14] <= eport_in[2];
					cicreg_1[15] <= eport_in[3];
				end
					
			4: begin
					cicreg_2[16] <= eport_in[0];
					cicreg_2[17] <= eport_in[1];
					cicreg_2[18] <= eport_in[2];
					cicreg_2[19] <= eport_in[3];
				end
				
			5: begin
					cicreg_2[20] <= eport_in[0];
					cicreg_2[21] <= eport_in[1];
					cicreg_2[22] <= eport_in[2];
					cicreg_2[23] <= eport_in[3];
				end
			
			6: begin
					cicreg_2[24] <= eport_in[0];
					cicreg_2[25] <= eport_in[1];
					cicreg_2[26] <= eport_in[2];
					cicreg_2[27] <= eport_in[3];
				end
				
			7: begin
					cicreg_2[28] <= eport_in[0];
					cicreg_2[29] <= eport_in[1];
					cicreg_2[30] <= eport_in[2];
					cicreg_2[31] <= eport_in[3];
				end

		endcase
		
	end

endmodule
