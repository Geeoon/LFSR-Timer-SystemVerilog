# LFSR Timer in SystemVerilog
Given a pre-determined number of clock cycles to wait for, this circuit will count the number of clock cycles until the number of clock cycles has been reached.

The advantage of using an LFSR is that we don't need to use an adder or a shifter.  This means the longest path can be very short, and the resource utilization is very low.

This was part of a different project, but I figured I would end up using this pretty frequently, so I made it its own repository.
