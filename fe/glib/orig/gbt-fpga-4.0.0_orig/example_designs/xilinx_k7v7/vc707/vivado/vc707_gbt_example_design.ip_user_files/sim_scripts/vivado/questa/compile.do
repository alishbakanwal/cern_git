vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/ila_v6_0_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/ltlib_v1_0_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/xsdbm_v1_1_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/xsdbs_v1_0_2/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/ila_v6_0_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/ltlib_v1_0_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/xsdbm_v1_1_0/hdl/verilog" +incdir+"./../../../../../../core_sources/chipscope_ila/vivado/xsdbs_v1_0_2/hdl/verilog" \
"./../../../../../../core_sources/chipscope_ila/vivado/sim/xlx_k7v7_vivado_debug.v" \


vlog -work xil_defaultlib "glbl.v"

quit -f

