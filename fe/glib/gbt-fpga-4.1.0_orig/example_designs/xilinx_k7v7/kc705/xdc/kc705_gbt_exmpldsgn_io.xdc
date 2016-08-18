##===================================================================================================##
##========================= Xilinx design constraints (XDC) information =============================##
##===================================================================================================##
##
## Company:               WUT (ISE PERG)
## Engineer:              Adrian Byszuk (a.byszuk@elka.pw.edu.pl)
##
## Project Name:          GBT-FPGA
## XDC File Name:         KC705 - GBT Bank example design I/O
##
## Target Device:         KC705 (Xilinx Kintex 7)
## Tool version:          Vivado 2014.4
##
## Version:               4.0
##
## Description:
##
## Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
##
##                        17/12/2014   1.0       Julian Mendez       First .xdc definition
##
## Additional Comments:
##
##===================================================================================================##
##===================================================================================================##

##===================================================================================================##
##========================================  I/O PINS  ===============================================##
##===================================================================================================##

##====================##
## Configuration pins ##
##====================##
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

##=======##
## RESET ##
##=======##

# IO_25_VRP_34
set_property PACKAGE_PIN AB7 [get_ports CPU_RESET]
set_property IOSTANDARD LVCMOS15 [get_ports CPU_RESET]

##==========##
## MGT(GTX) ##
##==========##

## SERIAL LANES:
##--------------

# MGTXTXP2_117
# MGTXTXN2_117
# MGTXRXP2_117
# MGTXRXN2_117
set_property PACKAGE_PIN G3 [get_ports SFP_RX_N]
set_property PACKAGE_PIN G4 [get_ports SFP_RX_P]
set_property PACKAGE_PIN H1 [get_ports SFP_TX_N]
set_property PACKAGE_PIN H2 [get_ports SFP_TX_P]

## SFP CONTROL:
##-------------

# IO_0_12
set_property PACKAGE_PIN Y20 [get_ports SFP_TX_DISABLE]
set_property IOSTANDARD LVCMOS25 [get_ports SFP_TX_DISABLE]

##===============##
## ON-BOARD LEDS ##
##===============##

# IO_L2N_T0_33
set_property PACKAGE_PIN AB8 [get_ports GPIO_LED_0_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_0_LS]
# IO_L2P_T0_33
set_property PACKAGE_PIN AA8 [get_ports GPIO_LED_1_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_1_LS]
# IO_L3N_T0_DQS_33
set_property PACKAGE_PIN AC9 [get_ports GPIO_LED_2_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_2_LS]
# IO_L3P_T0_DQS_33
set_property PACKAGE_PIN AB9 [get_ports GPIO_LED_3_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_3_LS]
# IO_25_13
set_property PACKAGE_PIN AE26 [get_ports GPIO_LED_4_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_4_LS]
# IO_0_17
set_property PACKAGE_PIN G19 [get_ports GPIO_LED_5_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_5_LS]
# IO_25_17
set_property PACKAGE_PIN E18 [get_ports GPIO_LED_6_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_6_LS]
# IO_25_18
set_property PACKAGE_PIN F16 [get_ports GPIO_LED_7_LS]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_LED_7_LS]

##====================##
## SIGNALS FORWARDING ##
##====================##

## SMA OUTPUT:
##------------

# IO_L1P_T0_12
set_property PACKAGE_PIN Y23 [get_ports USER_SMA_GPIO_P]
set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_P]
set_property SLEW FAST [get_ports USER_SMA_GPIO_P]

set_property PACKAGE_PIN Y24 [get_ports USER_SMA_GPIO_N]
set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_N]
set_property SLEW FAST [get_ports USER_SMA_GPIO_N]

## PATTERN MATCH FLAGS:
##---------------------

# IO_L12P_T1_MRCC_16
set_property PACKAGE_PIN C25 [get_ports FMC_HPC_LA00_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA00_CC_P]
set_property SLEW FAST [get_ports FMC_HPC_LA00_CC_P]
# IO_L11P_T1_SRCC_16
set_property PACKAGE_PIN D26 [get_ports FMC_HPC_LA01_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA01_CC_P]
set_property SLEW FAST [get_ports FMC_HPC_LA01_CC_P]

## CLOCKS FORWARDING:
##-------------------

# IO_L19P_T3_16
set_property PACKAGE_PIN H24 [get_ports FMC_HPC_LA02_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA02_P]
set_property SLEW FAST [get_ports FMC_HPC_LA02_P]
# IO_L23P_T3_16
set_property PACKAGE_PIN H26 [get_ports FMC_HPC_LA03_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA03_P]
set_property SLEW FAST [get_ports FMC_HPC_LA03_P]
# IO_L20P_T3_16
set_property PACKAGE_PIN G28 [get_ports FMC_HPC_LA04_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA04_P]
set_property SLEW FAST [get_ports FMC_HPC_LA04_P]
# IO_L22P_T3_16
set_property PACKAGE_PIN G29 [get_ports FMC_HPC_LA05_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_HPC_LA05_P]
set_property SLEW FAST [get_ports FMC_HPC_LA05_P]

##===================================================================================================##
##===================================================================================================##

