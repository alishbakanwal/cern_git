set_global_assignment -entity "frameclk_pll" -library "lib_frameclk_pll" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "frameclk_pll" -library "lib_frameclk_pll" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "frameclk_pll" -library "lib_frameclk_pll" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_frameclk_pll" -name SPD_FILE [file join $::quartus(sip_path) "frameclk_pll.spd"]
set_global_assignment -library "lib_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "../frameclk_pll.qsys"]

set_global_assignment -library "lib_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "sim/frameclk_pll.v"]
set_global_assignment -library "lib_frameclk_pll" -name MISC_FILE [file join $::quartus(sip_path) "altera_iopll_160/sim/frameclk_pll_altera_iopll_160_tnwlaai.vo"]
