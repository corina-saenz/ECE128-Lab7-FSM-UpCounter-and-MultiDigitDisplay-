`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:35:06 PM
// Design Name: 
// Module Name: mealy_1101
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


module mealy_1101 (
    input  wire clk,
    input  wire reset,  
    input  wire x,     
    output reg  z       
);
    parameter S0 = 2'd0; // ""
    parameter S1 = 2'd1; // "1"
    parameter S2 = 2'd2; // "11"
    parameter S3 = 2'd3; // "110"

    reg [1:0] PS, NS;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PS <= S0;
        else
            PS <= NS;
    end

    always @(*) begin
        case (PS)
            S0: NS = x ? S1 : S0;       // "" + 1 -> "1"
            S1: NS = x ? S2 : S0;       // "1" + 1 -> "11"; "1"+0 -> ""
            S2: NS = x ? S2 : S3;       // "11"+1 -> stay "11"; "11"+0 -> "110"
            S3: NS = x ? S1 : S0;       // "110"+1 -> MATCH, next "1"; "110"+0 -> ""
            default: NS = S0;
        endcase
    end

    always @(*) begin
        case (PS)
            S3:     z = (x == 1'b1);    
            default z = 1'b0;
        endcase
    end
endmodule
