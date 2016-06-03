All files under ./gbt_fpga_ml605 are extracted from "gbt_files_for_cern_ml507_ml605.zip" downloaded on February 13th, 2013 from the GBT-FPGA sharepoint site "https://espace.cern.ch/GBT-Project/GBT-FPGA" (complete link: https://espace.cern.ch/GBT-Project/GBT-FPGA/_layouts/listform.aspx?PageType=4&ListId={8CDF703A-0BDA-42AB-A811-A981F96C7D1B}&ID=8&ContentTypeID=0x0100736F96F17B79454A8A6A94F931059D0C )

Since the hierarchy in the GLIB platform is different, the signals monitored by the "v6_scope.cdc" Chipscope file cannot be found because the signal "paths" used in the Chipscope are absolute and not relative. For that reason, we use the the file  "./usr/GLIB_v6_scope.cdc" that provides the correct paths. The only difference is that instead of the 40bit rx_parallel output of the deserializer, the 40-bit word from the barrel shifter is used (for direct comparison with the trasmitted word).

In order to operate that project, it is necessary to set the cdce to provide 120MHz reference clock.
To do so you have to do the following:

- Run the script gbt_fpga_cdce_write.py to writing the correct values to the ram of the CDCE. 
- Run the script glib_cdce_copy_to_eeprom.py to save the settings to the eeprom of the CDCE.

To control the gbt_fpga module, you can run the script gbt_fpga_ctrl_reg.py [value_to_write], with the value typed in hex (without the prefix "0x"). The lines controlled are the two resets of the module and the internal loopback option.

Example: gbt_fpga_ctrl_reg.py 100 is writing "1" to bit8 enabling the internal loopback option








