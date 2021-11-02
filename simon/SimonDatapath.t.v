//===============================================================================
// Testbench Module for Simon Datapath
//===============================================================================
`timescale 1ns/100ps

`include "SimonDatapath.v"

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

// Cycle the clock up and then down, simulating
// a button press.
`define CLOCK $display("Pressing uclk..."); #1; clk = 1; #1; clk = 0; #1

module SimonDatapathTest;

	// Local Vars
	reg clk = 0;
	reg level = 0;
	reg [3:0] pattern = 4'b0000;

	reg w_en = 0;
	reg set_level = 0;
	reg read_Memory = 0;
	reg cnt_count = 0;
	reg clr_count = 0;
	reg cnt_index = 0;
	reg clr_index = 0;

	wire index_lt_count;
	wire input_eq_pattern;
	wire is_legal;

	wire [3:0] pattern_leds;

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	integer idx;
	initial begin
		$dumpfile("SimonDatapathTest.vcd");
		$dumpvars;
		for (idx = 0; idx < 64; idx = idx + 1) begin
			$dumpvars(0, dpath.mem.mem[idx]);
		end
	end

	// Simon DataPath Module
	SimonDatapath dpath(
		.clk     (clk),
		.level   (level),
		.pattern (pattern),
		.cnt_count (cnt_count),
		.clr_count(clr_count),
		.cnt_index(cnt_index),
		.clr_index(clr_index),
		.w_en(w_en),
		.set_level(set_level),
		.read_Memory(read_Memory),
		.index_lt_count(index_lt_count),
		.input_eq_pattern(input_eq_pattern),
		.is_legal(is_legal),

		.pattern_leds(pattern_leds)
	);

	// Main Test Logic
	initial begin
		
		
		$finish;
	end

endmodule
