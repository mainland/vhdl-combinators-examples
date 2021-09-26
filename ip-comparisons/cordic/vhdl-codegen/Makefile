RUNGHC = stack runghc

.PHONY : all
all : rtl/cordic_serial.vhd tb_cordic.vhd rtl/cordic_parallel.vhd data/in.csv data/out.csv

.PHONY : clean
clean :
	rm -f rtl/cordic_parallel.vhd tb_cordic.vhd
	rm -f rtl/cordic_serial.vhd tb_cordic.vhd
	rm -rf vunit_out

rtl/cordic_serial.vhd tb_cordic.vhd : Main.hs
	stack run cordic -- -s -o rtl/cordic_serial.vhd -t tb_cordic.vhd || rm -f $@

rtl/cordic_parallel.vhd tb_cordic.vhd : Main.hs
	stack run cordic -- -p -o rtl/cordic_parallel.vhd || rm -f $@


data/in.csv data/out.csv : Main.hs
	stack run cordic -- -n 100 --tvinput data/in.csv --tvoutput data/out.csv || rm -f $@

.PHONY : test
test : rtl/cordic_serial.vhd tb_cordic.vhd data/in.csv data/out.csv
	./run.py
