#!/bin/sh
mkdir work

ncvhdl -v93 -work work ../../implement/results/routed.vhd
ncvhdl -v93 -work work ../mdio_tb.vhd
ncvhdl -v93 -work work ../phy_tb.vhd
ncvhdl -v93 -work work ../demo_tb.vhd

echo "Compiling SDF file"
ncsdfc ../../implement/results/routed.sdf -output ./routed.sdf.X

echo "Generating SDF command file"
echo 'COMPILED_SDF_FILE = "routed.sdf.X",' > sdf.cmd
echo 'SCOPE = behavioral.dut,' >> sdf.cmd
echo 'MTM_CONTROL = "MAXIMUM";' >> sdf.cmd

echo "Elaborating design"
ncelab -vhdl_time_precision 1ps -no_tchk_msg -lib_binding -access +rw -sdf_cmd_file sdf.cmd work.testbench:behavioral

ncsim -gui work.testbench:behavioral -input @"simvision -input wave_ncsim.sv"
