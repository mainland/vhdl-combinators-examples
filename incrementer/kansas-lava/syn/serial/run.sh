#!/bin/sh

cat ../../vhdl/Lava.vhd ../../vhdl/serial/incrementer.vhd > rtl/incrementer.vhd

cat ../../vhdl/Lava.vhd ../../vhdl/serial/incrementer_fixed.vhd > rtl/incrementer_fixed.vhd

cat ../../vhdl/Lava.vhd ../../vhdl/serial/incrementer_rtl_dsl.vhd > rtl/incrementer_rtl_dsl.vhd

cat ../../vhdl/Lava.vhd ../../vhdl/serial/incrementer_rtl_dsl_fixed.vhd > rtl/incrementer_rtl_dsl_fixed.vhd

virtualenv -p python3 venv
. venv/bin/activate
pip install -e ../../../../tools/vivadostats


vivadostats -d rtl/incrementer.vhd --top incrementer --clock-period 2 -o stats
vivadostats -d rtl/incrementer_fixed.vhd --top incrementer --clock-period 2 -o stats_fixed
vivadostats -d rtl/incrementer_rtl_dsl.vhd --top incrementer --clock-period 2 -o stats_rtl_dsl
vivadostats -d rtl/incrementer_rtl_dsl_fixed.vhd --top incrementer --clock-period 2 -o stats_rtl_dsl_fixed
