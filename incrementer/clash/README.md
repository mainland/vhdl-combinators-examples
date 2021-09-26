## To run and generate VHDL:

`stack run clash -- HandshakeSerial HandshakeParallel HandshakeParallelBubble --vhdl`


Generated VHDL sources directories:

* vhdl/HandshakeSerial.topEntity
* vhdl/HandshakeParallel.topEntity
* vhdl/HandshakeParallelBubble.topEntity
* vhdl/HandshakeSerial.topEntityFixed
* vhdl/HandshakeParallel.topEntityFixed
* vhdl/HandshakeParallelBubble.topEntityFixed

## To test the generated VHDL sources:

Redirect to testbench/ for each implementation:

`python3 run.py`

## To synthesize the generated VHDL sources:

Redirect to syn/ for each implementation, and to run the rebuild.tcl script using the constraint files in /const directory:

`make`

Or to use the `vivadostats` tool:

`./run.sh`
