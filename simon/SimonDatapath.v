//==============================================================================
// Datapath for Simon Project
//==============================================================================

`include "Memory.v"

module SimonDatapath(
	// External Inputs
	input        clk,           // Clock
	input        level,         // Switch for setting level
	input  [3:0] pattern,       // Switches for creating pattern

	// Inputs from Controller
	input     cnt_count,
	input     clr_count,
	input 	  cnt_index,
	input 	  clr_index,
	input 	  w_en,
	input 	  set_level,
	input 	  read_Memory,

	// Outputs to Controller
	output  reg index_lt_count,
	output 	reg input_eq_pattern,
	output 	reg is_legal,

	// External Outputs
	output reg [3:0] pattern_leds   // LED outputs for pattern
);

	// Declare Local Vars Here
	reg [5:0] count = 6'b000000;
	reg [5:0] index = 6'b000000;
	wire [3:0] r_data;
	reg level_for_game;

	//----------------------------------------------------------------------
	// Internal Logic -- Manipulate Registers, ALU's, Memories Local to
	// the Datapath
	//----------------------------------------------------------------------

	always @(posedge clk) begin
		// Sequential Internal Logic Here
		if (clr_count) begin
		  	count <= 0;
			pattern_leds <= 4'b0000;
		end

		if (cnt_count) count <= count+1;

		if (clr_index) index <= 0;

		if (cnt_index) index <= index + 1;

		if (set_level) level_for_game <= level;
		
	end

	// 64-entry 4-bit memory (from Memory.v) -- Fill in Ports!
	Memory mem(
		.clk     (clk),
		.rst     (1'b0),
		.r_addr  (index),
		.w_addr  (count),
		.w_data  (pattern),
		.w_en    (w_en),
		.r_data  (r_data)
	);

	//----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------
	always @( * ) begin
		index_lt_count = (index < count); 
		input_eq_pattern = (r_data == pattern); 

		if (read_Memory == 1)
			pattern_leds = r_data;
		else pattern_leds = pattern;

		if (level_for_game || (pattern == 4'b0001) || (pattern == 4'b0010) || (pattern == 4'b0100) || (pattern == 4'b1000))
			is_legal = 1;
		else is_legal = 0;
	end
	
endmodule