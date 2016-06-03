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

// DATE "03/18/2016 09:48:21"

// 
// Device: Altera 10AX115S4F45I3SGE2 Package FBGA1932
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module mgt_pll (
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

wire \xcvr_fpll_a10_0|xcvr_avmm_inst|pld_cal_done[0] ;
wire \xcvr_fpll_a10_0|tx_serial_clk ;
wire \xcvr_fpll_a10_0|pll_locked ;
wire \xcvr_fpll_a10_0|tx_bonding_clocks[0] ;
wire \xcvr_fpll_a10_0|tx_bonding_clocks[1] ;
wire \xcvr_fpll_a10_0|tx_bonding_clocks[2] ;
wire \xcvr_fpll_a10_0|tx_bonding_clocks[3] ;
wire \xcvr_fpll_a10_0|tx_bonding_clocks[4] ;
wire \xcvr_fpll_a10_0|mcgb_serial_clk ;
wire \mcgb_rst~input_o ;
wire \pll_powerdown~input_o ;
wire \pll_refclk0~input_o ;


mgt_pll_altera_xcvr_fpll_a10 xcvr_fpll_a10_0(
	.pld_cal_done_0(\xcvr_fpll_a10_0|xcvr_avmm_inst|pld_cal_done[0] ),
	.tx_serial_clk(\xcvr_fpll_a10_0|tx_serial_clk ),
	.pll_locked(\xcvr_fpll_a10_0|pll_locked ),
	.tx_bonding_clocks({tx_bonding_clocks_unconnected_wire_5,\xcvr_fpll_a10_0|tx_bonding_clocks[4] ,\xcvr_fpll_a10_0|tx_bonding_clocks[3] ,\xcvr_fpll_a10_0|tx_bonding_clocks[2] ,\xcvr_fpll_a10_0|tx_bonding_clocks[1] ,\xcvr_fpll_a10_0|tx_bonding_clocks[0] }),
	.mcgb_serial_clk(\xcvr_fpll_a10_0|mcgb_serial_clk ),
	.pll_refclk0(\pll_refclk0~input_o ));

assign \pll_refclk0~input_o  = pll_refclk0;

assign pll_cal_busy = ~ \xcvr_fpll_a10_0|xcvr_avmm_inst|pld_cal_done[0] ;

assign pll_locked = \xcvr_fpll_a10_0|pll_locked ;

assign tx_bonding_clocks[0] = \xcvr_fpll_a10_0|tx_bonding_clocks[0] ;

assign tx_bonding_clocks[1] = \xcvr_fpll_a10_0|tx_bonding_clocks[1] ;

assign tx_bonding_clocks[2] = \xcvr_fpll_a10_0|tx_bonding_clocks[2] ;

assign tx_bonding_clocks[3] = \xcvr_fpll_a10_0|tx_bonding_clocks[3] ;

assign tx_bonding_clocks[4] = \xcvr_fpll_a10_0|tx_bonding_clocks[4] ;

assign tx_bonding_clocks[5] = \xcvr_fpll_a10_0|mcgb_serial_clk ;

assign tx_serial_clk = \xcvr_fpll_a10_0|tx_serial_clk ;

assign \mcgb_rst~input_o  = mcgb_rst;

assign \pll_powerdown~input_o  = pll_powerdown;

endmodule

module mgt_pll_altera_xcvr_fpll_a10 (
	pld_cal_done_0,
	tx_serial_clk,
	pll_locked,
	tx_bonding_clocks,
	mcgb_serial_clk,
	pll_refclk0)/* synthesis synthesis_greybox=0 */;
output 	pld_cal_done_0;
output 	tx_serial_clk;
output 	pll_locked;
output 	[5:0] tx_bonding_clocks;
output 	mcgb_serial_clk;
input 	pll_refclk0;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \xcvr_avmm_inst|chnl_pll_avmm_clk[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_read[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_rstn[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_write[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[1] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[2] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[3] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[4] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[5] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[6] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[7] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_address[8] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[0] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ;
wire \xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ;
wire \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE0 ;
wire \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE1 ;
wire \pll_blockselect_cmu_fpll_refclk_select[0] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[0] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[1] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[2] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[3] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[4] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[5] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[6] ;
wire \pll_avmmreaddata_cmu_fpll_refclk_select[7] ;
wire \pll_blockselect_cmu_fpll[0] ;
wire \pll_avmmreaddata_cmu_fpll[0] ;
wire \pll_avmmreaddata_cmu_fpll[1] ;
wire \pll_avmmreaddata_cmu_fpll[2] ;
wire \pll_avmmreaddata_cmu_fpll[3] ;
wire \pll_avmmreaddata_cmu_fpll[4] ;
wire \pll_avmmreaddata_cmu_fpll[5] ;
wire \pll_avmmreaddata_cmu_fpll[6] ;
wire \pll_avmmreaddata_cmu_fpll[7] ;
wire iqtxrxclk;
wire clk0_bad_wire;
wire clk1_bad_wire;
wire refclk_sel_outclk_wire;

wire [7:0] fpll_inst_AVMMREADDATA_bus;
wire [5:0] twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus;
wire [1:0] twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus;
wire [7:0] fpll_refclk_select_inst_AVMMREADDATA_bus;

assign \pll_avmmreaddata_cmu_fpll[0]  = fpll_inst_AVMMREADDATA_bus[0];
assign \pll_avmmreaddata_cmu_fpll[1]  = fpll_inst_AVMMREADDATA_bus[1];
assign \pll_avmmreaddata_cmu_fpll[2]  = fpll_inst_AVMMREADDATA_bus[2];
assign \pll_avmmreaddata_cmu_fpll[3]  = fpll_inst_AVMMREADDATA_bus[3];
assign \pll_avmmreaddata_cmu_fpll[4]  = fpll_inst_AVMMREADDATA_bus[4];
assign \pll_avmmreaddata_cmu_fpll[5]  = fpll_inst_AVMMREADDATA_bus[5];
assign \pll_avmmreaddata_cmu_fpll[6]  = fpll_inst_AVMMREADDATA_bus[6];
assign \pll_avmmreaddata_cmu_fpll[7]  = fpll_inst_AVMMREADDATA_bus[7];

assign tx_bonding_clocks[0] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[0];
assign tx_bonding_clocks[1] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[1];
assign tx_bonding_clocks[2] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[2];
assign tx_bonding_clocks[3] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[3];
assign tx_bonding_clocks[4] = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[4];
assign mcgb_serial_clk = twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus[5];

assign \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE0  = twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus[0];
assign \twentynm_hssi_pma_cgb_master_inst~O_MSTCGB_CORE1  = twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus[1];

assign \pll_avmmreaddata_cmu_fpll_refclk_select[0]  = fpll_refclk_select_inst_AVMMREADDATA_bus[0];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[1]  = fpll_refclk_select_inst_AVMMREADDATA_bus[1];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[2]  = fpll_refclk_select_inst_AVMMREADDATA_bus[2];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[3]  = fpll_refclk_select_inst_AVMMREADDATA_bus[3];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[4]  = fpll_refclk_select_inst_AVMMREADDATA_bus[4];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[5]  = fpll_refclk_select_inst_AVMMREADDATA_bus[5];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[6]  = fpll_refclk_select_inst_AVMMREADDATA_bus[6];
assign \pll_avmmreaddata_cmu_fpll_refclk_select[7]  = fpll_refclk_select_inst_AVMMREADDATA_bus[7];

mgt_pll_twentynm_xcvr_avmm xcvr_avmm_inst(
	.chnl_pll_avmm_clk({\xcvr_avmm_inst|chnl_pll_avmm_clk[0] }),
	.pld_cal_done({pld_cal_done_0}),
	.chnl_pll_avmm_read({\xcvr_avmm_inst|chnl_pll_avmm_read[0] }),
	.chnl_pll_avmm_rstn({\xcvr_avmm_inst|chnl_pll_avmm_rstn[0] }),
	.chnl_pll_avmm_write({\xcvr_avmm_inst|chnl_pll_avmm_write[0] }),
	.chnl_pll_avmm_address({\xcvr_avmm_inst|chnl_pll_avmm_address[8] ,\xcvr_avmm_inst|chnl_pll_avmm_address[7] ,\xcvr_avmm_inst|chnl_pll_avmm_address[6] ,\xcvr_avmm_inst|chnl_pll_avmm_address[5] ,\xcvr_avmm_inst|chnl_pll_avmm_address[4] ,\xcvr_avmm_inst|chnl_pll_avmm_address[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_address[2] ,\xcvr_avmm_inst|chnl_pll_avmm_address[1] ,\xcvr_avmm_inst|chnl_pll_avmm_address[0] }),
	.chnl_pll_avmm_writedata({\xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[0] }),
	.pll_blockselect_cmu_fpll({\pll_blockselect_cmu_fpll[0] }),
	.pll_avmmreaddata_cmu_fpll({\pll_avmmreaddata_cmu_fpll[7] ,\pll_avmmreaddata_cmu_fpll[6] ,\pll_avmmreaddata_cmu_fpll[5] ,\pll_avmmreaddata_cmu_fpll[4] ,\pll_avmmreaddata_cmu_fpll[3] ,\pll_avmmreaddata_cmu_fpll[2] ,\pll_avmmreaddata_cmu_fpll[1] ,\pll_avmmreaddata_cmu_fpll[0] }),
	.pll_blockselect_cmu_fpll_refclk_select({\pll_blockselect_cmu_fpll_refclk_select[0] }),
	.pll_avmmreaddata_cmu_fpll_refclk_select({\pll_avmmreaddata_cmu_fpll_refclk_select[7] ,\pll_avmmreaddata_cmu_fpll_refclk_select[6] ,\pll_avmmreaddata_cmu_fpll_refclk_select[5] ,\pll_avmmreaddata_cmu_fpll_refclk_select[4] ,\pll_avmmreaddata_cmu_fpll_refclk_select[3] ,
\pll_avmmreaddata_cmu_fpll_refclk_select[2] ,\pll_avmmreaddata_cmu_fpll_refclk_select[1] ,\pll_avmmreaddata_cmu_fpll_refclk_select[0] }));

twentynm_cmu_fpll_refclk_select fpll_refclk_select_inst(
	.avmmclk(\xcvr_avmm_inst|chnl_pll_avmm_clk[0] ),
	.avmmread(\xcvr_avmm_inst|chnl_pll_avmm_read[0] ),
	.avmmrstn(\xcvr_avmm_inst|chnl_pll_avmm_rstn[0] ),
	.avmmwrite(\xcvr_avmm_inst|chnl_pll_avmm_write[0] ),
	.core_refclk(),
	.extswitch(gnd),
	.fpll_cr_pllen(),
	.pll_cascade_in(),
	.refclk(pll_refclk0),
	.tx_rx_core_refclk(),
	.avmmaddress({\xcvr_avmm_inst|chnl_pll_avmm_address[8] ,\xcvr_avmm_inst|chnl_pll_avmm_address[7] ,\xcvr_avmm_inst|chnl_pll_avmm_address[6] ,\xcvr_avmm_inst|chnl_pll_avmm_address[5] ,\xcvr_avmm_inst|chnl_pll_avmm_address[4] ,\xcvr_avmm_inst|chnl_pll_avmm_address[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_address[2] ,\xcvr_avmm_inst|chnl_pll_avmm_address[1] ,\xcvr_avmm_inst|chnl_pll_avmm_address[0] }),
	.avmmwritedata({\xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[0] }),
	.iqtxrxclk(),
	.ref_iqclk({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.blockselect(\pll_blockselect_cmu_fpll_refclk_select[0] ),
	.clk0bad(clk0_bad_wire),
	.clk1bad(clk1_bad_wire),
	.extswitch_buf(),
	.outclk(refclk_sel_outclk_wire),
	.pllclksel(),
	.avmmreaddata(fpll_refclk_select_inst_AVMMREADDATA_bus),
	.clk_src());
defparam fpll_refclk_select_inst.mux0_inclk0_logical_to_physical_mapping = "lvpecl";
defparam fpll_refclk_select_inst.mux0_inclk1_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux0_inclk2_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux0_inclk3_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux0_inclk4_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux1_inclk0_logical_to_physical_mapping = "lvpecl";
defparam fpll_refclk_select_inst.mux1_inclk1_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux1_inclk2_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux1_inclk3_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.mux1_inclk4_logical_to_physical_mapping = "power_down";
defparam fpll_refclk_select_inst.pll_auto_clk_sw_en = "false";
defparam fpll_refclk_select_inst.pll_clk_loss_edge = "pll_clk_loss_both_edges";
defparam fpll_refclk_select_inst.pll_clk_loss_sw_en = "false";
defparam fpll_refclk_select_inst.pll_clk_sel_override = "normal";
defparam fpll_refclk_select_inst.pll_clk_sel_override_value = "select_clk0";
defparam fpll_refclk_select_inst.pll_clk_sw_dly = 0;
defparam fpll_refclk_select_inst.pll_clkin_0_scratch0_src = "pll_clkin_0_scratch0_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_0_scratch1_src = "pll_clkin_0_scratch1_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_0_scratch2_src = "pll_clkin_0_scratch2_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_0_scratch3_src = "pll_clkin_0_scratch3_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_0_scratch4_src = "pll_clkin_0_scratch4_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_0_src = "pll_clkin_0_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_scratch0_src = "pll_clkin_1_scratch0_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_scratch1_src = "pll_clkin_1_scratch1_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_scratch2_src = "pll_clkin_1_scratch2_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_scratch3_src = "pll_clkin_1_scratch3_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_scratch4_src = "pll_clkin_1_scratch4_src_vss";
defparam fpll_refclk_select_inst.pll_clkin_1_src = "pll_clkin_1_src_vss";
defparam fpll_refclk_select_inst.pll_manu_clk_sw_en = "false";
defparam fpll_refclk_select_inst.pll_powerdown_mode = "false";
defparam fpll_refclk_select_inst.pll_sup_mode = "user_mode";
defparam fpll_refclk_select_inst.pll_sw_refclk_src = "pll_sw_refclk_src_clk_0";
defparam fpll_refclk_select_inst.refclk_select0 = "lvpecl";
defparam fpll_refclk_select_inst.refclk_select1 = "ref_iqclk0";
defparam fpll_refclk_select_inst.silicon_rev = "20nm5es2";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_iqclk_sel = "power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_scratch0_src = "scratch0_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_scratch1_src = "scratch1_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_scratch2_src = "scratch2_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_scratch3_src = "scratch3_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux0_scratch4_src = "scratch4_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_iqclk_sel = "power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_scratch0_src = "scratch0_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_scratch1_src = "scratch1_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_scratch2_src = "scratch2_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_scratch3_src = "scratch3_power_down";
defparam fpll_refclk_select_inst.xpm_iqref_mux1_scratch4_src = "scratch4_power_down";

twentynm_cmu_fpll fpll_inst(
	.avmmclk(\xcvr_avmm_inst|chnl_pll_avmm_clk[0] ),
	.avmmread(\xcvr_avmm_inst|chnl_pll_avmm_read[0] ),
	.avmmrstn(\xcvr_avmm_inst|chnl_pll_avmm_rstn[0] ),
	.avmmwrite(\xcvr_avmm_inst|chnl_pll_avmm_write[0] ),
	.clk0bad_in(clk0_bad_wire),
	.clk1bad_in(clk1_bad_wire),
	.core_refclk(),
	.csr_bufin(),
	.csr_clk(),
	.csr_en(),
	.csr_en_dly(),
	.csr_in(),
	.dps_rst_n(vcc),
	.extswitch_buf(),
	.fbclk_in(gnd),
	.lc_to_fpll_refclk(gnd),
	.mdio_dis(),
	.nfrzdrv(),
	.nrpi_freeze(),
	.pfden(),
	.phase_en(gnd),
	.pllclksel(),
	.pma_atpg_los_en_n(),
	.pma_csr_test_dis(),
	.refclk(refclk_sel_outclk_wire),
	.rst_n(vcc),
	.scan_mode_n(),
	.scan_shift_n(),
	.up_dn(gnd),
	.avmmaddress({\xcvr_avmm_inst|chnl_pll_avmm_address[8] ,\xcvr_avmm_inst|chnl_pll_avmm_address[7] ,\xcvr_avmm_inst|chnl_pll_avmm_address[6] ,\xcvr_avmm_inst|chnl_pll_avmm_address[5] ,\xcvr_avmm_inst|chnl_pll_avmm_address[4] ,\xcvr_avmm_inst|chnl_pll_avmm_address[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_address[2] ,\xcvr_avmm_inst|chnl_pll_avmm_address[1] ,\xcvr_avmm_inst|chnl_pll_avmm_address[0] }),
	.avmmwritedata({\xcvr_avmm_inst|chnl_pll_avmm_writedata[7] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[6] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[5] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[4] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[3] ,
\xcvr_avmm_inst|chnl_pll_avmm_writedata[2] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[1] ,\xcvr_avmm_inst|chnl_pll_avmm_writedata[0] }),
	.cnt_sel({gnd,gnd,gnd,gnd}),
	.fpll_ppm_clk(),
	.iqtxrxclk({gnd,gnd,gnd,gnd,gnd,iqtxrxclk}),
	.num_phase_shifts({gnd,gnd,vcc}),
	.block_select(\pll_blockselect_cmu_fpll[0] ),
	.clk0(tx_serial_clk),
	.clk0bad(),
	.clk180(),
	.clk1bad(),
	.clk_sel_override(),
	.clk_sel_override_value(),
	.clklow(),
	.csr_bufout(),
	.csr_out(),
	.fbclk_out(),
	.fref(),
	.hclk_out(),
	.iqtxrxclk_out(),
	.lock(pll_locked),
	.phase_done(),
	.pll_cascade_out(),
	.avmmreaddata(fpll_inst_AVMMREADDATA_bus),
	.outclk(),
	.ppm_clk());
defparam fpll_inst.analog_mode = "user_custom";
defparam fpll_inst.bandwidth_range_high = 36'b000000000000000000000000000000000001;
defparam fpll_inst.bandwidth_range_low = 36'b000000000000000000000000000000000001;
defparam fpll_inst.bonding = "pll_bonding";
defparam fpll_inst.bw_sel = "high";
defparam fpll_inst.cgb_div = 1;
defparam fpll_inst.compensation_mode = "fpll_bonding";
defparam fpll_inst.datarate = "4800000000 bps";
defparam fpll_inst.duty_cycle_0 = 50;
defparam fpll_inst.duty_cycle_1 = 50;
defparam fpll_inst.duty_cycle_2 = 50;
defparam fpll_inst.duty_cycle_3 = 50;
defparam fpll_inst.f_max_band_0 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_1 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_2 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_3 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_4 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_5 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_6 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_7 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_8 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_band_9 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_div_two_bypass = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_pfd = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_pfd_bonded = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_pfd_fractional = 36'b000000000000000000000000000001011111;
defparam fpll_inst.f_max_pfd_integer = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_vco = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_max_vco_fractional = 36'b000000000000000000000000000000000101;
defparam fpll_inst.f_min_band_0 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_1 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_2 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_3 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_4 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_5 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_6 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_7 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_8 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_band_9 = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_pfd = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_min_vco = 36'b000000000000000000000000000000000001;
defparam fpll_inst.f_out_c0 = 36'b000000000000000000000000000000000000;
defparam fpll_inst.f_out_c0_hz = "0 hz";
defparam fpll_inst.f_out_c1 = 36'b000000000000000000000000000000000000;
defparam fpll_inst.f_out_c1_hz = "0 hz";
defparam fpll_inst.f_out_c2 = 36'b000000000000000000000000000000000000;
defparam fpll_inst.f_out_c2_hz = "0 hz";
defparam fpll_inst.f_out_c3 = 36'b000000000000000000000000000000000000;
defparam fpll_inst.f_out_c3_hz = "0 hz";
defparam fpll_inst.feedback = "iqtxrxclk";
defparam fpll_inst.fpll_cal_test_sel = "sel_cal_out_7_to_0";
defparam fpll_inst.fpll_cas_out_enable = "fpll_cas_out_disable";
defparam fpll_inst.fpll_hclk_out_enable = "fpll_hclk_out_disable";
defparam fpll_inst.fpll_iqtxrxclk_out_enable = "fpll_iqtxrxclk_out_disable";
defparam fpll_inst.hssi_output_clock_frequency = "2400.0 mhz";
defparam fpll_inst.initial_settings = "true";
defparam fpll_inst.input_tolerance = 8'b00000000;
defparam fpll_inst.is_cascaded_pll = "false";
defparam fpll_inst.is_pa_core = "false";
defparam fpll_inst.l_counter = 5'b00010;
defparam fpll_inst.m_counter = 8'b00010100;
defparam fpll_inst.m_counter_c0 = 9'b000000001;
defparam fpll_inst.m_counter_c1 = 9'b000000001;
defparam fpll_inst.m_counter_c2 = 9'b000000001;
defparam fpll_inst.m_counter_c3 = 9'b000000001;
defparam fpll_inst.max_fractional_percentage = 7'b0000000;
defparam fpll_inst.min_fractional_percentage = 7'b0000000;
defparam fpll_inst.n_counter = 6'b000001;
defparam fpll_inst.out_freq = 36'b000010001111000011010001100000000000;
defparam fpll_inst.out_freq_hz = "0 hz";
defparam fpll_inst.output_clock_frequency_0 = "0 ps";
defparam fpll_inst.output_clock_frequency_1 = "0 ps";
defparam fpll_inst.output_clock_frequency_2 = "0 ps";
defparam fpll_inst.output_clock_frequency_3 = "0 ps";
defparam fpll_inst.output_tolerance = 8'b00000000;
defparam fpll_inst.pfd_freq = 36'b000000001110010011100001110000000000;
defparam fpll_inst.phase_shift_0 = "0 ps";
defparam fpll_inst.phase_shift_1 = "0 ps";
defparam fpll_inst.phase_shift_2 = "0 ps";
defparam fpll_inst.phase_shift_3 = "0 ps";
defparam fpll_inst.pll_atb = "atb_selectdisable";
defparam fpll_inst.pll_bw_mode = "hi_bw";
defparam fpll_inst.pll_c0_pllcout_enable = "false";
defparam fpll_inst.pll_c1_pllcout_enable = "false";
defparam fpll_inst.pll_c2_pllcout_enable = "false";
defparam fpll_inst.pll_c3_pllcout_enable = "false";
defparam fpll_inst.pll_c_counter_0 = 1;
defparam fpll_inst.pll_c_counter_0_coarse_dly = "0 ps";
defparam fpll_inst.pll_c_counter_0_fine_dly = "0 ps";
defparam fpll_inst.pll_c_counter_0_in_src = "m_cnt_in_src_test_clk";
defparam fpll_inst.pll_c_counter_0_min_tco_enable = "false";
defparam fpll_inst.pll_c_counter_0_ph_mux_prst = 0;
defparam fpll_inst.pll_c_counter_0_prst = 1;
defparam fpll_inst.pll_c_counter_1 = 1;
defparam fpll_inst.pll_c_counter_1_coarse_dly = "0 ps";
defparam fpll_inst.pll_c_counter_1_fine_dly = "0 ps";
defparam fpll_inst.pll_c_counter_1_in_src = "m_cnt_in_src_test_clk";
defparam fpll_inst.pll_c_counter_1_min_tco_enable = "false";
defparam fpll_inst.pll_c_counter_1_ph_mux_prst = 0;
defparam fpll_inst.pll_c_counter_1_prst = 1;
defparam fpll_inst.pll_c_counter_2 = 1;
defparam fpll_inst.pll_c_counter_2_coarse_dly = "0 ps";
defparam fpll_inst.pll_c_counter_2_fine_dly = "0 ps";
defparam fpll_inst.pll_c_counter_2_in_src = "m_cnt_in_src_test_clk";
defparam fpll_inst.pll_c_counter_2_min_tco_enable = "false";
defparam fpll_inst.pll_c_counter_2_ph_mux_prst = 0;
defparam fpll_inst.pll_c_counter_2_prst = 1;
defparam fpll_inst.pll_c_counter_3 = 1;
defparam fpll_inst.pll_c_counter_3_coarse_dly = "0 ps";
defparam fpll_inst.pll_c_counter_3_fine_dly = "0 ps";
defparam fpll_inst.pll_c_counter_3_in_src = "m_cnt_in_src_test_clk";
defparam fpll_inst.pll_c_counter_3_min_tco_enable = "false";
defparam fpll_inst.pll_c_counter_3_ph_mux_prst = 0;
defparam fpll_inst.pll_c_counter_3_prst = 1;
defparam fpll_inst.pll_cal_status = "false";
defparam fpll_inst.pll_calibration = "true";
defparam fpll_inst.pll_cmp_buf_dly = "0 ps";
defparam fpll_inst.pll_cmu_rstn_value = "true";
defparam fpll_inst.pll_core_cali_ref_off = "true";
defparam fpll_inst.pll_core_cali_vco_off = "true";
defparam fpll_inst.pll_core_vccdreg_fb = "vreg_fb0";
defparam fpll_inst.pll_core_vccdreg_fw = "vreg_fw0";
defparam fpll_inst.pll_core_vreg0_atbsel = "atb_disabled";
defparam fpll_inst.pll_core_vreg1_atbsel = "atb_disabled1";
defparam fpll_inst.pll_cp_compensation = "false";
defparam fpll_inst.pll_cp_current_setting = "cp_current_setting19";
defparam fpll_inst.pll_cp_lf_3rd_pole_freq = "lf_3rd_pole_setting0";
defparam fpll_inst.pll_cp_lf_order = "lf_2nd_order";
defparam fpll_inst.pll_cp_testmode = "cp_normal";
defparam fpll_inst.pll_ctrl_override_setting = "true";
defparam fpll_inst.pll_ctrl_plniotri_override = "false";
defparam fpll_inst.pll_device_variant = "device1";
defparam fpll_inst.pll_dprio_base_addr = 256;
defparam fpll_inst.pll_dprio_broadcast_en = "false";
defparam fpll_inst.pll_dprio_clk_vreg_boost = "clk_fpll_vreg_no_voltage_boost";
defparam fpll_inst.pll_dprio_cvp_inter_sel = "false";
defparam fpll_inst.pll_dprio_force_inter_sel = "false";
defparam fpll_inst.pll_dprio_fpll_vreg1_boost = "fpll_vreg1_no_voltage_boost";
defparam fpll_inst.pll_dprio_fpll_vreg_boost = "fpll_vreg_no_voltage_boost";
defparam fpll_inst.pll_dprio_power_iso_en = "false";
defparam fpll_inst.pll_dprio_status_select = "dprio_normal_status";
defparam fpll_inst.pll_dsm_ecn_bypass = "false";
defparam fpll_inst.pll_dsm_ecn_test_en = "false";
defparam fpll_inst.pll_dsm_fractional_division = 32'b00000000000000000000000000000001;
defparam fpll_inst.pll_dsm_fractional_value_ready = "pll_k_ready";
defparam fpll_inst.pll_dsm_mode = "dsm_mode_integer";
defparam fpll_inst.pll_dsm_out_sel = "pll_dsm_disable";
defparam fpll_inst.pll_enable = "true";
defparam fpll_inst.pll_extra_csr = 0;
defparam fpll_inst.pll_fbclk_mux_1 = "pll_fbclk_mux_1_fbclk_pll";
defparam fpll_inst.pll_fbclk_mux_2 = "pll_fbclk_mux_2_fb_1";
defparam fpll_inst.pll_iqclk_mux_sel = "iqtxrxclk0";
defparam fpll_inst.pll_l_counter = 2;
defparam fpll_inst.pll_l_counter_bypass = "false";
defparam fpll_inst.pll_l_counter_enable = "true";
defparam fpll_inst.pll_lf_cbig = "lf_cbig_setting4";
defparam fpll_inst.pll_lf_resistance = "lf_res_setting0";
defparam fpll_inst.pll_lf_ripplecap = "lf_no_ripple";
defparam fpll_inst.pll_lock_fltr_cfg = 25;
defparam fpll_inst.pll_lock_fltr_test = "pll_lock_fltr_nrm";
defparam fpll_inst.pll_lpf_rstn_value = "lpf_normal";
defparam fpll_inst.pll_m_counter = 20;
defparam fpll_inst.pll_m_counter_coarse_dly = "0 ps";
defparam fpll_inst.pll_m_counter_fine_dly = "0 ps";
defparam fpll_inst.pll_m_counter_in_src = "m_cnt_in_src_ph_mux_clk";
defparam fpll_inst.pll_m_counter_min_tco_enable = "true";
defparam fpll_inst.pll_m_counter_ph_mux_prst = 0;
defparam fpll_inst.pll_m_counter_prst = 1;
defparam fpll_inst.pll_n_counter = 1;
defparam fpll_inst.pll_n_counter_coarse_dly = "0 ps";
defparam fpll_inst.pll_n_counter_fine_dly = "0 ps";
defparam fpll_inst.pll_nreset_invert = "false";
defparam fpll_inst.pll_op_mode = "false";
defparam fpll_inst.pll_optimal = "true";
defparam fpll_inst.pll_powerdown_mode = "false";
defparam fpll_inst.pll_ppm_clk0_src = "ppm_clk0_vss";
defparam fpll_inst.pll_ppm_clk1_src = "ppm_clk1_vss";
defparam fpll_inst.pll_ref_buf_dly = "0 ps";
defparam fpll_inst.pll_rstn_override = "false";
defparam fpll_inst.pll_self_reset = "false";
defparam fpll_inst.pll_sup_mode = "user_mode";
defparam fpll_inst.pll_tclk_mux_en = "false";
defparam fpll_inst.pll_tclk_sel = "pll_tclk_m_src";
defparam fpll_inst.pll_test_enable = "false";
defparam fpll_inst.pll_unlock_fltr_cfg = 2;
defparam fpll_inst.pll_vccr_pd_en = "true";
defparam fpll_inst.pll_vco_freq_band_0 = "pll_freq_band3";
defparam fpll_inst.pll_vco_freq_band_0_dyn_high_bits = 2'b00;
defparam fpll_inst.pll_vco_freq_band_0_dyn_low_bits = 3'b000;
defparam fpll_inst.pll_vco_freq_band_0_fix = 5'b00001;
defparam fpll_inst.pll_vco_freq_band_0_fix_high = "pll_vco_freq_band_0_fix_high_0";
defparam fpll_inst.pll_vco_freq_band_1 = "pll_freq_band3_1";
defparam fpll_inst.pll_vco_freq_band_1_dyn_high_bits = 2'b00;
defparam fpll_inst.pll_vco_freq_band_1_dyn_low_bits = 5'b00000;
defparam fpll_inst.pll_vco_freq_band_1_fix = 5'b00001;
defparam fpll_inst.pll_vco_freq_band_1_fix_high = "pll_vco_freq_band_1_fix_high_0";
defparam fpll_inst.pll_vco_ph0_en = "true";
defparam fpll_inst.pll_vco_ph0_value = "pll_vco_ph0_vss";
defparam fpll_inst.pll_vco_ph1_en = "false";
defparam fpll_inst.pll_vco_ph1_value = "pll_vco_ph1_vss";
defparam fpll_inst.pll_vco_ph2_en = "false";
defparam fpll_inst.pll_vco_ph2_value = "pll_vco_ph2_vss";
defparam fpll_inst.pll_vco_ph3_en = "false";
defparam fpll_inst.pll_vco_ph3_value = "pll_vco_ph3_vss";
defparam fpll_inst.pm_speed_grade = "e2";
defparam fpll_inst.pma_width = 20;
defparam fpll_inst.power_mode = "low_power";
defparam fpll_inst.power_rail_et = 0;
defparam fpll_inst.primary_use = "tx";
defparam fpll_inst.prot_mode = "basic_tx";
defparam fpll_inst.reference_clock_frequency = "240.0 mhz";
defparam fpll_inst.reference_clock_frequency_scratch = "240.0 mhz";
defparam fpll_inst.set_fpll_input_freq_range = 8'b00000000;
defparam fpll_inst.side = "side_unknown";
defparam fpll_inst.silicon_rev = "20nm5es2";
defparam fpll_inst.top_or_bottom = "tb_unknown";
defparam fpll_inst.vco_freq = 36'b000100011110000110100011000000000000;
defparam fpll_inst.vco_freq_hz = "4800000000";
defparam fpll_inst.vco_frequency = "4800.0 mhz";
defparam fpll_inst.xpm_cmu_fpll_core_cal_vco_count_length = "sel_8b_count";
defparam fpll_inst.xpm_cmu_fpll_core_fpll_refclk_source = "normal_refclk";
defparam fpll_inst.xpm_cmu_fpll_core_fpll_vco_div_by_2_sel = "bypass_divide_by_2";
defparam fpll_inst.xpm_cmu_fpll_core_pfd_delay_compensation = "normal_delay";
defparam fpll_inst.xpm_cmu_fpll_core_pfd_pulse_width = "pulse_width_setting0";
defparam fpll_inst.xpm_cmu_fpll_core_xpm_cpvco_fpll_xpm_chgpmplf_fpll_cp_current_boost = "boost_setting";

twentynm_hssi_pma_cgb_master twentynm_hssi_pma_cgb_master_inst(
	.avmmclk(gnd),
	.avmmread(gnd),
	.avmmrstn(gnd),
	.avmmwrite(gnd),
	.cgb_rstb(vcc),
	.clk_fpll_b(gnd),
	.clk_fpll_t(gnd),
	.clk_lc_b(gnd),
	.clk_lc_t(tx_serial_clk),
	.clkb_fpll_b(),
	.clkb_fpll_t(),
	.clkb_lc_b(),
	.clkb_lc_t(),
	.tx_bonding_rstb(vcc),
	.avmmaddress({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.avmmwritedata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.pcie_sw({gnd,gnd}),
	.blockselect(),
	.tx_iqtxrxclk_out(iqtxrxclk),
	.avmmreaddata(),
	.cpulse_out_bus(twentynm_hssi_pma_cgb_master_inst_CPULSE_OUT_BUS_bus),
	.mstcgb_core(twentynm_hssi_pma_cgb_master_inst_MSTCGB_CORE_bus),
	.pcie_sw_done());
defparam twentynm_hssi_pma_cgb_master_inst.bonding_reset_enable = "allow_bonding_reset";
defparam twentynm_hssi_pma_cgb_master_inst.cgb_enable_iqtxrxclk = "enable_iqtxrxclk";
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

endmodule

module mgt_pll_twentynm_xcvr_avmm (
	chnl_pll_avmm_clk,
	pld_cal_done,
	chnl_pll_avmm_read,
	chnl_pll_avmm_rstn,
	chnl_pll_avmm_write,
	chnl_pll_avmm_address,
	chnl_pll_avmm_writedata,
	pll_blockselect_cmu_fpll,
	pll_avmmreaddata_cmu_fpll,
	pll_blockselect_cmu_fpll_refclk_select,
	pll_avmmreaddata_cmu_fpll_refclk_select)/* synthesis synthesis_greybox=0 */;
output 	[0:0] chnl_pll_avmm_clk;
output 	[0:0] pld_cal_done;
output 	[0:0] chnl_pll_avmm_read;
output 	[0:0] chnl_pll_avmm_rstn;
output 	[0:0] chnl_pll_avmm_write;
output 	[8:0] chnl_pll_avmm_address;
output 	[7:0] chnl_pll_avmm_writedata;
input 	[0:0] pll_blockselect_cmu_fpll;
input 	[7:0] pll_avmmreaddata_cmu_fpll;
input 	[0:0] pll_blockselect_cmu_fpll_refclk_select;
input 	[7:0] pll_avmmreaddata_cmu_fpll_refclk_select;

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
	.blockselect({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,pll_blockselect_cmu_fpll_refclk_select[0],pll_blockselect_cmu_fpll[0],gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd}),
	.readdatachnl({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,pll_avmmreaddata_cmu_fpll_refclk_select[7],pll_avmmreaddata_cmu_fpll_refclk_select[6],pll_avmmreaddata_cmu_fpll_refclk_select[5],
pll_avmmreaddata_cmu_fpll_refclk_select[4],pll_avmmreaddata_cmu_fpll_refclk_select[3],pll_avmmreaddata_cmu_fpll_refclk_select[2],pll_avmmreaddata_cmu_fpll_refclk_select[1],pll_avmmreaddata_cmu_fpll_refclk_select[0],pll_avmmreaddata_cmu_fpll[7],pll_avmmreaddata_cmu_fpll[6],
pll_avmmreaddata_cmu_fpll[5],pll_avmmreaddata_cmu_fpll[4],pll_avmmreaddata_cmu_fpll[3],pll_avmmreaddata_cmu_fpll[2],pll_avmmreaddata_cmu_fpll[1],pll_avmmreaddata_cmu_fpll[0],gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
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
