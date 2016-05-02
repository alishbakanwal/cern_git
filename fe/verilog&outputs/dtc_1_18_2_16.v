`timescale 1ns / 1ps

module dtc_1(
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
	wire [255:0] trig_2;
	wire [255:0] trig_3;
	
	wire dout_buff_0, dout_buff_1; 
	reg  din_buff_0, din_buff_1; 
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
	reg sr_out;
	
	
//-------------------------------------------------
//                  clock divider
//-------------------------------------------------

	 dtc_1_clkDiv instance_name
		(// Clock in ports
		 .CLK_IN1(clk_in),      // IN
		 // Clock out ports
		 .CLK_OUT1(clk),     // OUT
		 .CLK_OUT2(clk_10)
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


//-------------------------------------------------
//                     buff_0
//-------------------------------------------------		
	
	dtc_buff buff_0 (
	  .clk(clk), // input clk
	  .din(din_buff_0), // input [0 : 0] din
	  .wr_en(wr_en_0), // input wr_en
	  .rd_en(rd_en_0), // input rd_en
	  .dout(dout_buff_0), // output [0 : 0] dout
	  .full(full_0), // output full
	  .empty(empty_0) // output empty
	);
		

//-------------------------------------------------
//                     buff_1
//-------------------------------------------------		
	
	
	dtc_buff buff_1 (
	  .clk(clk), // input clk
	  .din(din_buff_1), // input [0 : 0] din
	  .wr_en(wr_en_1), // input wr_en
	  .rd_en(rd_en_1), // input rd_en
	  .dout(dout_buff_1), // output [0 : 0] dout
	  .full(full_1), // output full
	  .empty(empty_1) // output empty
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
	


	always@(posedge clk)
	begin
		//  write to buff_0 while while reading from buff_1
		
		if(count_256)
		begin			
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
		
	
//-----------------------------------------------------
//  logic cloud: buffer setup and serial transmission
//-----------------------------------------------------

	reg [255:0] temp;
	// wire [255:0] temp2;
	
	// assign temp2 = douta_0;  // intermediate variable
	
	reg x; 
	
	always@(posedge clk)
	begin
		x <= temp[0];
	
		if(count_256)
			temp <= douta_0;
						
		else
			temp <= {temp[0], temp[255:1]};
	end

	

	always@(cycle)
	begin
		if(cycle)
		begin
			din_buff_0 = temp[0];  // display data input for the fifo that is filling up
												  // corresponding dout should be zero
			din_buff_1 = 0;
			
			// sr_out <= dout_buff_1;
		end
			
		else
		begin
			din_buff_0 = 0;  // disconnect input
			din_buff_1 = temp[0];
			
			// sr_out <= dout_buff_0;
		end
	end		
	
	
	always@(rd_en_1)
	begin
		
		if(rd_en_1)  // read data till fifo_1 not empty
			sr_out <= dout_buff_1;
			
		else
			sr_out <= dout_buff_0;
			
	end

		
//-------------------------------------------------
//        logic cloud: capturing data Rx
//-------------------------------------------------

	reg [255:0] buff_2;
	reg [255:0] buff_3;
	
	always@(posedge clk)
	begin
//		if(count_256)
//			buff_2 <= 0; 
//			
//		else
//		begin
			buff_2[255] <= sr_out;
			buff_2[254:0] <= {buff_2[255], buff_2[254:1]};  // same as buff[254:0] <= buff[255:1]
		//end
	end
	
	always@(posedge clk)
	begin
		if(full_0 || full_1)  // load data when either buffer is full
			buff_3 <= buff_2;
			
		// else
			// buff_3 <= buff_2;
	end
	
	
	
//-------------------------------------------------
//          logic cloud: capturing data
//-------------------------------------------------

	reg [2:0] chipID;
	reg [255:0] temp_2;  // cic packet has 227 after stripping away header
	reg [3:0] count_10;
	
	
	always@(posedge clk_10)  // captured data is shifted x10 to get all chipID 
	begin		 	
		
		count_10 <= count_10 + 1;
		
		if(count_10 == 9)
		begin
			count_10 <= 0;
			temp_2 <= buff_3;
		end
		
			
		case(count_10)
			0: chipID <= temp_2[226:224];  // to read packer from its logical start
			1: chipID <= temp_2[205:203];
			2: chipID <= temp_2[184:182];
			3: chipID <= temp_2[163:161];
			4: chipID <= temp_2[142:140];
			5: chipID <= temp_2[121:119];
			6: chipID <= temp_2[100:98];
			7: chipID <= temp_2[79:77];
			8: chipID <= temp_2[58:56];
			9: chipID <= temp_2[37:35];
			
		endcase
		
		/*
		case(count_10)
			0: chipID <= buff_3[31:29];  // to read packer from its logical start
			1: chipID <= buff_3[52:50];
			2: chipID <= buff_3[73:71];
			3: chipID <= buff_3[94:92];
			4: chipID <= buff_3[115:113];
			5: chipID <= buff_3[136:134];
			6: chipID <= buff_3[157:155];
			7: chipID <= buff_3[178:176];
			8: chipID <= buff_3[199:197];
			9: chipID <= buff_3[220:218];
			
		endcase
		*/
	end
	
	
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

	assign trig_0 = temp_2;  // check if correct data loaded into temp every 256 clock cycles
	assign trig_1 = douta_0;
	assign trig_2 = {addra_0, count_10, clk_10, chipID, x, cycle, temp[0], din_buff_0, din_buff_1, dout_buff_0, dout_buff_1, sr_out, full_1, empty_1, full_0, empty_0, wr_en_1, rd_en_1, wr_en_0, rd_en_0, count_256};
	assign trig_3 = buff_3;
	
endmodule
