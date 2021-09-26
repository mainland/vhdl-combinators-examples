RUNGHC = stack runghc

GENERATED = \
	vhdl/incrementer_uq16_serial.vhd \
	vhdl/incrementer_uq16_parallel.vhd \
	vhdl/incrementer_uq16_bubbles.vhd \
	vhdl/incrementer_uq8_8_serial.vhd \
	vhdl/incrementer_uq8_8_parallel.vhd \
	vhdl/incrementer_uq8_8_bubbles.vhd

.PHONY : all
all : $(GENERATED)

.PHONY : clean
clean :
	rm -f $(GENERATED)

vhdl/incrementer_uq16_serial.vhd : Main.hs
	$(RUNGHC) $< -- -s --uq16 -o $@ || rm -f $@

vhdl/incrementer_uq16_parallel.vhd : Main.hs
	$(RUNGHC) $< -- -p --uq16 -o $@ || rm -f $@

vhdl/incrementer_uq16_bubbles.vhd : Main.hs
	$(RUNGHC) $< -- -b --uq16  -o $@ || rm -f $@

vhdl/incrementer_uq8_8_serial.vhd : Main.hs
	$(RUNGHC) $< -- -s --uq8.8 -o $@ || rm -f $@

vhdl/incrementer_uq8_8_parallel.vhd : Main.hs
	$(RUNGHC) $< -- -p --uq8.8 -o $@ || rm -f $@

vhdl/incrementer_uq8_8_bubbles.vhd : Main.hs
	$(RUNGHC) $< -- -b --uq8.8  -o $@ || rm -f $@

stats/%_clock.csv : vhdl/%.vhd
	vivadostats -d --clock 5 $< -o stats
