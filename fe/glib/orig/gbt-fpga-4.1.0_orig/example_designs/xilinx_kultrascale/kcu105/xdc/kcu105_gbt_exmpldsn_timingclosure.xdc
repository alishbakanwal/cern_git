##===================================================================================================##
##========================= Xilinx design constraints (XDC) information =============================##
##===================================================================================================##
##
## Company:               WUT (ISE PERG)
## Engineer:              Adrian Byszuk (a.byszuk@elka.pw.edu.pl)
##
## Project Name:          GBT-FPGA
## XDC File Name:         KC705 - GBT Bank example design timing closure
##
## Target Device:         KC705 (Xilinx Kintex 7)
## Tool version:          Vivado 2014.4
##
## Version:               4.0
##
## Description:
##
## Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
##
##                        17/12/2014   1.0       Julian Mendez       First .xdc definition
##
## Additional Comments:
##
##===================================================================================================##
##===================================================================================================##

##===================================================================================================##
##====================================  TIMING CLOSURE  =============================================##
##===================================================================================================##

##=================================================##
## Latency-Optimized (LATOPT) specific constraints ##
##=================================================##


##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##                                                                           ##
## Comment: Note!! Uncomment out the following constraints when implementing ##
##                 the Latency-Optimized (LATOPT) version.                   ##
##                                                                           ##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##

## GBT TX:
##--------

## RX Phase Aligner
##----------------- 
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] 16.000

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
set_max_delay -datapath_only -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] 20.000

# False path constraints (From MGT IP)
# ----------------------------------------------------------------------------------------------------------------------
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]

##=============##
## RX Frameclk ##
##=============##

## Latency-optimized with gbt_rx_frameclk_phalgnr module based on PLL. Commented otherwize.

# The relation between both clock is set asynchronous to solve timing issue on the RX Alignment checker.

# The phaligner_phase_computing module deserialize the PLL output (RX Frameclk) using the wordclk (120 MHz)
# Due to an odd division, we have metastability during the deserialization which is already took into account
# in the compiraison state machine. Therefore, both clocks are specified a

set_clock_groups -asynchronous -group {clk_out1_xlx_ku_gbt_rx_frameclk_phaligner_mmcm} -group {rxoutclk_sig}

##===================================================================================================##
##===================================================================================================##
