#Pinout 
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"

set_location_assignment PIN_B4  -to HSMA_TX_D_P0
set_location_assignment PIN_C9  -to HSMA_TX_D_P1
set_location_assignment PIN_B5  -to HSMA_TX_D_P2
set_location_assignment PIN_A12 -to HSMA_TX_D_P3
set_location_assignment PIN_C6  -to HSMA_TX_D_P4
set_location_assignment PIN_C13 -to HSMA_TX_D_P5

set_instance_assignment -name IO_STANDARD "1.5 V" -to CLKIN_50
set_location_assignment PIN_V28 -to CLKIN_50

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to HSMB_RX_2
set_location_assignment PIN_J2 -to HSMB_RX_2
set_location_assignment PIN_J1 -to HSMB_RX_2(n)

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to HSMB_TX_2
set_location_assignment PIN_H4 -to HSMB_TX_2
set_location_assignment PIN_H3 -to HSMB_TX_2(n)

set_instance_assignment -name IO_STANDARD LVDS -to REFCLK_QL3
set_location_assignment PIN_P10 -to REFCLK_QL3(n)
set_location_assignment PIN_R11 -to REFCLK_QL3

set_instance_assignment -name IO_STANDARD "1.5 V" -to SMA_CLKOUT
set_location_assignment PIN_AF33 -to SMA_CLKOUT

set_location_assignment PIN_AH27 -to USER_LED[7]
set_location_assignment PIN_AC22 -to USER_LED[6]
set_location_assignment PIN_AJ27 -to USER_LED[5]
set_location_assignment PIN_AF25 -to USER_LED[4]
set_location_assignment PIN_AL31 -to USER_LED[3]
set_location_assignment PIN_AK29 -to USER_LED[2]
set_location_assignment PIN_AE25 -to USER_LED[1]
set_location_assignment PIN_AM23 -to USER_LED[0]

set_location_assignment PIN_AK13 -to USER_PB0