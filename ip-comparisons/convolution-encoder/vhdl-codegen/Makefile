RUNGHC = stack run

.PHONY : all
all : rtl/encoder.vhd tb_encoder.vhd

.PHONY : clean
clean :
	rm -f rtl/encoder.vhd tb_encoder.vhd
	rm -rf vunit_out

rtl/encoder.vhd tb_encoder.vhd : Main.hs
	$(RUNGHC) $< -- -o rtl/encoder.vhd -t tb_encoder.vhd || rm -f $@

.PHONY : test
test : rtl/encoder.vhd tb_encoder.vhd data/in.csv data/out.csv
	./run.py
