create_clock -period 1.600 -name clk -waveform {0.000 0.800} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]

set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports clk]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
