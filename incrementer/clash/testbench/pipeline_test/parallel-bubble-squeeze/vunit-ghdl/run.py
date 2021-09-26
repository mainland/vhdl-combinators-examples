#!/bin/env python3
from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).parent

VU = VUnit.from_argv()

VU.add_osvvm()
LIB = VU.add_library("lib")
LIB.add_source_files(ROOT / "tb_example.vhd")
LIB.add_source_files("../../../../vhdl/Incrementer.incrementer_u16_bubbles/*.vhdl")

VU.set_compile_option("ghdl.a_flags", ["--ieee=synopsys"])
VU.set_sim_option("ghdl.elab_flags", ["--ieee=synopsys"])
#VU.set_sim_option("ghdl.sim_flags", ["--wave=tb_example.ghw"])
VU.main()
