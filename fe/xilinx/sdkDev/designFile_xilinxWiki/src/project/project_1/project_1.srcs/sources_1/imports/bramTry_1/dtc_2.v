`timescale 1ns / 1ps

module dtc_2(
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
	wire [255:0] trig_4;
	
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
		 .CLK_OUT2(clk_10_c)
		 );    // OUT
			 
		 
		 
//-------------------------------------------------
//                     BRAM
//-------------------------------------------------

	sr_doubleBuffered_2_bram bram_t
 (
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
//                 clk_10 gen
//-------------------------------------------------

	reg clk_10;
	reg [7:0] count_20;
	
	always@(posedge clk)
	begin			
		if(count_256)  // reset count_20 every 256 cycles
		begin
			count_20 <= 0;
			clk_10 <= 1;
		end
		
		else
		begin
			clk_10 <= ~clk_10;
			count_20 <= count_20 + 1;
			
			if(count_20 >= 19) 
				clk_10 <= 0;
		end
	end
	
//-------------------------------------------------
//          logic cloud: capturing data 
//              and data processing
//-------------------------------------------------

	reg [2:0] chipID;
	reg [255:0] temp_2;  // cic packet has 227 after stripping away header
	reg [3:0] count_10;  // count the # of stubs that have been processed
	reg [4:0] count_24;
	// reg [229:0] temp_3; // discards header
	reg [20:0] inter;
	
	// temp_2 is for chipID processing
	// temp_3 is for data extraction against the chipID
	// temp_3 works by discarding the packet header and shifting the remaining bits
	
	// FILING
	
	integer mpa0_file, mpa1_file, mpa2_file, mpa3_file, mpa4_file, mpa5_file, mpa6_file, mpa7_file;
	initial
	begin
		mpa0_file = $fopen("mpa0.txt","w");
		mpa1_file = $fopen("mpa1.txt","w");
		mpa2_file = $fopen("mpa2.txt","w");
		mpa3_file = $fopen("mpa3.txt","w");
		mpa4_file = $fopen("mpa4.txt","w");
		mpa5_file = $fopen("mpa5.txt","w");
		mpa6_file = $fopen("mpa6.txt","w");
		mpa7_file = $fopen("mpa7.txt","w");
		
	end
	
	
	always@(posedge clk_10)  // captured data is shifted x10 to get all chipID 
	begin		 	
		
		count_10 <= count_10 + 1; 
		
		if(count == 0)
		begin
			count_10 <= 0;			
		end	
			
			
		case(count_10)
			0: begin
					chipID <= buff_3[226:224];  // to read packet from its logical start
					inter <= buff_3[229:209];
				end
				
			1: begin
					chipID <= buff_3[205:203];
					inter <= buff_3[208:188];
				end
				
			2: begin
					chipID <= buff_3[184:182];
					inter <= buff_3[187:167];
				end
				
			3: begin
					chipID <= buff_3[163:161];
					inter <= buff_3[166:146];
				end
				
			4: begin
					chipID <= buff_3[142:140];
					inter <= buff_3[145:125];
				end
				
			5: begin
					chipID <= buff_3[121:119];
					inter <= buff_3[124:104];
				end
				
			6: begin
					chipID <= buff_3[100:98];
					inter <= buff_3[103:83];
				end
				
			7: begin
					chipID <= buff_3[79:77];
					inter <= buff_3[82:62];
				end
				
			8: begin
					chipID <= buff_3[79:77];
					inter <= buff_3[61:41];
				end
				
			9: begin
					chipID <= buff_3[79:77];
					inter <= buff_3[40:20];
				end		
		endcase
		
		  // logic: got temp_2's 21-bit data, where should I put it?
		  
		case(chipID)
			0:  begin
					addra_0m <= addra_0m  +1;
					dina_0m <= inter;
					$fwrite(mpa0_file, "%h %h\n", douta_0m);
				 end
				 
			1:  begin
					addra_1m <= addra_1m  +1;
					dina_1m <= inter;
					$fwrite(mpa1_file, "%h %h\n", douta_1m);
				end
				
			2:  begin
					addra_2m <= addra_2m  +1;
					dina_2m <= inter;
					$fwrite(mpa2_file, "%h %h\n", douta_2m);
				end
				
			3:  begin
					addra_3m <= addra_3m  +1;
					dina_3m <= inter;
					$fwrite(mpa3_file, "%h %h\n", douta_3m);
				end
				
			4:  begin
					addra_4m <= addra_4m  +1;
					dina_4m <= inter;
					$fwrite(mpa4_file, "%h %h\n", douta_4m);
				end
				
			5:  begin
					addra_5m <= addra_5m  +1;
					dina_5m <= inter;
					$fwrite(mpa5_file, "%h %h\n", douta_5m);
				end
				
			6:  begin
					addra_6m <= addra_6m  +1;
					dina_6m <= inter;
					$fwrite(mpa6_file, "%h %h\n", douta_6m);
				end
				
			7:  begin
					addra_7m <= addra_7m  +1;
					dina_7m <= inter;
					$fwrite(mpa7_file, "%h %h\n", douta_7m);
				end
				/*
			8:  begin
					addra_8m <= addra_8m  +1;
					dina_8m <= inter;
				end
			9: begin
					addra_9m <= addra_9m  +1;
					dina_9m <= inter;
				end
			*/	
		endcase
		
	end
	
	
//-------------------------------------------------
//               mpa brams
//-------------------------------------------------	
	
	reg [6:0] addra_0m;
	reg [6:0] addra_1m;
	reg [6:0] addra_2m;
	reg [6:0] addra_3m;
	reg [6:0] addra_4m;
	reg [6:0] addra_5m;
	reg [6:0] addra_6m;
	reg [6:0] addra_7m;
	reg [6:0] addra_8m;
	reg [6:0] addra_9m;
	
	reg [20:0] dina_0m;
	reg [20:0] dina_1m;
	reg [20:0] dina_2m;
	reg [20:0] dina_3m;
	reg [20:0] dina_4m;
	reg [20:0] dina_5m;
	reg [20:0] dina_6m;
	reg [20:0] dina_7m;
	reg [20:0] dina_8m;
	reg [20:0] dina_9m;
	
	wire [20:0] douta_0m;
	wire [20:0] douta_1m;
	wire [20:0] douta_2m;
	wire [20:0] douta_3m;
	wire [20:0] douta_4m;
	wire [20:0] douta_5m;
	wire [20:0] douta_6m;
	wire [20:0] douta_7m;
	wire [20:0] douta_8m;
	wire [20:0] douta_9m;
	
	
	dtc_1_mpabram mpa_0 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_0m), // input [6 : 0] addra
	  .dina(dina_0m), // input [20 : 0] dina
	  .douta(douta_0m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_1 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_1m), // input [6 : 0] addra
	  .dina(dina_1m), // input [20 : 0] dina
	  .douta(douta_1m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_2 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_2m), // input [6 : 0] addra
	  .dina(dina_2m), // input [20 : 0] dina
	  .douta(douta_2m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_3 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_3m), // input [6 : 0] addra
	  .dina(dina_3m), // input [20 : 0] dina
	  .douta(douta_3m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_4 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_4m), // input [6 : 0] addra
	  .dina(dina_4m), // input [20 : 0] dina
	  .douta(douta_4m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_5 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_5m), // input [6 : 0] addra
	  .dina(dina_5m), // input [20 : 0] dina
	  .douta(douta_5m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_6 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_6m), // input [6 : 0] addra
	  .dina(dina_6m), // input [20 : 0] dina
	  .douta(douta_6m) // output [20 : 0] douta
	);
	
	
	dtc_1_mpabram mpa_7 (
	  .clka(clk), // input clka
	  .wea(wea_1), // input [0 : 0] wea
	  .addra(addra_7m), // input [6 : 0] addra
	  .dina(dina_7m), // input [20 : 0] dina
	  .douta(douta_7m) // output [20 : 0] douta
	);
	


//-------------------------------------------------
//               ChipScope modules
//-------------------------------------------------


	
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
		 .TRIG2(trig_2), // IN BUS [255:0]
		 .TRIG3(trig_3), // IN BUS [255:0]
		 .TRIG4(trig_4) // IN BUS [255:0]
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
 
	assign trig_0 = {count_20, douta_0m, douta_1m, douta_2m, douta_3m, douta_4m, douta_5m, douta_6m, douta_7m};
	assign trig_1 = douta_0;
	assign trig_2 = {addra_0m, addra_1m, addra_2m, addra_3m, addra_4m, addra_5m, addra_6m, addra_7m, addra_0, count_10, clk_10, chipID, x, cycle, temp[0], din_buff_0, din_buff_1, dout_buff_0, dout_buff_1, sr_out, full_1, empty_1, full_0, empty_0, wr_en_1, rd_en_1, wr_en_0, rd_en_0, count_256};
	assign trig_3 = {inter, dina_0m, dina_1m, dina_2m, dina_3m, dina_4m, dina_5m, dina_6m, dina_7m};
	assign trig_4 = temp_2;  // check if correct data loaded into temp every 256 clock cycles
	
	
endmodule

// last worked on:  22-03-2016
