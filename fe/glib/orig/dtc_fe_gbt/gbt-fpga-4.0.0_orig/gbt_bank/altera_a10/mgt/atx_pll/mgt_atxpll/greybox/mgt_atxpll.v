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

// DATE "03/16/2016 15:07:20"

// 
// Device: Altera 10AX115S4F45I3SGE2 Package FBGA1932
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module mgt_atxpll (
	mcgb_rst,
	pll_cal_busy,
	pll_locked,
	pll_powerdown,
	pll_refclk0,
	tx_bonding_clocks,
	tx_serial_clk)/* synthesis synthesis_greybox=0 */;
input 	mcgb_rst;
output 	pll_cal_busy;
output 	pll_locked;
input 	pll_powerdown;
input 	pll_refclk0;
output 	[5:0] tx_bonding_clocks;
output 	tx_serial_clk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \xcvr_atx_pll_a10_0|a10_xcvr_avmm_inst|pld_cal_done[0] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_serial_clk_8g ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_locked ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[0] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[1] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[2] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[3] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[4] ;
wire \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|mcgb_serial_clk ;
wire \mcgb_rst~input_o ;
wire \pll_powerdown~input_o ;
wire \pll_refclk0~input_o ;


mgt_atxpll_altera_xcvr_atx_pll_a10 xcvr_atx_pll_a10_0(
	.pld_cal_done_0(\xcvr_atx_pll_a10_0|a10_xcvr_avmm_inst|pld_cal_done[0] ),
	.tx_serial_clk(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_serial_clk_8g ),
	.pll_locked(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_locked ),
	.tx_bonding_clocks_0(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[0] ),
	.tx_bonding_clocks_1(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[1] ),
	.tx_bonding_clocks_2(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[2] ),
	.tx_bonding_clocks_3(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[3] ),
	.tx_bonding_clocks_4(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[4] ),
	.mcgb_serial_clk(\xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|mcgb_serial_clk ),
	.pll_refclk0(\pll_refclk0~input_o ));

assign \pll_refclk0~input_o  = pll_refclk0;

assign pll_cal_busy = ~ \xcvr_atx_pll_a10_0|a10_xcvr_avmm_inst|pld_cal_done[0] ;

assign pll_locked = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_locked ;

assign tx_bonding_clocks[0] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[0] ;

assign tx_bonding_clocks[1] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[1] ;

assign tx_bonding_clocks[2] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[2] ;

assign tx_bonding_clocks[3] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[3] ;

assign tx_bonding_clocks[4] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|tx_bonding_clocks[4] ;

assign tx_bonding_clocks[5] = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|mcgb_serial_clk ;

assign tx_serial_clk = \xcvr_atx_pll_a10_0|a10_xcvr_atx_pll_inst|pll_serial_clk_8g ;

assign \mcgb_rst~input_o  = mcgb_rst;

assign \pll_powerdown~input_o  = pll_powerdown;

endmodule

module mgt_atxpll_altera_xcvr_atx_pll_a10 (
	pld_cal_done_0,
	tx_serial_clk,
	pll_locked,
	tx_bonding_clocks_0,
	tx_bonding_clocks_1,
	tx_bonding_clocks_2,
	tx_bonding_clocks_3,
	tx_bonding_clocks_4,
	mcgb_serial_clk,
	pll_refclk0)/* synthesis synthesis_greybox=0 */;
