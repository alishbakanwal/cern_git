from PyChipsUser import *
import sys
import os
glibAddrTable = AddressTable("./glibAddrTable.dat")

spi_comm = 0x8FA38014;
cdce_settings = [0,1,2,3,4,5,6,7,8,0] 


################----------------------------------------------################
#cdce_settings[0] = 0xEB840320 # reg0 (out0=240MHz,LVDS, phase shift  0deg)
cdce_settings[0] = 0xEB840720 # reg0 (out0=240MHz,LVDS, phase shift  90deg)
#cdce_settings[0] = 0xEB840B20 # reg0 (out0=240MHz,LVDS, phase shift 180deg)
#cdce_settings[0] = 0xEB840F20 # reg0 (out0=240MHz,LVDS, phase shift 270deg)

cdce_settings[1] = 0xEB020321 # reg1 (out1=160MHz,LVDS)

cdce_settings[2] = 0xEB020302 # reg2 (out2=160MHz,LVDS)

#cdce_settings[3] = 0xEB840303 # reg3 (out3=240MHz,LVDS, phase shift  0deg)
#cdce_settings[3] = 0xEB840703 # reg3 (out3=240MHz,LVDS, phase shift 90deg)
#cdce_settings[3] = 0xEB840B03 # reg0 (out3=240MHz,LVDS, phase shift 180deg)
cdce_settings[3] = 0xEB840F03 # reg0 (out3=240MHz,LVDS, phase shift 270deg)

#ERROR on reg4!!!
#cdce_settings[4] = 0x6B140334 # reg4 (out4= 40MHz,LVDS, R4.1=1, ph4adjc=0)

#reg5 to modify
#cdce_settings[5] = 0x013C0CF5 # reg5 (LVDS in, DC term, PRIM REF enable, SEC REF enable, smartMUX off, etc.)

cdce_settings[6] = 0x33041BE6 # reg6 (VCO1, PS=4, FD=12, FB=1, ChargePump 50uA, Internal Filter, R6.20=0, AuxOut= enable; AuxOut= Out2)

cdce_settings[7] = 0xBD800DF7 # reg7 (C2=473.5pF, R2=98.6kR, C1=0pF, C3=0pF, R3=5kR etc, SEL_DEL2=1, SEL_DEL1=1)

#reg8 to modify
#cdce_settings[8] = 0x20009978 # reg8 (various)};
################----------------------------------------------################

#lcharles
cdce_settings[4] = 0xEB140334 # reg4 (out4= 40MHz,LVDS, R4.1=1, ph4adjc=0)
cdce_settings[5] = 0x013C0CF5
cdce_settings[8] = 0x20009978



########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"
########################################



########################################
# phase shift arguments
########################################

# out4 divide ratio = 4 
# out4 steps    [ 0, 1, 2, 3] (taken from cdce datasheet page 49, Table 25)
outclk0_phadj_lut = [ 0, 4, 8, 12]
outclk3_phadj_lut = [ 0, 4, 8, 12]

# out4 divide ratio = 24 
# out4 steps    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,23,23] (taken from cdce datasheet page 49, Table 25)
outclk4_phadj_lut = [ 0, 1, 2, 3, 8, 9,10,11,16,17,18,19,24,25,26,27,32,33,34,35,40,41,42,43]


arguments = len(sys.argv)
if (arguments>1):
	phadjc0 = int(sys.argv[1])
	cdce_settings[0] = (cdce_settings[0] & 0xfffe03ff) + ((outclk4_phadj_lut[phadjc0] & 0x7f)*(2**10))

if (arguments>2):
	phadjc3 = int(sys.argv[2])
	cdce_settings[3] = (cdce_settings[3] & 0xfffe03ff) + ((outclk4_phadj_lut[phadjc3] & 0x7f)*(2**10))
if (arguments>3):
	phadjc4 = int(sys.argv[3])	
	cdce_settings[4] = (cdce_settings[4] & 0xfffe03ff) + ((outclk4_phadj_lut[phadjc4] & 0x7f)*(2**10))

	


print
print "-> writing CDCE62005 registers"
print
for i in range(0,9):
	glib.write("spi_txdata",cdce_settings[i])
	print "-> writing",uInt32HexStr(cdce_settings[i]), "to register",'%02d' % i
	glib.write("spi_command", spi_comm)
	glib.read("spi_rxdata") # dummy read
	glib.read("spi_rxdata") # dummy read


print
print "--=======================================--"
print
print 
