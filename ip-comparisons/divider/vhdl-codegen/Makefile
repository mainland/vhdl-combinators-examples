RUNGHC = stack runghc

.PHONY : all
all : rtl/divider_serial.vhd tb_divider.vhd rtl/divider_parallel.vhd data/in.csv data/out.csv

.PHONY : clean
clean :
	rm -f rtl/divider_parallel.vhd tb_divider.vhd
	rm -f rtl/divider_serial.vhd tb_divider.vhd
	rm -rf vunit_out

rtl/divider_serial.vhd tb_divider.vhd : Main.hs
	stack run divider -- -o rtl/divider_serial.vhd -t tb_divider.vhd || rm -f $@

rtl/divider_parallel.vhd tb_divider.vhd : Main.hs
	stack run divider -- -p -o rtl/divider_parallel.vhd || rm -f $@


data/in.csv data/out.csv : Main.hs
	stack run divider -- -n 100 --tvinput data/in.csv --tvoutput data/out.csv || rm -f $@

.PHONY : test
test : rtl/divider_serial.vhd tb_divider.vhd data/in.csv data/out.csv
	./run.py
