module mux4_nibble(
    input  wire [15:0] bcd,
    input  wire [1:0]  sel,
    output reg  [3:0]  nib
);
    always @* begin
        case (sel)
            2'd0: nib = bcd[3:0];     // ones
            2'd1: nib = bcd[7:4];     // tens
            2'd2: nib = bcd[11:8];    // hundreds
            2'd3: nib = bcd[15:12];   // thousands
        endcase
    end
endmodule