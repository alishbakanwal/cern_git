set_global_assignment -entity "mgt_atxpll_rst" -library "lib_mgt_atxpll_rst" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "mgt_atxpll_rst" -library "lib_mgt_atxpll_rst" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "mgt_atxpll_rst" -library "lib_mgt_atxpll_rst" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_mgt_atxpll_rst" -name SPD_FILE [file join $::quartus(sip_path) "mgt_atxpll_rst.spd"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "../mgt_atxpll_rst.qsys"]

set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "sim/mgt_atxpll_rst.vhd"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/altera_xcvr_reset_control.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor/alt_xcvr_reset_counter.sv"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/plain_files.txt"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/mentor_files.txt"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/cadence_files.txt"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/synopsys_files.txt"]
set_global_assignment -library "lib_mgt_atxpll_rst" -name MISC_FILE [file join $::quartus(sip_path) "altera_xcvr_reset_control_151/sim/aldec_files.txt"]
