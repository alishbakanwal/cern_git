vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"./../../../../../../core_sources/gbt_rx_frameclk_phalgnr/vivado/xlx_k7v7_gbt_rx_frameclk_phalgnr_mmcm_clk_wiz.v" \
"./../../../../../../core_sources/gbt_rx_frameclk_phalgnr/vivado/xlx_k7v7_gbt_rx_frameclk_phalgnr_mmcm.v" \


vlog -work xil_defaultlib "glbl.v"

quit -f

