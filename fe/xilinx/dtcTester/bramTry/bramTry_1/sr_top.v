
// this module connects a simple n-bit shift register to a bram
// the shift register is to serially trasmit data stored at any bram location
// this component will be used to emulate the GBT link in the main design
// data from this shifter will be stored in another bram at the opposite end of the link

// works with a WASTED CLOCK CYCLE

`timescale 1ns / 1ps

module sr_top #(parameter N = 8)(
	input clk_in
    );
	  
	 reg [3:0] addra;
	 wire [N-1:0] douta, douta_2;
	 
	 reg [N-1:0] dina_2;
	 
	 wire [35:0] control_0, control_1;
	 
	 wire [63:0] trig;
	 wire [63:0] sync_in, sync_out;
	 
	 wire rst;
	 wire [N-1:0] sr_in;
	 wire sr_out;
	 
	 assign wea = 0;  // to ensure data is constantly read out of the bram
	 wire wea_2;
	 
	 wire rst_sr;
	 wire rst_sr_sh;
	 assign rst_sr = clk_8;
	 assign rst_sr_sh = clk_8_sh;
	
	 
//-------------------------------------------------
//                  clock divider
//-------------------------------------------------

	 clkDivider clkDiv(// Clock in ports
		 .CLK_IN1(clk_in),      // IN
		 // Clock out ports
		 .CLK_OUT1(clk),     // OUT
		 .CLK_OUT2(clk_8),     // OUT
		 .CLK_OUT3(clk_8_sh)     // OUT
		 );      // OUT
		 
		 
//-------------------------------------------------
//           trigger and syncs assignment
//-------------------------------------------------
	 
	 
	 assign trig = {wea_2, douta_2, dina_2, register, rst_sr, sr_out, sr_in, addra, rst};
	
	 assign sync_in = {douta_2, dina_2, register, rst_sr, sr_out, sr_in, addra};
	 assign rst = sync_out[0];
	 assign wea_2 = sync_out[1];
	 
	
//-------------------------------------------------
//                     BRAM
//-------------------------------------------------

	 
	 bram bram_2(
	  .clka(clk), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [1 : 0] addra
	  .dina(dina), // input [7 : 0] dina
	  .douta(douta) // output [7 : 0] douta
	);
	
	
//-------------------------------------------------
//          logic cloud: address control
//-------------------------------------------------
	
	always@(posedge clk_8)
	begin
		addra <= addra + 1;
		
		if(addra == 9)
			addra <= 0;
	end
	
//-------------------------------------------------
//               ChipScope modules
//-------------------------------------------------

	icon icon_2(
		 .CONTROL0(control_0), // INOUT BUS [35:0]
		 .CONTROL1(control_1) // INOUT BUS [35:0]
		);

	
	ila ila_2(
		 .CONTROL(control_1), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .TRIG0(trig) // IN BUS [15:0]
		);

	vio vio_2(
		 .CONTROL(control_0), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .SYNC_IN(sync_in), // IN BUS [15:0]
		 .SYNC_OUT(sync_out) // OUT BUS [15:0]
		);

//-------------------------------------------------
//                 shift register
//-------------------------------------------------	
	
	//
		
	sr #(8) sr_1(
		.sr_in(sr_in),
		.clk(clk),         // the shift register is reset when the counter counts to 4
		.rst(rst_sr),			           // reset with counter_out
								  // if reset, load new data
		.sr_out(sr_out)
		 );
		
		 assign sr_in = douta;


//-------------------------------------------------
//          storing data into second bram
//-------------------------------------------------
// had to create a second bram to be able to view dina separately from
// the previously initialized bram

	bram2 bram_4 (
	  .clka(clk), // input clka
	  .wea(wea_2), // input [0 : 0] wea
	  .addra(addra), // input [1 : 0] addra
	  .dina(dina_2), // input [7 : 0] dina
	  .douta(douta_2) // output [7 : 0] douta
	);
	
	
//-------------------------------------------------
//          logic cloud: bram_2 storage
//-------------------------------------------------
	
	reg [N-1:0] register;
	
	always@(posedge clk)
	begin
		register[7] <= sr_out;
		register[6:0] <= {register[7], register[6:1]};
	end
		
	always@(posedge clk_8_sh)  // previousy on clk_8_sh
	begin
		dina_2 <= register;
	end
	 
endmodule
