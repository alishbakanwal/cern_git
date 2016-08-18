#  Import the PyChips code - PYTHONPATH must be set to the PyChips installation src folder!
from PyChipsUser import *
from time import sleep
from struct import *
import sys
from time import *

# Read in an address table by creating an AddressTable object (Note the forward slashes, not backslashes!)
glibAddrTable = AddressTable("glibAddrTable.dat")


# Create a ChipsBus bus to talk to your board.
# These require an address table object, an IP address and a port number
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
#ipaddr = "192.168.0.111"
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"

#=>LIST : file storing all the reg names + access page + @ + def val + wr val
#i2cAddrTableFile = "CBCv2_i2cSlaveAddrTable.txt"
#i2cAddrTableFile = "FE0CBC0.txt"
#i2cAddrTableFile = "CommissMode2.txt"


FE0_CBC0_i2cAddrTableFile = "FE0CBC0.txt"
FE0_CBC1_i2cAddrTableFile = "FE0CBC1.txt"
FE0_CBC2_i2cAddrTableFile = "FE0CBC2.txt"
FE0_CBC3_i2cAddrTableFile = "FE0CBC3.txt"
FE0_CBC4_i2cAddrTableFile = "FE0CBC4.txt"
FE0_CBC5_i2cAddrTableFile = "FE0CBC5.txt"
FE0_CBC6_i2cAddrTableFile = "FE0CBC6.txt"
FE0_CBC7_i2cAddrTableFile = "FE0CBC7.txt"


##FE1_CBC0_i2cAddrTableFile = "FE1CBC0.txt"
##FE1_CBC1_i2cAddrTableFile = "FE1CBC1.txt"


FE_NB   = 1
CBC_NB  = 8



#glib.write("PC_config_ok",0)
sleep(0.500)
glib.write("cbc_hard_reset_fe1", 0)
##sleep(0.500)
##glib.write("cbc_hard_reset_fe1", 0)
glib.write("PC_config_ok",0)
sleep(0.500)


#cmd_req : 1 = Rd / 3 = Wr
cbc_i2c_cmd_rd = 1
cbc_i2c_cmd_wr = 3
cbc_i2c_cmd_rq = cbc_i2c_cmd_rd
##CBC2_A = 0
##CBC2_B = 1
##cbcSel = CBC2_A 
sram_used_for_i2c = "sram1" # fixed by VHDL



if sram_used_for_i2c == "sram1":
    sram_used_for_i2c_ipbusCtrl = "sram1_user_logic"
else:
    sram_used_for_i2c_ipbusCtrl = "sram2_user_logic"


# init sram 
#sram user -- 0: ipbus, 1: user
glib.write(sram_used_for_i2c_ipbusCtrl, 1)


#set FFFFFFFF on sram not used
FLAG_END = 0xffffffff


    
##print
##print "-> set sram_not_used_for_i2c =", sram_not_used_for_i2c, "controlled by ipbus"
##glib.write(sram_not_used_for_i2c_ipbusCtrl,0)
##print
##print "->",1,"word block write to",sram_not_used_for_i2c,"..."
##glib.blockWrite(sram_not_used_for_i2c, FLAG_END)
##print
##print "-> set sram_not_used_for_i2c =", sram_not_used_for_i2c, "controlled by user"
##glib.write(sram_not_used_for_i2c_ipbusCtrl,1)
##print

    


print "--=======================================--"
print "  I2C File Analysis"
print "--=======================================--"

###=>LIST : file storing all the reg names + access page + @ + def val + wr val
regNameSizeMax = 0

