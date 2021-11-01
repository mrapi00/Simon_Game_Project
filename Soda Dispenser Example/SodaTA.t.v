//===============================================================================
// Testbench Module for Soda
//===============================================================================
`timescale 1ns/100ps

`include "Soda.v"

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

module SodaTATest;

	// Local Vars
	reg clk = 0;
    reg rst = 0;
    reg c = 0;
    reg [7:0] s;
    reg [7:0] a = 0;
    wire d;

	// VCD Dump
	initial begin
		$dumpfile("SodaTATest.vcd");
		$dumpvars;
	end

	// Soda Module
    Soda soda(
        .clk (clk),
        .rst (rst),
        .c (c),
        .s (s),
        .a (a),
        .d (d)
    );

    // Clock
	always begin
		#1 clk = ~clk;
	end

	// Main Test Logic
	initial begin
        // Reset soda dispenser, setting soda price to 60 cents, and check d = 0
        $display("\nStarting soda dispenser testing");
        `SET(s, 8'd60);
        `SET(rst, 1);
        `SET(rst, 0);
        `ASSERT_EQ(d, 0, "d incorrect");

        // Insert a coin with value 25 cents, and check d = 0
        `SET(a, 8'd25);
        `SET(c, 1);
        `SET(c, 0);
        `ASSERT_EQ(d, 0, "d incorrect");

        // Insert a coin with value 10 cents, and check d = 0
        `SET(a, 8'd10);
        `SET(c, 1);
        `SET(c, 0);
        `ASSERT_EQ(d, 0, "d incorrect");


        // Insert a coin with value 5 cents, and check d = 0
        `SET(a, 8'd5);
        `SET(c, 1);
        `SET(c, 0);
        `ASSERT_EQ(d, 0, "d incorrect");

        // Insert a coin with value 25 cents
        `SET(a, 8'd25);
        `SET(c, 1);
        `SET(c, 0);
        #4 // wait two cycles through ADD, WAIT states, and check d = 1
        `ASSERT_EQ(d, 1, "d incorrect");

        #2 // wait one cycle through DONE state, and check d = 0
        `ASSERT_EQ(d, 0, "d incorrect!!");

        $finish;
	end

endmodule
