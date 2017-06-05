set_input_delay -clock [get_clocks sys_clock] -min -add_delay 2.000 [get_ports reset_rtl]
set_input_delay -clock [get_clocks sys_clock] -max -add_delay 3.000 [get_ports reset_rtl]
set_property IOSTANDARD LVCMOS18 [get_ports sys_clock]
set_property IOSTANDARD LVCMOS18 [get_ports reset_rtl]
set_property PACKAGE_PIN AM19 [get_ports sys_clock]
set_property PACKAGE_PIN AE15 [get_ports reset_rtl]


set_switching_activity -deassert_resets 
