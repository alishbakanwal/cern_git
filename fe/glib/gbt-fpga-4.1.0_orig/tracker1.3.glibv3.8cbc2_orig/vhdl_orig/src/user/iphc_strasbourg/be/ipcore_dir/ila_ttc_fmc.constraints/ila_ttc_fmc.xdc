#
# Clock constraints
#
create_clock -name D_CLK [get_nets -hierarchical * -filter {NAME =~ *CLK}]
set_false_path -from [get_cells -hierarchical * -filter {NAME =~ */U0/*/U_STAT/U_DIRTY_LDC}] -to [all_registers -edge_triggered]
set_false_path -from [all_registers -edge_triggered] -to [get_cells -hierarchical * -filter {NAME =~ */U0/*/U_STAT/U_DIRTY_LDC}]

#
# Input keep/save net constraints
#
set_property DONT_TOUCH 1 [get_nets -hierarchical * -filter {NAME =~ */TRIG0*}]
set_property KEEP true [get_nets -hierarchical * -filter {NAME =~ */TRIG0*}]
set_property DONT_TOUCH 1 [get_nets -hierarchical * -filter {NAME =~ */DATA*}]
set_property KEEP true [get_nets -hierarchical * -filter {NAME =~ */DATA*}]
