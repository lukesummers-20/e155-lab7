


module mux3_128(
    input  logic [127:0] a, b, c,
    input  logic [1:0] sel,
    output logic [127:0] y
);
    always_comb
        case(sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = 0;
        endcase

endmodule