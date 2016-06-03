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
module gbe_rxpacketbuffer(
    input [7:0] mac_rxd,
    input mac_rxdv, reset,
    input mac_rxpacketok,
    input mac_rxpacketbad,
    input mac_clk, clk,
    output [7:0] packet_rxd,
    input [10:0] packet_rxa,
    output reg [10:0] packet_len,
    output reg packet_rxready,
    input packet_rxdone
    );

	reg [10:0] packet_len_acc;
	reg [10:0] packet_len_fifo[7:0]; // store up to eight incoming packets at once
	reg [2:0] packet_len_wp, packet_len_rp;
	wire packet_len_fifo_empty;

  assign packet_len_fifo_empty=(packet_len_wp==packet_len_rp); // clock domain crossing - sync reg below

	reg [7:0] inByteBuffer;
	reg was_packetok, was_rxdone, was_dv;

	reg [11:0] buffer_write_base, buffer_read_base;
	reg [11:0] buffer_addr_write;

//assign buffer_addr_write = buffer_write_base+packet_len_acc;

always @(posedge mac_clk) buffer_addr_write<=buffer_write_base+packet_len_acc;
always @(posedge mac_clk) inByteBuffer<=mac_rxd;
always @(posedge mac_clk) was_dv<=mac_rxdv;
always @(posedge mac_clk) was_packetok<=mac_rxpacketok;

always @(posedge mac_clk) 
	if (reset) begin
		buffer_write_base<=0;
		packet_len_wp<=0;
		packet_len_acc<=0;
	end else if (mac_rxpacketok && !was_packetok) begin // keep the packet
		packet_len_fifo[packet_len_wp]<=packet_len_acc;
		buffer_write_base<=buffer_write_base+packet_len_acc;
	end else if (!mac_rxpacketok && was_packetok) begin // keep the packet (inc count)
		packet_len_wp<=packet_len_wp+1;
		packet_len_acc<=0;
	end else if (mac_rxpacketbad) begin // drop the packet (forget the length...)
		packet_len_acc<=0;
	end else if (mac_rxdv) begin
		packet_len_acc<=packet_len_acc+1;		
	end 

	wire [11:0] buffer_addr_read;
	
assign buffer_addr_read=buffer_read_base+packet_rxa;

always @(posedge clk) begin
	packet_len<=packet_len_fifo[packet_len_rp];
	packet_rxready<=!packet_len_fifo_empty;
	was_rxdone<=packet_rxdone;
end
always @(posedge clk) 
	if (reset) begin
		packet_len_rp<=0;
		buffer_read_base<=0;
	end else if (packet_rxdone && !was_rxdone) begin 
		packet_len_rp<=packet_len_rp+1;
		buffer_read_base<=buffer_read_base+packet_len;
	end
	
dpbr8 fifo(.clka(mac_clk),
	.wea(mac_rxdv || was_dv),
	.addra(buffer_addr_write),
	.dina(inByteBuffer),
	.web(1'b0),
	.dinb(8'b0),
	.clkb(clk),
	.addrb(buffer_addr_read),
	.doutb(packet_rxd)
	);

endmodule
