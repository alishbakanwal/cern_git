1) Global Project
-> CMS - Tracker Upgrade - µTCA TK_DAQ

2) Goal:
-> Test of 8CBC2 Hybrid through the µTCA board GLIB3

3) Ipbus version: ipbus_2_0_v1

4) Architecture:
-> 1 GLIB3 AND 1 8CBC2 mini-module (8CBC2Flex Hybrid + 8CBC2Flex Interface + 8CBC2 FMC Carrier) 
-> Only 1 GLIB3 for Acquisition => MONO CARD
-> Ethernet/IPBUS Readout through the data format proposed at DESY in Nov2013 (78 x 32-bit words)
-> 8CBC2 FMC Carrier to connect on connector J2 (FMC1)
-> CBC_MASK added for each induvidual CBC2 
-> Internal oscillator clock used
-> No external trigger
-> CBC order : 
	--> A0=CBC(0) B0=CBC(1)
	--> A1=CBC(2) B1=CBC(3)
	--> A2=CBC(4) B2=CBC(5)
	--> A3=CBC(6) B3=CBC(7)
	
5) Firmware/VHDL: 
-> Fw BE 
-> ISE Version: ISE14.6
-> Open the BE ise project \vhdl\prj_iphc_strasbourg\glib_v3_be\glib_v3_be.xise
-> The project \vhdl\prj_iphc_strasbourg\glib_v3_fe\glib_v3_fe.xise is not used in this case
-> Generic Constants: \vhdl\src\user\iphc_strasbourg\common\pkg\pkg_generic.vhd

6) Virtex6 Programmation Files:
-> Open \virtex6_prog_files\BE
-> \virtex6_prog_files\FE not used

7) Pychips scripts:
-> Open \sw
-> Run the script 8CBC2_data_readout.py to acquire the CBC data or to start the commissionning mode
-> Run the script 8CBC2_i2c_ctrl.py to execute the i2c transactions (reading or configuration of each CBC2's registers)

8) Documentation: 
-> Open \docs

