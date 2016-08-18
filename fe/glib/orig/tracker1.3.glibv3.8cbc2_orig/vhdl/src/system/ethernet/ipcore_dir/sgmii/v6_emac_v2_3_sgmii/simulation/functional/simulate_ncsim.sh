#!/bin/sh
mkdir work
ncvhdl -v93 -work work ../../../v6_emac_v2_3_sgmii.vhd
ncvhdl -v93 -work work ../../example_design/common/reset_sync.vhd
ncvhdl -v93 -work work ../../example_design/common/sync_block.vhd
ncvhdl -v93 -work work ../../example_design/fifo/tx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/fifo/rx_client_fifo_8.vhd
ncvhdl -v93 -work work ../../example_design/fifo/ten_100_1g_eth_fifo.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/address_swap.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/axi_mux.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/axi_pat_gen.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/axi_pat_check.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/axi_pipe.vhd
ncvhdl -v93 -work work ../../example_design/pat_gen/basic_pat_gen.vhd
ncvhdl -v93 -work work ../../example_design/physical/v6_gtxwizard_top.vhd
ncvhdl -v93 -work work ../../example_design/physical/double_reset.vhd
ncvhdl -v93 -work work ../../example_design/physical/v6_gtxwizard.vhd
ncvhdl -v93 -work work ../../example_design/physical/v6_gtxwizard_gtx.vhd
ncvhdl -v93 -work work ../../example_design/v6_emac_v2_3_sgmii_block.vhd
ncvhdl -v93 -work work ../../example_design/v6_emac_v2_3_sgmii_fifo_block.vhd
ncvhdl -v93 -work work ../../example_design/v6_emac_v2_3_sgmii_example_design.vhd

ncvhdl -v93 -work work ../mdio_tb.vhd
ncvhdl -v93 -work work ../phy_tb.vhd
ncvhdl -v93 -work work ../demo_tb.vhd

ncelab -vhdl_time_precision 1ps -lib_binding -access +rw work.testbench:behavioral
ncsim -gui work.testbench:behavioral -input @"simvision -input wave_ncsim.sv"
