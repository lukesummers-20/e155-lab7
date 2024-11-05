/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule



/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

    // TODO: Your code goes here
    logic [3:0][31:0] w, wInit, wMuxOut, expanIn, expanOut;
    logic [31:0] rCon;
    logic keySel;
    logic [1:0] addSel;
    logic [127:0] state;
    aes_controller c(clk, load, text, key, keySel, done, addSel, state, wInit, rCon);
    aes_datapath d(clk, wMuxOut, state, addSel, cyphertext);
    oneKeyExpansion e(clk, expanIn, rCon, expanOut);
    mux2_4x31 mEx(expanOut, wInit, keySel, expanIn);
    mux2_4x31 mW(expanOut, wInit, keySel, wMuxOut);

endmodule

module aes_datapath(
    input  logic clk,
    input  logic [3:0][31:0] w,
    input  logic [127:0] state,
    input  logic [1:0] addSel,
    output logic [127:0] cipher
);
    logic [127:0] t1, t2, t3, muxOut;
    subBytes sub(clk, cipher, t1);
    shiftRows shift(t1, t2);
    mixcolumns mix(t2, t3);
    mux3_128 m(state, t2, t3, addSel, muxOut);
    addRoundKey add(muxOut, w, cipher);

endmodule

module aes_controller(
    input  logic clk, load,
    input  logic [127:0] text, key,
    output logic keySel, done,
    output logic [1:0] addSel,
    output logic [127:0] stateInitial,
    output logic [3:0][31:0] wInitial,
    output logic [31:0] rCon
);
    parameter s0 = 4'b0000;
    parameter s1 = 4'b0001;
    parameter s2 = 4'b0010;
    parameter s3 = 4'b0011;
    parameter s4 = 4'b0100;
    parameter s5 = 4'b0101;
    parameter s6 = 4'b0110;
    parameter s7 = 4'b0111;
    parameter s8 = 4'b1000;
    parameter s9 = 4'b1001;
    parameter s10 = 4'b1010;
    parameter s11 = 4'b1011;

    logic [3:0] state, next;
    //state reg
    always_ff @(posedge clk) begin
        state <= next;
    end

    //next state logic
    always_comb
        case(state)
            s0: begin 
                    if(load) next = s1;
                    else next = s0;
                end
            s1: next = s2;
            s2: next = s3;
            s3: next = s4;
            s4: next = s5;
            s5: next = s6;
            s6: next = s7;
            s7: next = s8;
            s8: next = s9;
            s9: next = s10;
            s10: next = s11;
            s11: next = s0;
            default: next = s0;
        endcase
    
    //output logic
    assign done = (state == s11);
    assign keySel = (state == s1);
    assign stateInitial = text;
    assign wInitial[0] = key[127:96];
    assign wInitial[1] = key[95:64];
    assign wInitial[2] = key[63:32];
    assign wInitial[3] = key[31:0];
    assign addSel[0] = (state == s11);
    assign addSel[1] = !((state == s1) | (state == state == s11));
    always_comb
        case(state)
            s1: rCon = 32'h01000000;
            s2: rCon = 32'h02000000;
            s3: rCon = 32'h04000000;
            s4: rCon = 32'h08000000;
            s5: rCon = 32'h10000000;
            s6: rCon = 32'h20000000;
            s7: rCon = 32'h40000000;
            s8: rCon = 32'h80000000;
            s9: rCon = 32'h1b000000;
            s10: rCon = 32'h36000000;
            default: rCon = 32'h00000000;
        endcase

endmodule








