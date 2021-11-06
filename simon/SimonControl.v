//==============================================================================
// Control Module for Simon Project
//==============================================================================

module SimonControl(
	// External Inputs
	input        clk,           // Clock
	input        rst,           // Reset

	// Datapath Inputs
	input     index_lt_count,
	input 	  input_eq_pattern,
	input 	  is_legal,

	// Datapath Control Outputs
	output    reg cnt_count,
	output	  reg clr_count,
	output	  reg cnt_index,
	output 	  reg clr_index,
	output 	  reg read_Memory,
	output 	  reg w_en,
	output 	  reg set_level,
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
		//defaults
		w_en = 0;
		clr_count = rst;
		cnt_count = 0;
		clr_index = rst;
		cnt_index = 0;
		set_level = rst;
		
		if (state == INPUT) begin
			mode_leds = LED_MODE_INPUT;
			w_en = is_legal;
			clr_index = is_legal;
			read_Memory = 0;
		end
		else if (state == PLAYBACK) begin
			mode_leds = LED_MODE_PLAYBACK;
			cnt_index = index_lt_count;
			clr_index = !index_lt_count;
			read_Memory = 1;
		end
		else if (state == REPEAT) begin
			mode_leds = LED_MODE_REPEAT;
			cnt_index = index_lt_count & input_eq_pattern;
			clr_index = !input_eq_pattern;
			cnt_count = !index_lt_count & input_eq_pattern;
			read_Memory = 0;
		end
		else if (state == DONE) begin
			mode_leds = LED_MODE_DONE;
			cnt_index = index_lt_count;
			clr_index = !index_lt_count;
			read_Memory = 1;
		end

	end

	// Next State Combinational Logic
	always @( * ) begin
		if (state == INPUT) begin
			if (!is_legal) next_state = INPUT;
			else next_state = PLAYBACK;
		end
		else if (state == PLAYBACK) begin
			if (index_lt_count) next_state = PLAYBACK;
			else next_state = REPEAT;
		end
		else if (state == REPEAT) begin
			if (index_lt_count & input_eq_pattern) next_state = REPEAT;
			else if (!index_lt_count & input_eq_pattern) next_state = INPUT;
			else next_state = DONE;
		end
		else if (state == DONE) begin
			next_state = DONE;
		end
		
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= INPUT;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end

endmodule