
!!!!!!!!!!!!!!!!!!!!!!!
!!! Important notes !!!
!!!!!!!!!!!!!!!!!!!!!!!

   
* The clock signal from the output U0 of the clock synthesizer CDCE62005 (U38) is forwarded
  to the FPGA through the output TTC_MGT_XPOINT_C of the Crosspoint Switch U42 to be used as
  reference clock by the MGT of the GBT Bank.

  Please note that the Crosspoint Switch U42 does not need to be set by the user since it is 
  already set in the FC7 GBT-FPGA example design.

* Note!! In order to run the FC7 GBT-FPGA example design, it is neccesary to modify the frequency of 
         the MGT(GTX) reference clock "ttc_mgt_xpoint_c" (CDCE62005 U0) from 240MHz (Default) to 120Mhz.

	 To change the configuration of the CDCE62005, please run the python script for IPbus "fc7_cdce_write.py"
         that can be found in the folder "...\tags\fc7_<a.b.c>\sw\fc7\tests\scripts\" using the the following 
         values for "cdce_settings[0]":
		
	 cdce_settings[0]: 0xEB040320 # (out0=120MHz,LVDS, phase shift  0deg, sec_ref)
           	
  
  





