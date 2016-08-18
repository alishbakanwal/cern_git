#===================================================================================================#
#====================================   Srcipt Information   =======================================#
#===================================================================================================#
#                                                                                         
# Company:               CERN (PH-ESE-BE)                                                         
# Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
#                                                                                                 
# Project Name:          GBT-FPGA                                                                
# Script Name:           Xilinx Kintex7 & Virtex 7 - GBT Bank                                        
#                                                                                                 
# Language:              TCL (Xilinx version)                                                              
#                                                                                                   
# Target Device:         Xilinx Kintex7 & Virtex 7                                                 
#                                                                                                   
# Version:               3.2                                                                      
#
# Description:            
#
# Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
#
#                        11/04/2014   3.0       M. Barros Marin   First .tcl script definition
#
#                        12/09/2014   3.2       M. Barros Marin   Minor modifications
#
# Additional Comments:   TCL script for adding the source files of the Xilinx Kintex 7 &  Virtex 7
#                        GBT Bank to ISE
#
#===================================================================================================#
#===================================================================================================#
#===================================================================================================#


#===================================================================================================#
#============================ Absolute Data Path Set By The User ===================================#
#===================================================================================================#

# Comment: The user has to provide the absolute data path to the root folder of the GBT-FPGA Core
#          source files.

set SOURCE_PATH C:/svn/gbt_fpga/tags/gbt_fpga_3_1_0

#===================================================================================================#
#===================================================================================================#


#===================================================================================================#
#=================== Commands for Adding the Source Files of the GBT-FPGA Core =====================#
#===================================================================================================#
      
# Comment: Adding Common files: 

puts "->"
puts "-> Adding common files of the GBT-FPGA Core to the ISE project..."
puts "->" 

xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_16bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std_rdctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_16bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_bank.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_bank_package.vhd

# Comment: Adding Xilinx Kintex 7 & Virtex 7 specific files:

puts "-> Adding Xilinx Kintex 7 & Virtex 7 specific files of the GBT-FPGA Core to the ISE project..."
puts "->" 

xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_rx/xlx_k7v7_gbt_rx_gearbox_std_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_tx/xlx_k7v7_gbt_tx_gearbox_std_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_std.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_std.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_auto_phase_align.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_rx_manual_phase_align.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_rx_startup_fsm.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_sync_block.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_sync_pulse.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_tx_manual_phase_align.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_gtx_tx_startup_fsm.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_bank_package.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_banks_user_setup.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_rx/rx_dpram/xlx_k7v7_rx_dpram.xco
xfile add $SOURCE_PATH/gbt_bank/xilinx_k7v7/gbt_tx/tx_dpram/xlx_k7v7_tx_dpram.xco

#===================================================================================================#
#===================================================================================================#