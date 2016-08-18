view structure
view signals
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -format Logic /testbench/mgtclk_p
add wave -noupdate -format Logic /testbench/mgtclk_n
add wave -noupdate -format Logic /testbench/dut/gtx_clk_bufg
add wave -noupdate -divider {Tx MAC Interface}
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_tx_axis_mac_tvalid }
add wave -noupdate -format Literal {/testbench/dut/v6emac_fifo_block_tx_axis_mac_tdata }
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_tx_axis_mac_tready }
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_tx_axis_mac_tlast }
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_tx_axis_mac_tuser }
add wave -noupdate -divider {Rx MAC Interface}
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_rx_axis_mac_tvalid }
add wave -noupdate -format Literal {/testbench/dut/v6emac_fifo_block_rx_axis_mac_tdata }
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_rx_axis_mac_tlast }
add wave -noupdate -format Logic {/testbench/dut/v6emac_fifo_block_rx_axis_mac_tuser }
add wave -noupdate -divider {GTX Interface}
add wave -noupdate -format Logic /testbench/txp
add wave -noupdate -format Logic /testbench/txn
add wave -noupdate -format Logic /testbench/rxp
add wave -noupdate -format Logic /testbench/rxn
add wave -noupdate -divider {MDIO Interface}
add wave -noupdate -format Logic /testbench/mdc_in
add wave -noupdate -format Logic /testbench/mdio
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
