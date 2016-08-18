set_global_assignment -entity "alt_cv_gt_reset_rx" -library "lib_alt_cv_gt_reset_rx" -name IP_TOOL_NAME "altera_xcvr_reset_control"
set_global_assignment -entity "alt_cv_gt_reset_rx" -library "lib_alt_cv_gt_reset_rx" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "alt_cv_gt_reset_rx" -library "lib_alt_cv_gt_reset_rx" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name SPD_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx.spd"]

set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/alt_cv_gt_reset_rx.vhd"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/plain_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/mentor_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/cadence_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/synopsys_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_reset_rx" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_reset_rx_sim/altera_xcvr_reset_control/aldec_files.txt"]