output 	pld_cal_done_0;
output 	tx_serial_clk;
output 	pll_locked;
output 	tx_bonding_clocks_0;
output 	tx_bonding_clocks_1;
output 	tx_bonding_clocks_2;
output 	tx_bonding_clocks_3;
output 	tx_bonding_clocks_4;
output 	mcgb_serial_clk;
input 	pll_refclk0;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \a10_xcvr_avmm_inst|chnl_pll_avmm_clk[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_read[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_rstn[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_write[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[1] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[2] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[3] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[4] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[5] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[6] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[7] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_address[8] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[0] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ;
wire \a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ;
wire \a10_xcvr_atx_pll_inst|blockselect_lc ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[0] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[1] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[2] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[3] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[4] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[5] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[6] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_lc[7] ;
wire \a10_xcvr_atx_pll_inst|blockselect_refclk ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[0] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[1] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[2] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[3] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[4] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[5] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[6] ;
wire \a10_xcvr_atx_pll_inst|avmmreaddata_refclk[7] ;


mgt_atxpll_twentynm_xcvr_avmm a10_xcvr_avmm_inst(
	.chnl_pll_avmm_clk({\a10_xcvr_avmm_inst|chnl_pll_avmm_clk[0] }),
	.pld_cal_done({pld_cal_done_0}),
	.chnl_pll_avmm_read({\a10_xcvr_avmm_inst|chnl_pll_avmm_read[0] }),
	.chnl_pll_avmm_rstn({\a10_xcvr_avmm_inst|chnl_pll_avmm_rstn[0] }),
	.chnl_pll_avmm_write({\a10_xcvr_avmm_inst|chnl_pll_avmm_write[0] }),
	.chnl_pll_avmm_address({\a10_xcvr_avmm_inst|chnl_pll_avmm_address[8] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[7] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[6] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[5] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[4] ,
\a10_xcvr_avmm_inst|chnl_pll_avmm_address[3] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[2] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[1] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[0] }),
	.chnl_pll_avmm_writedata({\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ,
\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[0] }),
	.pll_blockselect_lc_pll({\a10_xcvr_atx_pll_inst|blockselect_lc }),
	.pll_avmmreaddata_lc_pll({\a10_xcvr_atx_pll_inst|avmmreaddata_lc[7] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[6] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[5] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[4] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[3] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[2] ,
\a10_xcvr_atx_pll_inst|avmmreaddata_lc[1] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[0] }),
	.pll_blockselect_lc_refclk_select({\a10_xcvr_atx_pll_inst|blockselect_refclk }),
	.pll_avmmreaddata_lc_refclk_select({\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[7] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[6] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[5] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[4] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[3] ,
\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[2] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[1] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[0] }));

mgt_atxpll_a10_xcvr_atx_pll a10_xcvr_atx_pll_inst(
	.pll_avmm_clk({\a10_xcvr_avmm_inst|chnl_pll_avmm_clk[0] }),
	.pll_avmm_read({\a10_xcvr_avmm_inst|chnl_pll_avmm_read[0] }),
	.pll_avmm_rstn({\a10_xcvr_avmm_inst|chnl_pll_avmm_rstn[0] }),
	.pll_avmm_write({\a10_xcvr_avmm_inst|chnl_pll_avmm_write[0] }),
	.pll_avmm_address({\a10_xcvr_avmm_inst|chnl_pll_avmm_address[8] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[7] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[6] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[5] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[4] ,
\a10_xcvr_avmm_inst|chnl_pll_avmm_address[3] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[2] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[1] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_address[0] }),
	.pll_avmm_writedata({\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ,
\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ,\a10_xcvr_avmm_inst|chnl_pll_avmm_writedata[0] }),
	.pll_blockselect_lc({\a10_xcvr_atx_pll_inst|blockselect_lc }),
	.pll_serial_clk_8g(tx_serial_clk),
	.pll_locked(pll_locked),
	.pll_avmmreaddata_lc({\a10_xcvr_atx_pll_inst|avmmreaddata_lc[7] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[6] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[5] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[4] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[3] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[2] ,
\a10_xcvr_atx_pll_inst|avmmreaddata_lc[1] ,\a10_xcvr_atx_pll_inst|avmmreaddata_lc[0] }),
	.tx_bonding_clocks({tx_bonding_clocks_unconnected_wire_5,tx_bonding_clocks_4,tx_bonding_clocks_3,tx_bonding_clocks_2,tx_bonding_clocks_1,tx_bonding_clocks_0}),
	.mcgb_serial_clk(mcgb_serial_clk),
	.pll_blockselect_refclk({\a10_xcvr_atx_pll_inst|blockselect_refclk }),
	.pll_avmmreaddata_refclk({\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[7] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[6] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[5] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[4] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[3] ,
\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[2] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[1] ,\a10_xcvr_atx_pll_inst|avmmreaddata_refclk[0] }),
	.pll_refclk0(pll_refclk0));

endmodule

module mgt_atxpll_a10_xcvr_atx_pll (
	pll_avmm_clk,
	pll_avmm_read,
	pll_avmm_rstn,
	pll_avmm_write,
	pll_avmm_address,
	pll_avmm_writedata,
	pll_blockselect_lc,
	pll_serial_clk_8g,
	pll_locked,
	pll_avmmreaddata_lc,
	tx_bonding_clocks,
	mcgb_serial_clk,
	pll_blockselect_refclk,
	pll_avmmreaddata_refclk,
	pll_refclk0)/* synthesis synthesis_greybox=0 */;
input 	[0:0] pll_avmm_clk;
input 	[0:0] pll_avmm_read;
input 	[0:0] pll_avmm_rstn;
input 	[0:0] pll_avmm_write;
input 	[8:0] pll_avmm_address;
input 	[7:0] pll_avmm_writedata;
output 	[0:0] pll_blockselect_lc;
output 	pll_serial_clk_8g;
output 	pll_locked;
output 	[7:0] pll_avmmreaddata_lc;
output 	[5:0] tx_bonding_clocks;
output 	mcgb_serial_clk;
output 	[0:0] pll_blockselect_refclk;
output 	[7:0] pll_avmmreaddata_refclk;
input 	pll_refclk0;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire pll_serial_clk_16g;
wire \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE0 ;
wire \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE1 ;
wire refclk_mux_out;

wire [7:0] twentynm_atx_pll_inst_AVMMREADDATA_bus;
wire [5:0] twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus;
wire [1:0] twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus;
wire [7:0] twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus;

assign pll_avmmreaddata_lc[0] = twentynm_atx_pll_inst_AVMMREADDATA_bus[0];
assign pll_avmmreaddata_lc[1] = twentynm_atx_pll_inst_AVMMREADDATA_bus[1];
assign pll_avmmreaddata_lc[2] = twentynm_atx_pll_inst_AVMMREADDATA_bus[2];
assign pll_avmmreaddata_lc[3] = twentynm_atx_pll_inst_AVMMREADDATA_bus[3];
assign pll_avmmreaddata_lc[4] = twentynm_atx_pll_inst_AVMMREADDATA_bus[4];
assign pll_avmmreaddata_lc[5] = twentynm_atx_pll_inst_AVMMREADDATA_bus[5];
assign pll_avmmreaddata_lc[6] = twentynm_atx_pll_inst_AVMMREADDATA_bus[6];
assign pll_avmmreaddata_lc[7] = twentynm_atx_pll_inst_AVMMREADDATA_bus[7];

assign tx_bonding_clocks[0] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[0];
assign tx_bonding_clocks[1] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[1];
assign tx_bonding_clocks[2] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[2];
assign tx_bonding_clocks[3] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[3];
assign tx_bonding_clocks[4] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[4];
assign mcgb_serial_clk = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[5];

assign \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE0  = twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus[0];
assign \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE1  = twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus[1];

assign pll_avmmreaddata_refclk[0] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[0];
assign pll_avmmreaddata_refclk[1] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[1];
assign pll_avmmreaddata_refclk[2] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[2];
assign pll_avmmreaddata_refclk[3] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[3];
assign pll_avmmreaddata_refclk[4] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[4];
assign pll_avmmreaddata_refclk[5] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[5];
assign pll_avmmreaddata_refclk[6] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[6];
assign pll_avmmreaddata_refclk[7] = twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus[7];

twentynm_atx_pll twentynm_atx_pll_inst(
	.avmmclk(pll_avmm_clk[0]),
	.avmmread(pll_avmm_read[0]),
	.avmmrstn(pll_avmm_rstn[0]),
	.avmmwrite(pll_avmm_write[0]),
	.core_clk(),
	.lf_rst_n(vcc),
	.refclk(refclk_mux_out),
	.rst_n(vcc),
	.avmmaddress({pll_avmm_address[8],pll_avmm_address[7],pll_avmm_address[6],pll_avmm_address[5],pll_avmm_address[4],pll_avmm_address[3],pll_avmm_address[2],pll_avmm_address[1],pll_avmm_address[0]}),
	.avmmwritedata({pll_avmm_writedata[7],pll_avmm_writedata[6],pll_avmm_writedata[5],pll_avmm_writedata[4],pll_avmm_writedata[3],pll_avmm_writedata[2],pll_avmm_writedata[1],pll_avmm_writedata[0]}),
	.iqtxrxclk({gnd,gnd,gnd,gnd,gnd,gnd}),
	.blockselect(pll_blockselect_lc[0]),
	.clk0_16g(pll_serial_clk_16g),
	.clk0_8g(pll_serial_clk_8g),
	.clk180_16g(),
	.clk180_8g(),
	.clklow_buf(),
	.fref_buf(),
	.hclk_out(),
	.iqtxrxclk_out(),
	.lc_to_fpll_refclk(),
	.lock(pll_locked),
	.overrange(),
	.underrange(),
	.avmmreaddata(twentynm_atx_pll_inst_AVMMREADDATA_bus),
	.m_cnt_int());
defparam twentynm_atx_pll_inst.analog_mode = "user_custom";
defparam twentynm_atx_pll_inst.bandwidth_range_high = "0 hz";
defparam twentynm_atx_pll_inst.bandwidth_range_low = "0 hz";
defparam twentynm_atx_pll_inst.bonding = "cpri_bonding";
defparam twentynm_atx_pll_inst.bw_sel = "medium";
defparam twentynm_atx_pll_inst.cal_status = "cal_done";
defparam twentynm_atx_pll_inst.calibration_mode = "cal_off";
defparam twentynm_atx_pll_inst.cascadeclk_test = "cascadetest_off";
defparam twentynm_atx_pll_inst.cgb_div = 1;
defparam twentynm_atx_pll_inst.clk_high_perf_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.clk_low_power_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.clk_mid_power_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.cp_compensation_enable = "false";
defparam twentynm_atx_pll_inst.cp_current_setting = "cp_current_setting26";
defparam twentynm_atx_pll_inst.cp_lf_3rd_pole_freq = "lf_3rd_pole_setting1";
defparam twentynm_atx_pll_inst.cp_lf_order = "lf_3rd_order";
defparam twentynm_atx_pll_inst.cp_testmode = "cp_normal";
defparam twentynm_atx_pll_inst.d2a_voltage = "d2a_setting_4";
defparam twentynm_atx_pll_inst.datarate = "4800000000 bps";
defparam twentynm_atx_pll_inst.device_variant = "device1";
defparam twentynm_atx_pll_inst.dprio_clk_vreg_boost_expected_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.dprio_clk_vreg_boost_scratch = 3'b000;
defparam twentynm_atx_pll_inst.dprio_clk_vreg_boost_step_size = 5'b00000;
defparam twentynm_atx_pll_inst.dprio_lc_vreg1_boost_expected_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.dprio_lc_vreg1_boost_scratch = 3'b000;
defparam twentynm_atx_pll_inst.dprio_lc_vreg_boost_expected_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.dprio_lc_vreg_boost_scratch = 3'b000;
defparam twentynm_atx_pll_inst.dprio_mcgb_vreg_boost_expected_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.dprio_mcgb_vreg_boost_scratch = 3'b000;
defparam twentynm_atx_pll_inst.dprio_mcgb_vreg_boost_step_size = 5'b00000;
defparam twentynm_atx_pll_inst.dprio_vreg1_boost_step_size = 5'b00000;
defparam twentynm_atx_pll_inst.dprio_vreg_boost_step_size = 5'b00000;
defparam twentynm_atx_pll_inst.dsm_ecn_bypass = "false";
defparam twentynm_atx_pll_inst.dsm_ecn_test_en = "false";
defparam twentynm_atx_pll_inst.dsm_fractional_division = 32'b00000000000000000000000000000001;
defparam twentynm_atx_pll_inst.dsm_fractional_value_ready = "pll_k_ready";
defparam twentynm_atx_pll_inst.dsm_mode = "dsm_mode_integer";
defparam twentynm_atx_pll_inst.dsm_out_sel = "pll_dsm_disable";
defparam twentynm_atx_pll_inst.enable_hclk = "hclk_disabled";
defparam twentynm_atx_pll_inst.enable_lc_calibration = "false";
defparam twentynm_atx_pll_inst.enable_lc_vreg_calibration = "false";
defparam twentynm_atx_pll_inst.expected_lc_boost_voltage = 12'b000000000000;
defparam twentynm_atx_pll_inst.f_max_lcnt_fpll_cascading = 36'b000000000000000000000000000000000001;
defparam twentynm_atx_pll_inst.f_max_pfd = "0 hz";
defparam twentynm_atx_pll_inst.f_max_pfd_fractional = "0 hz";
defparam twentynm_atx_pll_inst.f_max_ref = "0 hz";
defparam twentynm_atx_pll_inst.f_max_tank_0 = "0 hz";
defparam twentynm_atx_pll_inst.f_max_tank_1 = "0 hz";
defparam twentynm_atx_pll_inst.f_max_tank_2 = "0 hz";
defparam twentynm_atx_pll_inst.f_max_vco = "0 hz";
defparam twentynm_atx_pll_inst.f_max_vco_fractional = "0 hz";
defparam twentynm_atx_pll_inst.f_max_x1 = "0 hz";
defparam twentynm_atx_pll_inst.f_min_pfd = "0 hz";
defparam twentynm_atx_pll_inst.f_min_ref = "0 hz";
defparam twentynm_atx_pll_inst.f_min_tank_0 = "0 hz";
defparam twentynm_atx_pll_inst.f_min_tank_1 = "0 hz";
defparam twentynm_atx_pll_inst.f_min_tank_2 = "0 hz";
defparam twentynm_atx_pll_inst.f_min_vco = "0 hz";
defparam twentynm_atx_pll_inst.fb_select = "direct_fb";
defparam twentynm_atx_pll_inst.fpll_refclk_selection = "select_vco_output";
defparam twentynm_atx_pll_inst.hclk_divide = 1;
defparam twentynm_atx_pll_inst.initial_settings = "true";
defparam twentynm_atx_pll_inst.iqclk_mux_sel = "iqtxrxclk0";
defparam twentynm_atx_pll_inst.is_cascaded_pll = "false";
defparam twentynm_atx_pll_inst.l_counter = 4;
defparam twentynm_atx_pll_inst.l_counter_enable = "true";
defparam twentynm_atx_pll_inst.l_counter_scratch = 5'b00001;
defparam twentynm_atx_pll_inst.lc_atb = "atb_selectdisable";
defparam twentynm_atx_pll_inst.lc_mode = "lccmu_normal";
defparam twentynm_atx_pll_inst.lc_to_fpll_l_counter = "lcounter_setting0";
defparam twentynm_atx_pll_inst.lc_to_fpll_l_counter_scratch = 5'b00001;
defparam twentynm_atx_pll_inst.lf_cbig_size = "lf_cbig_setting4";
defparam twentynm_atx_pll_inst.lf_resistance = "lf_setting1";
defparam twentynm_atx_pll_inst.lf_ripplecap = "lf_ripple_cap_0";
defparam twentynm_atx_pll_inst.m_counter = 40;
defparam twentynm_atx_pll_inst.max_fractional_percentage = 7'b0000000;
defparam twentynm_atx_pll_inst.min_fractional_percentage = 7'b0000000;
defparam twentynm_atx_pll_inst.n_counter_scratch = 3'b001;
defparam twentynm_atx_pll_inst.output_clock_frequency = "2400000000 hz";
defparam twentynm_atx_pll_inst.output_regulator_supply = "vreg1v_setting3";
defparam twentynm_atx_pll_inst.overrange_voltage = "over_setting5";
defparam twentynm_atx_pll_inst.pfd_delay_compensation = "fb_compensated_delay";
defparam twentynm_atx_pll_inst.pfd_pulse_width = "pulse_width_setting0";
defparam twentynm_atx_pll_inst.pm_speed_grade = "e2";
defparam twentynm_atx_pll_inst.pma_width = 20;
defparam twentynm_atx_pll_inst.power_mode = "low_power";
defparam twentynm_atx_pll_inst.power_rail_et = 0;
defparam twentynm_atx_pll_inst.powerdown_mode = "powerup";
defparam twentynm_atx_pll_inst.primary_use = "hssi_x1";
defparam twentynm_atx_pll_inst.prot_mode = "basic_tx";
defparam twentynm_atx_pll_inst.ref_clk_div = 1;
defparam twentynm_atx_pll_inst.reference_clock_frequency = "120000000 hz";
defparam twentynm_atx_pll_inst.regulator_bypass = "reg_enable";
defparam twentynm_atx_pll_inst.side = "side_unknown";
defparam twentynm_atx_pll_inst.silicon_rev = "20nm5es2";
defparam twentynm_atx_pll_inst.sup_mode = "user_mode";
defparam twentynm_atx_pll_inst.tank_band = "lc_band4";
defparam twentynm_atx_pll_inst.tank_sel = "lctank1";
defparam twentynm_atx_pll_inst.tank_voltage_coarse = "vreg_setting_coarse0";
defparam twentynm_atx_pll_inst.tank_voltage_fine = "vreg_setting5";
defparam twentynm_atx_pll_inst.top_or_bottom = "tb_unknown";
defparam twentynm_atx_pll_inst.underrange_voltage = "under_setting4";
defparam twentynm_atx_pll_inst.vccdreg_clk = "vreg_clk0";
defparam twentynm_atx_pll_inst.vccdreg_fb = "vreg_fb0";
defparam twentynm_atx_pll_inst.vccdreg_fw = "vreg_fw0";
defparam twentynm_atx_pll_inst.vco_bypass_enable = "false";
defparam twentynm_atx_pll_inst.vco_freq = "9600000000 hz";
defparam twentynm_atx_pll_inst.xcpvco_xchgpmplf_cp_current_boost = "boost_setting";

twentynm_hssi_pma_cgb_master twentynm_hssi_pma_cgb_master_inst(
	.avmmclk(gnd),
	.avmmread(gnd),
	.avmmrstn(gnd),
	.avmmwrite(gnd),
	.cgb_rstb(vcc),
	.clk_fpll_b(gnd),
	.clk_fpll_t(gnd),
	.clk_lc_b(gnd),
	.clk_lc_t(pll_serial_clk_8g),
	.clkb_fpll_b(),
	.clkb_fpll_t(),
	.clkb_lc_b(),
	.clkb_lc_t(),
	.tx_bonding_rstb(vcc),
	.avmmaddress({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.avmmwritedata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.pcie_sw({gnd,gnd}),
	.blockselect(),
	.tx_iqtxrxclk_out(),
	.avmmreaddata(),
	.cpulse_out_bus(twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus),
	.mstcgb_core(twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus),
	.pcie_sw_done());
defparam twentynm_hssi_pma_cgb_master_inst.bonding_reset_enable = "allow_bonding_reset";
defparam twentynm_hssi_pma_cgb_master_inst.cgb_enable_iqtxrxclk = "disable_iqtxrxclk";
defparam twentynm_hssi_pma_cgb_master_inst.cgb_power_down = "normal_cgb";
defparam twentynm_hssi_pma_cgb_master_inst.datarate = "4800000000 bps";
defparam twentynm_hssi_pma_cgb_master_inst.dft_iqtxrxclk_control = "dft_iqtxrxclk_drv_low";
defparam twentynm_hssi_pma_cgb_master_inst.initial_settings = "true";
defparam twentynm_hssi_pma_cgb_master_inst.input_select = "lcpll_top";
defparam twentynm_hssi_pma_cgb_master_inst.input_select_gen3 = "unused";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control0 = "master_cgb_no_dft_control0";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control1 = "master_cgb_no_dft_control1";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control2 = "master_cgb_no_dft_control2";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control3 = "master_cgb_no_dft_control3";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control4 = "master_cgb_no_dft_control4";
defparam twentynm_hssi_pma_cgb_master_inst.master_cgb_clock_control5 = "master_cgb_no_dft_control5";
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_high_perf_datarate_limit = 36'b000000000000000000000000000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_high_perf_voltage = 12'b000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_low_power_datarate_limit = 36'b000000000000000000000000000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_low_power_voltage = 12'b000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_mid_power_datarate_limit = 36'b000000000000000000000000000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.mcgb_mid_power_voltage = 12'b000000000000;
defparam twentynm_hssi_pma_cgb_master_inst.observe_cgb_clocks = "observe_nothing";
defparam twentynm_hssi_pma_cgb_master_inst.optimal = "true";
defparam twentynm_hssi_pma_cgb_master_inst.pcie_gen3_bitwidth = "pciegen3_wide";
defparam twentynm_hssi_pma_cgb_master_inst.powerdown_mode = "powerup";
defparam twentynm_hssi_pma_cgb_master_inst.prot_mode = "basic_tx";
defparam twentynm_hssi_pma_cgb_master_inst.scratch0_x1_clock_src = "unused";
defparam twentynm_hssi_pma_cgb_master_inst.scratch1_x1_clock_src = "unused";
defparam twentynm_hssi_pma_cgb_master_inst.scratch2_x1_clock_src = "unused";
defparam twentynm_hssi_pma_cgb_master_inst.scratch3_x1_clock_src = "unused";
defparam twentynm_hssi_pma_cgb_master_inst.ser_mode = "twenty_bit";
defparam twentynm_hssi_pma_cgb_master_inst.silicon_rev = "20nm5es2";
defparam twentynm_hssi_pma_cgb_master_inst.sup_mode = "user_mode";
defparam twentynm_hssi_pma_cgb_master_inst.tx_ucontrol_en = "disable";
defparam twentynm_hssi_pma_cgb_master_inst.tx_ucontrol_pcie = "gen1";
defparam twentynm_hssi_pma_cgb_master_inst.tx_ucontrol_reset = "disable";
defparam twentynm_hssi_pma_cgb_master_inst.vccdreg_output = "vccdreg_nominal";
defparam twentynm_hssi_pma_cgb_master_inst.x1_clock_source_sel = "fpll_top";
defparam twentynm_hssi_pma_cgb_master_inst.x1_div_m_sel = "divbypass";

twentynm_hssi_pma_lc_refclk_select_mux twentynm_hssi_pma_lc_refclk_select_mux_inst(
	.avmmclk(pll_avmm_clk[0]),
	.avmmread(pll_avmm_read[0]),
	.avmmrstn(pll_avmm_rstn[0]),
	.avmmwrite(pll_avmm_write[0]),
	.core_refclk(gnd),
	.cr_pdb(vcc),
	.lvpecl_in(gnd),
	.avmmaddress({pll_avmm_address[8],pll_avmm_address[7],pll_avmm_address[6],pll_avmm_address[5],pll_avmm_address[4],pll_avmm_address[3],pll_avmm_address[2],pll_avmm_address[1],pll_avmm_address[0]}),
	.avmmwritedata({pll_avmm_writedata[7],pll_avmm_writedata[6],pll_avmm_writedata[5],pll_avmm_writedata[4],pll_avmm_writedata[3],pll_avmm_writedata[2],pll_avmm_writedata[1],pll_avmm_writedata[0]}),
	.iqtxrxclk({gnd,gnd,gnd,gnd,gnd,gnd}),
	.ref_iqclk({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,pll_refclk0}),
	.blockselect(pll_blockselect_refclk[0]),
	.refclk(refclk_mux_out),
	.avmmreaddata(twentynm_hssi_pma_lc_refclk_select_mux_inst_AVMMREADDATA_bus));
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.inclk0_logical_to_physical_mapping = "ref_iqclk0";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.inclk1_logical_to_physical_mapping = "power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.inclk2_logical_to_physical_mapping = "power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.inclk3_logical_to_physical_mapping = "power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.inclk4_logical_to_physical_mapping = "power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.powerdown_mode = "powerup";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.refclk_select = "ref_iqclk0";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.silicon_rev = "20nm5es2";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_lc_scratch0_src = "scratch0_src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_lc_scratch1_src = "scratch1_src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_lc_scratch2_src = "scratch2_src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_lc_scratch3_src = "scratch3_src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_lc_scratch4_src = "scratch4_src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xmux_refclk_src = "src_lvpecl";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_iqclk_sel = "power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_scratch0_src = "scratch0_power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_scratch1_src = "scratch1_power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_scratch2_src = "scratch2_power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_scratch3_src = "scratch3_power_down";
defparam twentynm_hssi_pma_lc_refclk_select_mux_inst.xpm_iqref_mux_scratch4_src = "scratch4_power_down";

endmodule

module mgt_atxpll_twentynm_xcvr_avmm (
	chnl_pll_avmm_clk,
	pld_cal_done,
	chnl_pll_avmm_read,
	chnl_pll_avmm_rstn,
	chnl_pll_avmm_write,
	chnl_pll_avmm_address,
	chnl_pll_avmm_writedata,
	pll_blockselect_lc_pll,
	pll_avmmreaddata_lc_pll,
	pll_blockselect_lc_refclk_select,
	pll_avmmreaddata_lc_refclk_select)/* synthesis synthesis_greybox=0 */;
output 	[0:0] chnl_pll_avmm_clk;
output 	[0:0] pld_cal_done;
output 	[0:0] chnl_pll_avmm_read;
output 	[0:0] chnl_pll_avmm_rstn;
output 	[0:0] chnl_pll_avmm_write;
output 	[8:0] chnl_pll_avmm_address;
output 	[7:0] chnl_pll_avmm_writedata;
input 	[0:0] pll_blockselect_lc_pll;
input 	[7:0] pll_avmmreaddata_lc_pll;
input 	[0:0] pll_blockselect_lc_refclk_select;
input 	[7:0] pll_avmmreaddata_lc_refclk_select;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \avmm_readdata[0] ;
wire \avmm_readdata[1] ;
wire \avmm_readdata[2] ;
wire \avmm_readdata[3] ;
wire \avmm_readdata[4] ;
wire \avmm_readdata[5] ;
wire \avmm_readdata[6] ;
wire \avmm_readdata[7] ;

wire [7:0] \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus ;
wire [8:0] \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus ;
wire [7:0] \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus ;

assign chnl_pll_avmm_writedata[0] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [0];
assign chnl_pll_avmm_writedata[1] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [1];
assign chnl_pll_avmm_writedata[2] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [2];
assign chnl_pll_avmm_writedata[3] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [3];
assign chnl_pll_avmm_writedata[4] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [4];
assign chnl_pll_avmm_writedata[5] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [5];
assign chnl_pll_avmm_writedata[6] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [6];
assign chnl_pll_avmm_writedata[7] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus [7];

assign chnl_pll_avmm_address[0] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [0];
assign chnl_pll_avmm_address[1] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [1];
assign chnl_pll_avmm_address[2] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [2];
assign chnl_pll_avmm_address[3] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [3];
assign chnl_pll_avmm_address[4] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [4];
assign chnl_pll_avmm_address[5] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [5];
assign chnl_pll_avmm_address[6] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [6];
assign chnl_pll_avmm_address[7] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [7];
assign chnl_pll_avmm_address[8] = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus [8];

assign \avmm_readdata[0]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [0];
assign \avmm_readdata[1]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [1];
assign \avmm_readdata[2]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [2];
assign \avmm_readdata[3]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [3];
assign \avmm_readdata[4]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [4];
assign \avmm_readdata[5]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [5];
assign \avmm_readdata[6]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [6];
assign \avmm_readdata[7]  = \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus [7];

twentynm_hssi_avmm_if \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst (
	.avmmclk(gnd),
	.avmmread(gnd),
	.avmmrequest(gnd),
	.avmmreservedin(),
	.avmmrstn(vcc),
	.avmmwrite(gnd),
	.scanmoden(vcc),
	.scanshiftn(vcc),
	.avmmaddress({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.avmmwritedata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.blockselect({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,pll_blockselect_lc_refclk_select[0],pll_blockselect_lc_pll[0],gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd}),
	.readdatachnl({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,pll_avmmreaddata_lc_refclk_select[7],pll_avmmreaddata_lc_refclk_select[6],
pll_avmmreaddata_lc_refclk_select[5],pll_avmmreaddata_lc_refclk_select[4],pll_avmmreaddata_lc_refclk_select[3],pll_avmmreaddata_lc_refclk_select[2],pll_avmmreaddata_lc_refclk_select[1],pll_avmmreaddata_lc_refclk_select[0],pll_avmmreaddata_lc_pll[7],pll_avmmreaddata_lc_pll[6],
pll_avmmreaddata_lc_pll[5],pll_avmmreaddata_lc_pll[4],pll_avmmreaddata_lc_pll[3],pll_avmmreaddata_lc_pll[2],pll_avmmreaddata_lc_pll[1],pll_avmmreaddata_lc_pll[0],gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.avmmbusy(),
	.avmmreservedout(),
	.clkchnl(chnl_pll_avmm_clk[0]),
	.hipcaldone(),
	.pldcaldone(pld_cal_done[0]),
	.readchnl(chnl_pll_avmm_read[0]),
	.rstnchnl(chnl_pll_avmm_rstn[0]),
	.writechnl(chnl_pll_avmm_write[0]),
	.avmmreaddata(\avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_AVMMREADDATA_bus ),
	.regaddrchnl(\avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_REGADDRCHNL_bus ),
	.writedatachnl(\avmm_atom_insts[0].twentynm_hssi_avmm_if_inst_WRITEDATACHNL_bus ));
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .arbiter_ctrl = "uc";
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .cal_done = "cal_done_deassert";
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .cal_reserved = 5'b00000;
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .calibration_en = "enable";
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .calibration_type = "one_time";
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .hip_cal_en = "disable";
defparam \avmm_atom_insts[0].twentynm_hssi_avmm_if_inst .silicon_rev = "20nm5es";

endmodule
