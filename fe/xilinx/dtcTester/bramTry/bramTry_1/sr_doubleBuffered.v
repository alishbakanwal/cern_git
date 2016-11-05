
`timescale 1ns / 1ps

module sr_doubleBuffered(
	input clk_in
    );

	reg [5:0] addra;
	
	wire [5:0] rd_data_count, wr_data_count;

	wire [35:0] control_0, control_1;
	wire [255:0] sync_in, async_in;
	wire [7:0] async_out;
	wire [63:0] trig;
	
	wire [3:0] dout_buff_0, dout_buff_1; 
	reg [3:0] din_buff_0, din_buff_1; 
	reg wr_en_0, rd_en_0;
	reg wr_en_1, rd_en_1;
	
	wire [3:0] douta, douta_1, douta_2; 
	reg [3:0] dina;
	reg [3:0] dina_1;
	reg [3:0] dina_2;
	
	assign wea = 0;
	assign wea_1 = 1;
	
	// from sr_top.v
	wire rst;
	reg [3:0] sr_in;
	wire sr_out;
	 
	wire rst_sr;
	wire rst_sr_sh;
	assign rst_sr = clk_4;
	assign rst_sr_sh = clk_4_sh;
	//


//-------------------------------------------------
//                  clock divider
//-------------------------------------------------

	sr_doubleBuffered_clkDiv clkDiv(// Clock in ports
		 .CLK_IN1(clk_in),      // IN
		 // Clock out ports
		 .CLK_OUT1(clk),     // OUT
		 .CLK_OUT2(clk_4),
		 .CLK_OUT3(clk_4_sh)    // OUT
		 );    // OUT


//-------------------------------------------------
//                     BRAM
//-------------------------------------------------

	sr_doubleBuffered_bram bram_tx (
	  .clka(clk), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [5 : 0] addra
	  .dina(dina), // input [3 : 0] dina
	  .douta(douta) // output [3 : 0] douta
		);
		
	sr_doubleBuffered_bram_tx bram_rx (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra), // input [5 : 0] addra
	  .dina(dina_1), // input [3 : 0] dina
	  .douta(douta_1) // output [3 : 0] douta
		);
		
	sram_doubleBuffered_tx2 bram_tx_2 (
	  .clka(clk), // input clka
	  .wea(wea), // input [0 : 0] wea
	  .addra(addra), // input [5 : 0] addra
	  .dina(dina_2), // input [3 : 0] dina
	  .douta(douta_2) // output [3 : 0] douta
		);
	


//-------------------------------------------------
//                     buff_0
//-------------------------------------------------		
	
	sr_doubleBuffered_buff buff_0 (
	  .wr_clk(clk_4), // input wr_clk
     .rd_clk(clk_4), // input rd_clk
	  .din(din_buff_0), // input [3 : 0] din
	  .wr_en(wr_en_0), // input wr_en
	  .rd_en(rd_en_0), // input rd_en
	  .dout(dout_buff_0), // output [3 : 0] dout
	  .full(full_0), // output full
	  .wr_ack(wr_ack_0), // output wr_ack
	  .empty(empty_0), // output empty
	  .rd_data_count(rd_data_count), // output [5 : 0] rd_data_count
	  .wr_data_count(wr_data_count) // output [5 : 0] wr_data_count
		);
		

//-------------------------------------------------
//                     buff_1
//-------------------------------------------------		
	
	
	sr_doubleBuffered_buff buff_1 (
	  .wr_clk(clk_4), // input wr_clk
     .rd_clk(clk_4), // input rd_clk
	  .din(din_buff_1), // input [3 : 0] din
	  .wr_en(wr_en_1), // input wr_en
	  .rd_en(rd_en_1), // input rd_en
	  .dout(dout_buff_1), // output [3 : 0] dout
	  .full(full_1), // output full
	  .wr_ack(wr_ack_1), // output wr_ack
	  .empty(empty_1), // output empty
	  .rd_data_count(rd_data_count_1), // output [5 : 0] rd_data_count
	  .wr_data_count(wr_data_count_1) // output [5 : 0] wr_data_count
		);
		
//-------------------------------------------------
//          logic cloud: address control
//-------------------------------------------------
	
	reg cycle;  // flag to indicate alternative 64 cycles
	reg [3:0] serialTrans;
	
	always@(posedge clk_4)
	begin
		addra <= addra + 1;  //  write to buff_0 while while reading from buff_1
			
			if(cycle)
			begin
				wr_en_0 <= 1;
				wr_en_1 <= 0;
				
				rd_en_0 <= 0;
				rd_en_1 <= 1;
				
				// serialTrans <= dout_buff_1;
				sr_in <= dout_buff_1;
			end
			
			// read and write from both buffers in alternate cycles
			
			else
			begin
				wr_en_0 <= 0;
				wr_en_1 <= 1;
				
				rd_en_0 <= 1;
				rd_en_1 <= 0;
				
				// serialTrans <= dout_buff_0;
				sr_in <= dout_buff_0;
			end
		
		if(addra == 63)
		begin
			addra <= 0;
			
			cycle <= cycle + 1;
			
			if(cycle)
				cycle <= 0;
		end
	end
	


//-------------------------------------------------
//          logic cloud: buffer
//-------------------------------------------------
	
	reg [3:0] temp;
	
	/*
	always@(posedge clk_4)
	begin
		din_buff_0 <= douta;
		din_buff_1 <= douta;
	end
	*/
	
	always@(cycle)
	begin
		if(cycle)
		begin
			din_buff_0 = douta;
			din_buff_1 = douta;
		end
		
		else
		begin
			din_buff_0 = douta_2;
			din_buff_1 = douta_2;
		end
	end
	

// pick reading cycle data for transmission
// data read out is input of the shift register

// picked from sr_top.v

//-------------------------------------------------
//                 shift register
//-------------------------------------------------	
	
	//
		
	sr #(4) sr_2(
		.sr_in(sr_in),
		.clk(clk),         // the shift register is reset when the counter counts to 4
		.rst(rst_sr),			           // reset with counter_out
								  // if reset, load new data
		.sr_out(sr_out)
		 );
		 

//-------------------------------------------------
//          logic cloud: bram_2 storage
//-------------------------------------------------
	
	reg [3:0] register;
	
	always@(posedge clk)
	begin
		register[3] <= sr_out;
		register[2:0] <= {register[3], register[2:1]};
	end
	
	
	always@(posedge clk_4_sh)  // previousy on clk_4_sh							
	begin								// this is to account for the error in sampling location
		dina_1 <= register;
	end

//
	

//-------------------------------------------------
//               ChipScope modules
//-------------------------------------------------

	sr_doubleBuffered_icon icon(
		 .CONTROL0(control_0), // INOUT BUS [35:0]
		 .CONTROL1(control_1) // INOUT BUS [35:0]
		);

	
	sr_doubleBuffered_ila ila (
		 .CONTROL(control_0), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .TRIG0(trig) // IN BUS [63:0]
		);
		
	sr_doubleBuffered_vio vio (
		 .CONTROL(control_1), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .ASYNC_IN(async_in), // IN BUS [255:0]
		.ASYNC_OUT(async_out), // OUT BUS [7:0]
		.SYNC_IN(async_in) // IN BUS [255:0]
		);



//-------------------------------------------------
//           trigger and syncs assignment
//-------------------------------------------------
	
	assign trig = {douta_2, dina_1, sr_out, sr_in, dout_buff_1, wr_en_1, rd_en_1, douta_1, wr_data_count, rd_data_count, wr_ack_0, full_0, empty_0, rd_en_0, wr_en_0, dout_buff_0, din_buff_0, addra, clk_4, rst};
	
	assign sync_in = {douta_2, dina_1, sr_out, sr_in, dout_buff_1, wr_en_1, rd_en_1, douta_1, wr_data_count, rd_data_count, wr_ack_0, full_0, empty_0, dout_buff_0, din_buff_0, clk_4, addra};
	assign rst = async_out[0];
	
endmodule


// last worked on:  12-01-2016