set_global_assignment -entity "gbt_tx_frameclk_stdpll" -library "lib_gbt_tx_frameclk_stdpll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "gbt_tx_frameclk_stdpll" -library "lib_gbt_tx_frameclk_stdpll" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "gbt_tx_frameclk_stdpll" -library "lib_gbt_tx_frameclk_stdpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_gbt_tx_frameclk_stdpll" -name SPD_FILE [file join $::quartus(sip_path) "gbt_tx_frameclk_stdpll.spd"]

set_global_assignment -library "lib_gbt_tx_frameclk_stdpll" -name MISC_FILE [file join $::quartus(sip_path) "gbt_tx_frameclk_stdpll_sim/gbt_tx_frameclk_stdpll.vho"]
