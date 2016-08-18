## Generated SDC file "M:/project_gbt/hdl_projects/alt_cv_latopt_refdes_old7/ref_designs/vendor_specific/altera/alt_v_series/cyclone_v_gt/cv_gt_fpga_devkit/sdc/cVgtFPGAdevkit_gbt_ref_design.sdc"

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
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"

## DATE    "Wed Jan 29 15:55:35 2014"

##
## DEVICE  "5CGTFD9E5F35C7"
##

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {REFCLK_QL3} -period  8.333 -waveform { 0.000  4.166 } [get_ports {REFCLK_QL3}]
create_clock -name {CLKIN_50}   -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLKIN_50}]

#create_clock -name {RX_RECCLK}  -period  8.333 -waveform { 0.000  4.166 } [get_pins -hierarchical {*|rcvdclkpma}]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks -create_base_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

set_clock_uncertainty -rise_from [get_clocks {REFCLK_QL3}] -rise_to [get_clocks {REFCLK_QL3}] 0.080  
set_clock_uncertainty -rise_from [get_clocks {REFCLK_QL3}] -fall_to [get_clocks {REFCLK_QL3}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REFCLK_QL3}] -rise_to [get_clocks {REFCLK_QL3}] 0.080  
set_clock_uncertainty -fall_from [get_clocks {REFCLK_QL3}] -fall_to [get_clocks {REFCLK_QL3}] 0.080  

set_clock_uncertainty -rise_from [get_clocks {CLKIN_50}]   -rise_to [get_clocks {CLKIN_50}]   0.080  
set_clock_uncertainty -rise_from [get_clocks {CLKIN_50}]   -fall_to [get_clocks {CLKIN_50}]   0.080  
set_clock_uncertainty -fall_from [get_clocks {CLKIN_50}]   -rise_to [get_clocks {CLKIN_50}]   0.080  
set_clock_uncertainty -fall_from [get_clocks {CLKIN_50}]   -fall_to [get_clocks {CLKIN_50}]   0.080 

#**************************************************************
# Set Input Delay
#**************************************************************

#**************************************************************
# Set Output Delay
#**************************************************************

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {REFCLK_QL3}] 

set_clock_groups -asynchronous -group [get_clocks {CLKIN_50}] 

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_ports {SMA_CLKOUT}]
set_false_path -to [get_ports {HSMA_TX_D_P0}]
set_false_path -to [get_ports {HSMA_TX_D_P1}]
set_false_path -to [get_ports {HSMA_TX_D_P2}]
set_false_path -to [get_ports {HSMA_TX_D_P3}]
set_false_path -to [get_ports {HSMA_TX_D_P4}]
set_false_path -to [get_ports {HSMA_TX_D_P5}]
set_false_path -to [get_ports {USER_LED[0]}]
set_false_path -to [get_ports {USER_LED[1]}]
set_false_path -to [get_ports {USER_LED[2]}]
set_false_path -to [get_ports {USER_LED[3]}]
set_false_path -to [get_ports {USER_LED[4]}]
set_false_path -to [get_ports {USER_LED[5]}]
set_false_path -to [get_ports {USER_LED[6]}]
set_false_path -to [get_ports {USER_LED[7]}]
#set_false_path -to [get_ports {altera_reserved_tdo}]

set_false_path -from [get_ports {USER_PB0}]
set_false_path -from [get_ports {altera_reserved_tdi}]
set_false_path -from [get_ports {altera_reserved_tms}]

set_false_path -from [get_registers {*8g*pcs*SYNC_DATA*}]
set_false_path -to   [get_registers {*8g*pcs*SYNC_DATA*}]

set_false_path -from [get_clocks {txframeclk_pll|gbt_tx_frameclk_stdpll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {*|txpmalocalclk}]
set_false_path -from [get_clocks {*|txpmalocalclk}] -to [get_clocks {txframeclk_pll|gbt_tx_frameclk_stdpll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from [get_clocks {txframeclk_pll|gbt_tx_frameclk_stdpll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {*|rcvdclkpma}]
set_false_path -from [get_clocks {*|rcvdclkpma}] -to [get_clocks {txframeclk_pll|gbt_tx_frameclk_stdpll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]

#**************************************************************
# Set Multicycle Path
#**************************************************************

#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {gbtExmplDsgn|\gbtBank_rst_gen:1:gbtBank_gbtBankRst|gbtResetTx_from_generalRstFsm}] 20.000
set_max_delay -from [get_registers {gbtExmplDsgn|\gbtBank_rst_gen:1:gbtBank_gbtBankRst|gbtResetRx_from_generalRstFsm}] 20.000
set_max_delay -from [get_registers {gbtExmplDsgn|\gbtBank_rst_gen:1:gbtBank_gbtBankRst|mgtResetTx_from_generalRstFsm}]  7.000
set_max_delay -from [get_registers {gbtExmplDsgn|\gbtBank_rst_gen:1:gbtBank_gbtBankRst|mgtResetRx_from_generalRstFsm}]  7.000

#**************************************************************
# Set Minimum Delay
#**************************************************************

#**************************************************************
# Set Input Transition
#**************************************************************
set_max_skew -from *tx_digitalreset*r_reset -to *pld_pcs_interface* 4.166
