
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name bramTry_1 -dir "D:/cern/xilinx/dtcTester/bramTry/bramTry_1/planAhead_run_2" -part xc6vlx240tff1156-1
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "D:/cern/xilinx/dtcTester/bramTry/bramTry_1/dtc_2.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/cern/xilinx/dtcTester/bramTry/bramTry_1} {ipcore_dir} }
add_files [list {ipcore_dir/blk_mem_gen_v7_3.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/bram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/bram2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/bram_2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/dtc_1_mpabram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/dtc_buff.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sram_doubleBuffered_tx2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_2_bram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_2_vio.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_bram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_bram_tx.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_buff.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/sr_doubleBuffered_vio.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/vio.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "dtc_2.ucf" [current_fileset -constrset]
add_files [list {dtc_2.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "D:/cern/xilinx/dtcTester/bramTry/bramTry_1/dtc_2.ncd"
if {[catch {read_twx -name results_1 -file "D:/cern/xilinx/dtcTester/bramTry/bramTry_1/dtc_2.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"D:/cern/xilinx/dtcTester/bramTry/bramTry_1/dtc_2.twx\": $eInfo"
}
