#===================================================================================================#
#===================================   Srcipt Information   ========================================#
#===================================================================================================#
#                                                                                         
# Company:               CERN (PH-ESE-BE)                                                         
# Engineer:              Julian Mendez <julian.mendez@cern.ch>
#                                                                                                 
# Project Name:          GBT-FPGA                                                                
# Script Name:           Altera Arria 10 - GBT Bank                                        
#                                                                                                 
# Language:              TCL (Altera version)                                                              
#                                                                                                   
# Target Device:         Altera Arria 10                                                      
#                                                                                                   
# Version:               4.0                                                                      
#
# Description:            
#
# Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
#
#                        11/02/2016   3.2       Julian Mendez     First .tcl script definition
#                        26/02/2016   4.0       Julian Mendez     Major modifications (Adding QSYS component)
#
# Additional Comments:   TCL script for adding the source files of the Altera Arria 10 GBT Bank
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

set SOURCE_PATH ../../../..
set PROJECT_PATH .

#====================================================================================================
#====================================================================================================

set maxlinks	6


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


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 specific files of the GBT-FPGA Core to the Quartus II project..."
puts "->" 


set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/alt_ax_gbt_banks_user_setup.vhd
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/alt_ax_gbt_bank_package.vhd
  
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/gbt_rx/alt_ax_gbt_rx_gearbox_std_dpram.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/gbt_rx/alt_ax_rx_dpram/alt_ax_rx_dpram/alt_ax_rx_dpram.qip
  
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/gbt_tx/alt_ax_gbt_tx_gearbox_std_dpram.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/gbt_tx/alt_ax_tx_dpram/alt_ax_tx_dpram/alt_ax_tx_dpram.qip

set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/alt_ax_mgt_latopt.vhd
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/alt_ax_mgt_resetctrl.vhd
set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/alt_ax_mgt_std.vhd

set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x6/gx_latopt_x6/gx_latopt_x6.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x5/gx_latopt_x5/gx_latopt_x5.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x4/gx_latopt_x4/gx_latopt_x4.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x3/gx_latopt_x3/gx_latopt_x3.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x2/gx_latopt_x2/gx_latopt_x2.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_latopt_x1/gx_latopt_x1/gx_latopt_x1.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x6/gx_std_x6/gx_std_x6.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x5/gx_std_x5/gx_std_x5.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x4/gx_std_x4/gx_std_x4.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x3/gx_std_x3/gx_std_x3.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x2/gx_std_x2/gx_std_x2.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_std_x1/gx_std_x1/gx_std_x1.qip

set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_reset_rx/gx_reset_rx/gx_reset_rx.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/gx_reset_tx/gx_reset_tx/gx_reset_tx.qip

set_global_assignment -name VHDL_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/alt_ax_mgt_txpll.vhd
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/atx_pll_rst/mgt_atxpll_rst/mgt_atxpll_rst.qip
set_global_assignment -name QIP_FILE  $SOURCE_PATH/gbt_bank/altera_a10/mgt/fpll/mgt_pll/mgt_pll.qip


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 RX Frameclk aligner to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_mmcm_controller.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd

set_global_assignment -name QIP_FILE $SOURCE_PATH/example_designs/altera_a10/core_sources/rx_frameclk_pll/rx_frameclk_pll/rx_frameclk_pll.qip
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/altera_a10/core_sources/phalgnr_std_pll.vhd

# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 Reset module to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/altera_a10/core_sources/alt_a10_reset.vhd
set_global_assignment -name QIP_FILE $SOURCE_PATH/example_designs/altera_a10/core_sources/alt_a10_reset/alt_a10_lpm_shiftreg/alt_a10_lpm_shiftreg.qip
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_bank_reset.vhd


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 GBT Pattern Generator to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_generator.vhd


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 GBT Pattern checker to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_checker.vhd


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 Match Flag module to the Quartus II project..."
puts "->" 
set_global_assignment -name VHDL_FILE $SOURCE_PATH/example_designs/core_sources/gbt_pattern_matchflag.vhd


# Comment: Adding Altera Arria 10 specific files:

puts "-> Adding Altera Arria 10 QSYS component to the Quartus II directory..."
puts "->" 

set in  [open $SOURCE_PATH/tcl/qsys_comp/alt_gbt_hw.tmp r]
set out [open $PROJECT_PATH/alt_gbt_hw.tcl     w]

# line-by-line, read the original file
while {[gets $in line] != -1} {
	if {[string first "set SOURCE_PATH" $line]!=-1} {
		puts $out "set SOURCE_PATH $SOURCE_PATH"
	} elseif {[string first "set MAXLINKS" $line]!=-1} {
		puts $out "set MAXLINKS $maxlinks"
	} elseif {[string first "set LAT_CAPABILITIES" $line]!=-1} {
		puts $out "set LAT_CAPABILITIES {\"Standard\" \"Optimized\"}"	
	} elseif {[string first "set XCVR_FREQ" $line]!=-1} {
		puts $out "set XCVR_FREQ 240000000"	
	} elseif {[string first "set RECONF_ADDR_SIZE" $line]!=-1} {
		puts $out "set RECONF_ADDR_SIZE 13"	
	} elseif {[string first "#Files" $line]!=-1} {
		puts $out "#Files"
		puts $out "add_fileset_file alt_ax_gbt_example_design_qsys_wrapper.vhd VHDL PATH $SOURCE_PATH/example_designs/altera_a10/core_sources/alt_ax_gbt_example_design_qsys_wrapper.vhd TOP_LEVEL_FILE"
		puts $out "add_fileset_file alt_ax_gbt_example_design.vhd VHDL PATH $SOURCE_PATH/example_designs/altera_a10/core_sources/alt_ax_gbt_example_design.vhd"
	} elseif {[string first "set_fileset_property 	QUARTUS_SYNTH 	TOP_LEVEL" $line]!=-1} { 
		puts $out "set_fileset_property 	QUARTUS_SYNTH 	TOP_LEVEL alt_ax_gbt_example_design_qsys"
	} else {
		puts $out $line
	}    
}

close $in
close $out
