# -*- coding: cp1252 -*-
#  Import the PyChips code - PYTHONPATH must be set to the PyChips installation src folder!
from PyChipsUser import *
from time import sleep
from struct import *
import sys
from time import *




########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
#ipaddr = "192.168.0.111"
glibAddrTable = AddressTable("./glibAddrTable.dat")
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"
########################################








######*********INIT AT STARTUP*********######

# aclr enabled
glib.write("PC_config_ok",0)

# init handshake
glib.write("PC_end_readout",0)
glib.write("SRAM1_end_readout",0)
glib.write("SRAM2_end_readout",0)

# init user CMD_START
glib.write("CMD_START_BY_PC", 0)  # if 1 : CMD_START sent

# init sram 
#sram1 user -- 0: ipbus, 1: user
glib.write("sram1_user_logic", 1)
#sram2 user -- 0: ipbus, 1: user
glib.write("sram2_user_logic", 1)



# Internal OSC_CLK 
# Init xpoint1 into GLIBv3 to route OSC_CLK = xpoint1_in2 towards xpoint1_out1
# At GLIBv3 startup, they are the default values into the GLIBv3 / it is just a precaution
glib.write("xpoint1_s10", 0)
glib.write("xpoint1_s11", 1)





#v4 sram_altern
#cst
CBC_PACKET_SIZE         = 78 #294 #42 #78 #42<=>2FE / 78<=>4FE 
CBC_PACKET_NUMBER_TRUE  = 1 #2**10 # 1 <=> 1 / inf_round(2**21/10) => round/lacks last addr
sizeAcq                 = CBC_PACKET_NUMBER_TRUE * CBC_PACKET_SIZE #size of SRAM to read 
nbAcq                   = 10000 #1000000 or 1 
loop_counter            = 0
shiftReadout            = 0
diff_event_count        = 0
cbc_error_count         = 0
sram_test_count         = 0


#--> TLU
glib.write("POLARITY_TLU", 1) # 1 : negative (falling edge to detect)

#--> FPGA_CLKOUT_MUXSEL : 0 : tx_frame_clk / 1 : cbc_trigger(0)
glib.write("FPGA_CLKOUT_MUXSEL", 0)
glib.write("FPGA_CLKOUT_MUXSEL_NEW", 2)

##case to_integer(unsigned(FPGA_CLKOUT_MUXSEL_NEW)) is --5b
##when 0 =>
##	FPGA_CLKOUT_O <= tx_frame_clk;
##when 1 =>
##	FPGA_CLKOUT_O <= tlu_trigger_i;
##when 2 =>
##	FPGA_CLKOUT_O <= tlu_trigger_del(0);	
##when 3 =>
##	FPGA_CLKOUT_O <= tlu_trigger_del(1);
##when 4 =>
##	FPGA_CLKOUT_O <= tlu_trigger_del(2);
##when 5 =>
##	FPGA_CLKOUT_O <= L1A_VALID;
##when 6 =>
##	FPGA_CLKOUT_O <= L1A_VALID_del1;				
##when 7 =>
##	FPGA_CLKOUT_O <= cbc_t1_trigger(0);	
##when 8 =>
##	FPGA_CLKOUT_O <= cbc_t1_trigger(1);					
##when 9 =>
##	FPGA_CLKOUT_O <= tlu_busy_o;	
##when 10 =>
##	FPGA_CLKOUT_O <= cbc_fast_reset(0);	
##when 11 =>
##	FPGA_CLKOUT_O <= cbc_fast_reset(1);	
##when 12 =>
##	FPGA_CLKOUT_O <= cbc_test_pulse(0);	
##when 13 =>
##	FPGA_CLKOUT_O <= cbc_test_pulse(1);					
##when 14 =>
##	FPGA_CLKOUT_O <= TDC_COUNTER_FIFO_WR_EN;	 
##when 15 =>
##	FPGA_CLKOUT_O <= fifo2_busy;	
##when 16 =>
##	FPGA_CLKOUT_O <= CBC_user_sram_write_cycle(sram1);	
##when 17 =>
##	FPGA_CLKOUT_O <= CBC_user_sram_write_cycle(sram2);				
##when 18 =>
##	FPGA_CLKOUT_O <= TIME_TRIGGER_FIFO_EMPTY;	
##when 19 =>
##	FPGA_CLKOUT_O <= CBC_DATA_FIFO_EMPTY(0,0);
##when 20 =>
##	FPGA_CLKOUT_O <= CBC_DATA_FIFO_EMPTY(0,1);
##when 21 =>
##	FPGA_CLKOUT_O <= CBC_COUNTER_FIFO_EMPTY(0,0);
##when 22 =>
##	FPGA_CLKOUT_O <= CBC_COUNTER_FIFO_EMPTY(0,1);
##when 23 =>
##	FPGA_CLKOUT_O <= CBC_STUBDATA_FIFO_EMPTY(0);	
##when 24 =>
##	FPGA_CLKOUT_O <= TDC_COUNTER_FIFO_EMPTY;
##when 25 =>
##	FPGA_CLKOUT_O <= ALL_FIFOS_ARE_EMPTY;
##when 26 =>
##	FPGA_CLKOUT_O <= ALL_FIFOS_ARE_NOT_EMPTY;				
##when others =>
##	FPGA_CLKOUT_O <= tx_frame_clk;
##end case;





