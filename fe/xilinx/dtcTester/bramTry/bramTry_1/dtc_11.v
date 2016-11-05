
`timescale 1ns / 1ps

module dtc_11(
	input clk_in
    );

	reg [7:0] temp;
	reg [7:0]counter;
	reg count_8;
	
	wire [35:0] control_0, control_1;
	wire [255:0] sync_in;
	wire [255:0] async_in;
	wire [7:0] sync_out;
	wire [255:0] trig_0;
	wire [255:0] trig_1;
	wire [255:0] trig_2;
	wire [255:0] trig_3;
	
	
	sr_doubleBuffered_clkDiv instance_name(// Clock in ports
    .CLK_IN1(clk_in),      // IN
    // Clock out ports
    .CLK_OUT1(clk),     // OUT
    .CLK_OUT2(clk_rx)  // rx clock x10 slower than tx
	 );    // OUT


	always@(posedge clk)
	begin
		counter <= counter+ 1;
		
		if(counter == 7)
		begin
			count_8 <= 1;
			counter <= 0;
		end
		
		else
			count_8 <= 0;
	end
	
	wire [3:0] a, b;
	assign a = 4'b1111;
	assign b = 4'b0000;
	
	always@(posedge clk or posedge count_8)
	begin
		if(count_8)
			temp <= {a, b};
			
		else
			temp <= {temp[0], temp[7:1]};
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
	
	assign trig_0 = {temp, count_8};

	
	assign sync_in = {temp, count_8};
	// assign async_in = {douta_0};
	assign rst = sync_out[0];
		
		
		
endmodule
