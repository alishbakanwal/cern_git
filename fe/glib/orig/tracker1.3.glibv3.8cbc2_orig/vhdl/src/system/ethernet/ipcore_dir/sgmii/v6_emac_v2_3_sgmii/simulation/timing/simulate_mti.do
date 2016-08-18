vlib work
vmap work work
vcom -work work ../../implement/results/routed.vhd
vcom -work work ../mdio_tb.vhd
vcom -work work ../phy_tb.vhd
vcom -work work ../demo_tb.vhd
vsim -voptargs="+acc" -t ps +no_tchk_msg -sdfmax /dut=../../implement/results/routed.sdf work.testbench
do wave_mti.do
run -all
