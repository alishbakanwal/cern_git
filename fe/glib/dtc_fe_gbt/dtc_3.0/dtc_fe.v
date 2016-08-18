`timescale 1ns / 1ps

module dtc_fe(
	input CLK40,
	input CLK320,
	input CLK40sh,
	output reg [83:0] DTC_FE_OUT,
	output [31:0] EPORT_OUT,
	output [10:0] CIC_ADDRA_O,
	output COUNT_64  // added to set an indicator for when a packet finishes Tx'ing
	                 // used to set Tx BRAM addra to 0 @posedge
	);

	reg [5:0] addra_1;
	reg [10:0] addra_0;  // bram depth: 64x24 = 1536
	
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
	
	wire [3:0] dout_buff_0, dout_buff_1; 
	reg  [3:0] din_buff_0, din_buff_1; 
	reg wr_en_0, rd_en_0;
	reg wr_en_1, rd_en_1;
	
	wire [3:0] douta_0;  // cicbram output data
	wire [3:0] douta_1;  //douta_2;
	reg [3:0] dina_0;  // cicbram input data
	reg [3:0] dina_1;
	// reg [3:0] dina_2;
	
	assign wea_0 = 0;  // read out of bram_0
	assign wea_1 = 1;  // write to bram_1
	
	// from sr_top.v
	reg [3:0] sr_in;
	reg [3:0] cic_out;
	
	assign COUNT_64 = count_64;
	assign CIC_ADDRA_O = addra_0;
	
//-------------------------------------------------
//                  clock divider
//-------------------------------------------------
	/*
	IBUFGDS clk_ibufg_inst(
		.I(SGMIICLK_QO_P),
		.IB(SGMIICLK_QO_N),
		.O(clkBUFG)
	);
	
   BUFG clk_bufg_inst (
		.I(clk_in_ibufg), 
		.O(clkBUFG)
	);
	
	
	clkDiv clkdiv(// Clock in ports
		 .CLK_IN1_P(SGMIICLK_QO_P),    // IN
		 .CLK_IN1_N(SGMIICLK_QO_N),    // IN
		 // Clock out ports
		 .CLK_OUT1(CLK40), // OUT
		 .CLK_OUT2(CLK320), // OUT
		 .CLK_OUT3(CLK40sh)  // to align CLK40 with eport_out
	); 
		*/
	
//	assign CLK40 = clk_in;
//	assign CLK320 = clk_in;
//-------------------------------------------------
//                     BRAM
//-------------------------------------------------


	cicbram cicbram(
	  .clka(CLK320), // input clka
	  .wea(wea_0), // input [0 : 0] wea
	  .addra(addra_0), // input [10 : 0] addra
	  .dina(dina_0), // input [3 : 0] dina
	  .douta(douta_0) // output [3 : 0] douta
	);



//-------------------------------------------------
//                     buff_0
//-------------------------------------------------		
	
	dtc_buff buff_0 (
	  .clk(CLK320), // input clk
	  .din(din_buff_0), // input [3 : 0] din
	  .wr_en(wr_en_0), // input wr_en
	  .rd_en(rd_en_0), // input rd_en
	  .dout(dout_buff_0), // output [3 : 0] dout
	  .full(full_0), // output full
	  .empty(empty_0) // output empty
	);
		

//-------------------------------------------------
//                     buff_1
//-------------------------------------------------		
	
	
	dtc_buff buff_1 (
	  .clk(CLK320), // input clk
	  .din(din_buff_1), // input [3 : 0] din
	  .wr_en(wr_en_1), // input wr_en
	  .rd_en(rd_en_1), // input rd_en
	  .dout(dout_buff_1), // output [3 : 0] dout
	  .full(full_1), // output full
	  .empty(empty_1) // output empty
	);


//-------------------------------------------------
//          logic cloud: count logic
//-------------------------------------------------
	
	reg cycle;  // flag to indicate alternative 64 cycles
	reg [7:0] count;
	reg count_256;
	
	reg [5:0] counter_64;
	reg count_64;  // indicates the start of a new packet
						// verified in ChipScope
	
	// count 256
	
	always@(posedge CLK320)  // count to 256
	begin						 	  // cycle represents the duration in which a packet is Txd/Rxd
		count <= count +1;     // cycle used to shift between buffers
		count_256 <= 0;
		
		if(count == 255)
		begin
			count <= 0;
			count_256 <= 1;
		end
	end
	
	
	// count 64
	
	always@(posedge CLK320)
	begin
		counter_64 <= counter_64 +1;     // cycle used to shift between buffers
		count_64 <= 0;
		
		if(counter_64 == 63)
		begin
			counter_64 <= 0;
			count_64 <= 1;
		end
	end



//-------------------------------------------------
//      logic cloud: count logic, 256 Rx
//-------------------------------------------------

	reg [7:0] counter_256_rx;
	reg count_256_rx;
	reg count_256_rx_sh0;
	reg count_256_rx_sh1;
	reg count_256_rx_sh2;

	always@(posedge CLK320)
	begin
		counter_256_rx <= counter_256_rx + 1;
		
		if(counter_256_rx == 255)
			count_256_rx <= 1;
			
		else
			count_256_rx <= 0;
		
		//
		
		if(count_256_rx)
			count_256_rx_sh0 <= 1;
			
		else
			count_256_rx_sh0 <= 0;
			
		//
		
		if(count_256_rx_sh0)
			count_256_rx_sh1 <= 1;
			
		else
			count_256_rx_sh1 <= 0;
			
		//
		
		if(count_256_sh1)
			count_256_rx_sh2 <= 1;
			
		else
			count_256_rx_sh2 <= 0;
	end


//-------------------------------------------------
//          logic cloud: address control
//-------------------------------------------------	
	
	
	always@(posedge CLK320)  // increment address every 64 cycles
	begin
		addra_0 <= addra_0 + 1;
							
		if(addra_0 == 1535)  // rollover
			addra_0 <= 0;
	end
	
	//
	// tip: @Rx side, generate another count_64 signal and a cycle signal the same way
	// cycle signals change of packet
	//
	
	always@(posedge CLK320)
	begin
		//  write to buff_0 while while reading from buff_1
		
		if(count_64)
		begin			
			cycle <= cycle + 1;
			
			if(cycle)
				cycle <= 0;
		end
	end
	
	always@(cycle)
	begin
		if(cycle)
		begin
			wr_en_0 <= 0;
			wr_en_1 <= 1;
			
			rd_en_0 <= 1;
			rd_en_1 <= 0;
			
			// serialTrans <= dout_buff_1;
			// sr_in <= dout_buff_1;
		end
			
		// read and write from both buffers in alternate cycles
		
		else
		begin
			wr_en_0 <= 1;
			wr_en_1 <= 0;
			
			rd_en_0 <= 0;
			rd_en_1 <= 1;
			
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
	reg count_256_sh;
	reg count_64_sh;
	reg count_256_sh1;  // signal used for trigger condition
	
	always@(posedge CLK320)
	begin	
		if(count_256)
			count_256_sh <= 1;
	
		else
			count_256_sh <= 0;
			
		// to try to elimiate data loading during the next address instead 
		// of the current address
		// addra_0 data loading into temp at addra_1 right now
		
		
		if(count_64)
			count_64_sh <= 1;
	
		else
			count_64_sh <= 0;
		
	end
	
	
	always@(posedge CLK320)
	begin
		if(count_256_sh)
			count_256_sh1 <= 1;
			
		else
			count_256_sh1 <= 0;
	end

	// @cycle: write into buff_1
	//         read from buff_0

	always@(cycle)
	begin
		if(cycle)
		begin
			din_buff_1 = douta_0;  // display data input for the fifo that is filling up
										  // corresponding dout should be zero
			din_buff_0 = 0;
			
			// cic_out <= dout_buff_1;
		end
			
		else
		begin
			din_buff_1 = 0;  // disconnect input
			din_buff_0 = douta_0;
			
			// cic_out <= dout_buff_0;
		end
	end		
	
	
	always@(rd_en_1)
	begin
		
		if(rd_en_1)  // read data till fifo_1 not empty
			cic_out <= dout_buff_1;
			
		else
			cic_out <= dout_buff_0;
			
	end




//-------------------------------------------------
//                  e-ports
//-------------------------------------------------

	wire [2:0] counter8;
	//wire [31:0] eport_out;
	
	eports_trig eports_trig (
    .clk(CLK320), 
    .eport_in(cic_out), 
    .eport_out(EPORT_OUT),
	 .counter8(counter8)
    );
	 
	  
	  
//-------------------------------------------------
//                  dtc_fe output
//-------------------------------------------------

	// reg [31:0] DTC_FE_OUT;  // result of sampling cicreg @40MHz
	
	// phase alignment of CLK40 with eport_out required
	// achieved by giving phase shift to CLK40sh in clkdiv
	
	
	// this block was necessary for data alignment again
	// eg getting 2214 0859
	// but required 5922 1408
	// assignment adjusted accordingly
	
//	assign CLK40sh = clk_in;
	always@(posedge CLK40sh)
	begin
		// CIC_0
		DTC_FE_OUT[3:0]                  <= EPORT_OUT[7:4];
		DTC_FE_OUT[7:4]                  <= EPORT_OUT[3:0];
		DTC_FE_OUT[11:8]                 <= EPORT_OUT[31:28];
		DTC_FE_OUT[15:12]                <= EPORT_OUT[27:24];
		DTC_FE_OUT[19:16]                <= EPORT_OUT[23:20];
		DTC_FE_OUT[23:20]                <= EPORT_OUT[19:16];
		DTC_FE_OUT[27:24]                <= EPORT_OUT[15:12];
		DTC_FE_OUT[31:28]                <= EPORT_OUT[11:8];
		// These 8 bits are for L1 data
		DTC_FE_OUT[35:32]                <= 4'b0;  
		DTC_FE_OUT[39:36]                <= 4'b0;
		
		// CIC_1
		// Simple data duplication for the time being
		DTC_FE_OUT[43:40]                <= EPORT_OUT[7:4];
		DTC_FE_OUT[47:44]                <= EPORT_OUT[3:0];
		DTC_FE_OUT[51:48]                <= EPORT_OUT[31:28];
		DTC_FE_OUT[55:52]                <= EPORT_OUT[27:24];
		DTC_FE_OUT[59:56]                <= EPORT_OUT[23:20];
		DTC_FE_OUT[63:60]                <= EPORT_OUT[19:16];
		DTC_FE_OUT[67:64]                <= EPORT_OUT[15:12];
		DTC_FE_OUT[71:68]                <= EPORT_OUT[11:8];
		// These 8 bits are for L1 data
		DTC_FE_OUT[75:72]                <= 4'b0;
		DTC_FE_OUT[79:76]                <= 4'b0;
	end
	 
	 
	 
/*	 
// uncomment these lines for stand-alone testing outside of the firmware	 
//-------------------------------------------------
//               ChipScope modules
//-------------------------------------------------

	icon icon(
		 .CONTROL0(control_0) // INOUT BUS [35:0]
		);

	
	ila ila (
		 .CONTROL(control_0), // INOUT BUS [35:0]
		 .CLK(CLK320), // IN                  
		 .TRIG0(trig_0), // IN BUS [255:0]
		 .TRIG1(trig_1) // IN BUS [255:0]
		);
	
*/


//-------------------------------------------------
//           trigger and syncs assignment
//-------------------------------------------------
 
	// OBSERVATION: clk used for trigger is not displayed [source: xilinx forum]
	
	//assign trig_0 = {count_256_rx_sh2, count_256_rx_sh1, count_256_rx_sh0, count_256_rx, counter_256_rx, 	clk_10_1, count_256_sh1, count_256_sh, count_20, douta_0m, douta_1m, douta_2m, douta_3m, douta_4m, douta_5m, douta_6m, douta_7m};
	assign trig_0 = { CLK40sh,
							counter8,
							EPORT_OUT,
						   DTC_FE_OUT,
							cic_out, count_64_sh, count_64, 
	                  dout_buff_1, dout_buff_0, din_buff_1, din_buff_0, 
						   rd_en_1, wr_en_1, rd_en_0, wr_en_0, 
							cycle, 
							CLK40, CLK320, 
						   addra_0
						  };
	
	
endmodule

// last worked on:  17-03-2016
