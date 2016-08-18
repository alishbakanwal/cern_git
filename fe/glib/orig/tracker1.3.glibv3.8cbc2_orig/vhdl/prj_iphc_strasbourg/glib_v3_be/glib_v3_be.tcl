# 
# Project automation script for glib_v3_be 
# 
# Created for ISE version 14.5
# 
# This file contains several Tcl procedures (procs) that you can use to automate
# your project by running from xtclsh or the Project Navigator Tcl console.
# If you load this file (using the Tcl command: source glib_v3_be.tcl), then you can
# run any of the procs included here.
# 
# This script is generated assuming your project has HDL sources.
# Several of the defined procs won't apply to an EDIF or NGC based project.
# If that is the case, simply remove them from this script.
# 
# You may also edit any of these procs to customize them. See comments in each
# proc for more instructions.
# 
# This file contains the following procedures:
# 
# Top Level procs (meant to be called directly by the user):
#    run_process: you can use this top-level procedure to run any processes
#        that you choose to by adding and removing comments, or by
#        adding new entries.
#    rebuild_project: you can alternatively use this top-level procedure
#        to recreate your entire project, and the run selected processes.
# 
# Lower Level (helper) procs (called under in various cases by the top level procs):
#    show_help: print some basic information describing how this script works
#    add_source_files: adds the listed source files to your project.
#    set_project_props: sets the project properties that were in effect when this
#        script was generated.
#    create_libraries: creates and adds file to VHDL libraries that were defined when
#        this script was generated.
#    set_process_props: set the process properties as they were set for your project
#        when this script was generated.
# 

set myProject "glib_v3_be"
set myScript "glib_v3_be.tcl"

# 
# Main (top-level) routines
# 
# run_process
# This procedure is used to run processes on an existing project. You may comment or
# uncomment lines to control which processes are run. This routine is set up to run
# the Implement Design and Generate Programming File processes by default. This proc
# also sets process properties as specified in the "set_process_props" proc. Only
# those properties which have values different from their current settings in the project
# file will be modified in the project.
# 
proc run_process {} {

   global myScript
   global myProject

   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: running ($myProject)...\n"

   if { ! [ open_project ] } {
      return false
   }

   set_process_props
   #
   # Remove the comment characters (#'s) to enable the following commands 
   # process run "Synthesize"
   # process run "Translate"
   # process run "Map"
   # process run "Place & Route"
   #
   set task "Implement Design"
   if { ! [run_task $task] } {
      puts "$myScript: $task run failed, check run output for details."
      project close
      return
   }

   set task "Generate Programming File"
   if { ! [run_task $task] } {
      puts "$myScript: $task run failed, check run output for details."
      project close
      return
   }

   puts "Run completed (successfully)."
   project close

}

# 
# rebuild_project
# 
# This procedure renames the project file (if it exists) and recreates the project.
# It then sets project properties and adds project sources as specified by the
# set_project_props and add_source_files support procs. It recreates VHDL Libraries
# as they existed at the time this script was generated.
# 
# It then calls run_process to set process properties and run selected processes.
# 
proc rebuild_project {} {

   global myScript
   global myProject

   project close
   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: Rebuilding ($myProject)...\n"

   set proj_exts [ list ise xise gise ]
   foreach ext $proj_exts {
      set proj_name "${myProject}.$ext"
      if { [ file exists $proj_name ] } { 
         file delete $proj_name
      }
   }

   project new $myProject
   set_project_props
   add_source_files
   create_libraries
   puts "$myScript: project rebuild completed."

   run_process

}

# 
# Support Routines
# 

# 
proc run_task { task } {

   # helper proc for run_process

   puts "Running '$task'"
   set result [ process run "$task" ]
   #
   # check process status (and result)
   set status [ process get $task status ]
   if { ( ( $status != "up_to_date" ) && \
            ( $status != "warnings" ) ) || \
         ! $result } {
      return false
   }
   return true
}

# 
# show_help: print information to help users understand the options available when
#            running this script.
# 
proc show_help {} {

   global myScript

   puts ""
   puts "usage: xtclsh $myScript <options>"
   puts "       or you can run xtclsh and then enter 'source $myScript'."
   puts ""
   puts "options:"
   puts "   run_process       - set properties and run processes."
   puts "   rebuild_project   - rebuild the project from scratch and run processes."
   puts "   set_project_props - set project properties (device, speed, etc.)"
   puts "   add_source_files  - add source files"
   puts "   create_libraries  - create vhdl libraries"
   puts "   set_process_props - set process property values"
   puts "   show_help         - print this message"
   puts ""
}

