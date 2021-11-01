//===============================================================================
// Testbench Module for Soda Dispenser Datapath
//===============================================================================
`timescale 1ns/100ps

`include "SodaDatapath.v"

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

module SodaDatapathTest;

	// Local Vars
	reg clk = 0;
    reg [7:0] s;
    reg [7:0] a;
    reg tot_ld = 0;
    reg tot_clr = 0;
    wire tot_lt_s;

	// VCD Dump
	initial begin
		$dumpfile("SodaDatapathTest.vcd");
		$dumpvars;
	end

	// Soda Datapath Module
	SodaDatapath dpath(
        .clk (clk),
        .s (s),
        .a (a),
        .tot_ld (tot_ld),
        .tot_clr (tot_clr), 
        .tot_lt_s (tot_lt_s)
    );

    // Clock
	always begin
		#1 clk = ~clk;
	end

	// Main Test Logic
	initial begin
		// Clear the tot register, and set soda price to 60 cents
        $display("\nStarting datapath testing");
        `SET(tot_clr, 1);
        `SET(tot_clr, 0);
		`SET(s, 8'd60);

        // Load in a coin with value 25 cents, and check that tot_lt_s is true
        `SET(a, 8'd25);
        `SET(tot_ld, 1);
        `SET(tot_ld, 0);
        `ASSERT_EQ(tot_lt_s, 1, "tot_lt_s incorrect");

        // load in a coin with value 10 cents, and check that tot_lt_s is true
        `SET(a, 8'd10);
        `SET(tot_ld, 1);
        `SET(tot_ld, 0);
        `ASSERT_EQ(tot_lt_s, 1, "tot_lt_s incorrect");

        // load in a coin with value 5 cents, and check that tot_lt_s is true
        `SET(a, 8'd5);
        `SET(tot_ld, 1);
        `SET(tot_ld, 0);
        `ASSERT_EQ(tot_lt_s, 1, "tot_lt_s incorrect");

        // Load in a coin with value 25 cents, and check that tot_lt_s is false
        `SET(a, 8'd25);
        `SET(tot_ld, 1);
        `SET(tot_ld, 0);
        `ASSERT_EQ(tot_lt_s, 0, "tot_lt_s incorrect");

        // Clear the tot register, and check that tot_lt_s is true
        `SET(tot_clr, 1);
        `SET(tot_clr, 0);
        `ASSERT_EQ(tot_lt_s, 1, "tot_lt_s incorrect");
        $finish;
	end

endmodule
