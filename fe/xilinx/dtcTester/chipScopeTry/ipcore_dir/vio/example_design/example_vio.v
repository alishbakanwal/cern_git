//////////////////////////////////////////////////////////////////////////////
//$Date: 2011/09/06 10:39:00 $
//$RCSfile: example_design.ejava,v $
//$Revision: 1.2 $
///////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version : 1.05
//  \   \         Application : VIO V1.05a
//  /   /         Filename : example_vio.v
// /___/   /\     
// \   \  /  \ 
//  \___\/\___\
//
// (c) Copyright 2010 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

`timescale 1ns / 1ps

//The example module here illustrates how vio core can be instantiated in
//a user design. This helps the user on how various ports selected for the core can be used.
module example_vio (
    input clk_i
  );

  //****************************************************************************
  //  Local Signals
  //****************************************************************************
  wire clk;
  wire clr_sync_control;
  wire [35: 0] control0;
  wire [31: 0] sync_in;
  reg  [31: 0] shift_out;
  wire [31: 0] sync_out;
  assign clr_sync_control = sync_out[0];


  BUFG bufg_inst
    (
      .O(clk),
      .I(clk_i)
    );

  //-----------------------------------------------------------------
  //
  //  ICON Pro core instance
  //
  //-----------------------------------------------------------------
  //ICON core is instantiated to connect to vio core

  chipscope_icon icon_inst 
    (
    .CONTROL0  (control0)); // INOUT BUS [35:0]   

  //-----------------------------------------------------------------
  //
  //  VIO Pro core instance
  //
  //-----------------------------------------------------------------  
  //When the example design is run on analyzer, shift operation is observed on
  //SYNC_IN port when selected. If SYNC_OUT is selected, SYNC_OUT[0] acts as 
  //load enable for this shift operation. If ASYNC_OUT is selected, ASYNC_OUT[0] 
  //acts as control to the pattern displayed on ASYNC_IN Port.


  vio VIO_inst 
    (
      .CONTROL(control0), // INOUT BUS [35:0]
      .CLK(clk), // IN
      .SYNC_IN(sync_in), // IN BUS [31:0]
      .SYNC_OUT(sync_out)); // OUT BUS [31:0]

  
  assign sync_in = shift_out;
  // Logic to load and shift
  always @ (posedge clk)
    begin
      if (clr_sync_control == 1'b0)
        begin
          shift_out <= 32'd1; 
        end
      else
        begin
          shift_out <= { shift_out[30:0] , shift_out[31] };
        end
    end


endmodule
