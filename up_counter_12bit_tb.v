`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:40:52 PM
// Design Name: 
// Module Name: up_counter_12bit_tb
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


module up_counter_12bit_tb;
    reg clk, reset;
    wire [11:0] count;

    up_counter_12bit dut (.clk(clk), .reset(reset), .count(count));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        repeat(4100) @(posedge clk);

        $finish;
    end
endmodule