#--> CBC_HARD_RESET
sleep(0.500)
glib.write("cbc_hard_reset_fe1", 0)
sleep(0.500)
glib.write("cbc_hard_reset_fe1", 0)


#--> COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID
glib.write("COMMISSIONNING_MODE_CBC_TEST_PULSE_VALID", 1) # 1 : EN

#--> COMMISSIONNING_MODE_CBC_FAST_RESET_VALID
glib.write("COMMISSIONNING_MODE_CBC_FAST_RESET_VALID", 1) # 1 : EN


#--> COMMISSIONNING_MODE DELAY
glib.write("COMMISSIONNING_MODE_DELAY_AFTER_FAST_RESET", 30000) 
glib.write("COMMISSIONNING_MODE_DELAY_AFTER_TEST_PULSE", 30000)
glib.write("COMMISSIONNING_MODE_DELAY_AFTER_L1A", 30000)

#--> COMMISSIONNING_MODE DELAY
glib.write("COMMISSIONNING_MODE_LOOPS_NB", CBC_PACKET_NUMBER_TRUE*2*100)

#--> COMMISSIONNING_MODE_RQ
glib.write("COMMISSIONNING_MODE_RQ", 1) # 1 : EN




#########****************************PARAMETERS****************************######
#--> trigger sel
glib.write("TRIGGER_SEL", 0)          #0 : internal trigger / 1 : l1a trigger from TTC_FMC
#--> Internal Trigger - Freq selection
glib.write("INT_TRIGGER_FREQ", 0)    # 0:1Hz / 1:2Hz / 2:4Hz / 3:8Hz / 4:16Hz / 5:32Hz / 6:64Hz / 7:128Hz / 8:256Hz / 9:512Hz / 10:1024Hz / 11:2048Hz / 12:4096Hz / 13:8192Hz / 14:16384Hz / 15:32768Hz	
#--> Acq mode
glib.write("ACQ_MODE", 1)             # 0 : trigger-controlled / 1 : storage in continue
#--> Readout - Packet Number in SRAM if ACQ_MODE = '1' (storage in continue)
glib.write("CBC_DATA_PACKET_NUMBER", CBC_PACKET_NUMBER_TRUE-1) #0 <=> 1 / inf_round(2^21/10-1) <=> inf_round(2^21/10)
#--> type of CBC DATA
glib.write("CBC_DATA_GENE", 1)        # 0 : internal data / 1 : from cbcv1 + cbc_receiver
#--> CBC_MASK: 0: NO / 1: Mask CBC0 / 2: Mask CBC1.../ 128 : Mask CBC7
glib.write("CBC_MASK_FE1", 0)
#--> BC_CLK dephasing to well deserialise CBD data (usefull if CBC_DATA_GENE = '1')
#glib.write("CLK_DEPHASING", 0)        # 0 : 0° / 1 : 180°
#--> Polarity select of serialised cbc data input (usefull if CBC_DATA_GENE = '1')
#glib.write("POLARITY_CBC", 1)         # 0 : positive / 1 : negative
#--> Spurious Frame emulator
glib.write("SPURIOUS_FRAME", 0)       # 1 : start a spurious frame (useful for debug)
#--> POLARITY_sTTS
#glib.write("POLARITY_sTTS", 1)        # 0 : positive
#--> User CMD_START (useful if TTC_FMC not connected)
glib.write("CMD_START_BY_PC", 1)      # 1 : CMD_START sent
#--> Flag End of SW configuration
glib.write("PC_config_ok",1)          # 1 : CMD_START sent
#########****************************PARAMETERS****************************######
		    

