module refresh_gen(
    input  wire       clk,        // 100 MHz
    input  wire       rst,        // sync reset, active-high
    output reg  [1:0] sel,        // 0..3
    output reg  [3:0] an          // active-LOW anodes
);
    localparam integer DIV = 25_000; 
    reg [14:0] cnt = 0;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
            sel <= 0;
            an  <= 4'b1111;       // all off
        end else begin
            if (cnt == DIV-1) begin
                // end of digit time slice
                cnt <= 0;
                an  <= 4'b1111;   // 1) blank all digits for one cycle
                sel <= sel + 1'b1;
            end else begin
                cnt <= cnt + 1'b1;

                if (cnt == 1) begin
                    case (sel)
                        2'd0: an <= 4'b1110; // AN0 (rightmost)
                        2'd1: an <= 4'b1101; // AN1
                        2'd2: an <= 4'b1011; // AN2
                        2'd3: an <= 4'b0111; // AN3 (leftmost)
                    endcase
                end
            end
        end
    end
endmodule
