//==============================================================================
// Datapath for Soda Dispenser Project
//==============================================================================

 module SodaDatapath(
     // External Inputs
     input clk,				// clock
     input [7:0] s,         // soda price
     input [7:0] a,         // inserted coin's value

     // Datapath Control Signals
     input tot_ld,          // signal to load tot register
     input tot_clr,         // signal to clear tot register

     // Datapath Outputs to Controller
     output reg tot_lt_s    // indicates whether total is less than soda price
 );

    // Declare Local Vars Here
    reg [8:0] tot; // store the total

    //----------------------------------------------------------------------
	// Internal Logic
	//----------------------------------------------------------------------
    always @(posedge clk) begin
        // if there is a clear signal, clear tot
        if (tot_clr == 1) begin 
            tot <= 9'd0;
        end
        // if there is a load signal, load tot 
        else if (tot_ld == 1) begin
            tot <= tot + a; 
        end
    end

    //----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------
	always @( * ) begin
        // set output to whether tot is less than s
        tot_lt_s = (tot < s);
	end
endmodule

