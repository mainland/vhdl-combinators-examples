set clockPeriod 1.504

create_clock -period $clockPeriod [get_ports clk]

set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports clk]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#set_input_delay -clock clk -add_delay 0.300 [get_ports -filter { NAME !~ "*clk*" && DIRECTION == "IN" }]
#set_output_delay -clock clk -add_delay 0.001 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]
