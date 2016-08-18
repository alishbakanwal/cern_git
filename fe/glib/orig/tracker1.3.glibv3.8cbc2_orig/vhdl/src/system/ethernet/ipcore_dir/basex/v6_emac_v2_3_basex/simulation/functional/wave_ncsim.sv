# SimVision Command Script

#
# groups
#

if {[catch {group new -name {System Signals} -overlay 0}] != ""} {
    group using {System Signals}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :reset \
    :mgtclk_p \
    :mgtclk_n \
    :dut.gtx_clk_bufg \
    :gtx_clk

if {[catch {group new -name {TX MAC Interface} -overlay 0}] != ""} {
    group using {TX MAC Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.v6emac_fifo_block.tx_mac_resetn \
    :dut.v6emac_fifo_block.tx_axis_mac_tvalid \
    :dut.v6emac_fifo_block.tx_axis_mac_tdata \
    :dut.v6emac_fifo_block.tx_axis_mac_tready \
    :dut.v6emac_fifo_block.tx_axis_mac_tlast \
    :dut.v6emac_fifo_block.tx_axis_mac_tuser

if {[catch {group new -name {TX Statistics} -overlay 0}] != ""} {
    group using {TX Statistics}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.tx_statistics_vector \
    :dut.tx_statistics_valid

if {[catch {group new -name {RX MAC Interface} -overlay 0}] != ""} {
    group using {RX MAC Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.v6emac_fifo_block.rx_mac_resetn \
    :dut.v6emac_fifo_block.rx_axis_mac_tvalid \
    :dut.v6emac_fifo_block.rx_axis_mac_tdata \
    :dut.v6emac_fifo_block.rx_axis_mac_tlast \
    :dut.v6emac_fifo_block.rx_axis_mac_tuser

if {[catch {group new -name {RX Statistics} -overlay 0}] != ""} {
    group using {RX Statistics}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.rx_statistics_vector \
    :dut.rx_statistics_valid


if {[catch {group new -name {Flow Control} -overlay 0}] != ""} {
    group using {Flow Control}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.pause_val \
    :dut.pause_req

if {[catch {group new -name {Rx FIFO Interface} -overlay 0}] != ""} {
    group using {Rx FIFO Interface}

    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.v6emac_fifo_block.rx_fifo_clock \
    :dut.v6emac_fifo_block.rx_fifo_resetn \
    :dut.v6emac_fifo_block.rx_axis_fifo_tdata \
    :dut.v6emac_fifo_block.rx_axis_fifo_tlast \
    :dut.v6emac_fifo_block.rx_axis_fifo_tready \
    :dut.v6emac_fifo_block.rx_axis_fifo_tvalid

if {[catch {group new -name {Tx FIFO Interface} -overlay 0}] != ""} {
    group using {Tx FIFO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.v6emac_fifo_block.tx_fifo_clock \
    :dut.v6emac_fifo_block.tx_fifo_resetn \
    :dut.v6emac_fifo_block.tx_axis_fifo_tdata \
    :dut.v6emac_fifo_block.tx_axis_fifo_tlast \
    :dut.v6emac_fifo_block.tx_axis_fifo_tready \
    :dut.v6emac_fifo_block.tx_axis_fifo_tvalid


if {[catch {group new -name {GTX Interface} -overlay 0}] != ""} {
    group using {GTX Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :txp \
    :txn \
    :rxp \
    :rxn



#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 906x585+25+55
} else {
    window geometry "Waveform 1" 906x585+25+55
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units fs \
    -valuewidth 75
cursor set -using TimeA -time 50,000,000,000fs
cursor set -using TimeA -marching 1
waveform baseline set -time 0

set id [waveform add -signals [list :reset \
        :gtx_clk ]]

set groupId [waveform add -groups {{System Signals}}]
set groupId [waveform add -groups {{TX MAC Interface}}]
set groupId [waveform add -groups {{TX Statistics Vector}}]
set groupId [waveform add -groups {{RX MAC Interface}}]
set groupId [waveform add -groups {{RX Statistics Vector}}]
set groupId [waveform add -groups {{Flow Control}}]

set groupId [waveform add -groups {{GTX Interface}}]
set groupId [waveform add -groups {{Configuration Interface}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us

