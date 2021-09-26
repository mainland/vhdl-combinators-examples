.PHONY : all


all : parallel
#serial:
#	vivado -nolog -nojou -mode batch -source build_serial.tcl
parallel:
	vivado -nolog -nojou -mode batch -source build_parallel.tcl

.PHONY : clean
clean :
#	rm -rf outputs_serial outputs_parallel .Xil
	rm -rf outputs .Xil
