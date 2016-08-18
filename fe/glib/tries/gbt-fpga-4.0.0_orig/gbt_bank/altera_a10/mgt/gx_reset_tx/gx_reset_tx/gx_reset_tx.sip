set_global_assignment -entity "gx_reset_tx" -library "lib_gx_reset_tx" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "gx_reset_tx" -library "lib_gx_reset_tx" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "gx_reset_tx" -library "lib_gx_reset_tx" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_gx_reset_tx" -name SPD_FILE [file join $::quartus(sip_path) "gx_reset_tx.spd"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "../gx_reset_tx.qsys"]

set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "sim/gx_reset_tx.vhd"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/plain_files.txt"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor_files.txt"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/cadence_files.txt"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/synopsys_files.txt"]
set_global_assignment -library "lib_gx_reset_tx" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/aldec_files.txt"]
