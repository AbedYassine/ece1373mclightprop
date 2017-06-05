
################################################################
# This is a generated script based on design: mclp_block_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mclp_block_design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project MC_light_propagation_proj MC_light_propagation_proj -part xcku115-flva1517-2-e
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "MC_light_prop_core/solution1/impl/ip"]" $obj

# CHANGE DESIGN NAME HERE
set design_name mclp_block_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 lmb_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl
  set sys_clock [ create_bd_port -dir I -type clk sys_clock ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {200000000} \
CONFIG.PHASE {0.000} \
 ] $sys_clock

  # Create instance: absorption0, and set properties
  set absorption0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption0

  # Create instance: absorption1, and set properties
  set absorption1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption1 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption1

  # Create instance: absorption2, and set properties
  set absorption2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption2 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption2

  # Create instance: absorption3, and set properties
  set absorption3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption3 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption3

  # Create instance: absorption4, and set properties
  set absorption4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption4 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption4

  # Create instance: absorption5, and set properties
  set absorption5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption5 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption5

  # Create instance: absorption6, and set properties
  set absorption6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption6 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption6

  # Create instance: absorption7, and set properties
  set absorption7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption7 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption7

  # Create instance: absorption8, and set properties
  set absorption8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption8 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption8

  # Create instance: absorption9, and set properties
  set absorption9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption9 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption9

  # Create instance: absorption10, and set properties
  set absorption10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption10 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption10

  # Create instance: absorption11, and set properties
  set absorption11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption11 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption11

  # Create instance: absorption12, and set properties
  set absorption12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption12 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption12

  # Create instance: absorption13, and set properties
  set absorption13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption13 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption13

  # Create instance: absorption14, and set properties
  set absorption14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption14 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption14

  # Create instance: absorption15, and set properties
  set absorption15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption15 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption15

  # Create instance: absorption16, and set properties
  set absorption16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption16 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption16

  # Create instance: absorption17, and set properties
  set absorption17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption17 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption17

  # Create instance: absorption18, and set properties
  set absorption18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption18 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption18

  # Create instance: absorption19, and set properties
  set absorption19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption19 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption19

  # Create instance: absorption20, and set properties
  set absorption20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption20 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption20

  # Create instance: absorption21, and set properties
  set absorption21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption21 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption21

  # Create instance: absorption22, and set properties
  set absorption22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption22 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption22

  # Create instance: absorption23, and set properties
  set absorption23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption23 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption23

  # Create instance: absorption24, and set properties
  set absorption24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption24 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption24

  # Create instance: absorption25, and set properties
  set absorption25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption25 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption25

  # Create instance: absorption26, and set properties
  set absorption26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption26 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption26

  # Create instance: absorption27, and set properties
  set absorption27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption27 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption27

  # Create instance: absorption28, and set properties
  set absorption28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption28 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption28

  # Create instance: absorption29, and set properties
  set absorption29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption29 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption29

  # Create instance: absorption30, and set properties
  set absorption30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption30 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption30

  # Create instance: absorption31, and set properties
  set absorption31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption31 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption31

  # Create instance: absorption_0, and set properties
  set absorption_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_0 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_0

  # Create instance: absorption_1, and set properties
  set absorption_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_1 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_1

  # Create instance: absorption_2, and set properties
  set absorption_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_2 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_2

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_2

  # Create instance: absorption_3, and set properties
  set absorption_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_3 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_3

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_3

  # Create instance: absorption_4, and set properties
  set absorption_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_4 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_4

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_4

  # Create instance: absorption_5, and set properties
  set absorption_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_5 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_5

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_5

  # Create instance: absorption_6, and set properties
  set absorption_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_6 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_6

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_6

  # Create instance: absorption_7, and set properties
  set absorption_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_7 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_7

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_7

  # Create instance: absorption_8, and set properties
  set absorption_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_8 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_8

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_8

  # Create instance: absorption_9, and set properties
  set absorption_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_9 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_9

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_9

  # Create instance: absorption_10, and set properties
  set absorption_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_10 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_10

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_10

  # Create instance: absorption_11, and set properties
  set absorption_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_11 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_11

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_11

  # Create instance: absorption_12, and set properties
  set absorption_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_12 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_12

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_12

  # Create instance: absorption_13, and set properties
  set absorption_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_13 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_13

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_13

  # Create instance: absorption_14, and set properties
  set absorption_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_14 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_14

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_14

  # Create instance: absorption_15, and set properties
  set absorption_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_15 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_15

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_15

  # Create instance: absorption_16, and set properties
  set absorption_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_16 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_16

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_16

  # Create instance: absorption_17, and set properties
  set absorption_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_17 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_17

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_17

  # Create instance: absorption_18, and set properties
  set absorption_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_18 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_18

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_18

  # Create instance: absorption_19, and set properties
  set absorption_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_19 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_19

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_19

  # Create instance: absorption_20, and set properties
  set absorption_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_20 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_20

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_20

  # Create instance: absorption_21, and set properties
  set absorption_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_21 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_21

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_21

  # Create instance: absorption_22, and set properties
  set absorption_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_22 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_22

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_22

  # Create instance: absorption_23, and set properties
  set absorption_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_23 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_23

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_23

  # Create instance: absorption_24, and set properties
  set absorption_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_24 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_24

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_24

  # Create instance: absorption_25, and set properties
  set absorption_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_25 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_25

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_25

  # Create instance: absorption_26, and set properties
  set absorption_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_26 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_26

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_26

  # Create instance: absorption_27, and set properties
  set absorption_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_27 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_27

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_27

  # Create instance: absorption_28, and set properties
  set absorption_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_28 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_28

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_28

  # Create instance: absorption_29, and set properties
  set absorption_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_29 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_29

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_29

  # Create instance: absorption_30, and set properties
  set absorption_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_30 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_30

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_30

  # Create instance: absorption_31, and set properties
  set absorption_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 absorption_31 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $absorption_31

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $absorption_31

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.M04_HAS_REGSLICE {1} \
CONFIG.M05_HAS_REGSLICE {1} \
CONFIG.M06_HAS_REGSLICE {1} \
CONFIG.M07_HAS_REGSLICE {1} \
CONFIG.M08_HAS_REGSLICE {1} \
CONFIG.M09_HAS_REGSLICE {1} \
CONFIG.M10_HAS_REGSLICE {1} \
CONFIG.M11_HAS_REGSLICE {1} \
CONFIG.NUM_MI {12} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
CONFIG.NUM_MI {12} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_2

  # Create instance: axi_interconnect_4, and set properties
  set axi_interconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_4 ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_4

  # Create instance: axi_interconnect_5, and set properties
  set axi_interconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_5 ]
  set_property -dict [ list \
CONFIG.NUM_MI {12} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_5

  # Create instance: axi_interconnect_7, and set properties
  set axi_interconnect_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_7 ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_7

  # Create instance: axi_interconnect_8, and set properties
  set axi_interconnect_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_8 ]
  set_property -dict [ list \
CONFIG.NUM_MI {12} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_8

  # Create instance: axi_interconnect_10, and set properties
  set axi_interconnect_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_10 ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_10

  # Create instance: axi_interconnect_11, and set properties
  set axi_interconnect_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_11 ]
  set_property -dict [ list \
CONFIG.NUM_MI {12} \
CONFIG.NUM_SI {9} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S04_HAS_DATA_FIFO {2} \
CONFIG.S05_HAS_DATA_FIFO {2} \
CONFIG.S06_HAS_DATA_FIFO {2} \
CONFIG.S07_HAS_DATA_FIFO {2} \
CONFIG.S08_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_11

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_1 ]
  set_property -dict [ list \
CONFIG.AUTO_PRIMITIVE {MMCM} \
CONFIG.CLKIN1_JITTER_PS {50.0} \
CONFIG.CLKIN2_JITTER_PS {100.0} \
CONFIG.CLKOUT1_DRIVES {Buffer} \
CONFIG.CLKOUT1_JITTER {142.473} \
CONFIG.CLKOUT1_PHASE_ERROR {157.402} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150} \
CONFIG.CLKOUT2_DRIVES {Buffer} \
CONFIG.CLKOUT2_JITTER {270.900} \
CONFIG.CLKOUT2_PHASE_ERROR {404.105} \
CONFIG.CLKOUT2_USED {false} \
CONFIG.CLKOUT3_DRIVES {Buffer} \
CONFIG.CLKOUT4_DRIVES {Buffer} \
CONFIG.CLKOUT5_DRIVES {Buffer} \
CONFIG.CLKOUT6_DRIVES {Buffer} \
CONFIG.CLKOUT7_DRIVES {Buffer} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {19.875} \
CONFIG.MMCM_CLKIN1_PERIOD {5.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.625} \
CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
CONFIG.MMCM_COMPENSATION {AUTO} \
CONFIG.MMCM_DIVCLK_DIVIDE {4} \
CONFIG.NUM_OUT_CLKS {1} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.RESET_PORT {resetn} \
CONFIG.RESET_TYPE {ACTIVE_LOW} \
CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.USE_INCLK_SWITCHOVER {false} \
CONFIG.USE_LOCKED {true} \
CONFIG.USE_PHASE_ALIGNMENT {true} \
CONFIG.USE_RESET {true} \
 ] $clk_wiz_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_1

  # Create instance: material_idx0, and set properties
  set material_idx0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx0

  # Create instance: material_idx1, and set properties
  set material_idx1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx1 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx1

  # Create instance: material_idx2, and set properties
  set material_idx2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx2 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx2

  # Create instance: material_idx3, and set properties
  set material_idx3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx3 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx3

  # Create instance: material_idx4, and set properties
  set material_idx4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx4 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx4

  # Create instance: material_idx5, and set properties
  set material_idx5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx5 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx5

  # Create instance: material_idx6, and set properties
  set material_idx6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx6 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx6

  # Create instance: material_idx7, and set properties
  set material_idx7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx7 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx7

  # Create instance: material_idx8, and set properties
  set material_idx8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx8 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx8

  # Create instance: material_idx9, and set properties
  set material_idx9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx9 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx9

  # Create instance: material_idx10, and set properties
  set material_idx10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx10 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx10

  # Create instance: material_idx11, and set properties
  set material_idx11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx11 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx11

  # Create instance: material_idx12, and set properties
  set material_idx12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx12 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx12

  # Create instance: material_idx13, and set properties
  set material_idx13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx13 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx13

  # Create instance: material_idx14, and set properties
  set material_idx14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx14 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx14

  # Create instance: material_idx15, and set properties
  set material_idx15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx15 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $material_idx15

  # Create instance: material_idx_0, and set properties
  set material_idx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_0 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_0

  # Create instance: material_idx_1, and set properties
  set material_idx_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_1 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_1

  # Create instance: material_idx_2, and set properties
  set material_idx_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_2 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_2

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_2

  # Create instance: material_idx_3, and set properties
  set material_idx_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_3 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_3

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_3

  # Create instance: material_idx_4, and set properties
  set material_idx_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_4 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_4

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_4

  # Create instance: material_idx_5, and set properties
  set material_idx_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_5 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_5

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_5

  # Create instance: material_idx_6, and set properties
  set material_idx_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_6 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_6

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_6

  # Create instance: material_idx_7, and set properties
  set material_idx_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_7 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_7

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_7

  # Create instance: material_idx_8, and set properties
  set material_idx_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_8 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_8

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_8

  # Create instance: material_idx_9, and set properties
  set material_idx_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_9 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_9

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_9

  # Create instance: material_idx_10, and set properties
  set material_idx_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_10 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_10

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_10

  # Create instance: material_idx_11, and set properties
  set material_idx_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_11 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_11

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_11

  # Create instance: material_idx_12, and set properties
  set material_idx_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_12 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_12

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_12

  # Create instance: material_idx_13, and set properties
  set material_idx_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_13 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_13

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_13

  # Create instance: material_idx_14, and set properties
  set material_idx_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_14 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_14

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_14

  # Create instance: material_idx_15, and set properties
  set material_idx_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 material_idx_15 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $material_idx_15

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $material_idx_15

  # Create instance: materials_array0, and set properties
  set materials_array0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array0

  # Create instance: materials_array1, and set properties
  set materials_array1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array1 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array1

  # Create instance: materials_array2, and set properties
  set materials_array2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array2 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array2

  # Create instance: materials_array3, and set properties
  set materials_array3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array3 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array3

  # Create instance: materials_array4, and set properties
  set materials_array4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array4 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array4

  # Create instance: materials_array5, and set properties
  set materials_array5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array5 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array5

  # Create instance: materials_array6, and set properties
  set materials_array6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array6 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array6

  # Create instance: materials_array7, and set properties
  set materials_array7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array7 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array7

  # Create instance: materials_array8, and set properties
  set materials_array8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array8 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array8

  # Create instance: materials_array9, and set properties
  set materials_array9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array9 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array9

  # Create instance: materials_array10, and set properties
  set materials_array10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array10 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array10

  # Create instance: materials_array11, and set properties
  set materials_array11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array11 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array11

  # Create instance: materials_array12, and set properties
  set materials_array12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array12 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array12

  # Create instance: materials_array13, and set properties
  set materials_array13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array13 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array13

  # Create instance: materials_array14, and set properties
  set materials_array14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array14 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array14

  # Create instance: materials_array15, and set properties
  set materials_array15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array15 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {0} \
 ] $materials_array15

  # Create instance: materials_array_0, and set properties
  set materials_array_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_0 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_0

  # Create instance: materials_array_1, and set properties
  set materials_array_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_1 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_1

  # Create instance: materials_array_2, and set properties
  set materials_array_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_2 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_2

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_2

  # Create instance: materials_array_3, and set properties
  set materials_array_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_3 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_3

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_3

  # Create instance: materials_array_4, and set properties
  set materials_array_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_4 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_4

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_4

  # Create instance: materials_array_5, and set properties
  set materials_array_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_5 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_5

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_5

  # Create instance: materials_array_6, and set properties
  set materials_array_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_6 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_6

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_6

  # Create instance: materials_array_7, and set properties
  set materials_array_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_7 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_7

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_7

  # Create instance: materials_array_8, and set properties
  set materials_array_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_8 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_8

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_8

  # Create instance: materials_array_9, and set properties
  set materials_array_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_9 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_9

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_9

  # Create instance: materials_array_10, and set properties
  set materials_array_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_10 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_10

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_10

  # Create instance: materials_array_11, and set properties
  set materials_array_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_11 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_11

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_11

  # Create instance: materials_array_12, and set properties
  set materials_array_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_12 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_12

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_12

  # Create instance: materials_array_13, and set properties
  set materials_array_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_13 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_13

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_13

  # Create instance: materials_array_14, and set properties
  set materials_array_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_14 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_14

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_14

  # Create instance: materials_array_15, and set properties
  set materials_array_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 materials_array_15 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $materials_array_15

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $materials_array_15

  # Create instance: mc_light_prop_0, and set properties
  set mc_light_prop_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30100000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30110000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x30120000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x30130000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30000000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30010000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x30020000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x30030000} \
 ] $mc_light_prop_0

  # Create instance: mc_light_prop_1, and set properties
  set mc_light_prop_1 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_1 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30100000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30110000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x30120000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x30130000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30000000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30010000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x30020000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x30030000} \
 ] $mc_light_prop_1

  # Create instance: mc_light_prop_2, and set properties
  set mc_light_prop_2 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_2 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30140000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30150000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x30160000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x30170000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30040000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30050000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x30060000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x30070000} \
 ] $mc_light_prop_2

  # Create instance: mc_light_prop_3, and set properties
  set mc_light_prop_3 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_3 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30140000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30150000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x30160000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x30170000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30040000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30050000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x30060000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x30070000} \
 ] $mc_light_prop_3

  # Create instance: mc_light_prop_4, and set properties
  set mc_light_prop_4 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_4 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30180000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30190000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x301A0000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x301B0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30080000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30090000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x300A0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x300B0000} \
 ] $mc_light_prop_4

  # Create instance: mc_light_prop_5, and set properties
  set mc_light_prop_5 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_5 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x30180000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x30190000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x301A0000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x301B0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x30080000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x30090000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x300A0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x300B0000} \
 ] $mc_light_prop_5

  # Create instance: mc_light_prop_6, and set properties
  set mc_light_prop_6 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_6 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x38000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x3A000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x3C000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x3E000000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x300C0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x300D0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x300E0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x300F0000} \
 ] $mc_light_prop_6

  # Create instance: mc_light_prop_7, and set properties
  set mc_light_prop_7 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_7 ]
  set_property -dict [ list \
CONFIG.C_M_AXI_MATERIALS_ARRAY_0_TARGET_ADDR {0x38000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_1_TARGET_ADDR {0x3A000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_2_TARGET_ADDR {0x3C000000} \
CONFIG.C_M_AXI_MATERIALS_ARRAY_3_TARGET_ADDR {0x3E000000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_0_TARGET_ADDR {0x300C0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_1_TARGET_ADDR {0x300D0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_2_TARGET_ADDR {0x300E0000} \
CONFIG.C_M_AXI_MATERIAL_INDEX_BRAM_3_TARGET_ADDR {0x300F0000} \
 ] $mc_light_prop_7

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [ list \
CONFIG.C_USE_UART {0} \
 ] $mdm_1

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
CONFIG.C_DEBUG_ENABLED {2} \
CONFIG.C_D_AXI {1} \
CONFIG.C_D_LMB {1} \
CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net S01_AXI_2 [get_bd_intf_pins axi_interconnect_4/S01_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net S01_AXI_3 [get_bd_intf_pins axi_interconnect_7/S01_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net S01_AXI_4 [get_bd_intf_pins axi_interconnect_10/S01_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net S03_AXI_1 [get_bd_intf_pins axi_interconnect_1/S03_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_2 [get_bd_intf_pins axi_interconnect_2/S03_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_3 [get_bd_intf_pins axi_interconnect_4/S03_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_4 [get_bd_intf_pins axi_interconnect_5/S03_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_5 [get_bd_intf_pins axi_interconnect_7/S03_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_6 [get_bd_intf_pins axi_interconnect_8/S03_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_7 [get_bd_intf_pins axi_interconnect_10/S03_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S03_AXI_8 [get_bd_intf_pins axi_interconnect_11/S03_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_materials_array_2]
  connect_bd_intf_net -intf_net S04_AXI_1 [get_bd_intf_pins axi_interconnect_1/S04_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_2 [get_bd_intf_pins axi_interconnect_2/S04_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_3 [get_bd_intf_pins axi_interconnect_4/S04_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_4 [get_bd_intf_pins axi_interconnect_5/S04_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_5 [get_bd_intf_pins axi_interconnect_7/S04_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_6 [get_bd_intf_pins axi_interconnect_8/S04_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_7 [get_bd_intf_pins axi_interconnect_10/S04_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S04_AXI_8 [get_bd_intf_pins axi_interconnect_11/S04_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_materials_array_3]
  connect_bd_intf_net -intf_net S05_AXI_1 [get_bd_intf_pins axi_interconnect_1/S05_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_2 [get_bd_intf_pins axi_interconnect_2/S05_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_3 [get_bd_intf_pins axi_interconnect_4/S05_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_4 [get_bd_intf_pins axi_interconnect_5/S05_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_5 [get_bd_intf_pins axi_interconnect_7/S05_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_6 [get_bd_intf_pins axi_interconnect_8/S05_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_7 [get_bd_intf_pins axi_interconnect_10/S05_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S05_AXI_8 [get_bd_intf_pins axi_interconnect_11/S05_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_material_index_bram_0]
  connect_bd_intf_net -intf_net S06_AXI_1 [get_bd_intf_pins axi_interconnect_1/S06_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_2 [get_bd_intf_pins axi_interconnect_2/S06_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_3 [get_bd_intf_pins axi_interconnect_4/S06_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_4 [get_bd_intf_pins axi_interconnect_5/S06_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_5 [get_bd_intf_pins axi_interconnect_7/S06_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_6 [get_bd_intf_pins axi_interconnect_8/S06_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_7 [get_bd_intf_pins axi_interconnect_10/S06_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S06_AXI_8 [get_bd_intf_pins axi_interconnect_11/S06_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_material_index_bram_1]
  connect_bd_intf_net -intf_net S07_AXI_1 [get_bd_intf_pins axi_interconnect_1/S07_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net S07_AXI_2 [get_bd_intf_pins axi_interconnect_4/S07_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net S07_AXI_3 [get_bd_intf_pins axi_interconnect_7/S07_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net S07_AXI_4 [get_bd_intf_pins axi_interconnect_10/S07_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net S08_AXI_1 [get_bd_intf_pins axi_interconnect_1/S08_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_2 [get_bd_intf_pins axi_interconnect_2/S08_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_3 [get_bd_intf_pins axi_interconnect_4/S08_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_4 [get_bd_intf_pins axi_interconnect_5/S08_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_5 [get_bd_intf_pins axi_interconnect_7/S08_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_6 [get_bd_intf_pins axi_interconnect_8/S08_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_7 [get_bd_intf_pins axi_interconnect_10/S08_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net S08_AXI_8 [get_bd_intf_pins axi_interconnect_11/S08_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_material_index_bram_3]
  connect_bd_intf_net -intf_net absorption10_BRAM_PORTA [get_bd_intf_pins absorption10/BRAM_PORTA] [get_bd_intf_pins absorption_10/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption11_BRAM_PORTA [get_bd_intf_pins absorption11/BRAM_PORTA] [get_bd_intf_pins absorption_11/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption12_BRAM_PORTA [get_bd_intf_pins absorption12/BRAM_PORTA] [get_bd_intf_pins absorption_12/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption13_BRAM_PORTA [get_bd_intf_pins absorption13/BRAM_PORTA] [get_bd_intf_pins absorption_13/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption14_BRAM_PORTA [get_bd_intf_pins absorption14/BRAM_PORTA] [get_bd_intf_pins absorption_14/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption15_BRAM_PORTA [get_bd_intf_pins absorption15/BRAM_PORTA] [get_bd_intf_pins absorption_15/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption16_BRAM_PORTA [get_bd_intf_pins absorption16/BRAM_PORTA] [get_bd_intf_pins absorption_16/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption17_BRAM_PORTA [get_bd_intf_pins absorption17/BRAM_PORTA] [get_bd_intf_pins absorption_17/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption18_BRAM_PORTA [get_bd_intf_pins absorption18/BRAM_PORTA] [get_bd_intf_pins absorption_18/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption19_BRAM_PORTA [get_bd_intf_pins absorption19/BRAM_PORTA] [get_bd_intf_pins absorption_19/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption8_BRAM_PORTA [get_bd_intf_pins absorption8/BRAM_PORTA] [get_bd_intf_pins absorption_8/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption9_BRAM_PORTA [get_bd_intf_pins absorption9/BRAM_PORTA] [get_bd_intf_pins absorption_9/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_1_BRAM_PORTA [get_bd_intf_pins absorption4/BRAM_PORTA] [get_bd_intf_pins absorption_4/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_1_BRAM_PORTA2 [get_bd_intf_pins absorption20/BRAM_PORTA] [get_bd_intf_pins absorption_20/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_1_BRAM_PORTA3 [get_bd_intf_pins absorption28/BRAM_PORTA] [get_bd_intf_pins absorption_28/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption0/BRAM_PORTA] [get_bd_intf_pins absorption_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins absorption24/BRAM_PORTA] [get_bd_intf_pins absorption_24/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_1_BRAM_PORTA [get_bd_intf_pins absorption5/BRAM_PORTA] [get_bd_intf_pins absorption_5/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_1_BRAM_PORTA2 [get_bd_intf_pins absorption21/BRAM_PORTA] [get_bd_intf_pins absorption_21/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_1_BRAM_PORTA3 [get_bd_intf_pins absorption29/BRAM_PORTA] [get_bd_intf_pins absorption_29/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption1/BRAM_PORTA] [get_bd_intf_pins absorption_1/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins absorption25/BRAM_PORTA] [get_bd_intf_pins absorption_25/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_1_BRAM_PORTA [get_bd_intf_pins absorption6/BRAM_PORTA] [get_bd_intf_pins absorption_6/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_1_BRAM_PORTA2 [get_bd_intf_pins absorption22/BRAM_PORTA] [get_bd_intf_pins absorption_22/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_1_BRAM_PORTA3 [get_bd_intf_pins absorption30/BRAM_PORTA] [get_bd_intf_pins absorption_30/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption2/BRAM_PORTA] [get_bd_intf_pins absorption_2/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins absorption26/BRAM_PORTA] [get_bd_intf_pins absorption_26/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_1_BRAM_PORTA [get_bd_intf_pins absorption7/BRAM_PORTA] [get_bd_intf_pins absorption_7/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_1_BRAM_PORTA2 [get_bd_intf_pins absorption23/BRAM_PORTA] [get_bd_intf_pins absorption_23/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_1_BRAM_PORTA3 [get_bd_intf_pins absorption31/BRAM_PORTA] [get_bd_intf_pins absorption_31/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption3/BRAM_PORTA] [get_bd_intf_pins absorption_3/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins absorption27/BRAM_PORTA] [get_bd_intf_pins absorption_27/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins mc_light_prop_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins mc_light_prop_1/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_interconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins mc_light_prop_2/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins mc_light_prop_3/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins axi_interconnect_7/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins mc_light_prop_4/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins mc_light_prop_5/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_interconnect_0/M09_AXI] [get_bd_intf_pins axi_interconnect_10/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins mc_light_prop_6/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins axi_interconnect_0/M11_AXI] [get_bd_intf_pins mc_light_prop_7/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI1 [get_bd_intf_pins axi_interconnect_4/M00_AXI] [get_bd_intf_pins axi_interconnect_5/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI2 [get_bd_intf_pins axi_interconnect_7/M00_AXI] [get_bd_intf_pins axi_interconnect_8/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI3 [get_bd_intf_pins axi_interconnect_10/M00_AXI] [get_bd_intf_pins axi_interconnect_11/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins absorption0/S_AXI] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI3 [get_bd_intf_pins absorption24/S_AXI] [get_bd_intf_pins axi_interconnect_10/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins absorption1/S_AXI] [get_bd_intf_pins axi_interconnect_1/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI3 [get_bd_intf_pins absorption25/S_AXI] [get_bd_intf_pins axi_interconnect_10/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins absorption2/S_AXI] [get_bd_intf_pins axi_interconnect_1/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI3 [get_bd_intf_pins absorption26/S_AXI] [get_bd_intf_pins axi_interconnect_10/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M04_AXI [get_bd_intf_pins absorption3/S_AXI] [get_bd_intf_pins axi_interconnect_1/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M04_AXI3 [get_bd_intf_pins absorption27/S_AXI] [get_bd_intf_pins axi_interconnect_10/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins absorption4/S_AXI] [get_bd_intf_pins axi_interconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI2 [get_bd_intf_pins absorption20/S_AXI] [get_bd_intf_pins axi_interconnect_8/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI3 [get_bd_intf_pins absorption28/S_AXI] [get_bd_intf_pins axi_interconnect_11/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M01_AXI [get_bd_intf_pins absorption5/S_AXI] [get_bd_intf_pins axi_interconnect_2/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M01_AXI2 [get_bd_intf_pins absorption21/S_AXI] [get_bd_intf_pins axi_interconnect_8/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M01_AXI3 [get_bd_intf_pins absorption29/S_AXI] [get_bd_intf_pins axi_interconnect_11/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M02_AXI [get_bd_intf_pins absorption6/S_AXI] [get_bd_intf_pins axi_interconnect_2/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M02_AXI2 [get_bd_intf_pins absorption22/S_AXI] [get_bd_intf_pins axi_interconnect_8/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M02_AXI3 [get_bd_intf_pins absorption30/S_AXI] [get_bd_intf_pins axi_interconnect_11/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M03_AXI [get_bd_intf_pins absorption7/S_AXI] [get_bd_intf_pins axi_interconnect_2/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M03_AXI2 [get_bd_intf_pins absorption23/S_AXI] [get_bd_intf_pins axi_interconnect_8/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M03_AXI3 [get_bd_intf_pins absorption31/S_AXI] [get_bd_intf_pins axi_interconnect_11/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M04_AXI [get_bd_intf_pins axi_interconnect_2/M04_AXI] [get_bd_intf_pins material_idx0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M04_AXI1 [get_bd_intf_pins axi_interconnect_5/M04_AXI] [get_bd_intf_pins material_idx4/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M04_AXI2 [get_bd_intf_pins axi_interconnect_8/M04_AXI] [get_bd_intf_pins material_idx8/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M04_AXI3 [get_bd_intf_pins axi_interconnect_11/M04_AXI] [get_bd_intf_pins material_idx12/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M05_AXI [get_bd_intf_pins axi_interconnect_2/M05_AXI] [get_bd_intf_pins material_idx1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M05_AXI1 [get_bd_intf_pins axi_interconnect_5/M05_AXI] [get_bd_intf_pins material_idx5/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M05_AXI2 [get_bd_intf_pins axi_interconnect_8/M05_AXI] [get_bd_intf_pins material_idx9/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M05_AXI3 [get_bd_intf_pins axi_interconnect_11/M05_AXI] [get_bd_intf_pins material_idx13/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M06_AXI [get_bd_intf_pins axi_interconnect_2/M06_AXI] [get_bd_intf_pins material_idx2/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M06_AXI1 [get_bd_intf_pins axi_interconnect_5/M06_AXI] [get_bd_intf_pins material_idx6/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M06_AXI2 [get_bd_intf_pins axi_interconnect_8/M06_AXI] [get_bd_intf_pins material_idx10/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M06_AXI3 [get_bd_intf_pins axi_interconnect_11/M06_AXI] [get_bd_intf_pins material_idx14/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M07_AXI [get_bd_intf_pins axi_interconnect_2/M07_AXI] [get_bd_intf_pins material_idx3/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M07_AXI1 [get_bd_intf_pins axi_interconnect_5/M07_AXI] [get_bd_intf_pins material_idx7/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M07_AXI2 [get_bd_intf_pins axi_interconnect_8/M07_AXI] [get_bd_intf_pins material_idx11/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M07_AXI3 [get_bd_intf_pins axi_interconnect_11/M07_AXI] [get_bd_intf_pins material_idx15/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M08_AXI [get_bd_intf_pins axi_interconnect_2/M08_AXI] [get_bd_intf_pins materials_array0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M08_AXI1 [get_bd_intf_pins axi_interconnect_5/M08_AXI] [get_bd_intf_pins materials_array4/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M08_AXI2 [get_bd_intf_pins axi_interconnect_8/M08_AXI] [get_bd_intf_pins materials_array8/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M08_AXI3 [get_bd_intf_pins axi_interconnect_11/M08_AXI] [get_bd_intf_pins materials_array12/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M09_AXI [get_bd_intf_pins axi_interconnect_2/M09_AXI] [get_bd_intf_pins materials_array1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M09_AXI1 [get_bd_intf_pins axi_interconnect_5/M09_AXI] [get_bd_intf_pins materials_array5/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M09_AXI2 [get_bd_intf_pins axi_interconnect_8/M09_AXI] [get_bd_intf_pins materials_array9/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M09_AXI3 [get_bd_intf_pins axi_interconnect_11/M09_AXI] [get_bd_intf_pins materials_array13/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M10_AXI [get_bd_intf_pins axi_interconnect_2/M10_AXI] [get_bd_intf_pins materials_array2/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M10_AXI1 [get_bd_intf_pins axi_interconnect_5/M10_AXI] [get_bd_intf_pins materials_array6/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M10_AXI2 [get_bd_intf_pins axi_interconnect_8/M10_AXI] [get_bd_intf_pins materials_array10/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M10_AXI3 [get_bd_intf_pins axi_interconnect_11/M10_AXI] [get_bd_intf_pins materials_array14/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M11_AXI [get_bd_intf_pins axi_interconnect_2/M11_AXI] [get_bd_intf_pins materials_array3/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M11_AXI1 [get_bd_intf_pins axi_interconnect_5/M11_AXI] [get_bd_intf_pins materials_array7/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M11_AXI2 [get_bd_intf_pins axi_interconnect_8/M11_AXI] [get_bd_intf_pins materials_array11/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M11_AXI3 [get_bd_intf_pins axi_interconnect_11/M11_AXI] [get_bd_intf_pins materials_array15/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_4_M01_AXI [get_bd_intf_pins absorption8/S_AXI] [get_bd_intf_pins axi_interconnect_4/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_4_M02_AXI [get_bd_intf_pins absorption9/S_AXI] [get_bd_intf_pins axi_interconnect_4/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_4_M03_AXI [get_bd_intf_pins absorption10/S_AXI] [get_bd_intf_pins axi_interconnect_4/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_4_M04_AXI [get_bd_intf_pins absorption11/S_AXI] [get_bd_intf_pins axi_interconnect_4/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_5_M00_AXI [get_bd_intf_pins absorption12/S_AXI] [get_bd_intf_pins axi_interconnect_5/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_5_M01_AXI [get_bd_intf_pins absorption13/S_AXI] [get_bd_intf_pins axi_interconnect_5/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_5_M02_AXI [get_bd_intf_pins absorption14/S_AXI] [get_bd_intf_pins axi_interconnect_5/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_5_M03_AXI [get_bd_intf_pins absorption15/S_AXI] [get_bd_intf_pins axi_interconnect_5/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_7_M01_AXI [get_bd_intf_pins absorption16/S_AXI] [get_bd_intf_pins axi_interconnect_7/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_7_M02_AXI [get_bd_intf_pins absorption17/S_AXI] [get_bd_intf_pins axi_interconnect_7/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_7_M03_AXI [get_bd_intf_pins absorption18/S_AXI] [get_bd_intf_pins axi_interconnect_7/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_7_M04_AXI [get_bd_intf_pins absorption19/S_AXI] [get_bd_intf_pins axi_interconnect_7/M04_AXI]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins material_idx0/BRAM_PORTA] [get_bd_intf_pins material_idx_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins material_idx4/BRAM_PORTA] [get_bd_intf_pins material_idx_4/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins material_idx8/BRAM_PORTA] [get_bd_intf_pins material_idx_8/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins material_idx12/BRAM_PORTA] [get_bd_intf_pins material_idx_12/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTB [get_bd_intf_pins material_idx0/BRAM_PORTB] [get_bd_intf_pins material_idx_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins material_idx4/BRAM_PORTB] [get_bd_intf_pins material_idx_4/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins material_idx8/BRAM_PORTB] [get_bd_intf_pins material_idx_8/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins material_idx12/BRAM_PORTB] [get_bd_intf_pins material_idx_12/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTA [get_bd_intf_pins material_idx1/BRAM_PORTA] [get_bd_intf_pins material_idx_1/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins material_idx5/BRAM_PORTA] [get_bd_intf_pins material_idx_5/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins material_idx9/BRAM_PORTA] [get_bd_intf_pins material_idx_9/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins material_idx13/BRAM_PORTA] [get_bd_intf_pins material_idx_13/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTB [get_bd_intf_pins material_idx1/BRAM_PORTB] [get_bd_intf_pins material_idx_1/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins material_idx5/BRAM_PORTB] [get_bd_intf_pins material_idx_5/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins material_idx9/BRAM_PORTB] [get_bd_intf_pins material_idx_9/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_1_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins material_idx13/BRAM_PORTB] [get_bd_intf_pins material_idx_13/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTA [get_bd_intf_pins material_idx2/BRAM_PORTA] [get_bd_intf_pins material_idx_2/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins material_idx6/BRAM_PORTA] [get_bd_intf_pins material_idx_6/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins material_idx10/BRAM_PORTA] [get_bd_intf_pins material_idx_10/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins material_idx14/BRAM_PORTA] [get_bd_intf_pins material_idx_14/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTB [get_bd_intf_pins material_idx2/BRAM_PORTB] [get_bd_intf_pins material_idx_2/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins material_idx6/BRAM_PORTB] [get_bd_intf_pins material_idx_6/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins material_idx10/BRAM_PORTB] [get_bd_intf_pins material_idx_10/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_2_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins material_idx14/BRAM_PORTB] [get_bd_intf_pins material_idx_14/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTA [get_bd_intf_pins material_idx3/BRAM_PORTA] [get_bd_intf_pins material_idx_3/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins material_idx7/BRAM_PORTA] [get_bd_intf_pins material_idx_7/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins material_idx11/BRAM_PORTA] [get_bd_intf_pins material_idx_11/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins material_idx15/BRAM_PORTA] [get_bd_intf_pins material_idx_15/BRAM_PORTA]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTB [get_bd_intf_pins material_idx3/BRAM_PORTB] [get_bd_intf_pins material_idx_3/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins material_idx7/BRAM_PORTB] [get_bd_intf_pins material_idx_7/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins material_idx11/BRAM_PORTB] [get_bd_intf_pins material_idx_11/BRAM_PORTB]
  connect_bd_intf_net -intf_net material_idx_3_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins material_idx15/BRAM_PORTB] [get_bd_intf_pins material_idx_15/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array0/BRAM_PORTA] [get_bd_intf_pins materials_array_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins materials_array4/BRAM_PORTA] [get_bd_intf_pins materials_array_4/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins materials_array8/BRAM_PORTA] [get_bd_intf_pins materials_array_8/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins materials_array12/BRAM_PORTA] [get_bd_intf_pins materials_array_12/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTB [get_bd_intf_pins materials_array0/BRAM_PORTB] [get_bd_intf_pins materials_array_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins materials_array4/BRAM_PORTB] [get_bd_intf_pins materials_array_4/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins materials_array8/BRAM_PORTB] [get_bd_intf_pins materials_array_8/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins materials_array12/BRAM_PORTB] [get_bd_intf_pins materials_array_12/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_1_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array1/BRAM_PORTA] [get_bd_intf_pins materials_array_1/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_1_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins materials_array5/BRAM_PORTA] [get_bd_intf_pins materials_array_5/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_1_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins materials_array9/BRAM_PORTA] [get_bd_intf_pins materials_array_9/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_1_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins materials_array13/BRAM_PORTA] [get_bd_intf_pins materials_array_13/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array2/BRAM_PORTA] [get_bd_intf_pins materials_array_2/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins materials_array6/BRAM_PORTA] [get_bd_intf_pins materials_array_6/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins materials_array10/BRAM_PORTA] [get_bd_intf_pins materials_array_10/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins materials_array14/BRAM_PORTA] [get_bd_intf_pins materials_array_14/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTB [get_bd_intf_pins materials_array2/BRAM_PORTB] [get_bd_intf_pins materials_array_2/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins materials_array6/BRAM_PORTB] [get_bd_intf_pins materials_array_6/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins materials_array10/BRAM_PORTB] [get_bd_intf_pins materials_array_10/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_2_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins materials_array14/BRAM_PORTB] [get_bd_intf_pins materials_array_14/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array3/BRAM_PORTA] [get_bd_intf_pins materials_array_3/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTA1 [get_bd_intf_pins materials_array7/BRAM_PORTA] [get_bd_intf_pins materials_array_7/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTA2 [get_bd_intf_pins materials_array11/BRAM_PORTA] [get_bd_intf_pins materials_array_11/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTA3 [get_bd_intf_pins materials_array15/BRAM_PORTA] [get_bd_intf_pins materials_array_15/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTB [get_bd_intf_pins materials_array3/BRAM_PORTB] [get_bd_intf_pins materials_array_3/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTB1 [get_bd_intf_pins materials_array7/BRAM_PORTB] [get_bd_intf_pins materials_array_7/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTB2 [get_bd_intf_pins materials_array11/BRAM_PORTB] [get_bd_intf_pins materials_array_11/BRAM_PORTB]
  connect_bd_intf_net -intf_net materials_array_3_axi_ctrl_BRAM_PORTB3 [get_bd_intf_pins materials_array15/BRAM_PORTB] [get_bd_intf_pins materials_array_15/BRAM_PORTB]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_0_PORTA [get_bd_intf_pins absorption_0/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_0_PORTA1 [get_bd_intf_pins absorption_8/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_2/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_0_PORTA2 [get_bd_intf_pins absorption_16/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_4/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_0_PORTA3 [get_bd_intf_pins absorption_24/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_6/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_1_PORTA [get_bd_intf_pins absorption_1/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_1_PORTA1 [get_bd_intf_pins absorption_9/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_2/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_1_PORTA2 [get_bd_intf_pins absorption_17/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_4/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_1_PORTA3 [get_bd_intf_pins absorption_25/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_6/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_2_PORTA [get_bd_intf_pins absorption_2/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_2_PORTA1 [get_bd_intf_pins absorption_10/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_2/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_2_PORTA2 [get_bd_intf_pins absorption_18/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_4/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_2_PORTA3 [get_bd_intf_pins absorption_26/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_6/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_3_PORTA [get_bd_intf_pins absorption_3/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_3_PORTA1 [get_bd_intf_pins absorption_11/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_2/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_3_PORTA2 [get_bd_intf_pins absorption_19/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_4/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_3_PORTA3 [get_bd_intf_pins absorption_27/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_6/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_m_axi_materials_array_1 [get_bd_intf_pins axi_interconnect_1/S02_AXI] [get_bd_intf_pins mc_light_prop_0/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_0_m_axi_materials_array_2 [get_bd_intf_pins axi_interconnect_4/S02_AXI] [get_bd_intf_pins mc_light_prop_2/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_0_m_axi_materials_array_3 [get_bd_intf_pins axi_interconnect_7/S02_AXI] [get_bd_intf_pins mc_light_prop_4/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_0_m_axi_materials_array_4 [get_bd_intf_pins axi_interconnect_10/S02_AXI] [get_bd_intf_pins mc_light_prop_6/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_1_PORTA [get_bd_intf_pins materials_array1/BRAM_PORTB] [get_bd_intf_pins materials_array_1/BRAM_PORTB]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_1_PORTA1 [get_bd_intf_pins materials_array5/BRAM_PORTB] [get_bd_intf_pins materials_array_5/BRAM_PORTB]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_1_PORTA2 [get_bd_intf_pins materials_array9/BRAM_PORTB] [get_bd_intf_pins materials_array_9/BRAM_PORTB]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_1_PORTA3 [get_bd_intf_pins materials_array13/BRAM_PORTB] [get_bd_intf_pins materials_array_13/BRAM_PORTB]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_0_PORTA [get_bd_intf_pins absorption_4/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_1/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_0_PORTA1 [get_bd_intf_pins absorption_12/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_3/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_0_PORTA2 [get_bd_intf_pins absorption_20/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_5/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_0_PORTA3 [get_bd_intf_pins absorption_28/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_7/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_1_PORTA [get_bd_intf_pins absorption_5/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_1/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_1_PORTA1 [get_bd_intf_pins absorption_13/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_3/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_1_PORTA2 [get_bd_intf_pins absorption_21/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_5/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_1_PORTA3 [get_bd_intf_pins absorption_29/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_7/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_2_PORTA [get_bd_intf_pins absorption_6/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_1/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_2_PORTA1 [get_bd_intf_pins absorption_14/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_3/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_2_PORTA2 [get_bd_intf_pins absorption_22/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_5/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_2_PORTA3 [get_bd_intf_pins absorption_30/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_7/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_3_PORTA [get_bd_intf_pins absorption_7/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_1/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_3_PORTA1 [get_bd_intf_pins absorption_15/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_3/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_3_PORTA2 [get_bd_intf_pins absorption_23/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_5/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_absorption_bram_3_PORTA3 [get_bd_intf_pins absorption_31/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_7/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_material_index_bram_2 [get_bd_intf_pins axi_interconnect_2/S07_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_material_index_bram_3 [get_bd_intf_pins axi_interconnect_5/S07_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_material_index_bram_4 [get_bd_intf_pins axi_interconnect_8/S07_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_material_index_bram_5 [get_bd_intf_pins axi_interconnect_11/S07_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_material_index_bram_2]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_0 [get_bd_intf_pins axi_interconnect_2/S01_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_1 [get_bd_intf_pins axi_interconnect_2/S02_AXI] [get_bd_intf_pins mc_light_prop_1/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_2 [get_bd_intf_pins axi_interconnect_5/S01_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_3 [get_bd_intf_pins axi_interconnect_5/S02_AXI] [get_bd_intf_pins mc_light_prop_3/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_4 [get_bd_intf_pins axi_interconnect_8/S01_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_5 [get_bd_intf_pins axi_interconnect_8/S02_AXI] [get_bd_intf_pins mc_light_prop_5/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_6 [get_bd_intf_pins axi_interconnect_11/S01_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_materials_array_0]
  connect_bd_intf_net -intf_net mc_light_prop_1_m_axi_materials_array_7 [get_bd_intf_pins axi_interconnect_11/S02_AXI] [get_bd_intf_pins mc_light_prop_7/m_axi_materials_array_1]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_10/ARESETN] [get_bd_pins axi_interconnect_11/ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_4/ARESETN] [get_bd_pins axi_interconnect_5/ARESETN] [get_bd_pins axi_interconnect_7/ARESETN] [get_bd_pins axi_interconnect_8/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
  connect_bd_net -net clock_rtl_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins absorption0/s_axi_aclk] [get_bd_pins absorption1/s_axi_aclk] [get_bd_pins absorption10/s_axi_aclk] [get_bd_pins absorption11/s_axi_aclk] [get_bd_pins absorption12/s_axi_aclk] [get_bd_pins absorption13/s_axi_aclk] [get_bd_pins absorption14/s_axi_aclk] [get_bd_pins absorption15/s_axi_aclk] [get_bd_pins absorption16/s_axi_aclk] [get_bd_pins absorption17/s_axi_aclk] [get_bd_pins absorption18/s_axi_aclk] [get_bd_pins absorption19/s_axi_aclk] [get_bd_pins absorption2/s_axi_aclk] [get_bd_pins absorption20/s_axi_aclk] [get_bd_pins absorption21/s_axi_aclk] [get_bd_pins absorption22/s_axi_aclk] [get_bd_pins absorption23/s_axi_aclk] [get_bd_pins absorption24/s_axi_aclk] [get_bd_pins absorption25/s_axi_aclk] [get_bd_pins absorption26/s_axi_aclk] [get_bd_pins absorption27/s_axi_aclk] [get_bd_pins absorption28/s_axi_aclk] [get_bd_pins absorption29/s_axi_aclk] [get_bd_pins absorption3/s_axi_aclk] [get_bd_pins absorption30/s_axi_aclk] [get_bd_pins absorption31/s_axi_aclk] [get_bd_pins absorption4/s_axi_aclk] [get_bd_pins absorption5/s_axi_aclk] [get_bd_pins absorption6/s_axi_aclk] [get_bd_pins absorption7/s_axi_aclk] [get_bd_pins absorption8/s_axi_aclk] [get_bd_pins absorption9/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_interconnect_1/M04_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_1/S02_ACLK] [get_bd_pins axi_interconnect_1/S03_ACLK] [get_bd_pins axi_interconnect_1/S04_ACLK] [get_bd_pins axi_interconnect_1/S05_ACLK] [get_bd_pins axi_interconnect_1/S06_ACLK] [get_bd_pins axi_interconnect_1/S07_ACLK] [get_bd_pins axi_interconnect_1/S08_ACLK] [get_bd_pins axi_interconnect_10/ACLK] [get_bd_pins axi_interconnect_10/M00_ACLK] [get_bd_pins axi_interconnect_10/M01_ACLK] [get_bd_pins axi_interconnect_10/M02_ACLK] [get_bd_pins axi_interconnect_10/M03_ACLK] [get_bd_pins axi_interconnect_10/M04_ACLK] [get_bd_pins axi_interconnect_10/S00_ACLK] [get_bd_pins axi_interconnect_10/S01_ACLK] [get_bd_pins axi_interconnect_10/S02_ACLK] [get_bd_pins axi_interconnect_10/S03_ACLK] [get_bd_pins axi_interconnect_10/S04_ACLK] [get_bd_pins axi_interconnect_10/S05_ACLK] [get_bd_pins axi_interconnect_10/S06_ACLK] [get_bd_pins axi_interconnect_10/S07_ACLK] [get_bd_pins axi_interconnect_10/S08_ACLK] [get_bd_pins axi_interconnect_11/ACLK] [get_bd_pins axi_interconnect_11/M00_ACLK] [get_bd_pins axi_interconnect_11/M01_ACLK] [get_bd_pins axi_interconnect_11/M02_ACLK] [get_bd_pins axi_interconnect_11/M03_ACLK] [get_bd_pins axi_interconnect_11/M04_ACLK] [get_bd_pins axi_interconnect_11/M05_ACLK] [get_bd_pins axi_interconnect_11/M06_ACLK] [get_bd_pins axi_interconnect_11/M07_ACLK] [get_bd_pins axi_interconnect_11/M08_ACLK] [get_bd_pins axi_interconnect_11/M09_ACLK] [get_bd_pins axi_interconnect_11/M10_ACLK] [get_bd_pins axi_interconnect_11/M11_ACLK] [get_bd_pins axi_interconnect_11/S00_ACLK] [get_bd_pins axi_interconnect_11/S01_ACLK] [get_bd_pins axi_interconnect_11/S02_ACLK] [get_bd_pins axi_interconnect_11/S03_ACLK] [get_bd_pins axi_interconnect_11/S04_ACLK] [get_bd_pins axi_interconnect_11/S05_ACLK] [get_bd_pins axi_interconnect_11/S06_ACLK] [get_bd_pins axi_interconnect_11/S07_ACLK] [get_bd_pins axi_interconnect_11/S08_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_interconnect_2/M01_ACLK] [get_bd_pins axi_interconnect_2/M02_ACLK] [get_bd_pins axi_interconnect_2/M03_ACLK] [get_bd_pins axi_interconnect_2/M04_ACLK] [get_bd_pins axi_interconnect_2/M05_ACLK] [get_bd_pins axi_interconnect_2/M06_ACLK] [get_bd_pins axi_interconnect_2/M07_ACLK] [get_bd_pins axi_interconnect_2/M08_ACLK] [get_bd_pins axi_interconnect_2/M09_ACLK] [get_bd_pins axi_interconnect_2/M10_ACLK] [get_bd_pins axi_interconnect_2/M11_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins axi_interconnect_2/S02_ACLK] [get_bd_pins axi_interconnect_2/S03_ACLK] [get_bd_pins axi_interconnect_2/S04_ACLK] [get_bd_pins axi_interconnect_2/S05_ACLK] [get_bd_pins axi_interconnect_2/S06_ACLK] [get_bd_pins axi_interconnect_2/S07_ACLK] [get_bd_pins axi_interconnect_2/S08_ACLK] [get_bd_pins axi_interconnect_4/ACLK] [get_bd_pins axi_interconnect_4/M00_ACLK] [get_bd_pins axi_interconnect_4/M01_ACLK] [get_bd_pins axi_interconnect_4/M02_ACLK] [get_bd_pins axi_interconnect_4/M03_ACLK] [get_bd_pins axi_interconnect_4/M04_ACLK] [get_bd_pins axi_interconnect_4/S00_ACLK] [get_bd_pins axi_interconnect_4/S01_ACLK] [get_bd_pins axi_interconnect_4/S02_ACLK] [get_bd_pins axi_interconnect_4/S03_ACLK] [get_bd_pins axi_interconnect_4/S04_ACLK] [get_bd_pins axi_interconnect_4/S05_ACLK] [get_bd_pins axi_interconnect_4/S06_ACLK] [get_bd_pins axi_interconnect_4/S07_ACLK] [get_bd_pins axi_interconnect_4/S08_ACLK] [get_bd_pins axi_interconnect_5/ACLK] [get_bd_pins axi_interconnect_5/M00_ACLK] [get_bd_pins axi_interconnect_5/M01_ACLK] [get_bd_pins axi_interconnect_5/M02_ACLK] [get_bd_pins axi_interconnect_5/M03_ACLK] [get_bd_pins axi_interconnect_5/M04_ACLK] [get_bd_pins axi_interconnect_5/M05_ACLK] [get_bd_pins axi_interconnect_5/M06_ACLK] [get_bd_pins axi_interconnect_5/M07_ACLK] [get_bd_pins axi_interconnect_5/M08_ACLK] [get_bd_pins axi_interconnect_5/M09_ACLK] [get_bd_pins axi_interconnect_5/M10_ACLK] [get_bd_pins axi_interconnect_5/M11_ACLK] [get_bd_pins axi_interconnect_5/S00_ACLK] [get_bd_pins axi_interconnect_5/S01_ACLK] [get_bd_pins axi_interconnect_5/S02_ACLK] [get_bd_pins axi_interconnect_5/S03_ACLK] [get_bd_pins axi_interconnect_5/S04_ACLK] [get_bd_pins axi_interconnect_5/S05_ACLK] [get_bd_pins axi_interconnect_5/S06_ACLK] [get_bd_pins axi_interconnect_5/S07_ACLK] [get_bd_pins axi_interconnect_5/S08_ACLK] [get_bd_pins axi_interconnect_7/ACLK] [get_bd_pins axi_interconnect_7/M00_ACLK] [get_bd_pins axi_interconnect_7/M01_ACLK] [get_bd_pins axi_interconnect_7/M02_ACLK] [get_bd_pins axi_interconnect_7/M03_ACLK] [get_bd_pins axi_interconnect_7/M04_ACLK] [get_bd_pins axi_interconnect_7/S00_ACLK] [get_bd_pins axi_interconnect_7/S01_ACLK] [get_bd_pins axi_interconnect_7/S02_ACLK] [get_bd_pins axi_interconnect_7/S03_ACLK] [get_bd_pins axi_interconnect_7/S04_ACLK] [get_bd_pins axi_interconnect_7/S05_ACLK] [get_bd_pins axi_interconnect_7/S06_ACLK] [get_bd_pins axi_interconnect_7/S07_ACLK] [get_bd_pins axi_interconnect_7/S08_ACLK] [get_bd_pins axi_interconnect_8/ACLK] [get_bd_pins axi_interconnect_8/M00_ACLK] [get_bd_pins axi_interconnect_8/M01_ACLK] [get_bd_pins axi_interconnect_8/M02_ACLK] [get_bd_pins axi_interconnect_8/M03_ACLK] [get_bd_pins axi_interconnect_8/M04_ACLK] [get_bd_pins axi_interconnect_8/M05_ACLK] [get_bd_pins axi_interconnect_8/M06_ACLK] [get_bd_pins axi_interconnect_8/M07_ACLK] [get_bd_pins axi_interconnect_8/M08_ACLK] [get_bd_pins axi_interconnect_8/M09_ACLK] [get_bd_pins axi_interconnect_8/M10_ACLK] [get_bd_pins axi_interconnect_8/M11_ACLK] [get_bd_pins axi_interconnect_8/S00_ACLK] [get_bd_pins axi_interconnect_8/S01_ACLK] [get_bd_pins axi_interconnect_8/S02_ACLK] [get_bd_pins axi_interconnect_8/S03_ACLK] [get_bd_pins axi_interconnect_8/S04_ACLK] [get_bd_pins axi_interconnect_8/S05_ACLK] [get_bd_pins axi_interconnect_8/S06_ACLK] [get_bd_pins axi_interconnect_8/S07_ACLK] [get_bd_pins axi_interconnect_8/S08_ACLK] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins material_idx0/s_axi_aclk] [get_bd_pins material_idx1/s_axi_aclk] [get_bd_pins material_idx10/s_axi_aclk] [get_bd_pins material_idx11/s_axi_aclk] [get_bd_pins material_idx12/s_axi_aclk] [get_bd_pins material_idx13/s_axi_aclk] [get_bd_pins material_idx14/s_axi_aclk] [get_bd_pins material_idx15/s_axi_aclk] [get_bd_pins material_idx2/s_axi_aclk] [get_bd_pins material_idx3/s_axi_aclk] [get_bd_pins material_idx4/s_axi_aclk] [get_bd_pins material_idx5/s_axi_aclk] [get_bd_pins material_idx6/s_axi_aclk] [get_bd_pins material_idx7/s_axi_aclk] [get_bd_pins material_idx8/s_axi_aclk] [get_bd_pins material_idx9/s_axi_aclk] [get_bd_pins materials_array0/s_axi_aclk] [get_bd_pins materials_array1/s_axi_aclk] [get_bd_pins materials_array10/s_axi_aclk] [get_bd_pins materials_array11/s_axi_aclk] [get_bd_pins materials_array12/s_axi_aclk] [get_bd_pins materials_array13/s_axi_aclk] [get_bd_pins materials_array14/s_axi_aclk] [get_bd_pins materials_array15/s_axi_aclk] [get_bd_pins materials_array2/s_axi_aclk] [get_bd_pins materials_array3/s_axi_aclk] [get_bd_pins materials_array4/s_axi_aclk] [get_bd_pins materials_array5/s_axi_aclk] [get_bd_pins materials_array6/s_axi_aclk] [get_bd_pins materials_array7/s_axi_aclk] [get_bd_pins materials_array8/s_axi_aclk] [get_bd_pins materials_array9/s_axi_aclk] [get_bd_pins mc_light_prop_0/ap_clk] [get_bd_pins mc_light_prop_1/ap_clk] [get_bd_pins mc_light_prop_2/ap_clk] [get_bd_pins mc_light_prop_3/ap_clk] [get_bd_pins mc_light_prop_4/ap_clk] [get_bd_pins mc_light_prop_5/ap_clk] [get_bd_pins mc_light_prop_6/ap_clk] [get_bd_pins mc_light_prop_7/ap_clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl] [get_bd_pins clk_wiz_1/resetn] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins absorption0/s_axi_aresetn] [get_bd_pins absorption1/s_axi_aresetn] [get_bd_pins absorption10/s_axi_aresetn] [get_bd_pins absorption11/s_axi_aresetn] [get_bd_pins absorption12/s_axi_aresetn] [get_bd_pins absorption13/s_axi_aresetn] [get_bd_pins absorption14/s_axi_aresetn] [get_bd_pins absorption15/s_axi_aresetn] [get_bd_pins absorption16/s_axi_aresetn] [get_bd_pins absorption17/s_axi_aresetn] [get_bd_pins absorption18/s_axi_aresetn] [get_bd_pins absorption19/s_axi_aresetn] [get_bd_pins absorption2/s_axi_aresetn] [get_bd_pins absorption20/s_axi_aresetn] [get_bd_pins absorption21/s_axi_aresetn] [get_bd_pins absorption22/s_axi_aresetn] [get_bd_pins absorption23/s_axi_aresetn] [get_bd_pins absorption24/s_axi_aresetn] [get_bd_pins absorption25/s_axi_aresetn] [get_bd_pins absorption26/s_axi_aresetn] [get_bd_pins absorption27/s_axi_aresetn] [get_bd_pins absorption28/s_axi_aresetn] [get_bd_pins absorption29/s_axi_aresetn] [get_bd_pins absorption3/s_axi_aresetn] [get_bd_pins absorption30/s_axi_aresetn] [get_bd_pins absorption31/s_axi_aresetn] [get_bd_pins absorption4/s_axi_aresetn] [get_bd_pins absorption5/s_axi_aresetn] [get_bd_pins absorption6/s_axi_aresetn] [get_bd_pins absorption7/s_axi_aresetn] [get_bd_pins absorption8/s_axi_aresetn] [get_bd_pins absorption9/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_interconnect_1/M04_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_1/S02_ARESETN] [get_bd_pins axi_interconnect_1/S03_ARESETN] [get_bd_pins axi_interconnect_1/S04_ARESETN] [get_bd_pins axi_interconnect_1/S05_ARESETN] [get_bd_pins axi_interconnect_1/S06_ARESETN] [get_bd_pins axi_interconnect_1/S07_ARESETN] [get_bd_pins axi_interconnect_1/S08_ARESETN] [get_bd_pins axi_interconnect_10/M00_ARESETN] [get_bd_pins axi_interconnect_10/M01_ARESETN] [get_bd_pins axi_interconnect_10/M02_ARESETN] [get_bd_pins axi_interconnect_10/M03_ARESETN] [get_bd_pins axi_interconnect_10/M04_ARESETN] [get_bd_pins axi_interconnect_10/S00_ARESETN] [get_bd_pins axi_interconnect_10/S01_ARESETN] [get_bd_pins axi_interconnect_10/S02_ARESETN] [get_bd_pins axi_interconnect_10/S03_ARESETN] [get_bd_pins axi_interconnect_10/S04_ARESETN] [get_bd_pins axi_interconnect_10/S05_ARESETN] [get_bd_pins axi_interconnect_10/S06_ARESETN] [get_bd_pins axi_interconnect_10/S07_ARESETN] [get_bd_pins axi_interconnect_10/S08_ARESETN] [get_bd_pins axi_interconnect_11/M00_ARESETN] [get_bd_pins axi_interconnect_11/M01_ARESETN] [get_bd_pins axi_interconnect_11/M02_ARESETN] [get_bd_pins axi_interconnect_11/M03_ARESETN] [get_bd_pins axi_interconnect_11/M04_ARESETN] [get_bd_pins axi_interconnect_11/M05_ARESETN] [get_bd_pins axi_interconnect_11/M06_ARESETN] [get_bd_pins axi_interconnect_11/M07_ARESETN] [get_bd_pins axi_interconnect_11/M08_ARESETN] [get_bd_pins axi_interconnect_11/M09_ARESETN] [get_bd_pins axi_interconnect_11/M10_ARESETN] [get_bd_pins axi_interconnect_11/M11_ARESETN] [get_bd_pins axi_interconnect_11/S00_ARESETN] [get_bd_pins axi_interconnect_11/S01_ARESETN] [get_bd_pins axi_interconnect_11/S02_ARESETN] [get_bd_pins axi_interconnect_11/S03_ARESETN] [get_bd_pins axi_interconnect_11/S04_ARESETN] [get_bd_pins axi_interconnect_11/S05_ARESETN] [get_bd_pins axi_interconnect_11/S06_ARESETN] [get_bd_pins axi_interconnect_11/S07_ARESETN] [get_bd_pins axi_interconnect_11/S08_ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins axi_interconnect_2/M01_ARESETN] [get_bd_pins axi_interconnect_2/M02_ARESETN] [get_bd_pins axi_interconnect_2/M03_ARESETN] [get_bd_pins axi_interconnect_2/M04_ARESETN] [get_bd_pins axi_interconnect_2/M05_ARESETN] [get_bd_pins axi_interconnect_2/M06_ARESETN] [get_bd_pins axi_interconnect_2/M07_ARESETN] [get_bd_pins axi_interconnect_2/M08_ARESETN] [get_bd_pins axi_interconnect_2/M09_ARESETN] [get_bd_pins axi_interconnect_2/M10_ARESETN] [get_bd_pins axi_interconnect_2/M11_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins axi_interconnect_2/S02_ARESETN] [get_bd_pins axi_interconnect_2/S03_ARESETN] [get_bd_pins axi_interconnect_2/S04_ARESETN] [get_bd_pins axi_interconnect_2/S05_ARESETN] [get_bd_pins axi_interconnect_2/S06_ARESETN] [get_bd_pins axi_interconnect_2/S07_ARESETN] [get_bd_pins axi_interconnect_2/S08_ARESETN] [get_bd_pins axi_interconnect_4/M00_ARESETN] [get_bd_pins axi_interconnect_4/M01_ARESETN] [get_bd_pins axi_interconnect_4/M02_ARESETN] [get_bd_pins axi_interconnect_4/M03_ARESETN] [get_bd_pins axi_interconnect_4/M04_ARESETN] [get_bd_pins axi_interconnect_4/S00_ARESETN] [get_bd_pins axi_interconnect_4/S01_ARESETN] [get_bd_pins axi_interconnect_4/S02_ARESETN] [get_bd_pins axi_interconnect_4/S03_ARESETN] [get_bd_pins axi_interconnect_4/S04_ARESETN] [get_bd_pins axi_interconnect_4/S05_ARESETN] [get_bd_pins axi_interconnect_4/S06_ARESETN] [get_bd_pins axi_interconnect_4/S07_ARESETN] [get_bd_pins axi_interconnect_4/S08_ARESETN] [get_bd_pins axi_interconnect_5/M00_ARESETN] [get_bd_pins axi_interconnect_5/M01_ARESETN] [get_bd_pins axi_interconnect_5/M02_ARESETN] [get_bd_pins axi_interconnect_5/M03_ARESETN] [get_bd_pins axi_interconnect_5/M04_ARESETN] [get_bd_pins axi_interconnect_5/M05_ARESETN] [get_bd_pins axi_interconnect_5/M06_ARESETN] [get_bd_pins axi_interconnect_5/M07_ARESETN] [get_bd_pins axi_interconnect_5/M08_ARESETN] [get_bd_pins axi_interconnect_5/M09_ARESETN] [get_bd_pins axi_interconnect_5/M10_ARESETN] [get_bd_pins axi_interconnect_5/M11_ARESETN] [get_bd_pins axi_interconnect_5/S00_ARESETN] [get_bd_pins axi_interconnect_5/S01_ARESETN] [get_bd_pins axi_interconnect_5/S02_ARESETN] [get_bd_pins axi_interconnect_5/S03_ARESETN] [get_bd_pins axi_interconnect_5/S04_ARESETN] [get_bd_pins axi_interconnect_5/S05_ARESETN] [get_bd_pins axi_interconnect_5/S06_ARESETN] [get_bd_pins axi_interconnect_5/S07_ARESETN] [get_bd_pins axi_interconnect_5/S08_ARESETN] [get_bd_pins axi_interconnect_7/M00_ARESETN] [get_bd_pins axi_interconnect_7/M01_ARESETN] [get_bd_pins axi_interconnect_7/M02_ARESETN] [get_bd_pins axi_interconnect_7/M03_ARESETN] [get_bd_pins axi_interconnect_7/M04_ARESETN] [get_bd_pins axi_interconnect_7/S00_ARESETN] [get_bd_pins axi_interconnect_7/S01_ARESETN] [get_bd_pins axi_interconnect_7/S02_ARESETN] [get_bd_pins axi_interconnect_7/S03_ARESETN] [get_bd_pins axi_interconnect_7/S04_ARESETN] [get_bd_pins axi_interconnect_7/S05_ARESETN] [get_bd_pins axi_interconnect_7/S06_ARESETN] [get_bd_pins axi_interconnect_7/S07_ARESETN] [get_bd_pins axi_interconnect_7/S08_ARESETN] [get_bd_pins axi_interconnect_8/M00_ARESETN] [get_bd_pins axi_interconnect_8/M01_ARESETN] [get_bd_pins axi_interconnect_8/M02_ARESETN] [get_bd_pins axi_interconnect_8/M03_ARESETN] [get_bd_pins axi_interconnect_8/M04_ARESETN] [get_bd_pins axi_interconnect_8/M05_ARESETN] [get_bd_pins axi_interconnect_8/M06_ARESETN] [get_bd_pins axi_interconnect_8/M07_ARESETN] [get_bd_pins axi_interconnect_8/M08_ARESETN] [get_bd_pins axi_interconnect_8/M09_ARESETN] [get_bd_pins axi_interconnect_8/M10_ARESETN] [get_bd_pins axi_interconnect_8/M11_ARESETN] [get_bd_pins axi_interconnect_8/S00_ARESETN] [get_bd_pins axi_interconnect_8/S01_ARESETN] [get_bd_pins axi_interconnect_8/S02_ARESETN] [get_bd_pins axi_interconnect_8/S03_ARESETN] [get_bd_pins axi_interconnect_8/S04_ARESETN] [get_bd_pins axi_interconnect_8/S05_ARESETN] [get_bd_pins axi_interconnect_8/S06_ARESETN] [get_bd_pins axi_interconnect_8/S07_ARESETN] [get_bd_pins axi_interconnect_8/S08_ARESETN] [get_bd_pins material_idx0/s_axi_aresetn] [get_bd_pins material_idx1/s_axi_aresetn] [get_bd_pins material_idx10/s_axi_aresetn] [get_bd_pins material_idx11/s_axi_aresetn] [get_bd_pins material_idx12/s_axi_aresetn] [get_bd_pins material_idx13/s_axi_aresetn] [get_bd_pins material_idx14/s_axi_aresetn] [get_bd_pins material_idx15/s_axi_aresetn] [get_bd_pins material_idx2/s_axi_aresetn] [get_bd_pins material_idx3/s_axi_aresetn] [get_bd_pins material_idx4/s_axi_aresetn] [get_bd_pins material_idx5/s_axi_aresetn] [get_bd_pins material_idx6/s_axi_aresetn] [get_bd_pins material_idx7/s_axi_aresetn] [get_bd_pins material_idx8/s_axi_aresetn] [get_bd_pins material_idx9/s_axi_aresetn] [get_bd_pins materials_array0/s_axi_aresetn] [get_bd_pins materials_array1/s_axi_aresetn] [get_bd_pins materials_array10/s_axi_aresetn] [get_bd_pins materials_array11/s_axi_aresetn] [get_bd_pins materials_array12/s_axi_aresetn] [get_bd_pins materials_array13/s_axi_aresetn] [get_bd_pins materials_array14/s_axi_aresetn] [get_bd_pins materials_array15/s_axi_aresetn] [get_bd_pins materials_array2/s_axi_aresetn] [get_bd_pins materials_array3/s_axi_aresetn] [get_bd_pins materials_array4/s_axi_aresetn] [get_bd_pins materials_array5/s_axi_aresetn] [get_bd_pins materials_array6/s_axi_aresetn] [get_bd_pins materials_array7/s_axi_aresetn] [get_bd_pins materials_array8/s_axi_aresetn] [get_bd_pins materials_array9/s_axi_aresetn] [get_bd_pins mc_light_prop_0/ap_rst_n] [get_bd_pins mc_light_prop_1/ap_rst_n] [get_bd_pins mc_light_prop_2/ap_rst_n] [get_bd_pins mc_light_prop_3/ap_rst_n] [get_bd_pins mc_light_prop_4/ap_rst_n] [get_bd_pins mc_light_prop_5/ap_rst_n] [get_bd_pins mc_light_prop_6/ap_rst_n] [get_bd_pins mc_light_prop_7/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_0/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces mc_light_prop_1/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_2/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces mc_light_prop_3/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_4/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces mc_light_prop_5/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_6/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_3] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_0] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_0] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_1] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_2] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_2] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_materials_array_3] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces mc_light_prop_7/Data_m_axi_material_index_bram_1] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption0/S_AXI/Mem0] SEG_absorption0_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20050000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption10/S_AXI/Mem0] SEG_absorption10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20060000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption11/S_AXI/Mem0] SEG_absorption11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20070000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption12/S_AXI/Mem0] SEG_absorption12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20080000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption13/S_AXI/Mem0] SEG_absorption13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20090000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption14/S_AXI/Mem0] SEG_absorption14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x200A0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption15/S_AXI/Mem0] SEG_absorption15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20100000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption16/S_AXI/Mem0] SEG_absorption16_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20120000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption17/S_AXI/Mem0] SEG_absorption17_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20140000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption18/S_AXI/Mem0] SEG_absorption18_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20160000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption19/S_AXI/Mem0] SEG_absorption19_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20002000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption1/S_AXI/Mem0] SEG_absorption1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20180000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption20/S_AXI/Mem0] SEG_absorption20_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201A0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption21/S_AXI/Mem0] SEG_absorption21_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201C0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption22/S_AXI/Mem0] SEG_absorption22_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201D0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption23/S_AXI/Mem0] SEG_absorption23_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201E0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption24/S_AXI/Mem0] SEG_absorption24_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x201F0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption25/S_AXI/Mem0] SEG_absorption25_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption26/S_AXI/Mem0] SEG_absorption26_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20210000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption27/S_AXI/Mem0] SEG_absorption27_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20220000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption28/S_AXI/Mem0] SEG_absorption28_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20230000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption29/S_AXI/Mem0] SEG_absorption29_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20004000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption2/S_AXI/Mem0] SEG_absorption2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20240000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption30/S_AXI/Mem0] SEG_absorption30_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20250000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption31/S_AXI/Mem0] SEG_absorption31_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20006000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption3/S_AXI/Mem0] SEG_absorption3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20008000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption4/S_AXI/Mem0] SEG_absorption4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000A000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption5/S_AXI/Mem0] SEG_absorption5_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000C000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption6/S_AXI/Mem0] SEG_absorption6_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2000E000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption7/S_AXI/Mem0] SEG_absorption7_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption8/S_AXI/Mem0] SEG_absorption8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x20030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption9/S_AXI/Mem0] SEG_absorption9_Mem0
  create_bd_addr_seg -range 0x00100000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx0/S_AXI/Mem0] SEG_material_idx0_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300A0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx10/S_AXI/Mem0] SEG_material_idx10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300B0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx11/S_AXI/Mem0] SEG_material_idx11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300C0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx12/S_AXI/Mem0] SEG_material_idx12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300D0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx13/S_AXI/Mem0] SEG_material_idx13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300E0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx14/S_AXI/Mem0] SEG_material_idx14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x300F0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx15/S_AXI/Mem0] SEG_material_idx15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx1/S_AXI/Mem0] SEG_material_idx1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30020000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx2/S_AXI/Mem0] SEG_material_idx2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx3/S_AXI/Mem0] SEG_material_idx3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30040000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx4/S_AXI/Mem0] SEG_material_idx4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30050000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx5/S_AXI/Mem0] SEG_material_idx5_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30060000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx6/S_AXI/Mem0] SEG_material_idx6_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30070000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx7/S_AXI/Mem0] SEG_material_idx7_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30080000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx8/S_AXI/Mem0] SEG_material_idx8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30090000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx9/S_AXI/Mem0] SEG_material_idx9_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30100000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array0/S_AXI/Mem0] SEG_materials_array0_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301A0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array10/S_AXI/Mem0] SEG_materials_array10_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x301B0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array11/S_AXI/Mem0] SEG_materials_array11_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array12/S_AXI/Mem0] SEG_materials_array12_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array13/S_AXI/Mem0] SEG_materials_array13_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array14/S_AXI/Mem0] SEG_materials_array14_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array15/S_AXI/Mem0] SEG_materials_array15_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30110000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array1/S_AXI/Mem0] SEG_materials_array1_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30120000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array2/S_AXI/Mem0] SEG_materials_array2_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30130000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array3/S_AXI/Mem0] SEG_materials_array3_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30140000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array4/S_AXI/Mem0] SEG_materials_array4_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30150000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array5/S_AXI/Mem0] SEG_materials_array5_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30160000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array6/S_AXI/Mem0] SEG_materials_array6_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30170000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array7/S_AXI/Mem0] SEG_materials_array7_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30180000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array8/S_AXI/Mem0] SEG_materials_array8_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x30190000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array9/S_AXI/Mem0] SEG_materials_array9_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_0/s_axi_AXILiteS/Reg] SEG_mc_light_prop_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_1/s_axi_AXILiteS/Reg] SEG_mc_light_prop_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_2/s_axi_AXILiteS/Reg] SEG_mc_light_prop_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_3/s_axi_AXILiteS/Reg] SEG_mc_light_prop_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A40000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_4/s_axi_AXILiteS/Reg] SEG_mc_light_prop_4_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A50000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_5/s_axi_AXILiteS/Reg] SEG_mc_light_prop_5_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_6/s_axi_AXILiteS/Reg] SEG_mc_light_prop_6_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_7/s_axi_AXILiteS/Reg] SEG_mc_light_prop_7_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port reset_rtl -pg 1 -y 3590 -defaultsOSRD
preplace port sys_clock -pg 1 -y 3660 -defaultsOSRD
preplace inst absorption11 -pg 1 -lvl 7 -y 1630 -defaultsOSRD
preplace inst absorption_31 -pg 1 -lvl 9 -y 7530 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 6 -y 660 -defaultsOSRD
preplace inst absorption1 -pg 1 -lvl 7 -y 420 -defaultsOSRD
preplace inst absorption12 -pg 1 -lvl 8 -y 3360 -defaultsOSRD
preplace inst axi_interconnect_2 -pg 1 -lvl 7 -y 2560 -defaultsOSRD
preplace inst materials_array0 -pg 1 -lvl 8 -y 2450 -defaultsOSRD
preplace inst absorption2 -pg 1 -lvl 7 -y 540 -defaultsOSRD
preplace inst absorption13 -pg 1 -lvl 8 -y 2930 -defaultsOSRD
preplace inst materials_array1 -pg 1 -lvl 8 -y 2570 -defaultsOSRD
preplace inst absorption3 -pg 1 -lvl 7 -y 720 -defaultsOSRD
preplace inst absorption14 -pg 1 -lvl 8 -y 3070 -defaultsOSRD
preplace inst materials_array2 -pg 1 -lvl 8 -y 2690 -defaultsOSRD
preplace inst absorption4 -pg 1 -lvl 8 -y 2180 -defaultsOSRD
preplace inst axi_interconnect_4 -pg 1 -lvl 6 -y 1570 -defaultsOSRD
preplace inst absorption15 -pg 1 -lvl 8 -y 3480 -defaultsOSRD
preplace inst materials_array3 -pg 1 -lvl 8 -y 2810 -defaultsOSRD
preplace inst absorption5 -pg 1 -lvl 8 -y 2330 -defaultsOSRD
preplace inst axi_interconnect_5 -pg 1 -lvl 7 -y 3750 -defaultsOSRD
preplace inst absorption16 -pg 1 -lvl 7 -y 4420 -defaultsOSRD
preplace inst materials_array4 -pg 1 -lvl 8 -y 3960 -defaultsOSRD
preplace inst absorption6 -pg 1 -lvl 8 -y 1900 -defaultsOSRD
preplace inst absorption17 -pg 1 -lvl 7 -y 4690 -defaultsOSRD
preplace inst axi_interconnect_7 -pg 1 -lvl 6 -y 4690 -defaultsOSRD
preplace inst materials_array5 -pg 1 -lvl 8 -y 4080 -defaultsOSRD
preplace inst absorption7 -pg 1 -lvl 8 -y 2040 -defaultsOSRD
preplace inst absorption18 -pg 1 -lvl 7 -y 4570 -defaultsOSRD
preplace inst absorption8 -pg 1 -lvl 7 -y 1190 -defaultsOSRD
preplace inst materials_array_10 -pg 1 -lvl 9 -y 6990 -defaultsOSRD
preplace inst axi_interconnect_8 -pg 1 -lvl 7 -y 6560 -defaultsOSRD
preplace inst materials_array6 -pg 1 -lvl 8 -y 4200 -defaultsOSRD
preplace inst absorption19 -pg 1 -lvl 7 -y 4810 -defaultsOSRD
preplace inst absorption9 -pg 1 -lvl 7 -y 1330 -defaultsOSRD
preplace inst materials_array_11 -pg 1 -lvl 9 -y 7110 -defaultsOSRD
preplace inst materials_array7 -pg 1 -lvl 8 -y 4320 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 1 -y 3650 -defaultsOSRD
preplace inst materials_array_12 -pg 1 -lvl 9 -y 8260 -defaultsOSRD
preplace inst materials_array8 -pg 1 -lvl 8 -y 6730 -defaultsOSRD
preplace inst materials_array_13 -pg 1 -lvl 9 -y 8380 -defaultsOSRD
preplace inst materials_array9 -pg 1 -lvl 8 -y 6850 -defaultsOSRD
preplace inst materials_array_14 -pg 1 -lvl 9 -y 8500 -defaultsOSRD
preplace inst materials_array_15 -pg 1 -lvl 9 -y 8620 -defaultsOSRD
preplace inst microblaze_0_local_memory -pg 1 -lvl 4 -y 3460 -defaultsOSRD
preplace inst absorption_0 -pg 1 -lvl 8 -y 200 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 3 -y 3450 -defaultsOSRD
preplace inst absorption_1 -pg 1 -lvl 8 -y 430 -defaultsOSRD
preplace inst absorption_20 -pg 1 -lvl 9 -y 5940 -defaultsOSRD
preplace inst absorption_2 -pg 1 -lvl 8 -y 550 -defaultsOSRD
preplace inst materials_array10 -pg 1 -lvl 8 -y 6990 -defaultsOSRD
preplace inst absorption_21 -pg 1 -lvl 9 -y 6110 -defaultsOSRD
preplace inst absorption_3 -pg 1 -lvl 8 -y 730 -defaultsOSRD
preplace inst materials_array11 -pg 1 -lvl 8 -y 7110 -defaultsOSRD
preplace inst absorption_22 -pg 1 -lvl 9 -y 6260 -defaultsOSRD
preplace inst absorption_4 -pg 1 -lvl 9 -y 2240 -defaultsOSRD
preplace inst materials_array12 -pg 1 -lvl 8 -y 8260 -defaultsOSRD
preplace inst absorption_23 -pg 1 -lvl 9 -y 6380 -defaultsOSRD
preplace inst absorption_5 -pg 1 -lvl 9 -y 2340 -defaultsOSRD
preplace inst materials_array13 -pg 1 -lvl 8 -y 8380 -defaultsOSRD
preplace inst absorption_24 -pg 1 -lvl 8 -y 4980 -defaultsOSRD
preplace inst absorption_6 -pg 1 -lvl 9 -y 1960 -defaultsOSRD
preplace inst materials_array_0 -pg 1 -lvl 9 -y 2450 -defaultsOSRD
preplace inst materials_array14 -pg 1 -lvl 8 -y 8500 -defaultsOSRD
preplace inst absorption_25 -pg 1 -lvl 8 -y 5080 -defaultsOSRD
preplace inst materials_array_1 -pg 1 -lvl 9 -y 2570 -defaultsOSRD
preplace inst absorption_7 -pg 1 -lvl 9 -y 2100 -defaultsOSRD
preplace inst materials_array15 -pg 1 -lvl 8 -y 8620 -defaultsOSRD
preplace inst absorption_26 -pg 1 -lvl 8 -y 5180 -defaultsOSRD
preplace inst materials_array_2 -pg 1 -lvl 9 -y 2690 -defaultsOSRD
preplace inst material_idx_0 -pg 1 -lvl 9 -y 1420 -defaultsOSRD
preplace inst absorption_8 -pg 1 -lvl 8 -y 1010 -defaultsOSRD
preplace inst absorption_27 -pg 1 -lvl 8 -y 5280 -defaultsOSRD
preplace inst materials_array_3 -pg 1 -lvl 9 -y 2810 -defaultsOSRD
preplace inst material_idx_1 -pg 1 -lvl 9 -y 1540 -defaultsOSRD
preplace inst absorption_9 -pg 1 -lvl 8 -y 1110 -defaultsOSRD
preplace inst absorption_28 -pg 1 -lvl 9 -y 7910 -defaultsOSRD
preplace inst materials_array_4 -pg 1 -lvl 9 -y 3960 -defaultsOSRD
preplace inst material_idx_2 -pg 1 -lvl 9 -y 1660 -defaultsOSRD
preplace inst material_idx0 -pg 1 -lvl 8 -y 1420 -defaultsOSRD
preplace inst absorption_29 -pg 1 -lvl 9 -y 7810 -defaultsOSRD
preplace inst materials_array_5 -pg 1 -lvl 9 -y 4080 -defaultsOSRD
preplace inst material_idx_3 -pg 1 -lvl 9 -y 1780 -defaultsOSRD
preplace inst material_idx1 -pg 1 -lvl 8 -y 1540 -defaultsOSRD
preplace inst materials_array_6 -pg 1 -lvl 9 -y 4200 -defaultsOSRD
preplace inst material_idx_4 -pg 1 -lvl 9 -y 3210 -defaultsOSRD
preplace inst material_idx2 -pg 1 -lvl 8 -y 1660 -defaultsOSRD
preplace inst material_idx_5 -pg 1 -lvl 9 -y 3600 -defaultsOSRD
preplace inst material_idx3 -pg 1 -lvl 8 -y 1780 -defaultsOSRD
preplace inst materials_array_7 -pg 1 -lvl 9 -y 4320 -defaultsOSRD
preplace inst mc_light_prop_0 -pg 1 -lvl 5 -y 170 -defaultsOSRD
preplace inst materials_array_8 -pg 1 -lvl 9 -y 6730 -defaultsOSRD
preplace inst material_idx_6 -pg 1 -lvl 9 -y 3720 -defaultsOSRD
preplace inst material_idx4 -pg 1 -lvl 8 -y 3210 -defaultsOSRD
preplace inst mc_light_prop_1 -pg 1 -lvl 5 -y 2180 -defaultsOSRD
preplace inst materials_array_9 -pg 1 -lvl 9 -y 6850 -defaultsOSRD
preplace inst absorption20 -pg 1 -lvl 8 -y 5980 -defaultsOSRD
preplace inst material_idx_7 -pg 1 -lvl 9 -y 3840 -defaultsOSRD
preplace inst material_idx5 -pg 1 -lvl 8 -y 3600 -defaultsOSRD
preplace inst mc_light_prop_2 -pg 1 -lvl 5 -y 1070 -defaultsOSRD
preplace inst material_idx_8 -pg 1 -lvl 9 -y 5720 -defaultsOSRD
preplace inst absorption21 -pg 1 -lvl 8 -y 6100 -defaultsOSRD
preplace inst material_idx6 -pg 1 -lvl 8 -y 3720 -defaultsOSRD
preplace inst mc_light_prop_3 -pg 1 -lvl 5 -y 3370 -defaultsOSRD
preplace inst material_idx_9 -pg 1 -lvl 9 -y 5840 -defaultsOSRD
preplace inst absorption22 -pg 1 -lvl 8 -y 6250 -defaultsOSRD
preplace inst material_idx7 -pg 1 -lvl 8 -y 3840 -defaultsOSRD
preplace inst rst_clk_wiz_1_100M -pg 1 -lvl 2 -y 3610 -defaultsOSRD
preplace inst absorption_10 -pg 1 -lvl 8 -y 1210 -defaultsOSRD
preplace inst mc_light_prop_4 -pg 1 -lvl 5 -y 4450 -defaultsOSRD
preplace inst material_idx_10 -pg 1 -lvl 9 -y 6490 -defaultsOSRD
preplace inst material_idx8 -pg 1 -lvl 8 -y 5720 -defaultsOSRD
preplace inst absorption23 -pg 1 -lvl 8 -y 6370 -defaultsOSRD
preplace inst absorption_11 -pg 1 -lvl 8 -y 1310 -defaultsOSRD
preplace inst mc_light_prop_5 -pg 1 -lvl 5 -y 6180 -defaultsOSRD
preplace inst absorption24 -pg 1 -lvl 7 -y 4950 -defaultsOSRD
preplace inst material_idx_11 -pg 1 -lvl 9 -y 6610 -defaultsOSRD
preplace inst material_idx9 -pg 1 -lvl 8 -y 5840 -defaultsOSRD
preplace inst absorption_12 -pg 1 -lvl 9 -y 3310 -defaultsOSRD
preplace inst mc_light_prop_6 -pg 1 -lvl 5 -y 5370 -defaultsOSRD
preplace inst material_idx_12 -pg 1 -lvl 9 -y 7230 -defaultsOSRD
preplace inst axi_interconnect_10 -pg 1 -lvl 6 -y 5610 -defaultsOSRD
preplace inst absorption25 -pg 1 -lvl 7 -y 5070 -defaultsOSRD
preplace inst absorption_13 -pg 1 -lvl 9 -y 2990 -defaultsOSRD
preplace inst mc_light_prop_7 -pg 1 -lvl 5 -y 7720 -defaultsOSRD
preplace inst material_idx_13 -pg 1 -lvl 9 -y 7350 -defaultsOSRD
preplace inst axi_interconnect_11 -pg 1 -lvl 7 -y 8190 -defaultsOSRD
preplace inst absorption26 -pg 1 -lvl 7 -y 5240 -defaultsOSRD
preplace inst absorption_14 -pg 1 -lvl 9 -y 3110 -defaultsOSRD
preplace inst material_idx_14 -pg 1 -lvl 9 -y 8020 -defaultsOSRD
preplace inst absorption27 -pg 1 -lvl 7 -y 5670 -defaultsOSRD
preplace inst absorption30 -pg 1 -lvl 8 -y 7610 -defaultsOSRD
preplace inst absorption_15 -pg 1 -lvl 9 -y 3410 -defaultsOSRD
preplace inst material_idx_15 -pg 1 -lvl 9 -y 8140 -defaultsOSRD
preplace inst absorption31 -pg 1 -lvl 8 -y 7470 -defaultsOSRD
preplace inst absorption28 -pg 1 -lvl 8 -y 7900 -defaultsOSRD
preplace inst material_idx10 -pg 1 -lvl 8 -y 6490 -defaultsOSRD
preplace inst absorption_16 -pg 1 -lvl 8 -y 4430 -defaultsOSRD
preplace inst absorption29 -pg 1 -lvl 8 -y 7750 -defaultsOSRD
preplace inst material_idx11 -pg 1 -lvl 8 -y 6610 -defaultsOSRD
preplace inst absorption_17 -pg 1 -lvl 8 -y 4700 -defaultsOSRD
preplace inst material_idx12 -pg 1 -lvl 8 -y 7230 -defaultsOSRD
preplace inst absorption_18 -pg 1 -lvl 8 -y 4530 -defaultsOSRD
preplace inst mdm_1 -pg 1 -lvl 2 -y 3450 -defaultsOSRD
preplace inst material_idx13 -pg 1 -lvl 8 -y 7350 -defaultsOSRD
preplace inst absorption_19 -pg 1 -lvl 8 -y 4870 -defaultsOSRD
preplace inst material_idx14 -pg 1 -lvl 8 -y 8020 -defaultsOSRD
preplace inst material_idx15 -pg 1 -lvl 8 -y 8140 -defaultsOSRD
preplace inst absorption10 -pg 1 -lvl 7 -y 1450 -defaultsOSRD
preplace inst absorption_30 -pg 1 -lvl 9 -y 7670 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 4 -y 3880 -defaultsOSRD
preplace inst absorption0 -pg 1 -lvl 7 -y 280 -defaultsOSRD
preplace netloc axi_interconnect_0_M07_AXI 1 4 1 1370
preplace netloc axi_interconnect_1_M00_AXI2 1 6 1 2450
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc axi_interconnect_1_M00_AXI3 1 6 1 2410
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc absorption11_BRAM_PORTA 1 7 1 2830
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc axi_interconnect_1_M02_AXI 1 6 1 2340
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc absorption10_BRAM_PORTA 1 7 1 2820
preplace netloc rst_clk_wiz_1_100M_mb_reset 1 2 1 550
preplace netloc axi_interconnect_7_M02_AXI 1 6 1 2410
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc microblaze_0_dlmb_1 1 3 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc mc_light_prop_0_absorption_bram_0_PORTA 1 5 3 N 210 NJ 210 NJ
preplace netloc S04_AXI_1 1 5 1 1990
preplace netloc axi_interconnect_7_M03_AXI 1 6 1 2400
preplace netloc S04_AXI_2 1 5 2 NJ 2120 N
preplace netloc S04_AXI_3 1 5 1 1960
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc S04_AXI_4 1 5 2 NJ 3310 N
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc S04_AXI_5 1 5 1 N
preplace netloc S07_AXI_1 1 5 1 1840
preplace netloc mdm_1_debug_sys_rst 1 1 2 190 3510 530
preplace netloc S07_AXI_2 1 5 1 1890
preplace netloc S04_AXI_6 1 5 2 NJ 6120 N
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc S08_AXI_1 1 5 1 1920
preplace netloc S07_AXI_3 1 5 1 N
preplace netloc S04_AXI_7 1 5 1 N
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc S08_AXI_2 1 5 2 NJ 2200 N
preplace netloc S07_AXI_4 1 5 1 N
preplace netloc materials_array_1_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc S04_AXI_8 1 5 2 NJ 7660 2350
preplace netloc S08_AXI_3 1 5 1 1880
preplace netloc mc_light_prop_0_materials_array_1_PORTA 1 8 1 N
preplace netloc materials_array_1_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc materials_array_1_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc S08_AXI_4 1 5 2 NJ 3390 N
preplace netloc mc_light_prop_0_absorption_bram_2_PORTA1 1 5 3 1940J 1110 NJ 1110 2830
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc S08_AXI_5 1 5 1 N
preplace netloc mc_light_prop_0_absorption_bram_2_PORTA2 1 5 3 1880J 6050 2490J 5470 3130
preplace netloc axi_interconnect_4_M02_AXI 1 6 1 2340
preplace netloc mc_light_prop_0_absorption_bram_2_PORTA3 1 5 3 1930 5170 NJ 5170 2830J
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc S08_AXI_6 1 5 2 NJ 6200 N
preplace netloc S08_AXI_7 1 5 1 N
preplace netloc S08_AXI_8 1 5 2 NJ 7740 2310
preplace netloc mc_light_prop_1_absorption_bram_1_PORTA 1 5 4 NJ 2240 2330J 3150 2940J 2260 3430
preplace netloc axi_interconnect_2_M04_AXI 1 7 1 2840
preplace netloc axi_interconnect_2_M01_AXI2 1 7 1 3150
preplace netloc axi_interconnect_2_M01_AXI3 1 7 1 3130
preplace netloc microblaze_0_ilmb_1 1 3 1 N
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc axi_interconnect_0_M02_AXI 1 4 1 1340
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc axi_interconnect_2_M02_AXI2 1 7 1 2810
preplace netloc absorption_3_axi_ctrl_BRAM_PORTA 1 7 1 N
preplace netloc axi_interconnect_2_M02_AXI3 1 7 1 3120
preplace netloc absorption_0_axi_ctrl_1_BRAM_PORTA 1 8 1 3430
preplace netloc axi_interconnect_2_M07_AXI 1 7 1 2900
preplace netloc axi_interconnect_2_M10_AXI 1 7 1 3150
preplace netloc mc_light_prop_1_m_axi_material_index_bram_2 1 5 2 NJ 2180 N
preplace netloc axi_interconnect_0_M11_AXI 1 4 1 1320
preplace netloc axi_interconnect_0_M09_AXI 1 4 2 NJ 3950 1920
preplace netloc mc_light_prop_1_m_axi_material_index_bram_3 1 5 2 NJ 3370 N
preplace netloc mc_light_prop_1_absorption_bram_3_PORTA 1 5 4 N 2280 2340J 1980 3150J 2110 NJ
preplace netloc mc_light_prop_1_m_axi_material_index_bram_4 1 5 2 NJ 6180 N
preplace netloc mc_light_prop_1_m_axi_material_index_bram_5 1 5 2 NJ 7720 2320
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc S05_AXI_1 1 5 1 1980
preplace netloc axi_interconnect_2_M08_AXI1 1 7 1 3070
preplace netloc mc_light_prop_1_absorption_bram_0_PORTA1 1 5 4 NJ 3410 2390J 4330 3020J 3280 3460
preplace netloc axi_interconnect_2_M08_AXI2 1 7 1 3030
preplace netloc mc_light_prop_1_absorption_bram_0_PORTA2 1 5 4 N 6220 2330J 5910 NJ 5910 3440J
preplace netloc S05_AXI_2 1 5 2 NJ 2140 N
preplace netloc mc_light_prop_1_absorption_bram_0_PORTA3 1 5 4 NJ 7760 2480J 7140 3170J 6920 3450
preplace netloc axi_interconnect_2_M08_AXI3 1 7 1 N
preplace netloc axi_interconnect_1_M00_AXI 1 6 1 2460
preplace netloc absorption_0_axi_ctrl_BRAM_PORTA3 1 7 1 2810
preplace netloc S05_AXI_3 1 5 1 1920
preplace netloc S05_AXI_4 1 5 2 NJ 3330 N
preplace netloc axi_interconnect_5_M02_AXI 1 7 1 2980
preplace netloc S05_AXI_5 1 5 1 N
preplace netloc rst_clk_wiz_1_100M_peripheral_aresetn 1 2 6 NJ 3650 1010 7490 1360 7490 2020 7490 2430 7490 3090
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc axi_interconnect_2_M02_AXI 1 7 1 2860
preplace netloc S05_AXI_6 1 5 2 NJ 6140 N
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc S05_AXI_7 1 5 1 N
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc S05_AXI_8 1 5 2 NJ 7680 2340
preplace netloc axi_interconnect_2_M08_AXI 1 7 1 2930
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc absorption_1_axi_ctrl_BRAM_PORTA3 1 7 1 N
preplace netloc absorption9_BRAM_PORTA 1 7 1 2810
preplace netloc axi_interconnect_0_M10_AXI 1 4 1 1330
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc S06_AXI_1 1 5 1 1850
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc material_idx_1_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc S06_AXI_2 1 5 2 NJ 2160 N
preplace netloc axi_interconnect_2_M06_AXI1 1 7 1 3070
preplace netloc S06_AXI_3 1 5 1 1900
preplace netloc axi_interconnect_2_M06_AXI2 1 7 1 3170
preplace netloc axi_interconnect_2_M06_AXI3 1 7 1 3160
preplace netloc S06_AXI_4 1 5 2 NJ 3350 N
preplace netloc S06_AXI_5 1 5 1 N
preplace netloc S06_AXI_6 1 5 2 NJ 6160 N
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc S06_AXI_7 1 5 1 N
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc S06_AXI_8 1 5 2 NJ 7700 2330
preplace netloc reset_rtl_0_1 1 0 2 20 3590 NJ
preplace netloc microblaze_0_M_AXI_DP 1 3 1 1010
preplace netloc axi_interconnect_2_M07_AXI1 1 7 1 3150
preplace netloc axi_interconnect_2_M07_AXI2 1 7 1 N
preplace netloc axi_interconnect_1_M04_AXI3 1 6 1 N
preplace netloc axi_interconnect_2_M07_AXI3 1 7 1 3170
preplace netloc axi_interconnect_1_M01_AXI3 1 6 1 2440
preplace netloc axi_interconnect_2_M11_AXI1 1 7 1 3040
preplace netloc axi_interconnect_2_M03_AXI 1 7 1 2890
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc axi_interconnect_2_M06_AXI 1 7 1 2880
preplace netloc axi_interconnect_2_M11_AXI2 1 7 1 2810
preplace netloc axi_interconnect_1_M01_AXI 1 6 1 2320
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc axi_interconnect_0_M08_AXI 1 4 1 1340
preplace netloc axi_interconnect_0_M05_AXI 1 4 1 1370
preplace netloc material_idx_2_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc axi_interconnect_2_M11_AXI3 1 7 1 2810
preplace netloc absorption14_BRAM_PORTA 1 8 1 3460
preplace netloc absorption_1_axi_ctrl_BRAM_PORTA 1 7 1 N
preplace netloc absorption_3_axi_ctrl_1_BRAM_PORTA 1 8 1 3430
preplace netloc mc_light_prop_1_absorption_bram_1_PORTA1 1 5 4 N 3430 2340J 3170 2970J 3140 3450J
preplace netloc mc_light_prop_1_absorption_bram_1_PORTA2 1 5 4 NJ 6240 2350J 5980 2810J 6170 3460
preplace netloc mc_light_prop_1_absorption_bram_1_PORTA3 1 5 4 NJ 7780 2500J 7590 2910J 7820 N
preplace netloc mc_light_prop_1_absorption_bram_0_PORTA 1 5 4 NJ 2220 2390J 3140 2920J 2250 N
preplace netloc mc_light_prop_1_m_axi_materials_array_0 1 5 2 NJ 2060 N
preplace netloc mc_light_prop_1_m_axi_materials_array_1 1 5 2 NJ 2080 N
preplace netloc mc_light_prop_1_m_axi_materials_array_2 1 5 2 NJ 3250 N
preplace netloc axi_interconnect_0_M01_AXI 1 4 1 1320
preplace netloc mc_light_prop_1_m_axi_materials_array_3 1 5 2 NJ 3270 N
preplace netloc axi_interconnect_2_M09_AXI1 1 7 1 3060
preplace netloc absorption_2_axi_ctrl_1_BRAM_PORTA 1 8 1 3430
preplace netloc mc_light_prop_1_m_axi_materials_array_4 1 5 2 1840J 6070 2510
preplace netloc axi_interconnect_2_M09_AXI2 1 7 1 2960
preplace netloc axi_interconnect_5_M00_AXI 1 7 1 2990
preplace netloc axi_interconnect_2_M09_AXI3 1 7 1 2980
preplace netloc mc_light_prop_1_m_axi_materials_array_5 1 5 2 NJ 6080 N
preplace netloc mc_light_prop_1_m_axi_materials_array_6 1 5 2 NJ 7600 2390
preplace netloc S00_AXI_1 1 4 2 N 3770 1910J
preplace netloc axi_interconnect_2_M10_AXI1 1 7 1 3050
preplace netloc mc_light_prop_1_m_axi_materials_array_7 1 5 2 NJ 7620 2370
preplace netloc axi_interconnect_2_M10_AXI2 1 7 1 2870
preplace netloc axi_interconnect_2_M10_AXI3 1 7 1 2880
preplace netloc absorption_1_axi_ctrl_1_BRAM_PORTA 1 8 1 N
preplace netloc absorption18_BRAM_PORTA 1 7 1 2810
preplace netloc axi_interconnect_4_M04_AXI 1 6 1 N
preplace netloc absorption13_BRAM_PORTA 1 8 1 3430
preplace netloc absorption12_BRAM_PORTA 1 8 1 3430
preplace netloc absorption_0_axi_ctrl_BRAM_PORTA 1 7 1 2800
preplace netloc rst_clk_wiz_1_100M_bus_struct_reset 1 2 2 NJ 3590 1030
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc mc_light_prop_0_absorption_bram_3_PORTA 1 5 3 1970J 190 NJ 190 2790
preplace netloc absorption19_BRAM_PORTA 1 7 1 2810
preplace netloc materials_array_3_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc axi_interconnect_1_M03_AXI 1 6 1 2390
preplace netloc axi_interconnect_1_M03_AXI3 1 6 1 2470
preplace netloc mc_light_prop_0_m_axi_materials_array_1 1 5 1 2020
preplace netloc microblaze_0_Clk 1 1 7 180 7470 540 7470 1020 7470 1350 7470 1990 7470 2420 7470 3080
preplace netloc mc_light_prop_0_m_axi_materials_array_2 1 5 1 2010
preplace netloc mc_light_prop_0_absorption_bram_3_PORTA1 1 5 3 1930J 1100 NJ 1100 2800
preplace netloc axi_interconnect_2_M03_AXI2 1 7 1 2890
preplace netloc axi_interconnect_2_M03_AXI3 1 7 1 2890
preplace netloc mc_light_prop_0_m_axi_materials_array_3 1 5 1 N
preplace netloc mc_light_prop_0_absorption_bram_3_PORTA2 1 5 3 1890 5140 NJ 5140 3100J
preplace netloc absorption_2_axi_ctrl_1_BRAM_PORTA2 1 8 1 N
preplace netloc S01_AXI_1 1 5 1 2030
preplace netloc axi_interconnect_5_M01_AXI 1 7 1 2960
preplace netloc mc_light_prop_0_m_axi_materials_array_4 1 5 1 N
preplace netloc mc_light_prop_0_absorption_bram_3_PORTA3 1 5 3 1870 6060 2480J 5310 3160J
preplace netloc absorption_2_axi_ctrl_1_BRAM_PORTA3 1 8 1 3430
preplace netloc S01_AXI_2 1 5 1 2030
preplace netloc axi_interconnect_0_M04_AXI 1 4 1 1330
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTB1 1 8 1 N
preplace netloc S01_AXI_3 1 5 1 N
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTB2 1 8 1 N
preplace netloc S01_AXI_4 1 5 1 N
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTB3 1 8 1 N
preplace netloc axi_interconnect_2_M01_AXI 1 7 1 2910
preplace netloc axi_interconnect_0_M03_AXI 1 4 2 N 3830 2000J
preplace netloc absorption8_BRAM_PORTA 1 7 1 2790
preplace netloc S03_AXI_1 1 5 1 2010
preplace netloc S03_AXI_2 1 5 2 NJ 2100 N
preplace netloc axi_interconnect_2_M09_AXI 1 7 1 2950
preplace netloc axi_interconnect_1_M04_AXI 1 6 1 N
preplace netloc S03_AXI_3 1 5 1 1970
preplace netloc axi_interconnect_4_M01_AXI 1 6 1 2320
preplace netloc clk_wiz_1_locked 1 1 1 190
preplace netloc S03_AXI_4 1 5 2 NJ 3290 N
preplace netloc S03_AXI_5 1 5 1 N
preplace netloc axi_interconnect_7_M04_AXI 1 6 1 2440
preplace netloc absorption_3_axi_ctrl_1_BRAM_PORTA2 1 8 1 N
preplace netloc S03_AXI_6 1 5 2 NJ 6100 N
preplace netloc axi_interconnect_2_M05_AXI1 1 7 1 3060
preplace netloc absorption_3_axi_ctrl_1_BRAM_PORTA3 1 8 1 3460
preplace netloc S03_AXI_7 1 5 1 N
preplace netloc axi_interconnect_2_M05_AXI2 1 7 1 3160
preplace netloc axi_interconnect_2_M05_AXI3 1 7 1 3150
preplace netloc S03_AXI_8 1 5 2 NJ 7640 2360
preplace netloc materials_array_1_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc microblaze_0_debug 1 2 1 N
preplace netloc axi_interconnect_1_M02_AXI3 1 6 1 2460
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc absorption_1_axi_ctrl_1_BRAM_PORTA2 1 8 1 N
preplace netloc mc_light_prop_0_absorption_bram_1_PORTA 1 5 3 1860J 170 NJ 170 2830
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc absorption16_BRAM_PORTA 1 7 1 N
preplace netloc material_idx_3_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc absorption_1_axi_ctrl_1_BRAM_PORTA3 1 8 1 3430
preplace netloc mc_light_prop_0_absorption_bram_0_PORTA1 1 5 3 1870 150 NJ 150 2820J
preplace netloc mc_light_prop_0_absorption_bram_0_PORTA2 1 5 3 1950 5130 2390J 4490 2810J
preplace netloc absorption17_BRAM_PORTA 1 7 1 N
preplace netloc mc_light_prop_0_absorption_bram_0_PORTA3 1 5 3 1870 5150 NJ 5150 3120J
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTA 1 8 1 N
preplace netloc axi_interconnect_4_M03_AXI 1 6 1 2390
preplace netloc materials_array_2_axi_ctrl_BRAM_PORTB 1 8 1 N
preplace netloc absorption_2_axi_ctrl_BRAM_PORTA 1 7 1 N
preplace netloc mc_light_prop_1_absorption_bram_3_PORTA1 1 5 4 NJ 3470 2330J 4340 3030J 3290 3450
preplace netloc mc_light_prop_1_absorption_bram_3_PORTA2 1 5 4 NJ 6280 2340J 5580 NJ 5580 3430
preplace netloc mc_light_prop_1_absorption_bram_3_PORTA3 1 5 4 1940 7540 NJ 7540 NJ 7540 NJ
preplace netloc mc_light_prop_0_absorption_bram_2_PORTA 1 5 3 1910J 180 NJ 180 2810
preplace netloc clock_rtl_1 1 0 1 NJ
preplace netloc absorption15_BRAM_PORTA 1 8 1 3460
preplace netloc absorption_3_axi_ctrl_BRAM_PORTA3 1 7 1 3170
preplace netloc mc_light_prop_0_absorption_bram_1_PORTA1 1 5 3 1950 1120 NJ 1120 NJ
preplace netloc axi_interconnect_2_M04_AXI1 1 7 1 3000
preplace netloc mc_light_prop_0_absorption_bram_1_PORTA2 1 5 3 1900J 5160 NJ 5160 3110
preplace netloc axi_interconnect_2_M04_AXI2 1 7 1 3140
preplace netloc axi_interconnect_2_M00_AXI 1 7 1 2870
preplace netloc mc_light_prop_0_materials_array_1_PORTA1 1 8 1 N
preplace netloc axi_interconnect_0_M06_AXI 1 4 2 NJ 3890 1950
preplace netloc mc_light_prop_0_absorption_bram_1_PORTA3 1 5 3 1860 6090 2500J 5430 3150J
preplace netloc axi_interconnect_2_M04_AXI3 1 7 1 2810
preplace netloc axi_interconnect_2_M11_AXI 1 7 1 3130
preplace netloc mc_light_prop_0_materials_array_1_PORTA2 1 8 1 N
preplace netloc axi_interconnect_5_M03_AXI 1 7 1 3010
preplace netloc mc_light_prop_0_materials_array_1_PORTA3 1 8 1 N
preplace netloc axi_interconnect_2_M05_AXI 1 7 1 2850
preplace netloc mc_light_prop_1_absorption_bram_2_PORTA1 1 5 4 N 3450 2320J 3160 2950J 3000 3430J
preplace netloc axi_interconnect_2_M00_AXI2 1 7 1 3130
preplace netloc mc_light_prop_1_absorption_bram_2_PORTA2 1 5 4 NJ 6260 2320J 5560 NJ 5560 3450
preplace netloc axi_interconnect_2_M00_AXI3 1 7 1 3140
preplace netloc mc_light_prop_1_absorption_bram_2_PORTA3 1 5 4 N 7800 2510J 7610 2820J 7680 NJ
preplace netloc ARESETN_1 1 2 5 NJ 3630 1040 480 NJ 480 1980 2230 2380
preplace netloc mc_light_prop_1_absorption_bram_2_PORTA 1 5 4 N 2260 2320J 1970 NJ 1970 NJ
preplace netloc absorption_2_axi_ctrl_BRAM_PORTA3 1 7 1 3140
preplace netloc absorption_0_axi_ctrl_1_BRAM_PORTA2 1 8 1 3460
preplace netloc axi_interconnect_7_M01_AXI 1 6 1 2330
preplace netloc absorption_0_axi_ctrl_1_BRAM_PORTA3 1 8 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTA1 1 8 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTA2 1 8 1 N
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTA3 1 8 1 N
preplace netloc axi_interconnect_1_M00_AXI1 1 6 1 2450
levelinfo -pg 1 0 100 360 780 1180 1620 2170 2650 3300 3570 3680 -top 0 -bot 8760
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


