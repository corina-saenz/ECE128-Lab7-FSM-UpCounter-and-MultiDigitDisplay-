`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:36:47 PM
// Design Name: 
// Module Name: mealy_1101_tb
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


module mealy_1101_tb;
    reg clk, reset, x;
    wire z;

    mealy_1101 dut (.clk(clk), .reset(reset), .x(x), .z(z));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task apply_bit;
    input b;    // 1-bit input (Verilog-2001)

        begin
            @(negedge clk); x = b;
            @(posedge clk); 
        end
    endtask

    initial begin
        x = 1'b0;
        reset = 1'b1;
        @(posedge clk);
        @(posedge clk);
        reset = 1'b0;

        // 1 1 0 1  1 0 1  0 1 1 0 1
        // Matches expected at the 4th bit, 7th bit, and last bit shown
        apply_bit(1);  // 1
        apply_bit(1);  // 11
        apply_bit(0);  // 110
        apply_bit(1);  // 1101 -> z=1 

        apply_bit(1);  // suffix "1"
        apply_bit(0);  // "10"
        apply_bit(1);  // "...1101" again -> z=1

        apply_bit(0);  // reset to ""
        apply_bit(1);  // 1
        apply_bit(1);  // 11
        apply_bit(0);  // 110
        apply_bit(1);  // 1101 -> z=1

        @(posedge clk);
        @(posedge clk);
        $finish;
    end
endmodule
