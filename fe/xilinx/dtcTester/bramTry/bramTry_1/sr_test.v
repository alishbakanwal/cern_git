
// this module is to test the functionality of the shift register using ChipScope

`timescale 1ns / 1ps

module sr_test(
	input clk
    );
	 
	 wire wea;
	 wire [3:0] dina, douta;
	 wire [1:0] addra;
	 
	 wire [3:0] sr_in;
	 wire sr_out;
	 wire rst;
	 
	 wire [35:0] control_0, control_1;
	 wire [15:0] trig;
	 wire [15:0] sync_in, sync_out;
	 
	 assign wea = 0;

//-------------------------------------------------
//           trigger and syncs assignment
//-------------------------------------------------
	 
	 
	 assign trig = {4'b0, sr_out, sr_in, douta, addra, rst};
	
	 assign sync_in = {7'b0, sr_out, sr_in, douta, addra};
	 assign rst = sync_out[0];
	 
	 assign addra = sync_out[2:1];
	 
	
//-------------------------------------------------
//                     BRAM
//-------------------------------------------------

	 
	 bram bram_3(
	  .clka(clk), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [1 : 0] addra
	  .dina(dina), // input [7 : 0] dina
	  .douta(douta) // output [7 : 0] douta
	);
	

//-------------------------------------------------
//               ChipScope modules
//-------------------------------------------------

	icon icon_3(
		 .CONTROL0(control_0), // INOUT BUS [35:0]
		 .CONTROL1(control_1) // INOUT BUS [35:0]
		);

	
	ila ila_3(
		 .CONTROL(control_1), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .TRIG0(trig) // IN BUS [15:0]
		);

	vio vio_3(
		 .CONTROL(control_0), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .SYNC_IN(sync_in), // IN BUS [15:0]
		 .SYNC_OUT(sync_out) // OUT BUS [15:0]
		);
		
//-------------------------------------------------
//                shift register
//-------------------------------------------------

	sr #(4) sr_3(
		.sr_in(sr_in),
		.clk(clk), 
		.rst(rst),  // this reset is to load new data into the shift register
		.sr_out(sr_out)
		 );
	
	assign sr_in = douta;

/*
	always@(posedge clk)
	begin
		if(rst)
			sr_temp <= sr_in;
			
		else
			sr_temp <= {sr_temp[0], sr_temp[3:1]};
	end
	
	assign sr_out = sr_temp[3];
*/



endmodule
