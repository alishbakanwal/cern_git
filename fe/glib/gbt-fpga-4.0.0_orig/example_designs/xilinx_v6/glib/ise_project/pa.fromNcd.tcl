
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name glib_gbt_example_design -dir "D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project/planAhead_run_2" -part xc6vlx130tff1156-1
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project/glib_gbt_example_design.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project} {../../../../../dtc_fe_gbt/dtc_3.0} {../../core_sources/chipscope_icon} {ipcore_dir} {../../../../gbt_bank/xilinx_v6/gbt_rx/rx_dpram} {../../../../gbt_bank/xilinx_v6/gbt_tx/tx_dpram} {../../core_sources/chipscope_ila} {../../core_sources/chipscope_vio} {../../core_sources/tx_mmcm} {../../core_sources/gbt_rx_frameclk_phalgnr/mmcm_inst} }
add_files [list {../../../../../dtc_fe_gbt/dtc_3.0/cicbram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../../../../dtc_fe_gbt/dtc_3.0/dtc_buff.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../../../../dtc_fe_gbt/dtc_3.0/icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../../../../dtc_fe_gbt/dtc_3.0/ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../core_sources/chipscope_icon/xlx_v6_chipscope_icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/dtcfetop_chipscope_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ibert.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/Rxbram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/Txbram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../core_sources/chipscope_ila/xlx_v6_chipscope_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {../../core_sources/chipscope_vio/xlx_v6_chipscope_vio.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/glib_firmware _emulation/ucf/glib_firmware_emulation_io.ucf" [current_fileset -constrset]
add_files [list {C:/Users/alishbaK/Desktop/glib_firmware_emulation_clks.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/glib_firmware _emulation/ucf/glib_firmware_emulation_io.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project/glib_gbt_example_design.ncd"
if {[catch {read_twx -name results_1 -file "D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project/glib_gbt_example_design.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"D:/cern/glib/gbt-fpga-4.0.0_orig/example_designs/xilinx_v6/glib/ise_project/glib_gbt_example_design.twx\": $eInfo"
}
