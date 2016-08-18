set_global_assignment -entity "alt_sv_issp_gbtBank2" -library "lib_alt_sv_issp_gbtBank2" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "alt_sv_issp_gbtBank2" -library "lib_alt_sv_issp_gbtBank2" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "alt_sv_issp_gbtBank2" -library "lib_alt_sv_issp_gbtBank2" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_alt_sv_issp_gbtBank2" -name SPD_FILE [file join $::quartus(sip_path) "../alt_sv_issp_gbtBank2.spd"]
set_global_assignment -library "lib_alt_sv_issp_gbtBank2" -name MISC_FILE [file join $::quartus(sip_path) "../../alt_sv_issp_gbtBank2.qsys"]

set_global_assignment -library "lib_alt_sv_issp_gbtBank2" -name MISC_FILE [file join $::quartus(sip_path) "alt_sv_issp_gbtBank2.vhd"]
set_global_assignment -library "lib_alt_sv_issp_gbtBank2" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altsource_probe.v"]