proc open_project {} {

   global myScript
   global myProject

   if { ! [ file exists ${myProject}.xise ] } { 
      ## project file isn't there, rebuild it.
      puts "Project $myProject not found. Use project_rebuild to recreate it."
      return false
   }

   project open $myProject

   return true

}
# 
# set_project_props
# 
# This procedure sets the project properties as they were set in the project
# at the time this script was generated.
# 
proc set_project_props {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: Setting project properties..."

   project set family "Virtex6"
   project set device "xc6vlx130t"
   project set package "ff1156"
   project set speed "-1"
   project set top_level_module_type "HDL"
   project set synthesis_tool "XST (VHDL/Verilog)"
   project set simulator "Modelsim-SE Mixed"
   project set "Preferred Language" "VHDL"
   project set "Enable Message Filtering" "false"

}


# 
# add_source_files
# 
# This procedure add the source files that were known to the project at the
# time this script was generated.
# 
proc add_source_files {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: Adding sources to project..."

   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/ChienSearch.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/RSTwoErrorsCorrect.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/adder60.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/errorlocpolynomial.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/gbt_rx_decoder.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/gbt_rx_gbtframe_decoder.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/gf16inverse.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/gf16log.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/gf16shifter.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/lambdadeterminant.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/decoder/syndromes.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/deinterleaver/gbt_rx_deinterleaver.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/descrambler/gbt_rx_16bit_descrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/descrambler/gbt_rx_21bit_descrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/descrambler/gbt_rx_descrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/gbt_rx.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_rx/gearbox/gbt_rx_gearbox.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/encoder/gbt_tx_encoder.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/encoder/gbt_tx_gbtframe_encoder.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/encoder/polydivider.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/gbt_tx.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/interleaver/gbt_tx_interleaver.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/scrambler/gbt_tx_16bit_scrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/scrambler/gbt_tx_21bit_scrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gbt_tx/scrambler/gbt_tx_scrambler.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gf16add.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt/gf16mult.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt_link.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_agnostic/gbt_link_package.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/Modulo_20_Counter.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/Right_Shifter_19b.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/gearbox/latency_opt/xlx_v6_gbt_rx_latop_gearbox.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/gearbox/standard/RX_DP_RAM.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/gearbox/standard/Read_RX_DP_RAM.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/gearbox/standard/dpram/rxtdpram.xco"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/gearbox/standard/xlx_v6_gbt_rx_standard_gearbox.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/rx_gearbox_wr_addr.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/xlx_v6_gbt_rx_bitslip_counter.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/xlx_v6_gbt_rx_frame_aligner.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_rx/xlx_v6_gbt_rx_pattern_search.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gbt/gbt_tx/gearbox/latency_opt/xlx_v6_gbt_tx_latop_gearbox.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/latency_opt/bitslip/xlx_v6_gtx_bitslip_control.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/latency_opt/sync/xlx_v6_latopt_gtx_rx_sync.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/latency_opt/sync/xlx_v6_latopt_gtx_tx_sync.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/latency_opt/xlx_v6_latopt_gtx.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/latency_opt/xlx_v6_latopt_gtx_wrapper.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/standard/xlx_v6_standard_gtx.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/standard/xlx_v6_standard_gtx_double_reset.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/xlx_v6_gtx_fabric_clk_scheme.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/gtx/xlx_v6_multi_gigabit_transceivers.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/gbt_link/vendor_specific/xilinx/xlx_6_series/virtex_6/xlx_v6_gbt_link_package.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_agnostic/error_detector.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_agnostic/gbt_link_reset.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_agnostic/gbt_rx_status.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_agnostic/pattern_generator.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_agnostic/pattern_match_flag.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_specific/xilinx/xlx_6_series/common_modules/xlx_v6_rxframeclk_ph_alig/xlx_v6_rxframeclk_ph_alig.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_specific/xilinx/xlx_6_series/common_modules/xlx_v6_rxframeclk_ph_alig/xlx_v6_rxfrmclkphalig_pll.vhd"
   xfile add "../../ip_com/gbt_fpga/tags/gbt_fpga_0_1_0_beta/ref_designs/vendor_specific/xilinx/xlx_6_series/common_modules/xlx_v6_rxframeclk_ph_alig/xlx_v6_rxfrmclkphalig_pll_mmcm.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ethernet/hdl/emac_hostbus_decl.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/ipbus_ctrl.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/ipbus_package.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/ipbus_trans_decl.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/stretcher.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/trans_arb.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/transactor.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/transactor_cfg.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/transactor_if.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/transactor_sm.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_buffer_selector.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_build_arp.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_build_payload.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_build_ping.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_build_resend.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_build_status.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_byte_sum.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_clock_crossing_if.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_do_rx_reset.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_dualportram.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_dualportram_rx.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_dualportram_tx.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_if_flat.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_ipaddr_block.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_packet_parser.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_rarp_block.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_rxram_mux.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_rxram_shim.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_rxtransactor_if_simple.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_status_buffer.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_tx_mux.vhd"
   xfile add "../../ip_com/ipbus/ipbus_2_0_v1/firmware/ipbus_core/hdl/udp_txtransactor_if_simple.vhd"
   xfile add "../../src/system/cdce/cdce_phase_mon_v2/cdce_phase_mon_v2.vhd"
   xfile add "../../src/system/cdce/cdce_phase_mon_v2/cdce_phase_mon_v2_wrapper.vhd"
   xfile add "../../src/system/cdce/cdce_phase_mon_v2/dpram/ttclk_distributed_dpram.xco"
   xfile add "../../src/system/cdce/cdce_phase_mon_v2/pll/ttclk_mmcm.xco"
   xfile add "../../src/system/cdce/cdce_synchronizer.vhd"
   xfile add "../../src/system/ethernet/eth_v6_basex_glib.vhd"
   xfile add "../../src/system/ethernet/eth_v6_sgmii_glib.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/basex/v6_emac_v2_3_basex.xco"
   xfile add "../../src/system/ethernet/ipcore_dir/basex/v6_emac_v2_3_basex/v6_emac_v2_3_basex_block.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/common/reset_sync.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/common/sync_block.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/physical/double_reset.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/physical/v6_gtxwizard.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/physical/v6_gtxwizard_gtx.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/physical/v6_gtxwizard_top.vhd"
   xfile add "../../src/system/ethernet/ipcore_dir/sgmii/v6_emac_v2_3_sgmii.xco"
   xfile add "../../src/system/ethernet/ipcore_dir/sgmii/v6_emac_v2_3_sgmii/v6_emac_v2_3_sgmii_block.vhd"
   xfile add "../../src/system/fmc/fmc_io_buffers.vhd"
   xfile add "../../src/system/fmc/fmc_io_pair.vhd"
   xfile add "../../src/system/fmc/fmc_package.vhd"
   xfile add "../../src/system/heartbeat/sys_heartbeat.vhd"
   xfile add "../../src/system/i2c/i2c_bitwise.vhd"
   xfile add "../../src/system/i2c/i2c_ctrl.vhd"
   xfile add "../../src/system/i2c/i2c_eeprom_read.vhd"
   xfile add "../../src/system/i2c/i2c_master_core.vhd"
   xfile add "../../src/system/i2c/i2c_slave_core.vhd"
   xfile add "../../src/system/i2c/i2c_slave_core_ro.vhd"
   xfile add "../../src/system/icap/icap_interface.vhd"
   xfile add "../../src/system/icap/icap_interface_fsm.vhd"
   xfile add "../../src/system/icap/icap_interface_ioControl.vhd"
   xfile add "../../src/system/icap/icap_interface_wrapper.vhd"
   xfile add "../../src/system/icap/icap_package.vhd"
   xfile add "../../src/system/ipbus/ipbus_glib/ip_mac_select.vhd"
   xfile add "../../src/system/ipbus/ipbus_glib/ipbus_addr_decode.vhd"
   xfile add "../../src/system/ipbus/ipbus_glib/ipbus_master_arb.vhd"
   xfile add "../../src/system/ipbus/ipbus_glib/ipbus_sys_fabric.vhd"
   xfile add "../../src/system/ipbus/ipbus_glib/ipbus_user_fabric.vhd"
   xfile add "../../src/system/mem/flash/flash_interface.vhd"
   xfile add "../../src/system/mem/flash/flash_interface_wrapper.vhd"
   xfile add "../../src/system/mem/mem_buf/sram_flash_buffers.vhd"
   xfile add "../../src/system/mem/sram/glib_sram_interface.vhd"
   xfile add "../../src/system/mem/sram/glib_sram_interface_bist.vhd"
   xfile add "../../src/system/mem/sram/glib_sram_interface_ioControl.vhd"
   xfile add "../../src/system/mem/sram/glib_sram_interface_wrapper.vhd"
   xfile add "../../src/system/mem/system_flash_sram_package.vhd"
   xfile add "../../src/system/pcie/pcie_or_eth_to_ipbus_arb/pcie_or_eth_to_ipbus_arb.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2/ezdma2_core_8dma_250mhz.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2/ezdma2_wrapper.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2/pcie_ezdma_xilinx_full.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ezdma2_ctrl_dpram/ezdma2_ctrl_dpram.xco"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/ipbus_ctrl_dpram/ipbus_ctrl_dpram.xco"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_rd_fifo/slv_rd_fifo.xco"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/cores/slv_wr_fifo/slv_wr_fifo.xco"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/ezdma2_ipbus_int.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/ezdma2_ipbus_int_addr_enc.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/ezdma2_ipbus_int_cdc.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/ezdma2_ipbus_int_ezdma2.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_ipbus_int/ezdma2_ipbus_int_ipbus.vhd"
   xfile add "../../src/system/pcie/sys_pcie/ezdma2_mux/ezdma2_mux.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/gtx_drp_chanalign_fix_3752_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/gtx_rx_valid_filter_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/gtx_tx_sync_rate_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/gtx_wrapper_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_2_0_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_bram_top_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_bram_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_brams_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_clocking_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_gtx_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_hip_x4_gen2_125ref.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_pipe_lane_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_pipe_misc_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_pipe_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_reset_delay_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_core/pcie_upconfig_fix_3451_v6.vhd"
   xfile add "../../src/system/pcie/sys_pcie/pcie_glib_wrapper.vhd"
   xfile add "../../src/system/pcie/system_pcie_package.vhd"
   xfile add "../../src/system/pll/glib_pll.xco"
   xfile add "../../src/system/prbs/prbs.vhd"
   xfile add "../../src/system/regs/system_regs.vhd"
   xfile add "../../src/system/reset/clock_div_alt.vhd"
   xfile add "../../src/system/reset/rst_ctrl.vhd"
   xfile add "../../src/system/spi/spi_master.vhd"
   xfile add "../../src/system/sys/glib_top.vhd"
   xfile add "../../src/system/sys/system.ucf"
   xfile add "../../src/system/sys/system_clk.ucf"
   xfile add "../../src/system/sys/system_core.vhd"
   xfile add "../../src/system/sys/system_package.vhd"
   xfile add "../../src/system/sys/system_version_package.vhd"
   xfile add "../../src/system/wb/ipbus_to_wb_bridge.vhd"
   xfile add "../../src/system/wb/wb_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/BE_FE_SyncTest.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/cbc_frame_detect.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/cbc_frame_transmission.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/cbc_i2c_updating_ctrl_v3.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/cbc_i2c_updating_ctrl_v4.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/gbt_data_interface_be.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/gbt_fpga/glib_gbt_link_user_setup.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/gbt_fpga/ucf/glib_gbt_ref_design_floorplanning.ucf"
   xfile add "../../src/user/iphc_strasbourg/be/gbt_fpga/ucf/glib_gbt_ref_design_timingclosure.ucf"
   xfile add "../../src/user/iphc_strasbourg/be/gbt_fpga/xlx_v6_gbt_ref_design.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/i2c/modif/i2c_ctrl_lvds.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/i2c/modif/i2c_data_lvds.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/i2c/modif/i2c_master_no_iobuf_lvds.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/ipcore_fifo/fifo_StubData/8x512/ipcore_fifo_StubData.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/ipcore_fifo/fifo_cbcCounter/24x512/ipcore_fifo_cbcCounter.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/ipcore_fifo/fifo_cbcv2/264x512/ipcore_fifo_cbcv2.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/ipcore_fifo/fifo_tdcCounter/6x512/ipcore_fifo_tdcCounter.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/ipcore_fifo/fifo_time_triggerCounter/96x512/ipcore_fifo_time_triggerCounter.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/mmcm/320M_input/mmcm1.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/stubdata/L1A_varDelay/1x128/ipcore_L1A_varDelay.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/stubdata/StubData_varDelay/8x128/ipcore_stubdata_varDelay.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ipcore_dir/tdc_counter/6bit/dsp48/ipcore_tdc_counter.xco"
   xfile add "../../src/user/iphc_strasbourg/be/ttc3/cdr2ttc.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/ttc3/mmcm_160M_in_dephasing.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/ucf/user_fabric_clk.ucf"
   xfile add "../../src/user/iphc_strasbourg/be/ucf/user_mgt_refclk.ucf"
   xfile add "../../src/user/iphc_strasbourg/be/ucf/user_mgt_sfp.ucf"
   xfile add "../../src/user/iphc_strasbourg/be/user_addr_decode.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_be_wb_regs.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_fmc1_io_conf_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_fmc2_io_conf_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_logic/break_trig/user_logic_be.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_sys_pcie_constants_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/user_version_package.vhd"
   xfile add "../../src/user/iphc_strasbourg/be/wb_ttc_fmc_regs.vhd"
   xfile add "../../src/user/iphc_strasbourg/common/chipscope/icon_OneCtrl.xco"
   xfile add "../../src/user/iphc_strasbourg/common/chipscope/ila_TenTrig1b/ila_TenTrig1b.xco"
   xfile add "../../src/user/iphc_strasbourg/common/chipscope/ila_TwoTrig84b_TwoTrig87b.xco"
   xfile add "../../src/user/iphc_strasbourg/common/clk_domain_bridge/clk_domain_bridge.vhd"
   xfile add "../../src/user/iphc_strasbourg/common/dist_mem/dist_mem_gen_v5_1.xco"
   xfile add "../../src/user/iphc_strasbourg/common/pkg/pkg_generic.vhd"
   puts ""
   puts "WARNING: project contains IP cores, synthesis will fail if any of the cores require regenerating."
   puts ""

   # Set the Top Module as well...
   project set top "glib_top_arch" "glib_top"

   puts "$myScript: project sources reloaded."

} ; # end add_source_files

