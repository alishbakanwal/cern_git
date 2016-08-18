set_global_assignment -entity "alt_cv_gt_txpll" -library "lib_alt_cv_gt_txpll" -name IP_TOOL_NAME "altera_xcvr_pll_cv"
set_global_assignment -entity "alt_cv_gt_txpll" -library "lib_alt_cv_gt_txpll" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "alt_cv_gt_txpll" -library "lib_alt_cv_gt_txpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_alt_cv_gt_txpll" -name SPD_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll.spd"]

set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/alt_cv_gt_txpll.vhd"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/altera_xcvr_functions.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/av_xcvr_h.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/av_xcvr_plls.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/av_reconfig_bundle_to_xcvr.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/av_xcvr_avmm_csr.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/av_xcvr_h.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/av_xcvr_plls.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/av_reconfig_bundle_to_xcvr.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/av_xcvr_avmm_csr.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor/alt_xcvr_resync.sv"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/plain_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/mentor_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/cadence_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/synopsys_files.txt"]
set_global_assignment -library "lib_alt_cv_gt_txpll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gt_txpll_sim/altera_xcvr_pll_cv/aldec_files.txt"]
