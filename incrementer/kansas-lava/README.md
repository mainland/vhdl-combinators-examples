## Dependencies:

* sized-types (version 0.3.5.1)
* Kansas-Lava (version io-0.2.0)


## To run and generate VHDL:
`> stack install`
`> bin/incrementer`

Generated VHDL sources directories:

* vhdl/serial/
* vhdl/parallel/
* vhdl/parallel-bubble-squeeze/

## To test the generated VHDL sources:

Redirect to testbench/vunit-ghdl/ for each implementation:

`python3 run.py`

## To synthesize the generated VHDL sources:

Redirect to syn/ for each implementation, and to run the rebuild.tcl script using the constraint files in /const directory:

`make`

Or to use the `vivadostats` tool:

`./run.sh`
