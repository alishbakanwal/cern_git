onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib xlx_k7v7_tx_pll_opt

do {wave.do}

view wave
view structure
view signals

do {xlx_k7v7_tx_pll.udo}

run -all

quit -force
