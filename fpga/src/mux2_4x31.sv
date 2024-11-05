


module mux2_4x31(
    input  logic [3:0][31:0] a, b,
    input  logic sel,
    output logic [3:0][31:0] y
);
    always_comb
        case(sel)
            1'b0: y = a;
            1'b1: y = b;
            default: y = 0;
        endcase

endmodule