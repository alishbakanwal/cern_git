// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus Prime"
// VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Standard Edition"

// DATE "03/18/2016 09:49:46"

// 
// Device: Altera 10AX115S4F45I3SGE2 Package FBGA1932
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module mgt_atxpll_rst (
	clock,
	pll_powerdown,
	reset)/* synthesis synthesis_greybox=0 */;
input 	clock;
output 	[0:0] pll_powerdown;
input 	reset;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \xcvr_reset_control_0|g_pll.counter_pll_powerdown|r_reset~q ;
wire \clock~input_o ;
wire \reset~input_o ;


mgt_atxpll_rst_altera_xcvr_reset_control xcvr_reset_control_0(
	.r_reset(\xcvr_reset_control_0|g_pll.counter_pll_powerdown|r_reset~q ),
	.clock(\clock~input_o ),
	.reset(\reset~input_o ));

assign \clock~input_o  = clock;

assign \reset~input_o  = reset;

assign pll_powerdown[0] = ~ \xcvr_reset_control_0|g_pll.counter_pll_powerdown|r_reset~q ;

endmodule

module mgt_atxpll_rst_altera_xcvr_reset_control (
	r_reset,
	clock,
	reset)/* synthesis synthesis_greybox=0 */;
output 	r_reset;
input 	clock;
input 	reset;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



mgt_atxpll_rst_alt_xcvr_reset_counter \g_pll.counter_pll_powerdown (
	.r_reset1(r_reset),
	.clk(clock),
	.async_req(reset));

endmodule

module mgt_atxpll_rst_alt_xcvr_reset_counter (
	r_reset1,
	clk,
	async_req)/* synthesis synthesis_greybox=0 */;
output 	r_reset1;
input 	clk;
input 	async_req;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \Add0~9_sumout ;
wire \count[1]~q ;
wire \Add0~2 ;
wire \Add0~25_sumout ;
wire \count[4]~q ;
wire \Add0~26 ;
wire \Add0~21_sumout ;
wire \count[5]~q ;
wire \Add0~22 ;
wire \Add0~17_sumout ;
wire \count[6]~q ;
wire \Add0~18 ;
wire \Add0~13_sumout ;
wire \count[7]~q ;
wire \Equal0~0_combout ;
wire \count[0]~0_combout ;
wire \count[0]~q ;
wire \Add0~10 ;
wire \Add0~5_sumout ;
wire \count[2]~q ;
wire \Add0~6 ;
wire \Add0~1_sumout ;
wire \count[3]~q ;
wire \Equal0~1_combout ;


dffeas r_reset(
	.clk(clk),
	.d(\Equal0~1_combout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(r_reset1),
	.prn(vcc));
defparam r_reset.is_wysiwyg = "true";
defparam r_reset.power_up = "low";

twentynm_lcell_comb \Add0~9 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[0]~q ),
	.datae(gnd),
	.dataf(!\count[1]~q ),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~9_sumout ),
	.cout(\Add0~10 ),
	.shareout());
defparam \Add0~9 .extended_lut = "off";
defparam \Add0~9 .lut_mask = 64'h0000FF00000000FF;
defparam \Add0~9 .shared_arith = "off";

dffeas \count[1] (
	.clk(clk),
	.d(\Add0~9_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[1]~q ),
	.prn(vcc));
defparam \count[1] .is_wysiwyg = "true";
defparam \count[1] .power_up = "low";

twentynm_lcell_comb \Add0~1 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[3]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~6 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~1_sumout ),
	.cout(\Add0~2 ),
	.shareout());
defparam \Add0~1 .extended_lut = "off";
defparam \Add0~1 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~1 .shared_arith = "off";

twentynm_lcell_comb \Add0~25 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[4]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~2 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~25_sumout ),
	.cout(\Add0~26 ),
	.shareout());
defparam \Add0~25 .extended_lut = "off";
defparam \Add0~25 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~25 .shared_arith = "off";

dffeas \count[4] (
	.clk(clk),
	.d(\Add0~25_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[4]~q ),
	.prn(vcc));
defparam \count[4] .is_wysiwyg = "true";
defparam \count[4] .power_up = "low";

twentynm_lcell_comb \Add0~21 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[5]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~26 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~21_sumout ),
	.cout(\Add0~22 ),
	.shareout());
