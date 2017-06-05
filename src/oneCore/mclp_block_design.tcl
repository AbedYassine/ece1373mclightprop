
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

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

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

  # Create instance: absorption_0_axi_ctrl, and set properties
  set absorption_0_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_0_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_0_axi_ctrl

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

  # Create instance: absorption_1_axi_ctrl, and set properties
  set absorption_1_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_1_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_1_axi_ctrl

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

  # Create instance: absorption_2_axi_ctrl, and set properties
  set absorption_2_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_2_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_2_axi_ctrl

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

  # Create instance: absorption_3_axi_ctrl, and set properties
  set absorption_3_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_3_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_3_axi_ctrl

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

  # Create instance: absorption_4_axi_ctrl, and set properties
  set absorption_4_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_4_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_4_axi_ctrl

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

  # Create instance: absorption_5_axi_ctrl, and set properties
  set absorption_5_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_5_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_5_axi_ctrl

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

  # Create instance: absorption_6_axi_ctrl, and set properties
  set absorption_6_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_6_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_6_axi_ctrl

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

  # Create instance: absorption_7_axi_ctrl, and set properties
  set absorption_7_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 absorption_7_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $absorption_7_axi_ctrl

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.NUM_MI {22} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_1 ]
  set_property -dict [ list \
CONFIG.AUTO_PRIMITIVE {MMCM} \
CONFIG.CLKIN1_JITTER_PS {50.0} \
CONFIG.CLKIN2_JITTER_PS {100.0} \
CONFIG.CLKOUT1_DRIVES {Buffer} \
CONFIG.CLKOUT1_JITTER {148.500} \
CONFIG.CLKOUT1_PHASE_ERROR {158.296} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {167} \
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
CONFIG.MMCM_CLKFBOUT_MULT_F {20.875} \
CONFIG.MMCM_CLKIN1_PERIOD {5.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.250} \
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

  # Create instance: material_idx_0_axi_ctrl, and set properties
  set material_idx_0_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_0_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_0_axi_ctrl

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

  # Create instance: material_idx_1_axi_ctrl, and set properties
  set material_idx_1_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_1_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_1_axi_ctrl

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

  # Create instance: material_idx_2_axi_ctrl, and set properties
  set material_idx_2_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_2_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_2_axi_ctrl

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

  # Create instance: material_idx_3_axi_ctrl, and set properties
  set material_idx_3_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_3_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_3_axi_ctrl

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

  # Create instance: material_idx_4_axi_ctrl, and set properties
  set material_idx_4_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_4_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_4_axi_ctrl

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

  # Create instance: material_idx_5_axi_ctrl, and set properties
  set material_idx_5_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_5_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_5_axi_ctrl

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

  # Create instance: material_idx_6_axi_ctrl, and set properties
  set material_idx_6_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_6_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_6_axi_ctrl

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

  # Create instance: material_idx_7_axi_ctrl, and set properties
  set material_idx_7_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 material_idx_7_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $material_idx_7_axi_ctrl

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

  # Create instance: materials_array_0_axi_ctrl, and set properties
  set materials_array_0_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array_0_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $materials_array_0_axi_ctrl

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

  # Create instance: materials_array_1_axi_ctrl, and set properties
  set materials_array_1_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array_1_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $materials_array_1_axi_ctrl

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

  # Create instance: materials_array_2_axi_ctrl, and set properties
  set materials_array_2_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array_2_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $materials_array_2_axi_ctrl

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

  # Create instance: materials_array_3_axi_ctrl, and set properties
  set materials_array_3_axi_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 materials_array_3_axi_ctrl ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $materials_array_3_axi_ctrl

  # Create instance: mc_light_prop_0, and set properties
  set mc_light_prop_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:mc_light_prop:1.0 mc_light_prop_0 ]

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
  connect_bd_intf_net -intf_net absorption_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_0/BRAM_PORTA] [get_bd_intf_pins absorption_0_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_1_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_1/BRAM_PORTA] [get_bd_intf_pins absorption_1_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_2_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_2/BRAM_PORTA] [get_bd_intf_pins absorption_2_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_3_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_3/BRAM_PORTA] [get_bd_intf_pins absorption_3_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_4_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_4/BRAM_PORTA] [get_bd_intf_pins absorption_4_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_5_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_5/BRAM_PORTA] [get_bd_intf_pins absorption_5_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_6_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_6/BRAM_PORTA] [get_bd_intf_pins absorption_6_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net absorption_7_axi_ctrl_BRAM_PORTA [get_bd_intf_pins absorption_7/BRAM_PORTA] [get_bd_intf_pins absorption_7_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_13_BRAM_PORTA [get_bd_intf_pins material_idx_7/BRAM_PORTB] [get_bd_intf_pins material_idx_7_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_14_BRAM_PORTA [get_bd_intf_pins material_idx_6/BRAM_PORTB] [get_bd_intf_pins material_idx_6_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_16_BRAM_PORTA [get_bd_intf_pins materials_array_2/BRAM_PORTB] [get_bd_intf_pins materials_array_2_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_17_BRAM_PORTA [get_bd_intf_pins materials_array_3/BRAM_PORTB] [get_bd_intf_pins materials_array_3_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_2_BRAM_PORTA [get_bd_intf_pins material_idx_5/BRAM_PORTB] [get_bd_intf_pins material_idx_5_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_3_BRAM_PORTA [get_bd_intf_pins material_idx_4/BRAM_PORTB] [get_bd_intf_pins material_idx_4_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_5_BRAM_PORTA [get_bd_intf_pins material_idx_3/BRAM_PORTB] [get_bd_intf_pins material_idx_3_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_6_BRAM_PORTA [get_bd_intf_pins material_idx_2/BRAM_PORTB] [get_bd_intf_pins material_idx_2_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_7_BRAM_PORTA [get_bd_intf_pins material_idx_1/BRAM_PORTB] [get_bd_intf_pins material_idx_1_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins mc_light_prop_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins materials_array_0_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins materials_array_1_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins materials_array_2_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins materials_array_3_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins absorption_0_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins absorption_1_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins absorption_2_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins absorption_3_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins absorption_4_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins absorption_5_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins absorption_6_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M12_AXI [get_bd_intf_pins absorption_7_axi_ctrl/S_AXI] [get_bd_intf_pins axi_interconnect_0/M12_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins axi_interconnect_0/M13_AXI] [get_bd_intf_pins material_idx_0_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins axi_interconnect_0/M14_AXI] [get_bd_intf_pins material_idx_1_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins axi_interconnect_0/M15_AXI] [get_bd_intf_pins material_idx_2_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M16_AXI [get_bd_intf_pins axi_interconnect_0/M16_AXI] [get_bd_intf_pins material_idx_3_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M17_AXI [get_bd_intf_pins axi_interconnect_0/M17_AXI] [get_bd_intf_pins material_idx_4_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M18_AXI [get_bd_intf_pins axi_interconnect_0/M18_AXI] [get_bd_intf_pins material_idx_5_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M19_AXI [get_bd_intf_pins axi_interconnect_0/M19_AXI] [get_bd_intf_pins material_idx_6_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M20_AXI [get_bd_intf_pins axi_interconnect_0/M20_AXI] [get_bd_intf_pins material_idx_7_axi_ctrl/S_AXI]
  connect_bd_intf_net -intf_net material_idx_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins material_idx_0/BRAM_PORTB] [get_bd_intf_pins material_idx_0_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_0_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array_0/BRAM_PORTB] [get_bd_intf_pins materials_array_0_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net materials_array_1_axi_ctrl_BRAM_PORTA [get_bd_intf_pins materials_array_1/BRAM_PORTA] [get_bd_intf_pins materials_array_1_axi_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_0_PORTA [get_bd_intf_pins absorption_0/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_1_PORTA [get_bd_intf_pins absorption_1/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_2_PORTA [get_bd_intf_pins absorption_2/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_3_PORTA [get_bd_intf_pins absorption_3/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_4_PORTA [get_bd_intf_pins absorption_4/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_4_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_5_PORTA [get_bd_intf_pins absorption_5/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_5_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_6_PORTA [get_bd_intf_pins absorption_6/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_6_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_absorption_bram_7_PORTA [get_bd_intf_pins absorption_7/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/absorption_bram_7_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_0_PORTA [get_bd_intf_pins material_idx_0/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_1_PORTA [get_bd_intf_pins material_idx_1/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_2_PORTA [get_bd_intf_pins material_idx_2/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_3_PORTA [get_bd_intf_pins material_idx_3/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_3_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_4_PORTA [get_bd_intf_pins material_idx_4/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_4_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_5_PORTA [get_bd_intf_pins material_idx_5/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_5_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_6_PORTA [get_bd_intf_pins material_idx_6/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_6_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_material_index_bram_7_PORTA [get_bd_intf_pins material_idx_7/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/material_index_bram_7_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_0_PORTA [get_bd_intf_pins materials_array_0/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/materials_array_0_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_1_PORTA [get_bd_intf_pins materials_array_1/BRAM_PORTB] [get_bd_intf_pins mc_light_prop_0/materials_array_1_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_2_PORTA [get_bd_intf_pins materials_array_2/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/materials_array_2_PORTA]
  connect_bd_intf_net -intf_net mc_light_prop_0_materials_array_3_PORTA [get_bd_intf_pins materials_array_3/BRAM_PORTA] [get_bd_intf_pins mc_light_prop_0/materials_array_3_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
  connect_bd_net -net clock_rtl_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins absorption_0_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_1_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_2_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_3_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_4_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_5_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_6_axi_ctrl/s_axi_aclk] [get_bd_pins absorption_7_axi_ctrl/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins axi_interconnect_0/M13_ACLK] [get_bd_pins axi_interconnect_0/M14_ACLK] [get_bd_pins axi_interconnect_0/M15_ACLK] [get_bd_pins axi_interconnect_0/M16_ACLK] [get_bd_pins axi_interconnect_0/M17_ACLK] [get_bd_pins axi_interconnect_0/M18_ACLK] [get_bd_pins axi_interconnect_0/M19_ACLK] [get_bd_pins axi_interconnect_0/M20_ACLK] [get_bd_pins axi_interconnect_0/M21_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins material_idx_0_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_1_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_2_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_3_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_4_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_5_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_6_axi_ctrl/s_axi_aclk] [get_bd_pins material_idx_7_axi_ctrl/s_axi_aclk] [get_bd_pins materials_array_0_axi_ctrl/s_axi_aclk] [get_bd_pins materials_array_1_axi_ctrl/s_axi_aclk] [get_bd_pins materials_array_2_axi_ctrl/s_axi_aclk] [get_bd_pins materials_array_3_axi_ctrl/s_axi_aclk] [get_bd_pins mc_light_prop_0/ap_clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl] [get_bd_pins clk_wiz_1/resetn] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins absorption_0_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_1_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_2_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_3_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_4_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_5_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_6_axi_ctrl/s_axi_aresetn] [get_bd_pins absorption_7_axi_ctrl/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins axi_interconnect_0/M13_ARESETN] [get_bd_pins axi_interconnect_0/M14_ARESETN] [get_bd_pins axi_interconnect_0/M15_ARESETN] [get_bd_pins axi_interconnect_0/M16_ARESETN] [get_bd_pins axi_interconnect_0/M17_ARESETN] [get_bd_pins axi_interconnect_0/M18_ARESETN] [get_bd_pins axi_interconnect_0/M19_ARESETN] [get_bd_pins axi_interconnect_0/M20_ARESETN] [get_bd_pins axi_interconnect_0/M21_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins material_idx_0_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_1_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_2_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_3_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_4_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_5_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_6_axi_ctrl/s_axi_aresetn] [get_bd_pins material_idx_7_axi_ctrl/s_axi_aresetn] [get_bd_pins materials_array_0_axi_ctrl/s_axi_aresetn] [get_bd_pins materials_array_1_axi_ctrl/s_axi_aresetn] [get_bd_pins materials_array_2_axi_ctrl/s_axi_aresetn] [get_bd_pins materials_array_3_axi_ctrl/s_axi_aresetn] [get_bd_pins mc_light_prop_0/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x00002000 -offset 0x20000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_0_axi_ctrl/S_AXI/Mem0] SEG_absorption_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x22000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_1_axi_ctrl/S_AXI/Mem0] SEG_absorption_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x24000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_2_axi_ctrl/S_AXI/Mem0] SEG_absorption_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x26000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_3_axi_ctrl/S_AXI/Mem0] SEG_absorption_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x28000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_4_axi_ctrl/S_AXI/Mem0] SEG_absorption_4_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2A000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_5_axi_ctrl/S_AXI/Mem0] SEG_absorption_5_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2C000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_6_axi_ctrl/S_AXI/Mem0] SEG_absorption_6_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x2E000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs absorption_7_axi_ctrl/S_AXI/Mem0] SEG_absorption_7_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00002000 -offset 0x30000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_0_axi_ctrl/S_AXI/Mem0] SEG_material_idx_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x32000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_1_axi_ctrl/S_AXI/Mem0] SEG_material_idx_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x34000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_2_axi_ctrl/S_AXI/Mem0] SEG_material_idx_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x36000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_3_axi_ctrl/S_AXI/Mem0] SEG_material_idx_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x38000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_4_axi_ctrl/S_AXI/Mem0] SEG_material_idx_4_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3A000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_5_axi_ctrl/S_AXI/Mem0] SEG_material_idx_5_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3C000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_6_axi_ctrl/S_AXI/Mem0] SEG_material_idx_6_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x3E000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs material_idx_7_axi_ctrl/S_AXI/Mem0] SEG_material_idx_7_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x50000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array_0_axi_ctrl/S_AXI/Mem0] SEG_materials_array_0_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x52000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array_1_axi_ctrl/S_AXI/Mem0] SEG_materials_array_1_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x54000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array_2_axi_ctrl/S_AXI/Mem0] SEG_materials_array_2_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x56000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs materials_array_3_axi_ctrl/S_AXI/Mem0] SEG_materials_array_3_axi_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mc_light_prop_0/s_axi_AXILiteS/Reg] SEG_mc_light_prop_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port reset_rtl -pg 1 -y 730 -defaultsOSRD
preplace port sys_clock -pg 1 -y 800 -defaultsOSRD
preplace inst mc_light_prop_0 -pg 1 -lvl 4 -y 1210 -defaultsOSRD
preplace inst absorption_7 -pg 1 -lvl 5 -y 920 -defaultsOSRD
preplace inst material_idx_2_axi_ctrl -pg 1 -lvl 4 -y 1750 -defaultsOSRD
preplace inst material_idx_0_axi_ctrl -pg 1 -lvl 4 -y 1510 -defaultsOSRD
preplace inst materials_array_2_axi_ctrl -pg 1 -lvl 4 -y 2590 -defaultsOSRD
preplace inst material_idx_4_axi_ctrl -pg 1 -lvl 4 -y 1990 -defaultsOSRD
preplace inst material_idx_0 -pg 1 -lvl 5 -y 1260 -defaultsOSRD
preplace inst material_idx_1 -pg 1 -lvl 5 -y 1360 -defaultsOSRD
preplace inst materials_array_0 -pg 1 -lvl 5 -y 1960 -defaultsOSRD
preplace inst material_idx_2 -pg 1 -lvl 5 -y 1460 -defaultsOSRD
preplace inst material_idx_1_axi_ctrl -pg 1 -lvl 4 -y 1630 -defaultsOSRD
preplace inst absorption_0 -pg 1 -lvl 5 -y 80 -defaultsOSRD
preplace inst mdm_1 -pg 1 -lvl 1 -y 930 -defaultsOSRD
preplace inst materials_array_1 -pg 1 -lvl 5 -y 2060 -defaultsOSRD
preplace inst material_idx_3 -pg 1 -lvl 5 -y 1560 -defaultsOSRD
preplace inst absorption_6_axi_ctrl -pg 1 -lvl 4 -y 670 -defaultsOSRD
preplace inst absorption_3_axi_ctrl -pg 1 -lvl 4 -y 430 -defaultsOSRD
preplace inst absorption_2_axi_ctrl -pg 1 -lvl 4 -y 310 -defaultsOSRD
preplace inst absorption_1 -pg 1 -lvl 5 -y 200 -defaultsOSRD
preplace inst absorption_0_axi_ctrl -pg 1 -lvl 4 -y 70 -defaultsOSRD
preplace inst materials_array_3_axi_ctrl -pg 1 -lvl 4 -y 2710 -defaultsOSRD
preplace inst materials_array_2 -pg 1 -lvl 5 -y 2160 -defaultsOSRD
preplace inst material_idx_4 -pg 1 -lvl 5 -y 1660 -defaultsOSRD
preplace inst absorption_5_axi_ctrl -pg 1 -lvl 4 -y 790 -defaultsOSRD
preplace inst absorption_2 -pg 1 -lvl 5 -y 320 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 2 -y 930 -defaultsOSRD
preplace inst materials_array_3 -pg 1 -lvl 5 -y 2260 -defaultsOSRD
preplace inst materials_array_0_axi_ctrl -pg 1 -lvl 4 -y 2350 -defaultsOSRD
preplace inst material_idx_5 -pg 1 -lvl 5 -y 1760 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 3 -y 1540 -defaultsOSRD
preplace inst absorption_7_axi_ctrl -pg 1 -lvl 4 -y 910 -defaultsOSRD
preplace inst absorption_3 -pg 1 -lvl 5 -y 440 -defaultsOSRD
preplace inst rst_clk_wiz_1_100M -pg 1 -lvl 2 -y 750 -defaultsOSRD
preplace inst material_idx_7_axi_ctrl -pg 1 -lvl 4 -y 2230 -defaultsOSRD
preplace inst material_idx_6 -pg 1 -lvl 5 -y 2360 -defaultsOSRD
preplace inst absorption_4 -pg 1 -lvl 5 -y 560 -defaultsOSRD
preplace inst absorption_1_axi_ctrl -pg 1 -lvl 4 -y 190 -defaultsOSRD
preplace inst microblaze_0_local_memory -pg 1 -lvl 3 -y 940 -defaultsOSRD
preplace inst material_idx_7 -pg 1 -lvl 5 -y 1860 -defaultsOSRD
preplace inst material_idx_6_axi_ctrl -pg 1 -lvl 4 -y 2830 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 1 -y 790 -defaultsOSRD
preplace inst absorption_5 -pg 1 -lvl 5 -y 800 -defaultsOSRD
preplace inst materials_array_1_axi_ctrl -pg 1 -lvl 4 -y 2470 -defaultsOSRD
preplace inst material_idx_5_axi_ctrl -pg 1 -lvl 4 -y 2110 -defaultsOSRD
preplace inst material_idx_3_axi_ctrl -pg 1 -lvl 4 -y 1870 -defaultsOSRD
preplace inst absorption_6 -pg 1 -lvl 5 -y 680 -defaultsOSRD
preplace inst absorption_4_axi_ctrl -pg 1 -lvl 4 -y 550 -defaultsOSRD
preplace netloc axi_interconnect_0_M08_AXI 1 3 1 1120
preplace netloc mc_light_prop_0_absorption_bram_7_PORTA 1 4 1 1710
preplace netloc axi_interconnect_0_M13_AXI 1 3 1 1200
preplace netloc axi_interconnect_0_M07_AXI 1 3 1 1100
preplace netloc mc_light_prop_0_absorption_bram_3_PORTA 1 4 1 1670
preplace netloc absorption_3_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc mc_light_prop_0_absorption_bram_6_PORTA 1 4 1 1690
preplace netloc mc_light_prop_0_absorption_bram_5_PORTA 1 4 1 1700
preplace netloc axi_interconnect_0_M04_AXI 1 3 1 1110
preplace netloc axi_interconnect_0_M18_AXI 1 3 1 1120
preplace netloc mc_light_prop_0_material_index_bram_5_PORTA 1 4 1 1680
preplace netloc microblaze_0_dlmb_1 1 2 1 N
preplace netloc axi_interconnect_0_M12_AXI 1 3 1 1190
preplace netloc materials_array_1_axi_ctrl_BRAM_PORTA 1 4 1 1830
preplace netloc rst_clk_wiz_1_100M_mb_reset 1 1 2 270 660 730
preplace netloc microblaze_0_M_AXI_DP 1 2 1 730
preplace netloc mc_light_prop_0_absorption_bram_0_PORTA 1 4 1 1640
preplace netloc axi_interconnect_0_M16_AXI 1 3 1 1060
preplace netloc clock_rtl_1 1 0 1 NJ
preplace netloc mc_light_prop_0_material_index_bram_7_PORTA 1 4 1 1660
preplace netloc material_idx_0_axi_ctrl_BRAM_PORTA 1 4 1 1710
preplace netloc absorption_5_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc rst_clk_wiz_1_100M_bus_struct_reset 1 2 1 770
preplace netloc mc_light_prop_0_material_index_bram_6_PORTA 1 4 1 1650
preplace netloc axi_interconnect_0_M01_AXI 1 3 1 1180
preplace netloc axi_bram_ctrl_13_BRAM_PORTA 1 4 1 1820
preplace netloc axi_interconnect_0_M02_AXI 1 3 1 1160
preplace netloc mc_light_prop_0_materials_array_2_PORTA 1 4 1 1750
preplace netloc axi_bram_ctrl_6_BRAM_PORTA 1 4 1 1640
preplace netloc absorption_7_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc microblaze_0_ilmb_1 1 2 1 N
preplace netloc axi_bram_ctrl_7_BRAM_PORTA 1 4 1 1730
preplace netloc mc_light_prop_0_materials_array_1_PORTA 1 4 1 1770
preplace netloc axi_interconnect_0_M20_AXI 1 3 1 1080
preplace netloc mdm_1_debug_sys_rst 1 1 1 240
preplace netloc axi_interconnect_0_M05_AXI 1 3 1 1050
preplace netloc mc_light_prop_0_material_index_bram_0_PORTA 1 4 1 N
preplace netloc axi_interconnect_0_M19_AXI 1 3 1 1050
preplace netloc mc_light_prop_0_absorption_bram_1_PORTA 1 4 1 1650
preplace netloc axi_bram_ctrl_5_BRAM_PORTA 1 4 1 1780
preplace netloc axi_interconnect_0_M09_AXI 1 3 1 1060
preplace netloc microblaze_0_Clk 1 1 3 250 70 760 70 1140
preplace netloc mc_light_prop_0_material_index_bram_3_PORTA 1 4 1 1760
preplace netloc axi_bram_ctrl_17_BRAM_PORTA 1 4 1 1850
preplace netloc axi_bram_ctrl_16_BRAM_PORTA 1 4 1 1840
preplace netloc mc_light_prop_0_material_index_bram_2_PORTA 1 4 1 1780
preplace netloc axi_interconnect_0_M10_AXI 1 3 1 1070
preplace netloc absorption_1_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc clk_wiz_1_locked 1 1 1 260
preplace netloc absorption_4_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc mc_light_prop_0_material_index_bram_4_PORTA 1 4 1 1740
preplace netloc microblaze_0_debug 1 1 1 N
preplace netloc axi_interconnect_0_M06_AXI 1 3 1 1080
preplace netloc axi_bram_ctrl_3_BRAM_PORTA 1 4 1 1800
preplace netloc absorption_2_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc axi_interconnect_0_M17_AXI 1 3 1 1150
preplace netloc mc_light_prop_0_absorption_bram_2_PORTA 1 4 1 1660
preplace netloc absorption_6_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc mc_light_prop_0_materials_array_3_PORTA 1 4 1 1720
preplace netloc axi_interconnect_0_M14_AXI 1 3 1 N
preplace netloc reset_rtl_0_1 1 0 2 20 730 NJ
preplace netloc axi_bram_ctrl_2_BRAM_PORTA 1 4 1 1810
preplace netloc materials_array_0_axi_ctrl_BRAM_PORTA 1 4 1 1640
preplace netloc absorption_0_axi_ctrl_BRAM_PORTA 1 4 1 N
preplace netloc axi_interconnect_0_M15_AXI 1 3 1 1100
preplace netloc mc_light_prop_0_absorption_bram_4_PORTA 1 4 1 1680
preplace netloc mc_light_prop_0_materials_array_0_PORTA 1 4 1 1790
preplace netloc mc_light_prop_0_material_index_bram_1_PORTA 1 4 1 1700
preplace netloc axi_bram_ctrl_14_BRAM_PORTA 1 4 1 1860
preplace netloc ARESETN_1 1 2 1 740
preplace netloc axi_interconnect_0_M11_AXI 1 3 1 1170
preplace netloc axi_interconnect_0_M03_AXI 1 3 1 1130
preplace netloc axi_interconnect_0_M00_AXI 1 3 1 1130
preplace netloc rst_clk_wiz_1_100M_peripheral_aresetn 1 2 2 750 790 1090
levelinfo -pg 1 0 130 500 910 1420 1970 2080 -top 0 -bot 2900
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


