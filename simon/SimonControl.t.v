//===============================================================================
// Testbench Module for Simon Controller
//===============================================================================
`timescale 1ns/100ps

`include "SimonControl.v"

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

module SimonControlTest;

	// Local Vars
	reg clk = 0;
	reg rst = 0;
	reg is_legal = 0;
	reg index_lt_count = 0;
	reg input_eq_pattern = 0;
	wire cnt_count, clr_count, cnt_index, clr_index, read_Memory, w_en, set_level;
	wire [2:0] mode_leds;


	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// VCD Dump
	initial begin
		$dumpfile("SimonControlTest.vcd");
		$dumpvars;
	end

	// Simon Control Module
	SimonControl ctrl(
		.clk (clk),
		.rst (rst),
		.index_lt_count (index_lt_count),
		.input_eq_pattern (input_eq_pattern),
		.is_legal (is_legal),
		.cnt_count(cnt_count),
		.clr_count(clr_count),
		.clr_index(clr_index),
		.cnt_index(cnt_index),
		.read_Memory(read_Memory),
		.w_en(w_en),
		.set_level(set_level),
		.mode_leds(mode_leds)
	);

	// Main Test Logic
	initial begin
		// Reset the game
		`SET(rst, 1);
		`ASSERT_EQ(clr_count,1,"Count not cleared on reset");
		`ASSERT_EQ(set_level, 1, "Level load not 1 on reset");
		`CLOCK;
		`SET(rst, 0);
		`ASSERT_EQ(clr_count,0,"Count clear not 0");
		`ASSERT_EQ(set_level, 0, "Level load not 0");
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Wrong mode");

		`SET(is_legal, 1);
		`ASSERT_EQ(w_en, 1 , "write enable when valid pattern");
		`ASSERT_EQ(clr_index, 1, "clear index when valid pattern");
		`ASSERT_EQ(read_Memory, 0, "displaying pattern in input mode");
		
		`CLOCK;

		`SET(is_legal, 0);
		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "mode not in playback");
		`ASSERT_EQ(read_Memory, 1, "playback not displaying mem");
		
		`SET(index_lt_count, 1)

		`ASSERT_EQ(cnt_index, 1, "not incrementing index");
		`ASSERT_EQ(clr_index, 0, "clearing index too soon");

		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_PLAYBACK, "mode didn't stay in playback");

		`SET(index_lt_count, 0);
		`CLOCK;

		`SET(index_lt_count, 0);
		`SET(input_eq_pattern, 1);

		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "mode not in repeat");
		`ASSERT_EQ(read_Memory, 0, "not displaying switches");
		`ASSERT_EQ(clr_index, 0, "clearing without being done");
		`ASSERT_EQ(cnt_count, 1, "not incrementing count");

		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "Did not go into input mode");	

		`SET(is_legal,0);
		`ASSERT_EQ(w_en, 0, "writing incorrect pattern");
		`ASSERT_EQ(read_Memory, 0, "not displaying pattern");

		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_INPUT, "advanced to playback without correct pattern");

		`SET(is_legal, 1);
		`CLOCK;
		`SET(index_lt_count, 0);
		`CLOCK;

		`ASSERT_EQ(mode_leds, LED_MODE_REPEAT, "Mode not in repeat");

		`SET(input_eq_pattern, 0);
		`CLOCK;
		`ASSERT_EQ(mode_leds, LED_MODE_DONE, "Mode not done after incorrect pattern");

		$finish;
	end
endmodule