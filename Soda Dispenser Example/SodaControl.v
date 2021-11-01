//==============================================================================
// Control Module for Soda Dispenser Project
//==============================================================================

module SodaControl(
	// External Inputs
    input clk,          // clock
    input rst,          // reset
    input c,            // whether a coin is detected

	// Datapath Inputs
    input tot_lt_s,     // indicates whether total is less than soda price

	// Datapath Control Outputs
    output reg tot_ld,  // signal to load tot register
    output reg tot_clr, // signal to clear tot register

	// External Outputs
    output reg d        // dispense signal

);

    // Declare Local Vars Here
    reg [1:0] state;
	reg [1:0] next_state;

    // Declare State Names Here
	localparam STATE_INIT = 2'b00; // Initial state
	localparam STATE_WAIT = 2'b01; // Wait state
	localparam STATE_ADD = 2'b10; // Add state
	localparam STATE_DISP = 2'b11; // Dispense state

    // Output Combinational Logic
	always @( * ) begin
        // Set defaults
        d = 0;
        tot_ld = 0;
        tot_clr = 0;

        if (state == STATE_INIT) begin
            tot_clr = 1; // signal to clear the tot register
		end
		if (state == STATE_ADD) begin
            tot_ld = 1; // signal to load the result of addition into tot register
		end
		if (state == STATE_DISP) begin
			d = 1; // set dispense to 1
		end
	end

    // Next State Combinational Logic
	always @( * ) begin
		next_state = state;

        case (state)
            STATE_INIT: begin
                next_state = STATE_WAIT; // If in INIT, move to WAIT state
            end
            STATE_WAIT: begin
                if (c == 1) begin
                    next_state = STATE_ADD;  // If there's a coin input in WAIT state, move to ADD state
                end
                else if (tot_lt_s == 1) begin
                    next_state = STATE_WAIT; // If there's no coin input in WAIT, and tot is less than s, stay in WAIT
                end
                else if (tot_lt_s == 0) begin
                    next_state = STATE_DISP; // If there's no coin input in WAIT, and tot is not less than s, go to DISP
                end
            end
            STATE_ADD: begin
                next_state = STATE_WAIT; // If in ADD, move to WAIT state
            end
            STATE_DISP: begin
                next_state = STATE_INIT; // If in DISP, move to INIT state
            end
        endcase
    end

    // State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_INIT; // start in INIT state
		end
		else begin
			state <= next_state; // move to next state
		end
	end

endmodule
