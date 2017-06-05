open_project MC_light_prop_core -reset
set_top mc_light_prop
add_files hls_oneCore/mc_data_structures.h
add_files hls_onecore/mc_hls_log_init.cpp
add_files hls_onecore/mc_hls_simulator.cpp
add_files hls_onecore/mc_light_prop.cpp
add_files hls_onecore/my_tinymt32.h

add_files -tb hls_oneCore/mc_light_prop_tb.cpp
open_solution "solution1"
set_part {xcku115-flva1517-2-e}
create_clock -period 6 -name default
csim_design -clean -compiler gcc
csynth_design
export_design -format ip_catalog
exit
