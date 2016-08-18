set_global_assignment -entity "alt_sv_gx_txpll" -library "lib_alt_sv_gx_txpll" -name IP_TOOL_NAME "altera_xcvr_pll_sv"
set_global_assignment -entity "alt_sv_gx_txpll" -library "lib_alt_sv_gx_txpll" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "alt_sv_gx_txpll" -library "lib_alt_sv_gx_txpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_alt_sv_gx_txpll" -name SPD_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll.spd"]

set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/alt_sv_gx_txpll.vhd"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/sv_xcvr_h.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/sv_xcvr_plls.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/sv_reconfig_bundle_to_xcvr.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/sv_xcvr_avmm_csr.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/sv_xcvr_h.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/sv_xcvr_plls.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/sv_reconfig_bundle_to_xcvr.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/sv_xcvr_avmm_csr.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/plain_files.txt"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/mentor_files.txt"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/cadence_files.txt"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/synopsys_files.txt"]
set_global_assignment -library "lib_alt_sv_gx_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_gx_txpll_sim/altera_xcvr_pll_sv/aldec_files.txt"]
