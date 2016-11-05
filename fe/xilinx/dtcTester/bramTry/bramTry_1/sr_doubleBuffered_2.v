`timescale 1ns / 1ps

module sr_doubleBuffered_2(
	input clk_in
    );

	reg [5:0] addra_1;
	reg [4:0] addra_0;
	
	wire [5:0] rd_data_count, wr_data_count;

	wire [35:0] control_0, control_1;
	wire [255:0] sync_in;
	wire [255:0] async_in;
	wire [7:0] sync_out;
	wire [255:0] trig_0;
	wire [255:0] trig_1;
	
	wire [3:0] dout_buff_0, dout_buff_1; 
	reg [3:0] din_buff_0, din_buff_1; 
	reg wr_en_0, rd_en_0;
	reg wr_en_1, rd_en_1;
	
	wire [255:0] douta_0; 
	wire [3:0] douta_1; //douta_2;
	reg [255:0] dina_0;
	reg [3:0] dina_1;
	// reg [3:0] dina_2;
	
	assign wea_0 = 0;  // read out of bram_0
	assign wea_1 = 1;  // write to bram_1
	
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

	sr_doubleBuffered_clkDiv clkDiv_2(// Clock in ports
		 .CLK_IN1(clk_in),      // IN
		 // Clock out ports
		 .CLK_OUT1(clk),     // OUT
		 .CLK_OUT2(clk_4),
		 .CLK_OUT3(clk_4_sh)    // OUT
		 );    // OUT


//-------------------------------------------------
//                     BRAM
//-------------------------------------------------

	sr_doubleBuffered_2_bram bram_tx (
	  .clka(clk), // input clka
	  .wea(wea_0), // input [0 : 0] wea
	  .addra(addra_0), // input [5 : 0] addra
	  .dina(dina_0), // input [255 : 0] dina
	  .douta(douta_0) // output [255 : 0] douta
		);
		
	sr_doubleBuffered_bram_tx bram_rx (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_1), // input [5 : 0] addra
	  .dina(dina_1), // input [3 : 0] dina
	  .douta(douta_1) // output [3 : 0] douta
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
//          logic cloud: count logic
//-------------------------------------------------
	
	reg cycle;  // flag to indicate alternative 64 cycles
	reg [7:0] count;
	reg count_256;
	
	always@(posedge clk)  // count to 64
	begin						 
		count <= count +1;
		count_256 <= 0;
		
		if(count == 255)
		begin
			count <= 0;
			count_256 <= 1;
		end
	end


//-------------------------------------------------
//          logic cloud: address control
//-------------------------------------------------	
	
	always@(posedge count_256)  // increment address every 64 cycles
	begin
		addra_0 <= addra_0 + 1;
							
		if(addra_0 == 23)  // rollover
			addra_0 <= 0;
	end
	

//-------------------------------------------------
//        logic cloud: wr_en and rd_en setup
//-------------------------------------------------
	
	always@(posedge clk_4)
	begin
		addra_1 <= addra_1 + 1;  //  write to buff_0 while while reading from buff_1
		
		if(addra_1 == 63)
		begin
			addra_1 <= 0;
			
			cycle <= cycle + 1;
			
			if(cycle)
				cycle <= 0;
		end
		
			if(cycle)
			begin
				wr_en_0 <= 1;
				wr_en_1 <= 0;
				
				rd_en_0 <= 0;
				rd_en_1 <= 1;
				
				// serialTrans <= dout_buff_1;
				// sr_in <= dout_buff_1;
			end
			
			// read and write from both buffers in alternate cycles
			
			else
			begin
				wr_en_0 <= 0;
				wr_en_1 <= 1;
				
				rd_en_0 <= 1;
				rd_en_1 <= 0;
				
				// serialTrans <= dout_buff_0;
				
			end
	end
	

	always@(cycle)
	begin
		if(cycle)
			sr_in <= dout_buff_1;
		
		else
			sr_in <= dout_buff_0;
	end


//-------------------------------------------------
//          logic cloud: buffer
//-------------------------------------------------
	
	reg [255:0] temp;
	
	always@(posedge clk_4 or posedge count_256)
	begin
		if(count_256)
			temp <= douta_0;
			
		else
		begin
			temp <= {temp[3:0], temp[255:4]};
			
			if(cycle)
			begin
				din_buff_0 <= temp[3:0];  // display data input for the fifo that is filling up
												  // correspnding dout should be zero
				din_buff_1 <= 0;
			end
			
			else
			begin
				din_buff_0 <= 0;
				din_buff_1 <= temp[3:0];
			end
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
		.rst(rst_sr),		 // reset with rst_sr
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
		 .TRIG0(trig_0), // IN BUS [255:0]
		 .TRIG1(trig_1), // IN BUS [255:0]
		 .TRIG2(trig_2), // IN BUS [7:0]
		 .TRIG3(trig_3) // IN BUS [7:0]
		);
		
	sr_doubleBuffered_2_vio vio (
		 .CONTROL(control_1), // INOUT BUS [35:0]
		 .CLK(clk), // IN
		 .ASYNC_IN(async_in), // IN BUS [255:0]
		 .SYNC_IN(sync_in), // IN BUS [255:0]
		 .SYNC_OUT(sync_out) // OUT BUS [7:0]
		);



//-------------------------------------------------
//           trigger and syncs assignment
//-------------------------------------------------
	
	assign trig_0 = {douta_1, sr_out, sr_in, empty_1, full_1, empty_0, full_0, rd_en_1, wr_en_1, rd_en_0, wr_en_0, dout_buff_1, din_buff_1, dout_buff_0, din_buff_0, douta_1, addra_1, count_256, addra_0, clk_4, rst};
	assign trig_1 = douta_0;
	
	assign sync_in = {douta_1, sr_out, sr_in, empty_1, full_1, empty_0, full_0, rd_en_1, wr_en_1, rd_en_0, wr_en_0, dout_buff_1, din_buff_1, dout_buff_0, din_buff_0, douta_1, addra_1, count_256, addra_0, clk_4};
	// assign async_in = {douta_0};
	assign rst = sync_out[0];
	
endmodule


// last worked on:  18-01-2016

