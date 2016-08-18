#===================================================================================================#
#===================================   Srcipt Information   ========================================#
#===================================================================================================#
#                                                                                         
# Company:               CERN (EP-ESE-BE)                                                         
# Engineer:              Julian Mendez (julian.mendez@cern.ch)
#                                                                                                 
# Project Name:          GBT-FPGA                                                                
# Script Name:           Xilinx Kintex Ultrascale - GBT Bank                                        
#                                                                                                 
# Language:              TCL (Xilinx version)                                                              
#                                                                                                   
# Target Device:         Xilinx Kintex Ultrascale                                                
#                                                                                                   
# Version:               4.1                                                                      
#
# Description:            
#
# Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
#
#                        19/07/2016   4.1       J. Mendez         First .tcl script definition
#
# Additional Comments:   TCL script for adding the source files of the Xilinx Kintex Ultrascale
#                        GBT Bank to Vivado
#
#===================================================================================================#
#===================================================================================================#
#===================================================================================================#

#===================================================================================================#
#============================ Absolute Data Path Set By The User ===================================#
#===================================================================================================#

# Comment: The user has to provide the absolute data path to the root folder of the GBT-FPGA Core
#          source files.

set SOURCE_PATH D:/svn/trunk

#===================================================================================================#
#=================== Commands for Adding the Source Files of the GBT-FPGA Core =====================#
#===================================================================================================#
      
# Comment: Adding Common files: 

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

# Comment: Adding Xilinx Kintex 7 & Virtex 7 specific files:

puts "->"
puts "-> Adding device specific packages of the GBT-FPGA Core for Kintex Ultrascale to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/xilinx_ku/xlx_ku_gbt_bank_package.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/xlx_ku_gbt_banks_user_setup.vhd

puts "->"
puts "-> Adding MGT files of the GBT-FPGA Core for Kintex Ultrascale to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_bit_synchronizer.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gthe3_channel.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gthe3_cpll_cal.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gthe3_cpll_cal_freq_counter.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_buffbypass_rx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_buffbypass_tx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_reset.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_userclk_rx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_userclk_tx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_userdata_rx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_gtwiz_userdata_tx.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_reset_inv_synchronizer.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/gtwizard_ultrascale_v1_6_reset_synchronizer.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/xlx_ku_mgt_ip.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/xlx_ku_mgt_ip_gthe3_channel_wrapper.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/xlx_ku_mgt_ip_gtwizard_gthe3.v
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/mgt_ip_vhd/xlx_ku_mgt_ip_gtwizard_top.v

add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/xlx_ku_mgt_ip_reset_synchronizer.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/xlx_ku_mgt_latopt.vhd
add_files $SOURCE_PATH/gbt_bank/xilinx_ku/mgt/xlx_ku_mgt_std.vhd

puts "->"
puts "-> Adding GBT TX files of the GBT-FPGA Core for Kintex Ultrascale to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/xilinx_ku/gbt_tx/xlx_ku_gbt_tx_gearbox_std_dpram.vhd
import_ip $SOURCE_PATH/gbt_bank/xilinx_ku/gbt_tx/xlx_ku_tx_dpram.xci -name xlx_ku_tx_dpram

puts "->"
puts "-> Adding GBT RX files of the GBT-FPGA Core for Kintex Ultrascale to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/gbt_bank/xilinx_ku/gbt_rx/xlx_ku_gbt_rx_gearbox_std_dpram.vhd
import_ip $SOURCE_PATH/gbt_bank/xilinx_ku/gbt_rx/xlx_ku_rx_dpram.xci -name xlx_ku_rx_dpram

puts "->"
puts "-> Adding GBT additional files for Kintex Ultrascale to the VIVADO project..."
puts "->" 

add_files $SOURCE_PATH/example_designs/xilinx_kultrascale/core_sources/xlx_ku_gbt_example_design.vhd

add_files $SOURCE_PATH/example_designs/xilinx_kultrascale/core_sources/gbt_rx_frameclk_phalgnr/phaligner_mmcm_controller.vhd
add_files $SOURCE_PATH/example_designs/xilinx_kultrascale/core_sources/gbt_rx_frameclk_phalgnr/xlx_ku_phalgnr_std_mmcm.vhd
import_ip $SOURCE_PATH/example_designs/xilinx_kultrascale/core_sources/gbt_rx_frameclk_phalgnr/vivado/xlx_ku_gbt_rx_frameclk_phaligner_mmcm.xci -name xlx_ku_gbt_rx_frameclk_phaligner_mmcm
add_files $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd
add_files $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd
add_files $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd

add_files $SOURCE_PATH/example_designs/core_sources/gbt_bank_reset.vhd
add_files $SOURCE_PATH/example_designs/core_sources/gbt_pattern_checker.vhd
add_files $SOURCE_PATH/example_designs/core_sources/gbt_pattern_generator.vhd
add_files $SOURCE_PATH/example_designs/core_sources/gbt_pattern_matchflag.vhd

#####################################################################################################
#####################################################################################################