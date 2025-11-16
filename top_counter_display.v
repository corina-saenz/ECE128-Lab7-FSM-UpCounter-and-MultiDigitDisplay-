`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 02:10:50 PM
// Design Name: 
// Module Name: top_counter_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_counter_display (
    input  wire        clk,       // 100 MHz
    output wire [3:0]  an,        // anodes (active-LOW)
    output wire [6:0]  seg,       // segments a..g (active-LOW)
    output wire        dp         // decimal point (active-LOW)
);

    // ~50 Hz tick 
    localparam integer DIV_BITS = 21;  // 100e6 / 2^21 ? 47.7 Hz
    reg [DIV_BITS-1:0] divcnt = 0;
    always @(posedge clk)
        divcnt <= divcnt + 1'b1;
    wire slow_clk = divcnt[DIV_BITS-1];

    // 12-bit up counter (0..4095)
    wire [11:0] count_val;
    up_counter_12bit u_cnt (
        .clk   (slow_clk),
        .reset (1'b0),      
        .count (count_val)
    );

    // Binary(12) -> BCD(16) 
    reg slow_clk_q = 1'b0;
    always @(posedge clk)
        slow_clk_q <= slow_clk;

    wire        en_conv = (slow_clk & ~slow_clk_q);
    wire [15:0] bcd_bus;
    wire        bcd_rdy;

    bin2bcd_12 u_b2b (
        .clk     (clk),
        .reset   (1'b0),
        .en      (en_conv),
        .bin_in  (count_val),
        .bcd_out (bcd_bus),
        .rdy     (bcd_rdy)
    );

    multiseg_driver u_disp (
        .clk (clk),
        .rst (1'b0),
        .bcd (bcd_bus),
        .an  (an),
        .seg (seg),
        .dp  (dp)
    );

endmodule
