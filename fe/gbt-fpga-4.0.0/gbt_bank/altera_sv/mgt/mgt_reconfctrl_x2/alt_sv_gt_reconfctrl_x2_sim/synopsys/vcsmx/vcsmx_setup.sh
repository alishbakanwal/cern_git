
# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 162 win32 2014.04.06.21:54:15

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="alt_sv_gx_reconfctrl_x2"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="C:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/alt_sv_gx_reconfctrl_x2/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/stratixv_ver/
mkdir -p ./libraries/stratixv_hssi_ver/
mkdir -p ./libraries/stratixv_pcie_hip_ver/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/stratixv/
mkdir -p ./libraries/stratixv_hssi/
mkdir -p ./libraries/stratixv_pcie_hip/

# ----------------------------------------
# copy RAM/ROM files to simulation directory

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                       -work altera_ver           
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                                -work lpm_ver              
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                   -work sgate_ver            
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                               -work altera_mf_ver        
  vlogan +v2k -sverilog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                           -work altera_lnsim_ver     
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/stratixv_atoms_ncrypt.v"          -work stratixv_ver         
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_atoms.v"                          -work stratixv_ver         
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/stratixv_hssi_atoms_ncrypt.v"     -work stratixv_hssi_ver    
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_hssi_atoms.v"                     -work stratixv_hssi_ver    
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/stratixv_pcie_hip_atoms_ncrypt.v" -work stratixv_pcie_hip_ver
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_pcie_hip_atoms.v"                 -work stratixv_pcie_hip_ver
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"                 -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"             -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"                -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"             -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"          -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"                     -work altera               
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                               -work lpm                  
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                              -work lpm                  
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                            -work sgate                
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                                 -work sgate                
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"                  -work altera_mf            
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                             -work altera_mf            
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"               -work altera_lnsim         
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_atoms.vhd"                        -work stratixv             
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_components.vhd"                   -work stratixv             
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_hssi_components.vhd"              -work stratixv_hssi        
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_hssi_atoms.vhd"                   -work stratixv_hssi        
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_pcie_hip_components.vhd"          -work stratixv_pcie_hip    
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/stratixv_pcie_hip_atoms.vhd"               -work stratixv_pcie_hip    
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/altera_xcvr_functions.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_h.sv"                                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_resync.sv"                             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_h.sv"                         -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_dfe_cal_sweep_h.sv"                     -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig.sv"                           -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_sv.sv"                        -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_cal_seq.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_cif.sv"                             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_uif.sv"                             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_basic_acq.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_analog.sv"                    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_analog_sv.sv"                 -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_datactrl.sv"                 -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_rmw.sv"                      -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xreconf_analog_ctrlsm.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_offset_cancellation.sv"       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_offset_cancellation_sv.sv"    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_eyemon.sv"                    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_eyemon_sv.sv"                 -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_eyemon_ctrl_sv.sv"            -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_eyemon_ber_sv.sv"             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k           "$QSYS_SIMDIR/alt_xcvr_reconfig/ber_reader_dcfifo.v"                            -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/step_to_mon_sv.sv"                              -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/mon_to_step_sv.sv"                              -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_sv.sv"                    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_reg_sv.sv"                -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_cal_sv.sv"                -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_cal_sweep_sv.sv"          -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_cal_sweep_datapath_sv.sv" -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_oc_cal_sv.sv"             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_pi_phase_sv.sv"           -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_step_to_mon_en_sv.sv"     -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_adapt_tap_sv.sv"          -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_ctrl_mux_sv.sv"           -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_local_reset_sv.sv"        -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_cal_sim_sv.sv"            -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dfe_adapt_tap_sim_sv.sv"      -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_adce.sv"                      -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_adce_sv.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_adce_datactrl_sv.sv"          -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_sv.sv"                    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_cal.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_control.sv"               -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_datapath.sv"              -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_pll_reset.sv"             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_eye_width.sv"             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_align_clk.sv"             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_get_sum.sv"               -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_dcd_cal_sim_model.sv"         -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_mif.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_mif.sv"                        -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_mif_ctrl.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_mif_avmm.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_pll.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_pll.sv"                        -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_pll_ctrl.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_soc.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_cpu_ram.sv"                   -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_direct.sv"                    -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xrbasic_l2p_addr.sv"                         -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xrbasic_l2p_ch.sv"                           -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xrbasic_l2p_rom.sv"                          -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xrbasic_lif_csr.sv"                          -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xrbasic_lif.sv"                              -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_xcvr_reconfig_basic.sv"                      -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_arbiter_acq.sv"                             -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_reconfig_basic.sv"                     -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_arbiter.sv"                            -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_m2s.sv"                                -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k           "$QSYS_SIMDIR/alt_xcvr_reconfig/altera_wait_generate.v"                         -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/alt_xcvr_csr_selector.sv"                       -work alt_sv_gx_reconfctrl_x2
  vlogan +v2k -sverilog "$QSYS_SIMDIR/alt_xcvr_reconfig/sv_reconfig_bundle_to_basic.sv"                 -work alt_sv_gx_reconfctrl_x2
  vhdlan -xlrm          "$QSYS_SIMDIR/alt_sv_gx_reconfctrl_x2.vhd"                                                                   
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
