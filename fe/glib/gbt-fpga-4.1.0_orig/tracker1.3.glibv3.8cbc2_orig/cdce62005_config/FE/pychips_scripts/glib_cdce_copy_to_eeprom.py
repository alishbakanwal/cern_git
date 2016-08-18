from PyChipsUser import *
glibAddrTable = AddressTable("./glibAddrTable.dat")

spi_comm = 0x8FA38014;
cdce_write_to_eeprom_unlocked = 0x0000001F

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

print
print "-> copying the register contents to EEPROM"
print
glib.write("spi_txdata", cdce_write_to_eeprom_unlocked)
glib.write("spi_command", spi_comm)
glib.read("spi_rxdata") # dummy read
glib.read("spi_rxdata") # dummy read

print
print "--=======================================--"
print
print 
