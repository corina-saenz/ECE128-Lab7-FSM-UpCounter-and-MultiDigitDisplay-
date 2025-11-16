`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 01:48:54 PM
// Design Name: 
// Module Name: bin2bcd_12
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


module bin2bcd_12 (
    input  wire        clk,
    input  wire        reset,     
    input  wire        en,        
    input  wire [11:0] bin_in,    // 0..4095
    output reg  [15:0] bcd_out,   // {thousands[15:12], hundreds[11:8], tens[7:4], ones[3:0]}
    output reg         rdy        
);
    localparam IDLE  = 3'd0,
               SETUP = 3'd1,
               ADD   = 3'd2,
               SHIFT = 3'd3,
               DONE  = 3'd4;

    reg [2:0]  PS, NS;

    // 28-bit shift register: [27:12] = 4 BCD nibbles, [11:0] = binary data
    reg [27:0] bcd_data;

    // counters
    reg [3:0] sh_counter;   
    reg [1:0] add_counter;  

    // wires for each BCD digit
    wire [3:0] thousands = bcd_data[27:24];
    wire [3:0] hundreds  = bcd_data[23:20];
    wire [3:0] tens      = bcd_data[19:16];
    wire [3:0] ones      = bcd_data[15:12];

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) PS <= IDLE;
        else       PS <= NS;
    end

    // Next-state logic
    always @(*) begin
        case (PS)
            IDLE : NS = (en) ? SETUP : IDLE;
            SETUP: NS = ADD;
            ADD  : NS = (add_counter == 2'd3) ? SHIFT : ADD;
            SHIFT: NS = (sh_counter == 4'd11) ? DONE : ADD; // after last shift, go DONE
            DONE : NS = IDLE;
            default: NS = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bcd_data    <= 28'd0;
            sh_counter  <= 4'd0;
            add_counter <= 2'd0;
            bcd_out     <= 16'd0;
            rdy         <= 1'b0;
        end else begin
            rdy <= 1'b0; 

            case (PS)
                IDLE: begin
                end

                SETUP: begin
                    bcd_data    <= {16'd0, bin_in};
                    sh_counter  <= 4'd0;
                    add_counter <= 2'd0;
                end

                ADD: begin
                    case (add_counter)
                        2'd0: begin
                            if (ones >= 5)    bcd_data[15:12] <= ones + 4'd3;
                            add_counter <= 2'd1;
                        end
                        2'd1: begin
                            if (tens >= 5)    bcd_data[19:16] <= tens + 4'd3;
                            add_counter <= 2'd2;
                        end
                        2'd2: begin
                            if (hundreds >= 5) bcd_data[23:20] <= hundreds + 4'd3;
                            add_counter <= 2'd3;
                        end
                        2'd3: begin
                            if (thousands >= 5) bcd_data[27:24] <= thousands + 4'd3;
                            add_counter <= 2'd0;
                        end
                    endcase
                end

                SHIFT: begin
                    // shift entire 28-bit register left by 1
                    bcd_data   <= bcd_data << 1;
                    sh_counter <= sh_counter + 1'b1;
                end

                DONE: begin
                    bcd_out <= bcd_data[27:12]; // latch result
                    rdy     <= 1'b1;            // pulse ready
                end
            endcase
        end
    end
endmodule
