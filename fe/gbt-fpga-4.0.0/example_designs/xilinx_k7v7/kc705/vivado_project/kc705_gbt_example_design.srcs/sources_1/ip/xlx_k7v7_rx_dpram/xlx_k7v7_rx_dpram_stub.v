// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Mon Apr 18 09:40:36 2016
// Host        : pcphese57 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/GBT-FPGA/trunk/example_designs/xilinx_k7v7/kc705/vivado_project/kc705_gbt_example_design.srcs/sources_1/ip/xlx_k7v7_rx_dpram/xlx_k7v7_rx_dpram_stub.v
// Design      : xlx_k7v7_rx_dpram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_0,Vivado 2015.3" *)
module xlx_k7v7_rx_dpram(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[4:0],dina[39:0],clkb,addrb[2:0],doutb[159:0]" */;
  input clka;
  input [0:0]wea;
  input [4:0]addra;
  input [39:0]dina;
  input clkb;
  input [2:0]addrb;
  output [159:0]doutb;
endmodule