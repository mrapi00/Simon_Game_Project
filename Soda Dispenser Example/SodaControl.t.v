//===============================================================================
// Testbench Module for Soda Dispenser Controller
//===============================================================================
`timescale 1ns/100ps

`include "SodaControl.v"

// Print an error message (MSG) if value ONE is not equal
// to value TWO.
`define ASSERT_EQ(ONE, TWO, MSG)               \
	begin                                      \
		if ((ONE) !== (TWO)) begin             \
			$display("\t[FAILURE]:%s", (MSG)); \
		end                                    \
	end #0

// Set the variable VAR to the value VALUE, printing a notification
// to the screen indicating the variable's update.
// The setting of the variable is preceeded and followed by
// a 1-timestep delay.
`define SET(VAR, VALUE) $display("Setting %s to %s...", "VAR", "VALUE"); #1; VAR = (VALUE); #1

module SodaControlTest;

	// Local Vars
	reg clk = 0;
    reg rst = 0;
    reg c = 0;
    reg tot_lt_s = 1;
    wire tot_ld;
    wire tot_clr; 
    wire d;

	// VCD Dump
	initial begin
		$dumpfile("SodaControlTest.vcd");
		$dumpvars;
	end

	// Soda Control Module
	SodaControl ctrl(
        .clk (clk),          
        .rst (rst), 
        .c (c),     
        .tot_lt_s (tot_lt_s), 


        .tot_ld (tot_ld), 
        .tot_clr (tot_clr), 
        .d (d)
    );

    // Clock
	always begin
		#1 clk = ~clk;
	end

	// Main Test Logic
	initial begin
		// Reset controller, and check that tot_clr is 1, and d is 0
        $display("\nStarting controller testing");
        `SET(rst, 1);
        `ASSERT_EQ(tot_clr, 1, "tot_clr incorrect");
        `ASSERT_EQ(d, 0, "d incorrect");
        `SET(rst, 0);

        // Input a coin, and check tot_ld is 1
        `SET(c, 1);
        `SET(c, 0);
        `ASSERT_EQ(tot_ld, 1, "tot_ld incorrect");

        // Set tot_lt_s to 1, and check that d is still 0
        `SET(tot_lt_s, 1);
        `ASSERT_EQ(d, 0, "d incorrect");

        // Input another coin, and check tot_ld is 1
        `SET(c, 1);
        `SET(c, 0);
        `ASSERT_EQ(tot_ld, 1, "tot_ld incorrect");

        // Set tot_lt_s to 0, wait one clock cycle, and check that d is now 1
        `SET(tot_lt_s, 0);
        #2
        `ASSERT_EQ(d, 1, "d incorrect");

        // wait one clock cycle, and check that tot_clear is 1, and d is 0
        #2
        `ASSERT_EQ(tot_clr, 1, "tot_clr incorrect");
        `ASSERT_EQ(d, 0, "d incorrect");

        $finish;
	end

endmodule
