## Generated SDC file "M:/svn_repositories/GBT_project/svn_work/trunk/example_designs/altera_sv/amc40/sdc/amc40_gbt_ref_design.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Full Version"

## DATE    "Thu Mar 27 13:32:54 2014"

##
## DEVICE  "5SGXEA7N2F45C3"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {REF_CLOCK_L4}         -period 8.333 -waveform { 0.000 4.166 } [get_ports {REF_CLOCK_L4}]
create_clock -name {REF_CLOCK_L2}         -period 8.333 -waveform { 0.000 4.166 } [get_ports {REF_CLOCK_L2}]

create_clock -name {SYS_CLK_40MHz}        -period 25.000 -waveform { 0.000 12.500 } [get_ports {SYS_CLK_40MHz}]

create_clock -name {GBTBANK1_RXRECCLK_1} -period 8.333 -waveform { 0.000 4.166 } [get_pins {gbtExmplDsgn|gbtBank|*|*|*|*|gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|inst_sv_pcs|ch[0].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|rcvdclkpma}]

create_clock -name {GBTBANK2_RXRECCLK_1} -period 8.333 -waveform { 0.000 4.166 } [get_pins {gbtExmplDsgn_gbtBank2|gbtBank|*|*|*|*|gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|inst_sv_pcs|ch[0].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|rcvdclkpma}]
create_clock -name {GBTBANK2_RXRECCLK_2} -period 8.333 -waveform { 0.000 4.166 } [get_pins {gbtExmplDsgn_gbtBank2|gbtBank|*|*|*|*|gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|inst_sv_pcs|ch[1].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|rcvdclkpma}]
create_clock -name {GBTBANK2_RXRECCLK_3} -period 8.333 -waveform { 0.000 4.166 } [get_pins {gbtExmplDsgn_gbtBank2|gbtBank|*|*|*|*|gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|inst_sv_pcs|ch[2].inst_sv_pcs_ch|inst_sv_hssi_8g_rx_pcs|wys|rcvdclkpma}]


create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]

#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {REF_CLOCK_L4}]        -rise_to [get_clocks {REF_CLOCK_L4}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {REF_CLOCK_L4}]        -fall_to [get_clocks {REF_CLOCK_L4}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REF_CLOCK_L4}]        -rise_to [get_clocks {REF_CLOCK_L4}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REF_CLOCK_L4}]        -fall_to [get_clocks {REF_CLOCK_L4}] 0.080 

set_clock_uncertainty -rise_from [get_clocks {REF_CLOCK_L2}]        -rise_to [get_clocks {REF_CLOCK_L2}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {REF_CLOCK_L2}]        -fall_to [get_clocks {REF_CLOCK_L2}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REF_CLOCK_L2}]        -rise_to [get_clocks {REF_CLOCK_L2}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REF_CLOCK_L2}]        -fall_to [get_clocks {REF_CLOCK_L2}] 0.080  

set_clock_uncertainty -rise_from [get_clocks {SYS_CLK_40MHz}]        -rise_to [get_clocks {SYS_CLK_40MHz}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK_40MHz}]        -fall_to [get_clocks {SYS_CLK_40MHz}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK_40MHz}]        -rise_to [get_clocks {SYS_CLK_40MHz}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK_40MHz}]        -fall_to [get_clocks {SYS_CLK_40MHz}] 0.080 

set_clock_uncertainty -rise_from [get_clocks {GBTBANK1_RXRECCLK_1}] -rise_to [get_clocks {GBTBANK1_RXRECCLK_1}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {GBTBANK1_RXRECCLK_1}] -fall_to [get_clocks {GBTBANK1_RXRECCLK_1}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK1_RXRECCLK_1}] -rise_to [get_clocks {GBTBANK1_RXRECCLK_1}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK1_RXRECCLK_1}] -fall_to [get_clocks {GBTBANK1_RXRECCLK_1}] 0.080

set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_1}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_1}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_1}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_1}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_1}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_1}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_1}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_1}] 0.080

set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_2}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_2}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_2}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_2}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_2}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_2}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_2}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_2}] 0.080

set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_3}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_3}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {GBTBANK2_RXRECCLK_3}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_3}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_3}] -rise_to [get_clocks {GBTBANK2_RXRECCLK_3}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {GBTBANK2_RXRECCLK_3}] -fall_to [get_clocks {GBTBANK2_RXRECCLK_3}] 0.080

#**************************************************************
# Set Input Delay
#**************************************************************

#**************************************************************
# Set Output Delay
#**************************************************************

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {SYS_CLK_40MHz}] 
set_clock_groups -asynchronous -group [get_clocks {REF_CLOCK_L4}] 
set_clock_groups -asynchronous -group [get_clocks {REF_CLOCK_L2}] 

set_clock_groups -asynchronous -group [get_clocks {GBTBANK1_RXRECCLK_1}] 
set_clock_groups -asynchronous -group [get_clocks {GBTBANK2_RXRECCLK_1}]
set_clock_groups -asynchronous -group [get_clocks {GBTBANK2_RXRECCLK_2}]
set_clock_groups -asynchronous -group [get_clocks {GBTBANK2_RXRECCLK_3}]

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_ports {AMC_CLOCK_OUT}]
set_false_path -to [get_ports {AMC_CLOCK_OUT(n)}]
set_false_path -to [get_ports {RTM_TX_1_P}]
set_false_path -to [get_ports {RTM_TX_1_N}]
set_false_path -to [get_ports {RTM_TX_2_P}]
set_false_path -to [get_ports {RTM_TX_2_N}]
set_false_path -to [get_ports {altera_reserved_tdo}]

set_false_path -to [get_registers {*alt_xcvr_resync*sync_r[0]}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]

set_false_path -from [get_ports {altera_reserved_tdi}]
set_false_path -from [get_ports {altera_reserved_tms}]
set_false_path -hold -from [get_keepers {*|alt_xcvr_reconfig_basic:basic|sv_xcvr_reconfig_basic:s5|pif_interface_sel}] 

#**************************************************************
# Set Multicycle Path
#**************************************************************

#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {gbtExmplDsgn|gbtBank|*|rxGearbox|*}] -to [get_registers {gbtExmplDsgn|gbtBank|*|descrambler|*}] 20.000
set_max_delay -from [get_registers {gbtExmplDsgn_gbtBank2|gbtBank|*|scrambler|*}] -to [get_registers {gbtExmplDsgn_gbtBank2|gbtBank|*|txGearbox|*}] 20.000

#**************************************************************
# Set Minimum Delay
#**************************************************************

#**************************************************************
# Set Input Transition
#**************************************************************

#**************************************************************
# Set Max Skew
#**************************************************************
set_max_skew -from *alt_sv_gx_reset_tx:gxResetTx*tx_digitalreset*r_reset -to *pld_pcs_interface* 4.166