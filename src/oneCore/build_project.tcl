# Create Project and build the Block design
source mclp_block_design.tcl

generate_target all [get_files MC_light_propagation_proj/MC_light_propagation_proj.srcs/sources_1/bd/mclp_block_design/mclp_block_design.bd]

# Make HDL Wrapper
validate_bd_design
make_wrapper -files [get_files ./MC_light_propagation_proj/MC_light_propagation_proj.srcs/sources_1/bd/mclp_block_design/mclp_block_design.bd] -top
add_files -norecurse ./MC_light_propagation_proj/MC_light_propagation_proj.srcs/sources_1/bd/mclp_block_design/hdl/mclp_block_design_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add XDC
add_files -norecurse timing.xdc

# Add testing file
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse mc_tb.v
add_files -fileset sim_1 -norecurse mc_tb_behav.wcfg
set_property xsim.view mc_tb_behav.wcfg [get_filesets sim_1]

# Bind ELF file to program
add_files -fileset sim_1 -norecurse mblaze_ctrl_var_size.elf
set_property SCOPED_TO_REF mclp_block_design [get_files -all -of_objects [get_fileset sim_1] {mblaze_ctrl_var_size.elf}]
set_property SCOPED_TO_CELLS {microblaze_0} [get_files -all -of_objects [get_fileset sim_1] {mblaze_ctrl_var_size.elf}]

# Export to SDK
file mkdir MC_light_propagation_proj/MC_light_propagation_proj.sdk
write_hwdef -force -file MC_light_propagation_proj/MC_light_propagation_proj.sdk/mclp_block_design_wrapper.hdf
update_compile_order -fileset sim_1
