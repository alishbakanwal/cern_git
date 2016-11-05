///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2015 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.5
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : icon.v
// /___/   /\     Timestamp  : Fri Nov 20 17:41:40 Pakistan Standard Time 2015
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module icon(
    CONTROL0,
    CONTROL1) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL0;
inout [35 : 0] CONTROL1;

endmodule
