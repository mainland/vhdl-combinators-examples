set outputDir ./outputs_u8_8
file mkdir $outputDir

read_vhdl -vhdl2008 ../../vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer_types.vhdl
read_vhdl -vhdl2008 ../../vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer.vhdl
set_property top incrementer [current_fileset]
set_property top_file {../../vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer.vhdl} [current_fileset]
read_xdc ./const/const_fixed.xdc

synth_design -top incrementer -part xc7vx485tffg1761-2 -mode out_of_context -retiming
write_checkpoint -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt
report_utilization -file $outputDir/post_synth_util.rpt

opt_design -directive Explore
power_opt_design
place_design -directive Explore
phys_opt_design
write_checkpoint -force $outputDir/post_place.dcp
report_utilization -file $outputDir/post_place_util.rpt
report_timing_summary -file $outputDir/post_place_timing.rpt

route_design
write_checkpoint -force $outputDir/post_route.dcp
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_methodology -file $outputDir/post_impl_checks.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/impl.xdc
