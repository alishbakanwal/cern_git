vlib work
vmap work work
vcom -work work ../../../v6_emac_v2_3_sgmii.vhd
vcom -work work ../../example_design/common/reset_sync.vhd \
../../example_design/common/sync_block.vhd \
../../example_design/physical/v6_gtxwizard_top.vhd \
../../example_design/physical/double_reset.vhd \
../../example_design/physical/v6_gtxwizard.vhd \
../../example_design/physical/v6_gtxwizard_gtx.vhd \
../../example_design/fifo/tx_client_fifo_8.vhd \
../../example_design/fifo/rx_client_fifo_8.vhd \
../../example_design/fifo/ten_100_1g_eth_fifo.vhd \
../../example_design/pat_gen/address_swap.vhd \
../../example_design/pat_gen/axi_mux.vhd \
../../example_design/pat_gen/axi_pat_gen.vhd \
../../example_design/pat_gen/axi_pat_check.vhd \
../../example_design/pat_gen/axi_pipe.vhd \
../../example_design/pat_gen/basic_pat_gen.vhd
vcom -work work \
../../example_design/v6_emac_v2_3_sgmii_block.vhd \
../../example_design/v6_emac_v2_3_sgmii_fifo_block.vhd \
../../example_design/v6_emac_v2_3_sgmii_example_design.vhd

vcom -work work ../mdio_tb.vhd \
../phy_tb.vhd \
../demo_tb.vhd

vsim -voptargs="+acc" -t ps work.testbench
do wave_mti.do
run -all
