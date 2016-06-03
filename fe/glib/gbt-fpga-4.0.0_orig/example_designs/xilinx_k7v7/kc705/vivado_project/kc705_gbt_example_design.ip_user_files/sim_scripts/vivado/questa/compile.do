vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"./../../../../../../core_sources/tx_pll/vivado/xlx_k7v7_tx_pll_clk_wiz.v" \
"./../../../../../../core_sources/tx_pll/vivado/xlx_k7v7_tx_pll.v" \


vlog -work xil_defaultlib "glbl.v"

quit -f

