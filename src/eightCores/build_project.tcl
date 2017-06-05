# Create Project and build the Block design
source mclp_block_design.tcl

generate_target all [get_files MC_light_propagation_proj/MC_light_propagation_proj.srcs/siyrces_1/bd/mclp_block_design/mclp_block_design.bd]

# Make HDL Wrapper
validate_bd_design
make_wrapper -files [get_files ./MC_light_propagation_proj/MC_light_propagation_proj.srcs/sources_1/bd/mclp_block_design/mclp_block_design.bd] -top
add_files -norecurse ./MC_light_propagation_proj/MC_light_propagation_proj.srcs/sources_1/bd/mclp_block_design/hdl/mclp_block_design_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add XDC
add_files -norecurse timing.xdc
