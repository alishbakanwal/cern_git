
## Comment: Adding Common files: 
set SOURCE_PATH D:/cern/glib/tries/gbt-fpga-4.1.0_orig

puts "->" 
puts "-> Adding common files of the GBT-FPGA Core to the ISE project..."
puts "->"


# UCF files
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/ucf/glib_firmware_emulation_clks.ucf
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/ucf/glib_firmware_emulation_io.ucf
#../ucf/ml605_gbt_exmpldsgn_floorplanning.ucf
#../ucf/ml605_gbt_exmpldsgn_timingclosure.ucf


xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/xlx_v6_gbt_bank_package.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/xlx_v6_gbt_banks_user_setup.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_bank_package.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_tx/tx_dpram/xlx_v6_tx_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_rx/rx_dpram/xlx_v6_rx_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_gtx_std_double_reset.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_tx/xlx_v6_gbt_tx_gearbox_std_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_rx/xlx_v6_gbt_rx_gearbox_std_dpram.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std_rdctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_16bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_std.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_16bit.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd
xfile add $SOURCE_PATH/gbt_bank/core_sources/gbt_bank.vhd



## Device specific files
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_mgt_std.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_mgt_latopt.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_gtx_std.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_gtx_latopt_tx_sync.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_gtx_latopt_rx_sync.vhd
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/mgt/xlx_v6_gtx_latopt.vhd


# Files from example design
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/glib_user_logic_emu.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/glib_system_core_emu.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_gbt_example_design.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/glib_fmc_package_emu.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/glib_firmware_emulation/cdce62005/cdce_synchronizer.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/tx_mmcm/xlx_v6_tx_mmcm.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/gbt_rx_frameclk_phalgnr/xlx_v6_phalgnr_std_mmcm.vhd
xfile add $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/tx_frameclk_phaligner/tx_frameclk_phalgnr.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/gbt_rx_frameclk_phalgnr/phaligner_mmcm_controller.vhd
xfile add $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd
xfile add $SOURCE_PATH/example_designs/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/tx_frameclk_phaligner/tx_std_pll.vhd
xfile add $SOURCE_PATH/example_designs/core_sources/gbt_bank_reset.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/xlx_v6_reset.vhd
# xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_vio/xlx_v6_chipscope_vio.vhd
# xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_ila/xlx_v6_chipscope_ila.vhd
# xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_icon/xlx_v6_chipscope_icon.vhd
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/gbt_rx_frameclk_phalgnr/mmcm_inst/xlx_v6_gbt_rx_frameclk_phalgnr_mmcm.vhd

---------------------------------------------------------

## Comment: Adding DTC-tester files: 

puts "->" 
puts "-> Adding CIC transmission files to the ISE project..."
puts "->"

set SOURCE_PATH_X D:/cern/glib/tries/dtc_fe_gbt

xfile add $SOURCE_PATH_X/tracker1.3.glibv3.8cbc2/vhdl/prj_iphc_strasbourg/glib_v3_be/dtc_fe_top.vhd
xfile add $SOURCE_PATH_X/dtc_3.0/dtc_3.0/eports_trig.v
xfile add $SOURCE_PATH_X/dtc_3.0/dtc_fe.v
xfile add $SOURCE_PATH_X/dtc_3.0/clkDiv/example_design/clkDiv_exdes.vhd
xfile add $SOURCE_PATH_X/dtc_3.0/dtc_buff.vhd
xfile add $SOURCE_PATH_X/dtc_3.0/cicbram.xco
xfile add $SOURCE_PATH_X/dtc_3.0/packet_checker.vhd




## Comment: Newly created VHDL codes: 

puts "->" 
puts "-> Adding newly created VHDL codes to the ISE project..."
puts "->"

xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/ise_project/ipcore_dir/dtcfetop_chipscope_ila.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/ise_project/ipcore_dir/Txbram.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/glib/ise_project/ipcore_dir/Rxbram.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/gbt_rx_frameclk_phalgnr/mmcm_inst/xlx_v6_gbt_rx_frameclk_phalgnr_mmcm.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_icon/xlx_v6_chipscope_icon.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_ila/xlx_v6_chipscope_ila.xco
xfile add $SOURCE_PATH/example_designs/xilinx_v6/core_sources/chipscope_vio/xlx_v6_chipscope_vio.xco
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_rx/rx_dpram/xlx_v6_rx_dpram.xco
xfile add $SOURCE_PATH/gbt_bank/xilinx_v6/gbt_tx/tx_dpram/xlx_v6_tx_dpram.xco
xfile add $SOURCE_PATH_X/dtc_3.0/dtc_buff.xco
xfile add $SOURCE_PATH_X/dtc_3.0/clkDiv.xco



