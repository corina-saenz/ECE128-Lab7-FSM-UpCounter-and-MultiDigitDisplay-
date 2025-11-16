`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:30:22 PM
// Design Name: 
// Module Name: moore_1100_tb
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


module moore_1100_tb;
    reg clk, reset, x;
    wire z;

    moore_1100 dut (.clk(clk), .reset(reset), .x(x), .z(z));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        x = 1'b0;
        reset = 1'b1;
        @(posedge clk);
        @(posedge clk);
        reset = 1'b0;

  
        // Sequence: 1 1 0 0  1 1 0 0
        @(negedge clk) x = 1;  @(posedge clk);
        @(negedge clk) x = 1;  @(posedge clk);
        @(negedge clk) x = 0;  @(posedge clk);
        @(negedge clk) x = 0;  @(posedge clk); // z should be 1 here 

        @(negedge clk) x = 1;  @(posedge clk);
        @(negedge clk) x = 1;  @(posedge clk);
        @(negedge clk) x = 0;  @(posedge clk);
        @(negedge clk) x = 0;  @(posedge clk); // z should be 1 again

        @(posedge clk);
        @(posedge clk);
        $finish;
    end
endmodule
