##===================================================================================================##
##============================= User Constraints FILE (UCF) information =============================##
##===================================================================================================##
##                                                                                         
## Company:               CERN (EP-ESE-BE)                                                         
## Engineer:              Julian Mendez (julian.mendez@cern.ch)
##                        (Original design by Paschalis Vichoudis (CERN))   
##                                                                                                 
## Project Name:          GBT-FPGA                                                                
## UCF File Name:         FC7 - System emulation                                 
##                                                                                                   
## Target Device:         FC7 (Xilinx Kintex 7)                                                         
## Tool version:          ISE 14.5                                                                
##                                                                                                   
## Version:               3.5                                                                      
##
## Description:            
##
## Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
##
##                        01/08/2014   3.5       J. Mendez           - First .xdc definitions 
## 
## Additional Comments:   
##                                                                                                   
##===================================================================================================##
##===================================================================================================##

##==============##           
## FABRIC CLOCK ##
##==============##         

set_property PACKAGE_PIN AK19 [get_ports fabric_clk_n]
set_property PACKAGE_PIN AK18 [get_ports fabric_clk_p]
#set_property IOSTANDARD LVDS [get_ports fabric_clk_n]
#set_property IOSTANDARD LVDS [get_ports fabric_clk_p]

create_clock -name FRMCLK -period 25.000 [get_ports fabric_clk_p]
set_clock_groups -asynchronous -group {FRMCLK}

##==============##           
## MGT CLOCK    ##
##==============##     
set_property PACKAGE_PIN G7  [get_ports ttc_mgt_xpoint_c_n]
set_property PACKAGE_PIN G8  [get_ports ttc_mgt_xpoint_c_p]

create_clock -name MGT_REFCLK -period 8.333 [get_ports ttc_mgt_xpoint_c_p]

##=====##           
## I/O ##
##=====##    

set_property PACKAGE_PIN AA28 [get_ports sw3]
set_property IOSTANDARD LVCMOS33 [get_ports sw3]

set_property PACKAGE_PIN AA24 [get_ports sysled1_r] 
set_property PACKAGE_PIN V27  [get_ports sysled1_g]
set_property PACKAGE_PIN AA31 [get_ports sysled1_b] 
set_property PACKAGE_PIN AA29 [get_ports sysled2_r]
set_property PACKAGE_PIN Y28  [get_ports sysled2_g]
set_property PACKAGE_PIN Y29  [get_ports sysled2_b]
set_property IOSTANDARD LVCMOS33 [get_ports sysled1_r]
set_property IOSTANDARD LVCMOS33 [get_ports sysled1_g]
set_property IOSTANDARD LVCMOS33 [get_ports sysled1_b]
set_property IOSTANDARD LVCMOS33 [get_ports sysled2_r]
set_property IOSTANDARD LVCMOS33 [get_ports sysled2_g]
set_property IOSTANDARD LVCMOS33 [get_ports sysled2_b]

set_property PACKAGE_PIN AH27 [get_ports fmc_l8_spare[0]]
set_property PACKAGE_PIN AH28 [get_ports fmc_l8_spare[1]]
set_property PACKAGE_PIN AH25 [get_ports fmc_l8_spare[2]]
set_property PACKAGE_PIN AJ25 [get_ports fmc_l8_spare[3]]
set_property PACKAGE_PIN AH24 [get_ports fmc_l8_spare[4]]
set_property PACKAGE_PIN AJ24 [get_ports fmc_l8_spare[5]]
set_property PACKAGE_PIN AG26 [get_ports fmc_l8_spare[6]]
set_property PACKAGE_PIN AG27 [get_ports fmc_l8_spare[7]]
set_property PACKAGE_PIN AG28  [get_ports fmc_l8_spare[8]] 
set_property PACKAGE_PIN AH29 [get_ports fmc_l8_spare[9]]
set_property PACKAGE_PIN AF28 [get_ports fmc_l8_spare[10]]
set_property PACKAGE_PIN AF29 [get_ports fmc_l8_spare[11]]
set_property PACKAGE_PIN AE27 [get_ports fmc_l8_spare[12]] 
set_property PACKAGE_PIN AE28 [get_ports fmc_l8_spare[13]]
set_property PACKAGE_PIN AE26 [get_ports fmc_l8_spare[14]]
set_property PACKAGE_PIN AF26 [get_ports fmc_l8_spare[15]]
set_property PACKAGE_PIN AE24 [get_ports fmc_l8_spare[16]]
set_property PACKAGE_PIN AF24 [get_ports fmc_l8_spare[17]]
set_property PACKAGE_PIN AF25 [get_ports fmc_l8_spare[18]]
set_property PACKAGE_PIN AG25 [get_ports fmc_l8_spare[19]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[0]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[1]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[2]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[3]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[4]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[5]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[6]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[7]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[8]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[9]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[10]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[11]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[12]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[13]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[14]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[15]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[16]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[17]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[18]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_spare[19]]

