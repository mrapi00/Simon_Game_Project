//==============================================================================
// Simon Module for Simon Project
//==============================================================================

`include "SimonControl.v"
`include "SimonDatapath.v"

module Simon(
	input        pclk,
	input        rst,
	input        level,
	input  [3:0] pattern,

	output [3:0] pattern_leds,
	output [2:0] mode_leds
);

	// Declare local connections here
	wire      cnt_count;
	wire      clr_count;
	wire 	  cnt_index;
	wire 	  clr_index;
	wire 	  w_en;
	wire 	  set_level;
	wire 	  read_Memory;
	wire      index_lt_count;
	wire 	  input_eq_pattern;
	wire 	  is_legal;

	//--------------------------------------------
	// IMPORTANT!!!! If simulating, use this line:
	//--------------------------------------------
	wire uclk = pclk;
	
	// Datapath -- Add port connections
	SimonDatapath dpath(
		.clk           (uclk),
		.level         (level),
		.pattern       (pattern),
		.cnt_count (cnt_count),
		.clr_count (clr_count),
		.cnt_index (cnt_index),
		.clr_index (clr_index),
		.w_en (w_en),
		.set_level (set_level),
		.read_Memory (read_Memory),
		.index_lt_count (index_lt_count),
		.input_eq_pattern (input_eq_pattern),
		.is_legal (is_legal),

		.pattern_leds(pattern_leds)
	);

	// Control -- Add port connections
	SimonControl ctrl(
		.clk           (uclk),
		.rst           (rst),
		
		.cnt_count (cnt_count),
		.clr_count (clr_count),
		.cnt_index (cnt_index),
		.clr_index (clr_index),
		.w_en (w_en),
		.set_level (set_level),
		.read_Memory (read_Memory),
		.index_lt_count (index_lt_count),
		.input_eq_pattern (input_eq_pattern),
		.is_legal (is_legal),
		
		.mode_leds (mode_leds) 
	);

endmodule