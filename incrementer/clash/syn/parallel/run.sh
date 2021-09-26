#!/bin/sh

#cat ../../vhdl/HandshakeParallel.topEntity/paralleliter_types.vhdl ../../vhdl/HandshakeParallel.topEntity/paralleliter.vhdl > rtl/paralleliter.vhdl

#cat ../../vhdl/HandshakeParallel.topEntityFixed/paralleliter_fixed_types.vhdl ../../vhdl/HandshakeParallel.topEntityFixed/paralleliter_fixed.vhdl > rtl/paralleliter_fixed.vhdl

cat ../../vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer.vhdl > rtl/incrementer_fixed.vhdl
cat ../../vhdl/Incrementer.incrementer_u16_bubbles/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u16_bubbles/incrementer.vhdl > rtl/incrementer.vhdl


virtualenv -p python3 venv
. venv/bin/activate
pip install -e ../../../../tools/vivadostats

vivadostats -d rtl/incrementer.vhdl --top incrementer --clock-period 2 -o stats
vivadostats -d rtl/incrementer_fixed.vhdl --top incrementer --clock-period 2 -o stats_fixed

#vivadostats -d rtl/paralleliter.vhdl --top paralleliter --clock-period 2 -o stats
#vivadostats -d rtl/paralleliter_fixed.vhdl --top paralleliter_fixed --clock-period 2 -o stats_fixed
