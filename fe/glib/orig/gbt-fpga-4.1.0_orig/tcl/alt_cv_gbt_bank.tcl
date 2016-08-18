#===================================================================================================#
#===================================   Srcipt Information   ========================================#
#===================================================================================================#
#                                                                                         
# Company:               CERN (PH-ESE-BE)                                                         
# Engineer:              Julian Mendez <julian.mendez@cern.ch>
#                                                                                                 
# Project Name:          GBT-FPGA                                                                
# Script Name:           Altera Cyclone V - GBT Bank                                        
#                                                                                                 
# Language:              TCL (Altera version)                                                              
#                                                                                                   
# Target Device:         Altera Cyclone v                                                      
#                                                                                                   
# Version:               4.0                                                                      
#
# Description:            
#
# Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
#
#                        11/04/2014   3.2       M. Barros Marin   First .tcl script definition
#                        26/02/2016   4.0       Julian Mendez     Major modifications (Adding QSYS component)
#
# Additional Comments:   TCL script for adding the source files of the Altera Stratix V GBT Bank
#                        to Quartus II
#
#===================================================================================================#
#===================================================================================================#
#===================================================================================================#


#===================================================================================================#
#============================ Absolute Data Path Set By The User ===================================#
#===================================================================================================#

# Comment: The user has to provide the absolute data path to the root folder of the GBT-FPGA Core
#          source files.

set SOURCE_PATH "D:/svn/trunk"

#===================================================================================================#
#=================== Commands for Adding the Source Files of the GBT-FPGA Core =====================#
#===================================================================================================#

# Comment: Adding Common files: 

puts "->" 
puts "-> Adding common files of the GBT-FPGA Core to the Quartus II project..."
puts "->" 

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_16bit.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std_rdctrl.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd
  
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_latopt.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_16bit.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_bank.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/core_sources/gbt_bank_package.vhd

# Comment: Adding Altera Cyclone V specific files:

puts "-> Adding Altera Cyclone V specific files of the GBT-FPGA Core to the Quartus II project..."
puts "->" 

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/alt_cv_gbt_banks_user_setup.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/alt_cv_gbt_bank_package.vhd
  
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/gbt_rx/alt_cv_gbt_rx_gearbox_std_dpram.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/gbt_rx/rx_dpram/alt_cv_rx_dpram.qip
  
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_cv/gbt_tx/alt_cv_gbt_tx_gearbox_std_dpram.vhd
set_global_assignment -name QIP_FILE   $SOURCE_PATH/gbt_bank/altera_cv/gbt_tx/tx_dpram/alt_cv_tx_dpram.qip

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/mgt/alt_cv_mgt_latopt.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/mgt/alt_cv_mgt_resetctrl.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/mgt/alt_cv_mgt_std.vhd

set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/gt_std_x1/alt_cv_gt_std_x1.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/gt_std_x2/alt_cv_gt_std_x2.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/gt_std_x3/alt_cv_gt_std_x3.qip

set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_reconfctrl_x1/alt_cv_gt_reconfctrl_x1.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_reconfctrl_x2/alt_cv_gt_reconfctrl_x2.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_reconfctrl_x3/alt_cv_gt_reconfctrl_x3.qip

set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/gt_reset_rx/alt_cv_gt_reset_rx.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/gt_reset_tx/alt_cv_gt_reset_tx.qip

set_global_assignment -name VHDL_FILE $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_txpll/alt_cv_mgt_txpll.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_txpll/gt_reset_txpll/alt_cv_gt_reset_txpll.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_cv/mgt/mgt_txpll/gt_txpll/alt_cv_gt_txpll.qip


# Comment: Adding Altera Cyclone V specific files:

puts "-> Adding Altera Cyclone V Reset module to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/altera_cv/core_sources/reset/alt_cv_reset.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/example_designs/altera_cv/core_sources/reset/lpm_shiftreg/alt_cv_lpm_shiftreg.qip
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_bank_reset.vhd


# Comment: Adding Altera Cyclone V specific files:

puts "-> Adding Altera Cyclone V GBT Pattern Generator to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_generator.vhd


# Comment: Adding Altera Cyclone V specific files:

puts "-> Adding Altera Cyclone V GBT Pattern checker to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_checker.vhd


# Comment: Adding Altera Cyclone V specific files:

puts "-> Adding Altera Cyclone V Match Flag module to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_matchflag.vhd


puts "-> Adding Altera Cyclone V top to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/altera_cv/core_sources/alt_cv_gbt_example_design.vhd