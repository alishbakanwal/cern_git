--------------------------------------------------------------------------------
-- Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.58f
--  \   \         Application: netgen
--  /   /         Filename: v6_emac_v2_3_sgmii.vhd
-- /___/   /\     Timestamp: Mon May 20 14:15:44 2013
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl ./tmp/_cg/v6_emac_v2_3_sgmii.ngc ./tmp/_cg/v6_emac_v2_3_sgmii.vhd 
-- Device	: 6vlx130tff1156-1
-- Input file	: ./tmp/_cg/v6_emac_v2_3_sgmii.ngc
-- Output file	: ./tmp/_cg/v6_emac_v2_3_sgmii.vhd
-- # of Entities	: 1
-- Design Name	: v6_emac_v2_3_sgmii
-- Xilinx	: C:\CAD\Xilinx\14.5\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


-- synthesis translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity v6_emac_v2_3_sgmii is
  port (
    rx_axi_clk : in STD_LOGIC := 'X'; 
    sync_acq_status : out STD_LOGIC; 
    glbl_rstn : in STD_LOGIC := 'X'; 
    signal_det : in STD_LOGIC := 'X'; 
    rx_axis_mac_tuser : out STD_LOGIC; 
    loopback_msb : out STD_LOGIC; 
    rx_buf_status : in STD_LOGIC := 'X'; 
    rx_not_in_table : in STD_LOGIC := 'X'; 
    mdio_out : out STD_LOGIC; 
    tx_axi_rstn : in STD_LOGIC := 'X'; 
    mgt_tx_reset : out STD_LOGIC; 
    powerdown : out STD_LOGIC; 
    dcm_locked : in STD_LOGIC := 'X'; 
    tx_collision : out STD_LOGIC; 
    mdio_tri : out STD_LOGIC; 
    rx_run_disp : in STD_LOGIC := 'X'; 
    rx_axi_rstn : in STD_LOGIC := 'X'; 
    tx_char_disp_val : out STD_LOGIC; 
    rx_disp_err : in STD_LOGIC := 'X'; 
    tx_axis_mac_tlast : in STD_LOGIC := 'X'; 
    tx_retransmit : out STD_LOGIC; 
    en_comma_align : out STD_LOGIC; 
    tx_axis_mac_tuser : in STD_LOGIC := 'X'; 
    tx_axi_clk_out : out STD_LOGIC; 
    mdc_in : in STD_LOGIC := 'X'; 
    tx_buf_err : in STD_LOGIC := 'X'; 
    mdio_in : in STD_LOGIC := 'X'; 
    rx_char_is_k : in STD_LOGIC := 'X'; 
    rx_axis_mac_tvalid : out STD_LOGIC; 
    rx_statistics_valid : out STD_LOGIC; 
    tx_statistics_valid : out STD_LOGIC; 
    tx_char_is_k : out STD_LOGIC; 
    rx_axis_mac_tlast : out STD_LOGIC; 
    speed_is_10_100 : out STD_LOGIC; 
    gtx_clk : in STD_LOGIC := 'X'; 
    rx_reset_out : out STD_LOGIC; 
    tx_reset_out : out STD_LOGIC; 
    tx_axi_clk : in STD_LOGIC := 'X'; 
    gmii_rx_dv : in STD_LOGIC := 'X'; 
    mgt_rx_reset : out STD_LOGIC; 
    tx_axis_mac_tready : out STD_LOGIC; 
    rx_char_is_comma : in STD_LOGIC := 'X'; 
    tx_axis_mac_tvalid : in STD_LOGIC := 'X'; 
    an_interrupt : out STD_LOGIC; 
    tx_char_disp_mode : out STD_LOGIC; 
    pause_req : in STD_LOGIC := 'X'; 
    tx_statistics_vector : out STD_LOGIC_VECTOR ( 31 downto 0 ); 
    pause_val : in STD_LOGIC_VECTOR ( 15 downto 0 ); 
    rx_clk_cor_cnt : in STD_LOGIC_VECTOR ( 2 downto 0 ); 
    rx_statistics_vector : out STD_LOGIC_VECTOR ( 27 downto 0 ); 
    gmii_rxd : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    phy_ad : in STD_LOGIC_VECTOR ( 4 downto 0 ); 
    tx_ifg_delay : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    tx_axis_mac_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    rx_axis_mac_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    gmii_txd : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end v6_emac_v2_3_sgmii;

architecture STRUCTURE of v6_emac_v2_3_sgmii is
  signal N0 : STD_LOGIC; 
  signal NlwRenamedSig_OI_rx_reset_out : STD_LOGIC; 
  signal NlwRenamedSig_OI_tx_reset_out : STD_LOGIC; 
  signal NlwRenamedSig_OI_tx_axis_mac_tready : STD_LOGIC; 
  signal NlwRenamedSig_OI_tx_retransmit : STD_LOGIC; 
  signal BU2_N27 : STD_LOGIC; 
  signal BU2_N26 : STD_LOGIC; 
  signal BU2_N24 : STD_LOGIC; 
  signal BU2_N22 : STD_LOGIC; 
  signal BU2_N20 : STD_LOGIC; 
  signal BU2_N18 : STD_LOGIC; 
  signal BU2_N17 : STD_LOGIC; 
  signal BU2_N15 : STD_LOGIC; 
  signal BU2_N14 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_frame_complete_rstpot_423 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_end_rstpot_422 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_mac_tuser_rstpot_421 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_rstpot_420 : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_rstpot_419 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_no_burst_rstpot_418 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_rstpot_417 : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VALID_rstpot_416 : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VALID_rstpot_415 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_two_byte_tx_rstpot_414 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tlast_reg_413 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_ignore_packet_glue_set_412 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_valid_glue_set_411 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_early_underrun_glue_set_410 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_early_deassert_glue_set_409 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_burst1_408 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_burst1_glue_set_407 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_assert_406 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_assert_glue_set_405 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_burst2_404 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_burst2_glue_set_403 : STD_LOGIC; 
  signal BU2_U0_MATCH_FRAME_INT_402 : STD_LOGIC; 
  signal BU2_U0_MATCH_FRAME_INT_glue_set_401 : STD_LOGIC; 
  signal BU2_N12 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_underrun_glue_set : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_early_underrun_398 : STD_LOGIC; 
  signal BU2_N10 : STD_LOGIC; 
  signal BU2_N8 : STD_LOGIC; 
  signal BU2_N6 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_early_deassert_394 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_two_byte_tx_393 : STD_LOGIC; 
  signal BU2_N4 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_force_end_391 : STD_LOGIC; 
  signal BU2_N2 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o5_389 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o2_388 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o1_387 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_frame_complete_386 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385 : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tlast_reg_glue_set : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_3_tx_state_3_OR_34_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_3_tx_mac_tlast_AND_50_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_no_burst_379 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_ignore_packet_378 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377 : STD_LOGIC; 
  signal BU2_U0_SYNC_TX_RESET_I_R3_PWR_19_o_MUX_100_o : STD_LOGIC; 
  signal BU2_U0_SYNC_TX_RESET_I_R3_375 : STD_LOGIC; 
  signal BU2_U0_SYNC_RX_RESET_I_R3_PWR_19_o_MUX_100_o : STD_LOGIC; 
  signal BU2_U0_SYNC_RX_RESET_I_R3_373 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_7_o : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_next_rx_state_1_rx_enable_AND_9_o : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361 : STD_LOGIC; 
  signal BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_In : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_REQ_reg_359 : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd2_342 : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_equal_13_o : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv : STD_LOGIC; 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_0_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_1_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_2_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_3_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_4_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_5_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_6_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_7_Q : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_n0269_inv : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_70_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_tx_enable_reg_AND_33_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_28_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_In_305 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_In : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_302 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_In_301 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd5_300 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_71_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_PWR_18_o_equal_74_o : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_72_o : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_0_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_1_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_2_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_3_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_4_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_5_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_6_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_7_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_8_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_9_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_10_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_11_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_12_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_13_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_14_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_15_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_16_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_17_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_18_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_19_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_20_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_21_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_22_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_23_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_24_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_25_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_26_Q : STD_LOGIC; 
  signal BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_27_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_0_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_1_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_2_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_3_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_4_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_5_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_6_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_7_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_8_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_9_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_10_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_11_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_12_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_13_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_14_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_15_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_16_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_17_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_18_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_19_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_20_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_21_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_22_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_23_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_24_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_25_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_26_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_27_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_28_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_29_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_30_Q : STD_LOGIC; 
  signal BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_31_Q : STD_LOGIC; 
  signal BU2_U0_SYNC_TX_RESET_I_R2_234 : STD_LOGIC; 
  signal BU2_U0_SYNC_TX_RESET_I_R1_233 : STD_LOGIC; 
  signal BU2_U0_INT_TX_RST_ASYNCH : STD_LOGIC; 
  signal BU2_U0_SYNC_RX_RESET_I_R2_231 : STD_LOGIC; 
  signal BU2_U0_SYNC_RX_RESET_I_R1_230 : STD_LOGIC; 
  signal BU2_U0_INT_RX_RST_ASYNCH : STD_LOGIC; 
  signal BU2_U0_RX_BAD_FRAME : STD_LOGIC; 
  signal BU2_U0_INT_GLBL_RST : STD_LOGIC; 
  signal BU2_U0_TX_STATS_SHIFT : STD_LOGIC; 
  signal BU2_U0_RX_STATS_SHIFT_VLD : STD_LOGIC; 
  signal BU2_U0_TX_STATS_SHIFT_VLD : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_data_valid_184 : STD_LOGIC; 
  signal BU2_U0_tx_axi_shim_tx_underrun_183 : STD_LOGIC; 
  signal BU2_U0_PAUSE_REQ_INT : STD_LOGIC; 
  signal BU2_U0_RX_GOOD_FRAME : STD_LOGIC; 
  signal BU2_U0_RX_DATA_VALID : STD_LOGIC; 
  signal BU2_U0_TX_ACK : STD_LOGIC; 
  signal BU2_U0_TX_STATS_BYTEVLD : STD_LOGIC; 
  signal BU2_mdc_out : STD_LOGIC; 
  signal BU2_gmii_tx_er : STD_LOGIC; 
  signal BU2_gmii_tx_en : STD_LOGIC; 
  signal BU2_N0 : STD_LOGIC; 
  signal NLW_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTMIIMRDY_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_DCRHOSTDONEIR_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACPHYTXGMIIMIICLKOUT_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXFRAMEDROP_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXDVLDMSW_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXCLIENTCLKOUT_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXSTATSBYTEVLD_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRACK_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACPHYTXCLK_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACCLIENTRXD_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_EMACDCRDBUS_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_v6_emac_HOSTRDDATA_0_UNCONNECTED : STD_LOGIC; 
  signal gmii_txd_2 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal rx_axis_mac_tdata_3 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal NlwRenamedSig_OI_rx_statistics_vector : STD_LOGIC_VECTOR ( 27 downto 6 ); 
  signal rx_statistics_vector_4 : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal tx_axis_mac_tdata_5 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal tx_ifg_delay_6 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal NlwRenamedSig_OI_tx_statistics_vector : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal pause_val_7 : STD_LOGIC_VECTOR ( 15 downto 0 ); 
  signal gmii_rxd_8 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal phy_ad_9 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal rx_clk_cor_cnt_10 : STD_LOGIC_VECTOR ( 2 downto 0 ); 
  signal BU2_U0_rx_axi_shim_rx_data_reg : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg : STD_LOGIC_VECTOR ( 15 downto 0 ); 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_tx_axi_shim_tx_data_hold : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_RX_STATS_SHIFT : STD_LOGIC_VECTOR ( 6 downto 0 ); 
  signal BU2_U0_PAUSE_VAL_INT : STD_LOGIC_VECTOR ( 15 downto 0 ); 
  signal BU2_U0_RX_DATA : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_tx_axi_shim_tx_data : STD_LOGIC_VECTOR ( 7 downto 0 ); 
begin
  tx_statistics_vector(31) <= NlwRenamedSig_OI_tx_statistics_vector(31);
  tx_statistics_vector(30) <= NlwRenamedSig_OI_tx_statistics_vector(30);
  tx_statistics_vector(29) <= NlwRenamedSig_OI_tx_statistics_vector(29);
  tx_statistics_vector(28) <= NlwRenamedSig_OI_tx_statistics_vector(28);
  tx_statistics_vector(27) <= NlwRenamedSig_OI_tx_statistics_vector(27);
  tx_statistics_vector(26) <= NlwRenamedSig_OI_tx_statistics_vector(26);
  tx_statistics_vector(25) <= NlwRenamedSig_OI_tx_statistics_vector(25);
  tx_statistics_vector(24) <= NlwRenamedSig_OI_tx_statistics_vector(24);
  tx_statistics_vector(23) <= NlwRenamedSig_OI_tx_statistics_vector(23);
  tx_statistics_vector(22) <= NlwRenamedSig_OI_tx_statistics_vector(22);
  tx_statistics_vector(21) <= NlwRenamedSig_OI_tx_statistics_vector(21);
  tx_statistics_vector(20) <= NlwRenamedSig_OI_tx_statistics_vector(20);
  tx_statistics_vector(19) <= NlwRenamedSig_OI_tx_statistics_vector(19);
  tx_statistics_vector(18) <= NlwRenamedSig_OI_tx_statistics_vector(18);
  tx_statistics_vector(17) <= NlwRenamedSig_OI_tx_statistics_vector(17);
  tx_statistics_vector(16) <= NlwRenamedSig_OI_tx_statistics_vector(16);
  tx_statistics_vector(15) <= NlwRenamedSig_OI_tx_statistics_vector(15);
  tx_statistics_vector(14) <= NlwRenamedSig_OI_tx_statistics_vector(14);
  tx_statistics_vector(13) <= NlwRenamedSig_OI_tx_statistics_vector(13);
  tx_statistics_vector(12) <= NlwRenamedSig_OI_tx_statistics_vector(12);
  tx_statistics_vector(11) <= NlwRenamedSig_OI_tx_statistics_vector(11);
  tx_statistics_vector(10) <= NlwRenamedSig_OI_tx_statistics_vector(10);
  tx_statistics_vector(9) <= NlwRenamedSig_OI_tx_statistics_vector(9);
  tx_statistics_vector(8) <= NlwRenamedSig_OI_tx_statistics_vector(8);
  tx_statistics_vector(7) <= NlwRenamedSig_OI_tx_statistics_vector(7);
  tx_statistics_vector(6) <= NlwRenamedSig_OI_tx_statistics_vector(6);
  tx_statistics_vector(5) <= NlwRenamedSig_OI_tx_statistics_vector(5);
  tx_statistics_vector(4) <= NlwRenamedSig_OI_tx_statistics_vector(4);
  tx_statistics_vector(3) <= NlwRenamedSig_OI_tx_statistics_vector(3);
  tx_statistics_vector(2) <= NlwRenamedSig_OI_tx_statistics_vector(2);
  tx_statistics_vector(1) <= NlwRenamedSig_OI_tx_statistics_vector(1);
  tx_statistics_vector(0) <= NlwRenamedSig_OI_tx_statistics_vector(0);
  pause_val_7(15) <= pause_val(15);
  pause_val_7(14) <= pause_val(14);
  pause_val_7(13) <= pause_val(13);
  pause_val_7(12) <= pause_val(12);
  pause_val_7(11) <= pause_val(11);
  pause_val_7(10) <= pause_val(10);
  pause_val_7(9) <= pause_val(9);
  pause_val_7(8) <= pause_val(8);
  pause_val_7(7) <= pause_val(7);
  pause_val_7(6) <= pause_val(6);
  pause_val_7(5) <= pause_val(5);
  pause_val_7(4) <= pause_val(4);
  pause_val_7(3) <= pause_val(3);
  pause_val_7(2) <= pause_val(2);
  pause_val_7(1) <= pause_val(1);
  pause_val_7(0) <= pause_val(0);
  rx_clk_cor_cnt_10(2) <= rx_clk_cor_cnt(2);
  rx_clk_cor_cnt_10(1) <= rx_clk_cor_cnt(1);
  rx_clk_cor_cnt_10(0) <= rx_clk_cor_cnt(0);
  rx_statistics_vector(27) <= NlwRenamedSig_OI_rx_statistics_vector(27);
  rx_statistics_vector(26) <= NlwRenamedSig_OI_rx_statistics_vector(26);
  rx_statistics_vector(25) <= NlwRenamedSig_OI_rx_statistics_vector(25);
  rx_statistics_vector(24) <= NlwRenamedSig_OI_rx_statistics_vector(24);
  rx_statistics_vector(23) <= NlwRenamedSig_OI_rx_statistics_vector(23);
  rx_statistics_vector(22) <= NlwRenamedSig_OI_rx_statistics_vector(22);
  rx_statistics_vector(21) <= NlwRenamedSig_OI_rx_statistics_vector(21);
  rx_statistics_vector(20) <= NlwRenamedSig_OI_rx_statistics_vector(20);
  rx_statistics_vector(19) <= NlwRenamedSig_OI_rx_statistics_vector(19);
  rx_statistics_vector(18) <= NlwRenamedSig_OI_rx_statistics_vector(18);
  rx_statistics_vector(17) <= NlwRenamedSig_OI_rx_statistics_vector(17);
  rx_statistics_vector(16) <= NlwRenamedSig_OI_rx_statistics_vector(16);
  rx_statistics_vector(15) <= NlwRenamedSig_OI_rx_statistics_vector(15);
  rx_statistics_vector(14) <= NlwRenamedSig_OI_rx_statistics_vector(14);
  rx_statistics_vector(13) <= NlwRenamedSig_OI_rx_statistics_vector(13);
  rx_statistics_vector(12) <= NlwRenamedSig_OI_rx_statistics_vector(12);
  rx_statistics_vector(11) <= NlwRenamedSig_OI_rx_statistics_vector(11);
  rx_statistics_vector(10) <= NlwRenamedSig_OI_rx_statistics_vector(10);
  rx_statistics_vector(9) <= NlwRenamedSig_OI_rx_statistics_vector(9);
  rx_statistics_vector(8) <= NlwRenamedSig_OI_rx_statistics_vector(8);
  rx_statistics_vector(7) <= NlwRenamedSig_OI_rx_statistics_vector(7);
  rx_statistics_vector(6) <= NlwRenamedSig_OI_rx_statistics_vector(6);
  rx_statistics_vector(5) <= rx_statistics_vector_4(5);
  rx_statistics_vector(4) <= rx_statistics_vector_4(4);
  rx_statistics_vector(3) <= rx_statistics_vector_4(3);
  rx_statistics_vector(2) <= rx_statistics_vector_4(2);
  rx_statistics_vector(1) <= rx_statistics_vector_4(1);
  rx_statistics_vector(0) <= rx_statistics_vector_4(0);
  gmii_rxd_8(7) <= gmii_rxd(7);
  gmii_rxd_8(6) <= gmii_rxd(6);
  gmii_rxd_8(5) <= gmii_rxd(5);
  gmii_rxd_8(4) <= gmii_rxd(4);
  gmii_rxd_8(3) <= gmii_rxd(3);
  gmii_rxd_8(2) <= gmii_rxd(2);
  gmii_rxd_8(1) <= gmii_rxd(1);
  gmii_rxd_8(0) <= gmii_rxd(0);
  phy_ad_9(4) <= phy_ad(4);
  phy_ad_9(3) <= phy_ad(3);
  phy_ad_9(2) <= phy_ad(2);
  phy_ad_9(1) <= phy_ad(1);
  phy_ad_9(0) <= phy_ad(0);
  tx_retransmit <= NlwRenamedSig_OI_tx_retransmit;
  tx_ifg_delay_6(7) <= tx_ifg_delay(7);
  tx_ifg_delay_6(6) <= tx_ifg_delay(6);
  tx_ifg_delay_6(5) <= tx_ifg_delay(5);
  tx_ifg_delay_6(4) <= tx_ifg_delay(4);
  tx_ifg_delay_6(3) <= tx_ifg_delay(3);
  tx_ifg_delay_6(2) <= tx_ifg_delay(2);
  tx_ifg_delay_6(1) <= tx_ifg_delay(1);
  tx_ifg_delay_6(0) <= tx_ifg_delay(0);
  tx_axis_mac_tdata_5(7) <= tx_axis_mac_tdata(7);
  tx_axis_mac_tdata_5(6) <= tx_axis_mac_tdata(6);
  tx_axis_mac_tdata_5(5) <= tx_axis_mac_tdata(5);
  tx_axis_mac_tdata_5(4) <= tx_axis_mac_tdata(4);
  tx_axis_mac_tdata_5(3) <= tx_axis_mac_tdata(3);
  tx_axis_mac_tdata_5(2) <= tx_axis_mac_tdata(2);
  tx_axis_mac_tdata_5(1) <= tx_axis_mac_tdata(1);
  tx_axis_mac_tdata_5(0) <= tx_axis_mac_tdata(0);
  rx_axis_mac_tdata(7) <= rx_axis_mac_tdata_3(7);
  rx_axis_mac_tdata(6) <= rx_axis_mac_tdata_3(6);
  rx_axis_mac_tdata(5) <= rx_axis_mac_tdata_3(5);
  rx_axis_mac_tdata(4) <= rx_axis_mac_tdata_3(4);
  rx_axis_mac_tdata(3) <= rx_axis_mac_tdata_3(3);
  rx_axis_mac_tdata(2) <= rx_axis_mac_tdata_3(2);
  rx_axis_mac_tdata(1) <= rx_axis_mac_tdata_3(1);
  rx_axis_mac_tdata(0) <= rx_axis_mac_tdata_3(0);
  rx_reset_out <= NlwRenamedSig_OI_rx_reset_out;
  tx_reset_out <= NlwRenamedSig_OI_tx_reset_out;
  gmii_txd(7) <= gmii_txd_2(7);
  gmii_txd(6) <= gmii_txd_2(6);
  gmii_txd(5) <= gmii_txd_2(5);
  gmii_txd(4) <= gmii_txd_2(4);
  gmii_txd(3) <= gmii_txd_2(3);
  gmii_txd(2) <= gmii_txd_2(2);
  gmii_txd(1) <= gmii_txd_2(1);
  gmii_txd(0) <= gmii_txd_2(0);
  tx_axis_mac_tready <= NlwRenamedSig_OI_tx_axis_mac_tready;
  VCC_0 : VCC
    port map (
      P => NLW_VCC_P_UNCONNECTED
    );
  GND_1 : GND
    port map (
      G => N0
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv1_INV_0 : INV
    port map (
      I => BU2_U0_TX_STATS_BYTEVLD,
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mcount_tx_stats_bytevld_ctr_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(0)
    );
  BU2_U0_INT_GLBL_RST1_INV_0 : INV
    port map (
      I => glbl_rstn,
      O => BU2_U0_INT_GLBL_RST
    );
  BU2_U0_tx_axi_shim_ignore_packet_glue_set : LUT6
    generic map(
      INIT => X"08082A0808080808"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => BU2_U0_tx_axi_shim_ignore_packet_378,
      I2 => tx_axis_mac_tlast,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I4 => NlwRenamedSig_OI_tx_axis_mac_tready,
      I5 => tx_axis_mac_tuser,
      O => BU2_U0_tx_axi_shim_ignore_packet_glue_set_412
    );
  BU2_U0_rx_axi_shim_rx_frame_complete_rstpot : LUT5
    generic map(
      INIT => X"FFFFFF8A"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      I1 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I2 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I3 => BU2_U0_RX_BAD_FRAME,
      I4 => BU2_U0_RX_GOOD_FRAME,
      O => BU2_U0_rx_axi_shim_rx_frame_complete_rstpot_423
    );
  BU2_U0_SYNC_TX_RESET_I_R3 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => tx_axi_clk,
      D => BU2_U0_SYNC_TX_RESET_I_R2_234,
      Q => BU2_U0_SYNC_TX_RESET_I_R3_375
    );
  BU2_U0_SYNC_TX_RESET_I_R4 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => tx_axi_clk,
      D => BU2_U0_SYNC_TX_RESET_I_R3_PWR_19_o_MUX_100_o,
      Q => NlwRenamedSig_OI_tx_reset_out
    );
  BU2_U0_SYNC_RX_RESET_I_R3 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => rx_axi_clk,
      D => BU2_U0_SYNC_RX_RESET_I_R2_231,
      Q => BU2_U0_SYNC_RX_RESET_I_R3_373
    );
  BU2_U0_SYNC_RX_RESET_I_R4 : FD
    generic map(
      INIT => '1'
    )
    port map (
      C => rx_axi_clk,
      D => BU2_U0_SYNC_RX_RESET_I_R3_PWR_19_o_MUX_100_o,
      Q => NlwRenamedSig_OI_rx_reset_out
    );
  BU2_U0_tx_axi_shim_two_byte_tx_rstpot : LUT4
    generic map(
      INIT => X"ABA8"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312,
      I3 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      O => BU2_U0_tx_axi_shim_two_byte_tx_rstpot_414
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o7 : LUT5
    generic map(
      INIT => X"FFEFFFEC"
    )
    port map (
      I0 => BU2_N27,
      I1 => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o2_388,
      I2 => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o5_389,
      I3 => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o1_387,
      I4 => BU2_N26,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o7_SW1 : LUT4
    generic map(
      INIT => X"444F"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308,
      I2 => BU2_U0_tx_axi_shim_early_deassert_394,
      I3 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      O => BU2_N27
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o7_SW0 : LUT6
    generic map(
      INIT => X"44454444444F4444"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308,
      I2 => BU2_U0_tx_axi_shim_early_deassert_394,
      I3 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I5 => NlwRenamedSig_OI_tx_axis_mac_tready,
      O => BU2_N26
    );
  BU2_U0_tx_axi_shim_early_deassert_glue_set : LUT6
    generic map(
      INIT => X"FFFFFFFF00404040"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I1 => BU2_U0_tx_axi_shim_tx_data_valid_184,
      I2 => BU2_U0_tx_axi_shim_early_deassert_394,
      I3 => tx_axis_mac_tvalid,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I5 => BU2_U0_tx_axi_shim_tx_state_3_tx_mac_tlast_AND_50_o,
      O => BU2_U0_tx_axi_shim_early_deassert_glue_set_409
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_rstpot : LUT6
    generic map(
      INIT => X"0000FFDF00000000"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(3),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      I3 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      I4 => NlwRenamedSig_OI_tx_reset_out,
      I5 => BU2_N24,
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_rstpot_419
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_rstpot_SW0 : LUT3
    generic map(
      INIT => X"EC"
    )
    port map (
      I0 => pause_req,
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd2_342,
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      O => BU2_N24
    );
  BU2_U0_tx_axi_shim_early_underrun_glue_set : LUT6
    generic map(
      INIT => X"1000555510001000"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I2 => tx_axis_mac_tuser,
      I3 => NlwRenamedSig_OI_tx_axis_mac_tready,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I5 => BU2_N22,
      O => BU2_U0_tx_axi_shim_early_underrun_glue_set_410
    );
  BU2_U0_tx_axi_shim_early_underrun_glue_set_SW0 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_early_underrun_398,
      I1 => BU2_U0_TX_ACK,
      O => BU2_N22
    );
  BU2_U0_tx_axi_shim_force_assert_glue_set : LUT6
    generic map(
      INIT => X"FFFFFFFFAE0C0C0C"
    )
    port map (
      I0 => BU2_N12,
      I1 => BU2_U0_tx_axi_shim_force_assert_406,
      I2 => BU2_U0_tx_axi_shim_tx_data_valid_184,
      I3 => BU2_U0_tx_axi_shim_early_deassert_394,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I5 => BU2_N20,
      O => BU2_U0_tx_axi_shim_force_assert_glue_set_405
    );
  BU2_U0_tx_axi_shim_force_assert_glue_set_SW0 : LUT3
    generic map(
      INIT => X"2C"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_force_burst2_404,
      I2 => BU2_U0_tx_axi_shim_force_burst1_408,
      O => BU2_N20
    );
  BU2_U0_tx_axi_shim_tx_data_valid_glue_set : LUT6
    generic map(
      INIT => X"FFBFAABFFFAAAAAA"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_force_assert_406,
      I1 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I4 => BU2_N18,
      I5 => BU2_N17,
      O => BU2_U0_tx_axi_shim_tx_data_valid_glue_set_411
    );
  BU2_U0_tx_axi_shim_tx_data_valid_glue_set_SW1 : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => tx_axis_mac_tuser,
      I2 => BU2_U0_tx_axi_shim_no_burst_379,
      I3 => BU2_U0_tx_axi_shim_ignore_packet_378,
      O => BU2_N18
    );
  BU2_U0_tx_axi_shim_tx_data_valid_glue_set_SW0 : LUT6
    generic map(
      INIT => X"05000D0005000F00"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => tx_axis_mac_tvalid,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_302,
      I3 => BU2_U0_tx_axi_shim_tx_data_valid_184,
      I4 => BU2_U0_tx_axi_shim_early_deassert_394,
      I5 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      O => BU2_N17
    );
  BU2_U0_rx_axi_shim_rx_mac_tuser_rstpot : LUT6
    generic map(
      INIT => X"0008000800080000"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I1 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I2 => NlwRenamedSig_OI_rx_reset_out,
      I3 => BU2_U0_MATCH_FRAME_INT_402,
      I4 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      I5 => BU2_U0_RX_DATA_VALID,
      O => BU2_U0_rx_axi_shim_rx_mac_tuser_rstpot_421
    );
  BU2_U0_tx_axi_shim_no_burst_rstpot : LUT3
    generic map(
      INIT => X"02"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_302,
      I1 => tx_axis_mac_tvalid,
      I2 => NlwRenamedSig_OI_tx_reset_out,
      O => BU2_U0_tx_axi_shim_no_burst_rstpot_418
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_rstpot : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => NlwRenamedSig_OI_tx_reset_out,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I2 => tx_axis_mac_tvalid,
      O => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_rstpot_417
    );
  BU2_U0_INT_RX_STATISTICS_VALID_rstpot : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => NlwRenamedSig_OI_rx_reset_out,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(6),
      I2 => BU2_U0_RX_STATS_SHIFT_VLD,
      O => BU2_U0_INT_RX_STATISTICS_VALID_rstpot_416
    );
  BU2_U0_INT_TX_STATISTICS_VALID_rstpot : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => NlwRenamedSig_OI_tx_reset_out,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(0),
      I2 => BU2_U0_TX_STATS_SHIFT_VLD,
      O => BU2_U0_INT_TX_STATISTICS_VALID_rstpot_415
    );
  BU2_U0_MATCH_FRAME_INT_glue_set : LUT3
    generic map(
      INIT => X"BA"
    )
    port map (
      I0 => BU2_U0_RX_GOOD_FRAME,
      I1 => BU2_U0_RX_BAD_FRAME,
      I2 => BU2_U0_MATCH_FRAME_INT_402,
      O => BU2_U0_MATCH_FRAME_INT_glue_set_401
    );
  BU2_U0_tx_axi_shim_force_burst2_glue_set : LUT6
    generic map(
      INIT => X"FFFF800080008000"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I1 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I2 => BU2_U0_tx_axi_shim_tlast_reg_413,
      I3 => tx_axis_mac_tvalid,
      I4 => BU2_U0_tx_axi_shim_force_burst1_408,
      I5 => BU2_U0_tx_axi_shim_force_burst2_404,
      O => BU2_U0_tx_axi_shim_force_burst2_glue_set_403
    );
  BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_rstpot : LUT5
    generic map(
      INIT => X"20002222"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I1 => NlwRenamedSig_OI_rx_reset_out,
      I2 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      I3 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I4 => BU2_U0_RX_DATA_VALID,
      O => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_rstpot_420
    );
  BU2_U0_tx_axi_shim_force_end_rstpot : LUT6
    generic map(
      INIT => X"FFFFFFFF888F8888"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd5_300,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I4 => BU2_U0_tx_axi_shim_force_end_391,
      I5 => NlwRenamedSig_OI_tx_retransmit,
      O => BU2_U0_tx_axi_shim_force_end_rstpot_422
    );
  BU2_U0_tx_axi_shim_force_burst1_glue_set : LUT6
    generic map(
      INIT => X"FFECFFA013005F00"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I1 => BU2_U0_tx_axi_shim_early_deassert_394,
      I2 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I3 => BU2_N14,
      I4 => BU2_U0_tx_axi_shim_tx_state_3_tx_state_3_OR_34_o,
      I5 => BU2_N15,
      O => BU2_U0_tx_axi_shim_force_burst1_glue_set_407
    );
  BU2_U0_tx_axi_shim_early_deassert_two_byte_tx_OR_35_o1_SW1 : LUT4
    generic map(
      INIT => X"B3A0"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => BU2_U0_TX_ACK,
      I2 => BU2_U0_tx_axi_shim_tlast_reg_413,
      I3 => BU2_U0_tx_axi_shim_force_burst1_408,
      O => BU2_N15
    );
  BU2_U0_tx_axi_shim_early_deassert_two_byte_tx_OR_35_o1_SW0 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_force_burst1_408,
      O => BU2_N14
    );
  BU2_U0_rx_axi_shim_rx_frame_complete : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_rx_frame_complete_rstpot_423,
      Q => BU2_U0_rx_axi_shim_rx_frame_complete_386
    );
  BU2_U0_tx_axi_shim_force_end : FD
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_force_end_rstpot_422,
      Q => BU2_U0_tx_axi_shim_force_end_391
    );
  BU2_U0_rx_axi_shim_rx_mac_tuser : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_rx_mac_tuser_rstpot_421,
      Q => rx_axis_mac_tuser
    );
  BU2_U0_rx_axi_shim_rx_state_FSM_FFd1 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_rstpot_420,
      Q => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1 : FD
    port map (
      C => tx_axi_clk,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_rstpot_419,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384
    );
  BU2_U0_tx_axi_shim_no_burst : FD
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_no_burst_rstpot_418,
      Q => BU2_U0_tx_axi_shim_no_burst_379
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd1 : FD
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_rstpot_417,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377
    );
  BU2_U0_INT_RX_STATISTICS_VALID : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VALID_rstpot_416,
      Q => rx_statistics_valid
    );
  BU2_U0_INT_TX_STATISTICS_VALID : FD
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VALID_rstpot_415,
      Q => tx_statistics_valid
    );
  BU2_U0_tx_axi_shim_two_byte_tx : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_two_byte_tx_rstpot_414,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_two_byte_tx_393
    );
  BU2_U0_tx_axi_shim_tx_underrun : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_underrun_glue_set,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_underrun_183
    );
  BU2_U0_tx_axi_shim_tlast_reg : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tlast_reg_glue_set,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tlast_reg_413
    );
  BU2_U0_tx_axi_shim_ignore_packet : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_ignore_packet_glue_set_412,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_ignore_packet_378
    );
  BU2_U0_tx_axi_shim_tx_data_valid : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_data_valid_glue_set_411,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_valid_184
    );
  BU2_U0_tx_axi_shim_early_underrun : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_early_underrun_glue_set_410,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_early_underrun_398
    );
  BU2_U0_tx_axi_shim_early_deassert : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_early_deassert_glue_set_409,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_early_deassert_394
    );
  BU2_U0_tx_axi_shim_force_burst1 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_force_burst1_glue_set_407,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_force_burst1_408
    );
  BU2_U0_tx_axi_shim_force_assert : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_force_assert_glue_set_405,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_force_assert_406
    );
  BU2_U0_tx_axi_shim_force_burst2 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_force_burst2_glue_set_403,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_force_burst2_404
    );
  BU2_U0_MATCH_FRAME_INT : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_MATCH_FRAME_INT_glue_set_401,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => BU2_U0_MATCH_FRAME_INT_402
    );
  BU2_U0_tx_axi_shim_early_deassert_force_burst2_OR_33_o_SW0 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => tx_axis_mac_tlast,
      O => BU2_N12
    );
  BU2_U0_tx_axi_shim_tx_mac_tready_int_tx_ack_wire_OR_29_o : LUT6
    generic map(
      INIT => X"FFFF00C800C800C8"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_early_underrun_398,
      I2 => BU2_U0_tx_axi_shim_force_end_391,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I5 => BU2_N10,
      O => BU2_U0_tx_axi_shim_tx_underrun_glue_set
    );
  BU2_U0_tx_axi_shim_tx_mac_tready_int_tx_ack_wire_OR_29_o_SW0 : LUT3
    generic map(
      INIT => X"D0"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => tx_axis_mac_tuser,
      I2 => NlwRenamedSig_OI_tx_axis_mac_tready,
      O => BU2_N10
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_In : LUT6
    generic map(
      INIT => X"FFFFF2F0F3F3F2F0"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => tx_axis_mac_tvalid,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_302,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I5 => BU2_N8,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_tx_enable_reg_AND_33_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_In_SW0 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => tx_axis_mac_tuser,
      I1 => BU2_U0_tx_axi_shim_no_burst_379,
      I2 => BU2_U0_tx_axi_shim_ignore_packet_378,
      O => BU2_N8
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_In : LUT6
    generic map(
      INIT => X"FFFFFFFFAAAAAA08"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      I2 => tx_axis_mac_tvalid,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I5 => BU2_N6,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_PWR_18_o_equal_74_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_In_SW0 : LUT5
    generic map(
      INIT => X"01000300"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => BU2_U0_tx_axi_shim_early_deassert_394,
      I2 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I4 => NlwRenamedSig_OI_tx_axis_mac_tready,
      O => BU2_N6
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_In : LUT6
    generic map(
      INIT => X"FFFFFFFFAAAAA888"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I1 => BU2_U0_tx_axi_shim_two_byte_tx_393,
      I2 => NlwRenamedSig_OI_tx_axis_mac_tready,
      I3 => tx_axis_mac_tlast,
      I4 => BU2_U0_tx_axi_shim_early_deassert_394,
      I5 => BU2_N4,
      O => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_In_301
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_In_SW0 : LUT4
    generic map(
      INIT => X"1000"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => BU2_U0_TX_ACK,
      I2 => BU2_U0_tx_axi_shim_force_end_391,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      O => BU2_N4
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_In : LUT6
    generic map(
      INIT => X"FFFFFFFFAAAAAAAE"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd5_300,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      I2 => BU2_U0_tx_axi_shim_force_end_391,
      I3 => BU2_U0_TX_ACK,
      I4 => tx_axis_mac_tvalid,
      I5 => BU2_N2,
      O => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_In_305
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_In_SW0 : LUT4
    generic map(
      INIT => X"8880"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => tx_axis_mac_tuser,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308,
      O => BU2_N2
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o5 : LUT4
    generic map(
      INIT => X"AAA8"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o5_389
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o2 : LUT6
    generic map(
      INIT => X"FF0FFF0FFF08FF00"
    )
    port map (
      I0 => tx_axis_mac_tuser,
      I1 => tx_axis_mac_tlast,
      I2 => BU2_U0_TX_ACK,
      I3 => BU2_U0_tx_axi_shim_ignore_packet_378,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I5 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o2_388
    );
  BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o1 : LUT6
    generic map(
      INIT => X"CCCCCCCCCC04CC00"
    )
    port map (
      I0 => tx_axis_mac_tuser,
      I1 => tx_axis_mac_tvalid,
      I2 => BU2_U0_tx_axi_shim_no_burst_379,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I5 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o1_387
    );
  BU2_U0_rx_axi_shim_rx_state_rx_state_1_rx_enable_AND_13_o1 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I1 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      O => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o
    );
  BU2_U0_rx_axi_shim_next_rx_state_1_rx_enable_AND_9_o1 : LUT4
    generic map(
      INIT => X"8880"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I1 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I2 => BU2_U0_RX_DATA_VALID,
      I3 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      O => BU2_U0_rx_axi_shim_next_rx_state_1_rx_enable_AND_9_o
    );
  BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_7_o1 : LUT4
    generic map(
      INIT => X"AA80"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I1 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      I2 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I3 => BU2_U0_RX_DATA_VALID,
      O => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_7_o
    );
  BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_In1 : LUT4
    generic map(
      INIT => X"3B2A"
    )
    port map (
      I0 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361,
      I1 => BU2_U0_rx_axi_shim_rx_state_FSM_FFd1_385,
      I2 => BU2_U0_rx_axi_shim_rx_frame_complete_386,
      I3 => BU2_U0_RX_DATA_VALID,
      O => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_In
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_REQ_out1 : LUT4
    generic map(
      INIT => X"88D8"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_REQ_reg_359,
      I2 => pause_req,
      I3 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd2_342,
      O => BU2_U0_PAUSE_REQ_INT
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mcount_tx_stats_bytevld_ctr_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(1)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out161 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(9),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(9),
      O => BU2_U0_PAUSE_VAL_INT(9)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out151 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(8),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(8),
      O => BU2_U0_PAUSE_VAL_INT(8)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out141 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(7),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(7),
      O => BU2_U0_PAUSE_VAL_INT(7)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out131 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(6),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(6),
      O => BU2_U0_PAUSE_VAL_INT(6)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out121 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(5),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(5),
      O => BU2_U0_PAUSE_VAL_INT(5)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out111 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(4),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(4),
      O => BU2_U0_PAUSE_VAL_INT(4)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out101 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(3),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(3),
      O => BU2_U0_PAUSE_VAL_INT(3)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(2),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(2),
      O => BU2_U0_PAUSE_VAL_INT(2)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(1),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(1),
      O => BU2_U0_PAUSE_VAL_INT(1)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(15),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(15),
      O => BU2_U0_PAUSE_VAL_INT(15)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out61 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(14),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(14),
      O => BU2_U0_PAUSE_VAL_INT(14)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out51 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(13),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(13),
      O => BU2_U0_PAUSE_VAL_INT(13)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out41 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(12),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(12),
      O => BU2_U0_PAUSE_VAL_INT(12)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out31 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(11),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(11),
      O => BU2_U0_PAUSE_VAL_INT(11)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out21 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(10),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(10),
      O => BU2_U0_PAUSE_VAL_INT(10)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Mmux_PAUSE_VAL_out17 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd1_384,
      I1 => pause_val_7(0),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(0),
      O => BU2_U0_PAUSE_VAL_INT(0)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o1 : LUT3
    generic map(
      INIT => X"57"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(3),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_equal_13_o11 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(3),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      I3 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_equal_13_o
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result_3_1 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(3),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      I3 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(3)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result_2_1 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2),
      I1 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0),
      I2 => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1),
      O => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(2)
    );
  BU2_U0_tx_axi_shim_tx_mac_tlast_tx_mac_tready_int_AND_27_o1 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => tx_axis_mac_tlast,
      I1 => NlwRenamedSig_OI_tx_axis_mac_tready,
      O => BU2_U0_tx_axi_shim_tlast_reg_glue_set
    );
  BU2_U0_tx_axi_shim_tx_state_tx_state_3_tx_state_3_OR_34_o1 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      O => BU2_U0_tx_axi_shim_tx_state_3_tx_state_3_OR_34_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_In1 : LUT4
    generic map(
      INIT => X"88D8"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I3 => BU2_U0_TX_ACK,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_72_o
    );
  BU2_U0_tx_axi_shim_n0269_inv1 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      O => BU2_U0_tx_axi_shim_n0269_inv
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT111 : LUT5
    generic map(
      INIT => X"FFFFFFF8"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I4 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      O => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT12 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(7),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(7),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_7_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT21 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(6),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(6),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_6_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT31 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(5),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(5),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_5_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT41 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(4),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(4),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_4_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT51 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(3),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(3),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_3_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT61 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(2),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(2),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_2_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT71 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(1),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(1),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_1_Q
    );
  BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT81 : LUT3
    generic map(
      INIT => X"AC"
    )
    port map (
      I0 => tx_axis_mac_tdata_5(0),
      I1 => BU2_U0_tx_axi_shim_tx_data_hold(0),
      I2 => BU2_U0_tx_axi_shim_Mmux_tx_data_7_tx_mac_tdata_7_mux_64_OUT11,
      O => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_0_Q
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd5_In1 : LUT4
    generic map(
      INIT => X"4000"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => tx_axis_mac_tlast,
      I2 => tx_axis_mac_tuser,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_71_o
    );
  BU2_U0_tx_axi_shim_tx_state_3_tx_mac_tlast_AND_50_o1 : LUT5
    generic map(
      INIT => X"00080000"
    )
    port map (
      I0 => tx_axis_mac_tvalid,
      I1 => tx_axis_mac_tlast,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I4 => NlwRenamedSig_OI_tx_axis_mac_tready,
      O => BU2_U0_tx_axi_shim_tx_state_3_tx_mac_tlast_AND_50_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_In1 : LUT5
    generic map(
      INIT => X"00000040"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_ignore_packet_378,
      I1 => tx_axis_mac_tvalid,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310,
      I3 => tx_axis_mac_tuser,
      I4 => BU2_U0_tx_axi_shim_no_burst_379,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_28_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_In1 : LUT3
    generic map(
      INIT => X"2A"
    )
    port map (
      I0 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308,
      I1 => tx_axis_mac_tlast,
      I2 => tx_axis_mac_tuser,
      O => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_70_o
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_In1 : LUT6
    generic map(
      INIT => X"4444F5F4F5F4F5F4"
    )
    port map (
      I0 => BU2_U0_TX_ACK,
      I1 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd1_377,
      I2 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312,
      I3 => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304,
      I4 => tx_axis_mac_tlast,
      I5 => tx_axis_mac_tuser,
      O => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_In
    );
  BU2_U0_INT_TX_RST_ASYNCH1 : LUT2
    generic map(
      INIT => X"7"
    )
    port map (
      I0 => glbl_rstn,
      I1 => tx_axi_rstn,
      O => BU2_U0_INT_TX_RST_ASYNCH
    );
  BU2_U0_INT_RX_RST_ASYNCH1 : LUT2
    generic map(
      INIT => X"7"
    )
    port map (
      I0 => glbl_rstn,
      I1 => rx_axi_rstn,
      O => BU2_U0_INT_RX_RST_ASYNCH
    );
  BU2_U0_SYNC_TX_RESET_I_Mmux_R3_PWR_19_o_MUX_100_o11 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => BU2_U0_SYNC_TX_RESET_I_R2_234,
      I1 => BU2_U0_SYNC_TX_RESET_I_R3_375,
      O => BU2_U0_SYNC_TX_RESET_I_R3_PWR_19_o_MUX_100_o
    );
  BU2_U0_SYNC_RX_RESET_I_Mmux_R3_PWR_19_o_MUX_100_o11 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => BU2_U0_SYNC_RX_RESET_I_R2_231,
      I1 => BU2_U0_SYNC_RX_RESET_I_R3_373,
      O => BU2_U0_SYNC_RX_RESET_I_R3_PWR_19_o_MUX_100_o
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT321 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(10),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_9_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT311 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(9),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_8_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT301 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(8),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_7_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT291 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(7),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_6_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT281 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(6),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_5_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT271 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(5),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_4_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT261 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(4),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_3_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT251 : LUT2
    generic map(
      INIT => X"B"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT,
      I1 => BU2_U0_TX_STATS_SHIFT_VLD,
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_31_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT241 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(31),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_30_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT231 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(3),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_2_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT221 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(30),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_29_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT211 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(29),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_28_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT201 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(28),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_27_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT191 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(27),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_26_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT181 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(26),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_25_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT171 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(25),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_24_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT161 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(24),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_23_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT151 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(23),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_22_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT141 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(22),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_21_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT131 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(21),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_20_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT121 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(2),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_1_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT111 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(20),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_19_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT101 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(19),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_18_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT91 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(18),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_17_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT81 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(17),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_16_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT71 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(16),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_15_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT61 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(15),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_14_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT51 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(14),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_13_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT41 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(13),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_12_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT33 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(12),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_11_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT210 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(11),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_10_Q
    );
  BU2_U0_Mmux_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT110 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_TX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_tx_statistics_vector(1),
      O => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_0_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT281 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(16),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_9_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT271 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(15),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_8_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT261 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(14),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_7_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT251 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(13),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_6_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT241 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(12),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_5_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT231 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(11),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_4_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT221 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(10),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_3_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT211 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(9),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_2_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT201 : LUT2
    generic map(
      INIT => X"B"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT(6),
      I1 => BU2_U0_RX_STATS_SHIFT_VLD,
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_27_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT191 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(5),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_26_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT181 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(4),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_25_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT171 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(3),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_24_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT161 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(2),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_23_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT151 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(1),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_22_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT141 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => BU2_U0_RX_STATS_SHIFT(0),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_21_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT131 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(27),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_20_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT121 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(8),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_1_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT111 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(26),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_19_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT101 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(25),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_18_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT91 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(24),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_17_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT81 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(23),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_16_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT71 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(22),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_15_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT61 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(21),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_14_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT51 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(20),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_13_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT41 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(19),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_12_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT31 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(18),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_11_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT29 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(17),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_10_Q
    );
  BU2_U0_Mmux_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT110 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => BU2_U0_RX_STATS_SHIFT_VLD,
      I1 => NlwRenamedSig_OI_rx_statistics_vector(7),
      O => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_0_Q
    );
  BU2_U0_rx_axi_shim_rx_data_reg_0 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(0),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(0)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_1 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(1),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(1)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_2 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(2),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(2)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_3 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(3),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(3)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_4 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(4),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(4)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_5 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(5),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(5)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_6 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(6),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(6)
    );
  BU2_U0_rx_axi_shim_rx_data_reg_7 : FD
    port map (
      C => rx_axi_clk,
      D => BU2_U0_RX_DATA(7),
      Q => BU2_U0_rx_axi_shim_rx_data_reg(7)
    );
  BU2_U0_rx_axi_shim_rx_mac_tvalid : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_7_o,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tvalid
    );
  BU2_U0_rx_axi_shim_rx_mac_tlast : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_next_rx_state_1_rx_enable_AND_9_o,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tlast
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_0 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(0),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(0)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_1 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(1),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(1)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_2 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(2),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(2)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_3 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(3),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(3)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_4 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(4),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(4)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_5 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(5),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(5)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_6 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(6),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(6)
    );
  BU2_U0_rx_axi_shim_rx_mac_tdata_7 : FDRE
    port map (
      C => rx_axi_clk,
      CE => BU2_U0_rx_axi_shim_rx_state_1_rx_enable_AND_13_o,
      D => BU2_U0_rx_axi_shim_rx_data_reg(7),
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_axis_mac_tdata_3(7)
    );
  BU2_U0_rx_axi_shim_rx_state_FSM_FFd2 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_In,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => BU2_U0_rx_axi_shim_rx_state_FSM_FFd2_361
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_REQ_reg : FDR
    port map (
      C => tx_axi_clk,
      D => pause_req,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_REQ_reg_359
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_0 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(0),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(0)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_1 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(1),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(1)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_2 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(2),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(2)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_3 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(3),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(3)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_4 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(4),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(4)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_5 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(5),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(5)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_6 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(6),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(6)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_7 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(7),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(7)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_8 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(8),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(8)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_9 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(9),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(9)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_10 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(10),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(10)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_11 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(11),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(11)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_12 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(12),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(12)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_13 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(13),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(13)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_14 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(14),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(14)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg_15 : FDR
    port map (
      C => tx_axi_clk,
      D => pause_val_7(15),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_PAUSE_VAL_reg(15)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd2 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_equal_13_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_pausereq_mux_slt_FSM_FFd2_342
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_0 : FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(0),
      R => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(0)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_1 : FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(1),
      R => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(1)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_2 : FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(2),
      R => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(2)
    );
  BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3 : FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr_3_PWR_16_o_LessThan_6_o,
      D => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_Result(3),
      R => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_TX_STATS_BYTEVLD_inv,
      Q => BU2_U0_PAUSESHIM_8_GEN_pausereq_shim_inst_tx_stats_bytevld_ctr(3)
    );
  BU2_U0_tx_axi_shim_tx_mac_tready_reg : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_ignore_packet_OR_45_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_axis_mac_tready
    );
  BU2_U0_tx_axi_shim_tx_data_hold_0 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(0),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(0)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_1 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(1),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(1)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_2 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(2),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(2)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_3 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(3),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(3)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_4 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(4),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(4)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_5 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(5),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(5)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_6 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(6),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(6)
    );
  BU2_U0_tx_axi_shim_tx_data_hold_7 : FDRE
    port map (
      C => tx_axi_clk,
      CE => NlwRenamedSig_OI_tx_axis_mac_tready,
      D => tx_axis_mac_tdata_5(7),
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data_hold(7)
    );
  BU2_U0_tx_axi_shim_tx_data_0 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_0_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(0)
    );
  BU2_U0_tx_axi_shim_tx_data_1 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_1_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(1)
    );
  BU2_U0_tx_axi_shim_tx_data_2 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_2_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(2)
    );
  BU2_U0_tx_axi_shim_tx_data_3 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_3_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(3)
    );
  BU2_U0_tx_axi_shim_tx_data_4 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_4_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(4)
    );
  BU2_U0_tx_axi_shim_tx_data_5 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_5_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(5)
    );
  BU2_U0_tx_axi_shim_tx_data_6 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_6_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(6)
    );
  BU2_U0_tx_axi_shim_tx_data_7 : FDRE
    port map (
      C => tx_axi_clk,
      CE => BU2_U0_tx_axi_shim_n0269_inv,
      D => BU2_U0_tx_axi_shim_tx_data_7_tx_mac_tdata_7_mux_64_OUT_7_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_data(7)
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd8 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_70_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd8_312
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd10 : FDS
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_tx_enable_reg_AND_33_o,
      S => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd10_310
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd9 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_28_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd9_308
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd7 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_In_305,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd7_306
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd6 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_In,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd6_304
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd3 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_In_301,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd3_302
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd5 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_71_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd5_300
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd4 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_PWR_18_o_equal_74_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd4_298
    );
  BU2_U0_tx_axi_shim_tx_state_FSM_FFd2 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_tx_axi_shim_next_tx_state_3_GND_18_o_equal_72_o,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => BU2_U0_tx_axi_shim_tx_state_FSM_FFd2_296
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_0 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_0_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(0)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_1 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_1_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(1)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_2 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_2_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(2)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_3 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_3_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(3)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_4 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_4_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(4)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_5 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_5_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => rx_statistics_vector_4(5)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_6 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_6_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(6)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_7 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_7_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(7)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_8 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_8_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(8)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_9 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_9_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(9)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_10 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_10_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(10)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_11 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_11_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(11)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_12 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_12_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(12)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_13 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_13_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(13)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_14 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_14_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(14)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_15 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_15_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(15)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_16 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_16_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(16)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_17 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_17_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(17)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_18 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_18_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(18)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_19 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_19_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(19)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_20 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_20_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(20)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_21 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_21_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(21)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_22 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_22_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(22)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_23 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_23_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(23)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_24 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_24_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(24)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_25 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_25_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(25)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_26 : FDR
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_26_Q,
      R => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(26)
    );
  BU2_U0_INT_RX_STATISTICS_VECTOR_27 : FDS
    port map (
      C => rx_axi_clk,
      D => BU2_U0_INT_RX_STATISTICS_VECTOR_27_RX_STATS_SHIFT_6_mux_6_OUT_27_Q,
      S => NlwRenamedSig_OI_rx_reset_out,
      Q => NlwRenamedSig_OI_rx_statistics_vector(27)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_0 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_0_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(0)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_1 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_1_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(1)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_2 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_2_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(2)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_3 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_3_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(3)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_4 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_4_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(4)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_5 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_5_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(5)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_6 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_6_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(6)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_7 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_7_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(7)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_8 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_8_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(8)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_9 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_9_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(9)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_10 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_10_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(10)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_11 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_11_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(11)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_12 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_12_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(12)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_13 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_13_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(13)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_14 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_14_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(14)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_15 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_15_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(15)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_16 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_16_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(16)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_17 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_17_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(17)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_18 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_18_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(18)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_19 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_19_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(19)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_20 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_20_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(20)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_21 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_21_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(21)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_22 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_22_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(22)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_23 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_23_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(23)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_24 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_24_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(24)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_25 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_25_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(25)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_26 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_26_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(26)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_27 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_27_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(27)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_28 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_28_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(28)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_29 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_29_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(29)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_30 : FDR
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_30_Q,
      R => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(30)
    );
  BU2_U0_INT_TX_STATISTICS_VECTOR_31 : FDS
    port map (
      C => tx_axi_clk,
      D => BU2_U0_INT_TX_STATISTICS_VECTOR_31_TX_STATS_SHIFT_mux_10_OUT_31_Q,
      S => NlwRenamedSig_OI_tx_reset_out,
      Q => NlwRenamedSig_OI_tx_statistics_vector(31)
    );
  BU2_U0_SYNC_TX_RESET_I_R2 : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => tx_axi_clk,
      D => BU2_U0_SYNC_TX_RESET_I_R1_233,
      PRE => BU2_U0_INT_TX_RST_ASYNCH,
      Q => BU2_U0_SYNC_TX_RESET_I_R2_234
    );
  BU2_U0_SYNC_TX_RESET_I_R1 : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => tx_axi_clk,
      D => BU2_N0,
      PRE => BU2_U0_INT_TX_RST_ASYNCH,
      Q => BU2_U0_SYNC_TX_RESET_I_R1_233
    );
  BU2_U0_SYNC_RX_RESET_I_R2 : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => rx_axi_clk,
      D => BU2_U0_SYNC_RX_RESET_I_R1_230,
      PRE => BU2_U0_INT_RX_RST_ASYNCH,
      Q => BU2_U0_SYNC_RX_RESET_I_R2_231
    );
  BU2_U0_SYNC_RX_RESET_I_R1 : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => rx_axi_clk,
      D => BU2_N0,
      PRE => BU2_U0_INT_RX_RST_ASYNCH,
      Q => BU2_U0_SYNC_RX_RESET_I_R1_230
    );
  BU2_U0_v6_emac : TEMAC_SINGLE
    generic map(
      EMAC_1000BASEX_ENABLE => FALSE,
      EMAC_ADDRFILTER_ENABLE => FALSE,
      EMAC_BYTEPHY => FALSE,
      EMAC_CTRLLENCHECK_DISABLE => FALSE,
      EMAC_DCRBASEADDR => X"00",
      EMAC_GTLOOPBACK => FALSE,
      EMAC_HOST_ENABLE => FALSE,
      EMAC_LINKTIMERVAL => X"030",
      EMAC_LTCHECK_DISABLE => FALSE,
      EMAC_MDIO_ENABLE => TRUE,
      EMAC_MDIO_IGNORE_PHYADZERO => FALSE,
      EMAC_PAUSEADDR => X"000000000000",
      EMAC_PHYINITAUTONEG_ENABLE => TRUE,
      EMAC_PHYISOLATE => FALSE,
      EMAC_PHYLOOPBACKMSB => FALSE,
      EMAC_PHYPOWERDOWN => FALSE,
      EMAC_PHYRESET => FALSE,
      EMAC_RGMII_ENABLE => FALSE,
      EMAC_RX16BITCLIENT_ENABLE => FALSE,
      EMAC_RXFLOWCTRL_ENABLE => FALSE,
      EMAC_RXHALFDUPLEX => FALSE,
      EMAC_RXINBANDFCS_ENABLE => FALSE,
      EMAC_RXJUMBOFRAME_ENABLE => FALSE,
      EMAC_RXRESET => FALSE,
      EMAC_RXVLAN_ENABLE => FALSE,
      EMAC_RX_ENABLE => TRUE,
      EMAC_SGMII_ENABLE => TRUE,
      EMAC_SPEED_LSB => FALSE,
      EMAC_SPEED_MSB => TRUE,
      EMAC_TX16BITCLIENT_ENABLE => FALSE,
      EMAC_TXFLOWCTRL_ENABLE => FALSE,
      EMAC_TXHALFDUPLEX => FALSE,
      EMAC_TXIFGADJUST_ENABLE => FALSE,
      EMAC_TXINBANDFCS_ENABLE => FALSE,
      EMAC_TXJUMBOFRAME_ENABLE => FALSE,
      EMAC_TXRESET => FALSE,
      EMAC_TXVLAN_ENABLE => FALSE,
      EMAC_TX_ENABLE => TRUE,
      EMAC_UNICASTADDR => X"000000000000",
      EMAC_UNIDIRECTION_ENABLE => FALSE,
      EMAC_USECLKEN => FALSE,
      SIM_VERSION => "1.0"
    )
    port map (
      EMACCLIENTTXCLIENTCLKOUT => tx_axi_clk_out,
      EMACPHYTXCHARDISPMODE => tx_char_disp_mode,
      HOSTMIIMRDY => NLW_BU2_U0_v6_emac_HOSTMIIMRDY_UNCONNECTED,
      EMACPHYSYNCACQSTATUS => sync_acq_status,
      EMACCLIENTTXSTATSBYTEVLD => BU2_U0_TX_STATS_BYTEVLD,
      DCRHOSTDONEIR => NLW_BU2_U0_v6_emac_DCRHOSTDONEIR_UNCONNECTED,
      PHYEMACGTXCLK => gtx_clk,
      EMACPHYMGTRXRESET => mgt_rx_reset,
      PHYEMACRXCLK => BU2_N0,
      DCREMACENABLE => BU2_N0,
      EMACSPEEDIS10100 => speed_is_10_100,
      PHYEMACTXGMIIMIICLKIN => BU2_N0,
      EMACCLIENTTXACK => BU2_U0_TX_ACK,
      EMACPHYTXCHARISK => tx_char_is_k,
      PHYEMACRXRUNDISP => rx_run_disp,
      PHYEMACMIITXCLK => BU2_N0,
      CLIENTEMACTXFIRSTBYTE => BU2_N0,
      EMACPHYTXGMIIMIICLKOUT => NLW_BU2_U0_v6_emac_EMACPHYTXGMIIMIICLKOUT_UNCONNECTED,
      HOSTMIIMSEL => BU2_N0,
      EMACCLIENTANINTERRUPT => an_interrupt,
      EMACPHYENCOMMAALIGN => en_comma_align,
      EMACPHYMDTRI => mdio_tri,
      EMACCLIENTRXDVLD => BU2_U0_RX_DATA_VALID,
      EMACPHYTXEN => BU2_gmii_tx_en,
      PHYEMACRXNOTINTABLE => rx_not_in_table,
      EMACCLIENTRXGOODFRAME => BU2_U0_RX_GOOD_FRAME,
      DCREMACCLK => BU2_N0,
      DCREMACWRITE => BU2_N0,
      CLIENTEMACDCMLOCKED => dcm_locked,
      PHYEMACRXDV => gmii_rx_dv,
      PHYEMACRXCHARISK => rx_char_is_k,
      PHYEMACTXBUFERR => tx_buf_err,
      EMACPHYMCLKOUT => BU2_mdc_out,
      CLIENTEMACPAUSEREQ => BU2_U0_PAUSE_REQ_INT,
      CLIENTEMACTXUNDERRUN => BU2_U0_tx_axi_shim_tx_underrun_183,
      EMACCLIENTRXFRAMEDROP => NLW_BU2_U0_v6_emac_EMACCLIENTRXFRAMEDROP_UNCONNECTED,
      EMACCLIENTRXDVLDMSW => NLW_BU2_U0_v6_emac_EMACCLIENTRXDVLDMSW_UNCONNECTED,
      EMACCLIENTRXCLIENTCLKOUT => NLW_BU2_U0_v6_emac_EMACCLIENTRXCLIENTCLKOUT_UNCONNECTED,
      CLIENTEMACTXCLIENTCLKIN => tx_axi_clk,
      PHYEMACCRS => N0,
      EMACCLIENTTXRETRANSMIT => NlwRenamedSig_OI_tx_retransmit,
      PHYEMACMCLKIN => mdc_in,
      CLIENTEMACTXDVLDMSW => BU2_N0,
      EMACCLIENTRXSTATSBYTEVLD => NLW_BU2_U0_v6_emac_EMACCLIENTRXSTATSBYTEVLD_UNCONNECTED,
      EMACPHYTXCHARDISPVAL => tx_char_disp_val,
      PHYEMACRXDISPERR => rx_disp_err,
      PHYEMACRXCHARISCOMMA => rx_char_is_comma,
      EMACPHYMDOUT => mdio_out,
      EMACPHYMGTTXRESET => mgt_tx_reset,
      PHYEMACCOL => N0,
      CLIENTEMACTXDVLD => BU2_U0_tx_axi_shim_tx_data_valid_184,
      EMACCLIENTTXSTATSVLD => BU2_U0_TX_STATS_SHIFT_VLD,
      PHYEMACMDIN => mdio_in,
      EMACCLIENTTXCOLLISION => tx_collision,
      PHYEMACSIGNALDET => signal_det,
      EMACCLIENTRXSTATSVLD => BU2_U0_RX_STATS_SHIFT_VLD,
      HOSTREQ => BU2_N0,
      EMACDCRACK => NLW_BU2_U0_v6_emac_EMACDCRACK_UNCONNECTED,
      HOSTCLK => N0,
      PHYEMACRXER => N0,
      EMACPHYTXCLK => NLW_BU2_U0_v6_emac_EMACPHYTXCLK_UNCONNECTED,
      EMACPHYTXER => BU2_gmii_tx_er,
      EMACPHYPOWERDOWN => powerdown,
      EMACPHYLOOPBACKMSB => loopback_msb,
      CLIENTEMACRXCLIENTCLKIN => tx_axi_clk,
      EMACCLIENTTXSTATS => BU2_U0_TX_STATS_SHIFT,
      RESET => BU2_U0_INT_GLBL_RST,
      DCREMACREAD => BU2_N0,
      EMACCLIENTRXBADFRAME => BU2_U0_RX_BAD_FRAME,
      CLIENTEMACTXD(15) => BU2_N0,
      CLIENTEMACTXD(14) => BU2_N0,
      CLIENTEMACTXD(13) => BU2_N0,
      CLIENTEMACTXD(12) => BU2_N0,
      CLIENTEMACTXD(11) => BU2_N0,
      CLIENTEMACTXD(10) => BU2_N0,
      CLIENTEMACTXD(9) => BU2_N0,
      CLIENTEMACTXD(8) => BU2_N0,
      CLIENTEMACTXD(7) => BU2_U0_tx_axi_shim_tx_data(7),
      CLIENTEMACTXD(6) => BU2_U0_tx_axi_shim_tx_data(6),
      CLIENTEMACTXD(5) => BU2_U0_tx_axi_shim_tx_data(5),
      CLIENTEMACTXD(4) => BU2_U0_tx_axi_shim_tx_data(4),
      CLIENTEMACTXD(3) => BU2_U0_tx_axi_shim_tx_data(3),
      CLIENTEMACTXD(2) => BU2_U0_tx_axi_shim_tx_data(2),
      CLIENTEMACTXD(1) => BU2_U0_tx_axi_shim_tx_data(1),
      CLIENTEMACTXD(0) => BU2_U0_tx_axi_shim_tx_data(0),
      HOSTWRDATA(31) => BU2_N0,
      HOSTWRDATA(30) => BU2_N0,
      HOSTWRDATA(29) => BU2_N0,
      HOSTWRDATA(28) => BU2_N0,
      HOSTWRDATA(27) => BU2_N0,
      HOSTWRDATA(26) => BU2_N0,
      HOSTWRDATA(25) => BU2_N0,
      HOSTWRDATA(24) => BU2_N0,
      HOSTWRDATA(23) => BU2_N0,
      HOSTWRDATA(22) => BU2_N0,
      HOSTWRDATA(21) => BU2_N0,
      HOSTWRDATA(20) => BU2_N0,
      HOSTWRDATA(19) => BU2_N0,
      HOSTWRDATA(18) => BU2_N0,
      HOSTWRDATA(17) => BU2_N0,
      HOSTWRDATA(16) => BU2_N0,
      HOSTWRDATA(15) => BU2_N0,
      HOSTWRDATA(14) => BU2_N0,
      HOSTWRDATA(13) => BU2_N0,
      HOSTWRDATA(12) => BU2_N0,
      HOSTWRDATA(11) => BU2_N0,
      HOSTWRDATA(10) => BU2_N0,
      HOSTWRDATA(9) => BU2_N0,
      HOSTWRDATA(8) => BU2_N0,
      HOSTWRDATA(7) => BU2_N0,
      HOSTWRDATA(6) => BU2_N0,
      HOSTWRDATA(5) => BU2_N0,
      HOSTWRDATA(4) => BU2_N0,
      HOSTWRDATA(3) => BU2_N0,
      HOSTWRDATA(2) => BU2_N0,
      HOSTWRDATA(1) => BU2_N0,
      HOSTWRDATA(0) => BU2_N0,
      EMACCLIENTRXD(15) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_15_UNCONNECTED,
      EMACCLIENTRXD(14) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_14_UNCONNECTED,
      EMACCLIENTRXD(13) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_13_UNCONNECTED,
      EMACCLIENTRXD(12) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_12_UNCONNECTED,
      EMACCLIENTRXD(11) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_11_UNCONNECTED,
      EMACCLIENTRXD(10) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_10_UNCONNECTED,
      EMACCLIENTRXD(9) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_9_UNCONNECTED,
      EMACCLIENTRXD(8) => NLW_BU2_U0_v6_emac_EMACCLIENTRXD_8_UNCONNECTED,
      EMACCLIENTRXD(7) => BU2_U0_RX_DATA(7),
      EMACCLIENTRXD(6) => BU2_U0_RX_DATA(6),
      EMACCLIENTRXD(5) => BU2_U0_RX_DATA(5),
      EMACCLIENTRXD(4) => BU2_U0_RX_DATA(4),
      EMACCLIENTRXD(3) => BU2_U0_RX_DATA(3),
      EMACCLIENTRXD(2) => BU2_U0_RX_DATA(2),
      EMACCLIENTRXD(1) => BU2_U0_RX_DATA(1),
      EMACCLIENTRXD(0) => BU2_U0_RX_DATA(0),
      EMACPHYTXD(7) => gmii_txd_2(7),
      EMACPHYTXD(6) => gmii_txd_2(6),
      EMACPHYTXD(5) => gmii_txd_2(5),
      EMACPHYTXD(4) => gmii_txd_2(4),
      EMACPHYTXD(3) => gmii_txd_2(3),
      EMACPHYTXD(2) => gmii_txd_2(2),
      EMACPHYTXD(1) => gmii_txd_2(1),
      EMACPHYTXD(0) => gmii_txd_2(0),
      PHYEMACRXD(7) => gmii_rxd_8(7),
      PHYEMACRXD(6) => gmii_rxd_8(6),
      PHYEMACRXD(5) => gmii_rxd_8(5),
      PHYEMACRXD(4) => gmii_rxd_8(4),
      PHYEMACRXD(3) => gmii_rxd_8(3),
      PHYEMACRXD(2) => gmii_rxd_8(2),
      PHYEMACRXD(1) => gmii_rxd_8(1),
      PHYEMACRXD(0) => gmii_rxd_8(0),
      PHYEMACRXCLKCORCNT(2) => rx_clk_cor_cnt_10(2),
      PHYEMACRXCLKCORCNT(1) => rx_clk_cor_cnt_10(1),
      PHYEMACRXCLKCORCNT(0) => rx_clk_cor_cnt_10(0),
      CLIENTEMACPAUSEVAL(15) => BU2_U0_PAUSE_VAL_INT(15),
      CLIENTEMACPAUSEVAL(14) => BU2_U0_PAUSE_VAL_INT(14),
      CLIENTEMACPAUSEVAL(13) => BU2_U0_PAUSE_VAL_INT(13),
      CLIENTEMACPAUSEVAL(12) => BU2_U0_PAUSE_VAL_INT(12),
      CLIENTEMACPAUSEVAL(11) => BU2_U0_PAUSE_VAL_INT(11),
      CLIENTEMACPAUSEVAL(10) => BU2_U0_PAUSE_VAL_INT(10),
      CLIENTEMACPAUSEVAL(9) => BU2_U0_PAUSE_VAL_INT(9),
      CLIENTEMACPAUSEVAL(8) => BU2_U0_PAUSE_VAL_INT(8),
      CLIENTEMACPAUSEVAL(7) => BU2_U0_PAUSE_VAL_INT(7),
      CLIENTEMACPAUSEVAL(6) => BU2_U0_PAUSE_VAL_INT(6),
      CLIENTEMACPAUSEVAL(5) => BU2_U0_PAUSE_VAL_INT(5),
      CLIENTEMACPAUSEVAL(4) => BU2_U0_PAUSE_VAL_INT(4),
      CLIENTEMACPAUSEVAL(3) => BU2_U0_PAUSE_VAL_INT(3),
      CLIENTEMACPAUSEVAL(2) => BU2_U0_PAUSE_VAL_INT(2),
      CLIENTEMACPAUSEVAL(1) => BU2_U0_PAUSE_VAL_INT(1),
      CLIENTEMACPAUSEVAL(0) => BU2_U0_PAUSE_VAL_INT(0),
      EMACDCRDBUS(0) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_0_UNCONNECTED,
      EMACDCRDBUS(1) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_1_UNCONNECTED,
      EMACDCRDBUS(2) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_2_UNCONNECTED,
      EMACDCRDBUS(3) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_3_UNCONNECTED,
      EMACDCRDBUS(4) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_4_UNCONNECTED,
      EMACDCRDBUS(5) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_5_UNCONNECTED,
      EMACDCRDBUS(6) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_6_UNCONNECTED,
      EMACDCRDBUS(7) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_7_UNCONNECTED,
      EMACDCRDBUS(8) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_8_UNCONNECTED,
      EMACDCRDBUS(9) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_9_UNCONNECTED,
      EMACDCRDBUS(10) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_10_UNCONNECTED,
      EMACDCRDBUS(11) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_11_UNCONNECTED,
      EMACDCRDBUS(12) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_12_UNCONNECTED,
      EMACDCRDBUS(13) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_13_UNCONNECTED,
      EMACDCRDBUS(14) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_14_UNCONNECTED,
      EMACDCRDBUS(15) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_15_UNCONNECTED,
      EMACDCRDBUS(16) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_16_UNCONNECTED,
      EMACDCRDBUS(17) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_17_UNCONNECTED,
      EMACDCRDBUS(18) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_18_UNCONNECTED,
      EMACDCRDBUS(19) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_19_UNCONNECTED,
      EMACDCRDBUS(20) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_20_UNCONNECTED,
      EMACDCRDBUS(21) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_21_UNCONNECTED,
      EMACDCRDBUS(22) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_22_UNCONNECTED,
      EMACDCRDBUS(23) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_23_UNCONNECTED,
      EMACDCRDBUS(24) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_24_UNCONNECTED,
      EMACDCRDBUS(25) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_25_UNCONNECTED,
      EMACDCRDBUS(26) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_26_UNCONNECTED,
      EMACDCRDBUS(27) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_27_UNCONNECTED,
      EMACDCRDBUS(28) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_28_UNCONNECTED,
      EMACDCRDBUS(29) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_29_UNCONNECTED,
      EMACDCRDBUS(30) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_30_UNCONNECTED,
      EMACDCRDBUS(31) => NLW_BU2_U0_v6_emac_EMACDCRDBUS_31_UNCONNECTED,
      HOSTADDR(9) => BU2_N0,
      HOSTADDR(8) => BU2_N0,
      HOSTADDR(7) => BU2_N0,
      HOSTADDR(6) => BU2_N0,
      HOSTADDR(5) => BU2_N0,
      HOSTADDR(4) => BU2_N0,
      HOSTADDR(3) => BU2_N0,
      HOSTADDR(2) => BU2_N0,
      HOSTADDR(1) => BU2_N0,
      HOSTADDR(0) => BU2_N0,
      DCREMACDBUS(0) => BU2_N0,
      DCREMACDBUS(1) => BU2_N0,
      DCREMACDBUS(2) => BU2_N0,
      DCREMACDBUS(3) => BU2_N0,
      DCREMACDBUS(4) => BU2_N0,
      DCREMACDBUS(5) => BU2_N0,
      DCREMACDBUS(6) => BU2_N0,
      DCREMACDBUS(7) => BU2_N0,
      DCREMACDBUS(8) => BU2_N0,
      DCREMACDBUS(9) => BU2_N0,
      DCREMACDBUS(10) => BU2_N0,
      DCREMACDBUS(11) => BU2_N0,
      DCREMACDBUS(12) => BU2_N0,
      DCREMACDBUS(13) => BU2_N0,
      DCREMACDBUS(14) => BU2_N0,
      DCREMACDBUS(15) => BU2_N0,
      DCREMACDBUS(16) => BU2_N0,
      DCREMACDBUS(17) => BU2_N0,
      DCREMACDBUS(18) => BU2_N0,
      DCREMACDBUS(19) => BU2_N0,
      DCREMACDBUS(20) => BU2_N0,
      DCREMACDBUS(21) => BU2_N0,
      DCREMACDBUS(22) => BU2_N0,
      DCREMACDBUS(23) => BU2_N0,
      DCREMACDBUS(24) => BU2_N0,
      DCREMACDBUS(25) => BU2_N0,
      DCREMACDBUS(26) => BU2_N0,
      DCREMACDBUS(27) => BU2_N0,
      DCREMACDBUS(28) => BU2_N0,
      DCREMACDBUS(29) => BU2_N0,
      DCREMACDBUS(30) => BU2_N0,
      DCREMACDBUS(31) => BU2_N0,
      EMACCLIENTRXSTATS(6) => BU2_U0_RX_STATS_SHIFT(6),
      EMACCLIENTRXSTATS(5) => BU2_U0_RX_STATS_SHIFT(5),
      EMACCLIENTRXSTATS(4) => BU2_U0_RX_STATS_SHIFT(4),
      EMACCLIENTRXSTATS(3) => BU2_U0_RX_STATS_SHIFT(3),
      EMACCLIENTRXSTATS(2) => BU2_U0_RX_STATS_SHIFT(2),
      EMACCLIENTRXSTATS(1) => BU2_U0_RX_STATS_SHIFT(1),
      EMACCLIENTRXSTATS(0) => BU2_U0_RX_STATS_SHIFT(0),
      DCREMACABUS(0) => BU2_N0,
      DCREMACABUS(1) => BU2_N0,
      DCREMACABUS(2) => BU2_N0,
      DCREMACABUS(3) => BU2_N0,
      DCREMACABUS(4) => BU2_N0,
      DCREMACABUS(5) => BU2_N0,
      DCREMACABUS(6) => BU2_N0,
      DCREMACABUS(7) => BU2_N0,
      DCREMACABUS(8) => BU2_N0,
      DCREMACABUS(9) => BU2_N0,
      HOSTOPCODE(1) => BU2_N0,
      HOSTOPCODE(0) => BU2_N0,
      CLIENTEMACTXIFGDELAY(7) => tx_ifg_delay_6(7),
      CLIENTEMACTXIFGDELAY(6) => tx_ifg_delay_6(6),
      CLIENTEMACTXIFGDELAY(5) => tx_ifg_delay_6(5),
      CLIENTEMACTXIFGDELAY(4) => tx_ifg_delay_6(4),
      CLIENTEMACTXIFGDELAY(3) => tx_ifg_delay_6(3),
      CLIENTEMACTXIFGDELAY(2) => tx_ifg_delay_6(2),
      CLIENTEMACTXIFGDELAY(1) => tx_ifg_delay_6(1),
      CLIENTEMACTXIFGDELAY(0) => tx_ifg_delay_6(0),
      PHYEMACPHYAD(4) => phy_ad_9(4),
      PHYEMACPHYAD(3) => phy_ad_9(3),
      PHYEMACPHYAD(2) => phy_ad_9(2),
      PHYEMACPHYAD(1) => phy_ad_9(1),
      PHYEMACPHYAD(0) => phy_ad_9(0),
      PHYEMACRXBUFSTATUS(1) => rx_buf_status,
      PHYEMACRXBUFSTATUS(0) => BU2_N0,
      HOSTRDDATA(31) => NLW_BU2_U0_v6_emac_HOSTRDDATA_31_UNCONNECTED,
      HOSTRDDATA(30) => NLW_BU2_U0_v6_emac_HOSTRDDATA_30_UNCONNECTED,
      HOSTRDDATA(29) => NLW_BU2_U0_v6_emac_HOSTRDDATA_29_UNCONNECTED,
      HOSTRDDATA(28) => NLW_BU2_U0_v6_emac_HOSTRDDATA_28_UNCONNECTED,
      HOSTRDDATA(27) => NLW_BU2_U0_v6_emac_HOSTRDDATA_27_UNCONNECTED,
      HOSTRDDATA(26) => NLW_BU2_U0_v6_emac_HOSTRDDATA_26_UNCONNECTED,
      HOSTRDDATA(25) => NLW_BU2_U0_v6_emac_HOSTRDDATA_25_UNCONNECTED,
      HOSTRDDATA(24) => NLW_BU2_U0_v6_emac_HOSTRDDATA_24_UNCONNECTED,
      HOSTRDDATA(23) => NLW_BU2_U0_v6_emac_HOSTRDDATA_23_UNCONNECTED,
      HOSTRDDATA(22) => NLW_BU2_U0_v6_emac_HOSTRDDATA_22_UNCONNECTED,
      HOSTRDDATA(21) => NLW_BU2_U0_v6_emac_HOSTRDDATA_21_UNCONNECTED,
      HOSTRDDATA(20) => NLW_BU2_U0_v6_emac_HOSTRDDATA_20_UNCONNECTED,
      HOSTRDDATA(19) => NLW_BU2_U0_v6_emac_HOSTRDDATA_19_UNCONNECTED,
      HOSTRDDATA(18) => NLW_BU2_U0_v6_emac_HOSTRDDATA_18_UNCONNECTED,
      HOSTRDDATA(17) => NLW_BU2_U0_v6_emac_HOSTRDDATA_17_UNCONNECTED,
      HOSTRDDATA(16) => NLW_BU2_U0_v6_emac_HOSTRDDATA_16_UNCONNECTED,
      HOSTRDDATA(15) => NLW_BU2_U0_v6_emac_HOSTRDDATA_15_UNCONNECTED,
      HOSTRDDATA(14) => NLW_BU2_U0_v6_emac_HOSTRDDATA_14_UNCONNECTED,
      HOSTRDDATA(13) => NLW_BU2_U0_v6_emac_HOSTRDDATA_13_UNCONNECTED,
      HOSTRDDATA(12) => NLW_BU2_U0_v6_emac_HOSTRDDATA_12_UNCONNECTED,
      HOSTRDDATA(11) => NLW_BU2_U0_v6_emac_HOSTRDDATA_11_UNCONNECTED,
      HOSTRDDATA(10) => NLW_BU2_U0_v6_emac_HOSTRDDATA_10_UNCONNECTED,
      HOSTRDDATA(9) => NLW_BU2_U0_v6_emac_HOSTRDDATA_9_UNCONNECTED,
      HOSTRDDATA(8) => NLW_BU2_U0_v6_emac_HOSTRDDATA_8_UNCONNECTED,
      HOSTRDDATA(7) => NLW_BU2_U0_v6_emac_HOSTRDDATA_7_UNCONNECTED,
      HOSTRDDATA(6) => NLW_BU2_U0_v6_emac_HOSTRDDATA_6_UNCONNECTED,
      HOSTRDDATA(5) => NLW_BU2_U0_v6_emac_HOSTRDDATA_5_UNCONNECTED,
      HOSTRDDATA(4) => NLW_BU2_U0_v6_emac_HOSTRDDATA_4_UNCONNECTED,
      HOSTRDDATA(3) => NLW_BU2_U0_v6_emac_HOSTRDDATA_3_UNCONNECTED,
      HOSTRDDATA(2) => NLW_BU2_U0_v6_emac_HOSTRDDATA_2_UNCONNECTED,
      HOSTRDDATA(1) => NLW_BU2_U0_v6_emac_HOSTRDDATA_1_UNCONNECTED,
      HOSTRDDATA(0) => NLW_BU2_U0_v6_emac_HOSTRDDATA_0_UNCONNECTED
    );
  BU2_XST_GND : GND
    port map (
      G => BU2_N0
    );

end STRUCTURE;

-- synthesis translate_on
