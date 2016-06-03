##===================================================================================================##
##============================= User Constraints FILE (UCF) information =============================##
##===================================================================================================##
##                                                                                         
## Company:               CERN (PH-ESE-BE)                                                         
## Engineer:              Julian Mendez (julian.mendez@cern.ch)
##                                                                                                 
## Project Name:          GBT-FPGA                                                                
## UCF File Name:         VC707 - GBT Bank example design I/O                                        
##                                                                                                   
## Target Device:         VC707 (Xilinx Virtex 7)                                                         
## Tool version:          VIVADO 2015.3                                                              
##                                                                                                   
## Version:               3.0                                                                      
##
## Description:            
##
## Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
##
##                        06/03/2013   3.0       J. Mendez           First .xdc definition
##
## Additional Comments:   
##                                                                                                   
##===================================================================================================##
##===================================================================================================##

##===================================================================================================##
##========================================  I/O PINS  ===============================================##
##===================================================================================================##

##==============##                                      
## FABRIC CLOCK ##         
##==============## 

set_property PACKAGE_PIN AK34 [get_ports USER_CLOCK_P]
set_property PACKAGE_PIN AL34 [get_ports USER_CLOCK_N]

set_property IOSTANDARD LVDS [get_ports USER_CLOCK_P]
set_property IOSTANDARD LVDS [get_ports USER_CLOCK_P]

create_clock -name USER_CLOCK -period 6.4 [get_ports USER_CLOCK_P]
set_clock_groups -asynchronous -group {USER_CLOCK}

##===========##                                      
## MGT CLOCK ##         
##===========##   

## Comment: * The MGT reference clock MUST be provided by an external clock generator.
##
##          * The MGT reference clock frequency must be 120MHz for the latency-optimized GBT Bank.


set_property PACKAGE_PIN AK8 [get_ports SMA_MGT_REFCLK_P]
set_property PACKAGE_PIN AK7 [get_ports SMA_MGT_REFCLK_N]

create_clock -name MGT_REFCLK -period 8.333 [get_ports SMA_MGT_REFCLK_N]
set_clock_groups -asynchronous -group {MGT_REFCLK}

##=======##  
## RESET ##            
##=======##   

set_property PACKAGE_PIN AV40 [get_ports CPU_RESET]
set_property IOSTANDARD LVCMOS18 [get_ports CPU_RESET]

##==========##
## MGT(GTX) ##
##==========##

## SERIAL LANES:
##--------------

set_property PACKAGE_PIN AM4 [get_ports SFP_TX_P]
set_property PACKAGE_PIN AM3 [get_ports SFP_TX_N]
set_property PACKAGE_PIN AL6 [get_ports SFP_RX_P]
set_property PACKAGE_PIN AL5 [get_ports SFP_RX_N]

## SFP CONTROL:
##-------------

set_property PACKAGE_PIN AP33 [get_ports SFP_TX_DISABLE]
set_property IOSTANDARD LVCMOS18 [get_ports SFP_TX_DISABLE]

##===============##      
## ON-BOARD LEDS ##  
##===============##

set_property PACKAGE_PIN AM39 [get_ports GPIO_LED_0_LS]
set_property PACKAGE_PIN AN39 [get_ports GPIO_LED_1_LS]
set_property PACKAGE_PIN AR37 [get_ports GPIO_LED_2_LS]
set_property PACKAGE_PIN AT37 [get_ports GPIO_LED_3_LS]
set_property PACKAGE_PIN AR35 [get_ports GPIO_LED_4_LS]
set_property PACKAGE_PIN AP41 [get_ports GPIO_LED_5_LS]
set_property PACKAGE_PIN AP42 [get_ports GPIO_LED_6_LS]
set_property PACKAGE_PIN AU39 [get_ports GPIO_LED_7_LS]                 

set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_0_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_1_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_2_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_3_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_4_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_5_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_6_LS]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_7_LS]

##====================##
## SIGNALS FORWARDING ##
##====================##

## SMA OUTPUT:
##------------

set_property PACKAGE_PIN AN31 [get_ports USER_SMA_GPIO_P]
set_property IOSTANDARD LVCMOS18 [get_ports USER_SMA_GPIO_P]

## PATTERN MATCH FLAGS:                         
##---------------------

set_property PACKAGE_PIN K39 [get_ports FMC1_HPC_LA00_CC_P]
set_property PACKAGE_PIN J40 [get_ports FMC1_HPC_LA01_CC_P]

set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA00_CC_P]
set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA01_CC_P]

## CLOCKS FORWARDING:   
##------------------- 

set_property PACKAGE_PIN P41 [get_ports FMC1_HPC_LA02_P]
set_property PACKAGE_PIN M42 [get_ports FMC1_HPC_LA03_P]
set_property PACKAGE_PIN H40 [get_ports FMC1_HPC_LA04_P]
set_property PACKAGE_PIN M41 [get_ports FMC1_HPC_LA05_P]

set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA02_P]
set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA03_P]
set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA04_P]
set_property IOSTANDARD LVCMOS18 [get_ports FMC1_HPC_LA05_P]

##===================================================================================================##
##===================================================================================================##