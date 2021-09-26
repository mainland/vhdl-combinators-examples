#!/bin/sh

#cat ../../vhdl/HandshakeParallelBubble.topEntity/paralleliterb_types.vhdl ../../vhdl/HandshakeParallelBubble.topEntity/paralleliterb.vhdl > rtl/paralleliterb.vhdl

#cat ../../vhdl/HandshakeParallelBubble.topEntityFixed/paralleliterb_fixed_types.vhdl ../../vhdl/HandshakeParallelBubble.topEntityFixed/paralleliterb_fixed.vhdl > rtl/paralleliterb_fixed.vhdl

cat ../../vhdl/Incrementer.incrementer_u8_8_parallel/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u8_8_parallel/incrementer.vhdl > rtl/incrementer_fixed.vhdl
cat ../../vhdl/Incrementer.incrementer_u16_parallel/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u16_parallel/incrementer.vhdl > rtl/incrementer.vhdl

virtualenv -p python3 venv
. venv/bin/activate
pip install -e ../../../../tools/vivadostats

vivadostats -d rtl/incrementer.vhdl --top incrementer --clock-period 2 -o stats
vivadostats -d rtl/incrementer_fixed.vhdl --top incrementer --clock-period 2 -o stats_fixed