set_property PACKAGE_PIN AN18 [get_ports k7_master_xpoint_ctrl[0]]
set_property PACKAGE_PIN AN17 [get_ports k7_master_xpoint_ctrl[1]]
set_property PACKAGE_PIN AM21 [get_ports k7_master_xpoint_ctrl[2]]    
set_property PACKAGE_PIN AL21 [get_ports k7_master_xpoint_ctrl[3]]      
set_property PACKAGE_PIN AP19 [get_ports k7_master_xpoint_ctrl[4]]
set_property PACKAGE_PIN AN19 [get_ports k7_master_xpoint_ctrl[5]]   
set_property PACKAGE_PIN AP20 [get_ports k7_master_xpoint_ctrl[6]]
set_property PACKAGE_PIN AN20 [get_ports k7_master_xpoint_ctrl[7]]
set_property PACKAGE_PIN AP22 [get_ports k7_master_xpoint_ctrl[8]]
set_property PACKAGE_PIN AP21 [get_ports k7_master_xpoint_ctrl[9]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[0]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[1]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[2]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[3]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[4]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[5]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[6]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[7]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[8]]
set_property IOSTANDARD LVCMOS25 [get_ports k7_master_xpoint_ctrl[9]]

set_property PACKAGE_PIN AD26 [get_ports fmc_l8_pwr_en]
set_property PACKAGE_PIN AC25 [get_ports fmc_l12_pwr_en]			
set_property IOSTANDARD LVCMOS33 [get_ports fmc_l8_pwr_en]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_l12_pwr_en]

set_property PACKAGE_PIN N24 [get_ports fmc_l12_spare[6]]	
set_property PACKAGE_PIN N25 [get_ports fmc_l12_spare[7]]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_l12_spare[6]]
set_property IOSTANDARD LVCMOS33 [get_ports fmc_l12_spare[7]]

set_property PACKAGE_PIN AE31 [get_ports fmc_l8_la_p[33]]
set_property PACKAGE_PIN AC32 [get_ports fmc_l8_la_p[32]]
set_property PACKAGE_PIN AE33 [get_ports fmc_l8_la_p[31]]
set_property PACKAGE_PIN AC34 [get_ports fmc_l8_la_p[30]]
set_property PACKAGE_PIN AJ29 [get_ports fmc_l8_la_p[29]]
set_property PACKAGE_PIN AD31 [get_ports fmc_l8_la_p[28]]
set_property PACKAGE_PIN AL30 [get_ports fmc_l8_la_p[27]]
set_property PACKAGE_PIN AK33 [get_ports fmc_l8_la_p[26]]
set_property PACKAGE_PIN AE34 [get_ports fmc_l8_la_p[25]]
set_property PACKAGE_PIN AH30 [get_ports fmc_l8_la_p[24]]
set_property PACKAGE_PIN AK28 [get_ports fmc_l8_la_p[23]]
set_property PACKAGE_PIN AF30 [get_ports fmc_l8_la_p[22]]
set_property PACKAGE_PIN AM33 [get_ports fmc_l8_la_p[21]]
set_property PACKAGE_PIN AM27 [get_ports fmc_l8_la_p[20]]
set_property PACKAGE_PIN AG33 [get_ports fmc_l8_la_p[19]]
set_property PACKAGE_PIN AL25 [get_ports fmc_l8_la_p[18]]
set_property PACKAGE_PIN AK26 [get_ports fmc_l8_la_p[17]]
set_property PACKAGE_PIN AJ32 [get_ports fmc_l8_la_p[16]]
set_property PACKAGE_PIN AH34 [get_ports fmc_l8_la_p[15]]
set_property PACKAGE_PIN AN32 [get_ports fmc_l8_la_p[14]]
set_property PACKAGE_PIN AK34 [get_ports fmc_l8_la_p[13]]
set_property PACKAGE_PIN AM25 [get_ports fmc_l8_la_p[12]]
set_property PACKAGE_PIN AL29 [get_ports fmc_l8_la_p[11]]
set_property PACKAGE_PIN AP31 [get_ports fmc_l8_la_p[10]]
set_property PACKAGE_PIN AN29 [get_ports fmc_l8_la_p[9]]
set_property PACKAGE_PIN AN27 [get_ports fmc_l8_la_p[8]]
set_property PACKAGE_PIN AP29 [get_ports fmc_l8_la_p[7]]
set_property PACKAGE_PIN AN25 [get_ports fmc_l8_la_p[6]]
set_property PACKAGE_PIN AP26 [get_ports fmc_l8_la_p[5]]
set_property PACKAGE_PIN AN24 [get_ports fmc_l8_la_p[4]]
set_property PACKAGE_PIN AM23 [get_ports fmc_l8_la_p[3]]
set_property PACKAGE_PIN AK24 [get_ports fmc_l8_la_p[2]]
set_property PACKAGE_PIN AG32 [get_ports fmc_l8_la_p[1]]
set_property PACKAGE_PIN AF31 [get_ports fmc_l8_la_p[0]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[33]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[32]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[31]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[30]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[29]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[28]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[27]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[26]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[25]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[24]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[23]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[22]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[21]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[20]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[19]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[18]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[17]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[16]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[15]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[14]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[13]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[12]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[11]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[10]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[9]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[8]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[7]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[6]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[5]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[4]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[3]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[2]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[1]]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_l8_la_p[0]]


set_property PACKAGE_PIN B10 [get_ports fmc_l12_dp_c2m_p[0]]
set_property PACKAGE_PIN B9  [get_ports fmc_l12_dp_c2m_n[0]]

set_property PACKAGE_PIN D10 [get_ports fmc_l12_dp_m2c_p[0]]
set_property PACKAGE_PIN D9  [get_ports fmc_l12_dp_m2c_n[0]]
##===================================================================================================##
##===================================================================================================##