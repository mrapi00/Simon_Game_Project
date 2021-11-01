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
	// wire localconn1; ...

	//--------------------------------------------
	// IMPORTANT!!!! If simulating, use this line:
	//--------------------------------------------
	wire uclk = pclk;
	wire [1:0] select;
	wire [2:0] mode_leds;
	wire clrcount;
	wire w_en;

	// Datapath Outputs to Control
	wire is_legal;
	wire play_gt_count;
	wire repeat_eq_play;
	wire input_eq_pattern;

	// Datapath -- Add port connections
	SimonDatapath dpath(
		.clk           (uclk),
		.level         (level),
		.pattern       (pattern),
		.rst (rst),
		.select (select),
		.mode_leds (mode_leds),
		//.clrcount (clrcount),
		.w_en (w_en),
		.is_legal (is_legal),
		.play_gt_count (play_gt_count),
		.repeat_eq_play (repeat_eq_play),
		.input_eq_pattern (input_eq_pattern),
		.pattern_leds (pattern_leds)
	);

	// Control -- Add port connections
	SimonControl ctrl(
		.clk           (uclk),
		.rst           (rst),

		.select (select),
		.mode_leds (mode_leds),
		//.clrcount (clrcount),
		.w_en (w_en),
		.is_legal (is_legal),
		.play_gt_count (play_gt_count),
		.repeat_eq_play (repeat_eq_play),
		.input_eq_pattern (input_eq_pattern)
	);

endmodule