defparam \Add0~21 .extended_lut = "off";
defparam \Add0~21 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~21 .shared_arith = "off";

dffeas \count[5] (
	.clk(clk),
	.d(\Add0~21_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[5]~q ),
	.prn(vcc));
defparam \count[5] .is_wysiwyg = "true";
defparam \count[5] .power_up = "low";

twentynm_lcell_comb \Add0~17 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[6]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~22 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~17_sumout ),
	.cout(\Add0~18 ),
	.shareout());
defparam \Add0~17 .extended_lut = "off";
defparam \Add0~17 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~17 .shared_arith = "off";

dffeas \count[6] (
	.clk(clk),
	.d(\Add0~17_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[6]~q ),
	.prn(vcc));
defparam \count[6] .is_wysiwyg = "true";
defparam \count[6] .power_up = "low";

twentynm_lcell_comb \Add0~13 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[7]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~18 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~13_sumout ),
	.cout(),
	.shareout());
defparam \Add0~13 .extended_lut = "off";
defparam \Add0~13 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~13 .shared_arith = "off";

dffeas \count[7] (
	.clk(clk),
	.d(\Add0~13_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[7]~q ),
	.prn(vcc));
defparam \count[7] .is_wysiwyg = "true";
defparam \count[7] .power_up = "low";

twentynm_lcell_comb \Equal0~0 (
	.dataa(!\count[7]~q ),
	.datab(!\count[6]~q ),
	.datac(!\count[5]~q ),
	.datad(!\count[4]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(\Equal0~0_combout ),
	.sumout(),
	.cout(),
	.shareout());
defparam \Equal0~0 .extended_lut = "off";
defparam \Equal0~0 .lut_mask = 64'h0100010001000100;
defparam \Equal0~0 .shared_arith = "off";

twentynm_lcell_comb \count[0]~0 (
	.dataa(!\count[3]~q ),
	.datab(!\count[2]~q ),
	.datac(!\count[1]~q ),
	.datad(!\count[0]~q ),
	.datae(!\Equal0~0_combout ),
	.dataf(gnd),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(\count[0]~0_combout ),
	.sumout(),
	.cout(),
	.shareout());
defparam \count[0]~0 .extended_lut = "off";
defparam \count[0]~0 .lut_mask = 64'hFF00FF01FF00FF01;
defparam \count[0]~0 .shared_arith = "off";

dffeas \count[0] (
	.clk(clk),
	.d(\count[0]~0_combout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\count[0]~q ),
	.prn(vcc));
defparam \count[0] .is_wysiwyg = "true";
defparam \count[0] .power_up = "low";

twentynm_lcell_comb \Add0~5 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(!\count[2]~q ),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(\Add0~10 ),
	.sharein(gnd),
	.combout(),
	.sumout(\Add0~5_sumout ),
	.cout(\Add0~6 ),
	.shareout());
defparam \Add0~5 .extended_lut = "off";
defparam \Add0~5 .lut_mask = 64'h0000FFFF000000FF;
defparam \Add0~5 .shared_arith = "off";

dffeas \count[2] (
	.clk(clk),
	.d(\Add0~5_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[2]~q ),
	.prn(vcc));
defparam \count[2] .is_wysiwyg = "true";
defparam \count[2] .power_up = "low";

dffeas \count[3] (
	.clk(clk),
	.d(\Add0~1_sumout ),
	.asdata(vcc),
	.clrn(!async_req),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(!\Equal0~1_combout ),
	.q(\count[3]~q ),
	.prn(vcc));
defparam \count[3] .is_wysiwyg = "true";
defparam \count[3] .power_up = "low";

twentynm_lcell_comb \Equal0~1 (
	.dataa(!\count[3]~q ),
	.datab(!\count[2]~q ),
	.datac(!\count[1]~q ),
	.datad(!\count[0]~q ),
	.datae(!\Equal0~0_combout ),
	.dataf(gnd),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(\Equal0~1_combout ),
	.sumout(),
	.cout(),
	.shareout());
defparam \Equal0~1 .extended_lut = "off";
defparam \Equal0~1 .lut_mask = 64'h0000000100000001;
defparam \Equal0~1 .shared_arith = "off";

endmodule
