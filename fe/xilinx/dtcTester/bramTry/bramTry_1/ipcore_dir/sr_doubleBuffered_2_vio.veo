///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.5
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : sr_doubleBuffered_2_vio.veo
// /___/   /\     Timestamp  : Wed Jan 13 12:46:16 Pakistan Standard Time 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: ISE Instantiation template
///////////////////////////////////////////////////////////////////////////////

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
sr_doubleBuffered_2_vio YourInstanceName (
    .CONTROL(CONTROL), // INOUT BUS [35:0]
    .CLK(CLK), // IN
    .ASYNC_IN(ASYNC_IN), // IN BUS [255:0]
    .SYNC_IN(SYNC_IN), // IN BUS [255:0]
    .SYNC_OUT(SYNC_OUT) // OUT BUS [7:0]
);

// INST_TAG_END ------ End INSTANTIATION Template ---------

