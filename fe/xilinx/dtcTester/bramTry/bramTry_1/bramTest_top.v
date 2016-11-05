`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:04 11/23/2015 
// Design Name: 
// Module Name:    bramTest_top 
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

module bramTest_top(
	input clk
    );
	 
	wire [35:0] control_0, control_1;
	wire [15:0] sync_in, sync_out;
	wire [15:0] trig;
	wire wea;
	
	wire [7:0] dina, douta;
	wire [1:0] addra;
	
	wire incr; // to increment address by 1
	
	assign sync_in = {8'b0,douta};
	assign addra = sync_out[1:0];
	assign wea = sync_out[2];  // make this a single-pulse signal @chipScope	
	assign trig = {5'b0,douta,incr,wea,addra};


//----- BRAM ----- 

	bram your_instance_name (
	  .clka(clk), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [1 : 0] addra
	  .dina(dina), // input [7 : 0] dina
	  .douta(douta) // output [7 : 0] douta
		);
		
//----- ChipScope modules -----
		
	icon icon_1 (
		 .CONTROL0(control_0), // INOUT BUS [35:0]
		 .CONTROL1(control_1) // INOUT BUS [35:0]
		); 
		
		ila ila_1 (
		 .CONTROL(control_1), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .TRIG0(trig) // IN BUS [15:0]
		);

	vio vio_1 (
		 .CONTROL(control_0), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .SYNC_IN(sync_in), // IN BUS [15:0]
		 .SYNC_OUT(sync_out) // OUT BUS [15:0]
		);

endmodule
