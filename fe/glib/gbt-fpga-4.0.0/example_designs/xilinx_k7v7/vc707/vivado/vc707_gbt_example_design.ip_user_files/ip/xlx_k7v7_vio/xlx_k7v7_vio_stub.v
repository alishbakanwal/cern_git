// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Sat Apr 16 19:54:10 2016
// Host        : pcphese57 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/gbt_fpga/example_designs/xilinx_k7v7/core_sources/chipscope_vio/vivado/xlx_k7v7_vio_stub.v
// Design      : xlx_k7v7_vio
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2015.3" *)
module xlx_k7v7_vio(clk, probe_in0, probe_in1, probe_in2, probe_in3, probe_in4, probe_in5, probe_in6, probe_in7, probe_in8, probe_in9, probe_in10, probe_in11, probe_in12, probe_out0, probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, probe_out6, probe_out7, probe_out8)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[0:0],probe_in1[0:0],probe_in2[0:0],probe_in3[0:0],probe_in4[0:0],probe_in5[5:0],probe_in6[0:0],probe_in7[0:0],probe_in8[0:0],probe_in9[0:0],probe_in10[0:0],probe_in11[0:0],probe_in12[0:0],probe_out0[0:0],probe_out1[0:0],probe_out2[1:0],probe_out3[2:0],probe_out4[0:0],probe_out5[0:0],probe_out6[0:0],probe_out7[0:0],probe_out8[0:0]" */;
  input clk;
  input [0:0]probe_in0;
  input [0:0]probe_in1;
  input [0:0]probe_in2;
  input [0:0]probe_in3;
  input [0:0]probe_in4;
  input [5:0]probe_in5;
  input [0:0]probe_in6;
  input [0:0]probe_in7;
  input [0:0]probe_in8;
  input [0:0]probe_in9;
  input [0:0]probe_in10;
  input [0:0]probe_in11;
  input [0:0]probe_in12;
  output [0:0]probe_out0;
  output [0:0]probe_out1;
  output [1:0]probe_out2;
  output [2:0]probe_out3;
  output [0:0]probe_out4;
  output [0:0]probe_out5;
  output [0:0]probe_out6;
  output [0:0]probe_out7;
  output [0:0]probe_out8;
endmodule
