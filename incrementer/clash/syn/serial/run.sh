#!/bin/sh

#cat ../../vhdl/HandshakeSerial.topEntity/serialiter_types.vhdl ../../vhdl/HandshakeSerial.topEntity/serialiter.vhdl > rtl/serialiter.vhdl

#cat ../../vhdl/HandshakeSerial.topEntityFixed/serialiter_fixed_types.vhdl ../../vhdl/HandshakeSerial.topEntityFixed/serialiter_fixed.vhdl > rtl/serialiter_fixed.vhdl

cat ../../vhdl/Incrementer.incrementer_u8_8_serial/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u8_8_serial/incrementer.vhdl > rtl/incrementer_fixed.vhdl
cat ../../vhdl/Incrementer.incrementer_u16_serial/incrementer_types.vhdl ../../vhdl/Incrementer.incrementer_u16_serial/incrementer.vhdl > rtl/incrementer.vhdl

virtualenv -p python3 venv
. venv/bin/activate
pip install -e ../../../../tools/vivadostats

vivadostats -d rtl/incrementer.vhdl --top incrementer --clock-period 2 -o stats
vivadostats -d rtl/incrementer_fixed.vhdl --top incrementer --clock-period 2 -o stats_fixed
