# file: simcmds.tcl

# create the simulation script
vcd dumpfile isim.vcd
vcd dumpvars -m /cdce_out4_mmcm_40M_tb -l 0
wave add /
run 50000ns
quit
