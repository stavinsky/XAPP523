`timescale 1ns / 1ps
module manchester_encoder (
    input  wire [7:0]  data_in,
    output wire [15:0] manchester_out
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_encode
            assign manchester_out[15 - 2*i]     = ~data_in[7 - i];
            assign manchester_out[15 - (2*i+1)] = data_in[7 - i];
        end
    endgenerate

endmodule