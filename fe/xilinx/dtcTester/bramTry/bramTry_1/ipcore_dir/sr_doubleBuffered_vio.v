///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.5
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : sr_doubleBuffered_vio.v
// /___/   /\     Timestamp  : Thu Jan 07 18:27:44 Pakistan Standard Time 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module sr_doubleBuffered_vio(
    CONTROL,
    CLK,
    SYNC_IN,
    SYNC_OUT) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [63 : 0] SYNC_IN;
output [7 : 0] SYNC_OUT;

endmodule
