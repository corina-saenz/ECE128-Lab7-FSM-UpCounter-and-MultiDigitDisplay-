`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:51:46 PM
// Design Name: 
// Module Name: bin2bcd_12_tb
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


module bin2bcd_12_tb;
    reg        clk, reset, en;
    reg [11:0] bin_in;
    wire [15:0] bcd_out;
    wire        rdy;

    bin2bcd_12 dut (
        .clk(clk), .reset(reset), .en(en),
        .bin_in(bin_in),
        .bcd_out(bcd_out), .rdy(rdy)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // start a conversion helper
    task start_conv(input [11:0] val);
        begin
            @(negedge clk);
            bin_in = val;
            en     = 1'b1;   
            @(posedge clk);  
            @(negedge clk);
            en     = 1'b0;   
        end
    endtask

    task wait_rdy;
        begin
            wait (rdy === 1'b1);
            @(posedge clk); 
        end
    endtask

    // display BCD as four nibbles
    task show_result(input [11:0] val);
        begin
            $display("BIN=%0d -> BCD digits: %0d%0d%0d%0d  (time=%0t)",
                val,
                bcd_out[15:12], bcd_out[11:8], bcd_out[7:4], bcd_out[3:0],
                $time);
        end
    endtask

    initial begin
        // reset
        reset = 1'b1; en = 1'b0; bin_in = 12'd0;
        @(posedge clk); @(posedge clk);
        reset = 1'b0;


        start_conv(12'd0);    wait_rdy; show_result(12'd0);
        start_conv(12'd1);    wait_rdy; show_result(12'd1);
        start_conv(12'd9);    wait_rdy; show_result(12'd9);
        start_conv(12'd10);   wait_rdy; show_result(12'd10);
        start_conv(12'd189);  wait_rdy; show_result(12'd189);
        start_conv(12'd999);  wait_rdy; show_result(12'd999);
        start_conv(12'd4095); wait_rdy; show_result(12'd4095);

        // done
        @(posedge clk);
        $finish;
    end
endmodule
