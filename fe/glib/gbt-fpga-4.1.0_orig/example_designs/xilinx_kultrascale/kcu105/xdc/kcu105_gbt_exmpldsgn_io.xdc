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
##=======##
## RESET ##
##=======##

# IO_25_VRP_34
set_property PACKAGE_PIN AN8 [get_ports CPU_RESET]
set_property IOSTANDARD LVCMOS18 [get_ports CPU_RESET]

##==========##
## MGT(GTX) ##
##==========##

## SERIAL LANES:
##--------------

# MGTXTXP2_117
# MGTXTXN2_117
# MGTXRXP2_117
# MGTXRXN2_117
set_property PACKAGE_PIN T1 [get_ports SFP_RX_N]
set_property PACKAGE_PIN T2 [get_ports SFP_RX_P]
set_property PACKAGE_PIN U3 [get_ports SFP_TX_N]
set_property PACKAGE_PIN U4 [get_ports SFP_TX_P]

## SFP CONTROL:
##-------------

# IO_0_12
set_property PACKAGE_PIN AL8 [get_ports SFP_TX_DISABLE]
set_property IOSTANDARD LVCMOS18 [get_ports SFP_TX_DISABLE]

##====================##
## SIGNALS FORWARDING ##
##====================##

## SMA OUTPUT:
##------------

# IO_L1P_T0_12
set_property PACKAGE_PIN H27 [get_ports USER_SMA_GPIO_P]
set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_P]
set_property SLEW FAST [get_ports USER_SMA_GPIO_P]

set_property PACKAGE_PIN G27 [get_ports USER_SMA_GPIO_N]
set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_N]
set_property SLEW FAST [get_ports USER_SMA_GPIO_N]

##===================================================================================================##
##===================================================================================================##

