proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -id {BD 41-968}  -string {{xillybus_S_AXI}}  -new_severity {INFO} 
set_msg_config  -id {BD 41-967}  -string {{xillybus_ip_0/xillybus_M_AXI}}  -new_severity {INFO} 
set_msg_config  -id {BD 41-967}  -string {{xillybus_ip_0/xillybus_S_AXI}}  -new_severity {INFO} 
set_msg_config  -id {BD 41-678}  -string {{xillybus_S_AXI/Reg}}  -new_severity {INFO} 
set_msg_config  -id {BD 41-1356}  -string {{xillybus_S_AXI/Reg}}  -new_severity {INFO} 
set_msg_config  -id {BD 41-759}  -string {{xlconcat_0/In}}  -new_severity {INFO} 
set_msg_config  -id {Netlist 29-160}  -string {{vivado_system_processing_system7}}  -new_severity {INFO} 

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  debug::add_scope template.lib 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.cache/wt [current_project]
  set_property parent.project_path C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.xpr [current_project]
  set_property ip_repo_paths {
  c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.cache/ip
  C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado-ip
} [current_project]
  set_property ip_output_repo c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.cache/ip [current_project]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/synth_1/KalmanProject.dcp
  set_property edif_extra_search_paths C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/cores [current_fileset]
  read_edif c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/system/pcores/xillybus_lite_v1_00_a/netlist/xillybus_lite.ngc
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/vga_fifo_synth_1/vga_fifo.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/vga_fifo_synth_1/vga_fifo.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/PLPS_FIFO_synth_1/PLPS_FIFO.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/PLPS_FIFO_synth_1/PLPS_FIFO.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_conv_synth_1/fp_conv.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_conv_synth_1/fp_conv.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_mul_synth_1/fp_mul.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_mul_synth_1/fp_mul.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_sub_synth_1/fp_sub.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_sub_synth_1/fp_sub.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_add_synth_1/fp_add.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_add_synth_1/fp_add.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_MLA_synth_1/fp_MLA.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_MLA_synth_1/fp_MLA.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_sqrt_synth_1/fp_sqrt.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_sqrt_synth_1/fp_sqrt.dcp]
  add_files -quiet C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_div_synth_1/fp_div.dcp
  set_property netlist_only true [get_files C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/fp_div_synth_1/fp_div.dcp]
  read_xdc -ref vivado_system_processing_system7_0_0 -cells inst c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_processing_system7_0_0/vivado_system_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_processing_system7_0_0/vivado_system_processing_system7_0_0.xdc]
  read_xdc -prop_thru_buffers -ref vivado_system_rst_processing_system7_0_100M_0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_rst_processing_system7_0_100M_0/vivado_system_rst_processing_system7_0_100M_0_board.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_rst_processing_system7_0_100M_0/vivado_system_rst_processing_system7_0_100M_0_board.xdc]
  read_xdc -ref vivado_system_rst_processing_system7_0_100M_0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_rst_processing_system7_0_100M_0/vivado_system_rst_processing_system7_0_100M_0.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vivado_system/ip/vivado_system_rst_processing_system7_0_100M_0/vivado_system_rst_processing_system7_0_100M_0.xdc]
  read_xdc -mode out_of_context -ref vga_fifo -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo_ooc.xdc]
  read_xdc -ref vga_fifo -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo/vga_fifo.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo/vga_fifo.xdc]
  read_xdc -mode out_of_context -ref PLPS_FIFO -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO_ooc.xdc]
  read_xdc -ref PLPS_FIFO -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO/PLPS_FIFO.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO/PLPS_FIFO.xdc]
  read_xdc -mode out_of_context -ref fp_conv -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_conv/fp_conv_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_conv/fp_conv_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_mul -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_mul/fp_mul_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_mul/fp_mul_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_sub -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_sub/fp_sub_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_sub/fp_sub_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_add -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_add/fp_add_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_add/fp_add_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_MLA -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_MLA/fp_MLA_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_MLA/fp_MLA_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_sqrt -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_sqrt/fp_sqrt_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_sqrt/fp_sqrt_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_div -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_div/fp_div_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/fp_div/fp_div_ooc.xdc]
  read_xdc C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/KalmanProject.xdc
  read_xdc -ref vga_fifo -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo/vga_fifo_clocks.xdc
  set_property processing_order LATE [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vivado-essentials/vga_fifo/vga_fifo/vga_fifo_clocks.xdc]
  read_xdc -ref PLPS_FIFO -cells U0 c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO/PLPS_FIFO_clocks.xdc
  set_property processing_order LATE [get_files c:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.srcs/sources_1/ip/PLPS_FIFO/PLPS_FIFO/PLPS_FIFO_clocks.xdc]
  link_design -top KalmanProject -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force KalmanProject_opt.dcp
  catch {report_drc -file KalmanProject_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force KalmanProject_placed.dcp
  catch { report_io -file KalmanProject_io_placed.rpt }
  catch { report_clock_utilization -file KalmanProject_clock_utilization_placed.rpt }
  catch { report_utilization -file KalmanProject_utilization_placed.rpt -pb KalmanProject_utilization_placed.pb }
  catch { report_control_sets -verbose -file KalmanProject_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force KalmanProject_routed.dcp
  catch { report_drc -file KalmanProject_drc_routed.rpt -pb KalmanProject_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file KalmanProject_timing_summary_routed.rpt -rpx KalmanProject_timing_summary_routed.rpx }
  catch { report_power -file KalmanProject_power_routed.rpt -pb KalmanProject_power_summary_routed.pb }
  catch { report_route_status -file KalmanProject_route_status.rpt -pb KalmanProject_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force KalmanProject.bit 
  if { [file exists C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/synth_1/KalmanProject.hwdef] } {
    catch { write_sysdef -hwdef C:/Users/Laudelino/SkyDrive/Estudos/UTFPR/9th/TCC2/Proj/V144D/20160702/KalmanProject/vhdl/vivado/KalmanProject.runs/synth_1/KalmanProject.hwdef -bitfile KalmanProject.bit -meminfo KalmanProject.mmi -file KalmanProject.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

