`timescale 1ns / 1ps
`define CYCLE 20

module fifotest_tb;

   reg clk;
	reg wr_en_0, rd_en_0;
	reg rst;
	wire [3:0] dout_buff_0;
	wire [5:0] rd_data_count, wr_data_count;
	wire full_0;
	wire empty_0;
	wire wr_ack_0;
	
	sr_doubleBuffered_buff buff_XX (
	  .rst(rst), // input rst
	  .wr_clk(clk), // input wr_clk
     .rd_clk(clk), // input rd_clk
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
	
	always
	begin
		#(`CYCLE/2 )clk = ~clk;
	end
	
	always
	begin
		clk = 0;
		rst = 1;
		#(`CYCLE) rst = 0;
		#140 wr_en_0 = 1;
  		     rd_en_0 = 0;
		
	end


endmodule
