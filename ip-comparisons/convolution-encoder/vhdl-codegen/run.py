#!/bin/env python3
from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).parent

VU = VUnit.from_argv()

VU.add_osvvm()
LIB = VU.add_library("lib")
LIB.add_source_files(ROOT / "rtl/encoder.vhd")
LIB.add_source_files(ROOT / "tb_encoder.vhd")

VU.main()
