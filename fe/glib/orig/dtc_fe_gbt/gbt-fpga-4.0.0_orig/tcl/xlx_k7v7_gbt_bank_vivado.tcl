##=================================================================================================##
####################################   Srcipt Information   #########################################
##=================================================================================================##
##                                                                                         
## Company:               CERN (PH-ESE-BE)                                                         
## Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
##                                                                                                 
## Project Name:          GBT-FPGA                                                                
## Script Name:           Xilinx Kintex7 & Virtex 7 - GBT Bank                                        
##                                                                                                 
## Language:              TCL (Xilinx version)                                                              
##                                                                                                   
## Target Device:         Xilinx Kintex7 & Virtex 7                                                 
##                                                                                                   
## Version:               3.2                                                                      
##
## Description:            
##
## Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
##
##                        11/04/2014   3.0       M. Barros Marin   First .tcl script definition
##
##                        12/09/2014   3.2       M. Barros Marin   Minor modifications
##
## Additional Comments:   TCL script for adding the source files of the Xilinx Kintex 7 &  Virtex 7
##                        GBT Bank to ISE
##
##=================================================================================================##
#####################################################################################################
##=================================================================================================##


#####################################################################################################
############################# Absolute Data Path Set By The User ####################################
#####################################################################################################

## Comment: The user has to provide the absolute data path to the root folder of the GBT-FPGA Core
##          source files.

set SOURCE_PATH D:/svn/trunk

#####################################################################################################
#####################################################################################################


#####################################################################################################
#################### Commands for Adding the Source Files of the GBT-FPGA Core ######################
#####################################################################################################
      
## Comment: Adding Common files: 

puts "->"
puts "-> Adding common files of the GBT-FPGA Core to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_16bit.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std_rdctrl.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd

add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_latopt.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_16bit.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd

add_files $SOURCE_PATH/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd

add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_bank.vhd
add_files $SOURCE_PATH/gbt_bank/core_sources/gbt_bank_package.vhd

## Comment: Adding Xilinx Kintex 7 & Virtex 7 specific files:

puts "-> Adding Xilinx Kintex 7 & Virtex 7 specific files of the GBT-FPGA Core to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_rx/xlx_k7v7_gbt_rx_gearbox_std_dpram.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_tx/xlx_k7v7_gbt_tx_gearbox_std_dpram.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_std.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_std.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_auto_phase_align.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_latopt.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_rx_manual_phase_align.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_rx_startup_fsm.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_sync_block.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_sync_pulse.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_tx_manual_phase_align.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_tx_startup_fsm.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_latopt.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_bank_package.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_banks_user_setup.vhd
import_ip $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_rx/rx_dpram_vivado/xlx_k7v7_rx_dpram.xci -name xlx_k7v7_rx_dpram
import_ip $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_tx/tx_dpram_vivado/xlx_k7v7_tx_dpram.xci -name xlx_k7v7_tx_dpram
#####################################################################################################
#####################################################################################################