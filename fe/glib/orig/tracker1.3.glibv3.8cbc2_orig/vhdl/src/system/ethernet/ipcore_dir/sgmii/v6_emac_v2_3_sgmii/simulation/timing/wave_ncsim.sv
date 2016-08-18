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
    :dut.v6emac_fifo_block_tx_axis_mac_tvalid \
    :dut.v6emac_fifo_block_tx_axis_mac_tdata \
    :dut.v6emac_fifo_block_tx_axis_mac_tready \
    :dut.v6emac_fifo_block_tx_axis_mac_tlast \
    :dut.v6emac_fifo_block_tx_axis_mac_tuser

if {[catch {group new -name {RX MAC Interface} -overlay 0}] != ""} {
    group using {RX MAC Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :dut.v6emac_fifo_block_rx_axis_mac_tvalid \
    :dut.v6emac_fifo_block_rx_axis_mac_tdata \
    :dut.v6emac_fifo_block_rx_axis_mac_tlast \
    :dut.v6emac_fifo_block_rx_axis_mac_tuser


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


if {[catch {group new -name {MDIO Interface} -overlay 0}] != ""} {
    group using {MDIO Interface}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    :mdc_in \
    :mdio


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

set groupId [waveform add -groups {{System Signals}}]
set groupId [waveform add -groups {{TX MAC Interface}}]
set groupId [waveform add -groups {{RX MAC Interface}}]

set groupId [waveform add -groups {{GTX Interface}}]
set groupId [waveform add -groups {{MDIO Interface}}]

waveform xview limits 0fs 10us

simcontrol run -time 2000us