# To knwow exactly the number of registers from the file CBCv1_i2cSlaveAddrTable.txt
file = open(FE0_CBC0_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 0
while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            if len(words[0]) > regNameSizeMax:  # to know regNamesize_max
                regNameSizeMax = len(words[0])
            lineNum += 1
    line = file.readline()  # Get the next line and start again.
file.close()
#print lineNum


# Vectors Init
Page	= range(lineNum*FE_NB*CBC_NB)
regName = range(lineNum*FE_NB*CBC_NB)
regAddr = range(lineNum*FE_NB*CBC_NB)
defData = range(lineNum*FE_NB*CBC_NB)
wrData  = range(lineNum*FE_NB*CBC_NB)


feSel   = range(lineNum*FE_NB*CBC_NB) #feSel
cbcSel  = range(lineNum*FE_NB*CBC_NB) 




# File reading FE0_CBC0
file = open(FE0_CBC0_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
index = 0
regNameSize = regNameSizeMax #30
regNameAdd = '_'


while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index]  = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]     = int(words[1], 16)
            regAddr[index]  = int(words[2], 16)
            defData[index]  = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 0
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC1
file = open(FE0_CBC1_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 1            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC2
file = open(FE0_CBC2_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 2            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC3
file = open(FE0_CBC3_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 3            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC4
file = open(FE0_CBC4_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 4            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC5
file = open(FE0_CBC5_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 5            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC6
file = open(FE0_CBC6_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 6            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


# File reading FE0_CBC7
file = open(FE0_CBC7_i2cAddrTableFile, 'r')
line = file.readline() # Get the first line
lineNum = 1
#index = index + 1

while len(line) != 0:  # i.e. not the end of the file
    words = line.split()   # Split up the line into words by its whitespace
    if len(words) != 0:  # A blank line (or a line with just whitespace).
        if line[0] != '*':  # Not a commented line
            if len(words) < 5:
                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
                                "' does not conform to file format expectations!")
            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
            Page[index]    = int(words[1], 16)
            regAddr[index] = int(words[2], 16)
            defData[index] = int(words[3], 16)
            feSel[index]   = 0
            cbcSel[index]  = 7            
            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
                wrData[index]  = 85 #0
            else:
                wrData[index]  = int(words[4], 16)
            index=index+1   
    line = file.readline()  # Get the next line and start again.
    lineNum += 1
file.close()


### File reading FE1_CBC0
##file = open(FE1_CBC0_i2cAddrTableFile, 'r')
##line = file.readline() # Get the first line
##lineNum = 1
###index = index + 1
##
##while len(line) != 0:  # i.e. not the end of the file
##    words = line.split()   # Split up the line into words by its whitespace
##    if len(words) != 0:  # A blank line (or a line with just whitespace).
##        if line[0] != '*':  # Not a commented line
##            if len(words) < 5:
##                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
##                                "' does not conform to file format expectations!")
##            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
##            Page[index]    = int(words[1], 16)
##            regAddr[index] = int(words[2], 16)
##            defData[index] = int(words[3], 16)
##            feSel[index]   = 1
##            cbcSel[index]  = 0            
##            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
##                wrData[index]  = 85 #0
##            else:
##                wrData[index]  = int(words[4], 16)
##            index=index+1   
##    line = file.readline()  # Get the next line and start again.
##    lineNum += 1
##file.close()
##
### File reading FE1_CBC1
##file = open(FE1_CBC1_i2cAddrTableFile, 'r')
##line = file.readline() # Get the first line
##lineNum = 1
###index = index + 1
##
##while len(line) != 0:  # i.e. not the end of the file
##    words = line.split()   # Split up the line into words by its whitespace
##    if len(words) != 0:  # A blank line (or a line with just whitespace).
##        if line[0] != '*':  # Not a commented line
##            if len(words) < 5:
##                raise ChipsException("Line " + str(lineNum) + " of file '" + addressTableFile + 
##                                "' does not conform to file format expectations!")
##            regName[index] = words[0] + regNameAdd * (regNameSize - len(words[0]))
##            Page[index]    = int(words[1], 16)
##            regAddr[index] = int(words[2], 16)
##            defData[index] = int(words[3], 16)
##            feSel[index]   = 1
##            cbcSel[index]  = 1            
##            if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
##                wrData[index]  = 85 #0
##            else:
##                wrData[index]  = int(words[4], 16)
##            index=index+1   
##    line = file.readline()  # Get the next line and start again.
##    lineNum += 1
##file.close()



###display all items of i2cAddrTableFile
###
##print
##print "-> displaying i2cAddrTableFile"
##sleep(0.001)
##print
##for j in range (len(regName)):
##    print "feSel=",feSel[j],"\tcbcSel=",cbcSel[j],"\tPage=",Page[j],"\tregName=",regName[j],"\tregAddr=",hex(regAddr[j]),"\tdefData=",hex(defData[j]),"\twrData=",hex(wrData[j])





print "--=======================================--"
print "  Fill-in words in SRAM"
print "--=======================================--"

KWord = 1024
MWord = 1024*1024
mem_size = 2*MWord 
i2cWordsNb = len(regAddr) #2*MWord #1*KWord
#latency = 5
offset  = 0 #mem_size-i2cWordsNb
#lastaddr= offset+i2cWordsNb-1
WordsNbToWrite = i2cWordsNb+1

wrBuffer = []
for i in range(0, i2cWordsNb):
    #wrBuffer[i] = cbcSel<<17 | Page[i]<<16 | regAddr[i]<<8 | wrData[i]
    #wrBuffer.append(cbcSel<<17 | Page[i]<<16 | regAddr[i]<<8 | wrData[i])
    wrBuffer.append(feSel[i]<<21 | cbcSel[i]<<17 | Page[i]<<16 | regAddr[i]<<8 | wrData[i])
#flag end
wrBuffer.append(0xffffffff)






print
print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by ipbus"
glib.write(sram_used_for_i2c_ipbusCtrl,0)
print
print "->",WordsNbToWrite,"words block write to",sram_used_for_i2c,"..."
glib.blockWrite(sram_used_for_i2c, wrBuffer, offset)
print
print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by user"
glib.write(sram_used_for_i2c_ipbusCtrl,1)
print


#####display all items of blockWrite(sram)
##print
##print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by ipbus"
##glib.write(sram_used_for_i2c_ipbusCtrl,0)
##print
##print "->",WordsNbToWrite,"words block read to",sram_used_for_i2c,"..."
##SRAMDATA = glib.blockRead(sram_used_for_i2c, WordsNbToWrite, offset)
##print
##print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by user"
##glib.write(sram_used_for_i2c_ipbusCtrl,1)
##print "\nSRAM Block read result is:", uInt32HexListStr(SRAMDATA) #[0:WordsNbToWrite]) 

##sleep(0.001)
##glib.write(sram_used_for_i2c_ipbusCtrl,0)
##SRAMDATA_Wr = glib.blockRead(sram_used_for_i2c, WordsNbToWrite, offset)
##print "\nSRAMDATA_Wr is:", uInt32HexListStr(SRAMDATA_Wr) #[0:WordsNbToWrite]) 
##glib.write(sram_used_for_i2c_ipbusCtrl,1)



print "--=======================================--"
print "  SEND REQ CMD"
print "--=======================================--"


#cbc_hard_reset : 1=EN
glib.write("cbc_hard_reset_fe1", 0) #same comand now

#FPGA_CLKOUT_MUXSEL : 0=TX_FRAME_CLK / 1=T1_TRIGGER
glib.write("FPGA_CLKOUT_MUXSEL", 0)




#cmd : 0=no / 1=rd / 3=wr
glib.write("cbc_i2c_cmd_rq_fe1", cbc_i2c_cmd_rq) #cbc_i2c_cmd_rq / 0

print "--=======================================--"
print "  SLEEP"
print "--=======================================--"


sleep(1.000)



#Handshaking SW/VHDL
while glib.read("cbc_i2c_cmd_ack_fe1")==0: 
    sleep(0.100)
    print "-> cbc_i2c_cmd_ack_fe1:", glib.read("cbc_i2c_cmd_ack_fe1")

#cmd : 0=no / 1=rd / 3=wr
glib.write("cbc_i2c_cmd_rq_fe1", 0)


#Handshaking SW/VHDL
while glib.read("cbc_i2c_cmd_ack_fe1")==1: 
    sleep(0.100)
    print "-> cbc_i2c_cmd_ack_fe1:", glib.read("cbc_i2c_cmd_ack_fe1")





##cmd     = glib.read("user_wb_cbc_fmc_regs", reg_i2c_cmd_offset)
##print "cmd = ", hex(cmd)
##word    = glib.read("user_wb_cbc_fmc_regs", reg_i2c_word_offset)
##print "word = ", hex(word)
##reply   = glib.read("user_wb_cbc_fmc_regs", reg_i2c_reply_offset)
##print "reply = ", hex(reply)

    



if cbc_i2c_cmd_rq == cbc_i2c_cmd_rd:
    print "--=======================================--"
    print "  DISP SRAM - CBC I2C READING"
    print "--=======================================--"
else:
    print "--=======================================--"
    print "  DISP SRAM - CBC I2C UPDATING"
    print "--=======================================--"



        



WordsNbToRead = i2cWordsNb+1

print
print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by ipbus"
glib.write(sram_used_for_i2c_ipbusCtrl,0)
print

print "->",WordsNbToRead," words to read from sram_used_for_i2c =",sram_used_for_i2c,"..."
SramReadI2cReg = glib.blockRead(sram_used_for_i2c, WordsNbToRead, offset)
print
#print "\nsram_used_for_i2c BlockRead result is:", uInt32HexListStr(SramReadI2cReg)
print "-> sram_used_for_i2c BlockRead result is:", uInt32HexListStr(SramReadI2cReg[0:WordsNbToRead])  #WordsNbToRead not comprised  
print
print "-> set sram_used_for_i2c =", sram_used_for_i2c, "controlled by user"
glib.write(sram_used_for_i2c_ipbusCtrl,1)
print




###compare W / R
##error_detected = 0
####if cbc_i2c_cmd_rq == cbc_i2c_cmd_wr:
####    print "-> verification Rd after Write",
####    if SRAMDATA_Wr == SramReadI2cReg:
####        error_detected = 0
####    else:
####        error_detected = 1
####    print "-> error_detected =", error_detected,
##
##
##if cbc_i2c_cmd_rq == cbc_i2c_cmd_wr:
##    print "-> verification Rd after Write",
##    for i in range(0, i2cWordsNb):
##        if SRAMDATA_Wr[i] == SramReadI2cReg[i]:
##            print "-> error detected =", 0
##        else:
##            print "-> SRAMDATA_Wr index =", SRAMDATA_Wr[i]
##            print "-> SramReadI2cReg index =", SramReadI2cReg[i]






##cmd     = glib.read("user_wb_cbc_fmc_regs", reg_i2c_cmd_offset)
##print "cmd = ", hex(cmd)
##word    = glib.read("user_wb_cbc_fmc_regs", reg_i2c_word_offset)
##print "word = ", hex(word)
##reply   = glib.read("user_wb_cbc_fmc_regs", reg_i2c_reply_offset)
##print "reply = ", hex(reply)
##
###word
##dataReg     = 0x3d
##addrReg     = 0x01
##page        = 0 # 0 : page1 / 1 : page2
##cbcSel     = 0x0
##word_to_write = cbcSel<<17 | page<<16 | addrReg<<8 | dataReg
##print "word_to_write = ", hex(word_to_write)
### word 
##glib.write("user_wb_cbc_fmc_regs", word_to_write, reg_i2c_word_offset)
##
###cmd : 0=no / 1=rd / 3=wr
##glib.write("user_wb_cbc_fmc_regs", 1, reg_i2c_cmd_offset)
##
##sleep(2.000)
##
##cmd     = glib.read("user_wb_cbc_fmc_regs", reg_i2c_cmd_offset)
##print "cmd = ", hex(cmd)
##word    = glib.read("user_wb_cbc_fmc_regs", reg_i2c_word_offset)
##print "word = ", hex(word)
##reply   = glib.read("user_wb_cbc_fmc_regs", reg_i2c_reply_offset)
##print "reply = ", hex(reply)
##





#######################################
# reply(31)		<= error_rdack4;
# reply(30)		<= error_rdack3;
# reply(29)		<= error_rdack2;
# reply(28)		<= error_rdack1;
# reply(27)		<= error;
# reply(26)		<= done;
# reply(25)		<= extm;
# reply(24)		<= ral;
#######################################

##cmd     = glib.read("user_wb_cbc_fmc_regs", reg_i2c_cmd_offset)
##print "cmd = ", hex(cmd)
##word    = glib.read("user_wb_cbc_fmc_regs", reg_i2c_word_offset)
##print "word = ", hex(word)
##reply   = glib.read("user_wb_cbc_fmc_regs", reg_i2c_reply_offset)
##print "reply = ", hex(reply)

#cmd : 0=no / 1=rd / 3=wr
#glib.write("cbc_i2c_cmd_rq", 0)

##cmd     = glib.read("user_wb_cbc_fmc_regs", reg_i2c_cmd_offset)
##print "cmd = ", hex(cmd)
##word    = glib.read("user_wb_cbc_fmc_regs", reg_i2c_word_offset)
##print "word = ", hex(word)
##reply   = glib.read("user_wb_cbc_fmc_regs", reg_i2c_reply_offset)
##print "reply = ", hex(reply)

print
print "-> done"
print
print "--=======================================--"
print 
print




