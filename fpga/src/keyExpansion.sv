//////////
// rotword
// 0 cycle
/////////
module rotWord(
  input  logic [31:0] word,
  output logic [31:0] rot
);
  assign rot[31:24] = word[23:16];
  assign rot[23:16] = word[15:8];
  assign rot[15:8] = word[7:0];
  assign rot[7:0] = word[31:24];

endmodule

/////////
// subword
// one cycle
/////////
module subWord(
    input  logic clk,
    input  logic [31:0] word,
    output logic [31:0] sub
);
  sbox_sync b0(word[31:24], clk, sub[31:24]);
  sbox_sync b1(word[23:16], clk, sub[23:16]);
  sbox_sync b2(word[15:8], clk, sub[15:8]);
  sbox_sync b3(word[7:0], clk, sub[7:0]);

endmodule

module oneKeyExpansion(
    input  logic clk,
    input  logic [3:0][31:0] oldW,
    input  logic [31:0] rCon,
    output logic [3:0][31:0] w
);
  logic[31:0] wRot, wSub;
  rotWord(oldW[3], wRot);
  subWord(clk, wRot, wSub);
  assign w[0] = oldW[0] ^ (rCon ^ wSub);
  assign w[1] = oldW[1] ^ w[0];
  assign w[2] = oldW[2] ^ w[1];
  assign w[3] = oldW[3] ^ w[2];

endmodule

///////////////////////////////
// key expansion
// one cycle
///////////////////////////////
module keyExpansion(
    input  logic clk,
    input  logic [127:0] key,
    output logic [43:0][31:0] w
);
  assign w[0] = key[127:96];
  assign w[1] = key[95:64];
  assign w[2] = key[63:32];
  assign w[3] = key[31:0];

  logic [31:0] w4rot;
  logic [31:0] w4sub;
  rotWord r4(w[3], w4rot);
  subWord s4(clk, w4rot, w4sub);
  assign w[4] = w[0] ^ (32'h01000000 ^ w4sub);
  assign w[5] = w[4] ^ w[1];
  assign w[6] = w[5] ^ w[2];
  assign w[7] = w[6] ^ w[3];

  logic [31:0] w8rot;
  logic [31:0] w8sub;
  rotWord r8(w[7], w8rot);
  subWord s8(clk, w8rot, w8sub);
  assign w[8] = w[4] ^ (32'h02000000 ^ w8sub);
  assign w[9] = w[8] ^ w[5];
  assign w[10] = w[9] ^ w[6];
  assign w[11] = w[10] ^ w[7];

  logic [31:0] w12rot;
  logic [31:0] w12sub;
  rotWord r12(w[11], w12rot);
  subWord s12(clk, w12rot, w12sub);
  assign w[12] = w[8] ^ (32'h04000000 ^ w12sub);
  assign w[13] = w[12] ^ w[9];
  assign w[14] = w[13] ^ w[10];
  assign w[15] = w[14] ^ w[11];

  logic [31:0] w16rot;
  logic [31:0] w16sub;
  rotWord r16(w[15], w16rot);
  subWord s16(clk, w16rot, w16sub);
  assign w[16] = w[12] ^ (32'h08000000 ^ w16sub);
  assign w[17] = w[16] ^ w[13];
  assign w[18] = w[17] ^ w[14];
  assign w[19] = w[18] ^ w[15];

  logic [31:0] w20rot;
  logic [31:0] w20sub;
  rotWord r20(w[19], w20rot);
  subWord s20(clk, w20rot, w20sub);
  assign w[20] = w[16] ^ (32'h10000000 ^ w20sub);
  assign w[21] = w[20] ^ w[17];
  assign w[22] = w[21] ^ w[18];
  assign w[23] = w[22] ^ w[19];

  logic [31:0] w24rot;
  logic [31:0] w24sub;
  rotWord r24(w[23], w24rot);
  subWord s24(clk, w24rot, w24sub);
  assign w[24] = w[20] ^ (32'h20000000 ^ w24sub);
  assign w[25] = w[24] ^ w[21];
  assign w[26] = w[25] ^ w[22];
  assign w[27] = w[26] ^ w[23];

  logic [31:0] w28rot;
  logic [31:0] w28sub;
  rotWord r28(w[27], w28rot);
  subWord s28(clk, w28rot, w28sub);
  assign w[28] = w[24] ^ (32'h40000000 ^ w28sub);
  assign w[29] = w[28] ^ w[25];
  assign w[30] = w[29] ^ w[26];
  assign w[31] = w[30] ^ w[27];

  logic [31:0] w32rot;
  logic [31:0] w32sub;
  rotWord r32(w[31], w32rot);
  subWord s32(clk, w32rot, w32sub);
  assign w[32] = w[28] ^ (32'h80000000 ^ w32sub);
  assign w[33] = w[32] ^ w[29];
  assign w[34] = w[33] ^ w[30];
  assign w[35] = w[34] ^ w[31];

  logic [31:0] w36rot;
  logic [31:0] w36sub;
  rotWord r36(w[35], w36rot);
  subWord s(clk, w36rot, w36sub);
  assign w[36] = w[32] ^ (32'h1b000000 ^ w36sub);
  assign w[37] = w[36] ^ w[33];
  assign w[38] = w[37] ^ w[34];
  assign w[39] = w[38] ^ w[35];

  logic [31:0] w40rot;
  logic [31:0] w40sub;
  rotWord r40(w[39], w40rot);
  subWord s40(clk, w40rot, w40sub);
  assign w[40] = w[36] ^ (32'h36000000 ^ w40sub);
  assign w[41] = w[40] ^ w[37];
  assign w[42] = w[41] ^ w[38];
  assign w[43] = w[42] ^ w[39];

endmodule