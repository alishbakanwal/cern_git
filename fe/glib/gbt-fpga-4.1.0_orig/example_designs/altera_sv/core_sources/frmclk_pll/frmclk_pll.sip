set_global_assignment -entity "frmclk_pll" -library "lib_frmclk_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "frmclk_pll" -library "lib_frmclk_pll" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "frmclk_pll" -library "lib_frmclk_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_frmclk_pll" -name SPD_FILE [file join $::quartus(sip_path) "frmclk_pll.spd"]

set_global_assignment -library "lib_frmclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "frmclk_pll_sim/frmclk_pll.vho"]
