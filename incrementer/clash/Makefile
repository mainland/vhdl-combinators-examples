CLASHARGS=-O2 -fno-worker-wrapper

SRC = \
	src/Pipeline.hs \
	src/Incrementer.hs

GENERATED = \
	vhdl/Incrementer.incrementer_u16_bubbles/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u16_bubbles/incrementer.vhdl \
	vhdl/Incrementer.incrementer_u16_parallel/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u16_parallel/incrementer.vhdl \
	vhdl/Incrementer.incrementer_u16_serial/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u16_serial/incrementer.vhdl \
	vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer.vhdl \
	vhdl/Incrementer.incrementer_u8_8_parallel/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u8_8_parallel/incrementer.vhdl \
	vhdl/Incrementer.incrementer_u8_8_serial/incrementer_types.vhdl \
	vhdl/Incrementer.incrementer_u8_8_serial/incrementer.vhdl

.PHONY : all
all : $(GENERATED)

.PHONY : clean
clean :
	rm -f $(GENERATED)

$(GENERATED) : $(SRC)
	stack run clash -- Incrementer --vhdl $(CLASHARGS)

STATS = \
	stats/incrementer_u16_bubbles/incrementer_clock.csv \
	stats/incrementer_u16_parallel/incrementer_clock.csv \
	stats/incrementer_u16_serial/incrementer_clock.csv \
	stats/incrementer_u8_8_bubbles/incrementer_clock.csv \
	stats/incrementer_u8_8_parallel/incrementer_clock.csv \
	stats/incrementer_u8_8_serial/incrementer_clock.csv

.PHONY : stats
stats : $(STATS)

stats/incrementer_u16_bubbles/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u16_bubbles vhdl/Incrementer.incrementer_u16_bubbles/incrementer.vhdl vhdl/Incrementer.incrementer_u16_bubbles/incrementer_types.vhdl

stats/incrementer_u16_parallel/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u16_parallel vhdl/Incrementer.incrementer_u16_parallel/incrementer.vhdl vhdl/Incrementer.incrementer_u16_parallel/incrementer_types.vhdl

stats/incrementer_u16_serial/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u16_serial vhdl/Incrementer.incrementer_u16_serial/incrementer.vhdl vhdl/Incrementer.incrementer_u16_serial/incrementer_types.vhdl

stats/incrementer_u8_8_bubbles/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u8_8_bubbles vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer.vhdl vhdl/Incrementer.incrementer_u8_8_bubbles/incrementer_types.vhdl

stats/incrementer_u8_8_parallel/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u8_8_parallel vhdl/Incrementer.incrementer_u8_8_parallel/incrementer.vhdl vhdl/Incrementer.incrementer_u8_8_parallel/incrementer_types.vhdl

stats/incrementer_u8_8_serial/incrementer_clock.csv :
	vivadostats -d --clock-period 1.3 --once --top incrementer -o stats/incrementer_u8_8_serial vhdl/Incrementer.incrementer_u8_8_serial/incrementer.vhdl vhdl/Incrementer.incrementer_u8_8_serial/incrementer_types.vhdl
