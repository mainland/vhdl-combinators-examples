.PHONY : all
all : u16 u8_8 u16_rtl u8_8_rtl
u16:
	vivado -nolog -nojou -mode batch -source build_u16.tcl
u8_8:
	vivado -nolog -nojou -mode batch -source build_u8_8.tcl
u16_rtl:
	vivado -nolog -nojou -mode batch -source build_u16_rtl.tcl
u8_8_rtl:
	vivado -nolog -nojou -mode batch -source build_u8_8_rtl.tcl

.PHONY : clean
clean :
	rm -rf outputs_* .Xil
