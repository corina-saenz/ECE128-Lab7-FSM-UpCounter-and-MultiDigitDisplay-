`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:26:20 PM
// Design Name: 
// Module Name: moore_1100
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


module moore_1100 (
    input  wire clk,
    input  wire reset,  
    input  wire x,     
    output reg  z       
);
    parameter S0 = 3'd0; // no match
    parameter S1 = 3'd1; // saw "1"
    parameter S2 = 3'd2; // saw "11"
    parameter S3 = 3'd3; // saw "110"
    parameter S4 = 3'd4; // saw "1100" (match)

    reg [2:0] PS, NS;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PS <= S0;
        else
            PS <= NS;
    end

    always @(*) begin
        case (PS)
            S0: NS = (x) ? S1 : S0;    // "" + 1 -> "1"
            S1: NS = (x) ? S2 : S0;    // "1" + 1 -> "11"; "1"+0 -> ""
            S2: NS = (x) ? S2 : S3;    // "11"+1 -> stay "11"; "11"+0 -> "110"
            S3: NS = (x) ? S1 : S4;    // "110"+1 -> "1"; "110"+0 -> "1100"
            S4: NS = (x) ? S1 : S0;    // after match, re-sync prefix
            default: NS = S0;
        endcase
    end

    always @(*) begin
        case (PS)
            S4:     z = 1'b1;
            default z = 1'b0;
        endcase
    end
endmodule
