`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:46 02/02/2010 
// Design Name: 
// Module Name:    sub_packetreq 
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
module sub_packetreq(
    input ipb_clk, mac_clk, reset,
    input incoming_ready, done_with_packet,
    output copydone, packet_avail, busy,
    input [10:0] rxl,
	 output reg [10:0] rxa,
	 input [7:0] rxd,
	 input [8:0] readAddr,
	 output [31:0] readData,
	 output [8:0] len
    );

	reg half;
	reg topFull, bottomFull;
	reg [1:0] state;
	reg we;
	reg [8:0] rqlen[1:0];

initial
	begin
		half = 0;
		bottomFull = 0;
		topFull = 0;
		state = 2'b0;
		rqlen[0] = 9'b0; 
		rqlen[1] = 9'b0; 
	end
	
parameter ST_IDLE = 2'h0;
parameter ST_COPY = 2'h1;
parameter ST_DONE = 2'h2;
	
assign copydone=(state==ST_DONE);
assign busy=topFull;

reg packet_avail_ipb;

always @(posedge ipb_clk)
  packet_avail_ipb <= bottomFull; // clock domain crossing - needs sync reg (multiple dest)

assign packet_avail=packet_avail_ipb; 
assign len=rqlen[half];

	reg [10:0] rqAddr;
	reg [10:0] iplen;

initial
	begin
		rqAddr = 11'b0; 
		iplen = 11'b0; 
	end

dpbr_8_32 buffer(
	.clka(ipb_clk),
	.wea(1'b0),
	.addra({half,readAddr}), // clock domain crossing - safe due to handshake
	.dina(32'h0),
	.douta(readData),
	.clkb(mac_clk),
	.web(we),
	.addrb({~half,rqAddr}),
	.dinb(rxd)
);

reg dwp_mac;

always @(posedge mac_clk)
  dwp_mac <= done_with_packet; // clock domain crossing - needs sync reg (multiple dest)

always @(posedge mac_clk)
	if (reset) begin 
		state<=ST_IDLE;
		we<=0;
		topFull<=0;
		bottomFull<=0;
		half<=0;
	end
	else case (state)
	ST_IDLE : if (!topFull && incoming_ready) begin
		rqAddr<=1; // provide one delay state (should logically start at 2) 
		rxa<=0;
		we<=1;
		state<=ST_COPY;
	end else begin
		if (dwp_mac) begin
			bottomFull<=topFull;
			topFull<=0;
			half<=~half;
		end
		we<=0;
		state<=ST_IDLE;
	end
	ST_COPY : if (rxa==rxl) begin
		we<=0;
		state<=ST_DONE;
	end else begin
		we<=1;
		state<=ST_COPY;
		rxa<=rxa+1;
		rqAddr<=rqAddr+1;
		iplen<=rxl-11'd14;
//		if (rxa==11'd17) iplen[15:8]<=rxd;  // offset by one for pipelining
//		if (rxa==11'd18) iplen[7:0]<=rxd;   // offset by one for pipelining
	end
	ST_DONE : 
		if (!incoming_ready) begin
			rqlen[~half]<=iplen[10:2]-9'd7; 		
//			rqlen[~half]<=9'd3;
			if (!bottomFull) begin
				bottomFull<=1;
				topFull<=0;
				half<=~half;
			end else begin
				topFull<=1;
				half<=half;
				bottomFull<=1;
			end
			state<=ST_IDLE;		
		end else state<=ST_DONE;
	endcase

endmodule