#########****************************ACQUISITION****************************######
f = open('acq_cbc_data.dat', 'wb')
#acq
for iAcq in range(nbAcq):
    #loop counter
    loop_counter = loop_counter + 1
    
    #spurious frame / Debug
    if loop_counter==4: #set 
        glib.write("SPURIOUS_FRAME", 0) 

    print "\nwaiting CMD_START..."
    while glib.read("CMD_START_VALID")==0: 
        sleep(0.100)

    #SRAM1
    print "\nCBC DATA in acq...waiting SRAM1_FULL..."
    
    while glib.read("SRAM1_full")==0:
        sleep(0.100)
##        print "\nCBC DATA in acq...waiting SRAM1_FULL..."
##        #Flags for debug
##        print "\n[los,lol,lock,fifo2_full,fifo1_full] is:",bin(glib.read("sTTS_all_failures"))
##        print "\nsTTS_code is:",bin(glib.read("sTTS_code"))

    print"-> --------------------------------------------------------------------"
    print "-> SRAM1 READOUT"
    print "-> --------------------------------------------------------------------"
      
    #Flags for debug
    print "\nSRAM1_full detected"
    print "\nSRAM1_end_readout is:",glib.read("SRAM1_end_readout")
    print "\nspurious_frame_detect is:",glib.read("spurious_frame_detect")
    print "\nsTTS_code is:",bin(glib.read("sTTS_code"))

    # SRAM1 Readout

    #SRAM1 ctrl
    #SRAM1 ipbus -- 0: ipbus, 1: user
    glib.write("sram1_user_logic", 0)
    sleep(0.010)

    #SRAM1 BlockRead
    SRAM1DATA=glib.blockRead("sram1", sizeAcq, 0)
    
    #SRAM1 ctrl
    #SRAM1 ipbus -- 0: ipbus, 1: user
    glib.write("sram1_user_logic", 1) 

    #SRAM1 End Readout
    glib.write("SRAM1_end_readout", 1) 

    #Handshaking SW/VHDL
    while glib.read("SRAM1_full")==1:
        sleep(0.100)     
    glib.write("SRAM1_end_readout", 0) # raz

##    #store into file
##    print "sample size:", str(len(pack('>l', SRAM1DATA[0]))),"Bytes"
##    for word in SRAM1DATA[shiftReadout:]:
##        f.write(pack('>l', word))
##        #f.write(pack('>H', word))
  


    ################DISP SRAM1##########################
    #display SRAM1 Data
    print "\nSRAM1 Data Readout of", str(len(SRAM1DATA)-shiftReadout),"words for acquisition n°",loop_counter
    #print "\nSRAM1 Block read result is:", uInt32HexListStr(SRAM1DATA)
    print "\nSRAM1 Block read result is:", uInt32HexListStr(SRAM1DATA[0:CBC_PACKET_SIZE])  #CBC_PACKET_SIZE not comprised  
    #print "\nlen(SRAM1DATA) is:", str(len(SRAM1DATA)-shiftReadout)
    #print "\nsizeAcq is:", sizeAcq
    ######################DISP##########################



##    ######################TESTS##########################
##    #test difference between L1A_COUNTER & CBC_COUNTER
##    l1a_count = SRAM1DATA[3]
##    cbc_count = SRAM1DATA[4] 
##    if l1a_count!=cbc_count:
##        diff_event_count = diff_event_count + 1
##    print "\ndiff_event_count = ",diff_event_count

