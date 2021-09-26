all: foo
SOURCE_FILES = $(shell find . -name '*.tcl')

.ONESHELL:
foo: ${SOURCE_FILES}
		FILES=()
		for F in $^; do
				FILES+=($${F})
		done
		vivado -nolog -nojou -mode batch -source "$${FILES[@]}"

.PHONY : clean
clean :
	rm -rf outputs_uq16 outputs_uq8_8 .Xil
