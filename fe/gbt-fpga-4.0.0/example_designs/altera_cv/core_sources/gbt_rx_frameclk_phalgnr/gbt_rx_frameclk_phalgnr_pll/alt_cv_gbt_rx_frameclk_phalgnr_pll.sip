set_global_assignment -entity "alt_cv_gbt_rx_frameclk_phalgnr_pll" -library "lib_alt_cv_gbt_rx_frameclk_phalgnr_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "alt_cv_gbt_rx_frameclk_phalgnr_pll" -library "lib_alt_cv_gbt_rx_frameclk_phalgnr_pll" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "alt_cv_gbt_rx_frameclk_phalgnr_pll" -library "lib_alt_cv_gbt_rx_frameclk_phalgnr_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_alt_cv_gbt_rx_frameclk_phalgnr_pll" -name SPD_FILE [file join $::quartus(sip_path) "alt_cv_gbt_rx_frameclk_phalgnr_pll.spd"]

set_global_assignment -library "lib_alt_cv_gbt_rx_frameclk_phalgnr_pll" -name MISC_FILE [file join $::quartus(sip_path) "alt_cv_gbt_rx_frameclk_phalgnr_pll_sim/alt_cv_gbt_rx_frameclk_phalgnr_pll.vho"]
