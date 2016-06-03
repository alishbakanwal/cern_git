// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Sun Apr 17 00:42:49 2016
// Host        : pcphese57 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/gbt_fpga/example_designs/xilinx_k7v7/fc7/vivado_project/fc7_gbt_example_design.srcs/sources_1/ip/xlx_k7v7_tx_dpram/xlx_k7v7_tx_dpram_stub.v
// Design      : xlx_k7v7_tx_dpram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_0,Vivado 2015.3" *)
module xlx_k7v7_tx_dpram(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[2:0],dina[159:0],clkb,addrb[4:0],doutb[39:0]" */;
  input clka;
  input [0:0]wea;
  input [2:0]addra;
  input [159:0]dina;
  input clkb;
  input [4:0]addrb;
  output [39:0]doutb;
endmodule
