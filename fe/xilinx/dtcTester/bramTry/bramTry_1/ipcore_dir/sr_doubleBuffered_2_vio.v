///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.5
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : sr_doubleBuffered_2_vio.v
// /___/   /\     Timestamp  : Wed Jan 13 12:46:16 Pakistan Standard Time 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module sr_doubleBuffered_2_vio(
    CONTROL,
    CLK,
    ASYNC_IN,
    SYNC_IN,
    SYNC_OUT) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [255 : 0] ASYNC_IN;
input [255 : 0] SYNC_IN;
output [7 : 0] SYNC_OUT;

endmodule
