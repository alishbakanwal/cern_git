############## IOSTANDARD - NET ################## 

set_instance_assignment -name IO_STANDARD "CURRENT MODE LOGIC (CML)"               -to	SFP_RX
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O"            -to	SFP_TX
set_instance_assignment -name IO_STANDARD "1.8V"            					   -to	SFP_DISABLE
set_instance_assignment -name IO_STANDARD "LVDS"								   -to  REF_CLOCK
set_instance_assignment -name IO_STANDARD "LVDS"								   -to  SYS_CLK_100MHz
set_instance_assignment -name IO_STANDARD "1.8V"								   -to  SMA_TX_P
set_instance_assignment -name IO_STANDARD "1.8V"								   -to  SMA_TX_N
set_instance_assignment -name IO_STANDARD "1.8V"								   -to  SYS_RESET_N

############## LOCATION - NET ################## 


set_location_assignment PIN_AA42       -to    SFP_RX
set_location_assignment PIN_AB44       -to    SFP_TX
set_location_assignment PIN_AR35       -to	  SFP_DISABLE
set_location_assignment PIN_AA37	   -to    REF_CLOCK
set_location_assignment PIN_AR36	   -to    SYS_CLK_100MHz
set_location_assignment PIN_C42 	   -to    SMA_TX_P
set_location_assignment PIN_C41 	   -to    SMA_TX_N
set_location_assignment PIN_BD27	   -to    SYS_RESET_N

# Commit assignments
export_assignments
