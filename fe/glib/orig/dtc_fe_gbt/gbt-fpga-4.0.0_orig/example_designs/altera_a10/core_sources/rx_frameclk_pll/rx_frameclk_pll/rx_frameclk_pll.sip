set_global_assignment -entity "rx_frameclk_pll" -library "lib_rx_frameclk_pll" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "rx_frameclk_pll" -library "lib_rx_frameclk_pll" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "rx_frameclk_pll" -library "lib_rx_frameclk_pll" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_rx_frameclk_pll" -name SPD_FILE [file join $::quartus(sip_path) "rx_frameclk_pll.spd"]
set_global_assignment -library "lib_rx_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "../rx_frameclk_pll.qsys"]

set_global_assignment -library "lib_rx_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "sim/rx_frameclk_pll.v"]
set_global_assignment -library "lib_rx_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "altera_iopll_151/sim/rx_frameclk_pll_altera_iopll_151_zl46mda.vo"]
