`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 02:06:39 PM
// Design Name: 
// Module Name: multiseg_driver
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

module multiseg_driver(
    input  wire        clk,   // 100 MHz
    input  wire        rst,   // sync reset, active-high
    input  wire [15:0] bcd,   // 4 BCD digits
    output wire [3:0]  an,    // anodes (active-LOW)
    output wire [6:0]  seg,   // a..g (active-LOW)
    output wire        dp     // decimal point (active-LOW)
);
    wire [1:0] sel;
    wire [3:0] nib;
    wire [6:0] seg_next;
    reg  [6:0] seg_r;

    refresh_gen   Uref (.clk(clk), .rst(rst), .sel(sel), .an(an));
    mux4_nibble   Umux (.bcd(bcd), .sel(sel), .nib(nib));
    bcd7seg       Udec (.din(nib), .seg(seg_next));

    always @(posedge clk) begin
        seg_r <= seg_next;
    end

    assign seg = seg_r;
    assign dp  = 1'b1; // OFF
endmodule

