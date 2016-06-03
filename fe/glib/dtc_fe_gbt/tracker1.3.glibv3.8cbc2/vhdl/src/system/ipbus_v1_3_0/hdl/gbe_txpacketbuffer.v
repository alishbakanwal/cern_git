`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:57:35 01/07/2010 
// Design Name: 
// Module Name:    gbe_packetbuffer 
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
module gbe_txpacketbuffer(
	input mac_clk,
    output reg [7:0] mac_txd,
    output reg mac_txdv,
    input mac_txack,
//    output packet_txspace,
    input [7:0] packet_txd,
	 input [10:0] packet_addr,
	 input [10:0] packet_len,
    input packet_we, packet_done,
	 input reset
    );

	reg [10:0] packet_len_fifo[7:0]; // store up to eight outgoing packets at once
	reg [2:0] packet_len_wp, packet_len_rp;

	reg [11:0] fifo_base_write, fifo_addr_read;

	wire packet_len_full, packet_len_empty, packet_fifo_space;
	
assign packet_len_empty=(packet_len_wp==packet_len_rp);
assign packet_len_full=((packet_len_wp+1)==packet_len_rp);
//	wire [11:0] delta_addr;
//assign delta_addr=(fifo_base_write-fifo_addr_read);
//assign packet_fifo_space=(delta_addr<12'h7ff);

//assign packet_txspace=(!packet_len_full);// && packet_fifo_space);

	reg was_packet_done;
always @(posedge mac_clk) was_packet_done<=packet_done;

always @(posedge mac_clk)
	if (reset) begin 
		packet_len_wp<=0;
		fifo_base_write<=0;
	end else if (packet_done && !was_packet_done) begin
		fifo_base_write<=fifo_base_write+packet_len;
		packet_len_fifo[packet_len_wp]<=packet_len;
	end else if (!packet_done && was_packet_done) begin
		packet_len_wp<=packet_len_wp+1;
	end

	reg [1:0] state;
	reg [10:0] packet_sent_len;
	wire end_of_output;

parameter ST_IDLE       = 2'h0;
parameter ST_FIRSTBYTE  = 2'h1;
parameter ST_WAITSTART  = 2'h2;
parameter ST_BYTES      = 2'h3;

assign end_of_output=(state==ST_BYTES && packet_sent_len==packet_len_fifo[packet_len_rp]);
//assign end_of_output=(state==ST_BYTES && packet_sent_len==11'h100);

	wire [7:0] fifo_read;
	reg [7:0] second_byte;

always @(posedge mac_clk)
	if (reset) begin // Clock domain crossing
		state<=ST_IDLE;
		fifo_addr_read<=0;
		packet_len_rp<=0; 
		mac_txdv<=0;
	end
	else case (state) 
	ST_IDLE : begin
		packet_sent_len<=0;
		mac_txdv<=0;
		if (!packet_len_empty) begin // Clock domain crossing
			state<=ST_FIRSTBYTE;
			mac_txd<=fifo_read;
			fifo_addr_read<=fifo_addr_read+1;
		end
		else begin
			state<=ST_IDLE;
//			fifo_addr_read<=0;
		end
	end
	ST_FIRSTBYTE : begin
		mac_txdv<=0;
		fifo_addr_read<=fifo_addr_read+1; // prep for _third_ byte..
      state<=ST_WAITSTART;
	end
	ST_WAITSTART : begin
		if (mac_txdv==0) begin
		   second_byte<=fifo_read;
		end
		mac_txdv<=1;
		if (mac_txack) begin
			state<=ST_BYTES;
			mac_txd<=second_byte; 
			fifo_addr_read<=fifo_addr_read+1; // now has second byte
			packet_sent_len<=2;
		end else begin
			state<=ST_WAITSTART;
			mac_txd<=mac_txd;
			fifo_addr_read<=fifo_addr_read;
		end
	end
	ST_BYTES : begin
		if (end_of_output) begin
			packet_len_rp<=packet_len_rp+1;
			fifo_addr_read<=fifo_addr_read-1; // back off by one...
			mac_txdv<=0;
			state<=ST_IDLE;
		end else begin
			state<=ST_BYTES;
			mac_txdv<=1;
			mac_txd<=fifo_read;
			fifo_addr_read<=fifo_addr_read+1;
			packet_sent_len<=packet_sent_len+1;
		end
	end
	endcase

	reg [11:0] fifo_addr_write=12'b0;
	reg [7:0] fifo_data_write=8'b0;
	reg fifo_we=0;

always @(posedge mac_clk) begin
	fifo_addr_write<=fifo_base_write+packet_addr;
	fifo_data_write<=packet_txd;
	fifo_we<=packet_we;
end

dpbr8 fifo(.clka(mac_clk),
	.wea(fifo_we),
	.addra(fifo_addr_write),
	.dina(fifo_data_write),
	.web(1'b0),
	.dinb(8'b0),
	.clkb(mac_clk),
	.addrb(fifo_addr_read),
	.doutb(fifo_read)
	);

endmodule
