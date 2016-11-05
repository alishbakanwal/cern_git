`timescale 1ns / 1ps

module fifotest(
	input clk,
	input wr_en_0, rd_en_0,
	input rst,
	output [3:0] dout_buff_0,
	output [5:0] rd_data_count, wr_data_count,
	output full_0,
	output empty_0,
	output wr_ack_0
    );

	reg [5:0] counter;
	
	sr_doubleBuffered_buff buff_X (
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
		
	
	always@(posedge clk)
	begin
		if(rst)
			counter <= 0;
		
		else
		begin
			din_buff_0 <= counter;
			counter <= counter + 1;
		end
	end

endmodule
