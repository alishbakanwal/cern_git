##===================================================================================================##
##========================= Xilinx design constraints (XDC) information =============================##
##===================================================================================================##
##                                                                                         
## Company:               WUT (ISE PERG)                                                         
## Engineer:              Adrian Byszuk (a.byszuk@elka.pw.edu.pl)
##                                                                                                 
## Project Name:          GBT-FPGA                                                                
## XDC File Name:         KC705 - GBT Bank example design timing closure                                        
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
##====================================  TIMING CLOSURE  =============================================##
##===================================================================================================##

##=================================================##
## Latency-Optimized (LATOPT) specific constraints ##
##=================================================##

##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##                                                                           ##
## Comment: Note!! Uncomment out the following constraints when implementing ## 
##                 the Latency-Optimized (LATOPT) version.                   ##
##                                                                           ## 
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##
##!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##

## GBT TX:
##--------

## RX Phase Aligner
##-----------------
## Comment: The period of TX_FRAMECLK is 25ns but "TS_GBTTX_SCRAMBLER_TO_GEARBOX" is set to 16ns, providing 9ns for setup margin.
#set_max_delay 16 -from [get_pins -hier -filter {NAME =~ */*/*/scrambler/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/txGearbox/*/D}] -datapath_only

## GBT RX:
##--------

## Comment: The period of RX_FRAMECLK is 25ns but "TS_GBTRX_GEARBOX_TO_DESCRAMBLER" is set to 20ns, providing 5ns for setup margin.
#set_max_delay 20 -from [get_pins -hier -filter {NAME =~ */*/*/rxGearbox/*/C}] -to [get_pins -hier -filter {NAME =~ */*/*/descrambler/*/D}] -datapath_only

##===================================================================================================##
##===================================================================================================##