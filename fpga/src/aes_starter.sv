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
    aes_controller c(clk, load, plaintext, key, keySel, done, addSel, state, wInit, rCon);
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
    output logic [127:0] cipher,
    output logic roundDone
);
    always_ff @(posedge clk) begin
        if(load) roundDone <= 0;
        else if (roundDone > 2) roundDone <= 0;
        else roundDone <= roundDone + 1;
    end
    logic [127:0] t1, t2, t3, muxOut;
    subBytes sub(clk, cipher, t1);
    shiftRows shift(t1, t2);
    mixcolumns mix(t2, t3);
    mux3_128 m(state, t2, t3, addSel, muxOut);
    addRoundKey add(muxOut, w, cipher);

endmodule

module aes_controller(
    input  logic clk, load, roundDone
    input  logic [127:0] text, key,
    output logic keySel, done,
    output logic [1:0] addSel,
    output logic [127:0] stateInitial,
    output logic [3:0][31:0] wInitial,
    output logic [31:0] rCon
);
    parameter s0 = 5'b00000;
    parameter s1 = 5'b00001;
    parameter s2 = 5'b00010;
    parameter s3 = 5'b00011;
    parameter s4 = 5'b00100;
    parameter s5 = 5'b00101;
    parameter s6 = 5'b00110;
    parameter s7 = 5'b00111;
    parameter s8 = 5'b01000;
    parameter s9 = 5'b01001;
    parameter s10 = 5'b01010;
    parameter s11 = 5'b01011;

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
            //r0
            s1: begin 
                    if(roundDone) next = s2;
                    else next = s1;
                end
            r//1
            s2: begin 
                    if(roundDone) next = s3;
                    else next = s2;
                end
            //r2
            s3: begin 
                    if(roundDone) next = s4;
                    else next = s3;
                end
            //r3
            s4: begin 
                    if(roundDone) next = s5;
                    else next = s4;
                end
            //r4
            s5: begin 
                    if(roundDone) next = s6;
                    else next = s5;
                end
            //r5
            s6: begin 
                    if(roundDone) next = s7;
                    else next = s6;
                end
            //r6
            s7: begin 
                    if(roundDone) next = s8;
                    else next = s7;
                end
            //r7
            s8: begin 
                    if(roundDone) next = s9;
                    else next = s8;
                end
            //r8
            s9: begin 
                    if(roundDone) next = s10;
                    else next = s9;
                end
            //r9
            s10: begin 
                    if(roundDone) next = s11;
                    else next = s10;
                end
            //r10
            s11: begin 
                    if(roundDone) next = s0;
                    else next = s11;
                end

            //r0 waits
            s12: next = s13;
            s13: next = s2;
            //r1 waits
            s14: next = s15;
            s15: next = s3;
            //r2 waits
            s16: next = s17;
            s17: next = s4;
            //r3 waits
            s18: next = s19;
            s19: next = s5;
            //r4 waits
            s20: next = s21;
            s21: next = s6;
            //r5 waits
            s22: next = s23;
            s23: next = s7;
            //r6 waits
            s24: next = s25;
            s25: next = s8;
            //r7 waits
            s26: next = s27;
            s27: next = s9;
            //r8 waits
            s28: next = s29;
            s29: next = s10;
            //r9 waits
            s30: next = s31;
            s31: next = s11;
            //r10 waits
            s32: next = s33;
            s33: next = s0;
            default: next = s0;
        endcase
    
    //output logic
    assign done = ((state == s11) & (roundDone));
    assign keySel = (state == s1);
    assign stateInitial = text;
    assign wInitial[0] = key[127:96];
    assign wInitial[1] = key[95:64];
    assign wInitial[2] = key[63:32];
    assign wInitial[3] = key[31:0];
    assign addSel[0] = (state == s11);
    assign addSel[1] = !((state == s1) | (state == s11));
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








