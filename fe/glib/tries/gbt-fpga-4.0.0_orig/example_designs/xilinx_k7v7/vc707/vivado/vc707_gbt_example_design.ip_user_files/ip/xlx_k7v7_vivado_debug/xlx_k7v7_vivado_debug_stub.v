// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Sat Apr 16 19:56:01 2016
// Host        : pcphese57 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/gbt_fpga/example_designs/xilinx_k7v7/core_sources/chipscope_ila/vivado/xlx_k7v7_vivado_debug_stub.v
// Design      : xlx_k7v7_vivado_debug
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2015.3" *)
module xlx_k7v7_vivado_debug(clk, probe0, probe1, probe2, probe3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[83:0],probe1[31:0],probe2[3:0],probe3[0:0]" */;
  input clk;
  input [83:0]probe0;
  input [31:0]probe1;
  input [3:0]probe2;
  input [0:0]probe3;
endmodule