# 
# create_libraries
# 
# This procedure defines VHDL libraries and associates files with those libraries.
# It is expected to be used when recreating the project. Any libraries defined
# when this script was generated are recreated by this procedure.
# 
proc create_libraries {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: Creating libraries..."


   # must close the project or library definitions aren't saved.
   project save

} ; # end create_libraries

# 
# set_process_props
# 
# This procedure sets properties as requested during script generation (either
# all of the properties, or only those modified from their defaults).
# 
proc set_process_props {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: setting process properties..."

   project set "Compiled Library Directory" "\$XILINX/<language>/<simulator>"
   project set "Global Optimization" "Off" -process "Map"
   project set "Use DSP Block" "Auto" -process "Synthesize - XST"
   project set "DCI Update Mode" "As Required" -process "Generate Programming File"
   project set "Enable Cyclic Redundancy Checking (CRC)" "true" -process "Generate Programming File"
   project set "Configuration Rate" "2" -process "Generate Programming File"
   project set "Pack I/O Registers/Latches into IOBs" "Off" -process "Map"
   project set "Place And Route Mode" "Route Only" -process "Place & Route"
   project set "Number of Clock Buffers" "32" -process "Synthesize - XST"
   project set "Max Fanout" "100000" -process "Synthesize - XST"
   project set "Use Clock Enable" "Auto" -process "Synthesize - XST"
   project set "Use Synchronous Reset" "Auto" -process "Synthesize - XST"
   project set "Use Synchronous Set" "Auto" -process "Synthesize - XST"
   project set "Regenerate Core" "Under Current Project Setting" -process "Regenerate Core"
   project set "Filter Files From Compile Order" "true"
   project set "Last Applied Goal" "Balanced"
   project set "Last Applied Strategy" "Xilinx Default (unlocked)"
   project set "Last Unlock Status" "false"
   project set "Manual Compile Order" "false"
   project set "Placer Effort Level" "High" -process "Map"
   project set "Extra Cost Tables" "0" -process "Map"
   project set "LUT Combining" "Off" -process "Map"
   project set "Combinatorial Logic Optimization" "false" -process "Map"
   project set "Starting Placer Cost Table (1-100)" "1" -process "Map"
   project set "Power Reduction" "Off" -process "Map"
   project set "Overwrite Existing Symbol" "false" -process "Create Schematic Symbol"
   project set "Report Fastest Path(s) in Each Constraint" "true" -process "Generate Post-Place & Route Static Timing"
   project set "Generate Datasheet Section" "true" -process "Generate Post-Place & Route Static Timing"
   project set "Generate Timegroups Section" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Report Fastest Path(s) in Each Constraint" "true" -process "Generate Post-Map Static Timing"
   project set "Generate Datasheet Section" "true" -process "Generate Post-Map Static Timing"
   project set "Generate Timegroups Section" "false" -process "Generate Post-Map Static Timing"
   project set "Project Description" ""
   project set "Property Specification in Project File" "Store all values"
   project set "Reduce Control Sets" "Auto" -process "Synthesize - XST"
   project set "Shift Register Minimum Size" "2" -process "Synthesize - XST"
   project set "Case Implementation Style" "None" -process "Synthesize - XST"
   project set "RAM Extraction" "true" -process "Synthesize - XST"
   project set "ROM Extraction" "true" -process "Synthesize - XST"
   project set "FSM Encoding Algorithm" "Auto" -process "Synthesize - XST"
   project set "Optimization Goal" "Speed" -process "Synthesize - XST"
   project set "Optimization Effort" "Normal" -process "Synthesize - XST"
   project set "Resource Sharing" "true" -process "Synthesize - XST"
   project set "Shift Register Extraction" "true" -process "Synthesize - XST"
   project set "User Browsed Strategy Files" "C:/Xilinx/14.6/ISE_DS/ISE/data/default.xds"
   project set "VHDL Source Analysis Standard" "VHDL-93"
   project set "Analysis Effort Level" "Standard" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Analysis Effort Level" "Standard" -process "Generate Text Power Report"
   project set "Input TCL Command Script" "" -process "Generate Text Power Report"
   project set "Load Physical Constraints File" "Default" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Physical Constraints File" "Default" -process "Generate Text Power Report"
   project set "Load Simulation File" "Default" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Simulation File" "Default" -process "Generate Text Power Report"
   project set "Load Setting File" "" -process "Analyze Power Distribution (XPower Analyzer)"
   project set "Load Setting File" "" -process "Generate Text Power Report"
   project set "Setting Output File" "" -process "Generate Text Power Report"
   project set "Produce Verbose Report" "false" -process "Generate Text Power Report"
   project set "Other XPWR Command Line Options" "" -process "Generate Text Power Report"
   project set "Essential Bits" "false" -process "Generate Programming File"
   project set "Encrypt Bitstream" "false" -process "Generate Programming File"
   project set "JTAG to System Monitor Connection" "Enable" -process "Generate Programming File"
   project set "User Access Register Value" "None" -process "Generate Programming File"
   project set "Other Bitgen Command Line Options" "" -process "Generate Programming File"
   project set "Maximum Signal Name Length" "20" -process "Generate IBIS Model"
   project set "Show All Models" "false" -process "Generate IBIS Model"
   project set "Disable Detailed Package Model Insertion" "false" -process "Generate IBIS Model"
   project set "Launch SDK after Export" "true" -process "Export Hardware Design To SDK with Bitstream"
   project set "Launch SDK after Export" "true" -process "Export Hardware Design To SDK without Bitstream"
   project set "Target UCF File Name" "" -process "Back-annotate Pin Locations"
   project set "Ignore User Timing Constraints" "false" -process "Map"
   project set "Register Ordering" "4" -process "Map"
   project set "Use RLOC Constraints" "Yes" -process "Map"
   project set "Other Map Command Line Options" "" -process "Map"
   project set "Use LOC Constraints" "true" -process "Translate"
   project set "Other Ngdbuild Command Line Options" "" -process "Translate"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "Floorplan Area/IO/Logic (PlanAhead)"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "I/O Pin Planning (PlanAhead) - Pre-Synthesis"
   project set "Use 64-bit PlanAhead on 64-bit Systems" "true" -process "I/O Pin Planning (PlanAhead) - Post-Synthesis"
   project set "Ignore User Timing Constraints" "false" -process "Place & Route"
   project set "Other Place & Route Command Line Options" "" -process "Place & Route"
   project set "BPI Reads Per Page" "1" -process "Generate Programming File"
   project set "Configuration Pin Busy" "Pull Up" -process "Generate Programming File"
   project set "Configuration Clk (Configuration Pins)" "Pull Up" -process "Generate Programming File"
   project set "UserID Code (8 Digit Hexadecimal)" "0xFFFFFFFF" -process "Generate Programming File"
   project set "Configuration Pin CS" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin DIn" "Pull Up" -process "Generate Programming File"
   project set "Disable JTAG Connection" "false" -process "Generate Programming File"
   project set "Configuration Pin Done" "Pull Up" -process "Generate Programming File"
   project set "Create ASCII Configuration File" "false" -process "Generate Programming File"
   project set "Create Binary Configuration File" "false" -process "Generate Programming File"
   project set "Create Bit File" "true" -process "Generate Programming File"
   project set "Enable BitStream Compression" "true" -process "Generate Programming File"
   project set "Run Design Rules Checker (DRC)" "false" -process "Generate Programming File"
   project set "Create IEEE 1532 Configuration File" "false" -process "Generate Programming File"
   project set "Create ReadBack Data Files" "false" -process "Generate Programming File"
   project set "Configuration Pin HSWAPEN" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin Init" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin M0" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin M1" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin M2" "Pull Up" -process "Generate Programming File"
   project set "Configuration Pin Program" "Pull Up" -process "Generate Programming File"
   project set "Power Down Device if Over Safe Temperature" "false" -process "Generate Programming File"
   project set "Configuration Pin RdWr" "Pull Up" -process "Generate Programming File"
   project set "Starting Address for Fallback Configuration" "None" -process "Generate Programming File"
   project set "JTAG Pin TCK" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TDI" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TDO" "Pull Up" -process "Generate Programming File"
   project set "JTAG Pin TMS" "Pull Up" -process "Generate Programming File"
   project set "Unused IOB Pins" "Pull Down" -process "Generate Programming File"
   project set "Watchdog Timer Mode" "Off" -process "Generate Programming File"
   project set "Security" "Enable Readback and Reconfiguration" -process "Generate Programming File"
   project set "Done (Output Events)" "Default (4)" -process "Generate Programming File"
   project set "Drive Done Pin High" "false" -process "Generate Programming File"
   project set "Enable Outputs (Output Events)" "Default (5)" -process "Generate Programming File"
   project set "Wait for DCI Match (Output Events)" "Auto" -process "Generate Programming File"
   project set "Wait for PLL Lock (Output Events)" "No Wait" -process "Generate Programming File"
   project set "Release Write Enable (Output Events)" "Default (6)" -process "Generate Programming File"
   project set "FPGA Start-Up Clock" "CCLK" -process "Generate Programming File"
   project set "Enable Internal Done Pipe" "false" -process "Generate Programming File"
   project set "Allow Logic Optimization Across Hierarchy" "false" -process "Map"
   project set "Maximum Compression" "false" -process "Map"
   project set "Generate Detailed MAP Report" "false" -process "Map"
   project set "Map Slice Logic into Unused Block RAMs" "false" -process "Map"
   project set "Perform Timing-Driven Packing and Placement" "false"
   project set "Trim Unconnected Signals" "true" -process "Map"
   project set "Create I/O Pads from Ports" "false" -process "Translate"
   project set "Macro Search Path" "" -process "Translate"
   project set "Netlist Translation Type" "Timestamp" -process "Translate"
   project set "User Rules File for Netlister Launcher" "" -process "Translate"
   project set "Allow Unexpanded Blocks" "false" -process "Translate"
   project set "Allow Unmatched LOC Constraints" "false" -process "Translate"
   project set "Allow Unmatched Timing Group Constraints" "false" -process "Translate"
   project set "Perform Advanced Analysis" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Report Paths by Endpoint" "3" -process "Generate Post-Place & Route Static Timing"
   project set "Report Type" "Verbose Report" -process "Generate Post-Place & Route Static Timing"
   project set "Number of Paths in Error/Verbose Report" "3" -process "Generate Post-Place & Route Static Timing"
   project set "Stamp Timing Model Filename" "" -process "Generate Post-Place & Route Static Timing"
   project set "Report Unconstrained Paths" "" -process "Generate Post-Place & Route Static Timing"
   project set "Perform Advanced Analysis" "false" -process "Generate Post-Map Static Timing"
   project set "Report Paths by Endpoint" "3" -process "Generate Post-Map Static Timing"
   project set "Report Type" "Verbose Report" -process "Generate Post-Map Static Timing"
   project set "Number of Paths in Error/Verbose Report" "3" -process "Generate Post-Map Static Timing"
   project set "Report Unconstrained Paths" "YES" -process "Generate Post-Map Static Timing"
   project set "Add I/O Buffers" "true" -process "Synthesize - XST"
   project set "Global Optimization Goal" "AllClockNets" -process "Synthesize - XST"
   project set "Keep Hierarchy" "Soft" -process "Synthesize - XST"
   project set "Register Balancing" "No" -process "Synthesize - XST"
   project set "Register Duplication" "true" -process "Synthesize - XST"
   project set "Library for Verilog Sources" "" -process "Synthesize - XST"
   project set "Export Results to XPower Estimator" "" -process "Generate Text Power Report"
   project set "Asynchronous To Synchronous" "false" -process "Synthesize - XST"
   project set "Automatic BRAM Packing" "false" -process "Synthesize - XST"
   project set "BRAM Utilization Ratio" "100" -process "Synthesize - XST"
   project set "Bus Delimiter" "<>" -process "Synthesize - XST"
   project set "Case" "Maintain" -process "Synthesize - XST"
   project set "Cores Search Directories" "" -process "Synthesize - XST"
   project set "Cross Clock Analysis" "false" -process "Synthesize - XST"
   project set "DSP Utilization Ratio" "100" -process "Synthesize - XST"
   project set "Equivalent Register Removal" "true" -process "Synthesize - XST"
   project set "FSM Style" "LUT" -process "Synthesize - XST"
   project set "Generate RTL Schematic" "Yes" -process "Synthesize - XST"
   project set "Generics, Parameters" "" -process "Synthesize - XST"
   project set "Hierarchy Separator" "/" -process "Synthesize - XST"
   project set "HDL INI File" "" -process "Synthesize - XST"
   project set "LUT Combining" "Auto" -process "Synthesize - XST"
   project set "Library Search Order" "" -process "Synthesize - XST"
   project set "Netlist Hierarchy" "As Optimized" -process "Synthesize - XST"
   project set "Optimize Instantiated Primitives" "false" -process "Synthesize - XST"
   project set "Pack I/O Registers into IOBs" "Auto" -process "Synthesize - XST"
   project set "Power Reduction" "false" -process "Synthesize - XST"
   project set "Read Cores" "true" -process "Synthesize - XST"
   project set "LUT-FF Pairs Utilization Ratio" "100" -process "Synthesize - XST"
   project set "Use Synthesis Constraints File" "true" -process "Synthesize - XST"
   project set "Verilog Include Directories" "" -process "Synthesize - XST"
   project set "Verilog Macros" "" -process "Synthesize - XST"
   project set "Work Directory" "D:/cern/glib/orig/tracker1.3.glibv3.8cbc2_orig/vhdl/prj_iphc_strasbourg/glib_v3_be/xst" -process "Synthesize - XST"
   project set "Write Timing Constraints" "false" -process "Synthesize - XST"
   project set "Other XST Command Line Options" "" -process "Synthesize - XST"
   project set "Timing Mode" "Performance Evaluation" -process "Map"
   project set "Generate Asynchronous Delay Report" "true" -process "Place & Route"
   project set "Generate Clock Region Report" "true" -process "Place & Route"
   project set "Generate Post-Place & Route Power Report" "false" -process "Place & Route"
   project set "Generate Post-Place & Route Simulation Model" "false" -process "Place & Route"
   project set "Power Reduction" "false" -process "Place & Route"
   project set "Place & Route Effort Level (Overall)" "High" -process "Place & Route"
   project set "Auto Implementation Compile Order" "true"
   project set "Equivalent Register Removal" "true" -process "Map"
   project set "Placer Extra Effort" "None" -process "Map"
   project set "Power Activity File" "" -process "Map"
   project set "Register Duplication" "Off" -process "Map"
   project set "Generate Constraints Interaction Report" "false" -process "Generate Post-Map Static Timing"
   project set "Synthesis Constraints File" "" -process "Synthesize - XST"
   project set "RAM Style" "Auto" -process "Synthesize - XST"
   project set "Maximum Number of Lines in Report" "1000" -process "Generate Text Power Report"
   project set "AES Initial Vector" "" -process "Generate Programming File"
   project set "HMAC Key (Hex String)" "" -process "Generate Programming File"
   project set "Encrypt Key Select" "BBRAM" -process "Generate Programming File"
   project set "AES Key (Hex String)" "" -process "Generate Programming File"
   project set "Input Encryption Key File" "" -process "Generate Programming File"
   project set "Output File Name" "glib_top" -process "Generate IBIS Model"
   project set "Timing Mode" "Performance Evaluation" -process "Place & Route"
   project set "Cycles for First BPI Page Read" "1" -process "Generate Programming File"
   project set "Enable Debugging of Serial Mode BitStream" "false" -process "Generate Programming File"
   project set "Create Logic Allocation File" "false" -process "Generate Programming File"
   project set "Create Mask File" "false" -process "Generate Programming File"
   project set "Watchdog Timer Value" "0x000000" -process "Generate Programming File"
   project set "Allow SelectMAP Pins to Persist" "false" -process "Generate Programming File"
   project set "Enable Multi-Threading" "2" -process "Map"
   project set "Generate Constraints Interaction Report" "false" -process "Generate Post-Place & Route Static Timing"
   project set "Move First Flip-Flop Stage" "true" -process "Synthesize - XST"
   project set "Move Last Flip-Flop Stage" "true" -process "Synthesize - XST"
   project set "ROM Style" "Auto" -process "Synthesize - XST"
   project set "Safe Implementation" "No" -process "Synthesize - XST"
   project set "Power Activity File" "" -process "Place & Route"
   project set "Extra Effort (Highest PAR level only)" "None" -process "Place & Route"
   project set "Fallback Reconfiguration" "Enable" -process "Generate Programming File"
   project set "Enable Multi-Threading" "4" -process "Place & Route"
   project set "Functional Model Target Language" "VHDL" -process "View HDL Source"
   project set "Change Device Speed To" "-1" -process "Generate Post-Place & Route Static Timing"
   project set "Change Device Speed To" "-1" -process "Generate Post-Map Static Timing"

   puts "$myScript: project property values set."

} ; # end set_process_props

proc main {} {

   if { [llength $::argv] == 0 } {
      show_help
      return true
   }

   foreach option $::argv {
      switch $option {
         "show_help"           { show_help }
         "run_process"         { run_process }
         "rebuild_project"     { rebuild_project }
         "set_project_props"   { set_project_props }
         "add_source_files"    { add_source_files }
         "create_libraries"    { create_libraries }
         "set_process_props"   { set_process_props }
         default               { puts "unrecognized option: $option"; show_help }
      }
   }
}

if { $tcl_interactive } {
   show_help
} else {
   if {[catch {main} result]} {
      puts "$myScript failed: $result."
   }
}