##    for i_pack_nb in range(CBC_PACKET_NUMBER_TRUE):
##        l1a_count = SRAM1DATA[3+i_pack_nb*CBC_PACKET_SIZE]
##        cbc_count = SRAM1DATA[4+i_pack_nb*CBC_PACKET_SIZE]
##        if l1a_count!=cbc_count:
##            diff_event_count = diff_event_count + 1
##            #print "\nSRAM1 Block read result is:", uInt32HexListStr(SRAM1DATA[0+(i_pack_nb-10)*CBC_PACKET_SIZE:9+i_pack_nb*CBC_PACKET_SIZE])
##    print "\ndiff_event_count = ",diff_event_count  
##
##    ######################TESTS########################## 

    


    #SRAM2
    print "\nCBC DATA in acq...waiting SRAM2_FULL..."
    while glib.read("SRAM2_full")==0:
        sleep(0.100)
##        print "\nCBC DATA in acq...waiting SRAM2_FULL..."
##        #Flags for debug
##        print "\n[los,lol,lock,fifo2_full,fifo1_full] is:",bin(glib.read("sTTS_all_failures"))
##        print "\nsTTS_code is:",bin(glib.read("sTTS_code"))        

    print"-> --------------------------------------------------------------------"
    print "-> SRAM2 READOUT"
    print "-> --------------------------------------------------------------------"

    #Flags for debug
    print "\nSRAM2_full detected"
    print "\nSRAM2_end_readout is:",glib.read("SRAM2_end_readout")
    print "\nspurious_frame_detect is:",glib.read("spurious_frame_detect")
    print "\nsTTS_code is:",bin(glib.read("sTTS_code"))

    # SRAM2 Readout

    #SRAM2 ctrl
    #SRAM2 ipbus -- 0: ipbus, 1: user
    glib.write("sram2_user_logic", 0)
    sleep(0.010)

    #SRAM2 BlockRead
    SRAM2DATA=glib.blockRead("sram2", sizeAcq, 0)
    
    #SRAM2 ctrl
    #SRAM2 ipbus -- 0: ipbus, 1: user
    glib.write("sram2_user_logic", 1) 

    #SRAM2 End Readout
    glib.write("SRAM2_end_readout", 1) 

    #Handshaking SW/VHDL
    while glib.read("SRAM2_full")==1:
        sleep(0.100)     
    glib.write("SRAM2_end_readout", 0) # raz

##    #store into file
##    print "sample size:", str(len(pack('>l', SRAM2DATA[0]))),"Bytes"
##    for word in SRAM2DATA[shiftReadout:]:
##        f.write(pack('>l', word))
##        #f.write(pack('>H', word))



    ######################DISP SRAM2##########################
    #display SRAM2 Data
    print "\nSRAM2 Data Readout of", str(len(SRAM2DATA)-shiftReadout),"words for acquisition n°",loop_counter
    #print "\nSRAM2 Block read result is:", uInt32HexListStr(SRAM2DATA)
    print "\nSRAM2 Block read result is:", uInt32HexListStr(SRAM2DATA[0:CBC_PACKET_SIZE])        
    #print "\nlen(SRAM2DATA) is:", str(len(SRAM2DATA)-shiftReadout)
    #print "\nsizeAcq is:", sizeAcq
    ######################DISP SRAM2##########################

    

##    ######################TESTS##########################
##    #test difference between L1A_COUNTER & CBC_COUNTER
##    l1a_count = SRAM2DATA[3]
##    cbc_count = SRAM2DATA[4]
##    if l1a_count!=cbc_count:
##        diff_event_count = diff_event_count + 1
##    print "\ndiff_event_count = ",diff_event_count

##    for i_pack_nb in range(CBC_PACKET_NUMBER_TRUE): #0 to end-1
##        l1a_count = SRAM2DATA[3+i_pack_nb*CBC_PACKET_SIZE]
##        cbc_count = SRAM2DATA[4+i_pack_nb*CBC_PACKET_SIZE]
##        if l1a_count!=cbc_count:
##            diff_event_count = diff_event_count + 1
##    print "\ndiff_event_count = ",diff_event_count  

##    ######################TESTS##########################    

print "\nEnd Readout"
f.close()

