.PHONY : all
all : u16 u8_8
u16:
	vivado -nolog -nojou -mode batch -source build_u16.tcl

u8_8:
	vivado -nolog -nojou -mode batch -source build_u8_8.tcl

.PHONY : clean
clean :
	rm -rf outputs .Xil
