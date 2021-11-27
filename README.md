# Simon_Project

A datapath and control circuit for a two-player version of Simon, a popular electronic toy designed to test the
memory of its players, programmed in Verilog.

Compilation:
iverilog -g2005 -Wall -Wno-timescale -o SimonTATest SimonTA.t.v

Run:
vvp SimonTATest

Viewing simulation on GTKWave:
gtkwave SimonTATest.vcd
