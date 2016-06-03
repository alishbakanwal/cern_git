#!/bin/sh

vsim -c -do $REPOS_FW_DIR/ipbus/firmware/sim/scripts/setup_project.tcl
cp -r $REPOS_FW_DIR/ipbus/firmware/ethernet/sim/modelsim_fli ./
cd modelsim_fli
. mac_fli_compile.sh
cd ..
ln -s modelsim_fli/mac_fli.so

