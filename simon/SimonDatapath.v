//==============================================================================
// Datapath for Simon Project
//==============================================================================

`include "Memory.v"

module SimonDatapath(
	// External Inputs
	input        clk,           // Clock
	input        level,         // Switch for setting level
	input  [3:0] pattern,       // Switches for creating pattern

	// Datapath Control Signals
	input [1:0] select,
	input [2:0] mode_leds,
	input clrcount,
	input w_en,

	// Datapath Outputs to Control
	output reg is_legal,
	output reg play_gt_count,
	output reg repeat_eq_play,
	output reg input_eq_pattern,

	// External Outputs
	output reg [3:0] pattern_leds   // LED outputs for pattern
	
);

	// Declare Local Vars Here
	reg levelStore;
	reg levelMaintain = 0;
	reg [5:0] mux_output;
	reg [5:0] count;
	// reg [5:0] w_addr;
	wire [3:0] r_data;
	reg [5:0] r_addr;
	reg [5:0] playback;
	reg [5:0] repeatC;
	reg [5:0] done;
	
	//----------------------------------------------------------------------
	// Internal Logic -- Manipulate Registers, ALU's, Memories Local to
	// the Datapath
	//----------------------------------------------------------------------

	always @(posedge clk) begin
		/* if (level == 1) 
			is_legal = 1; */
		/* mux feeding into r_addr */
		case (select)
			2'b00: mux_output = playback;
			2'b01: mux_output = repeatC;
			2'b10: mux_output = done;
			default: mux_output = 0;
		endcase

		// reset count on reset
		if (clrcount) begin
			count = 6'b000000;
			pattern_leds = 4'b0000;
		end 
		
		// INPUT state variable setting
		if (mode_leds == 3'b001) begin
			playback = 6'b000000;
			//pattern_leds = pattern;
		end
		// PLAYBACK state variable setting
		else if (mode_leds == 3'b010) begin
			if (playback == 6'b000000) 
				count = count + 1;
			r_addr = playback;
			//pattern_leds = r_data;
			
			repeatC = 6'b000000;
			playback = playback + 1;
		end
		// REPEAT state variable setting
		else if (mode_leds == 3'b100) begin
			r_addr = repeatC;
			$display("R_ADDR");
			$display(r_addr);
			$display("playback:");
			$display(playback);
			repeatC = repeatC + 1;
			done = 6'b000000;
			//pattern_leds <= pattern;
		end
		// DONE state variable setting
		else if (mode_leds == 3'b111) begin
			done <= done + 1;
			r_addr <= done;
			//pattern_leds <= r_data;
		end
		
	end

	// 64-entry 4-bit memory (from Memory.v) -- Fill in Ports!
	Memory mem(
		.clk     (clk),
		.rst     (1'b0),
		.r_addr  (mux_output),
		.w_addr  (count),
		.w_data  (pattern),
		.w_en    (w_en),
		.r_data  (r_data)
	);

	//----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------

	always @( * ) begin
		if (!levelMaintain) begin
			levelStore = level;
			levelMaintain = 1;
		end
		// check legality
		if (levelStore == 1) 
			is_legal = 1;
		else if (pattern != 4'b0001 && pattern != 4'b0010 && pattern != 4'b0100 && pattern != 4'b1000) 
			is_legal = 0;
		else is_legal = 1;
		
		input_eq_pattern = (pattern == r_data);
		repeat_eq_play = (playback > repeatC);
		play_gt_count = (playback == count); 

		if (mode_leds == 3'b001 || mode_leds == 3'b100) pattern_leds = pattern;
		if (mode_leds == 3'b010 || mode_leds == 3'b111) pattern_leds = r_data;
	end

endmodule
