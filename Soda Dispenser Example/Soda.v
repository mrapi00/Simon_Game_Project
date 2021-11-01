//==============================================================================
// Soda Module for Soda Dispenser Project
//==============================================================================

`include "SodaControl.v"
`include "SodaDatapath.v"

module Soda(
    input clk,
    input rst,
    input c,
    input [7:0] s,
    input [7:0] a,
    output d
);

    // Declare local connections here
    wire tot_ld;
    wire tot_clr;
    wire tot_lt_s;

    // Datapath -- Add port connections
    SodaDatapath dpath(
        .clk (clk),
        .s (s),
        .a (a),
        .tot_ld (tot_ld),
        .tot_clr (tot_clr), 
        .tot_lt_s (tot_lt_s)
    );

    // Control -- Add port connections
    SodaControl ctrl(
        .clk (clk),          
        .rst (rst), 
        .c (c),     
        .tot_lt_s (tot_lt_s), 
        .tot_ld (tot_ld), 
        .tot_clr (tot_clr), 
        .d (d)
    );

endmodule