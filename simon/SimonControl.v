//==============================================================================
// Control Module for Simon Project
//==============================================================================

module SimonControl(
	// External Inputs
	input        clk,           // Clock
	input        rst,           // Reset
	// Datapath Inputs
	input is_legal,
	input play_gt_count,
	input repeat_eq_play,
	input input_eq_pattern,

	// Datapath Control Outputs
	output reg [1:0] select,
	output reg clrcount,
	output reg w_en,

	// External Outputs
	output reg [2:0] mode_leds
);

	// Declare Local Vars Here
	reg [1:0] state;
	reg [1:0] next_state;

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// Declare State Names Here
	localparam INPUT = 2'd0;
	localparam PLAYBACK = 2'd1;
	localparam REPEAT = 2'd2;
	localparam DONE = 2'd3;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
		w_en = 0;
		
		// Write your output logic here
		if (state == INPUT) begin
			mode_leds = 3'b001;
			w_en = 1;
		end
		if (state == PLAYBACK) begin
			mode_leds = 3'b010;
			select = 2'b00;
		end
		if (state == REPEAT) begin
			mode_leds = 3'b100;
			select = 2'b01;
		end
		if (state == DONE) begin
			mode_leds = 3'b111;
			select = 2'b10;
		end
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;
		// Write your Next State Logic Here
		if (state == INPUT) begin
			if (is_legal) next_state = PLAYBACK;
			else next_state = INPUT;
		end
		else if (state == PLAYBACK) begin
			if (play_gt_count) next_state = REPEAT;
			else next_state = PLAYBACK;
		end 
		else if (state == REPEAT) begin
			if (repeat_eq_play && input_eq_pattern) next_state = INPUT;
			if (!repeat_eq_play && input_eq_pattern) next_state = REPEAT;
			if (!input_eq_pattern) next_state = DONE;
		end
		else if (state == DONE) 
			next_state = DONE;
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			clrcount = 1;
			state = INPUT;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end
endmodule
