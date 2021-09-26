set outputDir ./outputs
file mkdir $outputDir

create_project -in_memory -part xc7vx485tffg1761-2
read_ip ip/div_gen_0/div_gen_0.xci
set_property target_language VHDL [current_project]
set_property top dummy [current_fileset]
read_vhdl -vhdl2008 rtl/dummy.vhd
set_property top_file {rtl/dummy.vhd} [current_fileset]
read_xdc cons/consts.xdc

# Generate a DCP for the IP
# will generate output products if needed
#synth_ip [get_ips ip/div_gen_0]

# Read in an existing IP customization
# or create an IP from scratch
# create_ip ... or read_ip ip2.xci
# Set IP to use global synthesis (no DCP generated)
#set_property generate_synth_checkpoint false [get_files ip/div_gen_0/div_gen_0.xci]

# Need to generate output products for IP 
#generate_target all [get_files ip/div_gen_0/div_gen_0.xci]

# synthesis the complete design
synth_design -top dummy -mode out_of_context -retiming


# run implementation
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
