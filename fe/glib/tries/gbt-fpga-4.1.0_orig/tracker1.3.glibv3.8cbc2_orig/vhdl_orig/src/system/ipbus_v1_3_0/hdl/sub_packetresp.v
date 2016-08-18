`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:47 02/02/2010 
// Design Name: 
// Module Name:    sub_packetresp 
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
module sub_packetresp(
    input ipb_clk,
    input mac_clk,
    input reset,
//    output avail,
    output tx_req,
	 output reg tx_send, 
	 output reg we,
    input done, tx_ok,
    output reg [10:0] txa,
    output [10:0] txl,
    output reg [7:0] txd,
	 input [8:0] len,
    input [31:0] respData,
    input [8:0] respAddr,
    input respWE
    );

	reg half;
	reg bottomFull;
	reg [3:0] state;
	reg [10:0] rplen [1:0];

initial
	begin
		half = 0;
		bottomFull = 0;
		state = 4'b0;
		rplen[0] = 11'b0; 
		rplen[1] = 11'b0; 
	end
	
parameter ST_IDLE      = 4'h0;
parameter ST_PREPCOPY  = 4'h1;
parameter ST_COPY      = 4'h2;
parameter ST_COPYWAIT  = 4'h3;
parameter ST_DONE      = 4'h4;
parameter ST_CSUM0     = 4'h5;
parameter ST_CSUM1     = 4'h6;
parameter ST_CSUM2     = 4'h7;
parameter ST_CSUM3     = 4'h8;
	
assign tx_req=(state!=ST_IDLE);
//assign avail=~bottomFull;
assign txl=rplen[~half];

	reg [10:0] rdAddr;
	wire [7:0] rdData;
	wire [15:0] checksum_ip, checksum_udp;

initial
	begin
		rdAddr = 11'b0;
	end
	
dpbr_8_32 buffer(
	.clka(ipb_clk),
	.wea(respWE),
	.addra({half,respAddr}), // clock domain crossing - safe due to handshake
	.dina(respData),
	.clkb(mac_clk),
	.web(1'b0),
	.addrb({~half,rdAddr}),
	.dinb(8'h0),
	.doutb(rdData)
);

reg done_mac, done_mac_d;

always @(posedge mac_clk)
begin
  done_mac <= done; // clock domain crossing - needs sync reg (multiple dest?)
  done_mac_d <= done_mac;
end

always @(posedge mac_clk)
//	if (reset) bottomFull<=0;
//	else if (done_mac) bottomFull<=1;
//	else if (state==ST_PREPCOPY && tx_ok) bottomFull<=0;
//	else bottomFull<=bottomFull;
  if(reset) bottomFull <= 0;
  else if (done_mac && !done_mac_d) bottomFull <= 1;
  else if (state==ST_PREPCOPY && tx_ok) bottomFull <= 0;

	wire [10:0] copy_source_next;
	wire [10:0] txaNext;
	wire [7:0] txdForAddr;
	
	reg [15:0] ip_len, udp_len;

initial
	begin
		ip_len = 16'b0;
		udp_len = 16'b0;
	end

	
	assign txaNext=txa+1;

always @(posedge mac_clk)
	if (reset) begin 
		state<=ST_IDLE;
		we<=0;
		half<=0;
                // Greg start
                tx_send<=0;
                // Greg end
	end
	else case (state)
	ST_IDLE : 
		if (bottomFull) begin // topFull must be zero!
			half<=~half;
			rdAddr<=2+6; // must swap ethernet addresses
			txa<=0;
			state<=ST_PREPCOPY;
		end else begin
			we<=0;
			state<=ST_IDLE;
		end
	ST_PREPCOPY : if (tx_ok) begin
		txd<=rdData;
		rdAddr<=copy_source_next;			
		rplen[~half]<={len,2'h0}+11'd14+11'd28; // ENET+IP+UDP		
		ip_len<={len,2'h0}+11'd28; // IP+UDP
		udp_len<={len,2'h0}+11'd8; // UDP		
		state<=ST_COPYWAIT;
		we<=1;
	end else state<=ST_PREPCOPY;
	ST_COPYWAIT : begin 
		rdAddr<=copy_source_next;			
		state<=ST_COPY;
	end
	ST_COPY : if (txa==txl) begin
		we<=0;
		state<=ST_CSUM0;
	end else begin
		we<=1;
		state<=ST_COPY;
		txa<=txaNext;
		txd<=txdForAddr;
		rdAddr<=copy_source_next;		
	end
	ST_CSUM0 : begin
		txd<=checksum_ip[15:8];
		txa<=11'd24; // first byte of checksum
		we<=1;
		state<=ST_CSUM1;
	end
	ST_CSUM1 : begin
		txd<=checksum_ip[7:0];
		txa<=11'd25; // second byte of checksum
		we<=1;
		state<=ST_CSUM2;
	end
	ST_CSUM2 : begin
		txd<=checksum_udp[15:8];
		txa<=11'd40; // second byte of checksum
		we<=1;
		state<=ST_CSUM3;
	end
	ST_CSUM3 : begin
		txd<=checksum_udp[7:0];
		txa<=11'd41; // second byte of checksum
		we<=1;
		state<=ST_DONE;
	end
	ST_DONE : begin
		we<=0;
		if (tx_send) begin
			tx_send<=0;
			state<=ST_IDLE;
		end else begin
			tx_send<=1;
			state<=ST_DONE;
		end
		end
	endcase


assign copy_source_next = (rdAddr==11'd13)?(11'd2):
								  (rdAddr==11'd7)?(11'd14):
								  (rdAddr+1);

assign txdForAddr = (txaNext==11'd16)?(ip_len[15:8]):
							(txaNext==11'd17)?(ip_len[7:0]):
							(txaNext==11'd38)?(udp_len[15:8]):
							(txaNext==11'd39)?(udp_len[7:0]):
							rdData;

	wire isIPsum;
	
// do not add in the checksum itself ==> equivalent to adding zero
assign isIPsum=(state==ST_COPY) && ((txa>=11'd14 && txa<=11'd23) || (txa>=11'd26 && txa<=11'd33)); 

ip_checksum_8bit ipCSUM(.clk(mac_clk),.dv_even(!txa[0] && isIPsum),.dv_odd(txa[0] && isIPsum),
	.data(txd), .checksum(checksum_ip),	.reset(state==ST_IDLE));


// do not add in the checksum itself ==> equivalent to adding zero
assign isUDPsum=(state==ST_COPY) && ((txa>=11'd24)); 

	wire [7:0] udp_csum_input;
	
assign udp_csum_input=
							 (txa==11'd24)?(8'd0):
  							 (txa==11'd25)?(8'd17):
							 (txa==11'd40)?(udp_len[15:8]):
							 (txa==11'd41)?(udp_len[7:0]):
							  txd;

ip_checksum_8bit udpCSUM(.clk(mac_clk),.dv_even(!txa[0] && isUDPsum),.dv_odd(txa[0] && isUDPsum),
	.data(udp_csum_input), .checksum(checksum_udp),	.reset(state==ST_IDLE));



endmodule
